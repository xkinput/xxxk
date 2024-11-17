@echo off
cd /d "%~dp0"
start "" /b /wait quit.bat
if /i %PROCESSOR_ARCHITECTURE% EQU X86 ( cd /d "..\..") else (cd /d "..\..\w64")
start "" yong.exe
exit