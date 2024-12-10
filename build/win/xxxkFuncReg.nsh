!include "LogicLib.nsh"
#!define XXXK_REG_ROOT "HKLM"
#!define XXXK_NAME_EN "xxxk"
#!define XXXK_VER "1.0.6.0"
#!define XXXK_VER_DATE "20241212"
#!define XXXK_REG_MAIN "Software\Microsoft\Windows\CurrentVersion\Uninstall" # 注意由于 NSIS 创建的安装包为 32 位，"Software\Microsoft" 会被重定向为 "Software\Wow6432Node\Microsoft"

Function xxxkFuncReg

    WriteRegStr "HKCU" "Control Panel\Desktop" "LowLevelHooksTimeout" 0x000003E8 # 修复注册表
    WriteRegStr "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "DisplayName" "$(^Name)"
    WriteRegStr "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "DisplayVersion" "${XXXK_VER}"
    WriteRegStr "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "VersionDate" "${XXXK_VER_DATE}"
    WriteRegStr "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "InstallLocation" "$INSTDIR"

FunctionEnd

Function un.xxxkFuncReg # 删除注册表项

    DeleteRegKey "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}"

FunctionEnd