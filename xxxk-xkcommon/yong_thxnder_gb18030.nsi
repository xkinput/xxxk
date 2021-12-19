Function 目录
# 程序流程
#     预定义：头文件(!include)、页面属性、函数、区段等
#     主流程：.onInit函数→欢迎页→授权页→路径页(本例产生$INSTDIR)→.onVerifyInstDir函数(本例产生$yongdir)→组件页→各区段→开始菜单页(本例略)→进度页→完成页→.onInstSuccess函数
#
# 函数
#     定义：可以在函数体之外的地方定义。定义函数需用Function关键字，或者Section关键字（一类特殊的函数，又称为区段）。
#     调用：Section会被主程序自动调用；Function则（多数）只能在函数体内调用。
#
# 变量和常量
#     定义：可以在任何地方定义，变量定义形如Var /GLOBAL myvar，常量定义形如!define myconst "值"。变量和常量都是全局的。
#     赋值：变量的值可以使用Pop或StrCpy等函数改变。
#     引用：变量用$变量名，常量用${常量名}
#     其他：系统预定义了一些变量可以直接使用，例如$0、$INSTDIR等，参见《NSIS用户手册／4.2.2 其他可写的变量》；
#     也预定义了一些环境变量，例如$PROGRAMFILES等，参见《NSIS用户手册／4.2.3 常量》
FunctionEnd
#
# 常用函数
# IfFileExists path a b：如果文件存在，就跳转到a，否则跳转到b。跳转点可以是标号(lbl:),或以当前行为0的相对行号(+x, -x)
# CreateShortCut 快捷方式路径.lnk 目标文件 [参数 [图标文件 [图标索引号 [启动选项 [键盘快捷键 [描述]]]]]]
# Delete：删除文件，注意不能删除目录
# RMDir /r：删除目录，没有/r参数时只有在目录为空时才会被删除，如果指定了/r，则目录和子目录、文件均会被尝试删除；如果指定了/REBOOTOK，则删除失败的文件在重启后会被删除
# Rename 源文件路径 目标文件路径：也可以在同一盘符下移动目录，如果目标文件已存在或者目标文件父目录不存在，会导致移动失败
# CopyFiles /SILENT 源文件路径 目标目录路径：复制并覆盖文件
# StrCpy $0 "hello" N1 N2 把字符串从左往右数跳过N2位，然后截取N1位（默认""表示截取到尾部），保存到$0
# StrCmp $0 $R0 +1 +2 比较两个字符串$0和$R0（不分大小），若相等则跳到+1处，否则跳到+2处
# IntCmp类似
# IntOp 算数运算
# ReadRegStr 按根-项-键名读注册表键值到变量中，若不存在，则变量为空并且设置错误标记Errors
# ExecShell "open" "${PRODUCT_WEB_SITE}" 访问网页
# ExecShell "open" "$INSTDIR\tools\bat\yong.bat" 运行程序
# MessageBox MB_OK $INSTDIR

Function 预定义：头文件
#    仅用作注释
FunctionEnd
!include "MUI2.nsh"
#!include "TextFunc.nsh"
!include "x64.nsh" # 判断系统位数，可以用${If} ${RunningX64} ... ${Else} ... ${EndIf}判断位数，用${DisableX64FSRedirection}关闭64位系统上路径重定向到32位
!include "LogicLib.nsh" # 控制结构、判断函数支持，参考https://nsis.sourceforge.io/LogicLib
!include "WinVer.nsh" # 判断系统版本，用法http://nsis.sourceforge.net/Get_Windows_version
!include "FileFunc.nsh" # 文件遍历（如${Locate}）、路径处理，参见用户手册
!include "EnumIni.nsh" # ini文件内容遍历

Function 预定义：一些常量
#    仅用作注释
FunctionEnd
!define AppName "xxxk"
!define PRODUCT_NAME "小小星空"
!define PRODUCT_VERSION "1.0.4.0"
!define PRODUCT_VERSION_MINOR "20211219"
!define PRODUCT_PUBLISHER "thXnder"
!define PRODUCT_WEB_SITE "http://xkinput.github.io/xxxk-help"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

Function 预定义：安装包属性
#    参见《NSIS用户手册／4.8 安装程序属性》
FunctionEnd
RequestExecutionLevel admin # 请求管理员权限
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf" # Select Lang
# 安装包的名字等基本信息
Name ${PRODUCT_NAME}
SetCompressor /FINAL /SOLID lzma # 设置安装包压缩方式
OutFile "${PRODUCT_NAME}输入法-v${PRODUCT_VERSION}-Build${PRODUCT_VERSION_MINOR}.exe" # 安装包的名称
# 安装包文件属性里的版本信息
VIProductVersion "${PRODUCT_VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "dgod"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${PRODUCT_VERSION}"
# 安装包的一些界面定制
InstallDir $PROGRAMFILES\${AppName} # 设默认安装路径，$PROGRAMFILES对于64位系统为"C:\Program Files (x86)"，对于32位就是"C:\Program Files"；如果用$PROGRAMFILES64，那么对两种系统都是"C:\Program Files"
InstallDirRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" # 读取旧版本的安装路径
BrandingText ${PRODUCT_NAME}-${PRODUCT_WEB_SITE}
XPStyle on
ShowInstDetails show
DetailsButtonText "显示细节"
CompletedText "安装完成"

