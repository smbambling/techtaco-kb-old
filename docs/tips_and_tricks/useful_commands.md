# Useful Commands


Bash
----

**Display the access rights in octal of all files with in a directory**
```bash
stat -c "%a %n" *
```

**Diffing a local and remote file.**

 * The diff utility can take one operand in the form of stdin (represented by "-")

```bash
ssh node1.example.com cat '/full/file/path/text.txt' | diff -y --suppress-common-lines /full/file/path/text.txt -
```

**Diff two remote files**

 * The diff utility can take one operand in the form of stdin (represented by "-")

```bash
diff -y --suppress-common-lines <(ssh node1.example.com 'cat /full/file/path/text.txt') <( ssh node2.example.com 'cat /full/file/path/text.txt')
```

**Sort files by human readable size**
```bash
du -sk * | sort -rn | awk '{print $2}' | xargs -ia du -hs "a"
```
```bash
du -sk * | sort -rn | awk '{ split( "KB MB GB" , v ); s=1; while( $1>1024 ){ $1/=1024; s++ } print int($1) v[s], $2 }'
```
```bash
sudo du -sk .[!.]* * | sort -rn | awk '{ split( "KB MB GB" , v ); s=1; while( $1>1024 ){ $1/=1024; s++ } print int($1) v[s], $2 }'
```

**Determine Inode Usage**
Don't expect this to run quickly...

In a directory where you suspect there might be a lot of inode usage run the following

```bash
find . -type d |
while
  read line
do
  echo "$( find "$line" -maxdepth 1 | wc -l) $line"
done |
sort -rn | less
```

**Test GPG Passphrase**
````
echo "1234" | gpg --no-use-agent -o /dev/null --local-user <keyID> -as - && echo "The correct passphrase was entered for this key"
````

**List Linux processes using SWAP memory**
```
for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | less
```

Awk
---

Sed
---

### Update multiple files with find + sed

**Remove lines matching pattern(gimmick) from multiple files**
```
find . -name "*.md" -type f | xargs -o sed -i '' '/gimmick/d'
```

VIM
---
**Delete lines that do contain a word/pattern**
```
:%g/price/d
```

**Delete lines that do NOT contain a word/pattern**
```
:%g!/price/d
```
