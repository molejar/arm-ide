#!/bin/bash

# Build architecture and OS
BUILD_ARCH=`uname -m`
BUILD_OS=`uname -o`

# Default OS type (win32, win64, linux32, linux64)
if [ "$BUILD_ARCH" == "x86_64" ]; then
  OS_TYPE="linux64"
else
  OS_TYPE="linux32"
fi

# Default eclipse version (kepler-SR2, luna-R, ...)
ECLIPSE_VER="kepler-SR2"

# Default Java JRE version (7 or 8)
JRE_VER="7"

# Default output package type
OUT_TYPE="zip"

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

    -t | --ostype)  [ "$1" != "" ] && OS_TYPE="$1" && shift ;;
    -e | --eclipse) [ "$1" != "" ] && ECLIPSE_VER="$1" && shift ;;
    -j | --jre-ver) [ "$1" != "" ] && JRE_VER="$1" && shift ;;
    -o | --out-pkg) [ "$1" != "" ] && OUT_TYPE="$1" && shift ;;
    -l | --logfile) [ "$1" != "" ] && LOG_FILE="$1" && shift ;;
    -d | --debug)   [ "$1" != "" ] && DEBUG_LEVEL="$1" && shift ;;

    -? | --help)
      echo
      echo "Usage: $0 [param] [arg]"
      echo "Params can be one or more of the following:"
      echo "  -?, --help           : Print out this help message"
      echo "  -t, --ostype  <os>   : Set host OS type (win32, win64, linux32, linux64)"
      echo "  -e, --eclipse <ver>  : Set eclipse version (kepler-SR2, luna-R, ...)"
      echo "  -j, --jre-ver <ver>  : Set Java JRE version (7 or 8)"
      echo "  -o, --out-pkg <type> : Set output package type (zip, gz, bz2, deb or exe)"
      echo "  -l, --logfile <name> : The name of log file"
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
  win32)   ECLIPSE_PKG="eclipse-cpp-${ECLIPSE_VER}-win32.zip";;
  win64)   ECLIPSE_PKG="eclipse-cpp-${ECLIPSE_VER}-win32-x86_64.zip";;
  linux32) ECLIPSE_PKG="eclipse-cpp-${ECLIPSE_VER}-linux-gtk.tar.gz";;
  linux64) ECLIPSE_PKG="eclipse-cpp-${ECLIPSE_VER}-linux-gtk-x86_64.tar.gz";;
esac

# Eclipse Download Link
ECLIPSE_URL="http://mirror.netcologne.de/eclipse/technology/epp/downloads/release/${ECLIPSE_VER/-/\/}/$ECLIPSE_PKG"


# Toolchain Package
case $OS_TYPE in
  win32)   TOOLCHAIN_PKG="gcc-arm-none-eabi-4_8-2014q2-20140609-win32.zip";;
  win64)   TOOLCHAIN_PKG="gcc-arm-none-eabi-4_8-2014q2-20140609-win32.zip";;
  linux32) TOOLCHAIN_PKG="gcc-arm-none-eabi-4_8-2014q2-20140609-linux.tar.bz2";;
  linux64) TOOLCHAIN_PKG="gcc-arm-none-eabi-4_8-2014q2-20140609-linux.tar.bz2";;
esac

# Toolchain Download Link
TOOLCHAIN_URL="https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q2-update/+download/$TOOLCHAIN_PKG"
TOOLCHAIN_VER="4.8-2014-q2"


# JAVA JRE Package
case $OS_TYPE in
  win32)   JRE_TYPE="windows-i586.tar.gz";;
  win64)   JRE_TYPE="windows-x64.tar.gz";;
  linux32) JRE_TYPE="linux-i586.tar.gz";;
  linux64) JRE_TYPE="linux-x64.tar.gz";;
esac