Function 预定义：页面属性
#     参见《NSIS图文教程集锦／基础／Modern UI教程》
FunctionEnd
# 全局设定
!define MUI_ABORTWARNING
!define MUI_ICON "skin\favicon.ico"
#
# 欢迎页（略）
# !define MUI_WELCOMEPAGE_TITLE "欢迎使用"
# !define MUI_WELCOMEPAGE_TEXT  "小小星空——$\r$\n$\r$\n    基于小小输入法平台的$\r$\n$\r$\n    星空系列输入法套装$\r$\n$\r$\n    "
# !insertmacro MUI_PAGE_WELCOME
#
# 授权页
!define MUI_PAGE_HEADER_TEXT "欢迎使用"
!define MUI_PAGE_HEADER_SUBTEXT "小小星空——基于小小输入法平台的星空系列输入法套装"
!define MUI_INNERTEXT_LICENSE_TOP "在继续安装之前，请仔细阅读本软件的授权协议："
!define MUI_INNERTEXT_LICENSE_BOTTOM "如果您点击了下面的「我接受」按钮并继续安装，代表您接受以上授权协议。"
!insertmacro MUI_PAGE_LICENSE "README.txt"
#
# 路径页
!define MUI_PAGE_HEADER_TEXT "安装路径"
!define MUI_DIRECTORYPAGE_TEXT_TOP "请选择${PRODUCT_NAME}的安装路径"
!define MUI_DIRECTORYPAGE_VARIABLE $INSTDIR # 加了这句，安装路径就会被保存到$INSTDIR变量里
!insertmacro MUI_PAGE_DIRECTORY
#
# 组件页
!define MUI_PAGE_HEADER_TEXT "组件选择"
!define MUI_PAGE_HEADER_SUBTEXT "定制安装选项"
!insertmacro MUI_PAGE_COMPONENTS

#
# 开始菜单页
# （略）
#
# 进度页
!define MUI_PAGE_HEADER_TEXT "正在安装"
!insertmacro MUI_PAGE_INSTFILES
#
# 完成页
!define MUI_FINISHPAGE_TITLE "安装完成"
!define MUI_FINISHPAGE_TEXT_LARGE
!define MUI_FINISHPAGE_TEXT "小小星空需要运行开始菜单或程序目录下的“小小星空”快捷方式后才能使用。$\n为了使用方便，将为您添加开机自启动，请您确认。"
!define MUI_FINISHPAGE_RUN # 若想直接运行程序，就!define MUI_FINISHPAGE_RUN xxx.exe，不需要下面的RUN_FUNCTION
!define MUI_FINISHPAGE_RUN_FUNCTION RunXxxk # 安装完成后执行指定函数
!define MUI_FINISHPAGE_RUN_TEXT "现在立刻运行 小小星空"
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "不要添加开机自启动（不建议勾选）"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION DelStartup
!define MUI_FINISHPAGE_LINK '阅读 使用说明'
!define MUI_FINISHPAGE_LINK_LOCATION ${PRODUCT_WEB_SITE} #$INSTDIR\doc\程序\小小小星空输入法用户手册.html
!insertmacro MUI_PAGE_FINISH
# 卸载确认页（略）
# !insertmacro MUI_UNPAGE_CONFIRM
#
# 语言页（略）
!insertmacro MUI_LANGUAGE "SimpChinese" ; 加载中文语言包（NSIS\Contrib\Language files\SimpChinese.nsh）
# !insertmacro MUI_LANGUAGE "English"
# !insertmacro MUI_RESERVEFILE_LANGDLL

Function 预定义：一些函数
# 注意：为避免寄存器冲突，本脚本将$0～$9用于区段，$R0～$R9用于函数，在调用函数后$R0～$R9的值可能会变
FunctionEnd
#
Function RunXxxk
		ExecShell "open" "$INSTDIR\tools\bat\rerun.bat"
Functionend
Function DelStartup ; 取消开机自启（只用于安装版，外挂版不会安装自启项）
		Delete "$SMSTARTUP\yong.lnk"
Functionend
#
Function SetSecChk
# 功能：勾选/取消勾选某一区段
# 输入参数：
    Pop $R1 # 是否勾选（1或0）
		Pop $R0 # ${区段标签}或id（注意隐藏区段也计入id）
# 输出参数：无
# 原理：「SectionGetFlags 区段 变量」可以读取区段Flags，「SectionSetFlags 区段 Flags」可以设置区段Flags。区段的Flags是一个多位整数，各位分别有不同含义：
# 第1位：是否选中，仅该位激活时对应的FLags为${SF_SELECTED}
# 第2位：是否是组，仅该位激活时对应的FLags为${SF_SECGRP}
# 第4位：是否加粗显示，仅该位激活时对应的FLags为${SF_BOLD}
# 第5位：是否只读，仅该位激活时对应的FLags为${SF_RO}
# 第6位：区段组是否展开，仅该位激活时对应的FLags为${SF_EXPAND}
# 第7位：区段组是否部分选中，仅该位激活时对应的FLags为${SF_PSELECTED}
    SectionGetFlags $R0 $R2 # 把区段的Flags记入$R2
    IntOp $R2 $R2 & 0       # 保留Flags的其他位，
    IntOp $R2 $R2 | $R1     # 并更新第1位（是否选中）
    SectionSetFlags $R0 $R1 # 更新区段的Flags
Functionend
# 利用宏简化该函数的调用方式为：「!insertmacro SetSecChk ${区段} 是否勾选」
!macro SetSecChk Sec isChecked
	Push ${Sec}
	Push ${isChecked}
	Call SetSecChk
!macroend
#
Function GetSecChk
# 功能：获取某一区段的选中状态
# 输入参数：
		Pop $R0 # ${区段标签}或id（注意隐藏区段也计入id）
# 输出参数：Push 1/0
    SectionGetFlags $R0 $R2 # 把区段的Flags记入$R2
    IntOp $R2 $R2 & 1       # 仅保留Flags的第1位（是否选中）
    Push $R2
Functionend
# 利用宏简化该函数的调用方式为：「!insertmacro GetSecChk 返回值容器 ${区段}」
!macro GetSecChk isChecked Sec
	Push ${Sec}
	Call GetSecChk
	Pop ${isChecked}
!macroend
#
Function IsParentDir
# 功能：判断目录0是否为目录1的父目录
# 输入参数：
		Pop $R1 # 目录1（疑似子目录）
		Pop $R0 # 目录0（疑似父目录）
# 输出参数：Push 1/0
		StrLen $R2 $R0       # 目录0的长度 → $R2
		StrCpy $R3 $R1 $R2   # 目录1的前半部分 → $R3
		StrCpy $R4 $R1 1 $R2 # 目录1的前半部分的下一个字符 → $R4

		${If}   $R4 == "\"
		${OrIf} $R4 == "/"
		${OrIf} $R4 == ""
		${AndIf} $R3 == $R0
		    Push 1
		${Else}
    		Push 0
		${EndIf}
