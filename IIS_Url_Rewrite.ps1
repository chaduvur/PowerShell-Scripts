param
(
 [Parameter(Mandatory=$True,Position=0)]
 [string]$SiteName,
 [Parameter(Mandatory=$True,Position=1)]
 [string]$AppName,
 [Parameter(Mandatory=$True,Position=2)]
 [string]$Port
)

$site = "iis:\sites\"
$site="$site$SiteName"
$rulename="ReverseProxyInboundRule_"
$rulename = "$rulename$AppName"
$filterRoot = "system.webServer/rewrite/rules/rule[@name='$rulename']"
Clear-WebConfiguration -pspath $site -filter $filterRoot
Add-WebConfigurationProperty -pspath $site -filter "system.webServer/rewrite/rules" -name "." -value @{name='$rulename';patternSyntax='Regular Expressions';stopProcessing='True'}
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/match" -name "url" -value "$AppName(.*)"
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/conditions" -name "{CACHE_URL}" -value "^(https?)://"
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/action" -name "type" -value "Rewrite"
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/action" -name "url" -value "{C:1}://localhost:$Port/{R:1}"