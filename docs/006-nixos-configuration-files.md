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