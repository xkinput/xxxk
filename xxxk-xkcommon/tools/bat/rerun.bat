@echo off
cd /d "%~dp0"
call quit.bat
echo 准备重启输入法主程序...
ping -n 2 127.0.0.1 >nul
call yong.bat