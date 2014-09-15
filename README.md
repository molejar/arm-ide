----------------------------------------
ArmIDE - Eclipse based IDE for ARM MCUs
----------------------------------------


This repository doesn't contain a complete IDE but only a bash script for its automatic build in your PC. 


It's assembled from this components:
* [Eclipse IDE](http://www.eclipse.org/downloads/) for C/C++ Developers
* [JAVA JRE](http://java.com/en/download/manual.jsp?locale=en)
* [GCC ARM Toolchain](https://launchpad.net/gcc-arm-embedded)
* [Doxygen](http://www.stack.nl/~dimitri/doxygen/download.html)
* [OpenOCD Debugger](http://openocd.sourceforge.net/)
* [OpenSDA Debugger](http://www.pemicro.com/opensda/index.cfm)
* [Segger JLink Debugger](http://www.segger.com/jlink-software-beta-version.html) - must be installed manually into "sources/*/tools/segger_jlink"

Eclipse has preinstaled the follow plug-ins:
* [GNU ARM Eclipse](http://gnuarmeclipse.livius.net/blog/) - set of eclipse plugins for create, build and debug ARM projects
* [EmbSysRegView](http://embsysregview.sourceforge.net/) - plugin for monitoring and modifying ARM peripheral registers
* [PEMicro](http://www.pemicro.com/opensda/index.cfm) - add support of OpenSDA and OpenJTAG debuggers 
* [Eclox](http://home.gna.org/eclox/) - simple doxygen front-end for Eclipse
* [EHEP](http://ehep.sourceforge.net/) - hex editor plugin
* [AnyEdit](http://andrei.gmxhome.de/anyedit/index.html) - adds several new tools to the context menu of text-based Eclipse editors
* [Bracketeer for C/C++](http://marketplace.eclipse.org/content/bracketeer-cc-cdt#.VBc7-nWSz0o) - show all what you need to know about the brackets in your code (highlight brackets, show information about closing brackets, etc...)


## Usage

1. Clone the project into your local directory

``` bash
    $ git clone git://github.com/molejar/arm-ide.git
```

2. Go inside `arm-ide` directory and run `./armide.sh -?` for list of supported arguments

``` bash
    $ ./armide.sh -?
    $
    $ Usage: ./armide.sh [param] [arg]
    $ Params can be one or more of the following:
    $   -?, --help           : Print out this help message
    $   -t, --ostype  <os>   : Set host OS type (win32, win64, linux32, linux64)
    $   -e, --eclipse <ver>  : Set eclipse version (kepler-SR2, luna-R, ...)
    $   -j, --jre-ver <ver>  : Set Java JRE version (7 or 8)
    $   -c, --compres <type> : Set compression type (zip, gz, bz2)
    $   -l, --logfile <name> : The name of log file
    $   -v, --version        : Print out version number

```
