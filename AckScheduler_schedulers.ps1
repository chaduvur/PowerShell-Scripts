#following parameters are passed as arguments to this script dynamically
param
(
 [Parameter(Mandatory=$True,Position=0)]
 [string]$TaskXmlLocation,
 [Parameter(Mandatory=$True,Position=1)]
 [string]$Domain,
 [Parameter(Mandatory=$True,Position=2)]
 [string]$User,
 [Parameter(Mandatory=$True,Position=3)]
 [string]$Pass,
 [Parameter(Mandatory=$True,Position=4)]
 [string]$AppName
)


$TaskXmlFiles = Get-ChildItem -Path "$TaskXmlLocation" -Include *.xml -recurse

$temp = "$Domain\$User"

$path = "CDK\"
$path = "$path$AppName"
$path = $path+'\'

foreach ($file in $TaskXmlFiles)
{
	$TaskXmlFile = $file.fullname
	$TaskName = $file.BaseName
	Write-Host $temp
	Write-Host "$path$TaskName"
	schtasks.exe /CREATE /TN "$path$TaskName" /XML $TaskXmlFile /RU $temp /RP $Pass /F

}
