# FreedomOS

![alt text](assets/media/oneplus3/png/big-banner-nougat.png)

## Note for pull requests and issues

I refuse all pull requests and issues coming from Github, please use [Gitlab](https://gitlab.com/Nevax/FreedomOS).

## Required
- Linux x64 (others architectures are not currently supported).
- 30GiB of free space or more.
- Optional packages:
- `adb` for pulling updated apps and pushing rom with automatic flash.
- `java` for signed the zip file.

Arch based:
```
pacman -S rsync python python2 zip curl openssl ncurses cpio python-virtualenv
```

Debian/Ubuntu based:
```
apt-get install rsync python zip curl openssl libncurses-dev cpio python-virtualenv
```

## How to build

Clone the repo:
```bash
git clone --recursive https://gitlab.com/Nevax/FreedomOS.git
```
For updating al the repos:
```bash
git pull --recurse-submodules
```
Build the project:
```bash
bash build.sh
```

It will download all the needed files and start building your project.
Once you have the needed files, you don't need to re-download them.

## How to translate

The translation process is quite simple.   
First of all, fork this project in your gitlab account, after that you can add or update the language of your choice.   
You can use the gitlab web ui to create and edit the files.
All the languages files are stored in [one folder](https://gitlab.com/Nevax/FreedomOS/tree/master/assets/META-INF/aroma/common/langs).
NOTICE: Change the username with your own.

After that, just create a merge request, i'll check if everything is ok for the next release.
If you are curious about git in general, check this [link](https://forum.xda-developers.com/android/help/test-t3515907).

## Join the beta team
We use Slack, just send me your email address in private message on XDA and i will send your an invitation to join the team.

Check your email.

[XDA thread](http://forum.xda-developers.com/oneplus-3/development/rom-freedomos-1-0-t3409348)
