@echo off
set PTH=%~dp0
set JAVAVERSION=jre1.8.0_45

taskkill /F /IM iexplorer.exe
taskkill /F /IM iexplore.exe
taskkill /F /IM firefox.exe
taskkill /F /IM chrome.exe
taskkill /F /IM javaw.exe
taskkill /F /IM jqs.exe
taskkill /F /IM jusched.exe

REM 32-bit installs
echo "Attempting to remove 32-bit installs..."
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F83217021FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F83217025FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F83217040FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F83217045FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F83217051FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F83217060FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F03217065FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F03217067FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F03217067FF} /qn
Msiexec.exe /X{26A24AE4-039D-4CA4-87B4-2F03217071FF} /qn
Msiexec.exe /X{26A24AE4-039D-4CA4-87B4-2F83218031F0} /qn
Msiexec.exe /X{26A24AE4-039D-4CA4-87B4-2F83218040F0} /qn
		


REM 64-bit installs
echo "Attempting to remove 64-bit installs..."
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F86417013FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F86417017FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F86417021FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F86417025FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F86417045FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F86417051FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F86417060FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F06417065FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F06417067FF} /qn
MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F06417067FF} /qn
Msiexec.exe /X{26A24AE4-039D-4CA4-87B4-2F06417071FF} /qn
Msiexec.exe /X{26A24AE4-039D-4CA4-87B4-2F86418031F0} /qn
Msiexec.exe /X{26A24AE4-039D-4CA4-87B4-2F86418040F0} /qn


taskkill /F /IM iexplorer.exe
taskkill /F /IM iexplore.exe
taskkill /F /IM firefox.exe
taskkill /F /IM chrome.exe
taskkill /F /IM javaw.exe
taskkill /F /IM jqs.exe
taskkill /F /IM jusched.exe
msiexec.exe /i "%PTH%\%JAVAVERSION%.msi" /qn TRANSFORMS="%PTH%\%JAVAVERSION%_NoUpdate.mst" /norestart /l c:\windows\temp\%JAVAVERSION%.log
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Java"
exit
