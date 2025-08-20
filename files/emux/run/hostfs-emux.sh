#!/bin/bash
#
# EMUX Device Launcher
# This file is invoked by the hostfs
#
EMUX=$(cat /proc/cmdline | grep 'EMUX=' | sed 's/.*EMUX=\([A-Za-z0-9\-\/]*\).*/\1/g')
if [ "$EMUX" = "" ]
then
   EMUX="NULL"
fi
export EMUX

if [ -f "/emux/devices-extra" ]
then
   export EMUXDESC=$(cat /emux/devices /emux/devices-extra | grep -v '#' | grep $EMUX | sed 's/.*,\([^,]*\)$/\1/')
else
   export EMUXDESC=$(cat /emux/devices | grep -v '#' | grep $EMUX | sed 's/.*,\([^,]*\)$/\1/')
fi
export ROOTFS="/emux/${EMUX}/$(cat /emux/${EMUX}/config | grep -v '#' | grep rootfs | cut -d'=' -f2)"

# Need to set xterm-color else dialog doesn't like it
export TERM=xterm-color

# check if EMUX device is already started
fundialog=${fundialog=dialog}

x=`$fundialog --stdout --clear --no-cancel \
   --backtitle "EMUX - The Versatile IoT Device Emulator" \
   --menu "$EMUX Launcher" 0 0 0 \
   0 "EMUX HOSTFS shell (default)" \
   1 "Start $EMUXDESC" \
   2 "Enter $EMUXDESC CONSOLE (exec /bin/sh)"`

clear

if [ $x -eq 1 ]
then
   if [ -r /tmp/emuxstarted ]
   then
      echo "** $EMUXDESC already started."
      echo "If you really know what you are doing,"
      echo "then rm -f /tmp/emuxstarted"
      echo "and try this option again."
      echo "You have been warned!"
   else
      echo "Starting $EMUXDESC"
      cd /emux/$EMUX/
      ./run-init
      exit
   fi
fi

if [ $x -eq 2 ]
then
   echo "Entering $EMUXDESC CONSOLE (/bin/sh)"
   cd /emux/$EMUX/
   ./run-binsh
  exit
fi

export PS1="EMUX HOSTFS [$EMUX]:\w> "
