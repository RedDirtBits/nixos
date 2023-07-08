# Introduction

Adventures in learning [NixOS](https://nixos.org/).

# Table of Contents

- [Wireless Connectivity](https://github.com/RedDirtBits/nixos/blob/main/docs/001-connectivity.md)
- [Repartitioning the Hard Drive](https://github.com/RedDirtBits/nixos/blob/main/docs/002-repartitioning.md)
- [Formatting the Partitions](https://github.com/RedDirtBits/nixos/blob/main/docs/003-partition-formatting.md)
- [Mounting the Partitions](https://github.com/RedDirtBits/nixos/blob/main/docs/004-mounting-partitions.md)
- [Swap](https://github.com/RedDirtBits/nixos/blob/main/docs/005-swap.md)
- [Generating NixOS Configuration Files](https://github.com/RedDirtBits/nixos/blob/main/docs/006-nixos-configuration-files.md)
- [System Configuration](https://github.com/RedDirtBits/nixos/blob/main/docs/007-system-configuration.md)

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

# Connectivity

If you are working on a laptop that has only wireless connectivity you will need to activate that as NixOS will need to dowload several packages to complete the installation.  You could, of course, use a USB Ethernet adapter as well, but just in case that is not an option.  Booting from the minimal ISO, once you are at a command prompt, run the following commands:

```bash
sudo systemctl start wpa_supplicant
wpa_cli
```

This will drop you into the CLI for configuring wireless.  If you do not see `0` or `OK` after executing a command, be sure you have entered everything correctly.

```bash
add_network
set_network 0 ssid "Your SSID"
set_network 0 psk "Your WiFi Password"
set_network 0 key_managment WPA-PSK
enable_network
```

You should see some kind of confirmation that wireless is now connected.  You can type `quit` to exit the CLI.  Once back at the command prompt you can run the command `ifconfig` to make sure you have obtained an IP address.  If so, once you have an IP address you can use SSH to reach the machine.  However, you have to set a password first.  When booting from the minimal ISO the default user is `nixos`.  You can type the command `passwd`, set a password to use for SSH then go to the machine you want to connect from and run the command `ssh -l nixos [ip address]`.  Accept the fingerprint then enter the password you set.

It makes life easier being able to remotely connect to the device you want to set up as you can copy and paste, lookup information, etc. 

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

Or, if you are trying this out in a VM first you may see something similar to that below:

```bash
NAME  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0   7:0    0 778.2M  1 loop /nix/.ro-store
sda     8:0    0    64G  0 disk 
sr0    11:0    1   812M  0 rom  /iso
```

If you have only one hard drive on the system, it makes things easier, but if you have multiple drives you want to make **absolutely** certain you are targeting the right drive with the fdisk commands.  Your drive names may differ as well.  If you have a NVMe drive installed you will see something similar to the output above with _nvme0n1_ being the drive itself and _p1_, _p2_ in the name indicating different partitions.  If you have a SSD drive you may see something like _sda_, _sdb_ and so on.

Whichever the case may be for you, be sure you are working with the right drive in the case where multiple drives are installed.

I am working on a UEFI based system, so if you are using a BIOS based system, the process may differ slightly.

Run the following command:

```bash
sudo fdisk /dev/nvme0n1
```

or

```bash
sudo fdisk /dev/sda
```


That will take you into the fdisk utility and it will be targeting the NVMe or sda drive depending on your set up.

```bash
$ sudo fdisk /dev/sda

Welcome to fdisk (util-linux 2.38.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x5425b0a7.

Command (m for help): 
```

You can type the letter _m_ and get a list of the available menu options.  

```bash
Command (m for help): m

Help:

  DOS (MBR)
   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table
```

For our purposes we will start with the letter _d_ to delete all the partions on the drive.  Delete all the partitions until it indicates there are none left.

```bash
Command (m for help): d
No partition is defined yet!
```

Now, in the interest of full disclosure, I tend to do things a little unconventionally.  Most would just perform all the actions needed in the fdisk utility then write the changes and move on.  I am a little quirky that way.  I prefer to complete stages of work, write or save so I don't have to redo it should I mess something up in a later step of the same work.  To each their own, it's just my preference, it doesn't mean it has to be yours or the way you do things.  Don't be hatin' on me.

With that in mind, type the letter _w_ to write the changes to disk.  This will also have the effect of ending the fdisk utility session.  So you will have to re-enter the utility for the same drive as done at the beginning.

Once back in the utility, type the letter _g_.  This will create GPT partitioning table.

```bash
Command (m for help): g

Created a new GPT disklabel (GUID: 47EDABFB-14A4-0C40-86D0-C1F49274E341).
```

I would write this to disk too (_w_), then re-enter the utility, again.  I know, I know.  I told you I was unconventional.  Deal with it.

```bash
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

Now that you are back in the fdisk utility for the drive, we will, finally, create the partitions.  At a minimum you will need a _boot_ partition and a _root_ partition.  If you want a separate _home_ partition (which I will use) that will need to be created as well.  Given that, type the letter _n_ to create a new partition (it should default to partition number 1).  This will be the _boot_ partition.

```bash
Command (m for help): n    
Partition number (1-128, default 1): 
```

Hit enter to accept the first sector default

```bash
First sector (2048-134217694, default 2048): 
```

This tells fdisk **where** to start the partition at.  It is important to pay attention to this, though, generally, fdisk does know where the partitions end at so that when you create more partitions, it knows where to start them.  After setting the first sector, we need to tell fdisk where to end that partition at.  This can be done by specifying the number of sectors to use or the size of the sector.

```bash
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-134217694, default 134215679): 
```

I like simple, so I have never tried partitioning a disk by specifying the number of sectors, rather, I specify the size of the partition which is what will be done here.  Being that this is the boot partition, it does not need to be very big.  Most on-line information will tell you to use somewhere between 200 - 512Mb.  I like nice round numbers and, well, I'm unconventional, so I will allocate a whole gigabyte of space by entering `+1000M`.  The `M` indicates megabytes, but you can just as easily use `1G` too.

```bash
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-134217694, default 134215679): +1000M

Created a new partition 1 of type 'Linux filesystem' and of size 1000 MiB.
```

The boot partition, at least for UEFI systems, has to have a specific filesystem and not the _Linux filesystem_ indicated int the output above.  Therefore, we need to change it to the correct one.  This is done by typing the letter _t_

```bash
Command (m for help): t
Selected partition 1
Partition type or alias (type L to list all): 
```

There is only one partition at the moment, but if you have multiple partitions be sure to select the correct one.  I always make the boot partition first so its easy to remember and I don't have to select the partition number, it is automatically selected for me.  As for the _type_ of partition this will be, you can type the letter _L_ and you will get a list of about 200 potential types.  I'll save you the trouble here.  For an EFI partition, it is option 1.  For a Linux filesystem, it is 20.  So to make the first partition an EFI system, enter _1_

```bash
Partition type or alias (type L to list all): 1
Changed type of partition 'Linux filesystem' to 'EFI System'.
```

You now need to repeat this process for the root partition and home partition, though, we can accept the default filesystem type of _Linux filesystem_ on those.

Before we move on, there is a command you might want to be familiar with if for no other reason than just a sanity check.  Type in the letter _p_ then hit enter and you should see the following:

```bash
Command (m for help): p
Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 47EDABFB-14A4-0C40-86D0-C1F49274E341

Device       Start      End  Sectors  Size Type
/dev/sda1     2048  2050047  2048000 1000M EFI System
```

Notice the _Start_ and _End_ numbers.  These are the starting and ending sectors for that particular partition.  You can use this to verify the starting point of any subsequent partitions created.  The next partition should start where the last ends.  With that create the root partition, again, by typing in the letter _n_

```bash
Command (m for help): n
Partition number (2-128, default 2): 
```

You will notice that fdisk is smart enough to start the next partition number at 2, so you can just hit enter to accept that.  Notice the first sector of this new partition

```bash
First sector (2050048-134217694, default 2050048):
```

The boot partition we created ends at sector 2050047 and this partition will start at 2050048.  Again, this is just a sanity check to make sure the default is where it should be.  After accepting the default starting point, you will again be asked to specify the ending point for the partition by either entering the number of sectors or its size.  Again, we will specify the partition by size.  I couldn't find any hard and fast rules and/or suggestions for the size of the root partition.  I have been using a size value of 20 - 50GB depending on the size of the drive.  Remember, there will be a great deal of data stored here so you don't want to skimp.  For this instance I used 30Gb

```bash
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2050048-134217694, default 134215679): +30000M

Created a new partition 2 of type 'Linux filesystem' and of size 29.3 GiB.
```

Finally, we will create the home partition and it will simply use the rest of the disk.  Simply type the letter _n_ to start the process of creating a new partition again and just accept all the defaults

```bash
Command (m for help): n
Partition number (3-128, default 3): 
First sector (63490048-134217694, default 63490048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (63490048-134217694, default 134215679): 

Created a new partition 3 of type 'Linux filesystem' and of size 33.7 GiB.
```

You can type the letter _p_ to verify everything is as specified

```bash
Command (m for help): p
Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 47EDABFB-14A4-0C40-86D0-C1F49274E341

Device        Start       End  Sectors  Size Type
/dev/sda1      2048   2050047  2048000 1000M EFI System
/dev/sda2   2050048  63490047 61440000 29.3G Linux filesystem
/dev/sda3  63490048 134215679 70725632 33.7G Linux filesystem
```

The last operation, since we are done with this step and the overall process of partitioning, you can write all the changes to disk by typting the letter _w_.  Don't forget to do this or your changes will not be written and saved and you'll have to do it all over again.  If you run the command `lsblk` again you will see the partitions that were created

```bash
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0    7:0    0 778.2M  1 loop /nix/.ro-store
sda      8:0    0    64G  0 disk 
├─sda1   8:1    0  1000M  0 part 
├─sda2   8:2    0  29.3G  0 part 
└─sda3   8:3    0  33.7G  0 part 
sr0     11:0    1   812M  0 rom  /iso
```

# Formatting The Partitions

After creating the partitions we need to format and label them.  The reason for labeling them will become more clear once we generate the configuration files.  Let's start with the boot partition.  An EFI boot partition has to be formated as fat32

```bash
sudo mkfs.fat -F 32 -n nixboot /dev/sda1
```

The _-F 32_ flag specifies the partition will be formated as fat32 as there are other fat formats you could use.  The _-n_ flag specifies that the partition will be named the following, in this case _nixboot_.  Lastly, you provide the partition to be formatted.  The main disk in this case is _sda_.  The numbers the follow that specify the partition numbers.  So _sda1_ is the first partition, _sda2_ is the second partition and so on. 

Next, format the root partition

```bash
sudo mkfs.ext4 -L nixroot /dev/sda2
```

Finally, format the home partition

```bash
sudo mkfs.ext4 /dev/sda3 -L home
```

With that, we are done with the hard drive and everything is set up to start the installation process.

# Mount The Partitions

The order of operations is important in this part of the process.  It took banging my head on the wall and desk a few times, blaming the dog for all my woes, and wondering more than once how fun it might be to just set the computer on fire before I finally figured out what I was doing wrong.  The dog was happy afterwards too as she got a few treats for putting up with my ranting.  

Before generating the configuration files for NixOS, we have to mount the partitions.  The important step here is that the root partition **must** be mounted first to whatever point used (typically _/mnt_).  Once that is done, folders will be created on that mount point for boot and home so the installer correctly picks them up and configures them in the _hardware-configuration.nix_ file.  It is also here that you will start to see the reason for creating the partition  names/labels.

With that, let's mount the root partition **first**

```bash
sudo mount /dev/disk/by-label/nixroot /mnt
```

Now that the root partition is mounted, we need to create the directories that will mount the boot and home partitions under the _/mnt_ folder.  If you do this first, before mounting root to _/mnt_ the installer will not see the partitions correctly and you will end up with no boot partition and the machine will not reboot as a result. Notice also that we were able to mount the partition using its lable rather thand the less memorable UUID.

With the root partition mounted to _/mnt_ we can now create the directories in _/mnt_ that will serve as the mount points for the boot and home partitions.

```bash
sudo mkdir -p /mnt/boot
sudo mkdir -p /mnt/home
```

Once the mount points have been created, mount the boot and home partitions to their respective points

```bash
sudo mount /dev/disk/by-label/nixboot /mnt/boot
sudo mount /dev/disk/by-label/home /mnt/home
```

After all this you definitely want to run the _lsblk_ command again and make sure everything is where it should be

```bash
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0    7:0    0 778.2M  1 loop /nix/.ro-store
sda      8:0    0    64G  0 disk 
├─sda1   8:1    0  1000M  0 part /mnt/boot
├─sda2   8:2    0  29.3G  0 part /mnt
└─sda3   8:3    0  33.7G  0 part /mnt/home
sr0     11:0    1   812M  0 rom  /iso
```

# Create The Swap

There always seems to be some contention around whether you need a swap partition or a swapfile or some other option.  Well, we didn't create a swap partition, so that leaves us with either using a swap file or some other method.  There also seems to be some contention around whether or not swap is needed at all if you have sufficient RAM.  I am not here to settle any of those debates, but I can show you two methods you can use.  We can create swap on disk or in memory.  The one thing I always splurge on when purchings a computer is RAM.  I will max it out

The first option is to create a swapfile.  The other is to create a zram swap.  One uses hard drive space, the other uses RAM.

My perspective would be (and I reserve the right to be wrong and properlly schooled) that if you are on a more resource constrained system (i.e. low RAM availability) it might be better to use a swapfile.  If you have plenty of RAM, then zram swap would be better.  What the threshold is for "plenty of ram" I am unclear on.  Personally, I would not consider anything 8Gb or less "plenty of ram".  But again, opinions and all.

## Swapfile

If you want to create a swapfile you do so with the following command

```bash
sudo fallocate -l 2G /mnt/.swapfile
```

This will create a 2Gb swap file.  You can make it larger if you so desire.

We create it in the _/mnt_ directory because that is where the root partition is mounted.  However, in my experience thus far _hardware-configuration.nix_ does not pick this up correctly and thus a little tweaking is required there (shown later).  Once the swapfile has been created, permissions have to be set, it has to be formatted and then activated.  That can all be done with the following commands:

```bash
# change the swapfile permissions
sudo chmod 600 /mnt/.swapfile

# format the swapfile
sudo mkswap /mnt/.swapfile

# activate the swapfile
sudo swapon /mnt/.swapfile
```

## Zram Swap

If you want to use zram swap, there is nothing else to do at this stage.  Zram swap will be activated and configured in the _configuration.nix_ file with the following added to the configuraion:

```bash
# Enable zram swap
zramSwap.enable = true;
zramSwap.memoryPercent = 50; # sets swap to 50% of installed memory
```

# Generate NixOS Configuration Files

We are almost there.  Next up is a rather simple step.  Generate the configuration files.  There is more that goes on than just the creation of those files, but it is the part we will be most engaged with since it will set up the system and is the mechanism that provide the reproducability of the system, its immutability, etc.  Once configuration is fully completed, you can take those configuration files and use them on other systems and create a carbon copy of the setup.

To generate the configuration files, run  the following command


```bash
sudo nixos-generate-config --root /mnt
```

Once this has been done, change your directory to _/mnt/etc/nixos/_ and make sure that you see the two configuration files _configuration.nix_ and _hardware-configuration.nit_ there.

After that, you want to open up the _hardware-configuration.nix_ file so we can inspect it and make sure the partitions were picked up correctly (this was one of the tell tales that I had done things wrong and was ranting at the dog for).

```bash
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8159118b-c904-40b7-8af7-bcd400a725bf";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E66F-198F";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/7663629f-9d1a-49e0-9c68-2aa83b0411fb";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
```

Remember those partition labels create so long ago?  Well, they are about to shine again.  Notice in the above configuration that the disks (partitions) are identified using those cryptic UUID's.  If you were to now take this configuration and use it on another machine, those UUID's would be different and things would not work, even if you precisely followed all the other steps herein.  However, we can make a change here and better ensure the portability of this file (assuming you followed the steps in this document, particularly the partitioning labels).  We will change the _by-uuid_ part to _by-label_ as seen below

```bash
fileSystems."/" =
{ device = "/dev/disk/by-label/nixroot";
    fsType = "ext4";
};

fileSystems."/boot" =
{ device = "/dev/disk/by-label/nixboot";
    fsType = "vfat";
};

fileSystems."/home" =
{ device = "/dev/disk/by-label/home";
    fsType = "ext4";
};
```

Lastly, notice how the _swapDevices_ is empty.  If you opted for a swapfile and generated it as described, we need to make sure system is aware of it.  This requires changing it as seen in the above configuration file to:

```bash
swapDevices = [
    {
        device = "/.swapfile;
    }
];
```

We don't use _/mnt/.swapfile_ because when the machine is rebooted to finish the installation _/mnt_ will become _/_, a.k.a., the root folder.  If you opted for the zramswap, then leave the swapDevices as it is, we will configure it in the _configuration.nix_ file.  Don't forget to save the changes made to the file.  The last thing to do before we start the installation process is configure _configuration.nix_ with at least a few basic things.  You _could_ start the install now, but the _configuration.nix_ file is pretty sparse, nearly all options are commented out, most notably, the creation of a user.  It's basically just a boot loader to get you back in the system

# System Configuration

At this point, the last task is to work the system configuration file _configuration.nix_.  Unfortunately, the best I can do here is documnet my journey in this because the system configuration is, to some extent, full of personal preferences and, depending on the amount of customization of the hardware, may be highly hardware specific.  The one thing I may suggest is to leave the GUI part, that is, setting up and configuring a window manager, desktop manager, etc. until you have most other things as you want and/or need them.

I spent a lot of time rebuilding NixOS because I would turn on a window manager or desktop manager only to find out I had messed something up and either could not get back to a console (forgot to install one) or some other hinderence the prevented correcting the mistake, at least at my current level of knowledge.  My take-away from that was to save that part for as close to the end as possible.  There are many other things that can be set up and tweaked before hand.

My intention, at least at the time of writing all this, is to document as best I can, the journey back to a fully functioning machine state as if I had simply gone the more traditional route and just used some distro live USB installer to set up a machine.  My current guinea pig is my older but still very useful and very snappy Dell XPS15.

Stay tuned if you are interested.  And, of course, if you are more experienced with such things, please, don't hesitate to point out things I may be doing wrong or going about the wrong way.  My aim is to get this laptop back to a state where I can simply reinstall everything and be back to a state where the system has all the applications I regularly use, configured in the manner I have them and make it a s reproduceable as possible.

That all being said, once you have your configuration files (_configuration.nix_) set up so that you can at least reboot back into the system, you will need to run the command `sudo nixos-install`.  That's it.  It will take potentially several minutes to complete, but then you can unplug the bootable NixOS minimal ISO USB drive and continue on.

Oh, one final thing.  Yes, I realize how long this document is.  My plan is to refine it as best I am able and then break it up into smaller chunks at some point.

# Links

- [NixOS Wiki](https://nixos.wiki/)
  - [NixOS Options](https://search.nixos.org/options?)
  - [NixOS Packages](https://search.nixos.org/packages?)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/index.html)
- [NixOS Home Manager](https://nix-community.github.io/home-manager/index.html)