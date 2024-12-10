!include "LogicLib.nsh"
!include "IniGetSectionNames.nsh"
!include "xxxkFuncBase.nsh"
!include "WinVer.nsh"
#!define XXXK_DIR_HOME "..\..\home"
#!define XXXK_VER "2.0.2.0"
#!define XXXK_VER_DATE "20241212"
#Var /GLOBAL xxxkVarHomeDir # 变量不会自动提升，因此要放前面

# 把 pinyin 方案添加到目标 yong.ini
# 调用方法：${xxxkAddPinyinToIni} "目标ini"
# 参数均为传值
!ifmacrondef xxxkMacroAddPinyinToIni
!macro xxxkMacroAddPinyinToIni arg0
    # 备份要用到的变量
    Push "$R0" # 目标ini

    # 把传值型形参的值传给寄存器
    Push "${arg0}"
    Pop $R0

    # 可以随意使用变量了（但不能使用形参）
    WriteINIStr "$R0" "IM" "default" "0"
    WriteINIStr "$R0" "IM" "0" "pinyin"
    ${xxxkReplaceIniSection} "$INSTDIR\entry\pinyin.ini" "$R0" "pinyin"

    # 恢复变量的原值，并传回返回值
    Pop $R0
!macroend
!endif
!ifndef xxxkAddPinyinToIni
!define xxxkAddPinyinToIni "!insertmacro xxxkMacroAddPinyinToIni"
!endif

Function xxxkSubFuncAddSchemasToYongWinIni
    Push "$R0" # [IM]n 的 n
    Push "$R1" # [IM]n 的值（即方案ID）
    Push "$R2" # [方案ID] 段所在的 ini 文件名
    ${ForEach} $R0 0 999 + 1
        ReadINIStr $R1 "$xxxkVarHomeDir\yong.ini" "IM" "$R0"
        ${IfNot} $R1 == ""
            # 恢复 [IM]n
            WriteINIStr "$xxxkVarHomeDir\yong-win.ini" "IM" "$R0" "$R1"
            # 恢复相应的 [方案ID] 段
            ${xxxkFindIniContainingSchema} $R2 "$xxxkVarHomeDir\entry" "$R1"
            ${IfNot} ${Errors}
                ${xxxkReplaceIniSection} "$xxxkVarHomeDir\entry\$R2" "$xxxkVarHomeDir\yong-win.ini" "$R1"
            ${Else}
                ${xxxkReplaceIniSection} "$xxxkVarHomeDir\yong.ini" "$xxxkVarHomeDir\yong-win.ini" "$R1"
            ${EndIf}
        ${Else}
            ${Break}
        ${EndIf}
    ${Next}
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

Function xxxkSubFuncChkSchemasInYongWinIni
    Push "$R0"
    ReadINIStr $R0 "$xxxkVarHomeDir\yong-win.ini" "IM" "0"
    ${If} $R0 == ""
        ${xxxkAddPinyinToIni} "$xxxkVarHomeDir\yong-win.ini"
    ${Else}
        Push "$R1" # [IM]default 对应的 n
        Push "$R2" # [IM]default 对应的方案ID
        ReadINIStr $R1 "$xxxkVarHomeDir\yong.ini" "IM" "default"
        ReadINIStr $R2 "$xxxkVarHomeDir\yong-win.ini" "IM" "$R1"
        ${IfNotThen} $R2 == "" ${|} WriteINIStr "$xxxkVarHomeDir\yong.ini" "IM" "default" "$R1" ${|}
        Pop $R2
        Pop $R1
    ${EndIf}
    Pop $R0
FunctionEnd

Function xxxkSubFuncSetYongWinIni

    ${If} ${FileExists} "$xxxkVarHomeDir\xxxkCustomizableKeys.ini"
        CopyFiles /SILENT "$xxxkVarHomeDir\xxxkCustomizableKeys.ini" "$TEMP\xxxkCustomizableKeys.ini"
    ${Else}
        SetOutPath "$TEMP"
        File ".\xxxkCustomizableKeys.ini"
    ${EndIf}

    Push "$R0" # 段
    Push "$R1" # 键
    Push "$R2" # 值
    Push "$R3" # 计数器
    ${IniGetSectionNames} "$TEMP\xxxkCustomizableKeys.ini" xxxkSubFuncSetYongWinIniCallBack
    Pop $R3
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

