
param (
    [Parameter(Mandatory=$false)]
    [object]
    $WebhookData
)

Write-Output $WebhookData;

#$data = ConvertFrom-Json -InputObject $WebhookData;

$WebhookName = $WebhookData.WebhookName;
$RequestBody = $WebhookData.RequestBody;
$RequestHeader = $WebhookData.RequestHeader;

Write-Output "WebhookName => $WebhookName"
Write-Output "RequestBody => $RequestBody"
Write-Output "RequestHeader => $RequestHeader"


$snowEndpoint = Get-AutomationVariable -Name 'snowEndpoint';
$snowInstanceName = Get-AutomationVariable -Name 'snowInstanceName';
$restCrential = Get-AutomationPSCredential -Name 'SNOW-Connection';
$restUrl = $snowInstanceName + $snowEndpoint;

$payload = .\Get-SNOWIncPayload.ps1 -AlertInput $RequestBody

Write-Output "payload: $payload";

Invoke-WebRequest -Uri $restUrl -Body $payload -Credential $restCrential -ContentType 'application/json' -Method Post -UseBasicParsing