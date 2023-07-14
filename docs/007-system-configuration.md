# System Configuration

At this point, the last task is to work the system configuration file _configuration.nix_.  Unfortunately, the best I can do here is documnet my journey in this because the system configuration is, to some extent, full of personal preferences and, depending on the amount of customization of the hardware, may be highly hardware specific.  The one thing I may suggest is to leave the GUI part, that is, setting up and configuring a window manager, desktop manager, etc. until you have most other things as you want and/or need them.

I spent a lot of time rebuilding NixOS because I would turn on a window manager or desktop manager only to find out I had messed something up and either could not get back to a console (forgot to install one) or some other hinderence the prevented correcting the mistake, at least at my current level of knowledge.  My take-away from that was to save that part for as close to the end as possible.  There are many other things that can be set up and tweaked before hand.

My intention, at least at the time of writing all this, is to document as best I can, the journey back to a fully functioning machine state as if I had simply gone the more traditional route and just used some distro live USB installer to set up a machine.  My current guinea pig is my older but still very useful and very snappy Dell XPS15.

Stay tuned if you are interested.  And, of course, if you are more experienced with such things, please, don't hesitate to point out things I may be doing wrong or going about the wrong way.  My aim is to get this laptop back to a state where I can simply reinstall everything and be back to a state where the system has all the applications I regularly use, configured in the manner I have them and make it a s reproduceable as possible.

That all being said, once you have your configuration files (_configuration.nix_) set up so that you can at least reboot back into the system, you will need to run the command `sudo nixos-install`.  That's it.  It will take potentially several minutes to complete, but then you can unplug the bootable NixOS minimal ISO USB drive and continue on.

One of the first things you want to do after you boot into NixOS the first time is make sure everything is up-to-date.  At the very end of the file _/etc/nixos/configuration.nix_ is a line that shows your _state version_

```bash
system.stateVersion = "23.05";
```

The channel you are on _should_ match the state version, at least at this point.  That is, the default, initial install.  You can confirm with:

```bash
sudo nix-channel --list
```

You can run the following command to get all the updates:

```bash
sudo nix-channel --update
```

Finally, rebuild and switch which will update all the packages:

```bash
sudo nixos-rebuild switch
```

At this stage all your packages should be up-to-date and you can begin setting up your system and building the final configuration.