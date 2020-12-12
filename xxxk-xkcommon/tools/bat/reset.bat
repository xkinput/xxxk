@echo off
cd /d "%~dp0"

cd /d ..
cd /d ..
if not exist yong.exe exit

echo 清空用户配置文件...
rd /s /q .yong 2>nul
rd /s /q %AppData%\yong 2>nul
echo 完成！

cd /d tools
cd /d bat
call rerun.bat