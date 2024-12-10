!include "LogicLib.nsh"
!include "EnumIni.nsh" # 有两个函数 ${EnumIniKey} 和 ${EnumIniValue}，但是前者有 bug 用不了
!include "WordFunc.nsh"
!include "x64.nsh"

# 提供一种比 RMDir /r "$INSTDIR\mb" 更安全的文件夹删除方法（不会删除符号链接）
# 调用方法：${xxxkRMDir} "目标文件夹路径"
# 所有参数均为传值
!ifmacrondef xxxkMacroRMDir
!macro xxxkMacroRMDir argPath
    ExecShellWait "" "cmd" `/c rmdir /s /q "${argPath}"`
!macroend
!endif
!ifndef xxxkRMDir
!define xxxkRMDir "!insertmacro xxxkMacroRMDir"
!endif


# 复制源 ini 文件中指定段的全部内容到目标 ini 文件里
# 调用方法：${xxxkUpdateIniSection} "源ini路径" "目标ini路径" "段"
# 所有参数均为传值
!ifmacrondef xxxkMacroUpdateIniSection
!macro xxxkMacroUpdateIniSection arg0 arg1 arg2 # "源ini路径" "目标ini路径" "段"
    # 备份寄存器到栈顶
    Push "$R0" # 源ini
    Push "$R1" # 目标ini
    Push "$R2" # 段
    Push "$R3" # 键
    Push "$R4" # 值
    Push "$R5" # 计数器

    # 把传值型形参的值传给寄存器
    Push "${arg0}"
    Push "${arg1}"
    Push "${arg2}"
    Pop $R2
    Pop $R1
    Pop $R0
    
    # 可以随意使用变量了（但不能使用形参）
    StrCpy $R3 "" # 键
    StrCpy $R4 "" # 值
    StrCpy $R5 0  # 计数器

    ${Do}
        ${EnumIniValue} $R3 "$R0" "$R2" $R5 # 查询指定 INI 文件中指定节里的第N个键（从 0 开始计数），返回键名。如果查询失败（没有更多的键了），则返回空字符串，并设置错误标志
        ${If} $R3 == ""
            ${Break}
        ${Else}
            IntOp $R5 $R5 + 1
            ReadINIStr $R4 "$R0" "$R2" "$R3"
            WriteINIStr "$R1" "$R2" "$R3" "$R4"
        ${EndIf}
    ${Loop}

    # 恢复临时变量的原值，并传回返回值
    Pop $R5
    Pop $R4
    Pop $R3
    Pop $R2
    Pop $R1
    Pop $R0
!macroend
!endif
!ifndef xxxkUpdateIniSection
!define xxxkUpdateIniSection "!insertmacro xxxkMacroUpdateIniSection" # 提供更简单的调用方式
!endif


# 复制源 ini 文件中指定段的全部内容到目标 ini 文件里（清空目标 ini 中原本的段）
# 调用方法：${xxxkReplaceIniSection} "源ini路径" "目标ini路径" "段"
# 所有参数均为传值
!ifmacrondef xxxkMacroReplaceIniSection
!macro xxxkMacroReplaceIniSection arg0 arg1 arg2 # "源ini路径" "目标ini路径" "段"
    DeleteINISec "${arg1}" "${arg2}"
    ${xxxkUpdateIniSection} "${arg0}" "${arg1}" "${arg2}"
!macroend
!endif
!ifndef xxxkReplaceIniSection
!define xxxkReplaceIniSection "!insertmacro xxxkMacroReplaceIniSection" # 提供更简单的调用方式
!endif


# 复制源 ini 文件中的指定键到目标 ini 文件里
# 调用方法：${xxxkReplaceIniKey} "源ini路径" "目标ini路径" "段" "键"
# 所有参数均为传值
!ifmacrondef xxxkMacroReplaceIniKey
!macro xxxkMacroReplaceIniKey arg0 arg1 arg2 arg3 # "源ini路径" "目标ini路径" "段" "键"
    # 备份寄存器到栈顶
    Push "$R0" # 源ini
    Push "$R1" # 目标ini
    Push "$R2" # 段
    Push "$R3" # 键
    Push "$R4" # 值

    # 把传值型形参的值传给寄存器
    Push "${arg0}"
    Push "${arg1}"
    Push "${arg2}"
    Push "${arg3}"
    Pop $R3
    Pop $R2
    Pop $R1
    Pop $R0
    
    # 可以随意使用变量了（但不能使用形参）
    ReadINIStr $R4 "$R0" "$R2" "$R3"
    ${If} ${Errors}
    ${AndIf} $R4 == ""
        DeleteINIStr "$R1" "$R2" "$R3"
    ${Else}
        WriteINIStr "$R1" "$R2" "$R3" "$R4"  # 把某个键值对写入指定 INI 文件。
    ${EndIf}

    # 恢复临时变量的原值，并传回返回值
    Pop $R4
    Pop $R3
    Pop $R2
    Pop $R1
    Pop $R0
