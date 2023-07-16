# Version: 0.0.1
# Date Created: 07/08/2023
# Target Device: Dell XPS15 9550

# This is the base configuration for a Dell XPS15 9550, i7 6th Gen., 32Gb Ram, Nvidia GPU, 512Gb NVMe
# It is a known good base configuration from a NixOS minimal ISO install.

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use GRUB2 bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.useOSProber = true; # don't really need this unless using multiple operating systems

  networking.hostName = "xps15";
  networking.domain = "reddirt.net";
  networking.enableIPv6 = false;
  networking.timeServers = [ "68.97.68.79" "152.2.133.52" "192.58.120.8" ];
  networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];
  networking.stevenblack.enable = true;
  networking.networkmanager.enable = true; # automatically activates wireless
  programs.nm-applet.enable = true; # activates the network manager "gui" for managing connections

  # Set your time zone.
  time.timeZone = "US/Central";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure the X11 keymap
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;  # Needed for things like nVida or other drivers that are proprietary

  # Display server and Window managers
  # services.xserver.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.windowManager.awesome.enable = true;
  # services.xserver.windowManager.dwm.enable = true;

  # Enable printing (CUPS)
  # services.printing.enable = true;
  # services.printing.drivers = with pkgs; [ hplip hplipWithPlugin ];

  # Enable scanning (will need to add user to "scanner" group)
  # hardware.sane.enable = true;
  # hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  # Enable GVFS (Needed to recognize other internal drives, external storage, etc. in the filesystem)
  # services.gvfs.enable = true;

  # Enable default shell (may be the default and thus not needed?)
  # programs.bash.enable = true;
  # users.defaultUserShell = pkgs.bash;

  # Enable Bluetooth (if so equipped)
  # hardware.bluetooth.enable = true;

  # Enable Flatpak
  # services.flatpak.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # xdg.portal.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reddirt = {
    isNormalUser = true;
    initialPassword = "nixos";
    description = "RedDirt";
    extraGroups = [ "networkmanager" "wheel" "audio" "scanner" "lp" "dialout" "libvirtd" "vboxusers" ];
    packages = with pkgs; [ # packages to install only for the user
      firefox
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ # packages to be installed and available system wide
    alacritty
    wget
    git
    curl
    wget
    htop
    neofetch
    pciutils
    usbutils
    # etcher
  ];

  # Enable zram swap
  zramSwap.enable = true;
  zramSwap.memoryPercent = 25; # sets swap to 25% of installed memory

  # Enable temperature management daemon
  services.thermald.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
