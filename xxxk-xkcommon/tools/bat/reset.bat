@echo off
cd /d "%~dp0"

cd /d ..
cd /d ..
if not exist yong.exe exit

echo ����û������ļ�...
rd /s /q .yong 2>nul
rd /s /q %AppData%\yong 2>nul
echo ��ɣ�

cd /d tools
cd /d bat
call rerun.bat