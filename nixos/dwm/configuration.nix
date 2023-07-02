
# Verion: 0.0.1
# Date: 07/02/2023
# Last Updated: 07/02/2023

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# FILE AND CONFIGURATION IMPORTS

# The hardware-configuration.nix is typically auto-generated and should require no changes.  
# You would, however, use this for other configuration imports as needed.

# Given the more advanced nature of NixOS, don't worry too much, just yet, about the import.
# Work in this main configuration file first and get the base system established and 
# reproducable first.  Doing just that is going to present its own challenges and can serve
# to help you become familiar with the "Nix" way and how the configuration works.

# Get the base system installed.  Then work on a window manager and if needed, a desktop
# environment.  Start with a desktop environment you are familiar with such as XFCE, Cinnamon,
# Gnome, etc.  Those are really easy to get going from a base install.

# Then you can work on other system necessities such as sound, mouse/touchpad, networking if
# not configured automaticall, wireless, etc.  By the time you get those working, you will have
# a better understanding of the configuration file and can start to tackle more complex items.

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # BOOTLOADER

  # I have nothing against the systemd bootloader, I just kind of like GRUB more.  Don't get caught
  # up in fancier configuration syntax starting out where groups of similar configuration items are
  # enclosed in braces ( {} ), and put everything on its own line.  This will help you see the patterns
  # and how things group together.  For example, the below lines could also be written as:

  # boot.loader = {
  #    grub = {
  #        enable = true;
  #        version = 2;  
  #        device = "nodev";
  #        efiSupport = true;
  #    };
  #    efi = {
  #       canTouchEfiVariables = true;
  #       efiSysMountPoint = "/boot";
  #      };
  #    };

  # they are the same thing and do the same thing.  The above simply groups the configuration items
  # in a more logical manner.  But now, with the prettier format, you have to watch your semi-colons
  # ( ; ) or you will get syntax errors and your configuration will not rebuild.

  # Yes, it's more typing (*gasp*) but start with the line-by-line layout as much as possible.  It can
  # help you in the long run and what seems like an uneccessarily long configuration file now can
  # later be more condensed and prettified.

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.useOSProber = true;

  # NETWORKING

  networking.hostName = "nixos"; # Define your hostname.
  networking.enableIPv6 = false;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # NETWORK PROXY

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager = {
    dwm.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reddirt = {
    isNormalUser = true;
    description = "RedDirt";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      alacritty
      firefox
      st
      cinnamon.nemo-with-extensions
      ipcalc
      xed-editor
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
   git
   curl
   wget
   htop
   neofetch
   dmenu # required for dwm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}