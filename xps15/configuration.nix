# Version: 0.0.1
# Date Created: 07/08/2023
# Target Device: Dell XPS15 9550

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

##########################################################################
# BOOT LOADER
##########################################################################

  # Enable the GRUB2 bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # The OS Prober is used when you have multiple operating systems such as
  # when dual booting
  # boot.loader.grub.useOSProber = true;

##########################################################################
# NETWORK OPTIONS
##########################################################################

  networking.hostName = "xps15";
  networking.domain = "reddirt.net";
  networking.enableIPv6 = false;
  networking.timeServers = [ "68.97.68.79" "152.2.133.52" "192.58.120.8 " ];
  networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];
  networking.stevenblack.enable = true;

  # automatically activates wireless
  networking.networkmanager.enable = true;

  # activates network manager system tray applet
  # programs.nm-applet.enable = true;

##########################################################################
# FIREWALL OPTIONS
##########################################################################

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

##########################################################################
# SYSTEM SERVICES
##########################################################################

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable password authentication temporarily while the device is being configured
  # The documentation shows services.openssh.passwordAuthentication
  # however, this has been   # deprecated in favor of the below syntax
  services.openssh.settings.PasswordAuthentication = true;

  # Enable temperature management daemon
  services.thermald.enable = true;

  # Enable GVFS (Needed to recognize other internal drives, external storage, etc. in the filesystem)
  # services.gvfs.enable = true;

  # Enable adb if you work on your mobile device
  # programs.adb.enable = true;

  # Enable Bluetooth (if so equipped)
  # hardware.bluetooth.enable = true;

##########################################################################
# TIMEZONE AND LOCALE OPTIONS
##########################################################################

  # Set your time zone.
  time.timeZone = "US/Central";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.layout = "us";

##########################################################################
# MISCELLANEOUS OPTIONS
##########################################################################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # In order to run VS Code, you have to use Electron.  
  # To use Electron you have to allow "insecure" packages
  nixpkgs.config.permittedInsecurePackages = [ 
    "electron-12.2.3" 
  ];

##########################################################################
# DISPLAY SERVER, DISPLAY MANAGER(S), WINDOW MANAGER(S) OPTIONS
##########################################################################

  # Display server and Window managers
  # services.xserver.enable = true;
  # services.xserver.xautolock.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.windowManager.awesome.enable = true;
  # services.xserver.windowManager.dwm.enable = true;

##########################################################################
# GPU OPTIONS
##########################################################################

  # Enable nVidia GPU
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.prime.offload.enable = true;
  # hardware.nvidia.prime.offload.nvidiaBusId = "PCI:1:0:0";
  # hardware.nvidia.prime.offload.intelBusId = "PCI:0:2:0";
  # hardware.nvidia.modesetting.enable = false;

##########################################################################
# PRINTING OPTIONS
##########################################################################

  # Enable printing (CUPS)
  # services.printing.enable = true;
  # services.printing.drivers = with pkgs; [ hplip hplipWithPlugin ];

##########################################################################
# SOUND OPTIONS
##########################################################################

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire.enable = true;
  # services.pipewire.alsa.enable = true;
  # services.pipewire.alsa.support32Bit = true;
  # services.pipewire.pulse.enable = true;

##########################################################################
# TOUCHPAD/MOUSE OPTIONS
##########################################################################

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

##########################################################################
# USER/USER ACCOUNT OPTIONS
##########################################################################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reddirt = {
    isNormalUser = true;
    initialPassword = "nixos";
    description = "RedDirt";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

##########################################################################
# SYSTEM WIDE PACKAGES
##########################################################################

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    wget
    git
    curl
    wget
    htop
    neofetch
    pciutils
    usbutils
  ];

  # Enable Flatpak
  # services.flatpak.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # xdg.portal.enable = true;

##########################################################################
# SWAP
##########################################################################

  # Enable zram swap
  zramSwap.enable = true;
  zramSwap.memoryPercent = 25; # sets swap to 25% of installed memory

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
