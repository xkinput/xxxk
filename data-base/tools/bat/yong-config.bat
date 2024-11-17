@echo off
cd /d "%~dp0"
if /i %PROCESSOR_ARCHITECTURE% EQU X86 ( cd /d ..\..) else (cd /d ..\..\w64)
start "" yong-config.exe
exit