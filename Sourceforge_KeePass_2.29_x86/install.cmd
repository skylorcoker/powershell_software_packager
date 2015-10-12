@echo off

REM Set PTH to the current directory of the script
set PTH=%~dp0
set APPPATH=%PROGRAMFILES(X86)%\KeePass Password Safe 2
set CONFIGFILE=KeePass.config.enforced.xml
"%PTH%\KeePass-2.29-Setup.exe"/verysilent
copy "%PTH%\%CONFIGFILE%" "%APPPATH%"