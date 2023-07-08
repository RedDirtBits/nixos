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
