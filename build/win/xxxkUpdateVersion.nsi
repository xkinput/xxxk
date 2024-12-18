!include "LogicLib.nsh"
!include "xxxkConst.nsh"
#!define XXXK_DIR_HOME "..\..\home"
#!define XXXK_VER "2.0.4.0"
#!define XXXK_VER_DATE "20241221"

SilentInstall silent
RequestExecutionLevel user
 
Section

        Push $R0 # version.txt 的文件句柄
        Push $R1 # version.txt 的内容

        FileOpen $R0 "${XXXK_DIR_HOME}\version.txt" r
        FileRead $R0 $R1
        FileClose $R0

        ${If} $R1 != "xxxk ${XXXK_VER_DATE}"

            ${If} ${Cmd} `MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON1 "是否将 xxxkConst.nsh 的版本信息（${XXXK_VER_DATE}）更新到 home 目录下的 menu.ini 和 version.txt（$R1）？" IDYES` # 只支持单一结果常量匹配

                WriteINIStr "${XXXK_DIR_HOME}\menu.ini" "about" "exec" "$$MSG(v${XXXK_VER}-Build${XXXK_VER_DATE})"

                FileOpen $R0 "${XXXK_DIR_HOME}\version.txt" w
                FileWrite $R0 "xxxk ${XXXK_VER_DATE}"
                FileClose $R0

            ${EndIf}

        ${EndIf}

        Pop $R1
        Pop $R0

SectionEnd