FunctionEnd
# 利用宏简化该函数的调用方式为：「!insertmacro IsParentDir 返回值容器 目录0 目录1」
# 注意：!insertmacro调用时，若输入数据含空格，则必须赋值给变量再输入宏，不能直接把数据给宏
!macro IsParentDir isParent Dir0 Dir1
	Push ${Dir0}
	Push ${Dir1}
	Call isParentDir
	Pop ${isParent}
!macroend
#
Function CopyINIKey
# 功能：复制源ini中的指定键值到目标ini
# 输入参数：
		Pop $R0 # 源ini
		Pop $R1 # 目标ini
		Pop $R2 # 段名
		Pop $R3 # 键名
# 输出参数：无
		ReadINIStr $R4 $R0 $R2 $R3  # 读取键值到$R4
		StrCmp $R4 "" 0 +2
		DeleteINIStr $R1 $R2 $R3 # 如果值为空，则删除该键值对
		WriteINIStr $R1 $R2 $R3 $R4 # 如果值不为空，则覆盖该值
FunctionEnd
# 利用宏简化该函数的调用方式为：「!insertmacro CopyINIKey 源ini 目标ini 段名 键名」
# 注意：!insertmacro调用时，若输入数据含空格，则必须赋值给变量再输入宏，不能直接把数据给宏
!macro CopyINIKey src dest sec key
		Push ${key} # 键名
		Push ${sec} # 段名
		Push ${dest} # 目标ini
		Push ${src} # 源ini
		Call CopyINIKey
!macroend
#
Function CopyINISec
# 功能：复制源ini中，指定段下所有键值到目标ini
# 输入参数：
		Pop $R0 # 源ini
		Pop $R1 # 目标ini
		Pop $R2 # 段名
# 输出参数：无
		StrCpy $R3 0 # 遍历到第几个键（从0开始）
		loopBegin:
				${EnumIniValue} $R4 $R0 $R2 $R3 # 读取$R0文件的$R2段中的第$R3号(从0开始)键的名字，到$R4中
				StrCmp $R4 "" loopEnd
				ReadINIStr $R5 $R0 $R2 $R4  # 读取键值到$R5
				WriteINIStr $R1 $R2 $R4 $R5
				IntOp $R3 $R3 + 1
				Goto loopBegin
		loopEnd:
FunctionEnd
# 利用宏简化该函数的调用方式为：「!insertmacro CopyINISec 源ini 目标ini 段名」
# 注意：!insertmacro调用时，若输入数据含空格，则必须赋值给变量再输入宏，不能直接把数据给宏
!macro CopyINISec src dest sec
		Push ${sec} # 段名
		Push ${dest} # 目标ini
		Push ${src} # 源ini
		Call CopyINISec
!macroend
#
Function VerifyScheduleConfig
# 功能：验证yong.ini文件中某个名字的方案的配置文件有效性
# 输入参数：
		Pop $R0 # yong.ini
		Pop $R1 # 方案名字
# 输出参数：Push 0/1
    Push 1 # 默认有效
		${Do}
		    ReadINIStr $R2 $R0 $R1 "name"
		    ${If} $R2 == ""
		        Push 0
						${Break}
				${EndIf}
				
		    ReadINIStr $R2 $R0 $R1 "engine"
		    ${If} $R2 == ""
		        Push 0
						${Break}
				${EndIf}
				
		    ReadINIStr $R2 $R0 $R1 "arg"
		    ${If} $R2 == ""
		        Push 0
						${Break}
				${EndIf}
				
				${Break}
		${Loop}
FunctionEnd
# 利用宏简化该函数的调用方式为：「!insertmacro VerifyScheduleConfig 返回值容器 ini 方案名」
# 注意：!insertmacro调用时，若输入数据含空格，则必须赋值给变量再输入宏，不能直接把数据给宏
!macro VerifyScheduleConfig isValid ini name
		Push ${name} # 方案名字
		Push ${ini}  # yong.ini
		Call VerifyScheduleConfig
		Pop ${isValid} # 返回值
!macroend
#
Function 主流程
#    仅用作注释
FunctionEnd
#
Function .onInit
#    !insertmacro MUI_LANGDLL_DISPLAY ; 如果页面定义里开启了多语言，需要在这里调用
FunctionEnd
#
Function 欢迎页、授权页、路径页
#    仅用作注释
FunctionEnd
#
Function .onVerifyInstDir
		# 本段功能：判断小小输入法安装到用户选择的安装目录（$INSTDIR）时，其配置目录.yong目录的路径（$yongdir）
		# 判断逻辑：只要$INSTDIR在$PROGRAMFILES目录下，$yongdir将是$APPDATA\yong；否则就是$INSTDIR\.yong（外挂版小小则一定是$INSTDIR\.yong）
		# 输入参数：预定义常量、$INSTDIR
		# 相关常量：$PROGRAMFILES在64位系统为"C:\Program Files (x86)"，对于32位仍是"C:\Program Files"
		# 输出参数：$yongdir
		Var /GLOBAL yongdir
		!insertmacro IsParentDir $0 $PROGRAMFILES $INSTDIR
		${If} $0 == 1
		    StrCpy $yongdir $APPDATA\yong
		${Else}
		    StrCpy $yongdir $INSTDIR\.yong
		${EndIf}
FunctionEnd
#
Function 组件页
#    在组件页进行选择时会触发.onSelChange；选择完毕点下一步时会执行各区段里的代码。
FunctionEnd
#
Function .onSelChange

FunctionEnd
#
Function 区段
#    仅用作注释
FunctionEnd
# 区段就是组件页里的组件，用户在组件页里点「下一步」后，若该组件（区段）被选中，则会执行里面的代码
# 定义区段的语法：
# Section "区段标签" SecName ... SectionEnd：默认勾选的区段。若区段标签用!开头，则会加粗显示
# Section /o "区段标签" SecName ... SectionEnd：默认不勾选的区段。若区段标签以!开头，则会加粗显示
# Section "-区段标签" SecName ... SectionEnd：默认勾选的隐藏区段
# 引用区段的方法形如${SecName}
# 判断区段是否选中：${SectionIsSelected} ${SecPortable}
# 设置区段是否选中：SectionSetFlags ${SecXkjd6Dic} 0或1
# 多个区段可以被包裹在区段组SectionGroup /e "区段组标签" SecGroupName ... SectionGroupEnd里，以形成层次结构。/e表示默认展开区段组。
#
Section /o "便携安装（外挂模式）" SecPortable
		# 不干啥，仅用于判断该区段是否选中
