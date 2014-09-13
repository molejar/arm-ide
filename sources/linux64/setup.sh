#!/bin/bash

PWD=`pwd`
UDEVADM=`which udevadm`
DBG_PEMICRO_RULES=${PWD}/tools/pemicro/28-pemicro.rules
DBG_OPENOCD_RULES=${PWD}/tools/openocd/contrib/99-openocd.rules
DBG_JLINK_RULES=${PWD}/tools/segger_jlink/99-jlink.rules
CONFIG_FILE=${PWD}/configuration/.settings/org.eclipse.ui.ide.prefs
UDEV_DIR=/etc/udev/rules.d

echo "MAX_RECENT_WORKSPACES=5"                >  ${CONFIG_FILE}
echo "RECENT_WORKSPACES=${PWD}/workspace"     >> ${CONFIG_FILE}
echo "RECENT_WORKSPACES_PROTOCOL=3"           >> ${CONFIG_FILE}
echo "SHOW_WORKSPACE_SELECTION_DIALOG=false"  >> ${CONFIG_FILE}
echo "eclipse.preferences.version=1"          >> ${CONFIG_FILE}

echo "<I> INSTALL SYSTEM MODULES"

if [ -f ${DBG_PEMICRO_RULES} ]; then 
  sudo cp -f ${DBG_PEMICRO_RULES} /etc/udev/rules.d/
  sudo chmod 666 ${UDEV_DIR}/28-pemicro.rules
fi

if [ -f ${DBG_OPENOCD_RULES} ]; then
  sudo cp -f ${DBG_OPENOCD_RULES} /etc/udev/rules.d/
  sudo chmod 666 ${UDEV_DIR}/99-openocd.rules
fi

if [ -f ${DBG_JLINK_RULES} ]; then
  sudo cp -f ${DBG_JLINK_RULES} /etc/udev/rules.d/
  sudo chmod 666 ${UDEV_DIR}/99-jlink.rules
fi

if [ "$UDEVADM" != "" ]; then
  sudo $UDEVADM control --reload-rules
else
  sudo /sbin/udevcontrol reload_rules
fi

sudo /sbin/ldconfig

echo "<I> DONE"
