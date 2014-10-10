Eclipse based IDE for ARM MCUs
==============================


This repository doesn't contain a complete IDE but only a bash script for its automatic build in your PC. So far I have tested it on Linux Mint 17, but it should working on all Ubuntu based distributions. You can use this script for generating a fully customized IDE for ARM Embedded Processors. As target OS it is supporting Linux and Windows in both versions 32bit/64bit. Thanks to [Wine](https://www.winehq.org) which must be installed on build PC you can generate the Windows Installer Package directly from Linux. This script has many useful options, which are described in "Usage" section 


## ArmIDE Overview

<p align="center">
  <img src="docs/debug_window.png" alt="ArmIDE: main window"/>
</p>

####It's assembled from this components:
* [Eclipse](http://www.eclipse.org/downloads/) - C/C++ Developers IDE.
* [Java JRE](http://java.com/en/download/manual.jsp?locale=en) - Java Runtime Environment required by Eclipse.
* [GNU ARM Toolchain](https://launchpad.net/gcc-arm-embedded) - Pre-built GNU Tools for ARM Embedded Processors (Cortex-M and Cortex-R).
* [Doxygen](http://www.stack.nl/~dimitri/doxygen/download.html) - Open source tool for generating documentation from annotated C/C++ sources.
* [OpenOCD](http://openocd.sourceforge.net/) - Open On-Chip Debugger and In-System Programmer.
* [OpenSDA](http://www.pemicro.com/opensda/index.cfm) - PEMicro Debugger for Freescale MCUs. 
* [Segger JLink](http://www.segger.com/jlink-software-beta-version.html) - must be installed manually into "sources/<os>/tools/segger_jlink".

####Has pre-installed the following plugins:
* [GNU ARM Eclipse](http://gnuarmeclipse.livius.net/blog/) - set of eclipse plugins for create, build and debug ARM projects.
* [EmbSysRegView](http://embsysregview.sourceforge.net/) - plugin for monitoring and modifying the values of ARM peripheral registers.
* [PEMicro](http://www.pemicro.com/opensda/index.cfm) - add support of OpenSDA and OpenJTAG debuggers.
* [Eclox](http://home.gna.org/eclox/) - simple doxygen front-end for Eclipse.
* [EHEP](http://ehep.sourceforge.net/) - hex editor plugin.
* [AnyEdit](http://andrei.gmxhome.de/anyedit/index.html) - adds several new tools to the context menu of text-based Eclipse editors.
* [Bracketeer for C/C++](http://marketplace.eclipse.org/content/bracketeer-cc-cdt#.VBc7-nWSz0o) - show all what you need to know about the brackets in your code (highlight brackets, show information about closing brackets, etc...)


## Build OS Requirements

You will need have a PC with OS Ubuntu Linux (or some other Ubuntu based distribution). At first you need update the install repositories and then you have install all the following packages. After that you will have a ready Linux OS for building the Windows version of ArmIDE.

``` bash
  $ sudo apt-get update
  $ sudo apt-get install wget curl wine zip unzip p7zip-full p7zip-rar rar git
```
If you want build the Linux version of ArmIDE, then you need install additional packages, primary required for compiling the OpenOCD debugger.

``` bash
  $ sudo apt-get install build-essential libtool autoconf texlive texinfo libusb-dev libusb-1.0-0-dev libhidapi-dev libhidapi-hidraw0
```

## Usage

Clone the project into your local directory

``` bash
  $ git clone git://github.com/molejar/arm-ide.git
```

Go inside `arm-ide` directory and run `./armide.sh -?` for list of supported arguments

``` bash
  $ ./armide.sh -?
  $
  $ Usage: ./armide.sh [param] [arg]
  $ Params can be one or more of the following:
  $   -?, --help           : Print out this help message
  $   -t, --ostype  <os>   : Set host OS type (win32, win64, linux32, linux64)
  $   -e, --eclipse <ver>  : Set eclipse version (kepler-SR2, luna-R, ...)
  $   -j, --jre-ver <ver>  : Set Java JRE version (7 or 8)
  $   -o, --out-pkg <type> : Set output package type (zip, gz, bz2, deb, bin or exe)
  $   -l, --logfile <name> : The name of log file
  $   -v, --version        : Print out version number
```

Run the script with correct args and wait till finish. If the build was successful, then the complete ArmIDE is located inside `release` directory.
