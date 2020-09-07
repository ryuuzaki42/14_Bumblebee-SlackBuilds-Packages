## Links
    https://github.com/whitewolf1776/Bumblebee-SlackBuilds
    http://www.nvidia.com/object/unix.html

    Last: 450.66

    https://wiki.archlinux.org/index.php/bumblebee#Configuration
    https://docs.slackware.com/howtos:hardware:nvidia_optimus
    https://docs.slackware.com/howtos:hardware:proprietary_graphics_drivers
    https://slackbuilds.org/repository/14.2/system/nvidia-kernel/

## 1 Create group bumblebee:
    su -
    groupadd bumblebee

## 2 Add users to the group:
    usermod -G bumblebee -a USERNAME

## 3 Install and upgrade packages

## 4 Add bumblebee to start
    chmod +x /etc/rc.d/rc.bumblebeed
    echo "/etc/rc.d/rc.bumblebeed start" >> /etc/rc.d/rc.local

## 5 Set nouveau to greylist
    echo "xf86-video-nouveau" >> /etc/slackpkg/greylist

## Kernel upgrade - rebuilt
    bbswitch
    nvidia-kernel

## Test
    ## Note: you will need to re-login as the user for this to take effect
    Run:
glxinfo | egrep "OpenGL vendor|OpenGL renderer"

    OpenGL vendor string: Intel Open Source Technology Center
    OpenGL renderer string: Mesa DRI Intel(R) Ivybridge Mobile 

    If you switched to NVidia card:
optirun glxinfo | egrep "OpenGL vendor|OpenGL renderer"

    OpenGL vendor string: NVIDIA Corporation
    OpenGL renderer string: GeForce GT 620M/PCIe/SSE2

## Steam run game with bumblebee video card
    https://support.steampowered.com/kb_article.php?ref=6316-GJKC-7437

    ## try
        primusrun %command%

    ## Sometimes optirun is more stable
        optirun %command%

    ## In some cases, neither of those work (e.g. in Team Fortress 2) so I use:
        LD_PRELOAD="libpthread.so.0 libGL.so.1" __GL_THREADED_OPTIMIZATIONS=1 optirun %command%

## Error - fatal: failed to load any of the libraries
    $ optirun glxinfo | egrep "OpenGL vendor|OpenGL renderer"

    primus: fatal: failed to load any of the libraries: /usr/lib64/nvidia-bumblebee/libGL.so.1:/usr/lib/nvidia-bumblebee/libGL.so.1
    /us/lib64/nvidia-bumblebee/libGL.so.1: cannot open shared object file: No such file or directory
    /usr/lib/nvidia-bumblebee/libGL.so.1: cannot open shared object file: No such file or directory

    mv /usr/lib64/nvidia-bumblebee/libGL.so.1 /usr/lib64/nvidia-bumblebee/libGL.so.1.back
    ln -s /usr/lib64/nvidia-bumblebee/libGL.so.1.7.0 /usr/lib64/nvidia-bumblebee/libGL.so.1

## Error: Module glx does not have a glxModuleData data object.
    https://github.com/WhiteWolf1776/Bumblebee-SlackBuilds/issues/51

    ## Go to the modules folder:
cd /usr/lib64/nvidia-bumblebee/xorg/modules/

    ## Backup the old version of libGLX.so.0
mv libGLX.so.0 libGLX.so.0

    ## Create a link simbolic from libglxserver_nvidia.XXX from the up folder
ln ../libglxserver_nvidia.so.450.66 ./libGLX.so.0

    ## Now the error glx not appers, but the card is not dectected.
    ## Need to set manualy the correctly card

    ## See the card ID
lspci | egrep 'VGA|3D'

    ## Uncomment the line with "BusID ..." and set the value in the last command.
    ## I my case the value is "BusID "PCI:01:00:0"
nano /etc/bumblebee/xorg.conf.nvidia
