Param
(
    [Parameter(Mandatory = $true)]
    $AutomationAccountName,

    [Parameter(Mandatory = $true)]
    $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    $ResourceGroupLocation,

    [Parameter(Mandatory = $true)]
    $ServiceNowInstanceName,

    [Parameter(Mandatory = $true)]
    [PSCredential]
    $ServiceNowCredential
)


try {
    New-AzAutomationAccount -Name $AutomationAccountName -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -ErrorAction Stop;
    Write-Output "New automation account has been created successfully";
}
catch {

    Write-Error $_;
    Write-Error "New automation account creation has been failed.\nError Message: $($_.Exception.Response.Content)";
    exit 1;
}

try {
    Set-Location ~ -ErrorAction Stop;
    Set-Location ./AzureAutomation/OMS-SNOW-Integration/Runbook/ -ErrorAction Stop;
    Import-AzAutomationRunbook -Path ./Create-SNOWIncident.ps1 -Type PowerShell -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Name Create-SNOWIncident -ErrorAction Stop;
    Import-AzAutomationRunbook -Path ./Get-SNOWIncPayload.ps1 -Type PowerShell -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Name Get-SNOWIncPayload -ErrorAction Stop;
    Write-Output "Runbooks have been imported successfully";
}
catch {
    Write-Error $_;
    Write-Error "Unable to import runbooks.\nError Message: $_.Exception.Message";
    exit 1;
}


try {
    Publish-AzAutomationRunbook -Name Create-SNOWIncident -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -ErrorAction Stop;
    Publish-AzAutomationRunbook -Name Get-SNOWIncPayload -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -ErrorAction Stop;
    Write-Output "Runbooks have been published successfully";
}
catch {
    Write-Error $_;
    Write-Error "Unable to publish runbook.\nError Message: $_.Exception.Message";
    exit 1;
}

try {
    New-AzAutomationCredential -Name SNOW-Connection -ResourceGroupName $ResourceGroupName -Value $ServiceNowCredential -AutomationAccountName $AutomationAccountName -ErrorAction Stop;
    Write-Output "SNOW connection has been created successfully";
}
catch {
    Write-Error $_;
    Write-Error "Error occurred while creating SNOW connection.\nError Message: $_.Exception.Message";
    exit 1;
}

try {
    New-AzAutomationVariable -Name snowInstanceName -Value $ServiceNowInstanceName -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Encrypted $false -ErrorAction Stop;
    New-AzAutomationVariable -Name snowEndpoint -Value "/api/now/v1/table/incident" -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Encrypted $false -ErrorAction Stop;
    Write-Output "Automation variables have been created successfully";
}
catch {
    Write-Error $_;
    Write-Error "Error occurred while creating automation variables"
    exit 1;
}

try {
    $webhookResponse = New-AzAutomationWebhook -Name ServiceNow-Incident -ExpiryTime "12/12/2019" -RunbookName "Create-SNOWIncident" -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -IsEnabled $true -Force -ErrorAction Stop;
    $webhookName = $webhookResponse.WebhookURI
    Write-Output "Webhook has been created successfully";
}
catch {
    Write-Error $_;
    Write-Error "Error occurred while creating webhook";
    exit 1;
}

try {
    $actionGroupReceiver = New-AzureRmActionGroupReceiver -WebhookReceiver -ServiceUri $webhookName -Name SNOW-Incident -ErrorAction Stop
    Set-AzureRmActionGroup -Name 'SNOW-Incident' -ResourceGroupName $ResourceGroupName -ShortName "SNOW-INC" -Receiver $actionGroupReceiver -ErrorAction Stop
}
catch {
    Write-Error $_;
    Write-Error "Error occurred while creating Action Group. Error Message: $_.Exception.Message";
    exit 1;   
}