SectionEnd

Section /o "重置设定" SecClearUser
		# 不干啥，仅用于判断该区段是否选中
SectionEnd

Section /o "[实验性]使用64位的界面程序" SecX64
		# 不干啥，仅用于判断该区段是否选中
SectionEnd

Section "-检查旧版" SecChkOldVer
		# 本区段输入变量：前文预定义的常量
		# 本区段输出变量：$oldver
    DetailPrint "检查程序版本..."
    
		Var /GLOBAL uninstpath # 旧版卸载程序的路径，形如XXX\uninstall.exe
		Var /GLOBAL oldver     # 旧版版本号
		Var /GLOBAL uninstdir  # 旧版卸载程序所在目录
		ClearErrors

		${Unless} ${SectionIsSelected} ${SecPortable} # 不选中「外挂模式」的情况下才执行以下代码

				check_xxjd3:
				ReadRegStr $uninstpath ${PRODUCT_UNINST_ROOT_KEY} "Software\Microsoft\Windows\CurrentVersion\Uninstall\小小键道3" "UninstallString"
				IfErrors check_xxjd6
				ReadRegStr $oldver ${PRODUCT_UNINST_ROOT_KEY} "Software\Microsoft\Windows\CurrentVersion\Uninstall\小小键道3" "DisplayVersion"
				MessageBox MB_YESNO|MB_ICONQUESTION "检测到小小键道3（版本：$oldver）的注册表项。必须先卸载它，才能继续安装。\
				                                     $\n$\n要我帮你卸载吗？" \
			             /SD IDYES IDYES uninst_xxjd3
				Abort

				uninst_xxjd3:
				StrCpy $uninstdir $uninstpath -13
			  ExecWait '"$uninstpath" /S _?=$uninstdir' $0
			  DetailPrint "uninstall.exe returned $0"
			  Delete "$uninstpath"
			  RMDir $uninstdir

				check_xxjd6:
				ReadRegStr $uninstpath ${PRODUCT_UNINST_ROOT_KEY} "Software\Microsoft\Windows\CurrentVersion\Uninstall\小小键道6" "UninstallString"
				IfErrors check_xxxk
				ReadRegStr $oldver ${PRODUCT_UNINST_ROOT_KEY} "Software\Microsoft\Windows\CurrentVersion\Uninstall\小小键道6" "DisplayVersion"
				MessageBox MB_YESNO|MB_ICONQUESTION "检测到小小键道6（版本：$oldver）的注册表项。必须先卸载它，才能继续安装。\
				                                     $\n$\n要我帮你卸载吗？" \
			             /SD IDYES IDYES uninst_xxjd6
				Abort

				uninst_xxjd6:
				StrCpy $uninstdir $uninstpath -13
			  ExecWait '"$uninstpath" /S _?=$uninstdir' $0
			  DetailPrint "uninstall.exe returned $0"
			  Delete "$uninstpath"
			  RMDir $uninstdir

				check_xxxk:
				ReadRegStr $uninstpath ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "UninstallString"
				IfErrors exitChk

				ReadRegStr $oldver ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "DisplayVersion"
				MessageBox MB_YESNO|MB_ICONQUESTION "检测到本机已经安装了 ${PRODUCT_NAME} $oldver。\
				                                           $\n$\n要覆盖升级吗？（程序目录下的数据可能会被覆盖，建议做好必要的备份）" \
				           /SD IDYES IDYES exitChk  #/SD指定静默安装模式下，自动应答对话框的值
				Abort
		${EndUnless}

		exitChk:
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecPortable} "仅释放文件，而不写注册表和TSF模块。$\r$\n$\r$\n适合想初步体验或者安装到U盘的用户。$\r$\n$\r$\n对一些程序的兼容不佳，不建议勾选。"
!insertmacro MUI_DESCRIPTION_TEXT ${SecClearUser} "重置用户对输入法进行的个性化设置（yong.ini）。"
!insertmacro MUI_DESCRIPTION_TEXT ${SecX64} "小小输入法主程序包括内核程序和界面程序。其中，内核程序通常是以32位、64位双模式同时运行的，而界面程序则以稳定的32位模式运行。勾选此项，可将界面程序更改为以64位模式运行。" # 作者推荐用32位（http://yong.dgod.net/read.php?tid=766）
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSel} "小小星空包含一系列输入方案，你可以选择性安装。"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXkjd6} "21键双拼+5键字根笔画，多种顶功方式，拆字逻辑简单，打词效率更高。"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXkyb} "26键双拼+5键笔画，双拼部分超级简单，自带模糊音。"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXkyd} "歌颂大佬脑洞大开，将一笔的双拼与键道的笔画融合起来，是否能兼济阴阳，青出于蓝？"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXklb} "25键声母+25键双笔+5键单笔，是对传统两笔的顶功改造，单字和词组效率都不错。"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXklbzv} "冉冉大佬在星空两笔的基础上把Z和V对调，以追求更舒适的手感。"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXklbdz} "右耍大佬在星空两笔的基础上，摒弃词组并优化重排单字，码长短且无无理码，适合普通人使用的纯单字方案。"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXklbddr} "DR大佬的星空两笔单字版，摒弃词组并优化重排单字，同时设置了少量二重和无理码。"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelPinyin} "普通的全拼方案，据说连接着搜狗云。"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXkxb} "星空星笔"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "-检查操作系统版本" SecChkOS
		# 本段功能：检测系统版本，对于Win8以上系统，告知用户必须安装在X:\Program Files (x86)（64位系统）或X:\Program Files（32位系统），才能在metro程序中使用
		# 本段输入变量：预定义常量、$INSTDIR
		# 本段输出变量：无
		DetailPrint "检查操作系统版本..."
		${IfNot} ${AtMostWin7}
		    !insertmacro IsParentDir $0 $PROGRAMFILES $INSTDIR # 判断$INSTDIR是否在$PROGRAMFILES里，结果记录到$0
				StrCmp $0 1 pathIsGood +1
		    MessageBox MB_YESNO|MB_ICONINFORMATION "Win8以上操作系统，建议将$PROGRAMFILES作为安装路径。\
																						 		$\n您依然要安装在$INSTDIR下吗？这会导致输入法无法在Metro应用中使用。" \
										/SD IDYES IDYES pathIsGood
				Abort
				pathIsGood:
		${EndIf}
