!include "LogicLib.nsh"

!macro xxxkMacroKillYong

	# 变量 R0 用于记录 yong.exe 的句柄
	
	${Do}
	
		FindWindow $R0 "yong_main"
		${If} $R0 = 0
			${Break}
		${Else}
			SendMessage $R0 2 0 0 # 给窗口发送退出消息
			Sleep 500
		${EndIf}

	${Loop}

!macroend

Function xxxkFuncKillYong

	!insertmacro xxxkMacroKillYong

FunctionEnd

Function un.xxxkFuncKillYong

	!insertmacro xxxkMacroKillYong

FunctionEnd