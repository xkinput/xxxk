@echo off
cd /d "%~dp0"
cd /d ..
cd /d ..
if not exist yong-config.exe (cd /d ..)
echo �����������뷨������...
start yong-config.exe