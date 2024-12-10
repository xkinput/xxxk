!include "x64.nsh"
!include "WinVer.nsh"
!include "xxxkFuncBase.nsh"
#!define XXXK_DIR_DATA "..\..\data\yong-win"

# 根据操作系统版本确定 TSF 模块文件（即 yong.dll 等）的合理安装目录。对于 Win8 及以上系统，TSF 模块文件必须在 $PROGRAMFILES（指 x86 的 Program Files 目录或 x64 的 Program Files(x86) 目录）中注册，才能在 Metro 应用中使用。
# 调用方法：${xxxkGetTsfDir} "返回值变量"
# 所有参数均为传址的
!ifmacrondef xxxkMacroGetTsfDir
!macro xxxkMacroGetTsfDir arg0
    # 备份要用到的临时变量
    Push "$R0" # 返回值变量

    # 可以随意使用变量了（但不能使用形参）
    ${If} ${AtLeastWin8} 
        StrCpy $R0 "$PROGRAMFILES\xxxk\tsf"
    ${Else}
        StrCpy $R0 "$INSTDIR\tsf"
    ${EndIf}

    # 恢复临时变量的原值，并传回返回值
    Push "$R0"
    Exch
    Pop $R0
    Pop ${arg0}
!macroend
!endif
!ifndef xxxkGetTsfDir
!define xxxkGetTsfDir "!insertmacro xxxkMacroGetTsfDir" # 提供更简单的调用方式
!endif

# 将 TSF 模块文件（即 yong.dll 等）释放到指定目录
# 调用方法：${xxxkTsfToFolder} "文件夹路径"
# 所有参数均为传值的，无返回值
!ifmacrondef xxxkMacroTsfToFolder
!macro xxxkMacroTsfToFolder arg0 # arg0 是文件夹路径
    # 备份要用到的临时变量
    Push "$R0" # 文件夹路径
    
    # 把传值型形参的值传给寄存器
    Push "${arg0}"
    Pop $R0

    # 可以随意使用变量了（但不能使用形参）
    # 释放 TSF 模块：${XXXK_DIR_DATA}\tsf → 指定文件夹\tsf
    SetOutPath "$R0"
    File "${XXXK_DIR_DATA}\tsf\tsf-reg.exe"
    File "${XXXK_DIR_DATA}\tsf\tsf-reg64.exe"
    File "${XXXK_DIR_DATA}\tsf\install.bat"
    File "${XXXK_DIR_DATA}\tsf\uninstall.bat"
    # 由于原有的 yong.dll 和 yong64.dll 可能正被占用，需要先注销，再更名，再释放新文件
    ${If} ${FileExists} "$R0\yong.dll"
        ${DisableX64FSRedirection}
        ExecShellWait "open" "$R0\uninstall.bat"
        ${EnableX64FSRedirection}
        Sleep 1000
        ${xxxkMarkFileAsDel} "$R0\yong.dll"
        ${xxxkMarkFileAsDel} "$R0\yong64.dll"
    ${EndIf}
    File "${XXXK_DIR_DATA}\tsf\yong.dll"
    File "${XXXK_DIR_DATA}\tsf\yong64.dll"
    Delete "$R0\*.del"

    # 恢复临时变量的原值
    Pop $R0
!macroend
!endif
!ifndef xxxkTsfToFolder
!define xxxkTsfToFolder "!insertmacro xxxkMacroTsfToFolder" # 提供更简单的调用方式
!endif

Function xxxkFuncTsf

    Var /GLOBAL xxxkVarTsfDir
    ${xxxkGetTsfDir} $xxxkVarTsfDir

    # ${XXXK_DIR_DATA}\tsf → $xxxkVarTsfDir
    ${xxxkTsfToFolder} "$xxxkVarTsfDir"

    ${DisableX64FSRedirection}
    ExecShellWait "open" "$xxxkVarTsfDir\install.bat"
    ${EnableX64FSRedirection}

FunctionEnd

Function un.xxxkFuncTsf

    Push "$R0" # 是否为管理员账户
    ${xxxkUserIsAdmin} $R0
    ${If} $R0 == "1"

        ${xxxkGetTsfDir} $xxxkVarTsfDir

        ${If} ${FileExists} "$xxxkVarTsfDir\uninstall.bat"
            ${DisableX64FSRedirection}
            ExecShellWait "open" "$xxxkVarTsfDir\uninstall.bat"
            ${EnableX64FSRedirection}
            ${xxxkRMDir} "$xxxkVarTsfDir" # RMDir /r "$xxxkVarTsfDir"
        ${EndIf}
        
        ${If} ${FileExists} "$INSTDIR\tsf\uninstall.bat"
            ${DisableX64FSRedirection}
            ExecShellWait "open" "$INSTDIR\tsf\uninstall.bat"
            ${EnableX64FSRedirection}
            ${xxxkRMDir} "$INSTDIR\tsf" # RMDir /r "$INSTDIR\tsf"
        ${EndIf}

    ${EndIf}
    Pop $R0


FunctionEnd