# Remove Unused Kernels

Overview
--------

When running yum update you can some times revive the error below

````
Error Summary
-------------
Disk Requirements:
At least 10MB more space needed on the /boot filesystem.
````

To get around this error you can remove unused kernels from the system to create space.  You'll need to make sure that you do not remove the current running kernel from the system.  You can use the uname -r command to view the current running kernel that you should not remove.

```bash
uname -r 2.6.32-220.4.2.el6.x86_64
```

List Current Installed Kernels
------------------------------

You can view the current installed kernels on the systems by running the following command.

```bash
rpm -qa | grep kernel | grep -e "^kernel"
```

You can view all no running kernels on the system with the following command.

```bash
rpm -qa | grep kernel | grep -e "^kernel" | grep -v "`uname -r`\|headers\|firmware"
```

Clean-Up Space and Yum Update
-----------------------------

To make this process easier you can run the following command to remove the unused kernels and kick off a yum update.  I've purposely not thrown the -y switch via yum remove so that you can review any dependencies that might be removed along with the kernel.

This command will only proceed from command to command if the previous command is successful.

```bash
REMOVE=$(rpm -qa | grep kernel | grep -e "^kernel" | grep -v "`uname -r`\|headers\|firmware") && sudo yum remove ${REMOVE} && sudo yum update -y
```

You can also run this in a loop with a little escaping

```bash
for i in HOST1 HOST2; REMOVE=`ssh $i rpm -qa kernel\* | grep -v \`uname -r\`\|headers\|firmware` ; ssh $i yum -y remove $REMOVE ; ssh $i yum -y update ; done
```

