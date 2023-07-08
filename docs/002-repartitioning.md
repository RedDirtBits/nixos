# Repartitioning

There are several utilities that can do this such as [fdisk](https://linux.die.net/man/8/fdisk) or [gdisk](https://linux.die.net/man/8/gdisk) just to name a couple.  This process will be using _fdisk_.

The first command you want to run is _lsblk_.  That should generate some output similar to below:

```bash
NAME                MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda                   8:0    0 223.6G  0 disk  
nvme0n1             259:0    0 465.8G  0 disk  
├─nvme0n1p1         259:1    0     1M  0 part  
├─nvme0n1p2         259:2    0   513M  0 part  /boot/efi
├─nvme0n1p3         259:3    0   1.7G  0 part  /boot
└─nvme0n1p4         259:4    0 463.6G  0 part  
  └─nvme0n1p4_crypt 253:0    0 463.6G  0 crypt 
    ├─vgmint-root   253:1    0 462.6G  0 lvm   /
    └─vgmint-swap_1 253:2    0   980M  0 lvm   [SWAP]
```

Or, if you are trying this out in a VM first you may see something similar to that below:

```bash
NAME  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0   7:0    0 778.2M  1 loop /nix/.ro-store
sda     8:0    0    64G  0 disk 
sr0    11:0    1   812M  0 rom  /iso
```

If you have only one hard drive on the system, it makes things easier, but if you have multiple drives you want to make **absolutely** certain you are targeting the right drive with the fdisk commands.  Your drive names may differ as well.  If you have a NVMe drive installed you will see something similar to the output above with _nvme0n1_ being the drive itself and _p1_, _p2_ in the name indicating different partitions.  If you have a SSD drive you may see something like _sda_, _sdb_ and so on.

Whichever the case may be for you, be sure you are working with the right drive in the case where multiple drives are installed.

I am working on a UEFI based system, so if you are using a BIOS based system, the process may differ slightly.

Run the following command:

```bash
sudo fdisk /dev/nvme0n1
```

or

```bash
sudo fdisk /dev/sda
```


That will take you into the fdisk utility and it will be targeting the NVMe or sda drive depending on your set up.

```bash
$ sudo fdisk /dev/sda

Welcome to fdisk (util-linux 2.38.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x5425b0a7.

Command (m for help): 
```

You can type the letter _m_ and get a list of the available menu options.  

```bash
Command (m for help): m

Help:

  DOS (MBR)
   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table
```

For our purposes we will start with the letter _d_ to delete all the partions on the drive.  Delete all the partitions until it indicates there are none left.

```bash
Command (m for help): d
No partition is defined yet!
```

Now, in the interest of full disclosure, I tend to do things a little unconventionally.  Most would just perform all the actions needed in the fdisk utility then write the changes and move on.  I am a little quirky that way.  I prefer to complete stages of work, write or save so I don't have to redo it should I mess something up in a later step of the same work.  To each their own, it's just my preference, it doesn't mean it has to be yours or the way you do things.  Don't be hatin' on me.

With that in mind, type the letter _w_ to write the changes to disk.  This will also have the effect of ending the fdisk utility session.  So you will have to re-enter the utility for the same drive as done at the beginning.

Once back in the utility, type the letter _g_.  This will create GPT partitioning table.

```bash
Command (m for help): g

Created a new GPT disklabel (GUID: 47EDABFB-14A4-0C40-86D0-C1F49274E341).
```

I would write this to disk too (_w_), then re-enter the utility, again.  I know, I know.  I told you I was unconventional.  Deal with it.

```bash
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

Now that you are back in the fdisk utility for the drive, we will, finally, create the partitions.  At a minimum you will need a _boot_ partition and a _root_ partition.  If you want a separate _home_ partition (which I will use) that will need to be created as well.  Given that, type the letter _n_ to create a new partition (it should default to partition number 1).  This will be the _boot_ partition.

```bash
Command (m for help): n    
Partition number (1-128, default 1): 
```

Hit enter to accept the first sector default

```bash
First sector (2048-134217694, default 2048): 
```

This tells fdisk **where** to start the partition at.  It is important to pay attention to this, though, generally, fdisk does know where the partitions end at so that when you create more partitions, it knows where to start them.  After setting the first sector, we need to tell fdisk where to end that partition at.  This can be done by specifying the number of sectors to use or the size of the sector.

```bash
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-134217694, default 134215679): 
```

I like simple, so I have never tried partitioning a disk by specifying the number of sectors, rather, I specify the size of the partition which is what will be done here.  Being that this is the boot partition, it does not need to be very big.  Most on-line information will tell you to use somewhere between 200 - 512Mb.  I like nice round numbers and, well, I'm unconventional, so I will allocate a whole gigabyte of space by entering `+1000M`.  The `M` indicates megabytes, but you can just as easily use `1G` too.

```bash
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-134217694, default 134215679): +1000M

