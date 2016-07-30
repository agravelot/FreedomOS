#FreedomOS

![alt tag](https://raw.githubusercontent.com/Nevax07/FreedomOS/op3/banner_small.png)

**Required :**
Linux
20 Go of free space
Packages : `rsync python zip curl openssl`
Optional packages:
- `adb` for pulling updated apps and pushing rom with automatic flash.
- `java` for signed the zip file, i don't know which version is needed, i use `java-8-jdk` on my Arch Linux.
You also need ext4 mount support with loop option.

**How to build :**

```bash
bash build.sh
```

It will download all the needed files (~1.4Go) and start building your project.
Once you have the needed files, you don't need to re-download them.

#### Join the beta team
We use Slack, just give me your email address in PM on XDA and i will invite you in the team.

XDA thread : http://forum.xda-developers.com/oneplus-3/development/rom-freedomos-1-0-t3409348
