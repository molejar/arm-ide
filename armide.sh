#!/bin/bash

BUILD_ARCH=`uname -m`

# Default OS type (win32, win64, linux32, linux64)
if [ "$BUILD_ARCH" == "x86_64" ]; then
  OS_TYPE="linux64"
else
  OS_TYPE="linux32"
fi

# Default name of log file
LOG_FILE="`echo ${0##*/} | sed 's/sh/log/g'`"

# Default debug Level (0 - 5)
DEBUG_LEVEL="0"

# Project name
PROJECT_NAME="ArmIDE"

# Project version number
PROJECT_VNUM="0.0.1"


# Parse arguments
while [[ $# > 0 ]]; do

  param="$1"; shift

  case $param in
    -v | --version)
      echo
      echo "$PROJECT_NAME creator version: $PROJECT_VNUM"
      echo
      exit 0
      ;;

    -t | --ostype)
      [ "$1" != "" ] && OS_TYPE="$1" && shift
      ;;

    -l | --logfile)
      [ "$1" != "" ] && LOG_FILE="$1" && shift
      ;;

    -d | --debug)
      [ "$1" != "" ] && DEBUG_LEVEL="$1" && shift
      ;;

    -? | --help)
      echo
      echo "Usage: $0 [param] [arg]"
      echo "params can be one or more of the following :"
      echo "  -?, --help           : Print out this help message"
      echo "  -l, --logfile <name> : The name of log file"
      echo "  -t, --ostype  <os>   : Select OS type (win32, win64, linux32, linux64)"
      echo "  -v, --version        : Print out version number"
      echo
      exit 0
      ;;

    *)
      echo
      echo "Unrecognized parameter: $param"
      echo "Use \"$0 -?\" for params description"
      echo
      exit 1  
      ;;
  esac
done


# Eclipse Package
case $OS_TYPE in
  win32)   ECLIPSE_PKG="eclipse-cpp-kepler-SR2-win32.zip";;
  win64)   ECLIPSE_PKG="eclipse-cpp-kepler-SR2-win32-x86_64.zip";;
  linux32) ECLIPSE_PKG="eclipse-cpp-kepler-SR2-linux-gtk.tar.gz";;
  linux64) ECLIPSE_PKG="eclipse-cpp-kepler-SR2-linux-gtk-x86_64.tar.gz";;
esac

# Eclipse Download Link
ECLIPSE_URL="http://mirror.netcologne.de/eclipse/technology/epp/downloads/release/kepler/SR2/$ECLIPSE_PKG"


# Toolchain Package
case $OS_TYPE in
  win32)   TOOLCHAIN_PKG="gcc-arm-none-eabi-4_8-2014q2-20140609-win32.zip";;
  win64)   TOOLCHAIN_PKG="gcc-arm-none-eabi-4_8-2014q2-20140609-win32.zip";;
  linux32) TOOLCHAIN_PKG="gcc-arm-none-eabi-4_8-2014q2-20140609-linux.tar.bz2";;
  linux64) TOOLCHAIN_PKG="gcc-arm-none-eabi-4_8-2014q2-20140609-linux.tar.bz2";;
esac

# Toolchain Download Link
TOOLCHAIN_URL="https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q2-update/+download/$TOOLCHAIN_PKG"


# JAVA JRE Package
case $OS_TYPE in
  win32)   JRE_TYPE="windows-i586.tar.gz";;
  win64)   JRE_TYPE="windows-x64.tar.gz";;
  linux32) JRE_TYPE="linux-i586.tar.gz";;
  linux64) JRE_TYPE="linux-x64.tar.gz";;
esac

