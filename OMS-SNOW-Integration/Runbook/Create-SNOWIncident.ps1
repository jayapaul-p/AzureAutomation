param (
    [Parameter(Mandatory=$false)]
    [object]
    $WebhookData
)

Write-Output $WebhookData;

#$data = ConvertFrom-Json -InputObject $WebhookData;

#$WebhookName = $data.WebhookName;
#$RequestBody = $data.RequestBody;
#$RequestHeader = $data.RequestHeader;

$WebhookName = $WebhookData.WebhookName;
$RequestBody = $WebhookData.RequestBody;
$RequestHeader = $WebhookData.RequestHeader;

Write-Output "WebhookName => $WebhookName"
Write-Output "RequestBody => $RequestBody"
Write-Output "RequestHeader => $RequestHeader"


$snowEndpoint = Get-AutomationVariable -Name 'snowEndpoint';
$restCrential = Get-AutomationPSCredential -Name 'SNOW-Connection';

$payload = .\Get-SNOWIncPayload.ps1 -AlertInput $RequestBody

Write-Output "payload: $payload";

Invoke-WebRequest -Uri $snowEndpoint -Body $payload -Credential $restCrential -ContentType 'application/json' -Method Post -UseBasicParsing