@echo off
cd /d "%~dp0"
cd /d ..
cd /d ..
rem if not exist yong.exe (cd /d ..)
echo 正在启动输入法主程序...
if /i "%PROCESSOR_IDENTIFIER:~0,3%"=="X86" (start yong.exe) else (if exist w64/yong.exe (start w64/yong.exe) else (start yong.exe))