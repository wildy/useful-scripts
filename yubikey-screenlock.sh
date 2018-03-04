#!/bin/bash
#
# Lock screen when a Yubikey is removed
#
DEVID="1050:0407"
getXuser() {
        user=`who| grep -m1 ":$displaynum " | awk '{print $1}'`
 
        if [ x"$user" = x"" ]; then
                user=`who| grep -m1 ":$displaynum" | awk '{print $1}'`
        fi
        if [ x"$user" != x"" ]; then
                userhome=`getent passwd $user | cut -d: -f6`
                export XAUTHORITY=$userhome/.Xauthority
        else
                export XAUTHORITY=""
        fi
}

sleep 1
lsusb | grep $DEVID &> /dev/null && exit 0 

for x in /tmp/.X11-unix/*; do
    displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
    getXuser
    if [ x"$XAUTHORITY" != x"" ]; then
        # extract current state
   export DISPLAY=":$displaynum"
    fi
su $user -c "/usr/bin/xscreensaver-command --lock"
done


