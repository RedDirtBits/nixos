
# NixOS Home Manager

**NOTE**:
This is still a work in progress

You have completely wiped and reformatted your drive, gone through the process of getting at least a basic NixOS install on the computer and now the journey begins.  However, now there are decisions to be made.  You can build out your system using the _configuration.nix_ file, which is not entirely recommended, but it can be done.  Or you can maintain [separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns) and let the file  _/etc/nixos/configuration.nix_ remain the file that determines the system state and configuration and manage the user(s) separately, but how?

That is where  NixOS Home Manager comes it.  What _configuration.nix_ is to the system, Home Manager is to the users that work on and use the computer.  I am the only user of my particular computer, but if you had multiple users on a single system, you could use Home Manager to manage each independently.  You can manage access, [dotfiles](https://wiki.archlinux.org/title/Dotfiles), applications, etc.  But first it needs to be installed.  The Home Manager documentation is good for getting started and is clear enough but I really liked [Red Tomato's Blog](https://tech.aufomm.com/my-nixos-journey-home-manager/) on the subject.  I have drawn heavily from his information in setting up Home Manager for myself.  There are a few different options for installing Home Manager.  I am opting for the stand-alone method.  There are pros and cons to the different ways in which to install and use Home Manager which I feel are covered well enough in Red Tomato's blog.

I opted for the stand-alone method simply because I felt it would give me a better oportunity to learn the ins and outs of Home Manager.  Though, I _think_ once all the dust settles and I have a more defined and/or final configuration, I may opt for the module method so that I can just manage the system using the _nixos_ commands.

**NOTE**:
These are not run as root/superuser.  That is, you don't use _sudo_.

I did not see anything in the documentation that stated a reboot would be needed, but I ended up having to reboot after adding the home manager channel in order to install Home Manager.  This may have well been because I was configuring the system over SSH, but I do not know for sure.  I kept getting the following error:

```bash
nix-shell '<home-manager>' -A install
error: file 'home-manager' was not found in the Nix search path (add it using $NIX_PATH or -I)

       at «none»:0: (source not available)
```

I rebooted the machine and then was able to finish the install

## Add The Home Manager Channel

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
nix-channel --update
```

Pay attention to the release version and make sure it matches your state version.  

## Install Home Manager

Once that has been done, there's only one other command to run:

```bash
nix-shell '<home-manager>' -A install
```

Once that has been done, you will find your Home Manager configuration file _home.nix_ in _/.config/home-manager_.  The configuration file should be pretty basic and bare bones:

```bash
{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "reddirt";
  home.homeDirectory = "/home/reddirt";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/reddirt/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
```
















# Links

- [Home Manager Manual](https://nix-community.github.io/home-manager/index.html)
- [Red Tomato Blog - Home Manager](https://tech.aufomm.com/my-nixos-journey-home-manager/)

# Commands

- Update Nix Channel: _nix-channel --update_
- Apply Home Manager changes: _home-manager switch_
  - This is similar to updating the system configuration using _sudo nixos-rebuild switch_