Function xxxkSubFuncSetYongWinIniCallBack

    # 只能使用 $R0（段）、$R1（键）、$R2（值）、$R3（计数器）寄存器
	Pop $R0 # 段
	${If} $R0 == "BAZ"
		${IniGetSectionNames_StopEnum}
    ${ElseIf} $R0 == "IM"
    ${OrIf} $R0 == "main"
    ${OrIf} $R0 == "input"
    ${OrIf} $R0 == "key"
    ${OrIf} $R0 == "table"
    ${OrIf} $R0 == "sync"
        StrCpy $R1 "" # 键
        StrCpy $R3 "0"  # 计数器
        ${Do}
            ${EnumIniValue} $R1 "$TEMP\xxxkCustomizableKeys.ini" "$R0" $R3 # 查询指定 INI 文件中指定节里的第N个键（从 0 开始计数），返回键名。如果查询失败（没有更多的键了），则返回空字符串，并设置错误标志
            ${If} $R1 == ""
                ${Break}
            ${Else} 
                IntOp $R3 $R3 + 1
                ${xxxkReplaceIniKey} "$xxxkVarHomeDir\yong.ini" "$xxxkVarHomeDir\yong-win.ini" "$R0" "$R1"
            ${EndIf}
        ${Loop}
	${EndIf}

FunctionEnd

