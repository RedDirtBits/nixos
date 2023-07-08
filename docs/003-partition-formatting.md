# Formatting The Partitions

After creating the partitions we need to format and label them.  The reason for labeling them will become more clear once we generate the configuration files.  Let's start with the boot partition.  An EFI boot partition has to be formated as fat32

```bash
sudo mkfs.fat -F 32 -n nixboot /dev/sda1
```

The _-F 32_ flag specifies the partition will be formated as fat32 as there are other fat formats you could use.  The _-n_ flag specifies that the partition will be named the following, in this case _nixboot_.  Lastly, you provide the partition to be formatted.  The main disk in this case is _sda_.  The numbers the follow that specify the partition numbers.  So _sda1_ is the first partition, _sda2_ is the second partition and so on. 

Next, format the root partition

```bash
sudo mkfs.ext4 -L nixroot /dev/sda2
```

Finally, format the home partition

```bash
sudo mkfs.ext4 /dev/sda3 -L home
```

With that, we are done with the hard drive and everything is set up to start the installation process.