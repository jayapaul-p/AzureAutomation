param (
    [Parameter(Mandatory=$false)]
    [object]
    $WebhookData
)

Write-Output $WebhookData;

#$data = ConvertFrom-Json -InputObject $WebhookData;

if ($WebHookData){
    $WebhookName = $WebhookData.WebhookName;
    $RequestBody = $WebhookData.RequestBody;
    $RequestHeader = $WebhookData.RequestHeader;

    if(-not $RequestBody) {
        Write-Output "WebhookName: $WebhookName"
        Write-Output "RequestBody: $RequestBody"
        Write-Output "RequestHeader: $RequestHeader"
    }
    else {
        Write-Error -Message 'Runbook was not started from Webhook. RequestBody was empty.' -ErrorAction Stop;
        exit 1;
    }
}
else
{
   Write-Error -Message 'Runbook was not started from Webhook. Webhookdata was empty.' -ErrorAction Stop;
   exit 1;
}


$snowEndpoint = Get-AutomationVariable -Name 'snowEndpoint';
$snowInstanceName = Get-AutomationVariable -Name 'snowInstanceName';
$restCrential = Get-AutomationPSCredential -Name 'SNOW-Connection';
$restUrl = $snowInstanceName + $snowEndpoint;

$payload = .\Get-SNOWIncPayload.ps1 -AlertInput $RequestBody

Write-Output "payload: $payload";

$hasCompleted = $false;
[int]$Retrycount = 0;
 
do {
    try {
        $response = Invoke-WebRequest -Uri $restUrl -Body $payload -Credential $restCrential -ContentType 'application/json' -Method Post -UseBasicParsing -ErrorAction Stop
        
        if($response.statusCode -eq 201) {
            $hasCompleted = $true
            Write-Output "Incident has been created successfully";
        }
    }
    catch {
        if ($Retrycount -gt 3){
            Write-Host "Could not create incident after 3 retries";
            $hasCompleted = $true
        }
        else {
            Write-Host "Could not create incident in ServiceNow, retrying in 30 seconds...";
            Start-Sleep -Seconds 30
            $Retrycount = $Retrycount + 1
        }
    }
}
While ($hasCompleted -eq $false)