;ArmIDE NSIS Installer Script
;Written by Martin Olejar


!ifndef APPNAME
  !error "APPNAME undefined, please pass this in the command line."
!endif

!ifndef APPVER
  !error "APPVER undefined, please pass this in the command line."
!endif

!ifndef ECLIPSEVER
  !error "ECLIPSEVER undefined, please pass this in the command line."
!endif

!ifndef GNUARMVER
  !error "GNUARMVER undefined, please pass this in the command line."
!endif

!ifndef JREVER
  !error "JREVER undefined, please pass this in the command line."
!endif

!ifndef OPENOCDVER
  !error "OPENOCDVER undefined, please pass this in the command line."
!endif

!ifndef JLINKVER
  !error "JLINKVER undefined, please pass this in the command line."
!endif

!ifndef DOXYGENVER
  !error "DOXYGENVER undefined, please pass this in the command line."
!endif

!define PUBLISHER       "Martin Olejar"
!define EXEPATH         "$INSTDIR\eclipse.exe"
!define ICONPATH        "$INSTDIR\ArmIDE.ico"
!define UNINSTALLERPATH "$INSTDIR\Uninstall.exe"
!define REGKEY          "Software\${APPNAME}"
!define REGKEYUNINSTALL "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"


;----------------------------------------------------------------------------------------------------
;Include Modern UI
;----------------------------------------------------------------------------------------------------
!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "Sections.nsh"
!include "LogicLib.nsh"
!include "WinVer.nsh"
!include "x64.nsh"


;----------------------------------------------------------------------------------------------------
;General Settings
;----------------------------------------------------------------------------------------------------
Name "${APPNAME}"
;Default installation folder
InstallDir "$PROGRAMFILES\${APPNAME}"
;Registry key to check for directory (so if you install again, it will overwrite the old one)
InstallDirRegKey HKLM "${REGKEY}" "$INSTDIR"
;Request application privileges
RequestExecutionLevel user
;Compresion type
SetCompressor /SOLID lzma


;----------------------------------------------------------------------------------------------------
;MUI Interface Settings
;----------------------------------------------------------------------------------------------------
; Icons
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

; Header
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-r.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-uninstall-r.bmp"

; Wizard
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange-uninstall.bmp"

; Others
!define MUI_ABORTWARNING
!define MUI_COMPONENTSPAGE_SMALLDESC


;----------------------------------------------------------------------------------------------------
;MUI Pages
;----------------------------------------------------------------------------------------------------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES


;----------------------------------------------------------------------------------------------------
;User Functions
;----------------------------------------------------------------------------------------------------
Function InstallJlinkDrv
  ${If} ${RunningX64}
    ;Install JLink Debugger Driver
    ExecWait '"$INSTDIR\tools\segger_jlink\USBDriver\x64\DPInst.exe" \
    /C /Q /SA /SW /PATH "$INSTDIR\tools\segger_jlink\USBDriver\x64"'
    ;Install JLink VCOM Driver
    ExecWait '"$INSTDIR\tools\segger_jlink\USBDriver\CDC\dpinst_x64.exe" \
    /C /Q /SA /SW /PATH "$INSTDIR\tools\segger_jlink\USBDriver\CDC"'
  ${Else}
    ;Install JLink Debugger Driver
    ExecWait '"$INSTDIR\tools\segger_jlink\USBDriver\x86\DPInst.exe" \
    /C /Q /SA /SW /PATH "$INSTDIR\tools\segger_jlink\USBDriver\x86"'
    ;Install JLink VCOM Driver
    ExecWait '"$INSTDIR\tools\segger_jlink\USBDriver\CDC\dpinst_x86.exe" \
    /C /Q /SA /SW /PATH "$INSTDIR\tools\segger_jlink\USBDriver\CDC"'
  ${EndIf}
FunctionEnd


;----------------------------------------------------------------------------------------------------
;Call-Back Functions
;----------------------------------------------------------------------------------------------------
Function .onInit
  ${IfNot} ${AtLeastWinXP}
    MessageBox MB_OK "Windows XP and above required"
    Quit
  ${EndIf}

  ReadRegStr $0  "HKLM" "${REGKEYUNINSTALL}" "DisplayVersion"
  StrCmp "$0" "" done
  MessageBox MB_OK|MB_ICONEXCLAMATION "${APPNAME} version $0 is already installed. \
  First uninstall the old version if want install new." /SD IDOK
  Abort
  done:
FunctionEnd

Function .onInstFailed
FunctionEnd

Function .onInstSuccess
FunctionEnd


;----------------------------------------------------------------------------------------------------
;Languages
;---------------------------------------------------------------------------------------------------- 
!insertmacro MUI_LANGUAGE "English"


;----------------------------------------------------------------------------------------------------
;Installer Sections
;----------------------------------------------------------------------------------------------------
Section "Eclipse ${ECLIPSEVER} (required)" SecEclipse
  SectionIn RO
  SetOutPath "$INSTDIR"
  File /r /x "jre" /x "toolchain" /x "tools" "release\${APPNAME}\*"
SectionEnd

Section "GNU ARM Toolchain ${GNUARMVER} (required)" SecToolchain
  SectionIn RO
  SetOutPath "$INSTDIR\toolchain"
  File /r "release\${APPNAME}\toolchain\*"
SectionEnd

Section "JAVA JRE ${JREVER}" SecJava
  SetOutPath "$INSTDIR\jre"
  File /r "release\${APPNAME}\jre\*"
SectionEnd

Section "OpenOCD ${OPENOCDVER}" SecOpenOCD
  SetOutPath "$INSTDIR\tools\openocd"
  File /r "release\${APPNAME}\tools\openocd\*"
