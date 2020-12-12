@echo off
cd /d "%~dp0"

cd /d ..
cd /d ..
if not exist yong.exe exit

if exist ".yong" (
  start /max "" ".yong" >nul 2>nul
) else (
  if exist "%AppData%\yong" (start /max "" "%AppData%\yong" >nul 2>nul)
)