# JRE Download Link
JAVA_PAGE=`curl http://www.oracle.com/technetwork/java/javase/downloads/index.html 2>/dev/null | sed -ne "s/.*href=\"\([/a-z]*jre${JRE_VER}-downloads-[0-9]*\.html\)\".*/\1/p" | uniq`
JAVA_URL=`curl http://www.oracle.com$JAVA_PAGE 2>/dev/null | sed -ne "s/.*\"filepath\":\"\(http.*jre-${JRE_VER}.*-${JRE_TYPE}\)\".*/\1/p"`
JAVA_PKG=${JAVA_URL##*/}
JAVA_COOKIE_VAL=`echo "http://www.oracle.com$JAVA_PAGE" | sed -e 's/%/%25/g' -e 's/ /%20/g' -e 's/!/%21/g' -e 's/"/%22/g' -e 's/#/%23/g' -e 's/$/%24/g' -e 's/\&/%26/g' -e "s/'/%27/g" -e 's/(/%28/g' -e 's/)/%29/g' -e 's/\*/%2A/g' -e 's/+/%2B/g' -e 's/,/%2C/g' -e 's/-/%2D/g' -e 's#/#%2F#g' -e 's/:/%3A/g' -e 's/;/%3B/g' -e 's//%3E/g' -e 's/?/%3F/g' -e 's/@/%40/g' -e 's/\[/%5B/g' -e 's/\\\/%5C/g' -e 's/\]/%5D/g' -e 's/\^/%5E/g' -e 's/_/%5F/g' -e 's/\`/%60/g' -e 's/{/%7B/g' -e 's/|/%7C/g' -e 's/}/%7D/g' -e 's/~/%7E/g' -e 's/%24$//'`
JAVA_COOKIES="Cookie: gpw_e24=${JAVA_COOKIE_VAL}; oraclelicense=accept-securebackup-cookie"
#JAVA_COOKIES="Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"
                      

# Doxygen Version
DOXYGEN_VER="1.8.8"

# Doxygen Package
case $OS_TYPE in
  win32)   DOXYGEN_PKG="doxygen-${DOXYGEN_VER}.windows.bin.zip";;
  win64)   DOXYGEN_PKG="doxygen-${DOXYGEN_VER}.windows.x64.bin.zip";;
  linux32) DOXYGEN_PKG="doxygen-${DOXYGEN_VER}.linux.bin.tar.gz";;
  linux64) DOXYGEN_PKG="doxygen-${DOXYGEN_VER}.linux.bin.tar.gz";;
esac

# Doxygen Download Link
DOXYGEN_URL="http://ftp.stack.nl/pub/users/dimitri/$DOXYGEN_PKG"
DOXYGEN_PLG="http://www.mcternan.me.uk/mscgen/software/mscgen-w32-0.20.zip"

# OpenOCD Version
OPENOCD_VER="0.8.0"

# OpenOCD Package
case $OS_TYPE in
  win32 | win64)   
    OPENOCD_PKG="openocd-${OPENOCD_VER}-win.7z"
    OPENOCD_URL="http://www.freddiechopin.info/en/download/category/4-openocd?download=109%3Aopenocd-${OPENOCD_VER}";;
  linux32 | linux64) 
    OPENOCD_PKG="openocd-${OPENOCD_VER}-src.tar.gz"
    OPENOCD_URL="http://downloads.sourceforge.net/project/openocd/openocd/${OPENOCD_VER}/openocd-${OPENOCD_VER}.tar.gz";;
esac


# EmbSysReg SVD Patch
SVDPATCH_URL="https://github.com/ErichStyger/mcuoneclipse/blob/master/EclipsePlugins/EmbSysReg/FSL_SVD_Patch%20V0.2%20for%20EmbSysRegV0.2.4.zip?raw=true"
SVDPATCH_PKG="fsl_svd_patch.zip"


