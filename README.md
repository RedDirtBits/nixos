# Introduction

Adventures in learning [NixOS](https://nixos.org/).

## WARNING

I am a _verbose_ person.  I won't apologize for that, but I will at least make it known up front.  It's just how I was brought up, how I started in technology and how, in general, the world around me worked at those more impressionable years.  Unfortunately it is not something that is compatible with _today's_ world of much shorter attention spans.

Further exasperating the issue is that I tend to write documents, especially those of a more instructional nature, with zero assumptions of the readers understanding of the material.  It irks me, probably too much, to go to a source of documentation as a beginning learner of whatever material or task that is before me and find that the genius minds behind the subject write the documentation in a manner that assumes I have a similar genius mind.  In a metaphorical sense, they fail to reach down to me and help me climb the learning curve.

I get it though.  Documentation is time consuming, not all that fun and, well, you have to start somewhere.  Though, I wish it was more acceptable to include a different version of the documentation titled ["Explaining _x_ As If You Were A 5 Year Old"](https://dev.to/ben/explain-tcp-like-im-five).  Probably overkill, but you get the point.

That's where I tend to annoy people.  My verbosity coupled with writing documentation in a run playbook type fashion.  That is, in a step-by-step manner with the only assumption being you know nothing.  In my world, I'd rather provide that level of detail and let the reader connect the dots, discover the patterns of how things intertwine, build up and ideally get that moment of "Oh!  That's why that is done that way" rather than assume they know those little details and nuances and it leave them unable to extrapolate and adapt to a use case that may be just slightly enough different to inject some confusion.

There you have it.  That's your warning up front.

# Goals

I don't have a great deal of experience with NixOS but what little I have has left me with a love of all it can do.  The idea of being able to build out a system exactly how you want it and make that a repeatable process across machines is something so appealing to me that it has driven me to try and navigate the more advanced nature of NixOS.

Despite having used Linux for a number of years now, NixOS has made me realize how little I know and how much goes on behind the scenes when you download a live USB installer and set up a new computer.  It has been a rather humbling experience.  A good one, but humbling nonetheless.

To that end, the goal is to use the [minimal ISO](https://nixos.org/download.html#nixos-iso) installer and replicate, within reason, my current set up.  Now, I say _within reason_ because my journey with NixOS so far has led me to try out other desktop environments, window managers, that I otherwise would not have simply because I, as so many others, was used to what was provided as a Linux desktop OS by the various distros available.

One of the things I discovered in this process (and had never tried before) was that I really like window managers like i3, dwm, etc.  I have always just lived with the desktop environment that I downloaded as part of the Linux installer and never really questioned doing things any other way.

As such, the goal is, as mentioned, to replicate my current set up potentially with some tweaks.  But for those that come across this and want a normal desktop environment but also take advantage of all that NixOS has, that will be possible as well.  However, there will be some added complexity from using the minimal ISO.  For me, there is real value in understanding that process.  If you want to skip that and just get to a usable desktop but still use NixOS, then perhaps the [graphical installer](https://nixos.org/download.html#nixos-iso) will be a better path where you can chose from a number of popular desktop environments.

# Getting Started

First, another quick **WARNING**.  This process will wipe your hard drive.  We are going to wipe out the partitions on the hard drive, create new ones and format them.  There are already a metric crap ton of articles and videos on how to download an ISO image and write/burn it to a USB drive so I won't cover that here.  This process will start from the point of you having booted from the USB using the NixOS minimal ISO and are sitting at the command prompt.

We will be starting from scratch.  No GUI guided installation, no [Calamares](https://calamares.io/), no [ncurses](https://en.wikipedia.org/wiki/Ncurses).  Just the good ole command line.

# Repartitioning

There are several utilities that can do this such as [fdisk](https://linux.die.net/man/8/fdisk) or [gdisk](https://linux.die.net/man/8/gdisk) just to name a couple.  This process will be using _fdisk_.

The first command you want to run is _lsblk_.  That should generate some output similar to below:

```bash
NAME                MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda                   8:0    0 223.6G  0 disk  
nvme0n1             259:0    0 465.8G  0 disk  
├─nvme0n1p1         259:1    0     1M  0 part  
├─nvme0n1p2         259:2    0   513M  0 part  /boot/efi
├─nvme0n1p3         259:3    0   1.7G  0 part  /boot
└─nvme0n1p4         259:4    0 463.6G  0 part  
  └─nvme0n1p4_crypt 253:0    0 463.6G  0 crypt 
    ├─vgmint-root   253:1    0 462.6G  0 lvm   /
    └─vgmint-swap_1 253:2    0   980M  0 lvm   [SWAP]
```

If you have only one hard drive on the system, it makes things easier, but if you have multiple drives you want to make **absolutely** certain you are targeting the right drive with the fdisk commands.  Your drive names may differ as well.  If you have a NVMe drive installed you will see something similar to the output above with _nvme0n1_ being the drive itself and _p1_, _p2_ in the name indicating different partitions.  If you have a SSD drive you may see something like _sda_, _sdb_ and so on.

Whichever the case may be for you, be sure you are working with the right drive in the case where multiple drives are installed.  In this process I will be working with a NVMe drive.

I am working on a UEFI based system, so if you are using a BIOS based system, the process may differ slightly.

Run the following command:

```bash
fdisk /dev/nvme0n1
```

That will take you into the fdisk utility and it will be targeting the NVMe drive.  You can type the letter _m_ and get a list of the available menu options.  For our purposes we will start with the letter _d_ to delete all the partions on the drive.  Delete all the partitions until it indicates there are none left.

Now, in the interest of full disclosure, I tend to do things a little unconventionally.  Most would just perform all the actions needed in the fdisk utility then write the changes and move on.  I am a little quirky that way.  I prefer to complete stages of work, write or save so I don't have to redo it should I mess something up in a later step of the same work.  To each their own, it's just my preference, it doesn't mean it has to be yours or the way you do things.  Don't be hatin' on me.

With that in mind, type the letter _w_ to write the changes to disk.  This will also have the effect of ending the fdisk utility session.  So you will have to re-enter the utility for the same drive as done at the beginning.

Once back in the utility, type the letter _g_.  This will create GPT partitioning table.  I would write this to disk too (_w_), then re-enter the utility, again.  I know, I know.  I told you I was unconventional.  Deal with it.

Now that you are back in the fdisk utility for the NVMe drive, we will, finally, create the partitions.  At a minimum you will need a _boot_ partition and a _root_ partition.  If you want a separate _home_ partition (which I will use) that will need to be created as well.  Given that, type the letter _n_ to create a new partition (it should default to partition number 1).  This will be the _boot_ partition.