SectionEnd

Section "SEGGER JLink ${JLINKVER}" SecJlink
  SetOutPath "$INSTDIR\tools\segger_jlink"
  File /r "release\${APPNAME}\tools\segger_jlink\*"
SectionEnd

Section "Doxygen ${DOXYGENVER}" SecDoxygen
  SetOutPath "$INSTDIR\tools\doxygen"
  File /r "release\${APPNAME}\tools\doxygen\*"
SectionEnd

Section -post
  SetOutPath "$INSTDIR"
  
  ;create desktop shortcut
  CreateShortCut "$DESKTOP\${APPNAME}.lnk" "${EXEPATH}" "" "${ICONPATH}"

  ;create start-menu items
  CreateDirectory "$SMPROGRAMS\${APPNAME}"
  CreateShortCut  "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "${EXEPATH}"         "" "${ICONPATH}"
  CreateShortCut  "$SMPROGRAMS\${APPNAME}\Uninstall.lnk"  "${UNINSTALLERPATH}" "" ""
  CreateDirectory "$SMPROGRAMS\${APPNAME}\Manuals"
  ${If} ${SectionIsSelected} ${SecJlink}
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Manuals\JLinkARM Users Guide.lnk" \
    "$INSTDIR\tools\segger_jlink\JLinkARM.pdf" "" ""
  ${EndIf}
  ${If} ${SectionIsSelected} ${SecOpenOCD}
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Manuals\OpenOCD Users Guide.lnk" \
    "$INSTDIR\tools\openocd\OpenOCD.pdf" "" ""
  ${EndIf}
  ${If} ${SectionIsSelected} ${SecDoxygen}
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Manuals\Doxygen Users Guide.lnk" \
    "$INSTDIR\tools\doxygen\Doxygen.pdf" "" ""
  ${EndIf}

  ; Write the uninstall keys for Windows
  WriteRegStr   HKLM "${REGKEYUNINSTALL}" "DisplayName"      "${APPNAME}"
  WriteRegStr   HKLM "${REGKEYUNINSTALL}" "DisplayIcon"      "${ICONPATH}"
  WriteRegStr   HKLM "${REGKEYUNINSTALL}" "DisplayVersion"   "${APPVER}"
  WriteRegStr   HKLM "${REGKEYUNINSTALL}" "Publisher"        "${PUBLISHER}"
  WriteRegStr   HKLM "${REGKEYUNINSTALL}" "InstallLocation"  "$INSTDIR\"
  WriteRegStr   HKLM "${REGKEYUNINSTALL}" "UninstallString" '"${UNINSTALLERPATH}"'
  WriteRegDWORD HKLM "${REGKEYUNINSTALL}" "NoModify" 1
  WriteRegDWORD HKLM "${REGKEYUNINSTALL}" "NoRepair" 1

  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "${REGKEYUNINSTALL}" "EstimatedSize"    "$0"

  ;Create uninstaller
  WriteUninstaller "${UNINSTALLERPATH}"

  ;Install Drivers
  ${If} ${SectionIsSelected} ${SecJlink}
    Call InstallJlinkDrv
  ${EndIf}
SectionEnd


;----------------------------------------------------------------------------------------------------
;Uninstaller Section
;----------------------------------------------------------------------------------------------------
Section "Uninstall"
  ; Remove registry keys
  DeleteRegKey HKLM "${REGKEY}"
  DeleteRegKey HKLM "${REGKEYUNINSTALL}"

  ;Delete Desktop and Start Menu Shortcuts
  Delete "$DESKTOP\${APPNAME}.lnk"
  Delete "$SMPROGRAMS\${APPNAME}\Manuals\*.lnk"
  RmDir  "$SMPROGRAMS\${APPNAME}\Manuals"
  Delete "$SMPROGRAMS\${APPNAME}\*.lnk"
  RmDir  "$SMPROGRAMS\${APPNAME}"

  ;Remove uninstaller
  Delete "${UNINSTALLERPATH}"

  ;Remove all installed files
  RMDir /r "$INSTDIR"
SectionEnd


;----------------------------------------------------------------------------------------------------
;Components page descriptions
;----------------------------------------------------------------------------------------------------
LangString DESC_SecEclipse ${LANG_ENGLISH} \
"Eclipse CDT IDE for C/C++ developers with pre-installed plugins for ARM Embedded Processors"

LangString DESC_SecToolchain ${LANG_ENGLISH} \
"GNU Tools for ARM Embedded Processors (Cortex-M and Cortex-R)"

LangString DESC_SecJava ${LANG_ENGLISH} \
"Java virtual machine required by Eclipse. Must be installed, if isn't"

LangString DESC_SecOpenOCD ${LANG_ENGLISH} \
"Open On-Chip Debugger and In-System Programmer"

LangString DESC_SecJlink ${LANG_ENGLISH} \
"SEGGER JLink Debugger and In-System Programmer (Beta Version)"

LangString DESC_SecDoxygen ${LANG_ENGLISH} \
"Open source tool for generating documentation from annotated C/C++ sources"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecEclipse}   $(DESC_SecEclipse)
!insertmacro MUI_DESCRIPTION_TEXT ${SecToolchain} $(DESC_SecToolchain)
!insertmacro MUI_DESCRIPTION_TEXT ${SecJava}      $(DESC_SecJava)
!insertmacro MUI_DESCRIPTION_TEXT ${SecOpenOCD}   $(DESC_SecOpenOCD)
!insertmacro MUI_DESCRIPTION_TEXT ${SecJlink}     $(DESC_SecJlink)
!insertmacro MUI_DESCRIPTION_TEXT ${SecDoxygen}   $(DESC_SecDoxygen)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