!macroend
!endif
!ifndef xxxkReplaceIniKey
!define xxxkReplaceIniKey "!insertmacro xxxkMacroReplaceIniKey" # 提供更简单的调用方式
!endif

# 在给定目录中，非递归式地寻找包含指定 [方案ID] 段的第一个 ini 文件。返回文件名。如果找不到，就返回空文件名并设置错误标记。
# 调用方法：${xxxkFindIniContainingSchema} 返回值变量 "目录" "方案ID"
# 第一个参数传址，其余参数均为传值
!ifmacrondef xxxkMacroFindIniContainingSchema
!macro xxxkMacroFindIniContainingSchema arg0 arg1 arg2 # 返回值变量 "目录" "方案ID"
    # 备份要用到的临时变量
    Push "$R0" # 返回值变量
    Push "$R1" # 目录
    Push "$R2" # 方案ID"
    Push "$R3" # 搜索句柄
    Push "$R4" # 文件名

    # 获得传值型形参的值
    Push "${arg1}"
    Push "${arg2}"
    Pop $R2
    Pop $R1

    # 可以随意使用寄存器变量了（但不能使用形参）
    ClearErrors
    ReadINIStr $R0 "$R1\$R2_entry.ini" "$R2" "name"
    ${IfNot} ${Errors}
        StrCpy $R0 "$R2_entry.ini"
    ${Else}
        FindFirst $R3 $R4 "$R1\*.ini" # 第一个变量代表本次搜索的句柄, 第二个变量代表文件名（不含路径），如果找不到文件了，其会被赋空值并设置错误标记。
        ${DoUntil} ${Errors}
            ReadINIStr $R0 "$R1\$R4" "$R2" "name"
            ${IfNot} ${Errors}
                StrCpy $R0 "$R4"
                ${Break}
            ${EndIf}
            FindNext $R3 $R4
        ${Loop}
        FindClose $R3
    ${EndIf}
    ${IfThen} $R0 == "" ${|} SetErrors ${|}

    # 恢复传值型形参和寄存器变量的原值，并传回返回值
    Pop $R4
    Pop $R3
    Pop $R2
    Pop $R1
    Push "$R0"
    Exch
    Pop $R0
    Pop ${arg0}
!macroend
!endif
!ifndef xxxkFindIniContainingSchema
!define xxxkFindIniContainingSchema "!insertmacro xxxkMacroFindIniContainingSchema" # 提供更简单的调用方式
!endif

# 将一个文件有规律地重命名为“原文件名.数字序号.del”
# 调用方法：${xxxkMarkFileAsDel} "文件路径"
# 所有参数均为传值的，无返回值
!ifmacrondef xxxkMacroMarkFileAsDel
!macro xxxkMacroMarkFileAsDel arg0 # arg0 是文件路径
    # 备份要用到的临时变量
    Push "$R0" # 文件路径
    Push "$R1" # 计数器
    
    # 把传值型形参的值传给寄存器
    Push "${arg0}"
    Pop $R0

    # 可以随意使用变量了（但不能使用形参）
    StrCpy $R1 "0"
    ${DoWhile} ${FileExists} "$R0.$R1.del" 
        IntOp $R1 $R1 + 1
    ${Loop}
    Rename "$R0" "$R0.$R1.del"

    # 恢复临时变量的原值
    Pop $R1
    Pop $R0
!macroend
!endif
!ifndef xxxkMarkFileAsDel
!define xxxkMarkFileAsDel "!insertmacro xxxkMacroMarkFileAsDel" # 提供更简单的调用方式
!endif

# 判断当前账户是否为管理员
# 调用方法：${xxxkUserIsAdmin} 返回值变量
# 参数均为传值
!ifmacrondef xxxkMacroUserIsAdmin
!macro xxxkMacroUserIsAdmin arg0 # 可在宏体内用形如 ${arg0} 的形式引用形参。
    # 备份要用到的变量
    Push "$R0" # 返回值
    Push "$R1" # 账户类型

    # 可以随意使用变量了（但不能使用形参）
    StrCpy $R0 "0"
    UserInfo::GetAccountType
    Pop $R1
    ${If} $R1 == "Admin"
    ${OrIf} $R1 == "Power"
        StrCpy $R0 "1"
    ${EndIf}

    # 恢复变量的原值，并传回返回值
    Pop $R1
    Push "$R0"
    Exch
    Pop $R0
    Pop ${arg0}
!macroend
!endif
# 提供更简单的调用方式
!ifndef xxxkUserIsAdmin
!define xxxkUserIsAdmin "!insertmacro xxxkMacroUserIsAdmin"
!endif

