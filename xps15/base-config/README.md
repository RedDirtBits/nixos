
# Dell XPS15 Base Configuration

The configuration files found here are the result of the initial set up of the system configuration before running `sudo nixos-install`.  In other words it is the continuation of the initial [system](https://github.com/RedDirtBits/nixos/blob/main/docs/007-system-configuration.md) configuration.  What I wanted was a plain, vanilla configuration that would get me back to a bootable, minimal system that could serve as something of a template from which to start.  The scaffold if you will.

This is not likely to change much, if at all.  The only real changes I have made were to add in configurations for xserver, sound, enabling thermal management, etc., and commented out most of it so it would not be a part of the base config, but available to be quickly enabled without having to remember all the specific things needed.  Which in turn made it easy to just uncomment certain things for the production configuration one-by-one to make sure they would work as intended.

As such, there won't be much action here.  The main changes will be taking place in the testing configuration and as those changes are set up and show to not degrade the system they will be moved to the production configuration for longer term testing.  I am probably doing that all wonky from the perspective of all the programmers out there, but it seems to be working for me thus far.  My hope is to have some kind of documentation in the production configuration that, at least as far as my current knowledge level will allow, will describe what some or most things are doing, why and perhaps any _gotchas_ along the way.

It's a journey and a process and I suppose it has to start somewhere.