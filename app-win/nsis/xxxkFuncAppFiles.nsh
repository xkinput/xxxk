!include "LogicLib.nsh"
!include "xxxkFuncBase.nsh"
#!define XXXK_DIR_APP_WIN ".."
#!define XXXK_DIR_DATA_BASE "..\..\data-base"
#!define XXXK_VER "1.0.6.0"
#!define XXXK_VER_DATE "20240415"
#!define XXXK_DIR_DATA_SCHEMA "..\..\data-schema"

Function xxxkFuncAppFiles

    # 一、释放 app-win 里的文件（除了 tsf）

    # 1. 释放输入法主程序和功能模块（64位版）：app-win\yong\w64 → $INSTDIR\w64
    SetOutPath "$INSTDIR\w64"
    File "${XXXK_DIR_APP_WIN}\yong\w64\libcloud.so"
    File "${XXXK_DIR_APP_WIN}\yong\w64\libgbk.so"
    File "${XXXK_DIR_APP_WIN}\yong\w64\libl.dll"
    File "${XXXK_DIR_APP_WIN}\yong\w64\libmb.so"
    File "${XXXK_DIR_APP_WIN}\yong\w64\yong.exe"
    File "${XXXK_DIR_APP_WIN}\yong\w64\yong-config.exe"
    File "${XXXK_DIR_APP_WIN}\yong\w64\yong-vim.exe"

    # 2. 释放输入法主程序和功能模块（32位版）以及有关的资源文件：app-win\yong → $INSTDIR
    SetOutPath "$INSTDIR"
    File "${XXXK_DIR_APP_WIN}\yong\libcloud.so"
    File "${XXXK_DIR_APP_WIN}\yong\libgbk.so"
    File "${XXXK_DIR_APP_WIN}\yong\libl.dll"
    File "${XXXK_DIR_APP_WIN}\yong\libmb.so"
    File "${XXXK_DIR_APP_WIN}\yong\yong.exe"
    File "${XXXK_DIR_APP_WIN}\yong\yong-config.exe"
    File "${XXXK_DIR_APP_WIN}\yong\yong-vim.exe"
    File "${XXXK_DIR_APP_WIN}\yong\class.txt"
    File "${XXXK_DIR_APP_WIN}\yong\normal.txt"

    # 二、释放 data-base 里的文件

    # 3. 释放 xxxk 定制的有关资源文件：data-base → $INSTDIR
    SetOutPath "$INSTDIR"
    File "${XXXK_DIR_DATA_BASE}\bd.txt"
    File "${XXXK_DIR_DATA_BASE}\bihua.bin"
    File "${XXXK_DIR_DATA_BASE}\crab.txt"
    File "${XXXK_DIR_DATA_BASE}\keyboard.ini"
    File "${XXXK_DIR_DATA_BASE}\layout.txt"
    File "${XXXK_DIR_DATA_BASE}\menu.ini"
    WriteINIStr $INSTDIR\menu.ini "about" "exec" "$$MSG(v${XXXK_VER}-Build${XXXK_VER_DATE})"
    File "${XXXK_DIR_DATA_BASE}\README.txt"
    File "${XXXK_DIR_DATA_BASE}\urls.txt"
    File "${XXXK_DIR_DATA_BASE}\yong.ini"
    File "${XXXK_DIR_DATA_BASE}\xxxkCustomizableKeys.ini"
    File "${XXXK_DIR_DATA_BASE}\yong.bat"
    File "${XXXK_DIR_DATA_BASE}\yong-config.bat"
    
    # 4. 释放 xxxk 定制的皮肤、托盘和图标文件：data-base\skin → $INSTDIR\skin
    SetOutPath "$INSTDIR\skin"
    File "${XXXK_DIR_DATA_BASE}\skin\*.*" # 只打包文件，因此调试用的皮肤目录不会被打包
    
    # 5. 释放 xxxk 定制的文档：data-base\doc → $INSTDIR\doc
    SetOutPath "$INSTDIR\doc"
    File /r "${XXXK_DIR_DATA_BASE}\doc\*.*" # 打包所有子文件和子目录

    # 6. 释放 xxxk 定制的工具：data-base\tools → $INSTDIR\tools
    SetOutPath "$INSTDIR\tools"
    File /r "${XXXK_DIR_DATA_BASE}\tools\*.*" # 打包所有子文件和子目录

    # 7. 释放 xxxk 定制的码表：data-base\mb → $INSTDIR\mb        data-base\entry → $INSTDIR\entry
    SetOutPath "$INSTDIR\mb"
    File /r "${XXXK_DIR_DATA_BASE}\mb\*.*" # 打包所有子文件和子目录
    SetOutPath "$INSTDIR\entry"
    File /r "${XXXK_DIR_DATA_BASE}\entry\*.*" # 打包所有子文件和子目录

    # 三、释放 data-schema 里的文件

    # 8. 释放码表：data-schema\方案名 → $INSTDIR
    SetOutPath "$INSTDIR"
    File /r "${XXXK_DIR_DATA_SCHEMA}\xkjd6\*.*" # 打包所有子文件和子目录
    File /r "${XXXK_DIR_DATA_SCHEMA}\xklb\*.*" # 打包所有子文件和子目录
    File /r "${XXXK_DIR_DATA_SCHEMA}\xkxb\*.*" # 打包所有子文件和子目录
    File /r "${XXXK_DIR_DATA_SCHEMA}\xkyb\*.*" # 打包所有子文件和子目录

