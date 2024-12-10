!include "LogicLib.nsh"
#!define XXXK_REG_ROOT "HKLM"
#!define XXXK_NAME_EN "xxxk"
#!define XXXK_REG_MAIN "Software\Microsoft\Windows\CurrentVersion\Uninstall" # 注意 NSIS 安装包是 32 位程序，所以 "Software\Microsoft" 会被重定向为 "Software\Wow6432Node\Microsoft"

Function xxxkFuncChkInstDir

    ${IfNot} ${SectionIsSelected} ${OptPortable}

        Push $R0 # 旧版 $INSTDIR
 
        ReadRegStr $R0 "HKLM" "${XXXK_REG_MAIN}\小小键道3" "InstallLocation"
        ${IfNot} ${Errors}
            MessageBox MB_OK|MB_ICONEXCLAMATION "安装失败！$\n原因：检测到旧版小小键道3（$R0）。$\n为避免不可预料的冲突，请先将其卸载！"
            Abort
        ${EndIf}

        ReadRegStr $R0 "HKLM" "${XXXK_REG_MAIN}\小小键道6" "InstallLocation"
        ${IfNot} ${Errors}
            MessageBox MB_OK|MB_ICONEXCLAMATION "安装失败！$\n原因：检测到旧版小小键道6（$R0）。$\n为避免不可预料的冲突，请先将其卸载！"
            Abort
        ${EndIf}

        ReadRegStr $R0 "HKLM" "${XXXK_REG_MAIN}\小小星空" "InstallLocation"
        ${IfNot} ${Errors}
            MessageBox MB_OK|MB_ICONEXCLAMATION "安装失败！$\n原因：检测到旧版小小星空（$R0）。$\n为避免不可预料的冲突，请先将其卸载！"
            Abort
        ${EndIf}

        ReadRegStr $R0 "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "InstallLocation"
        ${IfNot} ${Errors}
            ${If} "$R0" != "$INSTDIR"
                MessageBox MB_OK|MB_ICONEXCLAMATION "安装失败！$\n原因：检测到旧版小小星空，且其安装路径（$R0）与当前所选安装路径（$INSTDIR)不同。$\n为避免不可预料的冲突，请先将其卸载！"
                Abort
            ${EndIf}
        ${EndIf}

        Push $R1 # 旧版版本号
        ReadRegStr $R1 "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "VersionDate"
        ${If} "$R1" > "0"
        ${AndIf} "$R1" < "20241212"
            MessageBox MB_OK|MB_ICONEXCLAMATION "安装失败！$\n原因：检测到旧版小小星空（$R0）。$\n为避免不可预料的冲突，请先将其卸载！"
            Abort
        ${EndIf}
        Pop $R1

        Pop $R0

    ${EndIf}

    ${If} ${FileExists} "$INSTDIR\*.*"
        ${If} ${Cmd} `MessageBox MB_YESNO|MB_ICONQUESTION "$INSTDIR 目录已存在，$\n继续安装可能导致原有文件被覆盖，或者因文件占用而安装失败。$\n确定要继续吗？" IDNO`
            Abort
        ${EndIf}
    ${EndIf}

    Push "$R0"
    ${xxxkHasWritePermissionOnDir} $R0 "$INSTDIR"
    ${If} $R0 == "0"
        MessageBox MB_OK|MB_ICONEXCLAMATION "安装失败！$\n原因：缺少对安装路径的写入权限。"
        Abort
    ${EndIf}
    Pop $R0

FunctionEnd