Function xxxkSubFuncFilesInCurrentHome

    # 一、释放 data 里的资源文件：${XXXK_DIR_HOME} → $xxxkVarHomeDir

    SetOutPath "$xxxkVarHomeDir"
    File "${XXXK_DIR_HOME}\bd.txt"
    File "${XXXK_DIR_HOME}\bihua.bin"
    File "${XXXK_DIR_HOME}\crab.txt"
    File "${XXXK_DIR_HOME}\menu.ini"
    WriteINIStr "$xxxkVarHomeDir\menu.ini" "about" "exec" "$$MSG(v${XXXK_VER}-Build${XXXK_VER_DATE})"
    File "${XXXK_DIR_HOME}\README.txt"
    File "${XXXK_DIR_HOME}\urls.txt"
    File "${XXXK_DIR_HOME}\yong-win.ini"

    SetOutPath "$xxxkVarHomeDir\doc"
    File "${XXXK_DIR_HOME}\doc\LiangFenHandbook.pdf"
    File "${XXXK_DIR_HOME}\doc\yong.chm"
    File "${XXXK_DIR_HOME}\doc\xkjd6.chm"
    File "${XXXK_DIR_HOME}\doc\xklb.chm"
    File "${XXXK_DIR_HOME}\doc\xkxb.txt"
    File "${XXXK_DIR_HOME}\doc\xkyb.chm"

    SetOutPath "$xxxkVarHomeDir\entry"
    File /r "${XXXK_DIR_HOME}\entry\xkjd6_entry.ini"
    File /r "${XXXK_DIR_HOME}\entry\xklb_entry.ini"
    File /r "${XXXK_DIR_HOME}\entry\xkxb_entry.ini"
    File /r "${XXXK_DIR_HOME}\entry\xkyb_entry.ini"
    
    SetOutPath "$xxxkVarHomeDir\mb"
    File /r "${XXXK_DIR_HOME}\mb\xkbase"
    File /r "${XXXK_DIR_HOME}\mb\xkjd6"
    File /r "${XXXK_DIR_HOME}\mb\xklb"
    File /r "${XXXK_DIR_HOME}\mb\xkxb"
    File /r "${XXXK_DIR_HOME}\mb\xkyb"
    File "${XXXK_DIR_HOME}\mb\english.txt"

    SetOutPath "$xxxkVarHomeDir\skin"
    File "${XXXK_DIR_HOME}\skin\DarkYellow.zip"
    File "${XXXK_DIR_HOME}\skin\favicon.ico"
    File "${XXXK_DIR_HOME}\skin\xxxktray1.png"
    File "${XXXK_DIR_HOME}\skin\xxxktray2.png"

    SetOutPath "$xxxkVarHomeDir\tools"
    File "${XXXK_DIR_HOME}\tools\yong-config.bat"
    File "${XXXK_DIR_HOME}\tools\quit.bat"
    File "${XXXK_DIR_HOME}\tools\yong.bat"

    # 二、如果 $xxxkVarHomeDir\yong.ini 不存在，直接让 $xxxkVarHomeDir\yong-win.ini 成为它即可（需补上 [IM]0，[IM]default 和 [pinyin] 段）。
    ${IfNot} ${FileExists} "$xxxkVarHomeDir\yong.ini"
        ${xxxkAddPinyinToIni} "$xxxkVarHomeDir\yong-win.ini"
        Rename "$xxxkVarHomeDir\yong-win.ini" "$xxxkVarHomeDir\yong.ini"
        Return
    ${EndIf}

    # 三、如果 $xxxkVarHomeDir\yong.ini 存在，
    #     以 $xxxkVarHomeDir\yong-win.ini 为模板，
    #     尽可能地把先前已存在的 $xxxkVarHomeDir\yong.ini 的设置填入，
    #     最后使其成为新的 $xxxkVarHomeDir\yong.ini。

    # 3-1. 把 $xxxkVarHomeDir\yong.ini 的 [IM]0-n 和对应的 [方案ID] 段恢复到 $xxxkVarHomeDir\yong-win.ini。
    Call xxxkSubFuncAddSchemasToYongWinIni

    # 3-2. 检查 $xxxkVarHomeDir\yong-win.ini 中是否有 [IM]0，
    # 如果没有：为其补上 [IM]0，[IM]default 和 [pinyin] 段。
    #   如果有：检查 $xxxkVarHomeDir\yong.ini 中 [IM]default 数值是否合理，如果合理，将 [IM]default 恢复到 $xxxkVarHomeDir\yong-win.ini。
    Call xxxkSubFuncChkSchemasInYongWinIni

    # 3-3. 把 $xxxkVarHomeDir\yong.ini 中 [IM],[main],[input],[key],[table],[sync] 段的部分设定（由 $TEMP\xxxkCustomizableKeys.ini 标记）恢复到 $xxxkVarHomeDir\yong-win.ini。
    Call xxxkSubFuncSetYongWinIni

    # 3-4. 重建完成：把 $xxxkVarHomeDir\yong-win.ini 作为新的 $xxxkVarHomeDir\yong.ini
    Delete "$xxxkVarHomeDir\yong.ini"
    Rename "$xxxkVarHomeDir\yong-win.ini" "$xxxkVarHomeDir\yong.ini"

FunctionEnd

Function xxxkFuncFilesHome

    ${xxxkGetHomeDir} $xxxkVarHomeDir "$INSTDIR"

    # 配置目录在程序目录下，或者便携模式时，只需为当前用户安装
    ${If} "$xxxkVarHomeDir" == "$INSTDIR\.yong"
    ${OrIf} ${SectionIsSelected} ${optPortable}

        Call xxxkSubFuncFilesInCurrentHome

    # 其他情况，需为所有用户安装
    ${Else}

        # 获取每个用户的 $xxxkVarHomeDir，并依次调用 xxxkSubFuncFilesInCurrentHome
        SetShellVarContext current
        Push "$R0" # 形如 C:\Users（Win7+）或 C:\Documents and Settings (XP-)
        Push "$R1" # 搜索句柄
        Push "$R2" # 文件夹名
        Push "$R3" # 当前用户名
        ${GetParent} "$PROFILE" $R0
        UserInfo::GetName
        Pop $R3
        ClearErrors
        FindFirst $R1 $R2 "$R0\*.*" # 第一个变量代表本次搜索的句柄, 第二个变量代表文件名（不含路径），如果找不到文件了，其会被赋空值并设置错误标记。
        ${DoUntil} ${Errors}
            ${If} ${FileExists} "$R0\$R2\*.*"
            ${AndIf} "$R2" != "Public"
            ${AndIf} "$R2" != "Default"
            ${AndIf} "$R2" != "All Users"
            ${AndIf} "$R2" != "$R3"
            ${AndIf} "$R2" != ".."
            ${AndIf} "$R2" != "."
                ${If} ${AtLeastWin7}
                    StrCpy $xxxkVarHomeDir "$R0\$R2\AppData\Roaming\yong"
                ${Else}
                    StrCpy $xxxkVarHomeDir "$R0\$R2\Application Data\yong"
                ${EndIf}
                Call xxxkSubFuncFilesInCurrentHome
            ${EndIf}
            FindNext $R1 $R2
        ${Loop}
        FindClose $R1
        Pop $R3
        Pop $R2
        Pop $R1
        Pop $R0

        ${xxxkGetHomeDir} $xxxkVarHomeDir "$INSTDIR"
        Call xxxkSubFuncFilesInCurrentHome
    ${EndIf}