SectionEnd

Section "-关闭yong.exe" SecChkYong
		# 本段功能：终止正在运行的yong.exe
		# 本段输入变量：预定义常量
		# 本段输出变量：无
		DetailPrint "检查正在运行的程序..."
		loopTerminateBegin:
		FindWindow $0 "yong_main"
		IntCmp $0 0 loopTerminateEnd
		# 不提示，直接终止
;		MessageBox MB_OKCANCEL "小小输入法主程序正在运行。\
;							   $\n$\n点击“确定”会强制关闭小小输入法然后继续安装，\
;							   $\n$\n点击“取消”将终止本次安装。" \
;				   /SD IDOK IDOK NoAbort
;		Abort
;		NoAbort:
		SendMessage $0 2 0 0 # 给窗口发送退出消息
		# 稍等后继续检测直至检测不到或用户选择取消
		Sleep 444
		Goto loopTerminateBegin
		loopTerminateEnd:
SectionEnd

Section "-释放主要文件" SecInstMainFiles
		# 本段功能：释放主要文件（不管是否外挂模式，这些文件都是必须要释放的）
		# 本段输入变量：预定义常量、$INSTDIR、$yongdir
		# 本段输出变量：无
		Detailprint "释放主要文件..."
		#
		# 安装64位主程序文件（到$INSTDIR\w64）。这些文件来自原版，未来可能会被小小输入法作者dgod更新。
 		SetOutPath $INSTDIR\w64
		File w64\libcloud.so
		File w64\libgbk.so
		File w64\libl.dll
		File w64\libmb.so
		File w64\yong.exe
		File w64\yong-config.exe
		File w64\yong-vim.exe
		# 安装32位主程序文件和相关资源文件。这些文件来自原版，未来可能会被小小输入法作者dgod更新
		SetOutPath $INSTDIR
		File yong.exe
		File yong-config.exe
		File yong-vim.exe
		File libmb.so
		File libgbk.so
		File libcloud.so
		File libl.dll
		File class.txt
		File README.txt
		#File yong.chm
		File normal.txt
		# 安装相关资源文件。这些文件来自xxxk，经过thXnder定制，且未来不太可能被dgod更新
		File bihua.bin
		File bd.txt
		File keyboard.ini
		File yong.ini # 默认设定文件，当用户设定文件$yongdir\yong.ini不存在时，才会采用该文件
		File menu.ini
		WriteINIStr $INSTDIR\menu.ini "about" "exec" "$$MSG(v${PRODUCT_VERSION}-Build${PRODUCT_VERSION_MINOR})" #里面不能用中文，否则会乱码
		File crab.txt
		File layout.txt
		File urls.txt
		#
		# 更新TSF模块（到$INSTDIR\tsf）
		Detailprint "更新TSF模块..."
		SetOutPath $INSTDIR\tsf
		# 解除yong.dll等
		${If} ${FileExists} $INSTDIR\tsf\yong.dll
				ExecWait '"$INSTDIR\tsf\tsf-reg.exe" -u -d' # 反注册旧版dll
				# 旧版dll反注册后，仍可能被已打开的程序占用，但可以改名，因此我们不直接删除，而是给文件名加上.del标记，等下次执行安装包时，再尝试删除
				StrCpy $1 0
				${While} ${FileExists} $INSTDIR\tsf\yong-$oldver-$1.del
						IntOp $1 $1 + 1
				${EndWhile}
				Rename $INSTDIR\tsf\yong.dll $INSTDIR\tsf\yong-$oldver-$1.del
		${EndIf}
		# 解除yong64.dll等（即使是32位的输入法，也可能会同时用到yong.dll和yong64.dll）
		${If} ${FileExists} $INSTDIR\tsf\yong64.dll
				ExecWait '"$INSTDIR\tsf\tsf-reg64.exe" -u -d' # 反注册旧版dll
				# 旧版dll反注册后，仍可能被已打开的程序占用，但可以改名，因此我们不直接删除，而是给文件名加上.del标记，等下次执行安装包时，再尝试删除
				StrCpy $1 0
				${While} ${FileExists} $INSTDIR\tsf\yong64-$oldver-$1.del
						IntOp $1 $1 + 1
				${EndWhile}
				Rename $INSTDIR\tsf\yong64.dll $INSTDIR\tsf\yong64-$oldver-$1.del
		${EndIf}
		# 释放其他tsf文件
		File tsf\yong.dll
		File tsf\yong64.dll
		File tsf\tsf-reg.exe
		File tsf\tsf-reg64.exe
		File tsf\install.bat # 外挂版可以通过执行install.bat文件升级为安装版
		File tsf\uninstall.bat
		Delete $INSTDIR\tsf\*.del # 删除带.del标记的文件，如果加上/REBOOTOK参数，可以在删除失败时提示重启
		#
		#
		# 本段功能：创建快捷方式、注册表项
		# 本段输入变量：预定义常量、$INSTDIR、$yongdir、$oldver
		# 本段输出变量：无
		
		${IfNot} ${RunningX64}
				!insertmacro SetSecChk ${SecX64} 0 # 防止在32位系统上强行勾选64位
		${EndIf}
		
		# 下面是仅用于安装版的部分
		${Unless} ${SectionIsSelected} ${SecPortable}
				# 释放卸载程序
				WriteUninstaller $INSTDIR\uninstall.exe
				# 写注册表
				Detailprint "写入注册表..."
				WriteRegStr HKCU "Control Panel\Desktop" "LowLevelHooksTimeout" 0x000003E8 # 修复注册表
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallProgram" "$INSTDIR\yong.exe"
				# 快捷方式
				Detailprint "创建快捷方式..."
				${If} ${SectionIsSelected} ${SecX64}
				    CreateShortCut "$INSTDIR\小小星空.lnk" "$INSTDIR\w64\yong.exe"
				${Else}
				    CreateShortCut "$INSTDIR\小小星空.lnk" "$INSTDIR\yong.exe"
				${EndIf}
				# 开始菜单
				Delete "$SMSTARTUP\yong.lnk"
				${If} ${SectionIsSelected} ${SecX64}
				    CreateShortCut "$SMSTARTUP\yong.lnk" "$INSTDIR\w64\yong.exe" # 快捷方式名必须为yong.lnk，才能和输入法的默认设置程序yong-config.exe配合
				${Else}
				    CreateShortCut "$SMSTARTUP\yong.lnk" "$INSTDIR\yong.exe" # 快捷方式名必须为yong.lnk，才能和输入法的默认设置程序yong-config.exe配合
				${EndIf}
				RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}" # 删除开始->程序->小小星空里的快捷方式，以重建
				CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\1.小小星空.lnk" "$INSTDIR\tools\bat\rerun.bat" "" "$INSTDIR\yong.exe"
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\2.重置小小.lnk" "$INSTDIR\tools\bat\reset.bat" "" "$WINDIR\System32\SHELL32.dll" 238
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\3.教程.lnk" "$INSTDIR\doc" "" "$WINDIR\System32\SHELL32.dll" 23
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\4.官网.lnk" ${PRODUCT_WEB_SITE} "" "$WINDIR\System32\SHELL32.dll" 17
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\5.网盘.lnk" "http://xxjd.ys168.com/" "" "$WINDIR\System32\SHELL32.dll" 17
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\6.卸载.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
				# 注册TSF模块（在64位操作系统上，即使只用32位的yong.exe，也需要同时注册32位和64位的dll）
				DetailPrint "注册TSF模块..."
				SetOutPath $INSTDIR\tsf
				ExecWait '"$INSTDIR\tsf\tsf-reg.exe" -i'
				ExecWait '"$INSTDIR\tsf\tsf-reg64.exe" -i'
		${EndUnless}
