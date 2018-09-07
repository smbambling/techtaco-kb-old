# Sun Java JDK RPM Build The JPackage Way Modified

Building Sun Java 1.6 u31
=========================

---

Download the JDK 1.6 u31 from Oracle
-----------------------------------

1. Go to http://www.oracle.com/technetwork/java/javase/downloads/index.html
1. Click on the Download button for the Java SE 6 Update 31 JDK
1. Select the Accept License Agreement radio button
1. Download the jdk-6u31-linux-x64.bin for 64bit or jdk-6u31-linux-i586.bin for 32bit file

Download the Timezone Updater from Oracle
-----------------------------------------

1. Go to http://www.oracle.com/technetwork/java/javase/downloads/index.html
1. Click on the Download button for JDK DST Timezone Update Tool - 1.3.45
1. Select the Accept License Agreement radio button
1. Download the tzupdater-1_3_45-2011n.zip file

Create RPM Build Environment (If needed)
----------------------------------------

More to come on this…

Move/Copy Updated/JDK into SOURCES
----------------------------------

If you building on a remote machine you’ll need to transfer the files to that build server via SCP or some other preferred method

```bash
mv tzupdater-1_3_45-2011n.zip ~/rpms/SOURCES/
mv jdk-6u31-linux-x64.bin  ~/rpms/SOURCES/
```

Download java-1.6.0-sun-1.6.0.31-1.0.cf.nosrc.rpm
-------------------------------------------------

This is being performed on your build server. We will download directly to the SRPM build directory to keep things clean

```bash
wget wget http://mirror.city-fan.org/ftp/contrib/java/java-1.6.0-sun-1.6.0.31-1.0.cf.nosrc.rpm ~/rpms/SRPMS/
```

Build Sun Java RPMs
-------------------

```bash
rpmbuild --rebuild ~/rpms/SRPMS/java-1.6.0-sun-1.6.0.31-1.0.cf.nosrc.rpm
```

After completion you should have the following RPMs in ~/rpms/RPMS/x86_64

* java-1.6.0-sun-1.6.0.31-1.0.cf.x86_64.rpm
* java-1.6.0-sun-demo-1.6.0.31-1.0.cf.x86_64.rpm
* java-1.6.0-sun-devel-1.6.0.31-1.0.cf.x86_64.rpm
* java-1.6.0-sun-jdbc-1.6.0.31-1.0.cf.x86_64.rpm
* java-1.6.0-sun-plugin-1.6.0.31-1.0.cf.x86_64.rpm
* java-1.6.0-sun-src-1.6.0.31-1.0.cf.x86_64.rpm

Installing Java JDK (Development Environment)
---------------------------------------------

```bash
yum install java-1.6.0-sun-devel
```

Check Java Version
------------------

```bash
[host1]~]$ java -version
java version "1.6.0_31"
Java(TM) SE Runtime Environment (build 1.6.0_31-b04)
Java HotSpot(TM) 64-Bit Server VM (build 20.6-b01, mixed mode)
```


[gimmick:Disqus](techtacoorg)
