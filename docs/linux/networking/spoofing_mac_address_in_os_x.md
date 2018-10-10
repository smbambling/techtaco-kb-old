# Spoofing MAC Address in OS X

Overview
-------

A MAC address is a unique identifier assigned to your network card, and some networks implement MAC address filtering as a method of security. Spoofing a MAC address can be desired for multiple reasons.  In the article below is an explanation of how to spoof your Mac’s wireless MAC address.  This procedure can be slightly modified to spoof the MAC on other interfaces

Retrieving your current MAC address
-----------------------------------

Determining your current MAC address will allow you to set it back without rebooting.  Via a terminal execute the following command

```bash
ifconfig en0 | grep ether
```

Your output should be similar to ``` ether b8:e8:56:37:6d:c0 ```

Write this down somewhere so you don’t forget it. If you do, it’s not the end of the world, you’ll just have to reboot to reset it from a change.

Spoofing a MAC address
---------------------

To spoof your MAC address, you simply set that value returned from ifconfig to another hex value in the format of aa:bb:cc:dd:ee:ff. You can [generate a random one](http://osxdaily.com/2010/11/10/random-mac-address-generator/) if need be.

Via a terminal execute the following command, be sure to replace the MAC address to the one you are trying to spoof

The sudo command will require that you enter your root password to make the change.

```bash
sudo ifconfig en0 ether 5c:f9:38:b9:17:4f
```

Note: Some Macs use en1, so if you run into any issues you can try that.

Verifying the Spoofed MAC address was set 
-----------------------------------------

Issue the same command as you did above to get you current MAC address to determine if the spoof address was set

```bash
ifconfig en0 | grep ether
```

Your output should be ```` ether 5c:f9:38:b9:17:4f ````.  This means your MAC was correctly set to the spoofed address


Restore your original MAC Address
---------------------------------

In order to restore you MAC address to its original address you will need the address that you obtained from the [Retrieving your current MAC address](http://kb.techtaco.org/#!linux/networking/spoofing_mac_address_in_os_x.md#Retrieving_your_current_MAC_address) section above.

Via a terminal execute the following command, be sure to replace the MAC address to the one you are trying to restore

The sudo command will require that you enter your root password to make the change.

```bash
sudo ifconfig en0 ether b8:e8:56:37:6d:c0
``` 

Note: Some Macs use en1, so if you run into any issues you can try that.

References
---------

http://osxdaily.com/2008/01/17/how-to-spoof-your-mac-address-in-mac-os-x/


