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

# Links

- [NixOS Wiki](https://nixos.wiki/)
  - [NixOS Options](https://search.nixos.org/options?)
  - [NixOS Packages](https://search.nixos.org/packages?)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/index.html)
- [NixOS Home Manager](https://nix-community.github.io/home-manager/index.html)