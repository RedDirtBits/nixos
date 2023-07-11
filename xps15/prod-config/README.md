
# Dell XPS15 Production Configuration

In rather ineloquent terms, this just the configuration that is currently running and working on the machine.  I am probably going **way** overboard with the whole base, production, and testing thing, but it helps me keep everything organized until I can sort out some better method.  It would be really cool if such a mechnism existed within NixOS (well, I assume it doesn't anyway).  Yeah, I know, generations and all but what you end up there is a menu full of different generations that have no apparent meaning (because as far as I know there is no way to annotate them).

I mentioned in the [partitioning](https://github.com/RedDirtBits/nixos/blob/main/docs/002-repartitioning.md) that I did things a little weird in that I tend to do things in stages.  One of the reasons for this is that I like to take good notes on such things.  So my generations menu selection tends to grow quite rapidly as I try new thing and make micro steps so I can capture what I hope to be, useful information.  Don't be hatin' on me, I mentioned I was a little unconventional.

At any rate, this production configuration is where I hope to document most the the various changes I make along this journey and capture things like why is that needed, what does it do, when might it be useful.  You know, my normal bland, verbose stuff.  I mean, if you are having trouble sleeping and all...

# WARNING

I am still very much learning.  NixOS is forcing me, and I am happy to do so, to get somewhat into the weeds of Linux and its inner workings.  So what I add here as documentation may come from personal observation, experience, etc. or may other sources of information.  I say that to state that if you are here reading this (and still miraculously still awake) and see something that is not right, or have misunderstood, please be kind enough to let me know.  I am learning.  I will make mistakes along the way.  But I have two things I live by in such journeys:

> The only place success comes before work is in the dictionary

> Failure is inevitable.  The lesson is optional

I am willing to put in the work and I have no shame in making mistakes along the way, I just want to be sure I learn something from that.

# The Configuration

Let's walk through the configuration.

One of the first things you will notice is that I have dispensed with a lot of the curly brace _{}_ syntax.  This was by choice and intentional.  I have nothing against the curly braces, but I find the dotted notation more readable, and, for the moment, that is more important to me.  I am not ready, yet, to dive deep into the Nix Experession Language.  I need to better understand what it takes to get a fully functional, daily use machine up and running first.  In addition, I imagine new users that don't have any exposure to languages like JavaScript, perhaps Python to some extent, etc. might be a little intimidated by all the curly braces.  So, hopefully, using the dotted notation, for now, makes it less so for them.  Enough about that.

## Bootloader

I have nothing against systemd, I just like the GRUB boot menu a little more

```bash
boot.loader.grub.enable = true;
boot.loader.grub.device = "nodev";
boot.loader.grub.efiSupport = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint = "/boot";
boot.loader.grub.useOSProber = true;
```

## Networking

I am, as a general rule, not a fan of things being automatically configured for me.  It's part security thinking (not that I am any expert in this area) but more so just a learning thing and, well, perhaps more evidence I am just weird and unconventional.  The point to all that was to say you may see some things in my configurations that may not be in others that meant to just get you up and running.  The network configuration in NixOS is one such area.

```bash
  networking.hostName = "xps15";
  networking.domain = "reddirt.net";
  networking.enableIPv6 = false;
  networking.timeServers = [ "68.97.68.79" "152.2.133.52" "192.58.120.8 " ];
  networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];
  networking.stevenblack.enable = true;
  networking.usePredictableInterfaceNames = false;
  networking.networkmanager.enable = true;
  ```

I believe most of the options above are pretty self-explanatory though, I will go over a few.

```bash
networking.timeServers = [ "68.97.68.79" "152.2.133.52" "192.58.120.8 " ];
```

Call me crazy, but I like to specify the NTP servers I use rather than the typical pool settings.  There's no real benefit I know of from doing so other than I get to tweak things a little more

```bash
networking.stevenblack.enable = true;
```

If you have ever used an adblocker or even something like [Pi-Hole](https://pi-hole.net/) you might be familiar with [Steven Black's](https://github.com/StevenBlack/hosts) block list.  I found this option available when looking over the options for networking and, well, I had to put it in.  I used a Pi-Hole for a **very** long time and have more recently tried using [NextDNS](https://nextdns.io/).  While I love NextDNS I would much rather filter things closer to home.  Couple that with [Quad9](https://www.quad9.net/) and I think you have a fairly reasonable general purpose configuration that can replace some of the functionality of Pi-Hole without a lot of effort and it is just sitting there waiting for you to clamp things down further should you so desire.  You might not get the pretty graphs and reports of Pi-Hole but it's not like that can't be added on at a later time.

```bash
networking.usePredictableInterfaceNames = false;
```

This is one of those settings that comes with some warnings.  If you chose to use this option, do so from the very start, the very first boot into NixOS.  I had some _odd_ results with booting setting this option after having set up the system.  That said, what it does is return you back to the traditional/legacy interface names such as _eth0_, _wlan0_ etc.  I have nothing against the newer naming conventions or _predictable interface names_ it was just an option I tossed in to try and see the overall affect and impact.  As I mentioned, however, use this setting from the start if you are curious.  I don't know the details of how changing the interface names would impact the boot sequence as I thought that would be set in a much later stage of the process, but I did have some issues with booting, but were, fortunately, easily fixable.

## Environment System Packages

```bash
environment.systemPackages = with pkgs; [
  wget
  git
  curl
  wget
  htop
  neofetch
  pciutils
  usbutils
];
```

There is nothing spectacular about this part of the configuration with the exception of a couple packages I needed to install that I was not aware I would have to.  If you want or need to be able to run commands like _lspci_ or _lsusb_ then you will need to install the last two packages, _pciutils_ and _usbutils_.  It never occurred to me that such functionality would not be on a system by default but here we are.

## Swap

```bash
zramSwap.enable = true;
zramSwap.memoryPercent = 25;
```

I did not set up a swap specific partition, nor configure a swap file on my installation.  Rather I opted to use Zram Swap.  I set mine to use 25% because I have 32Gb of ram on my system.  I decided to use Zram Swap primarily becuase of the reported better memory managment.
