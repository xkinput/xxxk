!include "LogicLib.nsh"
!include "IniGetSectionNames.nsh"
!include "xxxkFuncBase.nsh"
!include "WinVer.nsh"

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
    ${xxxkReplaceIniSection} "$INSTDIR\entry\pinyin_entry.ini" "$R0" "pinyin"

    # 恢复变量的原值，并传回返回值
    Pop $R0
!macroend
!endif
!ifndef xxxkAddPinyinToIni
!define xxxkAddPinyinToIni "!insertmacro xxxkMacroAddPinyinToIni"
!endif

Function xxxkSubFuncAddSchemasToYongIniInTempDir
    Push "$R0" # [IM]n 的 n
    Push "$R1" # [IM]n 的值（即方案ID）
    Push "$R2" # [方案ID] 段所在的 ini 文件名
    ${ForEach} $R0 0 999 + 1
        ReadINIStr $R1 "$xxxkVarHomeDir\yong.ini" "IM" "$R0"
        ${IfNot} $R1 == ""
            # 恢复 [IM]n
            WriteINIStr "$TEMP\yong.ini" "IM" "$R0" "$R1"
            # 恢复相应的 [方案ID] 段
            ${xxxkFindIniContainingSchema} $R2 "$INSTDIR\entry" "$R1"
            ${IfNot} ${Errors}
                ${xxxkReplaceIniSection} "$INSTDIR\entry\$R2" "$TEMP\yong.ini" "$R1"
            ${Else}
                ${xxxkReplaceIniSection} "$xxxkVarHomeDir\yong.ini" "$TEMP\yong.ini" "$R1"
            ${EndIf}
        ${Else}
            ${Break}
        ${EndIf}
    ${Next}
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

Function xxxkSubFuncChkSchemasInYongIniInTempDir
    Push "$R0"
    ReadINIStr $R0 "$TEMP\yong.ini" "IM" "0"
    ${If} $R0 == ""
        ${xxxkAddPinyinToIni} "$TEMP\yong.ini"
    ${Else}
        Push "$R1" # [IM]default 对应的 n
        Push "$R2" # [IM]default 对应的方案ID
        ReadINIStr $R1 "$xxxkVarHomeDir\yong.ini" "IM" "default"
        ReadINIStr $R2 "$TEMP\yong.ini" "IM" "$R1"
        ${IfNotThen} $R2 == "" ${|} WriteINIStr "$TEMP\yong.ini" "IM" "default" "$R1" ${|}
        Pop $R2
        Pop $R1
    ${EndIf}
    Pop $R0
FunctionEnd

Function xxxkSubFuncSetYongIniInTempDir
    Delete "$TEMP\xxxkCustomizableKeys.ini"
    ${If} ${FileExists} "$xxxkVarHomeDir\xxxkCustomizableKeys.ini"
        CopyFiles /SILENT "$xxxkVarHomeDir\xxxkCustomizableKeys.ini" "$TEMP\xxxkCustomizableKeys.ini"
    ${Else}
        CopyFiles /SILENT "$INSTDIR\xxxkCustomizableKeys.ini" "$TEMP\xxxkCustomizableKeys.ini"
    ${EndIf}
    Push "$R0" # 段
    Push "$R1" # 键
    Push "$R2" # 值
    Push "$R3" # 计数器
    ${IniGetSectionNames} "$TEMP\xxxkCustomizableKeys.ini" xxxkSubFuncSetYongIniInTempDirCallBack
    Pop $R3
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

Function xxxkSubFuncSetYongIniInTempDirCallBack

    # 只能使用 $R0（段）、$R1（键）、$R2（值）、$R3（计数器）寄存器
	Pop $R0 # 段
	${If} $R0 == "BAZ"
		${IniGetSectionNames_StopEnum}
    ${ElseIf} $R0 == "IM"
    ${OrIf} $R0 == "main"
    ${OrIf} $R0 == "input"
    ${OrIf} $R0 == "key"
    ${OrIf} $R0 == "table"
        StrCpy $R1 "" # 键
        StrCpy $R3 "0"  # 计数器
        ${Do}
            ${EnumIniValue} $R1 "$TEMP\xxxkCustomizableKeys.ini" "$R0" $R3 # 查询指定 INI 文件中指定节里的第N个键（从 0 开始计数），返回键名。如果查询失败（没有更多的键了），则返回空字符串，并设置错误标志
            ${If} $R1 == ""
                ${Break}
            ${Else} 
                IntOp $R3 $R3 + 1
                ${xxxkReplaceIniKey} "$xxxkVarHomeDir\yong.ini" "$TEMP\yong.ini" "$R0" "$R1"
            ${EndIf}
        ${Loop}
	${EndIf}

FunctionEnd

