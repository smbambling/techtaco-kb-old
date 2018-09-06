# Determine The Location of Linux Kernel Driver

!!! note ""
    **/lib/modules/kernel-version/** directory stores all compiled drivers under Linux operating system.

Display current modules
```bash 
ls -l /lib/modules/$(uname -r)
```

Navigate to current modules directory
```bash
cd /lib/modules/$(uname -r)
```

