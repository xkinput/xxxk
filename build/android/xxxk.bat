@echo off
set dirData=..\..\data\yong-android
set dirHome=..\..\home
set outApkName=xxxk

:menu
cls
cd /d %~dp0
echo [D] Decompose yong.apk into data\yong-android directory
echo [R] Replace files in data\yong-android directory with files in home directory
echo [C] Compose data\yong-android directory to xxxk.apk
echo [S] Sign xxxk.apk
echo [A] All of above
echo [Q] Quit
choice /c DRCSAQ /m "Please choose an option:"
set result=%errorlevel%
if %result%==1 goto decompose
if %result%==2 goto replace
if %result%==3 goto compose
if %result%==4 goto sign
if %result%==5 goto all
if %result%==6 goto quit

:all

:decompose
rmdir /s /q %dirData%
call apktool.bat d yong.apk -f -o %dirData%
if %result%==1 (pause && goto menu)

:replace
rem home\skin\xxxktray2.png -> yong-android\res\drawable-*dpi\app_icon.png -> APP ICON
copy %dirHome%\skin\xxxktray2.png %dirData%\res\drawable-hdpi\app_icon.png /y
copy %dirHome%\skin\xxxktray2.png %dirData%\res\drawable-mdpi\app_icon.png /y
copy %dirHome%\skin\xxxktray2.png %dirData%\res\drawable-xhdpi\app_icon.png /y
rem home\skin-android -> yong-android\assets\.yong\android -> APP SKIN
xcopy %dirHome%\skin-android %dirData%\assets\.yong\android /i /s /e /y
rem home\mb -> yong-android\assets\.yong\mb -> sdcard\yong\.yong\mb
rmdir /s /q %dirData%\assets\mb
xcopy %dirHome%\mb\xkbase %dirData%\assets\.yong\mb\xkbase /i /s /e /y
xcopy %dirHome%\mb\xkjd6 %dirData%\assets\.yong\mb\xkjd6 /i /s /e /y
xcopy %dirHome%\mb\xklb %dirData%\assets\.yong\mb\xklb /i /s /e /y
xcopy %dirHome%\mb\xkxb %dirData%\assets\.yong\mb\xkxb /i /s /e /y
xcopy %dirHome%\mb\xkyb %dirData%\assets\.yong\mb\xkyb /i /s /e /y
rem copy %dirHome%\mb\english.txt %dirData%\assets\.yong\mb\english.txt /y
rem home -> yong-android\assets\.yong -> sdcard\yong\.yong  或 sdcard\yong
copy %dirHome%\bd.txt %dirData%\assets\.yong\bd.txt /y
copy %dirHome%\bihua.bin %dirData%\assets\.yong\bihua.bin /y
copy %dirHome%\crab.txt %dirData%\assets\.yong\crab.txt /y
copy %dirHome%\urls.txt %dirData%\assets\.yong\urls.txt /y
copy %dirHome%\version.txt %dirData%\assets\version.txt /y
copy %dirHome%\yong-android.ini %dirData%\assets\yong.ini /y
if %result%==2 (pause && goto menu)

:compose
call apktool.bat b %dirData% -o %outApkName%.apk
if %result%==3 (pause && goto menu)

:sign
cmd /c java -jar uber-apk-signer.jar --apks %outApkName%.apk
del /f %outApkName%-aligned-debugSigned.apk.idsig
del /f %outApkName%-signed.apk
del /f %outApkName%.apk
rename %outApkName%-aligned-debugSigned.apk %outApkName%-signed.apk
if %result%==4 (pause && goto menu)

if %result%==5 (pause && goto menu)

:quit
exit /b 0