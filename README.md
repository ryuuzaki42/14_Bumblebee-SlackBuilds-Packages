## Bumblebee-SlackBuilds compiled to Slackware Current

## Version
    Nvidia driver: 460.32.03
    Slackware Current Kernel: 5.10.10

## Links
[https://github.com/whitewolf1776/Bumblebee-SlackBuilds](https://github.com/whitewolf1776/Bumblebee-SlackBuilds)

.

[http://www.nvidia.com/object/unix.html](http://www.nvidia.com/object/unix.html)

[https://wiki.archlinux.org/index.php/bumblebee#Configuration](https://wiki.archlinux.org/index.php/bumblebee#Configuration)

[https://docs.slackware.com/howtos:hardware:nvidia_optimus](https://docs.slackware.com/howtos:hardware:nvidia_optimus)

[https://docs.slackware.com/howtos:hardware:proprietary_graphics_drivers](https://docs.slackware.com/howtos:hardware:proprietary_graphics_drivers)

.

[https://github.com/ryuuzaki42/Bumblebee-SlackBuilds-Packages](https://github.com/ryuuzaki42/Bumblebee-SlackBuilds-Packages)

## Source files used:
[https://github.com/ryuuzaki42/14_Bumblebee-SlackBuilds-Packages/blob/master/Bumblebee-SlackBuilds-Source.zip](https://github.com/ryuuzaki42/14_Bumblebee-SlackBuilds-Packages/blob/master/Bumblebee-SlackBuilds-Source.zip)

## How Install

## 0 - clone the repository or donwload
    git clone https://github.com/ryuuzaki42/14_Bumblebee-SlackBuilds-Packages.git

## Or download
[https://github.com/ryuuzaki42/14_Bumblebee-SlackBuilds-Packages/archive/master.zip](https://github.com/ryuuzaki42/14_Bumblebee-SlackBuilds-Packages/archive/master.zip)

## 1 Create group bumblebee:
    su -
    groupadd bumblebee

## 2 Add users to the group: # Change USERNAME to your user name
    usermod -G bumblebee -a USERNAME

## 3 Install - upgrade packages
    cd Bumblebee-SlackBuilds-Packages/final_packages/upgrade/
    upgradepkg xf86-video-nouveau-blacklist-1.0-noarch-1.txz

    cd ../install/
    upgradepkg --install-new --reinstall *z

    cd kernel_upgrade/
    upgradepkg --install-new --reinstall *z

## 4 Add bumblebee to start
    chmod +x /etc/rc.d/rc.bumblebeed
    echo "/etc/rc.d/rc.bumblebeed start" >> /etc/rc.d/rc.local

Rebbot to test

If you use slackpkg+ ([http://slakfinder.org/slackpkg+.html](http://slakfinder.org/slackpkg+.html)), Set nouveau to greylist:

    echo "xf86-video-nouveau" >> /etc/slackpkg/greylist

# After a Kernel update need to rebuilt
    bbswitch
    nvidia-kernel

### Test - Note: you need to re-login (or rebbot) to update take effect
Run:

    glxinfo | egrep "OpenGL vendor|OpenGL renderer"

### Result example:
    OpenGL vendor string: Intel
    OpenGL renderer string: Mesa Intel(R) UHD Graphics 620 (KBL GT2)

### Now test the NVidia card:
    optirun glxinfo | egrep "OpenGL vendor|OpenGL renderer"

### Result example:
    OpenGL vendor string: NVIDIA Corporation
    OpenGL renderer string: GeForce 930MX/PCIe/SSE2

Card version of the test: GeForce 930MX

## Steam run game with bumblebee video card
[https://support.steampowered.com/kb_article.php?ref=6316-GJKC-7437](https://support.steampowered.com/kb_article.php?ref=6316-GJKC-7437)

## Try
    primusrun %command%

## Sometimes optirun is more stable
    optirun %command%

## In some cases, neither of those work (e.g. in Team Fortress 2) so I use:
    LD_PRELOAD="libpthread.so.0 libGL.so.1" __GL_THREADED_OPTIMIZATIONS=1 optirun %command%

# Errors

## Error - fatal: failed to load any of the libraries .../libGL.so.1
### Backup libGL.so.1
    mv /usr/lib64/nvidia-bumblebee/libGL.so.1 /usr/lib64/nvidia-bumblebee/libGL.so.1.back

### Create a link simbolic from libGL.so.1.7.0
    ln -s /usr/lib64/nvidia-bumblebee/libGL.so.1.7.0 /usr/lib64/nvidia-bumblebee/libGL.so.1

## Error: Module glx does not have a glxModuleData data object
[https://github.com/WhiteWolf1776/Bumblebee-SlackBuilds/issues/51](https://github.com/WhiteWolf1776/Bumblebee-SlackBuilds/issues/51)

### Sometimes just need the last part, with set the card in /etc/bumblebee/xorg.conf.nvidia

### Go to the modules folder:
    cd /usr/lib64/nvidia-bumblebee/xorg/modules/

### Backup the old version of libGLX.so.0
    mv libGLX.so.0 libGLX.so.0.back

### Create a link simbolic from libglxserver_nvidia.XXX from the up folder
    ln ../libglxserver_nvidia.so.450.66 ./libGLX.so.0

### Now the error glx not appears, but the card is not detected. Need to set manually the correctly card

### See the card ID
    lspci | egrep 'VGA|3D'

### Uncomment the line with "BusID ..." and set the value in the last command
### I my case the value is "BusID "PCI:01:00:0"
    nano /etc/bumblebee/xorg.conf.nvidia
