/*
File Association Helper Macros
Written by Saivert
Improved by ShellLinkTool

Usage in script:
1. !include "FileAssociation.nsh"
2. [Section|Function]
   ${registerExtension} "executable" "extension" "description"
   [SectionEnd|FunctionEnd]

Example:
${registerExtension} "$INSTDIR\myapp.exe" ".myext" "MyApp File"

*/

!ifndef FILEASSOCIATION_NSH
!define FILEASSOCIATION_NSH

!macro registerExtension executable extension description
Push "${executable}"  ; Push executable
Push "${extension}"   ; Push extension
Push "${description}" ; Push description
Call RegisterExtension
!macroend

!macro unregisterExtension extension description
Push "${extension}"   ; Push extension
Push "${description}" ; Push description  
Call un.UnRegisterExtension
!macroend

Function RegisterExtension
  ; input: 
  ;        top of stack  = description
  ;        top of stack-1 = extension 
  ;        top of stack-2 = executable
  ; Note: the order is reversed when using the !insertmacro call
  
  Exch $R2 ; Get description
  Exch 
  Exch $R1 ; Get extension
  Exch 2
  Exch $R0 ; Get executable
  
  ; Backup the previously associated file class
  ReadRegStr $R3 HKCR "${R1}" ""
  WriteRegStr HKCR "${R1}" "backup_val" "$R3"
  
  ; Create ProgID
  StrCpy $R3 "CoolPlayer${R1}"
  WriteRegStr HKCR "${R1}" "" "$R3"
  
  ; Create file type
  WriteRegStr HKCR "$R3" "" "${R2}"
  WriteRegStr HKCR "$R3\DefaultIcon" "" "$R0,0"
  WriteRegStr HKCR "$R3\shell" "" "open"
  WriteRegStr HKCR "$R3\shell\open" "" "&Open with CoolPlayer"
  WriteRegStr HKCR "$R3\shell\open\command" "" '$R0 "%1"'
  
  ; Add to OpenWith list
  WriteRegStr HKCR "$R3\shell\open" "FriendlyAppName" "CoolPlayer"
  
  ; Refresh shell
  System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'
  
  Pop $R0
  Pop $R1  
  Pop $R2
  Pop $R3
FunctionEnd

Function un.UnRegisterExtension
  ; input: 
  ;        top of stack  = description
  ;        top of stack-1 = extension
  
  Exch $R1 ; Get description
  Exch 
  Exch $R0 ; Get extension
  
  ; Restore the previously associated file class
  ReadRegStr $R2 HKCR "${R0}" "backup_val"
  WriteRegStr HKCR "${R0}" "" "$R2"
  DeleteRegValue HKCR "${R0}" "backup_val"
  
  ; Delete our ProgID
  StrCpy $R2 "CoolPlayer${R0}"
  DeleteRegKey HKCR "$R2"
  
  ; Refresh shell
  System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'
  
  Pop $R0
  Pop $R1
  Pop $R2
FunctionEnd

!define registerExtension "!insertmacro registerExtension"
!define unregisterExtension "!insertmacro unregisterExtension"

!endif ; FILEASSOCIATION_NSH
