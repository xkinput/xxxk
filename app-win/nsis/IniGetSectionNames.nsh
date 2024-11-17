!include LogicLib.nsh
!ifndef NSIS_CHAR_SIZE
!define NSIS_CHAR_SIZE 1
!endif
 
!define IniGetSectionNames "!insertmacro IniGetSectionNames "
!define IniGetSectionNames_StopEnum 'StrCpy $3 "$\n"'
!define /math _IniGetSectionNames_MAXCCH 0xffff - 1 ; Should be plenty
 
!macro IniGetSectionNames _INI _FUNCNAME
!insertmacro _LOGICLIB_TEMP
GetFunctionAddress $_LOGICLIB_TEMP "${_FUNCNAME}"
Push "${_INI}"
Push $_LOGICLIB_TEMP
Call IniGetSectionNames
!macroend
 
Function IniGetSectionNames
Exch $1 ; enumfunc
Push $0 ; str
Push $2 ; mem & tmp
Push $3 ; len
Exch 4 ; .ini on top of stack
System::Call '*(&t${_IniGetSectionNames_MAXCCH})i.r2'
System::Call 'kernel32::GetPrivateProfileSectionNames(ir2r0,i${_IniGetSectionNames_MAXCCH},ts)'
Push $2
loop:
	System::Call 'kernel32::lstrlen(t)(i$0)i.r3' ; (t) is here to trigger A/W detection
	StrCmp $3 0 done
	System::Call '*$0(&t${NSIS_MAX_STRLEN}.r2)'
	IntOp $3 $3 + 1
!if ${NSIS_CHAR_SIZE} > 1
	IntOp $3 $3 * ${NSIS_CHAR_SIZE}
!endif
	IntOp $0 $0 + $3
	Push $0 ; Save
	Push $1 ; Save
	Push $2
	Call $1
	Pop $1
	Pop $0
	!ifdef IniGetSectionNames_StopEnum
	${If} $3 == "$\n"
		System::Call '*$0(&i${NSIS_CHAR_SIZE} 0)'
	${EndIf}
	!endif
	Goto loop
done:
Pop $2
System::Free $2
Pop $2
Pop $0
Pop $1
Pop $3
FunctionEnd