Function xxxkSubFuncYongIni

    # 目标：以 $INSTDIR\yong.ini 为蓝本构建一个 yong.ini，
    #      尽可能地把先前已存在的 $xxxkVarHomeDir\yong.ini 的设置填入，
    #      成为新的 $xxxkVarHomeDir\yong.ini。

    # 如果 $xxxkVarHomeDir\yong.ini 不存在，为其补上 [IM]0，[IM]default 和 [pinyin] 段，结束整个流程；否则重建 $xxxkVarHomeDir\yong.ini。
    ${IfNot} ${FileExists} "$xxxkVarHomeDir\yong.ini"
        ${xxxkAddPinyinToIni} "$INSTDIR\yong.ini"
        Return
    ${EndIf}

    # 重建开始：以 $INSTDIR\yong.ini 为模板（其没有 [IM]0-n，[IM]default，[方案ID]），建立$TEMP\yong.ini（将来要替换 $xxxkVarHomeDir\yong.ini 的）
    Delete "$TEMP\yong.ini"
    CopyFiles /SILENT "$INSTDIR\yong.ini" "$TEMP\yong.ini"

    # 把 $xxxkVarHomeDir\yong.ini 的 [IM]0-n 和对应的 [方案ID] 段（优先从 $INSTDIR\entry 提取）恢复到 $TEMP\yong.ini。
    Call xxxkSubFuncAddSchemasToYongIniInTempDir

    # 检查 $TEMP\yong.ini 中是否有 [IM]0，
    # 如果没有：为其补上 [IM]0，[IM]default 和 [pinyin] 段。
    #   如果有：检查 $xxxkVarHomeDir\yong.ini 中 [IM]default 数值是否合理，如果合理，将 [IM]default 恢复到 $TEMP\yong.ini。
    Call xxxkSubFuncChkSchemasInYongIniInTempDir

    # 把 $xxxkVarHomeDir\yong.ini 剩下的 [IM],[main],[input],[key],[table] 段的部分设定（由 $TEMP\xxxkCustomizableKeys.ini 标记）恢复到 $TEMP\yong.ini。
    Call xxxkSubFuncSetYongIniInTempDir

    # 重建结束：把 $TEMP\yong.ini 作为新的 $xxxkVarHomeDir\yong.ini
    CopyFiles /SILENT "$TEMP\yong.ini" "$xxxkVarHomeDir\yong.ini"

FunctionEnd

Function xxxkFuncYongIni

    Var /GLOBAL xxxkVarHomeDir
    ${xxxkGetHomeDir} $xxxkVarHomeDir "$INSTDIR"
    ${If} "$xxxkVarHomeDir" == "$INSTDIR\.yong"
    ${OrIf} ${SectionIsSelected} ${optPortable}
        Call xxxkSubFuncYongIni
    ${Else}
        # 获取每个用户的 $xxxkVarHomeDir，并依次调用 xxxkSubFuncYongIni

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
                    StrCpy $xxxkVarHomeDir "$R0\$R2\AppData\Roaming"
                ${Else}
                    StrCpy $xxxkVarHomeDir "$R0\$R2\Application Data"
                ${EndIf}
                Call xxxkSubFuncYongIni
            ${EndIf}
            FindNext $R1 $R2
        ${Loop}
        FindClose $R1
        Pop $R3
        Pop $R2
        Pop $R1
        Pop $R0

        ${xxxkGetHomeDir} $xxxkVarHomeDir "$INSTDIR"
        Call xxxkSubFuncYongIni
    ${EndIf}

FunctionEnd

Function un.xxxkFuncYongIni

    ${If} ${Cmd} `MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "是否保留配置目录？" IDYES` # 只支持单一结果常量匹配
        Return
    ${EndIf}

    ${xxxkGetHomeDir} $xxxkVarHomeDir "$INSTDIR"
    ${If} "$xxxkVarHomeDir" == "$INSTDIR\.yong"
    ${OrIf} "$xxxkIsPortable" == "1"
        ${xxxkRMDir} "$xxxkVarHomeDir"  # RMDir /r "$xxxkVarHomeDir"
    ${Else}
        # 获取每个用户的 $xxxkVarHomeDir，并依次删除配置目录

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
                    StrCpy $xxxkVarHomeDir "$R0\$R2\AppData\Roaming"
                ${Else}
                    StrCpy $xxxkVarHomeDir "$R0\$R2\Application Data"
                ${EndIf}
                ${xxxkRMDir} "$xxxkVarHomeDir"  # RMDir /r "$xxxkVarHomeDir"
            ${EndIf}
            FindNext $R1 $R2
        ${Loop}
        FindClose $R1
        Pop $R3
        Pop $R2
        Pop $R1
        Pop $R0

        ${xxxkGetHomeDir} $xxxkVarHomeDir "$INSTDIR"
        ${xxxkRMDir} "$xxxkVarHomeDir"  # RMDir /r "$xxxkVarHomeDir"
    ${EndIf}

FunctionEnd