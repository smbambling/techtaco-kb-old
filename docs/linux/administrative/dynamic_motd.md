# Dynamic MOTD

Overview
--------
Enabling an automatic message on each SSH connection, with a dynamic MOTD.

Configure
---------
By default the SSH connection cats the file /etc/motd. You can disable this by editing the sshd_config and restarting the sshd service

Modify the ** #PrintMotd yes **  line

Hint! 
This is not required: You can also leave the /etc/motd file blank or have a static and dynamic combo

````bash
PrintMotd no
````

Configure the PAM connection module.  Add the following at the end of the file ** /etc/pam.d/login **
````bash
session    optional     pam_motd.so
````

Configure the ** /etc/profile ** file to include executing the dynamic MOTD script
````bash
/usr/local/bin/dynmotd
````
Hint!
The dynamic MOTD script below is using facter (Puppet Labs) to gather system information

Create a dynamic MOTD script ** /usr/local/bin/dynmotd ***
````bash
#!/bin/bash

echo -e "\n"
facts=`facter fqdn is_virtual lsbdistdescription architecture kernelversion uptime physicalprocessorcount processor0 memorytotal ipaddress`

echo "Hostname: `echo ${facts} | awk -F'fqdn => |ipaddress' '{ print $2 }'`"
echo "Virtual Machine: `echo ${facts} | awk -F'is_virtual => |kernelversion' '{ print $2 }'`"
echo "OS: `echo ${facts} | awk -F'lsbdistdescription => |memorytotal' '{ print $2 }'`"
echo "Architecture: `echo ${facts} | awk -F'architecture => |fqdn' '{ print $2 }'`"
echo "Kernel: `echo ${facts} | awk -F'kernelversion => |lsbdistdescription' '{ print $2 }'`"
echo "Up Time: `echo ${facts} | awk -F'uptime => |$' '{ print $2 }'`"
echo "Processors Count: `echo ${facts} | awk -F'physicalprocessorcount => |processor0' '{ print $2 }'`"
echo "Processor Info: `echo ${facts} | awk -F'processor0 => |uptime' '{ print $2 }'`"
echo "Memory: `echo ${facts} | awk -F'memorytotal => |physicalprocessorcount' '{ print $2 }'`"
echo "IP: `echo ${facts} | awk -F'ipaddress => |is_virtual' '{ print $2 }'`"
````

Modify the permissions to make the dynamic MOTD script executable
````bash
sudo chmod +x /usr/local/bin/dynmotd
````

Testing
-------

````bash
 ~  ssh techtaco.org
Last login: Mon Aug  4 08:40:15 2014 from core.arin.net

Hostname: R2.droids.local
Virtual Machine: false
OS: CentOS release 6.5 (Final)
Architecture: i386
Kernel: 2.6.32
Up Time: 41 days
Processors Count: 1
Processor Info: Intel(R) Atom(TM) CPU D525 @ 1.80GHz
Memory: 3.82 GB
IP: 192.168.1.254

[smbambling@R2 ~]$
````

[gimmick:Disqus](techtacoorg)
