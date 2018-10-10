# Building Apache Tomcat Connetor module (mod-jk) RPM with FPM on Centos 6.x

The Apache Tomat Connector module (mod_jk) is not currently in included Centos or [EPEL](https://fedoraproject.org/wiki/EPEL) repositories. 

To assist in the deployment and management of the Apache mod_jk module a RPM package will be created from the built source using [FPM](https://github.com/jordansissel/fpm).  If you havn't stumbled upon or used FPM I highly recommend taking a look.

Download the latest tomcat-connector source 
-------------------------------------------

[Tomcat-Connector Source Index](http://www.apache.org/dist/tomcat/tomcat-connectors/jk/). 

As of the writing of this article [1.2.40](http://www.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.40-src.tar.gz)

Verify Build Prerequisites
--------------------------

The following packages will need to be installed in order to correctly build the Apache Tomcat Connetor module (mod-jk).

* Apache 
```bash
sudo yum install httpd
```

* Apache Extension Tool [(apxs)](http://httpd.apache.org/docs/2.2/programs/apxs.html)
```bash
sudo yum install apache-devel
```

* GCC
```bash
sudo yum instll gcc
``` 

Build the Apache Tomcat Connetor module (mod-jk)
------------------------------------------------

Extract the downloaded source
```bash
tar -zxvf tomcat-connectors-1.2.40-src.tar.gz
```

Navigate into the /native subdirectory of the extracted source
```bash
cd tomcat-connectors-1.2.40-src/native
```

Run the configure script with apxs set
```bash
./configure --with-apxs=/usr/sbin/apxs
```

Complie/Make the module
```bash
make
```

At this point the module is build and could be copied directly to a servers /usr/[lib/lib64]/httpd/mouldes directory to be used or tested.

Create FPM Build Root 
------------------------------------------------------------

FPM will be used to generate an RPM package from a build root source containing the mimiced directory structure and files to be installed on the system.  

This means if we want to install the mod_jk.so module file via the rpm into /usr/lib64/httpd/modules we need to create correct diretory structure inside the build root directory for FPM to reference.

This can be created anywhere on your file system, but for ease of management and reference I recommand creating the build root in the /native subdirectory of the extracted source

Note! The commands reference below are being run from inside the tomcat-connectors-1.2.40-src/native directory

Create the Apache configureation directory structure inside the FPM build root
```bash
sudo mkdir -p fpm_build_root/etc/httpd/conf.d/
```

Create the Apache Lib modules directory structure inside the FPM build root
```bash
sudo mkdir -p fpm_build_root/usr/lib64/httpd/modules/
```

Populate the FPM Build Root
---------------------------

With the FPM build root directory structure(s) create we can create the needed Apache configuration files and copy the newly built module into place

Note! The commands reference below are being run from inside the tomcat-connectors-1.2.40-src/native directory

Create a mod_jk.conf Apache configuration file to load the module and apply come basic settings.  The exapmle below is one that has been used in a production environment for basic use
```bash
sudo bash -c 'cat << EOF > fpm_build_root/etc/httpd/conf.d/mod_jk.conf
# Load mod_jk module
# Specify the filename of the mod_jk lib
LoadModule jk_module modules/mod_jk.so

# Where to find workers.properties
JkWorkersFile conf.d/workers.properties

# Where to put jk logs
JkLogFile logs/mod_jk.log

# Set the jk log level [debug/error/info]
JkLogLevel info

# Select the log format
JkLogStampFormat  "[%a %b %d %H:%M:%S %Y]"

# JkRequestLogFormat
JkRequestLogFormat "%w %V %T"

# Add shared memory.
# This directive is present with 1.2.10 and
# later versions of mod_jk, and is needed for
# for load balancing to work properly
JkShmFile logs/jk.shm
EOF'
```
 
Create a Apache Tomcat Connetor module (mod-jk) workers.properties file referenced in the mod_jk.conf file.  This file will be empty
```bash
touch fpm_build_root/etc/httpd/conf.d/workers.properties
```

Copy the newly built Apache Tomcat Connetor module (mod-jk) into the FPM build root
```bash
sudo cp apache-2.0/mod_jk.so fpm_build_root/usr/lib64/httpd/modules/
```

Create the Apache Tomcat Connetor module (mod-jk) RPM Package
-------------------------------------------------------------

Warning! You must be at the top level of the FPM build root for it to correctly read the directory structures needed to generate the RPM package

Run the FPM to generate the RPM package.  Note the -p and -v flags contain the version of the built module
```bash
fpm --iteration=1 --rpm-use-file-permissions --verbose -s dir -t rpm -p /root/mod_jk-1.2.40.rpm -n mod_jk -v 1.2.40 ./
```

Veify The RPM Package Version/Files
-----------------------------------

Verify the package version
```bash
rpm -qp /root/mod_jk-1.2.40.rpm
```

Verify the package files (contents)
```bash
rpm -qp --filesbypkg /root/mod_jk-1.2.40.rpm
```

# [Disclaimer](/disclaimer.md)