FunctionEnd

Function un.xxxkFuncAppFiles

    # 删除在程序目录下创建的输入法主程序的快捷方式（历史遗留）
    Delete "$INSTDIR\*.lnk"

    # 8.7. 删除码表
    ${xxxkRMDir} "$INSTDIR\mb"     # RMDir /r "$INSTDIR\mb"
    ${xxxkRMDir} "$INSTDIR\entry"  # RMDir /r "$INSTDIR\entry"

    # 6. 删除工具
    ${xxxkRMDir} "$INSTDIR\tools"  # RMDir /r "$INSTDIR\tools"

    # 5. 删除文档
    ${xxxkRMDir} "$INSTDIR\doc"    # RMDir /r "$INSTDIR\doc"

    # 4. 删除皮肤、托盘和图标文件
    ${xxxkRMDir} "$INSTDIR\skin"   # RMDir /r "$INSTDIR\skin"

    # 3. 删除 xxxk 定制的有关资源文件
    Delete "$INSTDIR\bd.txt"
    Delete "$INSTDIR\bihua.bin"
    Delete "$INSTDIR\crab.txt"
    Delete "$INSTDIR\keyboard.ini"
    Delete "$INSTDIR\layout.txt"
    Delete "$INSTDIR\menu.ini"
    Delete "$INSTDIR\README.txt"
    Delete "$INSTDIR\urls.txt"
    Delete "$INSTDIR\yong.ini"
    Delete "$INSTDIR\xxxkCustomizableKeys.ini"
    Delete "$INSTDIR\yong.bat"
    Delete "$INSTDIR\yong-config.bat"

    # 2. 删除输入法主程序和功能模块（32位版）以及有关的资源文件
    Delete "$INSTDIR\libcloud.so"
    Delete "$INSTDIR\libgbk.so"
    Delete "$INSTDIR\libl.dll"
    Delete "$INSTDIR\libmb.so"
    Delete "$INSTDIR\yong.exe"
    Delete "$INSTDIR\yong-config.exe"
    Delete "$INSTDIR\yong-vim.exe"
    Delete "$INSTDIR\class.txt"
    Delete "$INSTDIR\normal.txt"

    # 1. 删除输入法主程序和功能模块（64位版）
    ${xxxkRMDir} "$INSTDIR\w64" # RMDir /r "$INSTDIR\w64"

FunctionEnd