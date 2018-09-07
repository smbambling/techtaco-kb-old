# Create RPM Build Environment

Overview
--------
Create an RPM Build Environment for a unprivilged user account.

Warning! Building RPMs should **NEVER** be done as the root user.  It shoudl **ALWAYS** be done with an unprivileged user account.  Building RPMs as root could cause potential damage to your system.

Prerequisites
-------------

Install the rpm-build package
```bash
sudo yum install rpm-build
```

Most SRPMs targetted to be rebuilt on CentOS also need certain rpmbuild build macros and helper scripts, which are contained in package: redhat-rpm-config. To get results as desired, you should also install it in the same fashion as noted above, substituting the new package name.
```bash 
sudo yum install redhat-rpm-config
```

Building packages will require various compilers, install a few commons ones to get you started
```bash
sudo yum install gcc gcc-c++ make
```

Create directories for RPM building
-----------------------------------

Create RPM build directory structure in your home directory
```bash
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
```

Create .rpm macros file hunder your home directory
```bash
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
```

References
----------
http://wiki.centos.org/HowTos/SetupRpmBuildEnvironment


[gimmick:Disqus](techtacoorg)
