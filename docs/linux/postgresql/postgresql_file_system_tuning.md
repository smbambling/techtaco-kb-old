# PostgreSQL File System Tuning

Overview
--------
This article covers some basic recommended setting for files system tuning in Linux to get some additional performance when running a Postgresql Database.

File System (EXT4)
-----------------
I most commonly use CentOS (Currently 6.x versoins) as my go to operating system, because of this I'm going to focus on EXT4.  Though some other choices are XFS used for some very large databases and some considered less stable JFS,ReiserFS, BTRFS. Its important to note for Postgersql some bugs involving FSYNC handling were not fully corrected until kernel 2.6.31.8/2.6.32.1.  Kernel 2.6.32 is the first version that includes an ext4 version that should be considered safe for production Postgresql databases.  From the Postgresql perspective the main improvement over EXT3 is EXT4's better handling of write barriers and FSYNC operations.

Read-Ahead Tuning
------------------
This feature results in asking for blocks form the disk ahead of the application requesting them.  You can check your current read-ahead using the blockdev command, either for a single drive or with a summary for all drives, RAID devices, and logical volumes.  The default is 256 for regular drives, and may be larger for software RAID devices.  The units here are normally 512 bytes, making the default value equal to 128KB of read-ahead.

```bash
blockdev --getra /dev/sda
blockdev --report
```

The normal properly tuned range on modern hardware normally works out to be 4096 to 16384.  You can make the change via the blockdev command.  Unfortunatley, read-ahead needs to be set for each drive on your system.  It's usually handled by putting a blockdev adjustement for each device in rc.local boot script. 

```bash
blockdev --setra 4096 /dev/sda
```

If you run bonnie++ with a few read-ahead values, you should see the sequential read numbers increase as you tune upwards, eventually leveling off.  On smaller disk arrays or single drives, the difference may not be large.  Using this amount of read-ahead is necessary to reach full speed on a larger disk array.

File Access Time Tuning
-----------------------
Each time you access a file in Linux, a file attribute called the file's last access time (atime) is updated.  You can disable this on the database volume by adding noatime to the volume mount options in /etc/fstab.  Note that setting noatime disables both nodiratime and relatime levels of access time udpates.

```bash
/dev/sda1 /pgsql ext4 noatime,errors=remount-ro 0 1
```

Write Barrier Tuning 
--------------------
When PostgreSQL writes to disk, it executes one of the system fsync calls (fsync or fdatasync) to flush that data to disk.  By default, the cache on hard disks and disk controllers are assumed to be volatile:  when power fails, data written there will be lost.  Since that can result in filesystem and/or database corruption when it happens, fsync in Linux issues a write barrier that forces all data onto physical disk.  That will flush the write cache on both RAID and drive write caches.

When the database hardware includes a battery-backed write that's setup correctly, this is not necessary.  Writes to that cache are not volatile; they will be saved in the case of a power interruption.  In that case, you can turn off barriers on that disk.  This results in a significant boost in write performance.  You can disable barriers on the database volume by adding nobarrier to the volume mount options in /etc/fstab.

```bash
/dev/sda1 /pgsql ext4 noatime,nobarrier,errors=remount-ro 0 1
```

Read Caching and Swapping Tuning
--------------------------------
You can check the current value on your system by looking at /proc/sys/vm/swappiness and the easiest way to make a permanent change is to add a line to the /etc/sysctl.conf as shown below.   A value of 0 perfers shrinking the filesystem cache rather then using then swap, which is recommended behavior for getting predictable database performance.  

```bash
cat /proc/sys/vm/swappiness
```

```bash
vm.swappiness=0
```

Linux's tendency to let processes allocate more RAM than the system has, in hopes not all of it will actually be used.  This overcommit behavior should be disabled by making the change below to the sysctl configuration.  

```bash
vm.overcommit_memory=2
```