FunctionEnd

Function un.xxxkSubFuncFilesInCurrentHome

    Delete /REBOOTOK "$xxxkVarHomeDir\doc\LiangFenHandbook.pdf"
    Delete /REBOOTOK "$xxxkVarHomeDir\doc\yong.chm"
    Delete /REBOOTOK "$xxxkVarHomeDir\doc\xkjd6.chm"
    Delete /REBOOTOK "$xxxkVarHomeDir\doc\xklb.chm"
    Delete /REBOOTOK "$xxxkVarHomeDir\doc\xkxb.txt"
    Delete /REBOOTOK "$xxxkVarHomeDir\doc\xkyb.chm"
    RMDir "$xxxkVarHomeDir\doc" # 只删除空目录

    Delete /REBOOTOK "$xxxkVarHomeDir\entry\xkjd6_entry.ini"
    Delete /REBOOTOK "$xxxkVarHomeDir\entry\xklb_entry.ini"
    Delete /REBOOTOK "$xxxkVarHomeDir\entry\xkxb_entry.ini"
    Delete /REBOOTOK "$xxxkVarHomeDir\entry\xkyb_entry.ini"
    RMDir "$xxxkVarHomeDir\entry" # 只删除空目录

    Delete /REBOOTOK "$xxxkVarHomeDir\mb\xkbase\*.*"
    RMDir "$xxxkVarHomeDir\mb\xkbase" # 只删除空目录
    Delete /REBOOTOK "$xxxkVarHomeDir\mb\xkjd6\*.*"
    RMDir "$xxxkVarHomeDir\mb\xkjd6" # 只删除空目录
    Delete /REBOOTOK "$xxxkVarHomeDir\mb\xklb\*.*"
    RMDir "$xxxkVarHomeDir\mb\xklb" # 只删除空目录
    Delete /REBOOTOK "$xxxkVarHomeDir\mb\xkxb\*.*"
    RMDir "$xxxkVarHomeDir\mb\xkxb" # 只删除空目录
    Delete /REBOOTOK "$xxxkVarHomeDir\mb\xkyb\*.*"
    RMDir "$xxxkVarHomeDir\mb\xkyb" # 只删除空目录
    Delete /REBOOTOK "$xxxkVarHomeDir\mb\english.txt"
    RMDir "$xxxkVarHomeDir\mb" # 只删除空目录

    Delete /REBOOTOK "$xxxkVarHomeDir\skin\DarkYellow.zip"
    Delete /REBOOTOK "$xxxkVarHomeDir\skin\favicon.ico"
    Delete /REBOOTOK "$xxxkVarHomeDir\skin\xxxktray1.png"
    Delete /REBOOTOK "$xxxkVarHomeDir\skin\xxxktray2.png"
    RMDir "$xxxkVarHomeDir\skin" # 只删除空目录

    Delete /REBOOTOK "$xxxkVarHomeDir\tools\yong-config.bat"
    Delete /REBOOTOK "$xxxkVarHomeDir\tools\quit.bat"
    Delete /REBOOTOK "$xxxkVarHomeDir\tools\yong.bat"
    RMDir "$xxxkVarHomeDir\tools" # 只删除空目录

    Delete /REBOOTOK "$xxxkVarHomeDir\bd.txt"
    Delete /REBOOTOK "$xxxkVarHomeDir\bihua.bin"
    Delete /REBOOTOK "$xxxkVarHomeDir\crab.txt"
    Delete /REBOOTOK "$xxxkVarHomeDir\menu.ini"
    Delete /REBOOTOK "$xxxkVarHomeDir\README.txt"
    Delete /REBOOTOK "$xxxkVarHomeDir\urls.txt"
    Delete /REBOOTOK "$xxxkVarHomeDir\yong-win.ini"

    Delete /REBOOTOK "$xxxkVarHomeDir\xxxkCustomizableKeys.ini"
    Delete /REBOOTOK "$xxxkVarHomeDir\yong.ini"
    Delete /REBOOTOK "$xxxkVarHomeDir\yong.ini.old"
    Delete /REBOOTOK "$xxxkVarHomeDir\xkjd6.usr"
    Delete /REBOOTOK "$xxxkVarHomeDir\xklb.usr"
    Delete /REBOOTOK "$xxxkVarHomeDir\xkxb.usr"
    Delete /REBOOTOK "$xxxkVarHomeDir\xkyb.usr"
    RMDir "$xxxkVarHomeDir" # 只删除空目录

