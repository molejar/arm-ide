Eclipse based IDE for ARM MCUs
==============================


This repository doesn't contain a complete IDE but only a bash script for its automatic build in your PC. 


###It's assembled from this components:
* [Eclipse](http://www.eclipse.org/downloads/) - C/C++ Developers IDE.
* [Java JRE](http://java.com/en/download/manual.jsp?locale=en) - Java Runtime Environment.
* [GNU ARM Toolchain](https://launchpad.net/gcc-arm-embedded) - Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors.
* [Doxygen](http://www.stack.nl/~dimitri/doxygen/download.html) - Documentation generator from source code.
* [OpenOCD](http://openocd.sourceforge.net/) - Free and Open On-Chip Debugger.
* [OpenSDA](http://www.pemicro.com/opensda/index.cfm) - Freescale debug/programming interface.
* [Segger JLink](http://www.segger.com/jlink-software-beta-version.html) - must be installed manually into "sources/*/tools/segger_jlink".

###Has pre-installed the follow plug-ins:
* [GNU ARM Eclipse](http://gnuarmeclipse.livius.net/blog/) - set of eclipse plugins for create, build and debug ARM projects.
* [EmbSysRegView](http://embsysregview.sourceforge.net/) - plugin for monitoring and modifying the values of ARM peripheral registers.
* [PEMicro](http://www.pemicro.com/opensda/index.cfm) - add support of OpenSDA and OpenJTAG debuggers.
* [Eclox](http://home.gna.org/eclox/) - simple doxygen front-end for Eclipse.
* [EHEP](http://ehep.sourceforge.net/) - hex editor plugin.
* [AnyEdit](http://andrei.gmxhome.de/anyedit/index.html) - adds several new tools to the context menu of text-based Eclipse editors.
* [Bracketeer for C/C++](http://marketplace.eclipse.org/content/bracketeer-cc-cdt#.VBc7-nWSz0o) - show all what you need to know about the brackets in your code (highlight brackets, show information about closing brackets, etc...)


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
    $   -o, --out-pkg <type> : Set output package type (zip, gz, bz2, deb or exe)"
    $   -l, --logfile <name> : The name of log file
    $   -v, --version        : Print out version number
```

Run the script with correct args and wait till finish. If the build was successful, then the complete ArmIDE is located inside `release` directory.