SectionEnd
Section "-安装皮肤、文档、脚本" SecInstOtherFiles
		# 安装皮肤（到$INSTDIR\skin）
		DetailPrint "安装皮肤..."
		SetOutPath $INSTDIR\skin
		File skin\*.* # 皮肤，键盘和图标文件，*.*表示不拷贝目录，只拷贝文件，这样就不会把我临时制作的皮肤（子目录）也一起弄进来了
		#
		# 安装文档（到$INSTDIR\doc\程序、$INSTDIR\doc\方案）
		DetailPrint "安装文档..."
		SetOutPath $INSTDIR\doc
		File /r doc\* # *表示包含目录，/r表示包含子目录
		#
 		# 安装脚本（到$INSTDIR\tools\vbs、$INSTDIR\tools\bat）
		DetailPrint "安装脚本..."
		Delete $INSTDIR\tools\bat\exit.bat # 先删掉历史遗留的旧脚本
		SetOutPath $INSTDIR\tools\vbs
		File /r tools\vbs\* # *表示包含目录，/r表示包含子目录
		SetOutPath $INSTDIR\tools\bat
		File /r tools\bat\*
		${If} ${SectionIsSelected} ${SecX64}
				Delete yong.bat
				Delete yong-config.bat
				Rename yong64.bat yong.bat
				Rename yong-config64.bat yong-config.bat
		${Else}
				Delete yong64.bat
				Delete yong-config64.bat
		${EndIf}
SectionEnd
Section "-安装码表" SecInstMbFiles
		DetailPrint "安装码表..."
		# 先把所有方案包释放到$TEMP\mb，再逐个转移到$INSTDIR\mb里（之所以这么做，而不直接用条件语句选择性释放方案包，是因为NSIS的一个机制是根据File命令自动判断要将哪些文件打包到安装包里，但如果File命令在条件语句中使用，该机制将失效，导致相应文件不会被编译到安装包里）
		RMDir /r $TEMP\mb
		SetOutPath $TEMP\mb
		File /r mb\*
		RMDir /r $INSTDIR\mb\delete
		SetOutPath $INSTDIR\mb\delete # 确保目录存在，以保证下一步要用的Rename命令顺利执行
		${Locate} "$TEMP\mb" "/L=D /G=0" "EachDirInMbTemp" # 遍历指定目录($TEMP\mb)下的一级(/G=0)子目录(/L=D)，对每个结果调用函数EachDirInMbTemp（作用是把该子目录转移到$INSTDIR\mb，$INSTDIR\mb下同名的目录将被转移到$INSTDIR\mb\delete）
		# 安装英文码表
		SetOutPath $INSTDIR\mb
		File mb\english.txt
		# 释放entry
		SetOutPath $INSTDIR\entry
		File entry\*.ini
SectionEnd
Function EachDirInMbTemp
		# $R6-大小  $R7-名字  $R8-父路径  $R9-父路径\名字
		${IfThen} ${FileExists} $INSTDIR\mb\$R7 ${|} Rename $INSTDIR\mb\$R7 $INSTDIR\mb\delete\$R7 ${|} # 如果不判断文件是否存在就用Rename，会导致遍历出错
		CopyFiles /SILENT $TEMP\mb\$R7\* $INSTDIR\mb\$R7
		Push $0
FunctionEnd
#
Section "-恢复yongdir\yong.ini" SecSetUser
# 本段功能：①以$INSTDIR\yong.ini为模板建立$TEMP\yong.ini，②恢复$yongdir\yong.ini中的部分设定到$TEMP\yong.ini（若在组件页中选了“重置设定”则跳过此步），③使$TEMP\yong.ini成为新的$yongdir\yong.ini
# 本段输入变量：预定义常量、$INSTDIR、$yongdir（因为使用了$yongdir，该区段必须放到.onVerifyInstDir函数之后）
# 本段输出变量：无
		Detailprint "更新配置文件..."
		Step1:
		Delete $TEMP\yong.ini
		CopyFiles /SILENT $INSTDIR\yong.ini $TEMP\yong.ini
