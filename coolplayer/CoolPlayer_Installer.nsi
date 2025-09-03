; CoolPlayer NSIS Installer Script
; This script creates an installer for CoolPlayer audio player

;--------------------------------
; Include Modern UI
!include "MUI2.nsh"
!include "FileAssociation.nsh"

;--------------------------------
; General

; Name and file
Name "CoolPlayer"
OutFile "CoolPlayer_Setup.exe"

; Default installation folder
InstallDir "$PROGRAMFILES\CoolPlayer"

; Get installation folder from registry if available
InstallDirRegKey HKCU "Software\CoolPlayer" ""

; Request application privileges for Windows Vista/7/8/10/11
RequestExecutionLevel admin

;--------------------------------
; Variables
Var StartMenuFolder

;--------------------------------
; Interface Settings
!define MUI_ABORTWARNING
!define MUI_ICON "res\coolplayer.ico"
!define MUI_UNICON "res\coolplayer.ico"

;--------------------------------
; Pages

; Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "res\readme.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY

; Start Menu Folder Page Configuration
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\CoolPlayer" 
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Version Information
VIProductVersion "2.0.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "CoolPlayer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "A lightweight audio player with support for MP3, OGG, WAV, and FLAC"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "CoolPlayer Development Team"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© CoolPlayer Development Team"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "CoolPlayer Audio Player"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "2.0.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "2.0.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "InternalName" "coolplayer.exe"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "OriginalFilename" "coolplayer.exe"

;--------------------------------
; Installer Sections

Section "CoolPlayer (required)" SecCoolPlayer

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "builddir\coolplayer.exe"
  File "builddir\coolplayer.ini"
  File "builddir\default.m3u"
  
  ; Copy resource files
  SetOutPath $INSTDIR\res
  File "res\*.*"
  
  ; Store installation folder
  WriteRegStr HKCU "Software\CoolPlayer" "" $INSTDIR
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  ; Add to Add/Remove Programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer" \
                   "DisplayName" "CoolPlayer"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer" \
                   "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer" \
                   "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer" \
                   "DisplayIcon" "$INSTDIR\coolplayer.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer" \
                   "Publisher" "CoolPlayer Development Team"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer" \
                   "DisplayVersion" "2.0.0"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer" \
                     "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer" \
                     "NoRepair" 1

SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts" SecStartMenu

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    
    ; Create shortcuts
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortcut "$SMPROGRAMS\$StartMenuFolder\CoolPlayer.lnk" "$INSTDIR\coolplayer.exe"
    CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Uninstall CoolPlayer.lnk" "$INSTDIR\Uninstall.exe"
    
  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

Section "Desktop Shortcut" SecDesktop

  CreateShortcut "$DESKTOP\CoolPlayer.lnk" "$INSTDIR\coolplayer.exe"

SectionEnd

Section "File Associations" SecFileAssoc

  ; Register MP3 files
  ${registerExtension} "$INSTDIR\coolplayer.exe" ".mp3" "MP3 Audio File"
  
  ; Register OGG files  
  ${registerExtension} "$INSTDIR\coolplayer.exe" ".ogg" "OGG Vorbis Audio File"
  
  ; Register WAV files
  ${registerExtension} "$INSTDIR\coolplayer.exe" ".wav" "Wave Audio File"
  
  ; Register FLAC files
  ${registerExtension} "$INSTDIR\coolplayer.exe" ".flac" "FLAC Audio File"
  
  ; Register M3U playlist files
  ${registerExtension} "$INSTDIR\coolplayer.exe" ".m3u" "M3U Playlist File"
  
  ; Register PLS playlist files
  ${registerExtension} "$INSTDIR\coolplayer.exe" ".pls" "PLS Playlist File"

SectionEnd

;--------------------------------
; Descriptions

; Language strings
LangString DESC_SecCoolPlayer ${LANG_ENGLISH} "The core CoolPlayer application and required files."
LangString DESC_SecStartMenu ${LANG_ENGLISH} "Create shortcuts in the Start Menu."
LangString DESC_SecDesktop ${LANG_ENGLISH} "Create a shortcut on the Desktop."
LangString DESC_SecFileAssoc ${LANG_ENGLISH} "Associate audio file types (MP3, OGG, WAV, FLAC) and playlist files (M3U, PLS) with CoolPlayer."

; Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCoolPlayer} $(DESC_SecCoolPlayer)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} $(DESC_SecStartMenu)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} $(DESC_SecDesktop)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFileAssoc} $(DESC_SecFileAssoc)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CoolPlayer"
  DeleteRegKey HKCU "Software\CoolPlayer"

  ; Remove file associations
  ${unregisterExtension} ".mp3" "MP3 Audio File"
  ${unregisterExtension} ".ogg" "OGG Vorbis Audio File"
  ${unregisterExtension} ".wav" "Wave Audio File"
  ${unregisterExtension} ".flac" "FLAC Audio File"
  ${unregisterExtension} ".m3u" "M3U Playlist File"
  ${unregisterExtension} ".pls" "PLS Playlist File"

  ; Remove files and uninstaller
  Delete $INSTDIR\coolplayer.exe
  Delete $INSTDIR\coolplayer.ini
  Delete $INSTDIR\default.m3u
  Delete $INSTDIR\Uninstall.exe
  
  ; Remove resource files
  Delete $INSTDIR\res\*.*
  RMDir $INSTDIR\res

  ; Remove shortcuts, if any
  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
  Delete "$SMPROGRAMS\$StartMenuFolder\CoolPlayer.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall CoolPlayer.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"
  
  Delete "$DESKTOP\CoolPlayer.lnk"

  ; Remove directories used
  RMDir "$INSTDIR"

SectionEnd

;--------------------------------
; Functions

Function .onInit
  ; Check if CoolPlayer is already running
  System::Call 'kernel32::OpenMutex(i 0x100000, b 0, t "CoolPlayerMutex") i .R0'
  IntCmp $R0 0 notRunning
    System::Call 'kernel32::CloseHandle(i $R0)'
    MessageBox MB_OK|MB_ICONEXCLAMATION "CoolPlayer is currently running. Please close it first and then run setup again."
    Abort
  notRunning:
FunctionEnd

Function un.onInit
  ; Check if CoolPlayer is already running
  System::Call 'kernel32::OpenMutex(i 0x100000, b 0, t "CoolPlayerMutex") i .R0'
  IntCmp $R0 0 notRunning
    System::Call 'kernel32::CloseHandle(i $R0)'
    MessageBox MB_OK|MB_ICONEXCLAMATION "CoolPlayer is currently running. Please close it first and then run uninstaller again."
    Abort
  notRunning:
  
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove CoolPlayer and all of its components?" IDYES +2
  Abort
FunctionEnd