Created a new partition 1 of type 'Linux filesystem' and of size 1000 MiB.
```

The boot partition, at least for UEFI systems, has to have a specific filesystem and not the _Linux filesystem_ indicated int the output above.  Therefore, we need to change it to the correct one.  This is done by typing the letter _t_

```bash
Command (m for help): t
Selected partition 1
Partition type or alias (type L to list all): 
```

There is only one partition at the moment, but if you have multiple partitions be sure to select the correct one.  I always make the boot partition first so its easy to remember and I don't have to select the partition number, it is automatically selected for me.  As for the _type_ of partition this will be, you can type the letter _L_ and you will get a list of about 200 potential types.  I'll save you the trouble here.  For an EFI partition, it is option 1.  For a Linux filesystem, it is 20.  So to make the first partition an EFI system, enter _1_

```bash
Partition type or alias (type L to list all): 1
Changed type of partition 'Linux filesystem' to 'EFI System'.
```

You now need to repeat this process for the root partition and home partition, though, we can accept the default filesystem type of _Linux filesystem_ on those.

Before we move on, there is a command you might want to be familiar with if for no other reason than just a sanity check.  Type in the letter _p_ then hit enter and you should see the following:

```bash
Command (m for help): p
Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 47EDABFB-14A4-0C40-86D0-C1F49274E341

Device       Start      End  Sectors  Size Type
/dev/sda1     2048  2050047  2048000 1000M EFI System
```

Notice the _Start_ and _End_ numbers.  These are the starting and ending sectors for that particular partition.  You can use this to verify the starting point of any subsequent partitions created.  The next partition should start where the last ends.  With that create the root partition, again, by typing in the letter _n_

```bash
Command (m for help): n
Partition number (2-128, default 2): 
```

You will notice that fdisk is smart enough to start the next partition number at 2, so you can just hit enter to accept that.  Notice the first sector of this new partition

```bash
First sector (2050048-134217694, default 2050048):
```

The boot partition we created ends at sector 2050047 and this partition will start at 2050048.  Again, this is just a sanity check to make sure the default is where it should be.  After accepting the default starting point, you will again be asked to specify the ending point for the partition by either entering the number of sectors or its size.  Again, we will specify the partition by size.  I couldn't find any hard and fast rules and/or suggestions for the size of the root partition.  I have been using a size value of 20 - 50GB depending on the size of the drive.  Remember, there will be a great deal of data stored here so you don't want to skimp.  For this instance I used 30Gb

```bash
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2050048-134217694, default 134215679): +30000M

Created a new partition 2 of type 'Linux filesystem' and of size 29.3 GiB.
```

Finally, we will create the home partition and it will simply use the rest of the disk.  Simply type the letter _n_ to start the process of creating a new partition again and just accept all the defaults

```bash
Command (m for help): n
Partition number (3-128, default 3): 
First sector (63490048-134217694, default 63490048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (63490048-134217694, default 134215679): 

Created a new partition 3 of type 'Linux filesystem' and of size 33.7 GiB.
```

You can type the letter _p_ to verify everything is as specified

```bash
Command (m for help): p
Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 47EDABFB-14A4-0C40-86D0-C1F49274E341

Device        Start       End  Sectors  Size Type
/dev/sda1      2048   2050047  2048000 1000M EFI System
/dev/sda2   2050048  63490047 61440000 29.3G Linux filesystem
/dev/sda3  63490048 134215679 70725632 33.7G Linux filesystem
```

The last operation, since we are done with this step and the overall process of partitioning, you can write all the changes to disk by typting the letter _w_.  Don't forget to do this or your changes will not be written and saved and you'll have to do it all over again.  If you run the command `lsblk` again you will see the partitions that were created

```bash
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0    7:0    0 778.2M  1 loop /nix/.ro-store
sda      8:0    0    64G  0 disk 
├─sda1   8:1    0  1000M  0 part 
├─sda2   8:2    0  29.3G  0 part 
└─sda3   8:3    0  33.7G  0 part 
sr0     11:0    1   812M  0 rom  /iso
```