# JRE Download Link
JAVA_PAGE=`curl http://www.oracle.com/technetwork/java/javase/downloads/index.html 2>/dev/null | sed -ne 's/.*href="\([/a-z]*jre7-downloads-[0-9]*\.html\)".*/\1/p'| uniq`
JAVA_URL=`curl http://www.oracle.com$JAVA_PAGE 2>/dev/null | sed -ne "s/.*\"filepath\":\"\(http.*jre-7.*-${JRE_TYPE}\)\".*/\1/p"`
JAVA_PKG=${JAVA_URL##*/}
JAVA_COOKIE_VAL=`echo "http://www.oracle.com$JAVA_PAGE" | sed -e 's/%/%25/g' -e 's/ /%20/g' -e 's/!/%21/g' -e 's/"/%22/g' -e 's/#/%23/g' -e 's/$/%24/g' -e 's/\&/%26/g' -e "s/'/%27/g" -e 's/(/%28/g' -e 's/)/%29/g' -e 's/\*/%2A/g' -e 's/+/%2B/g' -e 's/,/%2C/g' -e 's/-/%2D/g' -e 's#/#%2F#g' -e 's/:/%3A/g' -e 's/;/%3B/g' -e 's//%3E/g' -e 's/?/%3F/g' -e 's/@/%40/g' -e 's/\[/%5B/g' -e 's/\\\/%5C/g' -e 's/\]/%5D/g' -e 's/\^/%5E/g' -e 's/_/%5F/g' -e 's/\`/%60/g' -e 's/{/%7B/g' -e 's/|/%7C/g' -e 's/}/%7D/g' -e 's/~/%7E/g' -e 's/%24$//'`
JAVA_COOKIES="Cookie: gpw_e24=${JAVA_COOKIE_VAL}; oraclelicense=accept-securebackup-cookie"
#JAVA_COOKIES="Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"
                      


# Doxygen Package
case $OS_TYPE in
  win32)   DOXYGEN_PKG="doxygen-1.8.8.windows.bin.zip";;
  win64)   DOXYGEN_PKG="doxygen-1.8.8.windows.x64.bin.zip";;
  linux32) DOXYGEN_PKG="doxygen-1.8.8.linux.bin.tar.gz";;
  linux64) DOXYGEN_PKG="doxygen-1.8.8.linux.bin.tar.gz";;
esac

# Doxygen Download Link
DOXYGEN_URL="http://ftp.stack.nl/pub/users/dimitri/$DOXYGEN_PKG"
DOXYGEN_PLG="http://www.mcternan.me.uk/mscgen/software/mscgen-w32-0.20.zip"


# OpenOCD Package
case $OS_TYPE in
  win32 | win64)   
    OPENOCD_PKG="openocd-0.8.0-win.7z"
    OPENOCD_URL="http://www.freddiechopin.info/en/download/category/4-openocd?download=109%3Aopenocd-0.8.0";;
  linux32 | linux64) 
    OPENOCD_PKG="openocd-0.8.0-src.tar.gz"
    #OPENOCD_URL="git://repo.or.cz/openocd.git"
    OPENOCD_URL="http://downloads.sourceforge.net/project/openocd/openocd/0.8.0/openocd-0.8.0.tar.gz?r=&ts=1410613104&use_mirror=garr";;
esac


# EmbSysReg SVD Patch
SVDPATCH_URL="https://github.com/ErichStyger/mcuoneclipse/blob/master/EclipsePlugins/EmbSysReg/FSL_SVD_Patch%20V0.2%20for%20EmbSysRegV0.2.4.zip?raw=true"
SVDPATCH_PKG="fsl_svd_patch.zip"

# Project directories
WORKING_DIR=`pwd`
DOWNLOAD_DIR=$WORKING_DIR/download
RELEASE_DIR=$WORKING_DIR/release
SOURCES_DIR=$WORKING_DIR/sources/$OS_TYPE
TEMP_DIR=$WORKING_DIR/temp
LOG_FILE=$WORKING_DIR/${LOG_FILE}


