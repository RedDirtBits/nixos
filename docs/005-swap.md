# Create The Swap

There always seems to be some contention around whether you need a swap partition or a swapfile or some other option.  Well, we didn't create a swap partition, so that leaves us with either using a swap file or some other method.  There also seems to be some contention around whether or not swap is needed at all if you have sufficient RAM.  I am not here to settle any of those debates, but I can show you two methods you can use.  We can create swap on disk or in memory.  The one thing I always splurge on when purchings a computer is RAM.  I will max it out

The first option is to create a swapfile.  The other is to create a zram swap.  One uses hard drive space, the other uses RAM.

My perspective would be (and I reserve the right to be wrong and properlly schooled) that if you are on a more resource constrained system (i.e. low RAM availability) it might be better to use a swapfile.  If you have plenty of RAM, then zram swap would be better.  What the threshold is for "plenty of ram" I am unclear on.  Personally, I would not consider anything 8Gb or less "plenty of ram".  But again, opinions and all.

## Swapfile

If you want to create a swapfile you do so with the following command

```bash
sudo fallocate -l 2G /mnt/.swapfile
```

This will create a 2Gb swap file.  You can make it larger if you so desire.

We create it in the _/mnt_ directory because that is where the root partition is mounted.  However, in my experience thus far _hardware-configuration.nix_ does not pick this up correctly and thus a little tweaking is required there (shown later).  Once the swapfile has been created, permissions have to be set, it has to be formatted and then activated.  That can all be done with the following commands:

```bash
# change the swapfile permissions
sudo chmod 600 /mnt/.swapfile

# format the swapfile
sudo mkswap /mnt/.swapfile

# activate the swapfile
sudo swapon /mnt/.swapfile
```

## Zram Swap

If you want to use zram swap, there is nothing else to do at this stage.  Zram swap will be activated and configured in the _configuration.nix_ file with the following added to the configuraion:

```bash
# Enable zram swap
zramSwap.enable = true;
zramSwap.memoryPercent = 50; # sets swap to 50% of installed memory
```
