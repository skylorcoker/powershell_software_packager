# http://www.scconfigmgr.com/2014/08/22/how-to-get-msi-file-information-with-powershell/
#http://stackoverflow.com/questions/6816450/call-powershell-script-ps1-from-another-ps1-script-inside-powershell-ise
#http://stackoverflow.com/questions/12356869/invoke-executable-w-parameters-from-powershell-script

$NEWLINE = "`r`n"

$SCRIPTHEADER			= "@echo off" + $NEWLINE + $NEWLINE
$INSTALLSCRIPTHEADER	= $SCRIPTHEADER + "REM Set PTH to the current directory of the script" + $NEWLINE + "set PTH=%~dp0" + $NEWLINE
$UNINSTALLSCRIPTHEADER	= $SCRIPTHEADER

###################################################################################################################
# Function:	GetMSIinfo
# Purpose:	Returns a requested MSI Property from a provided MSI
###################################################################################################################
Function GetMSIinfo {

	Param (
		[parameter(Mandatory=$true)] [IO.FileInfo]$Path,
		[parameter(Mandatory=$true)] [ValidateSet("ProductCode","ProductVersion","ProductName")] [string]$Property
	)
	
	Try {
		$WindowsInstaller	= New-Object -ComObject WindowsInstaller.Installer
		$MSIDatabase		= $WindowsInstaller.GetType().InvokeMember("OpenDatabase","InvokeMethod",$Null,$WindowsInstaller,@($Path.FullName,0))
		$Query				= "SELECT Value FROM Property WHERE Property = '$($Property)'"
		$View				= $MSIDatabase.GetType().InvokeMember("OpenView","InvokeMethod",$null,$MSIDatabase,($Query))
		$View.GetType().InvokeMember("Execute", "InvokeMethod", $null, $View, $null)
		$Record				= $View.GetType().InvokeMember("Fetch","InvokeMethod",$null,$View,$null)
		$Value				= $Record.GetType().InvokeMember("StringData","GetProperty",$null,$Record,1)
		Write-Host $Value
		Return $Value
	} 
	Catch { Write-Output $_.Exception.Message }
}

Function GetMSIUninstallIntructions {
	Param (
		[parameter(Mandatory=$true)] $ProductCode
	)
	
	Return "@echo off" + $NEWLINE + "msiexec.exe /x " + $ProductCode + " /qn /norestart"
}