if (( $DEBUG_LEVEL > 1 )); then
  echo ""
  echo "Internal Variables of $0:"
  echo "OS_TYPE       = $OS_TYPE"
  echo "LOG_FILE      = $LOG_FILE"
  echo "ECLIPSE_URL   = $ECLIPSE_URL"
  echo "TOOLCHAIN_URL = $TOOLCHAIN_URL"
  echo "JAVA_URL      = $JAVA_URL"
  echo ""
  exit 0
fi


# Print Message function
# Usage: print_msg [status_flag] "message"
#        status_flag - "I" -> "INFO", "W" -> "WARNING", "E" -> "ERROR"
function print_msg()
{
  local TIME=`date +%X`
  local MARK="INFO:"
  local MESSAGE=$1

  if [ "$#" -gt "1" ]; then
    case $1 in
      "E") MARK="ERROR:";;
      "W") MARK="WARNING:";;
      *) ;;
    esac

    MESSAGE=$2
  fi

  echo -e "[$TIME] $MARK ${MESSAGE}"
  echo -e "[$TIME] $MARK ${MESSAGE}" >> $LOG_FILE
}


# Prepare Directories function
function initialize_dirs()
{
  print_msg "Install Directories"

  [ ! -d ${DOWNLOAD_DIR} ] && mkdir ${DOWNLOAD_DIR}

  if [ -d ${RELEASE_DIR} ]; then
    #if exist release dir, remove it content
    rm -rfd ${RELEASE_DIR}/"$PROJECT_NAME"
  else
    mkdir -p ${RELEASE_DIR}
  fi 

  print_msg "Successfully Done \n"
}


# Download Package function
# Usage: download_package <package_url>
function download_package()
{
  local PKG_URL="$1"
  local PKG_NAME="${PKG_URL##*/}"
  local PKG_ARGS=""
  local PKG_PARAMS=""

  # shift to next parameter
  shift

  #[ "$DEBUG_LEVEL" == "0" ] && PKG_ARGS="-q " 

  # Parse arguments
  while [[ $# > 0 ]]; do
    param="$1" && shift
    case $param in
      -n) PKG_NAME="$1" && shift ;;
      -c) PKG_ARGS+="--no-cookies --no-check-certificate --header"; PKG_PARAMS="$1"; shift;;
      *)  print_msg "E" "Unrecognized parameter: $param"; exit 1;;
    esac
  done

  if [ ! -f ${DOWNLOAD_DIR}/${PKG_NAME} ]; then

    print_msg "Downloading package: ${PKG_NAME} \n"

    if [ "${PKG_PARAMS}" != "" ]; then
      wget ${PKG_ARGS} "${PKG_PARAMS}" -O ${DOWNLOAD_DIR}/${PKG_NAME} ${PKG_URL}
    else
      wget ${PKG_ARGS} -O ${DOWNLOAD_DIR}/${PKG_NAME} ${PKG_URL}
    fi

    if [ $? -ne 0 ]; then
      print_msg "E" "Download failed, exit ! \n"
      rm -f ${DOWNLOAD_DIR}/${PKG_NAME}
      exit 1
    fi

    print_msg "Successfully Done \n"
  fi
}