#
		Step2:
		# 以下情况，不用恢复
		${IfThen} ${SectionIsSelected} ${SecClearUser} ${|} Goto Step3${|} # 勾选“重置设定”时
		${IfNotThen} ${FileExists} $yongdir\yong.ini ${|} Goto Step3 ${|} # $yongdir\yong.ini不存在时
		# 其余情况，进行恢复。先恢复以下容易恢复的设定。这些设定（非注释掉的项目）大多在yong-config.exe中也可以修改。
		# IM段（主程序相关）
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "cand"								# 候选数量
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "lang"								# 初始中英
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "s2t"								# 初始简繁
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "s2t_m"							# 简繁一对多转换
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "filter"								# 汉字过滤
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "enable"							# 外挂模式下，运行后自动激活状态条
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "skin"								# 皮肤
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "enter"							# 回车键行为
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "num"								# 大键盘数字键行为
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "keypad"							# 小键盘数字键行为
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "space"							# 空格类型
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "onspot"							# 预编辑开关
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "preedit"							# 预编辑风格
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "auto_move"							# 自动调频，优先于主码表中的设置
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "ABCD"							# SHIFT+字母直接出字母
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "CNen_commit"						# 按中英文切换键时，候选窗中的遗留编码如何处理
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "alt_bd_disable"						# 按住Alt键时，临时切换中英文标点状态
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "sym_in_num"							# 这些符号的全角模式若在数字后出现，自动变成半角
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "caps_bd"							# 中文模式+大写锁定时，标点中英状态
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "dict_en"							# 英文状态下联网查询网址
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "dict_cn"							# 中文状态下联网查询网址
		# main段（状态条相关）
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "tray"							# 显示托盘图标
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "noshow"							# 隐藏状态条
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "tran"							# 状态条半透明
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "pos"							# 状态条在屏幕上的位置
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "menu.ini"							# 设置菜单
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "tip"								# 操作反馈
		# input段（候选窗相关）
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "hint"							# 编码提示
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "root"							# 光标跟随
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "a_caret"							# 光标跟随方式
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "noshow"							# 隐藏候选窗
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "strip"							# 候选窗最多显示多长的编码
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "font"							# 候选项序号字体
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "select"							# 候选项序号样式
		# key段（热键相关）
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "trigger"							# 激活状态条的快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "select"							# 二三候选快捷键
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "select_n"							# 候选快捷键
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "CNen"							# 中英文切换快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "tEN"								# 特殊模式切换快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "switch"							# 输入方案切换快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "switch_default"						# 切换到默认输入方案的快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "switch_4"							# 切换到4号输入方案快捷键
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "page"							# 翻页快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "w2c"								# 以词定字快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "filter"							# 临时取消过滤的快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "move"							# 调词频的快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "ishow"							# 临时显示候选窗的快捷键
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "mshow"							# 临时显示状态条的快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "s2t"								# 简繁切换的快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "replace"							# 替换（好像没用）
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "query"							# 逆查编码的快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "dict"								# 联网查询的快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "bihua"							# 笔画模式引导键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "zi_switch"							# 单字模式切换快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "keyboard"							# 软键盘快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "corner"							# 全半角切换快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "biaodian"							# 中英文标点切换快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "tools[0]"							# 运行指定程序快捷键
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "keymap"							# 键位图快捷键
		# table段（码表相关）
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "table" "edit"							# 码表默认编辑器
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "table" "zi_mode"							# 单字模式
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "table" "adict"							# 设为1则把辅助码表也作为分码表加载
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "table" "wildcard"							# 万能键，优先于码表中的设置
#
    # 接下来恢复比较复杂的[IM]段序号键和[方案ID]段。
		# 首先应该知道：当$yongdir\yong.ini中，同一个方案的序号键和[方案ID]段应该保持“要么都有，要么都没有（可在yong-config.exe里添加）”的状态，而不能只有一者。
		#（如果只有序号键而没有相应的[方案ID]段，会导致yong-config.exe重复识别该方案的入口文件；如果只有[方案ID]而没有相应的序号键，会导致yong-config.exe识别不到该方案的入口文件）
		# 其次明确本次恢复的目标为：把$TEMP\yong.ini的[IM]段序号键和[方案ID]段尽量还原为$yongdir\yong.ini的状态。但是对于内置方案应进行覆盖更新，对于错误（如序号键和[方案ID]段缺一）应予以修正。
		#
		# $TEMP\yong.ini的初始状态：[IM]0=pinyin，[IM]default=0，[pinyin]段(仅示范、重置设定用)。请不要擅自在$INSTDIR\yong.ini中添加其他方案的序号键或[方案ID]段。
		DeleteINISec $TEMP\yong.ini pinyin # 先清空$TEMP\yong.ini中原有的[方案ID]段
		#
		# 遍历$yongdir\yong.ini中，[IM]段里序号键0~99的值——.
		#		A:若是本程序内置方案（判据：$INSTDIR\entry目录中存在相应的方案ID_entry.ini入口文件），就采用该序号键及方案ID_entry.ini里的[方案ID]段到$TEMP\yong.ini中
		#   B:否则，B1:若是无缺方案（存在相应的[方案ID]段），就采用该序号键及[方案ID]段到$TEMP\yong.ini中
		#						B2:若是有缺方案，则不采用该方案到$TEMP\yong.ini中（记得保证$TEMP\yong.ini中序号键的连续）
		# 占用一下$0~$9
		StrCpy $9 "-1" # $9用来记录$TEMP\yong.ini中的方案编号
		${For} $0 0 99 # $0用来遍历$yongdir\yong.ini中的方案编号
		    ReadINIStr $1 "$yongdir\yong.ini" "IM" "$0" # $1记录$0对应的方案ID
				${If} ${FileExists} "$INSTDIR\entry\$1_entry.ini"
				    # A
            IntOp $9 $9 + 1
						WriteINIStr "$TEMP\yong.ini" "IM" "$9" "$1"
						!insertmacro CopyINISec "$INSTDIR\entry\$1_entry.ini" "$TEMP\yong.ini" "$1" # 复制整段
				${Else}
				    # B
				    ReadINIStr $2 "$yongdir\yong.ini" "$1" "name"  # $2是一个flag，如果方案是无缺的，$2应不为空
				    ${IfNot} $2 == "" # B1
		            IntOp $9 $9 + 1
								WriteINIStr "$TEMP\yong.ini" "IM" "$9" "$1"
								!insertmacro CopyINISec "$yongdir\yong.ini" "$TEMP\yong.ini" "$1" # 复制整段
				    ${EndIf}
				${EndIf}
		${Next}
		#
		# $0~$8已释放，$9是$TEMP\yong.ini中的最大方案编号
		#
		# 尝试还原default（默认为0）
		WriteINIStr "$TEMP\yong.ini" "IM" "default" "0"
		ReadINIStr $0 "$yongdir\yong.ini" "IM" "default"
		ReadINIStr $1 "$yongdir\yong.ini" "IM" "$0" # 读取$yongdir\yong.ini的default方案ID到$1
    ReadINIStr $2 "$TEMP\yong.ini" "$1" "name"  # $2是一个flag，本次用于判断该方案ID在$TEMP\yong.ini中是否存在
		${IfNot} $2 == "" # 存在，进一步判断该方案ID在$TEMP\yong.ini中对应的序号键
				${For} $3 0 $9 # $3用来遍历$TEMP\yong.ini中的方案编号
				    ReadINIStr $4 "$TEMP\yong.ini" "IM" "$3" # 读取方案ID，到$4
				    ${If} $4 == $1
				        WriteINIStr "$TEMP\yong.ini" "IM" "default" "$3"
				    ${EndIf}
				${Next}
		${EndIf}
		# 变量已释放，$9可能还有用
		
		Step3:
		# 为了应急，确保存在pinyin方案
    ReadINIStr $2 "$TEMP\yong.ini" "pinyin" "name"  # $2是一个flag，如果有pinyin方案，$2应不为空
    ${If} $2 == ""
        IntOp $9 $9 + 1
				WriteINIStr "$TEMP\yong.ini" "IM" "$9" "pinyin"
				!insertmacro CopyINISec "$INSTDIR\entry\pinyin_entry.ini" "$TEMP\yong.ini" "pinyin" # 复制整段
    ${EndIf}
		# 只有1个方案（必为pinyin）时，追加键道方案
		${If} $9 < 1
	      IntOp $9 $9 + 1
				WriteINIStr "$TEMP\yong.ini" "IM" "$9" "xkjd6"
				!insertmacro CopyINISec "$INSTDIR\entry\xkjd6_entry.ini" "$TEMP\yong.ini" "xkjd6" # 复制整段
				WriteINIStr "$TEMP\yong.ini" "IM" "default" "1" # 把默认方案设为键道
    ${EndIf}
    # 应用配置文件
		CopyFiles /SILENT $TEMP\yong.ini $yongdir\yong.ini
		# 变量已释放，$9可能还有用