Get-ChildItem "C:\Scripts" -Filter  *.msi | ForEach-Object {

	#$MSIPath = ('C:\Scripts\' + $_)
	$MSIPath				= $_.FullName
	$MSIName				= $_
	$ProductName			= GetMSIinfo -Path $MSIPath -Property 'ProductName'
	$ProductVersion			= GetMSIinfo -Path $MSIPath -Property 'ProductVersion'
	$MSIProductCode			= GetMSIinfo -Path $MSIPath -Property 'ProductCode'
	$AdditionalResources	= $FALSE

	#Lets Create our Package Folder
	Switch -wildcard($ProductName) {
		("*7-Zip*")							{	$ProductManufacturer	= "IgorPavlov"
												$ProductName			= "7-Zip"
												$Bitness				= "x64"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + 'msiexec.exe /i "%PTH%\"' + $MSIName + ' /qn /norestart'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
											}
		("*AIR*")							{	$ProductManufacturer	= "Adobe"
												$ProductName			= "AIR"
												$Bitness				= "x86"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + 'msiexec.exe /i "%PTH%\' + $MSIName +  '" /qn /norestart /log C:\Windows\Temp\AirInstall.log'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
												$AdditionalResources	= $TRUE
												$ResourcePath			= "C:\Scripts\Resources\AIR"
											}  
		("*ActiveX*")						{	$ProductManufacturer	= "Adobe"
												$ProductName			= "FlashPlayerActiveX"
												$Bitness				= "x86"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + "REM Lets Kill MSIEXEC" + $NEWLINE + "taskkill /F /IM msiexec.exe" + $NEWLINE + $NEWLINE + "md %windir%\syswow64\macromed\flash"+ $NEWLINE + 'copy /Y "%PTH%\mms - silent updates disabled.cfg" %WINDIR%\SysWow64\Macromed\Flash\mms.cfg'+ $NEWLINE + 'msiexec.exe /i "%PTH%\' + $MSIName +  '" /qn /norestart' + $NEWLINE + 'schtasks /delete /TN "Adobe Flash Player Updater" /F'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
												$AdditionalResources	= $TRUE
												$ResourcePath			= "C:\Scripts\Resources\FlashPlayer"
											}
		("*NPAPI*")							{	$ProductManufacturer	= "Adobe"
												$ProductName			= "FlashPlayerPlugin"
												$Bitness				= "x86"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + "REM Lets Kill MSIEXEC" + $NEWLINE + "taskkill /F /IM msiexec.exe" + $NEWLINE + $NEWLINE + "md %windir%\syswow64\macromed\flash"+ $NEWLINE + 'copy /Y "%PTH%\mms - silent updates disabled.cfg" %WINDIR%\SysWow64\Macromed\Flash\mms.cfg'+ $NEWLINE + 'msiexec.exe /i "%PTH%\' + $MSIName +  '" /qn /norestart' + $NEWLINE + 'schtasks /delete /TN "Adobe Flash Player Updater" /F'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
												$AdditionalResources	= $TRUE
												$ResourcePath			= "C:\Scripts\Resources\FlashPlayer"
											}
		("*plugin*")						{	$ProductManufacturer	= "Adobe"
												$ProductName			= "FlashPlayerPlugin"
												$Bitness				= "x86"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + "REM Lets Kill MSIEXEC" + $NEWLINE + "taskkill /F /IM msiexec.exe" + $NEWLINE + $NEWLINE + "md %windir%\syswow64\macromed\flash"+ $NEWLINE + 'copy /Y "%PTH%\mms - silent updates disabled.cfg" %WINDIR%\SysWow64\Macromed\Flash\mms.cfg'+ $NEWLINE + 'msiexec.exe /i "%PTH%\' + $MSIName +  '" /qn /norestart' + $NEWLINE + 'schtasks /delete /TN "Adobe Flash Player Updater" /F'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
												$AdditionalResources	= $TRUE
												$ResourcePath			= "C:\Scripts\Resources\FlashPlayer"
											}
		("*Google Chrome*")					{	$ProductManufacturer	= "Google"
												$ProductName			= "ChromeForEnterprise"
												$Bitness				= "x86"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + "set PREFILE=master_preferences" + $NEWLINE + "set INSTALLPATH=%ProgramFiles(x86)%\Google\Chrome\Application\" + $NEWLINE + $NEWLINE + 'msiexec.exe /i "%PTH%\' + $MSIName + '" /qn /norestart' + $NEWLINE + 'copy %PREFILE% "%INSTALLPATH%" /Y' + $NEWLINE + 'del /q /f "%PUBLIC%\Desktop\Google Chrome.lnk"'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
												$AdditionalResources	= $TRUE
												$ResourcePath			= "C:\Scripts\Resources\GoogleChrome"
											}
		("*Snagit*")						{	$ProductManufacturer	= "TechSmithCorporation"
												$ProductName			= "Snagit"
												$Bitness				= "x86"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + 'msiexec.exe /i "%PTH%\' + $MSIName + '" TRANSFORMS="%PTH%\snagit11.mst" /qn REBOOT=ReallySuppress TSC_TUDI_OPTIN=0 TSC_START_AUTO=0 ALLUSERS=1 /log C:\Windows\temp\SnagIt11_Install.log'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
												$AdditionalResources	= $TRUE
												$ResourcePath			= "C:\Scripts\Resources\Snagit"
											}
		("*Cisco Desktop Administrator*")	{	$ProductManufacturer	= "Cisco"
												$ProductName			= "DesktopAdministrator"
												$Bitness				= "x86"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + 'msiexec.exe /i "%PTH%\' + $MSIName + '" /qn /norestart'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
											}
		("*Right Click Tools*")				{	$ProductManufacturer	= "NowMicro"
												$ProductName			= "Right-Click-Tools"
												$Bitness				= "x86"
												$InstallInstructions	= $INSTALLSCRIPTHEADER + 'msiexec.exe /i "%PTH%\' + $MSIName + '" /qn /norestart'
												$UninstallIntructions	= GetMSIUninstallIntructions $MSIProductCode
											}
	}
	
	$PackageName		= $ProductManufacturer + "_" +$ProductName + "_" + $ProductVersion + "_" + $Bitness
	
	New-Item -ItemType Directory -Path ('C:\Scripts\' + $PackageName)													#Create a folder based on the package name
	New-Item -Path ("C:\Scripts\" + $PackageName) -Name "install.cmd"	-Type "file" -Value $InstallInstructions		#Create the install script
	New-Item -Path ("C:\Scripts\" + $PackageName) -Name "uninstall.cmd"	-Type "file" -Value $UninstallInstructions     	#Create the uninstall script
	
	#Start-Sleep -Seconds 10
	
	Copy-Item $MSIPath ("C:\Scripts\" + $PackageName)																	#Copy the MSI out to the package folder

	If ($AdditionalResources) {																							#Let's get any other resources we need for this package
		Get-ChildItem $ResourcePath | ForEach-Object { Copy-Item ($ResourcePath + $_) ("C:\Scripts\" + $PackageName) }
	}
}

###########################################################################################################################################
# LETS GET EXE's
###########################################################################################################################################

Get-ChildItem "C:\Scripts" -Filter  *.exe | ForEach-Object {
	$EXEPath				= $_.FullName
	$EXEName				= $_
	$AdditionalResources	= $FALSE

	If ($_ -like '*Firefox*') {

		#Write-Host $_.FullName
		Set-Alias 7z 'C:\Scripts\Resources\7zip\7za.exe'
		$UnzipLocation = ('C:\Scripts\FirefoxUnzip\')
		If (Test-Path $UnzipLocation) { Remove-Item $UnzipLocation -recurse }
		#& "7z" x ("C:\Users\scoker\Desktop\Firefox Test\" + $_) "-o$UnzipLocation"
		& "7z" x $_.Fullname  "-o$UnzipLocation"


		$ProductVersion	= (Get-Item ($UnzipLocation + '\setup.exe')).VersionInfo.ProductVersion.TrimEnd()
		$ProductName	= (Get-Item ($UnzipLocation + '\setup.exe')).VersionInfo.ProductName.TrimEnd()
		
	} Else { #NOT FIREFOX#

		$ProductVersion	= (Get-Item $EXEPath).VersionInfo.ProductVersion.TrimEnd()
		$ProductName	= (Get-Item $EXEPath).VersionInfo.ProductName.TrimEnd()

		If ($ProductName -eq "")	{ ($ProductName		= (Get-Item $EXEPath).VersionInfo.FileDescription.TrimEnd()) }	#???
		If ($ProductVersion -eq "") { ($ProductVersion	= (Get-Item $EXEPath).VersionInfo.FileVersion.TrimEnd()) }		#???
	}
	
	Switch -wildcard($ProductName) {																					#Create Package Container
		("*Adobe Connect*")		{	$ProductManufacturer	= "Adobe"
									$ProductName			= "Connect"
									$Bitness				= "x86"
									$InstallInstructions	= $INSTALLSCRIPTHEADER + '"%PTH%\' + $EXEName +  '" /SP /SILENT /VERYSILENT'
									$UninstallIntructions	= $UNINSTALLSCRIPTHEADER + "C:\Users\%USERNAME%\AppData\Roaming\Macromedia\Flash Player\www.macromedia.com\bin\adobeconnectaddin\adobeconnectaddin.exe -uninstall"
									$AdditionalResources	= $TRUE
									$ResourcePath			= "C:\Scripts\Resources\AdobeConnect"
								}
		("*KeePass*")			{	$ProductManufacturer	= "Sourceforge"
									$ProductName			= "KeePass"
									$Bitness				= "x86"
									$InstallInstructions	= $INSTALLSCRIPTHEADER + 'set APPPATH=%PROGRAMFILES(X86)%\KeePass Password Safe 2' + $NEWLINE + 'set CONFIGFILE=KeePass.config.enforced.xml' + $NEWLINE + '"%PTH%\' + $EXEName +  '"/verysilent' + $NEWLINE + 'copy "%PTH%\%CONFIGFILE%" "%APPPATH%"'
									$UninstallIntructions	= $UNINSTALLSCRIPTHEADER + '"C:\Program Files (x86)\KeePass Password Safe 2\unins000.exe" /SILENT'
									$AdditionalResources	= $TRUE
									$ResourcePath			= "C:\Scripts\Resources\KeePass"
								}
		("*Citrix Receiver*")	{	$ProductManufacturer	= "Citrix"
									$ProductName			= "Receiver"
									$Bitness				= "x86"
									$InstallInstructions	= $INSTALLSCRIPTHEADER + '"%PTH%\' + $EXEName +  '" /silent /norestart'
									$UninstallIntructions	= $UNINSTALLSCRIPTHEADER + 'Coming Back to this One'
								}
		("*Firefox*")			{	$ProductManufacturer	= "Mozilla"
									$ProductName			= "Firefox"
									$Bitness				= "x86"
									$InstallInstructions	= $INSTALLSCRIPTHEADER + 'md "C:\Program Files (x86)\Mozilla Firefox"' + $NEWLINE + 'copy "%PTH%\is.ini" "c:\Program Files (x86)\Mozilla Firefox" /Y' + $NEWLINE + '"%PTH%\' + $EXEName +  '" /INI="C:\Program Files (x86)\Mozilla Firefox\is.ini"'
									$UninstallIntructions	= $UNINSTALLSCRIPTHEADER + '"C:\Program Files (x86)\Mozilla Firefox\Uninstall\helper.exe" /S' 
									$AdditionalResources	= $TRUE
									$ResourcePath			= "C:\Scripts\Resources\Firefox"
								}
	}
	
	$PackageName	= $ProductManufacturer + "_" + $ProductName + "_" + $ProductVersion + "_" + $Bitness
		
	New-Item -ItemType Directory -Path ('C:\Scripts\' + $PackageName)													#Create a folder based on the package name
	New-Item -Path ("C:\Scripts\" + $PackageName) -Name "install.cmd"	-Type "file" -Value $InstallInstructions		#Create the install script
	New-Item -Path ("C:\Scripts\" + $PackageName) -Name "uninstall.cmd" -Type "file" -Value $UninstallIntructions     	#Create the uninstall script
	
	Copy-Item $EXEPath ("C:\Scripts\" + $PackageName)																	#Copy the EXE out to the package folder

	If ($AdditionalResources) {																							#Let's get any other resources we need for this package
		Get-ChildItem $ResourcePath | ForEach-Object { Copy-Item ($ResourcePath + $_) ("C:\Scripts\" + $PackageName) }
	}

	If (Test-Path $UnzipLocation) {	Remove-Item $UnzipLocation -recurse	}												#Clean up temporarily extracted files
}

