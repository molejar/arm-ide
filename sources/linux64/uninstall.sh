#!/bin/bash

SCRIPT_ARGS="$@"
GUESS_XTERMS="xterm rxvt dtterm eterm Eterm kvt konsole aterm"
LABEL="ArmIDE Uninstaller"

# Run this script in terminal if doesn't
if tty -s; then # Do we have a terminal?
	:
else
  if xset q > /dev/null 2>&1; then # Check for valid DISPLAY variable
    for a in $GUESS_XTERMS; do
      if type $a >/dev/null 2>&1; then
        XTERM=$a
        break
      fi
    done

    chmod a+x $0 || echo "Please add execution rights on $0"

    if test `echo "$0" | cut -c1` = "/"; then # Spawn a terminal!
      exec $XTERM -title "$LABEL" -e "$0" --xwin "$SCRIPT_ARGS"
    else
      exec $XTERM -title "$LABEL" -e "./$0" --xwin "$SCRIPT_ARGS"
    fi
  fi
fi

# Resolve the location of the ArmIDE installation.
# This includes resolving any symlinks.
PRG=$0
while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '^.*-> \(.*\)$' 2>/dev/null`
  if expr "$link" : '^/' 2> /dev/null >/dev/null; then
    PRG="$link"
  else
    PRG="`dirname "$PRG"`/$link"
  fi
done

cd `dirname "$PRG"`
ARMIDE_PATH=`pwd`
ARMIDE_DIR=${ARMIDE_PATH##*/}

UDEV_DIR=/etc/udev/rules.d
DBG_PEMICRO_RULES="28-pemicro.rules"
DBG_OPENOCD_RULES="99-openocd.rules"
DBG_JLINK_RULES="99-jlink.rules"

echo ""
echo " ******************************************************"
echo " *               ArmIDE uninstaller                   *"
echo " ******************************************************"
echo ""
echo " This script automaticaly remove all ArmIDE files."
echo " Please backup your work from \"Workspace\" directory"
echo " before continue to uninstall !"
echo ""
read -p " Remove complete $ARMIDE_DIR ? [y/n]: " key
echo ""

if [ "$key" = "y" ]; then
  xdg-desktop-menu uninstall arm-ide.desktop
  xdg-desktop-icon uninstall arm-ide.desktop
  xdg-icon-resource uninstall --size  32 arm-ide
  xdg-icon-resource uninstall --size  48 arm-ide
  xdg-icon-resource uninstall --size  64 arm-ide
  xdg-icon-resource uninstall --size 128 arm-ide
  cd ..
  rm -rfd $ARMIDE_DIR
fi

read -p " Remove all installed UDEV rules ? [y/n]: " key
echo ""

if [ "$key" = "y" ]; then
  sudo rm $UDEV_DIR/$DBG_PEMICRO_RULES && echo " Removed $UDEV_DIR/$DBG_PEMICRO_RULES"
  sudo rm $UDEV_DIR/$DBG_OPENOCD_RULES && echo " Removed $UDEV_DIR/$DBG_OPENOCD_RULES"
  sudo rm $UDEV_DIR/$DBG_JLINK_RULES   && echo " Removed $UDEV_DIR/$DBG_JLINK_RULES"

  UDEVADM=`which udevadm`

  if [ "$UDEVADM" != "" ]; then
    sudo $UDEVADM control --reload-rules
  else
    sudo udevcontrol reload_rules
  fi
fi

echo " Successfully Uninstalld"
read -p " Press enter for exit..." key
echo ""


