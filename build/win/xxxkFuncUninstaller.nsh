!include "LogicLib.nsh"
!include "xxxkFuncBase.nsh"
#!define XXXK_REG_ROOT "HKLM"
#!define XXXK_NAME_EN "xxxk"
#!define XXXK_REG_MAIN "Software\Microsoft\Windows\CurrentVersion\Uninstall" # 注意由于 NSIS 创建的安装包为 32 位，"Software\Microsoft" 会被重定向为 "Software\Wow6432Node\Microsoft"

Function xxxkFuncUninstaller

    WriteUninstaller "$INSTDIR\uninstall.exe"

FunctionEnd

Function un.onInit

    ${If} ${Cmd} `MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDNO` # 只支持单一结果常量匹配
        Abort
    ${EndIf}

    #Var /GLOBAL xxxkIsPortable
    StrCpy $xxxkIsPortable "0"
    Push "$R0"
    ReadRegStr $R0 "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "InstallLocation"
    ${If} $R0 != $INSTDIR
        StrCpy $xxxkIsPortable "1"
    ${EndIf}
    Pop $R0

    ${If} "$xxxkIsPortable" == "0"
        Push "$R0"
        ${xxxkUserIsAdmin} $R0
        ${If} $R0 != "1"
            MessageBox MB_OK|MB_ICONEXCLAMATION "卸载失败！$\n原因：权限不足，需要管理员身份。"
            Abort
        ${EndIF}
        Pop $R0
    ${EndIf}

FunctionEnd

Section "Uninstall"

    Call un.xxxkFuncKillYong
    Call un.xxxkFuncFilesData
    Call un.xxxkFuncFilesHome
    ${If} "$xxxkIsPortable" == "0"
        Call un.xxxkFuncTsf
        Call un.xxxkFuncStartMenu
        Call un.xxxkFuncReg
    ${EndIf}

    Delete "$INSTDIR\uninstall.exe" # 删除自己
    RMDir "$INSTDIR" # 只删除空目录

SectionEnd

Function un.onUninstSuccess

    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除！\
                                         $\n安装目录如果有残留文件，重启后即可删除。"
                                         
    ExecShell "open" "$INSTDIR" # 如果有残留，打开给用户看
    ExecShell "open" "$xxxkVarHomeDir" # 如果有残留，打开给用户看

FunctionEnd