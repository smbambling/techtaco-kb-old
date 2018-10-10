# Configuring a Wireless Access Point

Log In and Enter Configuration Mode
-----------------------------------

First you will need to log into the AP with the supplied console cable. The default password is typically Cisco. Once logged in we must elevate privileges to do this type enable. The symbol follow the device name will now change from an arrow(>) to a pound(#) sign.

````
Now we will enter the configuration mode. You may type configure terminal or conf t for short .
````

Now we will enter the configuration mode. You may type configure terminal or conf t for short .

````
#configure terminal
````

Any changed made in the configuration mode are stored until the device is rebooted. We will save the changes to the device after all changes are made later in this wiki.

For security we will change the enable password.

````
(config)#enable secret <mypassword>
````

Now lets name the device so it is easily recognized if your network has more than one AP or Cisco device. In this example we named it using the following method. Out of Band - Office Site - Access Point Management IP - Physical Location

````
(config)#hostname OOB-DUM-AP9-1stFlr
````

We will also need to create a user so that we may SSH into the AP and not have to console in every time. This is especially useful if the AP is behind a ceiling tile. Replace <Newuser> and <Password> with their corresponding information.

````
(config)#username <Newuser> password 0 <Password>
````

Setting The Time
----------------

For logging purposes we will now set the clock. First we set the time zone either UTC (Coordinated Universal Time), GMT(Greenwich Mean Time), etc. Then we tell the device if it is currently daylight saving time. lastly we exit the configuration terminal to set the time. Notice we are still in elevated privilege mode noted by the # symbol.

````
(config)# clock timezone UTC -5
(config)#clock summer-time EDT recurring
(config)#CNTL/Z.
#clock set 10:55:00 Oct 29 2010
````

Configure The Radio
-------------------

In this stage we will turn on and configure the wireless radio. We must first enter configuration mode the enter your interface. In this example the interface is Dot11Radio 0

````
#configure terminal
(config)#interface Dot11Radio 0
````

We are now in the Radio 0 configuration notice config now has a dash IF.

To set the SSID simple type ssid followed by the name

````
(config-if)#ssid <NewSSID Name>
````

We will also encrypt the wireless using WPA2. And set the AP to use the least congested changes using channel 1,6,and 11 because these changes are the only ones not to over lap. Also tell the wireless antenna not to turn off.

````
(config-if)#encryption mode ciphers aes-ccm
(config-if)#channel least-congested 2412 2437 2462
(config-if)#no shutdown
````

Some addition but not necessary changes are to make the wireless check authentication key on a given time interval and set the speed available.

````
(config-if)#broadcast-key change 300 membership-termination capability-change
(config-if)#speed basic-1.0 basic-2.0 basic-5.5 6.0 9.0 basic-11.0 12.0 18.0 24.0 36.0 48.0 54.0
````

After these are all set we will exit the Radio configuration

````
(config-if)#exit
````

Configure The SSID
------------------

Now that we have a SSID we need to set its configuration also. So we log into its config mode. You will notice the word config will then be followed by a dash ssid

````
(config)#dot11 ssid <SSID NAME>
````

Here we set the AP authentication method (WPA) and the password. Then we set the SSID to Open so it will be displayed when searching from a computer.

````
(config-ssid)#authentication open
(config-ssid)#authentication key-management wpa
(config-ssid)#wpa-psk ascii 0 <NEW PASSWORD>
````

Addidtionally but again not required is to set the maximum number of connections. Cisco states that after 22 connection the Ap will begain to lose signal/connection strength. Here we set ours to 25 then exit the SSID configuration.

````
(config-ssid)#max-associations 25
(config-ssid)#exit
````

Configure The Ethernet Port for SSH
-----------------------------------

In order to be able to ssh in to the AP we need to know where the device is located. So now we set the IP address. First enter the Ethernet interface. Again notice that a dash IF will appear after the word config.

````
(config)#interface fastEthernet 0
````

And set the IP and gateway. We also tell the port not to turn off before exiting the Ethernet interface.

````
(config-if)#ip address 192.168.10.9 255.255.255.0
(config-if)#no shutdown
(config-if)#exit
````

Securing The Web Interface
--------------------------

Here we instruct the web interface to only use HTTPS

````
(config)#no ip http server
(config)#ip http secure-server
(config)#exit
````

Saving Your Configurations
--------------------------

Lastly we must save all the changes from the running configuration to the start up configuration. If you where to reboot the device before this has been done all changes we have made will be removed.

````
#copy running-config startup-config
````

