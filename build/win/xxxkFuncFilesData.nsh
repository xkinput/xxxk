!include "LogicLib.nsh"
!include "xxxkFuncBase.nsh"
#!define XXXK_DIR_DATA "..\..\data\yong-win"

Function xxxkFuncFilesData

    # 释放 data 里的文件（除了 tsf）

    # 1. 释放输入法主程序和功能模块（64位版）
    SetOutPath "$INSTDIR\w64"
    File "${XXXK_DIR_DATA}\w64\libcloud.so"
    File "${XXXK_DIR_DATA}\w64\libgbk.so"
    File "${XXXK_DIR_DATA}\w64\libl.dll"
    File "${XXXK_DIR_DATA}\w64\libmb.so"
    File "${XXXK_DIR_DATA}\w64\yong.exe"
    File "${XXXK_DIR_DATA}\w64\yong-config.exe"
    File "${XXXK_DIR_DATA}\w64\yong-vim.exe"

    # 2. 释放输入法主程序和功能模块（32位版）
    SetOutPath "$INSTDIR"
    File "${XXXK_DIR_DATA}\libcloud.so"
    File "${XXXK_DIR_DATA}\libgbk.so"
    File "${XXXK_DIR_DATA}\libl.dll"
    File "${XXXK_DIR_DATA}\libmb.so"
    File "${XXXK_DIR_DATA}\yong.exe"
    File "${XXXK_DIR_DATA}\yong-config.exe"
    File "${XXXK_DIR_DATA}\yong-vim.exe"

    # 3. 释放其他有关的资源文件
    SetOutPath "$INSTDIR\entry"
    File "${XXXK_DIR_DATA}\entry\*.*"        # 该目录不会被 yong-config.exe 更新
    SetOutPath "$INSTDIR\mb"
    File "${XXXK_DIR_DATA}\mb\*.*"           # 该目录除了 pinyin.txt，pypre.bin 和 yong.txt，不会被 yong-config.exe 更新
    SetOutPath "$INSTDIR\skin"
    File "${XXXK_DIR_DATA}\skin\*.*"         # 该目录不会被 yong-config.exe 更新
    SetOutPath "$INSTDIR"
    File "${XXXK_DIR_DATA}\bihua.bin"
    File "${XXXK_DIR_DATA}\class.txt"        # 该文件不会被 yong-config.exe 更新
    File "${XXXK_DIR_DATA}\normal.txt"       # 该文件不会被 yong-config.exe 更新
    File "${XXXK_DIR_DATA}\README.txt"       # 该文件不会被 yong-config.exe 更新
    File "${XXXK_DIR_DATA}\yong.chm"
    File "${XXXK_DIR_DATA}\yong.ini"         # 该文件不会被 yong-config.exe 更新

FunctionEnd

Function un.xxxkFuncFilesData

    # 为了数据安全，配置目录里的文件不会被删除，用户可以手动删除

    # 删除程序目录里的文件
    # 1
    ${xxxkRMDir} "$INSTDIR\w64"    # RMDir /r "$INSTDIR\w64"
    # 2
    Delete /REBOOTOK "$INSTDIR\libcloud.so"
    Delete /REBOOTOK "$INSTDIR\libgbk.so"
    Delete /REBOOTOK "$INSTDIR\libl.dll"
    Delete /REBOOTOK "$INSTDIR\libmb.so"
    Delete /REBOOTOK "$INSTDIR\yong.exe"
    Delete /REBOOTOK "$INSTDIR\yong-config.exe"
    Delete /REBOOTOK "$INSTDIR\yong-vim.exe"
    # 3
    ${xxxkRMDir} "$INSTDIR\entry"  # RMDir /r "$INSTDIR\entry"
    ${xxxkRMDir} "$INSTDIR\mb"     # RMDir /r "$INSTDIR\mb"
    ${xxxkRMDir} "$INSTDIR\skin"   # RMDir /r "$INSTDIR\skin"
    Delete /REBOOTOK "$INSTDIR\bihua.bin"
    Delete /REBOOTOK "$INSTDIR\class.txt"
    Delete /REBOOTOK "$INSTDIR\normal.txt"
    Delete /REBOOTOK "$INSTDIR\README.txt"
    Delete /REBOOTOK "$INSTDIR\yong.chm"
    Delete /REBOOTOK "$INSTDIR\yong.ini"

FunctionEnd