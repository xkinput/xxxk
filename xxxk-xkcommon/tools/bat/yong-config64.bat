@echo off
cd /d "%~dp0"
cd /d ..
cd /d ..
rem if not exist yong.exe (cd /d ..)
echo �����������뷨���ó���...
if /i "%PROCESSOR_IDENTIFIER:~0,3%"=="X86" (start yong-config.exe) else (if exist w64/yong-config.exe (start w64/yong-config.exe) else (start yong-config.exe))