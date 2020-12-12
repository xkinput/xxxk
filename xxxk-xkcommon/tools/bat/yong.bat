@echo off
cd /d "%~dp0"
cd /d ..
cd /d ..
if not exist yong.exe (cd /d ..)
echo 正在启动输入法主程序...
start yong.exe