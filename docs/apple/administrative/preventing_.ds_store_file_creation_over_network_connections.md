# Preventing .DS_Store file creation over network connections

Overview
--------

The Finder automatically places a .DS_Store file into every folder you have opened. .DS_Store files are created by the Finder during its normal course of operation. These files hold view options, including the positions of icons, size of the Finder window, window backgrounds plus many more properties but are hidden from the user's view.


Procedure
---------

Note!This will affect the user's interactions with SMB/CIFS, AFP, NFS, and WebDAV servers.

1. Execute the following command
```bash
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
```
1. Either restart the computer or log out and back in to the user account.

If you want to prevent .DS_Store file creation for other users on the same computer, log in to each user account and perform the steps above—or distribute a copy of the newly modified com.apple.desktopservices.plist file to the ~/Library/Preferences folder of other user accounts.

**Additional Information**

These steps do not prevent the Finder from creating .DS_Store files on the local volume, and these steps do not prevent previously existing .DS_Store files from being copied to the remote file server.

Clean Up
--------

You can can run this find command to recursively remove .DS_Store files in a directory

```bash
find . -name '*.DS_Store' -type f -delete
```

References
----------

http://support.apple.com/kb/HT1629

