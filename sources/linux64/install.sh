#!/bin/bash

SCRIPT_ARGS="$@"
GUESS_XTERMS="xterm rxvt dtterm eterm Eterm kvt konsole aterm"
LABEL="ArmIDE Installer"

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

OLD_PWD=`pwd`
cd `dirname "$PRG"`

ARMIDE_DIR=`pwd`
DBG_PEMICRO_RULES="$ARMIDE_DIR/tools/pemicro/28-pemicro.rules"
DBG_OPENOCD_RULES="$ARMIDE_DIR/tools/openocd/contrib/99-openocd.rules"
DBG_JLINK_RULES="$ARMIDE_DIR/tools/segger_jlink/99-jlink.rules"
CONFIG_FILE="$ARMIDE_DIR/configuration/.settings/org.eclipse.ui.ide.prefs"
UDEV_DIR=/etc/udev/rules.d

echo
echo "<I> Configure Workspace directory"

echo "MAX_RECENT_WORKSPACES=5"                 >  $CONFIG_FILE
echo "RECENT_WORKSPACES=$ARMIDE_DIR/workspace" >> $CONFIG_FILE
echo "RECENT_WORKSPACES_PROTOCOL=3"            >> $CONFIG_FILE
echo "SHOW_WORKSPACE_SELECTION_DIALOG=false"   >> $CONFIG_FILE
echo "eclipse.preferences.version=1"           >> $CONFIG_FILE

echo
read -p "<I> Create Desktop/Menu icons ? [y/n]: " key

if [ "$key" = "y" ]; then
ICON_NAME=arm-ide
TMP_DIR=`mktemp --directory`
DESKTOP_FILE=$TMP_DIR/arm-ide.desktop

cat << EOF > $DESKTOP_FILE
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=ArmIDE
Keywords=eclipse;toolchain;gnuarm
GenericName=Eclipse based IDE for ARM MCUs
Type=Application
Categories=Development
Terminal=false
StartupNotify=true
Exec="$ARMIDE_DIR/eclipse"
Icon=$ICON_NAME.png
EOF

xdg-icon-resource install --size  32 "$ARMIDE_DIR/icons/arm-ide-32.png"  $ICON_NAME
xdg-icon-resource install --size  48 "$ARMIDE_DIR/icons/arm-ide-48.png"  $ICON_NAME
xdg-icon-resource install --size  64 "$ARMIDE_DIR/icons/arm-ide-64.png"  $ICON_NAME
xdg-icon-resource install --size 128 "$ARMIDE_DIR/icons/arm-ide-128.png" $ICON_NAME
xdg-desktop-menu install $DESKTOP_FILE
xdg-desktop-icon install $DESKTOP_FILE

rm $DESKTOP_FILE
rm -R $TMP_DIR
fi

echo
echo "<I> Install UDEV rules for Debuggers"

if [ -f $DBG_PEMICRO_RULES ]; then
  sudo cp -f $DBG_PEMICRO_RULES $UDEV_DIR
  sudo chmod 666 $UDEV_DIR/${DBG_PEMICRO_RULES##*/}
fi

if [ -f $DBG_OPENOCD_RULES ]; then
  sudo cp -f $DBG_OPENOCD_RULES $UDEV_DIR
  sudo chmod 666 $UDEV_DIR/${DBG_OPENOCD_RULES##*/}
fi

if [ -f $DBG_JLINK_RULES ]; then
  sudo cp -f $DBG_JLINK_RULES $UDEV_DIR
  sudo chmod 666 $UDEV_DIR/${DBG_JLINK_RULES##*/}
fi

UDEVADM=`which udevadm`

if [ "$UDEVADM" != "" ]; then
  sudo $UDEVADM control --reload-rules
else
  sudo udevcontrol reload_rules
fi

sudo ldconfig

cd $OLD_PWD

echo
echo "<I> Sucsessfully installed"