FunctionEnd

Function un.xxxkFuncFilesHome

    ${xxxkGetHomeDir} $xxxkVarHomeDir "$INSTDIR" # 这行必须在下面询问框的前面，以及时获得 $xxxkVarHomeDir 值，供 xxxkFuncUninstaller.nsh 使用。

    ${If} ${Cmd} `MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "是否保留配置目录？" IDYES` # 只支持单一结果常量匹配
        Return
    ${EndIf}

    # 配置目录在程序目录下，或者便携模式时，只需为当前用户卸载
    ${If} "$xxxkVarHomeDir" == "$INSTDIR\.yong"
    ${OrIf} "$xxxkIsPortable" == "1" # 此变量由 xxxkFuncUninstaller.nsh 的 un.onInit 函数生成
    
        Call un.xxxkSubFuncFilesInCurrentHome

    # 其他情况，需为所有用户卸载
    ${Else}

        # 获取每个用户的 $xxxkVarHomeDir，并依次调用 un.xxxkSubFuncFilesInCurrentHome

        SetShellVarContext current
        Push "$R0" # 形如 C:\Users（Win7+）或 C:\Documents and Settings (XP-)
        Push "$R1" # 搜索句柄
        Push "$R2" # 文件夹名
        Push "$R3" # 当前用户名
        ${GetParent} "$PROFILE" $R0
        UserInfo::GetName
        Pop $R3
        ClearErrors
        FindFirst $R1 $R2 "$R0\*.*" # 第一个变量代表本次搜索的句柄, 第二个变量代表文件名（不含路径），如果找不到文件了，其会被赋空值并设置错误标记。
        ${DoUntil} ${Errors}
            ${If} ${FileExists} "$R0\$R2\*.*"
            ${AndIf} "$R2" != "Public"
            ${AndIf} "$R2" != "Default"
            ${AndIf} "$R2" != "All Users"
            ${AndIf} "$R2" != "$R3"
            ${AndIf} "$R2" != ".."
            ${AndIf} "$R2" != "."
                ${If} ${AtLeastWin7}
                    StrCpy $xxxkVarHomeDir "$R0\$R2\AppData\Roaming\yong"
                ${Else}
                    StrCpy $xxxkVarHomeDir "$R0\$R2\Application Data\yong"
                ${EndIf}
                Call un.xxxkSubFuncFilesInCurrentHome
            ${EndIf}
            FindNext $R1 $R2
        ${Loop}
        FindClose $R1
        Pop $R3
        Pop $R2
        Pop $R1
        Pop $R0

        ${xxxkGetHomeDir} $xxxkVarHomeDir "$INSTDIR"
        Call un.xxxkSubFuncFilesInCurrentHome
    ${EndIf}

FunctionEnd