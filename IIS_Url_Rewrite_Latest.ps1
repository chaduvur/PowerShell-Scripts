param
(
 [Parameter(Mandatory=$True,Position=0)]
 [string]$SiteName,
 [Parameter(Mandatory=$True,Position=1)]
 [string]$AppName,
 [Parameter(Mandatory=$True,Position=2)]
 [string]$Port
)

$site = "IIS:\Sites\"
$site="$site$SiteName"

$name = "ReverseProxyInboundRule_"
$name = "$name$AppName"

$inbound = "{0}(.*)" -f $AppName
$outbound = "{C:1}://localhost:$Port/{R:1}"
$pattern = '^(https?)://'
$root = 'system.webServer/rewrite/rules'
$filter = "{0}/rule[@name='{1}']" -f $root, $name

Clear-WebConfiguration -pspath $site -filter $filter
Add-WebConfigurationProperty -PSPath $site -filter $root -name '.' -value @{name=$name; patterSyntax='Regular Expressions'; stopProcessing='True'}
Set-WebConfigurationProperty -PSPath $site -filter "$filter/match" -name 'url' -value $inbound
Set-WebConfigurationProperty -PSPath $site -filter "$filter/conditions" -name '.' -value @{input='{CACHE_URL}'; pattern=$pattern}
Set-WebConfigurationProperty -PSPath $site -filter "$filter/action" -name 'type' -value 'Rewrite'
Set-WebConfigurationProperty -PSPath $site -filter "$filter/action" -name 'url' -value $outbound
Set-WebConfigurationProperty -PSPath $site -filter "$filter/action" -name 'logRewrittenUrl' -value 'True'