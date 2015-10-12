@echo off

REM Set PTH to the current directory of the script
set PTH=%~dp0

REM Lets Kill MSIEXEC
taskkill /F /IM msiexec.exe

md %windir%\syswow64\macromed\flash
copy /Y "%PTH%\mms - silent updates disabled.cfg" %WINDIR%\SysWow64\Macromed\Flash\mms.cfg
msiexec.exe /i "%PTH%\install_flash_player_18_active_x.msi" /qn /norestart
schtasks /delete /TN "Adobe Flash Player Updater" /F