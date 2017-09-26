# FreedomOS

![alt text](assets/media/png/op5-big-banner-nougat.png)

## Note for pull requests and issues

I refuse all pull requests and issues coming from Github, please use [Gitlab](https://gitlab.com/Nevax/FreedomOS).
All push requests must be done in develop branch, never in the master branch.

## Required
- Linux x64 (others architectures are not currently supported).
- 30GiB of free space or more.
- Optional packages:
- `adb` for pulling updated apps and pushing rom with automatic flash.
- `java` for signed the zip file.
- `aria2` for paralleled download.

Arch based:
```
pacman -S python python2 zip curl openssl ncurses cpio python-virtualenv unzip binutils
```

Debian/Ubuntu based:
```
apt-get install python zip curl openssl libncurses-dev cpio python-virtualenv gawk binutils
```

## How to build

Clone all the required repos:
```bash
git clone --recursive https://gitlab.com/Nevax/FreedomOS.git
```
To update all the repos:
```bash
git pull --recurse-submodules
```
Build the rom with the interactive menu:
```bash
bash build.sh
```

Or build the rom with the one line command:

`<device>`: to get the list of the available devices just type `ls device`  
`<version>`: anything you wan want (e.g 1.0)  
`<build_type>`: put your developer name for public release, or `debug` for testing (e.g nevax)  
In order to build a public release build, you need to generate your own private keys (see gitlab Wiki)
```bash
bash  build.sh -d <device> -v <version> -t <build_type>
# example
bash  build.sh -d OnePlus5 -v 1.0 -t nevax
```

It will download all the needed files and start building your project.

If you forget to pull the submodules, run this command:
```bash
git submodule update --init --recursive
```

## How to translate

The translation process is quite simple.   
First of all, fork this project in your gitlab account, after that you can add or update the language of your choice.   
You can use the gitlab web ui to create and edit the files.
All the languages files are stored in [one folder](https://gitlab.com/Nevax/FreedomOS/tree/master/assets/META-INF/aroma/common/langs).
NOTICE: Change the username with your own.

After that, just create a merge request, i'll check if everything is ok for the next release.
If you are curious about git in general, check this [link](https://forum.xda-developers.com/android/help/test-t3515907).

## Join the beta team
You can join the public Slack group [link](freedomos.fr:3000)

Check your email.

[XDA thread](http://forum.xda-developers.com/oneplus-3/development/rom-freedomos-1-0-t3409348)