# 修改组件框的状态
# 调用方法：${xxxkSetSectionState} ${区段ID} ${SF_XXX} 状态值
# 参数均为传值。第一个参数表示目标组件框，第二个常量表示要修改的状态种类，第三个值表示要修改成什么值（1表示真，其余表示假）。
!ifmacrondef xxxkMacroSetSectionState
!macro xxxkMacroSetSectionState arg0 arg1 arg2 # 可在宏体内用形如 ${arg0} 的形式引用形参。
    # 备份要用到的变量
    Push "$R0" # 区段ID
    Push "$R1" # 状态种类
    Push "$R2" # 状态值
    Push "$R3" # 用来记录区段的初始 Flags
    Push "$R4" # 用来记录区段的目标 Flags
    

    # 把传值型形参的值传给寄存器
    Push "${arg0}"
    Pop $R0
    Push "${arg1}"
    Pop $R1
    Push "${arg2}"
    Pop $R2

    # 可以随意使用变量了（但不能使用形参）
    SectionGetFlags $R0 $R3
    ${If} $R2 == "1"
        IntOp $R4 $R3 | $R1
    ${Else}
        IntOp $R4 4294967295 ^ $R1 # 这个大整数即是二进制下32位的1，用来生成掩码
        IntOp $R4 $R3 & $R4
    ${EndIf}
    SectionSetFlags $R0 $R4

    # 恢复变量的原值
    Pop $R4
    Pop $R3
    Pop $R2
    Pop $R1
    Pop $R0
!macroend
!endif
# 提供更简单的调用方式
!ifndef xxxkSetSectionState
!define xxxkSetSectionState "!insertmacro xxxkMacroSetSectionState"
!endif

# 根据给定 DataDir（程序目录），获取 HomeDir（配置目录）。一般 HomeDir 是 DataDir\.yong，但如果 DataDir 是 PROGRAMFILES 或 $PROGRAMFILES64 的后代目录，则 HomeDir 为 %APPDATA%\yong
# arg0 为返回值变量，如果失败，返回空值
# arg1 为传值型形参，DataDir
# 调用方法：${xxxkGetHomeDir} 返回值变量 "DataDir"
!ifmacrondef xxxkMacroGetHomeDir
!macro xxxkMacroGetHomeDir arg0 arg1
    # 备份要用到的变量
    Push "$R0" # 返回值
    Push "$R1" # 形参，DataDir
    Push "$R2" # 临时变量，标记是否为子目录

    # 把传值型形参的值传给寄存器
    Push "${arg1}"
    Pop $R1

    # 可以随意使用变量了（但不能使用形参）
    StrCpy $R0 ""
    ${If} ${FileExists} "$R1\*"
        ${WordFind} "$R1" "$PROGRAMFILES" "+1{" $R2 # 通过检测 $R1 是否以 $PROGRAMFILES 开头，来判断 $R1 是否在 $PROGRAMFILES（指 x86 的 Program Files 目录或 x64 的 Program Files(x86) 目录）下。如果检测成功，则返回变量值为空
        ${If} $R2 != ""
            ${If} ${RunningX64}
                ${WordFind} "$R1" "$PROGRAMFILES64" "+1{" $R2 # $PROGRAMFILES64 指 x64 的Program Files 目录
            ${EndIf}
        ${EndIf}

        ${If} $R2 == ""
            SetShellVarContext current
            StrCpy $R0 "$APPDATA\yong"
        ${Else}
            StrCpy $R0 "$R1\.yong"
        ${EndIf}
    ${EndIf}

    # 恢复变量的原值，并传回返回值
    Pop $R2
    Pop $R1
    Push "$R0"
    Exch
    Pop $R0
    Pop ${arg0}
!macroend
!endif
!ifndef xxxkGetHomeDir
!define xxxkGetHomeDir "!insertmacro xxxkMacroGetHomeDir" # 提供更简单的调用方式
!endif

# 检测安装包是否拥有给定目录的写入权限。
# arg0 为返回值变量，如果成功，返回 1，如果失败，返回 0
# arg1 为传值型形参，给定目录
# 调用方法：${xxxkHasWritePermissionOnDir} 返回值变量 "给定目录"
!ifmacrondef xxxkMacroHasWritePermissionOnDir
!macro xxxkMacroHasWritePermissionOnDir arg0 arg1
    # 备份要用到的变量
    Push "$R0" # 返回值
    Push "$R1" # 形参，给定目录
    Push "$R2" # 临时变量，存放文件句柄

    # 把传值型形参的值传给寄存器
    Push "${arg1}"
    Pop $R1

    # 可以随意使用变量了（但不能使用形参）
    CreateDirectory "$R1" # 副作用：可能会产生空文件夹
    ClearErrors
    FileOpen $R2 "$R1\tmp.dat" "a"
    FileClose "$R2"
    Delete "$R1\tmp.dat"
    ${If} ${Errors}
        StrCpy $R0 "0"
    ${Else}
        StrCpy $R0 "1"
    ${EndIf}

    # 恢复变量的原值，并传回返回值
    Pop $R2
    Pop $R1
    Push "$R0"
    Exch
    Pop $R0
    Pop ${arg0}
!macroend
!endif
!ifndef xxxkHasWritePermissionOnDir
!define xxxkHasWritePermissionOnDir "!insertmacro xxxkMacroHasWritePermissionOnDir" # 提供更简单的调用方式
!endif