SectionEnd
#
Function .onInstSuccess
    # 问用户是否打开图形配置程序
		MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON1 "$\n是否为您打开图形化配置程序？$\n您可以在其中管理输入方案，或者进行一些个性化定制。$\n您也可以通过开始菜单或者输入法状态条来打开图形化配置程序。" \
				   /SD IDYES IDNO skip
		ExecShell "open" "$INSTDIR\tools\bat\yong-config.bat" # 打开配置程序
		skip:
FunctionEnd

Function 卸载程序
#    仅用作注释
FunctionEnd
# 从此，INSTDIR指uninstall.exe所在目录
# 卸载前
Function un.onInit
		MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" \
				   /SD IDYES IDYES +2
		Abort
FunctionEnd


# 卸载时
Section "Uninstall"
		# 检测并关闭主程序
		loop:
		FindWindow $0 "yong_main"
		IntCmp $0 0 done
		SendMessage $0 2 0 0
		Sleep 444
		Goto loop
		done:

		# 删除快捷方式
		RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"
		Delete "$SMSTARTUP\yong.lnk"
		Delete "$INSTDIR\*.lnk"

		# 反注册tsf
		IfFileExists "$INSTDIR\tsf\tsf-reg.exe" 0 +2
		ExecWait '"$INSTDIR\tsf\tsf-reg.exe" -u -d'

		IfFileExists "$INSTDIR\tsf\tsf-reg64.exe" 0 +2
		ExecWait '"$INSTDIR\tsf\tsf-reg64.exe" -u -d'

		# 删除yong目录下的主要文件
		RMDir /r "$INSTDIR\tsf"
		RMDir /r "$INSTDIR\mb"
		RMDir /r "$INSTDIR\skin"
		RMDir /r "$INSTDIR\w64"
		RMDir /r "$INSTDIR\entry"
		RMDir /r "$INSTDIR\doc"
		RMDir /r "$INSTDIR\tools"
		RMDir /r "$INSTDIR\userdict"
		Delete "$INSTDIR\yong.exe"
		Delete "$INSTDIR\yong-config.exe"
		Delete "$INSTDIR\yong-vim.exe"
		Delete "$INSTDIR\libmb.so"
		Delete "$INSTDIR\libgbk.so"
		Delete "$INSTDIR\libcloud.so"
		Delete "$INSTDIR\libl.dll"
		Delete "$INSTDIR\README.txt"
		Delete "$INSTDIR\yong.ini"
		Delete "$INSTDIR\class.txt"
		Delete "$INSTDIR\bd.txt"
		Delete "$INSTDIR\bihua.bin"
		Delete "$INSTDIR\keyboard.ini"
		Delete "$INSTDIR\normal.txt"
		Delete "$INSTDIR\learn.dat"
		Delete "$INSTDIR\yong.chm"
		Delete "$INSTDIR\menu.ini"
		Delete "$INSTDIR\crab.txt"
		Delete "$INSTDIR\layout.txt"
		Delete "$INSTDIR\urls.txt"

		# 删除自己
		Delete "$INSTDIR\uninstall.exe"

		# 处理用户设定.yong
		MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "是否保留用户设定？" \
		           /SD IDYES IDYES +3
		RMDir /r "$APPDATA\yong"
		RMDir /r "$INSTDIR\.yong"
		
		ExecShell "open" "$INSTDIR" # 打开给用户看

		# 删除注册表
		DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

SectionEnd

# 卸载后
Function un.onUninstSuccess
		HideWindow
		MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除！\
		                                     $\n安装目录如果有残留文件，重启后即可删除。\
											 									 $\n您也可以不重启直接安装新版的小小星空。" \
				   			/SD IDOK
FunctionEnd
