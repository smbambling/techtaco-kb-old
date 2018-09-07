# PostgreSQL Disk Array, Layout and RAID Tuning

Overview
--------
This article covers basic recommendation for setting up and configuring Disk Arrays, RAID and Disk Layout for your Postgresql database server.

Definitions
-----------
**No-Read-Ahead:** Selecting no-read-ahead policy indicates that the controller should not use read-ahead policy. 

**Read-Ahead:** When using read-ahead policy, the controller reads sequential sectors of the virtual disk when seeking data. Read-ahead policy may improve system performance if the data is actually written to sequential sectors of the virtual disk. 

**Adaptive Read-Ahead:** When using adaptive read-ahead policy, the controller initiates read-ahead only if the two most recent read requests accessed sequential sectors of the disk. If subsequent read requests access random sectors of the disk, the controller reverts to no-read-ahead policy. The controller continues to evaluate whether read requests are accessing sequential sectors of the disk, and can initiate read-ahead if necessary.

**Write-Back:** When using write-back caching, the controller sends a write-request completion signal as soon as the data is in the controller cache but has not yet been written to disk.  This is only recommended with a Battery Back Raid Controller.  In that configuration, when the battery isn't there or isn't working, the controller will degrade to Write-Through automatically.  This is still safe, but writes can be much slower.

**Write-Through:** When using write-through caching, the controller sends a write-request completion signal only after the data is written to the disk.
Force Write Back: When using force write-back caching, the write cache is enabled regardless of whether the controller has a battery.

Disk Array
----------
If you have a large amount of disks and disk space required for the database a good optimal configuration would be.  In the table below $PGDTA = /var/lib/pgsql/9.2 on a Centos 6 installation with Postgresql 9.2.x installed. 

Hint! Its recommended that if you don't have at least 2 disk dedicated to the pg_xlog that you allow it to reside on the same disk as the $PGDATA

| Location        | Disks | RAID | Purpose               |      
|:----------------|:------|:-----|:----------------------|
| / (root)        | 2     | 1    | Operating System      |
| $PGDATA	  | 4+    | 10   | Database              |
| $PGDATA/pg_xlog | 2     | 1    | Write Ahead Log (WAL) |
| Tablespace      | 1+    | None | Temporary files       |

Looking at some of the access patterns of the main file systems.  This is useful if you have less disk or want to create a larger single array/fewer arrays.

| Location              | Cache Flushes    | Access Patterns                       | 
|:----------------------|:-----------------|:--------------------------------------|
| Operating System      | Rare             | Mix of Sequential and Random          |
| Database	        | Regularly	   | Mix of Sequential and Random          |
| Write Ahead Log (WAL) | Constant         | Sequential  		           |
| Temporary Files	| Never		   | More random as client count increases |

Note that the exact mix of sequential and random behavior for your database is completely application dependent.  Any attempt to optimize disk layout that doesn't take into account the access pattern of your app, including concurrency is unlikely to predict performance correctly. 

Hardware RAID Parameters
------------------------
Additional performance tuning can be achieved by setting hardware raid card parameters such as **Read-Ahead** and **Write-Back**.  

Though from talks with users read-ahead/adaptive read-ahead set on the raid controller does not significantly contribute to performance improvement in comparison to the OS which will usually perform the read-ahead.  

Lastly Write-Back is only recommended with a Battery Back Raid Controller, as if there is no battery data loss may occur in the event of a power failure.

Disk Layout
-----------
There are a few guidelines that can help prune down the possible configuration. 

 * Avoid putting the WAL on the operating system drive, because they have completely different access patterns and both will suffer when combined. 
 * If you have evidence you don't do any large sorting, the temporary files can be kept at their default location, as part of the database disk.

All things considered splitting the data up allows for easier measurement of data going to the database, WAL, and temporary disk. 





[gimmick:Disqus](techtacoorg)
