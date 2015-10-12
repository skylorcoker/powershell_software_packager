# http://www.scconfigmgr.com/2014/08/22/how-to-get-msi-file-information-with-powershell/

#http://stackoverflow.com/questions/6816450/call-powershell-script-ps1-from-another-ps1-script-inside-powershell-ise

#http://stackoverflow.com/questions/12356869/invoke-executable-w-parameters-from-powershell-script

 

 

 

Get-ChildItem "C:\Scripts" -Filter  *.msi | ForEach-Object {

 

#$MSIPath = ('C:\Scripts\' + $_)

$MSIPath = $_.FullName

$MSIName = $_

$ProductName = GetMSIinfo -Path $MSIPath -Property 'ProductName'

$ProductVersion = GetMSIinfo -Path $MSIPath -Property 'ProductVersion'

$MSI = GetMSIinfo -Path $MSIPath -Property 'ProductCode'

$NewLine = "`r`n"

 

#Lets Create our Package Folder
#Once we fully create a custome install package we add to this list.
#Build something that is consistant and reproducable.

Switch -wildcard($ProductName)

            {

      ("*7-Zip*") {$PackageName = ("IgorPavlov_7-Zip_" + $ProductVersion + "_x64") ; break}

      ("*AIR*") {$PackageName = ("Adobe_AIR_" + $ProductVersion + "_x86") ; break} 

      ("*ActiveX*") {$PackageName = ("Adobe_FlashPlayerActiveX_" + $ProductVersion + "_x86") ; break}

      ("*NPAPI*") {$PackageName = ("Adobe_FlashPlayerPlugin_" + $ProductVersion + "_x86") ; break}

      ("*plugin*") {$PackageName = ("Adobe_FlashPlayerPlugin_" + $ProductVersion + "_x86") ; break}

      ("*Google Chrome*") {$PackageName = ("Google_ChromeForEnterprise_" + $ProductVersion + "_x86") ; break}

      ("*Snagit*") {$PackageName = ("TechSmithCorporation_Snagit_" + $ProductVersion + "_x86") ; break}

      ("*Cisco Desktop Administrator*") {$PackageName = ("Cisco_DesktopAdministrator_" + $ProductVersion + "_x86") ; break}

      ("*Right Click Tools*") {$PackageName = ("NowMicro_Right-Click-Tools_" + $ProductVersion + "_x86") ; break}

           

            }

New-Item -ItemType directory -Path ('C:\Scripts\' + $PackageName)

 

 

#Lets Create our Resources (Install & Uninstall CMD)

Switch -wildcard($PackageName)

      {

      ("*AIR*"){ $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"    + $NewLine + "set PTH=%~dp0" + $NewLine + 'msiexec.exe /i "%PTH%\' + $MSIName +  '" /qn /norestart /log C:\Windows\Temp\AirInstall.log'}

      ("*ActiveX*"){ $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"    + $NewLine + "set PTH=%~dp0" + $NewLine + $NewLine + "REM Lets Kill MSIEXEC" + $NewLine + "taskkill /F /IM msiexec.exe" + $NewLine + $NewLine + "md %windir%\syswow64\macromed\flash"+ $NewLine + 'copy /Y "%PTH%\mms - silent updates disabled.cfg" %WINDIR%\SysWow64\Macromed\Flash\mms.cfg'+ $NewLine + 'msiexec.exe /i "%PTH%\' + $MSIName +  '" /qn /norestart' + $NewLine + 'schtasks /delete /TN "Adobe Flash Player Updater" /F'}

      ("*Plugin*"){ $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"    + $NewLine + "set PTH=%~dp0" + $NewLine + $NewLine + "REM Lets Kill MSIEXEC" + $NewLine + "taskkill /F /IM msiexec.exe" + $NewLine + $NewLine + "md %windir%\syswow64\macromed\flash"+ $NewLine + 'copy /Y "%PTH%\mms - silent updates disabled.cfg" %WINDIR%\SysWow64\Macromed\Flash\mms.cfg'+ $NewLine + 'msiexec.exe /i "%PTH%\' + $MSIName +  '" /qn /norestart' + $NewLine + 'schtasks /delete /TN "Adobe Flash Player Updater" /F'}

      ("*7-Zip*") { $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"    + $NewLine + "set PTH=%~dp0" + $NewLine + 'msiexec.exe /i "%PTH%\"' + $MSIName + ' /qn /norestart'}

      ("*ChromeForEnterprise*") { $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script" + $NewLine + "set PTH=%~dp0" + $NewLine + "set PREFILE=master_preferences" + $NewLine + "set INSTALLPATH=%ProgramFiles(x86)%\Google\Chrome\Application\" + $NewLine + $NewLine + 'msiexec.exe /i "%PTH%\' + $MSIName + '" /qn /norestart' + $NewLine + 'copy %PREFILE% "%INSTALLPATH%" /Y' + $NewLine + 'del /q /f "%PUBLIC%\Desktop\Google Chrome.lnk"'}

      ("*Snagit*") { $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"    + $NewLine + "set PTH=%~dp0" + $NewLine + $NewLine + 'msiexec.exe /i "%PTH%\' + $MSIName + '" TRANSFORMS="%PTH%\snagit11.mst" /qn REBOOT=ReallySuppress TSC_TUDI_OPTIN=0 TSC_START_AUTO=0 ALLUSERS=1 /log C:\Windows\temp\SnagIt11_Install.log'}

      ("*Cisco_DesktopAdmin*") { $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script" + $NewLine + "set PTH=%~dp0" + $NewLine + $NewLine + 'msiexec.exe /i "%PTH%\' + $MSIName + '" /qn /norestart'}

      ("*NowMicro_Right-Click*") { $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script" + $NewLine + "set PTH=%~dp0" + $NewLine + $NewLine + 'msiexec.exe /i "%PTH%\' + $MSIName + '" /qn /norestart'}

 

 

      }

$CreateUninstall = "@echo off" + $NewLine + "msiexec.exe /x " + $MSI + " /qn /norestart"

 

New-Item -Path ("C:\Scripts\" + $PackageName) -Name "install.cmd" -Type "file" -Value $CreateInstall

 

New-Item -Path ("C:\Scripts\" + $PackageName) -Name "uninstall.cmd" -Type "file" -Value $CreateUninstall       

 

#Start-Sleep -Seconds 10

 

Copy-Item $MSIPath ("C:\Scripts\" + $PackageName)

 

#Lets get any other resources we need for this package#

Switch -wildcard($PackageName)

      {

      ("*AIR*"){Get-ChildItem "C:\Scripts\Resources\AIR" | ForEach-Object {Copy-Item ("C:\Scripts\Resources\AIR\" + $_) ("C:\Scripts\" + $PackageName) }}

      ("*Flash*"){Get-ChildItem "C:\Scripts\Resources\FlashPlayer" | ForEach-Object {Copy-Item ("C:\Scripts\Resources\FlashPlayer\" + $_) ("C:\Scripts\" + $PackageName) }}

      ("*Chrome*"){Get-ChildItem "C:\Scripts\Resources\GoogleChrome" | ForEach-Object {Copy-Item ("C:\Scripts\Resources\GoogleChrome\" + $_) ("C:\Scripts\" + $PackageName) }}

      ("*Snagit*"){Get-ChildItem "C:\Scripts\Resources\Snagit" | ForEach-Object {Copy-Item ("C:\Scripts\Resources\Snagit\" + $_) ("C:\Scripts\" + $PackageName) }}

      }

}

 

###########################################################################################################################################

# LETS GET EXE's

###########################################################################################################################################

 

Get-ChildItem "C:\Scripts" -Filter  *.exe | ForEach-Object {

 

If ($_ -like '*Firefox*') {

 

 

 

#Write-Host $_.FullName

Set-Alias 7z 'C:\Scripts\Resources\7zip\7za.exe'

$UnzipLocation = ('C:\Scripts\FirefoxUnzip\')

      If (Test-Path $UnzipLocation)

      {

      Remove-Item $UnzipLocation -recurse

      }

#& "7z" x ("C:\Users\scoker\Desktop\Firefox Test\" + $_) "-o$UnzipLocation"

& "7z" x $_.Fullname  "-o$UnzipLocation"

 

 

$EXEPath = $_.FullName

$EXEName = $_

$ProductVersion = (Get-Item ($UnzipLocation + '\setup.exe') ).VersionInfo.ProductVersion.TrimEnd()

$ProductName = (Get-Item ($UnzipLocation + '\setup.exe')).VersionInfo.ProductName.TrimEnd()

$NewLine = "`r`n"

 

}

Else #NOT FIREFOX#

{

$EXEPath = ('C:\Scripts\' + $_)

$EXEName = $_

$ProductVersion = (Get-Item $EXEPath).VersionInfo.ProductVersion.TrimEnd()

$ProductName = (Get-Item $EXEPath).VersionInfo.ProductName.TrimEnd()

$NewLine = "`r`n"

 

If ($ProductName -eq "")

      {

      ($ProductName = (Get-Item $EXEPath).VersionInfo.FileDescription.TrimEnd())

      }

If ($ProductVersion -eq "")

      {

      ($ProductVersion = (Get-Item $EXEPath).VersionInfo.FileVersion.TrimEnd())

      }

}

 

#Create Package Container

Switch -wildcard($ProductName)

            {

      ("*Adobe Connect*") {$PackageName = ("Adobe_Connect_" + $ProductVersion + "_x86") ; break}

      ("*KeePass*") {$PackageName = ("Sourceforge_KeePass_" + $ProductVersion + "_x86") ; break}

      ("*Citrix Receiver*") {$PackageName = ("Citrix_Receiver_" + $ProductVersion + "_x86") ; break}

      ("*Firefox*") {$PackageName = ("Mozilla_Firefox_" + $ProductVersion + "_x86") ; break}

                 

            }

New-Item -ItemType directory -Path ('C:\Scripts\' + $PackageName)

 

#Lets Create our Install

Switch -wildcard($PackageName)

      {

      ("*Adobe_Connect*"){ $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"   + $NewLine + "set PTH=%~dp0" + $NewLine + '"%PTH%\' + $EXEName +  '" /SP /SILENT /VERYSILENT'}

      ("*KeePass*"){ $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"    + $NewLine + "set PTH=%~dp0" + $NewLine + 'set APPPATH=%PROGRAMFILES(X86)%\KeePass Password Safe 2' + $NewLine + 'set CONFIGFILE=KeePass.config.enforced.xml' + $NewLine + '"%PTH%\' + $EXEName +  '"/verysilent' + $NewLine + 'copy "%PTH%\%CONFIGFILE%" "%APPPATH%"'}

      ("*Citrix_Receiver*"){ $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"     + $NewLine + "set PTH=%~dp0" + $NewLine + '"%PTH%\' + $EXEName +  '" /silent /norestart'}

      ("*Firefox*"){ $CreateInstall = "@echo off" + $NewLine + $NewLine + "REM Set PTH to the current directory of the script"    + $NewLine + "set PTH=%~dp0" + $NewLine + 'md "C:\Program Files (x86)\Mozilla Firefox"' + $NewLine + 'copy "%PTH%\is.ini" "c:\Program Files (x86)\Mozilla Firefox" /Y' + $NewLine + '"%PTH%\' + $EXEName +  '" /INI="C:\Program Files (x86)\Mozilla Firefox\is.ini"'}

     

      

      

      }

#Lest Create our Uninstall

Switch -wildcard($PackageName)

      {

      ("*Adobe_Connect*"){ $CreateUninstall = "@echo off" + $NewLine + $NewLine + "C:\Users\%USERNAME%\AppData\Roaming\Macromedia\Flash Player\www.macromedia.com\bin\adobeconnectaddin\adobeconnectaddin.exe -uninstall"}

      ("*KeePass*"){ $CreateUninstall = "@echo off" + $NewLine + $NewLine + '"C:\Program Files (x86)\KeePass Password Safe 2\unins000.exe" /SILENT'}

      ("*Citrix_Receiver*"){ $CreateUninstall = "@echo off" + $NewLine + $NewLine + 'Coming Back to this One'}

      ("*Firefox*"){ $CreateUninstall = "@echo off" + $NewLine + $NewLine + '"C:\Program Files (x86)\Mozilla Firefox\Uninstall\helper.exe" /S'}

     

      

      

      }

 

 

New-Item -Path ("C:\Scripts\" + $PackageName) -Name "install.cmd" -Type "file" -Value $CreateInstall

 

New-Item -Path ("C:\Scripts\" + $PackageName) -Name "uninstall.cmd" -Type "file" -Value $CreateUninstall

 

Copy-Item $EXEPath ("C:\Scripts\" + $PackageName)

 

#Lets get any other resources we need for this package#

Switch -wildcard($PackageName)

      {

      ("*KeePass*"){Get-ChildItem "C:\Scripts\Resources\KeePass" | ForEach-Object {Copy-Item ("C:\Scripts\Resources\KeePass\" + $_) ("C:\Scripts\" + $PackageName) }}

      ("*Adobe_Connect*"){Get-ChildItem "C:\Scripts\Resources\AdobeConnect" | ForEach-Object {Copy-Item ("C:\Scripts\Resources\AdobeConnect\" + $_) ("C:\Scripts\" + $PackageName) }}

      ("*Firefox*"){Get-ChildItem "C:\Scripts\Resources\Firefox" | ForEach-Object {Copy-Item ("C:\Scripts\Resources\Firefox\" + $_) ("C:\Scripts\" + $PackageName) }}

 

      }

 

If (Test-Path $UnzipLocation)

      {

      Remove-Item $UnzipLocation -recurse

      }

#End ForEach-Object (EXE)

}

#########################

 

 

 

 

 

 

Function GetMSIinfo {

 

param(

[parameter(Mandatory=$true)]

[IO.FileInfo]$Path,

[parameter(Mandatory=$true)]

[ValidateSet("ProductCode","ProductVersion","ProductName")]

[string]$Property

)

try {

    $WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer

    $MSIDatabase = $WindowsInstaller.GetType().InvokeMember("OpenDatabase","InvokeMethod",$Null,$WindowsInstaller,@($Path.FullName,0))

    $Query = "SELECT Value FROM Property WHERE Property = '$($Property)'"

    $View = $MSIDatabase.GetType().InvokeMember("OpenView","InvokeMethod",$null,$MSIDatabase,($Query))

    $View.GetType().InvokeMember("Execute", "InvokeMethod", $null, $View, $null)

    $Record = $View.GetType().InvokeMember("Fetch","InvokeMethod",$null,$View,$null)

    $Value = $Record.GetType().InvokeMember("StringData","GetProperty",$null,$Record,1)

      Write-Host $Value

    return $Value

      }

catch {

    Write-Output $_.Exception.Message

        }

                              }