# Windows installer package
NSIS_URL="http://downloads.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46.zip"
NSIS_PKG=${NSIS_URL##*/}


# Project directories
WORKING_DIR=`pwd`
DOWNLOAD_DIR=$WORKING_DIR/download
RELEASE_DIR=$WORKING_DIR/release
SOURCES_DIR=$WORKING_DIR/sources/$OS_TYPE
TEMP_DIR=$WORKING_DIR/temp
LOG_FILE=$WORKING_DIR/${LOG_FILE}
NSIS_SCRIPT=$WORKING_DIR/armide.nsi


if [[ $DEBUG_LEVEL > 1 ]]; then
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


# Create Read-me file function
# Usage: add_info out_path
function add_info()
{
  local OUTFILE="$1/INFO.txt"

  touch $OUTFILE
  echo "**********************************************" >> $OUTFILE
  echo "$PROJECT_NAME - Eclipse based IDE for ARM MCUs" >> $OUTFILE
  echo "**********************************************" >> $OUTFILE
  echo "" >> $OUTFILE
  echo "Assembled from following packages:" >> $OUTFILE
  echo "- $ECLIPSE_PKG" >> $OUTFILE
  echo "- $JAVA_PKG" >> $OUTFILE
  echo "- $TOOLCHAIN_PKG" >> $OUTFILE
  echo "- $OPENOCD_PKG" >> $OUTFILE
  if [ "$OS_TYPE" == "win32" -o "$OS_TYPE" == "win64" ]; then
    echo "- $DOXYGEN_PKG" >> $OUTFILE
  fi
  echo "" >> $OUTFILE
}


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


# Extract package archive function
# Usage: extract <pkg_path> <out_dir> 
function extract()
{
  local PKG_PATH="$1"
  local PKG_EXT=${PKG_PATH##*.}
  local PKG_ODIR="$2"

  if [ ! -f ${PKG_PATH} ]; then
    print_msg "E" "Package: $PKG_PATH doesn't exist"
    exit 1
  fi

  # Parse arguments
  case $PKG_EXT in
    gz)  tar -xzf ${PKG_PATH} -C ${PKG_ODIR} 2>&1 >> ${LOG_FILE} ;;
    bz2) tar -xjf ${PKG_PATH} -C ${PKG_ODIR} 2>&1 >> ${LOG_FILE} ;;
    zip) unzip -q ${PKG_PATH} -d ${PKG_ODIR} 2>&1 >> ${LOG_FILE} ;;
    7z)  7z x ${PKG_PATH} -o${PKG_ODIR} 2>&1 >> ${LOG_FILE} ;;
    *) print_msg "E" "Unsupported archive: $PKG_EXT"; exit 1 ;;
  esac

  if [ $? -ne 0 ]; then
    print_msg "E" "Extraction failed, exit ! \n"
    rm -rfd ${PKG_ODIR}
    exit 1
  fi
}


# Compress source directory function
# Usage: compress <src_dir> <name> <arch> <out_dir> 
function compress()
{
  local SRC_PATH="$1"
  local PKG_NAME="$2"
  local PKG_EXT="$3"
  local PKG_ODIR="$4"

  if [ ! -d ${SRC_PATH} ]; then
    print_msg "E" "Package source $SRC_PATH doesn't exist"
    exit 1
  fi

  cd $SRC_PATH/..
  SRC_PATH=${SRC_PATH##*/}

  # Parse arguments
  case $PKG_EXT in
    gz)  PKG_NAME=${PKG_NAME}.tar.gz;  tar -czf "$PKG_NAME" "$SRC_PATH" 2>&1 >> ${LOG_FILE} ;;
    bz2) PKG_NAME=${PKG_NAME}.tar.bz2; tar -cjf "$PKG_NAME" "$SRC_PATH" 2>&1 >> ${LOG_FILE} ;;
    zip) PKG_NAME=${PKG_NAME}.zip; zip -9 -q -r "$PKG_NAME" "$SRC_PATH" 2>&1 >> ${LOG_FILE} ;;
    7z)  PKG_NAME=${PKG_NAME}.7z;  zip -9 -q -r "$PKG_NAME" "$SRC_PATH" 2>&1 >> ${LOG_FILE} ;;
    *) print_msg "E" "Unsupported archive: $PKG_EXT"; exit 1 ;;
  esac

  if [ $? -ne 0 ]; then
    print_msg "E" "Compression failed, exit ! \n"
    exit 1
  fi

  if [ "$PKG_ODIR" != "" ]; then
    mv ${PKG_NAME} $PKG_ODIR 
  fi

  cd $WORKING_DIR
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

  print_msg "Install $PKG_NAME into $PKG_OUTDIR"

  #extract package
  extract "$DOWNLOAD_DIR/$PKG_NAME" "$PKG_WORKDIR"

  if [ "`ls $PKG_WORKDIR | wc -l`" == "1" ]; then
    PKG_WORKDIR="$PKG_WORKDIR/`ls $TEMP_DIR`"
  fi

  mkdir -p ${RELEASE_DIR}/${PKG_OUTDIR}

  if [ "$POSTPROC" != "" ]; then
    $POSTPROC "$PKG_WORKDIR" "$RELEASE_DIR/$PKG_OUTDIR"
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
    rm -rfd ${SRC_DIR}/scripts/target/1986ве1т.cfg
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

    if [ "$BUILD_ARCH" == "x86_64" -a "$OS_TYPE" == "linux32" ]; then
      unset CFLAGS
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

  local MAX_ITER="6"
  local ECLIPSE_CMD="${RELEASE_DIR}/$PROJECT_NAME/eclipse"

  if [ "$OS_TYPE" == "win32" -o "$OS_TYPE" == "win64" ]; then
    ECLIPSE_CMD="${ECLIPSE_CMD}c.exe"
  fi

  if [ ! -f ${ECLIPSE_CMD} ]; then
    print_msg "E" "Eclipse doesn't installed, exit ! \n"
    exit 1 
  fi

  if [ "$BUILD_OS" == "GNU/Linux" ]; then
    case $OS_TYPE in
      win32) ECLIPSE_CMD="wine $ECLIPSE_CMD";;
      win64) ECLIPSE_CMD="wine64 $ECLIPSE_CMD";;
    esac 
  fi

  for N in {2..10}; do

    ${ECLIPSE_CMD} -application org.eclipse.equinox.p2.director -repository $1 -installIUs $2 -noSplash >> $LOG_FILE

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


