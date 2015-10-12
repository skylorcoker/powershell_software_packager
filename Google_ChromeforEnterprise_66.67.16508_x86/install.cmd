@echo off
cls
set PTH=%~dp0
set PREFFILE=master_preferences
set INSTALLPATH=%ProgramFiles(x86)%\Google\Chrome\Application\

echo "Attempting install of Chrome..."
msiexec.exe /i "%PTH%\GoogleChromeStandaloneEnterprise.msi" /qn /norestart
copy %PREFFILE% "%INSTALLPATH%" /Y

REM echo "Deleteing shortcut from desktop..."
del /q /f "%PUBLIC%\Desktop\Google Chrome.lnk"