# Extract Package function
# Usage: install_package <pkg> <outdir> [pproc]
#        pkg    - Package Archive
#        outdir - Install Directory
#        pproc  - Post-processing function
function install_package()
{
  local PKG_NAME="$1"
  local PKG_EXT=${PKG_NAME##*.}
  local PKG_OUTDIR="$2"
  local PKG_WORKDIR=${TEMP_DIR}
  local POSTPROC="$3"

  if [ ! -f ${DOWNLOAD_DIR}/${PKG_NAME} ]; then
    print_msg "E" "Package: $PKG_NAME doesn't exist, please download it first"
    exit 1
  fi

  if [ -d ${PKG_WORKDIR} ]; then
    rm -rfd ${PKG_WORKDIR}/*
  else
    mkdir ${PKG_WORKDIR}
  fi 

  print_msg "Install ${PKG_NAME} into $PKG_OUTDIR"

  # Parse arguments
  case $PKG_EXT in
    gz)  tar -xzf ${DOWNLOAD_DIR}/${PKG_NAME} -C ${PKG_WORKDIR} 2>&1 >> ${LOG_FILE} ;;
    bz2) tar -xjf ${DOWNLOAD_DIR}/${PKG_NAME} -C ${PKG_WORKDIR} 2>&1 >> ${LOG_FILE} ;;
    zip) unzip -q ${DOWNLOAD_DIR}/${PKG_NAME} -d ${PKG_WORKDIR} 2>&1 >> ${LOG_FILE} ;;
    7z)  7z x ${DOWNLOAD_DIR}/${PKG_NAME} -o${PKG_WORKDIR} 2>&1 >> ${LOG_FILE} ;;
    *) print_msg "E" "Unsupported archive: $PKG_EXT"; exit 1 ;;
  esac

  if [ $? -ne 0 ]; then
    print_msg "E" "Extraction failed, exit ! \n"
    rm -rfd ${PKG_WORKDIR}
    exit 1
  fi

  if [ "`ls ${PKG_WORKDIR} | wc -l`" == "1" ]; then
    PKG_WORKDIR="$PKG_WORKDIR/`ls ${TEMP_DIR}`"
  fi

  mkdir -p ${RELEASE_DIR}/${PKG_OUTDIR}

  if [ "$POSTPROC" != "" ]; then
    $POSTPROC "${PKG_WORKDIR}" "${RELEASE_DIR}/${PKG_OUTDIR}"
  else
    mv ${PKG_WORKDIR}/* ${RELEASE_DIR}/${PKG_OUTDIR}/
  fi

  rm -rfd ${TEMP_DIR}/*

  print_msg "Successfully Done \n"
}

# OpenOCD post-procesing function
# Usage: postproc_openocd <srcdir> <outdir>
function postproc_openocd()
{
  local SRC_DIR="$1"
  local OUT_DIR="$2"

  if [ "$OS_TYPE" == "win32" -o "$OS_TYPE" == "win64" ]; then

    if [ "$OS_TYPE" == "win64" ]; then
      rm -rfd ${SRC_DIR}/bin
      mv ${SRC_DIR}/bin-x64 ${SRC_DIR}/bin
    else
      rm -rfd ${SRC_DIR}/bin-x64
    fi

    mv ${SRC_DIR}/bin/openocd*.exe ${SRC_DIR}/bin/openocd.exe
    rm -rfd ${SRC_DIR}/source
    mv ${SRC_DIR}/* ${OUT_DIR}/

  else

    # Build OpenOCD
    cd ${SRC_DIR}
    mkdir build

    if [ "$BUILD_ARCH" == "x86_64" -a "$OS_TYPE" == "linux32" ]; then
      export CFLAGS="-m32"
    fi

    #./bootstrap && \
    ./configure --enable-maintainer-mode \
                --enable-cmsis-dap \
                --enable-hidapi-libusb \
                --prefix=${SRC_DIR}/build 2>&1 >> ${LOG_FILE}

    if [ $? -ne 0 ]; then
      print_msg "E" "OpenOCD configuration failed, exit ! \n"
      exit 1
    fi

    make -j 8 2>&1 >> ${LOG_FILE} && make install 2>&1 >> ${LOG_FILE}

    if [ $? -ne 0 ]; then
      print_msg "E" "OpenOCD compilation failed, exit ! \n"
      exit 1
    fi

    cp -rf build/bin build/share/openocd/

    make -j 9 pdf 2>&1 >> ${LOG_FILE} && {
      cp -rf doc/openocd.pdf build/share/openocd/OpenOCD_User’s_Guide.pdf
    }
  
    mv build/share/openocd/* ${OUT_DIR}/

    cd ${WORKING_DIR}

  fi
}

# Doxygen plugin post-procesing function
# Usage: postproc_doxyplg <srcdir> <outdir>
function postproc_doxyplg()
{
  local SRC_DIR="$1"
  local OUT_DIR="$2"

  cp -rf ${SRC_DIR}/bin/* ${OUT_DIR}/
}


# SVD patch post-procesing function
# Usage: postproc_svdpatch <srcdir> <outdir>
function postproc_svdpatch()
{
  local SRC_DIR="$1"
  local OUT_DIR="$2"

  cp -rf ${SRC_DIR}/eclipse/* ${OUT_DIR}/
}


# Install eclipse plugin
# Usage: install_eplugin <url> <plg> <desc>
function install_eplugin() 
{
  print_msg "Download and Install $3 plugin"

  local ECLIPSE_CMD="${RELEASE_DIR}/$PROJECT_NAME/eclipse"
  local WINE=""
  local MAX_ITER="6"

  case $OS_TYPE in
    win32) WINE="wine";   ECLIPSE_CMD="${ECLIPSE_CMD}c.exe";;
    win64) WINE="wine64"; ECLIPSE_CMD="${ECLIPSE_CMD}c.exe";;
  esac 

  if [ ! -f ${ECLIPSE_CMD} ]; then
    print_msg "E" "Eclipse doesn't installed, exit ! \n"
    exit 1 
  fi

  for N in {2..10}; do

    $WINE ${ECLIPSE_CMD} -application org.eclipse.equinox.p2.director -repository $1 -installIUs $2 -noSplash >> $LOG_FILE

    if [ $? -ne 0 ]; then
      if [ $N != $MAX_ITER ]; then
        print_msg "W" "Eclipse $3 plugin installation failed, try it again [ $N / $MAX_ITER ]"
        continue
      else
        print_msg "E" "Eclipse $3 plugin installation failed, exit ! \n"
        exit 1
      fi
    else
      break
    fi
  done

  print_msg "Installation Done \n"
}

# Create target archive function
# Usage: create_archive <arch_type>
#        arch_type: --gz, --zip
function create_archive()
{
  local BUILD_DATE=`date +%y%m%d%H%M` 
  local PACKAGE_NAME="${PROJECT_NAME}-${OS_TYPE}-${BUILD_DATE}"

  print_msg "Create package ${PACKAGE_NAME}"

  cd $RELEASE_DIR

  case $1 in
    --gz)  tar -czf ${PACKAGE_NAME}.tar.gz "$PROJECT_NAME";;
    --zip) zip -9 -q -r ${PACKAGE_NAME}.zip "$PROJECT_NAME";;
    *) print_msg "E" "Unsupported archive: $1"; exit 1 ;;
  esac

  if [ $? -ne 0 ]; then
    print_msg "E" "Compression failed, exit ! \n"
    rm -rfd ${PACKAGE_NAME}.*
    cd $WORKING_DIR
    exit 1
  fi

  cd $WORKING_DIR

  print_msg "Successfully Done \n"
}

#####################################################################################
# MAIN
#####################################################################################
echo "" > $LOG_FILE

# Initialization
initialize_dirs

# Download Packages
download_package "${ECLIPSE_URL}"
download_package "${TOOLCHAIN_URL}"
download_package "${JAVA_URL}" -c "${JAVA_COOKIES}"
download_package "${SVDPATCH_URL}" -n "$SVDPATCH_PKG"
download_package "${OPENOCD_URL}" -n "$OPENOCD_PKG"
if [ "$OS_TYPE" == "win32" -o "$OS_TYPE" == "win64" ]; then
  download_package "${DOXYGEN_URL}"
  download_package "${DOXYGEN_PLG}"
fi

# Install Packages
install_package "$ECLIPSE_PKG" "$PROJECT_NAME"
install_package "$TOOLCHAIN_PKG" "$PROJECT_NAME/toolchain"
install_package "$JAVA_PKG" "$PROJECT_NAME/jre"
install_package "$OPENOCD_PKG" "$PROJECT_NAME/tools/openocd" "postproc_openocd"
if [ "$OS_TYPE" == "win32" -o "$OS_TYPE" == "win64" ]; then
  install_package "${DOXYGEN_PKG}" "$PROJECT_NAME/tools/doxygen"
  install_package "${DOXYGEN_PLG##*/}" "$PROJECT_NAME/tools/doxygen" "postproc_doxyplg"
fi

# Install Eclipse plugins
#install_eplugin http://download.eclipse.org/releases/kepler org.eclipse.cdt.sdk.feature.group "C/C++ Development Tools SDK"
install_eplugin http://download.eclipse.org/releases/kepler org.eclipse.cdt.debug.gdbjtag.feature.group "C/C++ GDB Hardware Debugging"
install_eplugin http://gnuarmeclipse.sourceforge.net/updates ilg.gnuarmeclipse.managedbuild.cross.feature.group "GNU ARM Eclipse"
install_eplugin http://gnuarmeclipse.sourceforge.net/updates ilg.gnuarmeclipse.templates.cortexm.feature.group "Cortex-M Project Templates"
install_eplugin http://gnuarmeclipse.sourceforge.net/updates ilg.gnuarmeclipse.debug.gdbjtag.jlink.feature.group "ARM J-Link Debuger"
install_eplugin http://gnuarmeclipse.sourceforge.net/updates ilg.gnuarmeclipse.debug.gdbjtag.openocd.feature.group "OpenOCD Debuger"
install_eplugin http://gnuarmeclipse.sourceforge.net/updates ilg.gnuarmeclipse.templates.freescale.feature.group "Freescale Project Templates"
install_eplugin http://gnuarmeclipse.sourceforge.net/updates ilg.gnuarmeclipse.templates.stm.feature.group "STM32Fx Project Templates"
#install_eplugin http://gnuarmeclipse.sourceforge.net/updates ilg.gnuarmeclipse.packs.feature.group "GNU ARM Packs Support (Experimental)"
install_eplugin http://www.pemicro.com/eclipse/updates com.pemicro.debug.gdbjtag.pne.feature.feature.group "PEMicro Interface Debuger"
install_eplugin http://embsysregview.sourceforge.net/update org.eclipse.cdt.embsysregview.data_feature.feature.group "Embedded Systems Register View (Data)"
install_eplugin http://embsysregview.sourceforge.net/update org.eclipse.cdt.embsysregview_feature.feature.group "Embedded Systems Register View (SFR)"
install_eplugin http://ehep.sourceforge.net/update net.sourceforge.ehep.feature.group "HEX Editor"
install_eplugin http://download.gna.org/eclox/update org.gna.eclox.feature.group "Doxygen"
install_eplugin http://andrei.gmxhome.de/eclipse AnyEditTools.feature.group "Any Editor Tools"
install_eplugin http://chookapp.github.com/ChookappUpdateSite/ com.chookapp.org.Bracketeer.feature.group "Bracketeer"
install_eplugin http://chookapp.github.com/ChookappUpdateSite/ com.chookapp.org.BracketeerCDT.feature.group "BracketeerCDT"
#install_eplugin http://www.wickedshell.net/updatesite com.tetrade.eclipse.plugins.easyshell.feature.feature.group "Easy Shell Feature"

# Install Patch for Eclipse plugin: Embedded Systems Register View
install_package "$SVDPATCH_PKG" "$PROJECT_NAME" "postproc_svdpatch"

# Add configuration and tool files
cp -rf ${SOURCES_DIR}/*  ${RELEASE_DIR}/$PROJECT_NAME/  

# Create release package
if [ "$OS_TYPE" == "win32" -o "$OS_TYPE" == "win64" ]; then
  create_archive --zip
else
  create_archive --gz
fi

# Clean working dirs
print_msg "Clean"
rm -rfd ${TEMP_DIR}
rm -rfd ${RELEASE_DIR}/$PROJECT_NAME
print_msg "Successfully Done \n"

exit 0