function create_install_pkg()
{
  local NSIS_EXE=""
  local PKG_NAME="$1"

  print_msg "Create Windows installation package ${PKG_NAME}.exe"

  extract "$DOWNLOAD_DIR/$NSIS_PKG" "$TEMP_DIR"

  NSIS_EXE="wine $TEMP_DIR/`ls $TEMP_DIR`/makensis.exe"

  $NSIS_EXE "/XOutFile release/${PKG_NAME}.exe" \
            /DAPPNAME="$PROJECT_NAME" \
            /DAPPVER="$PROJECT_VNUM" \
            /DECLIPSEVER="$ECLIPSE_VER" \
            /DGNUARMVER="$TOOLCHAIN_VER" \
            /DJREVER="$JRE_VER" \
            /DOPENOCDVER="$OPENOCD_VER" \
            /DJLINKVER="4.90" \
            /DDOXYGENVER="$DOXYGEN_VER" \
            armide.nsi 2>&1 >> ${LOG_FILE}

  if [ $? -ne 0 ]; then
    print_msg "E" "Creating Windows installer failed, exit ! \n"
    exit 1
  fi

  print_msg "Successfully Done \n"
}


function create_debian_pkg()
{
  print_msg "Create debian package ${PKG_NAME}.deb"

  print_msg "Successfully Done \n"
}


function create_compress_pkg() 
{
  local PKG_NAME="$1"
  local PKG_EXT="$2"

  print_msg "Create release package ${PKG_NAME}.${PKG_EXT}"

  compress "$RELEASE_DIR/$PROJECT_NAME" "$PKG_NAME" "$PKG_EXT" "$RELEASE_DIR"

  print_msg "Successfully Done \n"
}


#####################################################################################
# MAIN
#####################################################################################
echo "" > $LOG_FILE

if [ "$OS_TYPE" == "linux32" -o "$OS_TYPE" == "linux64" -o "$OS_TYPE" == "win64" ]; then
  if [ "$OUT_TYPE" == "exe" ]; then
    print_msg "E" "Unsupported combination of args"
    exit 1
  fi
fi

if [ "$OUT_TYPE" == "deb" ]; then
  print_msg "E" "Unsupported output format yet"
  exit 1
fi

PACKAGE_NAME="${PROJECT_NAME}-${OS_TYPE}-`date +%y%m%d%H%M`"

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
  [ "$OUT_TYPE" == "exe" ] && download_package "${NSIS_URL}"
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
add_info "${RELEASE_DIR}/$PROJECT_NAME"  

# Create release package
case $OUT_TYPE in
  exe) create_install_pkg "$PACKAGE_NAME";;
  deb) create_debian_pkg "$PACKAGE_NAME";;
  zip | gz | bz2)   
       create_compress_pkg "$PACKAGE_NAME" "$OUT_TYPE";;
  *)   print_msg "E" "Unsupported output format: $OUT_TYPE"; exit 1;;
esac

# Clean working dirs
print_msg "Clean"
rm -rfd ${TEMP_DIR}
rm -rfd ${RELEASE_DIR}/$PROJECT_NAME
print_msg "Successfully Done \n"

exit 0

