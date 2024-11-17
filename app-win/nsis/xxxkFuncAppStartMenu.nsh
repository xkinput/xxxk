!include "x64.nsh"
#!define XXXK_NAME_EN "xxxk"
#!define XXXK_URL_HOME "https://xkinput.github.io/xxxk-help"
#!define XXXK_URL_DOWNLOAD "http://xxxk.ysepan.com"

Function xxxkFuncAppStartMenu

    # 如果要创建自启动项，快捷方式名必须为yong.lnk 且位于用户开始菜单，以保持与 yong-config.exe 修改启动项的行为一致
    ; SetShellVarContext current
    ; ${If} ${RunningX64}
    ;     CreateShortCut "$SMSTARTUP\yong.lnk" "$INSTDIR\w64\yong.exe" 
    ; ${Else}
    ;     CreateShortCut "$SMSTARTUP\yong.lnk" "$INSTDIR\yong.exe"
    ; ${EndIf}

    SetShellVarContext all
    RMDir /r "$SMPROGRAMS\${XXXK_NAME_EN}"
    CreateDirectory "$SMPROGRAMS\${XXXK_NAME_EN}"
    CreateShortCut "$SMPROGRAMS\${XXXK_NAME_EN}\1.小小星空.lnk" "$INSTDIR\tools\bat\yong.bat" "" "$INSTDIR\yong.exe"
    CreateShortCut "$SMPROGRAMS\${XXXK_NAME_EN}\2.重置小小.lnk" "$INSTDIR\tools\bat\reset.bat" "" "$WINDIR\System32\SHELL32.dll" 238
    CreateShortCut "$SMPROGRAMS\${XXXK_NAME_EN}\3.教程.lnk" "$INSTDIR\doc" "" "$WINDIR\System32\SHELL32.dll" 23
    CreateShortCut "$SMPROGRAMS\${XXXK_NAME_EN}\4.官网.lnk" "${XXXK_URL_HOME}" "" "$WINDIR\System32\SHELL32.dll" 17
    CreateShortCut "$SMPROGRAMS\${XXXK_NAME_EN}\5.网盘.lnk" "${XXXK_URL_DOWNLOAD}" "" "$WINDIR\System32\SHELL32.dll" 17
    CreateShortCut "$SMPROGRAMS\${XXXK_NAME_EN}\6.卸载.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe"

FunctionEnd

Function un.xxxkFuncAppStartMenu # 删除快捷方式和开始菜单
    
    # 二、删除自启动项
    SetShellVarContext current # yong-config 创建的启动项位于用户开始菜单
    Delete "$SMSTARTUP\yong.lnk"

    # 一、删除开始菜单
    SetShellVarContext all
    RMDir /r "$SMPROGRAMS\${XXXK_NAME_EN}" # 删除开始->程序->小小星空

FunctionEnd