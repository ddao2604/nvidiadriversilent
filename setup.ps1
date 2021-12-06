[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.innerHTML -eq 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
$installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
Invoke-WebRequest $dlurl -OutFile $installerPath
Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest "http://us.download.nvidia.com/tesla/451.82/451.82-tesla-desktop-winserver-2019-2016-international.exe" -OutFile "c:\driver.exe"
$7zpath = Get-ItemProperty -path  HKLM:\SOFTWARE\7-Zip\ -Name Path
$7zpath = $7zpath.Path
$7zpathexe = $7zpath + "7z.exe"
$filesToExtract = "c:\driver.exe"
$extractFolder = "c:\driver"
Start-Process -FilePath $7zpathexe -NoNewWindow -ArgumentList "x -bso0 -bsp1 -bse1 -aoa $dlFile $filesToExtract -o""$extractFolder""" -wait
$install_args = "-passive -noreboot -noeula -nofinish -s"
Start-Process -FilePath "$extractFolder\setup.exe" -ArgumentList $install_args -wait