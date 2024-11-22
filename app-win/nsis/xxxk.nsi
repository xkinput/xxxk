# 引入文件
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "xxxkFuncBase.nsh"

# 声明常量
!define XXXK_NAME_CN "小小星空"
!define XXXK_NAME_EN "xxxk"
!define XXXK_VER "2.0.0.0"
!define XXXK_VER_DATE "20241117"
!define XXXK_URL_HOME "https://xkinput.github.io/xxxk-help"
!define XXXK_URL_DOWNLOAD "http://xxxk.ysepan.com"
!define XXXK_REG_ROOT "HKLM"
!define XXXK_REG_MAIN "Software\Microsoft\Windows\CurrentVersion\Uninstall" # 注意由于 NSIS 创建的安装包为 32 位，"Software\Microsoft" 会被重定向为 "Software\Wow6432Node\Microsoft"
!define XXXK_DIR_APP_WIN ".."
!define XXXK_DIR_DATA_BASE "..\..\data-base"
!define XXXK_DIR_DATA_SCHEMA "..\..\data-schema"

# 设定安装程序属性
RequestExecutionLevel highest
SetCompressor /SOLID lzma
InstallDir "$LOCALAPPDATA\${XXXK_NAME_EN}"
OutFile "${XXXK_NAME_EN}-v${XXXK_VER}-build${XXXK_VER_DATE}.exe"
Name "${XXXK_NAME_CN}" # 修改变量 $(^Name)。影响欢迎页的有关文本
VIProductVersion "${XXXK_VER}" # 安装包的文件属性 > 详细信息 > 安装文件版本号
VIAddVersionKey ProductVersion "${XXXK_VER}" # 安装包的文件属性 > 详细信息 > 产品版本号
VIAddVersionKey ProductName "${XXXK_NAME_CN}" # 安装包的文件属性 > 详细信息 > 产品名称

# 声明页面

!define MUI_ICON "${XXXK_DIR_DATA_BASE}\skin\favicon.ico" # 安装程序的图标

!define MUI_ABORTWARNING # 用户关闭安装程序前弹出警告

!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_LICENSE "${XXXK_DIR_DATA_BASE}\README.txt"

!insertmacro MUI_PAGE_COMPONENTS

!define MUI_DIRECTORYPAGE_VARIABLE $INSTDIR # 绑定变量到目录选择页
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN $INSTDIR\yong.bat
!define MUI_FINISHPAGE_RUN_TEXT "运行输入法主程序"

!define MUI_FINISHPAGE_TEXT "要以 TSF 模式（需安装了 TSF 模块）运行输入法，\
                            $\n请在一个新的可键入文本的窗口中切换至 Yong 输入法键盘，\
                            $\n再运行输入法主程序。"
!define MUI_FINISHPAGE_LINK '阅读在线文档'
!define MUI_FINISHPAGE_LINK_LOCATION "${XXXK_URL_HOME}/#/install?id=启动"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "SimpChinese"

# 显式区段（选框）
Section /o "标准安装（需管理员身份）" optStandard
    AddSize 23810 # KB
SectionEnd
Section /o "便携安装" optPortable
    AddSize 23113 # KB
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${optStandard} "为所有用户安装输入法主程序和 TSF 模块。$\n$\nTSF 模块能够把小小输入法注册到系统键盘，获得系统原生输入法级别的体验，但必须以管理员身份运行安装包。"
    !insertmacro MUI_DESCRIPTION_TEXT ${optPortable} "仅释放主程序和星空方案，不写入注册表、不添加开始菜单、不注册 TSF 模块。$\n$\n仅适合想初步体验或者安装到U盘的用户。"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# 隐式区段（必发）

!include "xxxkFuncChkInstDir.nsh"
!include "xxxkFuncKillYong.nsh"
!include "xxxkFuncAppFiles.nsh"
!include "xxxkFuncYongIni.nsh"
!include "xxxkFuncAppReg.nsh"
!include "xxxkFuncAppStartMenu.nsh"
!include "xxxkFuncTsf.nsh"
!include "xxxkFuncUninstaller.nsh"

Section "-Main"

    Call xxxkFuncChkInstDir                           # 检查 $INSTDIR 和有关注册表项

    Call xxxkFuncKillYong                             # 退出正在运行的主程序

    Call xxxkFuncAppFiles                             # 释放或删除 app-win, data-base, data-schema 里的有关文件到 $INSTDIR

    Call xxxkFuncYongIni                              # 酌情恢复或删除 yong.ini 里的设置

    ${IfNot} ${SectionIsSelected} ${optPortable}
        Call xxxkFuncAppReg                           # 创建或删除注册表项
        Call xxxkFuncAppStartMenu                     # 创建或删除开始菜单
        Call xxxkFuncTsf                              # 释放或删除 app-win/tsf 里的文件，以及注册或注销 TSF 模块
    ${EndIf}

    Call xxxkFuncUninstaller                          # 创建卸载程序

SectionEnd

# 回调函数

Function xxxkSubFuncInitCheckbox
    Push "$R0" # 是否为管理员账户
    ${xxxkUserIsAdmin} $R0
    ${If} $R0 == "1"
        SectionSetFlags ${optStandard} ${SF_SELECTED}
        SectionSetFlags ${optPortable} 0
    ${Else}
        SectionSetFlags ${optStandard} ${SF_RO}
        SectionSetFlags ${optPortable} ${SF_SELECTED}|${SF_RO}
    ${EndIf}
    Pop $R0
FunctionEnd

Function xxxkSubFuncInitInstDir
    ${If} ${SectionIsSelected} ${optPortable}
        SetShellVarContext current
        StrCpy $INSTDIR "$LOCALAPPDATA\${XXXK_NAME_EN}"
    ${Else}
        ClearErrors
        ReadRegStr $INSTDIR "${XXXK_REG_ROOT}" "${XXXK_REG_MAIN}\${XXXK_NAME_EN}" "InstallLocation" # 尝试从已有注册表项（注意 "Software\Microsoft" 会被重定向为 "Software\Wow6432Node\Microsoft"）中读取安装路径，并赋值给变量 $INSTDIR
        ${IfThen} ${Errors} ${|} StrCpy $INSTDIR "$PROGRAMFILES\${XXXK_NAME_EN}" ${|}
    ${EndIf}
FunctionEnd

Function .onInit

    Call xxxkSubFuncInitCheckbox
    Call xxxkSubFuncInitInstDir

FunctionEnd

Function .onSelChange # 发生变化的区段索引存储在 $0 中

    ${If} $0 == ${optPortable}

        ${If} ${SectionIsSelected} ${optPortable}
            ${xxxkSetSectionState} ${optStandard} ${SF_SELECTED} "0"
        ${Else}
            ${xxxkSetSectionState} ${optPortable} ${SF_SELECTED} "1"
        ${EndIf}

    ${ElseIf} $0 == ${optStandard}

        ${If} ${SectionIsSelected} ${optStandard}
            ${xxxkSetSectionState} ${optPortable} ${SF_SELECTED} "0"
        ${Else}
            ${xxxkSetSectionState} ${optStandard} ${SF_SELECTED} "1"
        ${EndIf}
        
    ${EndIf}

    Call xxxkSubFuncInitInstDir

FunctionEnd
