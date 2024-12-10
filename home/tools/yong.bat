@echo off
cd /d "%~dp0"
start "" /b /wait quit.bat

cd ..
for %%A in ("%cd%") do set "folderName=%%~nxA"
if /i %folderName%==.yong (
    if /i %PROCESSOR_ARCHITECTURE% EQU X86 (cd ..) else (cd ..\w64)
) else (
    if /i %PROCESSOR_ARCHITECTURE% EQU X86 (cd /d "%ProgramFiles%\xxxk") else (cd /d "%ProgramFiles(x86)%\xxxk\w64")
)

start "" yong.exe
exit
