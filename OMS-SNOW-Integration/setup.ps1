Param
(
    [Parameter(Mandatory = $true)]
    $AutomationAccountName,

    [Parameter(Mandatory = $true)]
    $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    $ResourceGroupLocation = "westeurope",

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
    Write-Output "New automation account creation has been failed.\nError Message: $_.Message";
    exit;
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
    Write-Output "Unable to import runbooks.\nError Message: $_.Message";
    exit
}


try {
    Publish-AzAutomationRunbook -Name Create-SNOWIncident -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -ErrorAction Stop;
    Publish-AzAutomationRunbook -Name Get-SNOWIncPayload -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -ErrorAction Stop;
    Write-Output "Runbooks have been published successfully";
}
catch {
    Write-Error $_;
    Write-Output "Unable to publish runbook.\nError Message: $_.Message";
    exit
}

try {
    New-AzAutomationCredential -Name SNOW-Connection -ResourceGroupName $ResourceGroupName -Value $ServiceNowCredential -AutomationAccountName $AutomationAccountName -ErrorAction Stop;
    Write-Output "SNOW connection has been created successfully";
}
catch {
    Write-Host $_;
    Write-Output "Error occurred while creating SNOW connection.\nError Message: $_.Message";
    exit;
}

try {
    New-AzAutomationVariable -Name snowInstanceName -Value $ServiceNowInstanceName -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Encrypted $false -ErrorAction Stop;
    New-AzAutomationVariable -Name snowEndpoint -Value "/api/now/v1/table/incident" -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Encrypted $false -ErrorAction Stop;
    Write-Output "Automation variables have been created successfully";
}
catch {
    Write-Host $_;
    Write-Output "Error occurred while creating automation variables"
    exit;
}

try {
    $webhookResponse = New-AzAutomationWebhook -Name ServiceNow-Incident -ExpiryTime "12/12/2019" -RunbookName "Create-SNOWIncident" -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -IsEnabled $true -Force -ErrorAction Stop;
    $webhookName = $webhookResponse.WebhookURI
    Write-Output "Webhook has been created successfully";
}
catch {
    Write-Host $_;
    Write-Output "Error occurred while creating webhook";
    exit;
}

try {
    $actionGroupReceiver = New-AzureRmActionGroupReceiver -WebhookReceiver -ServiceUri $webhookName -Name SNOW-Incident -ErrorAction Stop
    Set-AzureRmActionGroup -Name 'SNOW-Incident' -ResourceGroupName $ResourceGroupName -ShortName "SNOW-INC" -Receiver $actionGroupReceiver -ErrorAction Stop
}
catch {
    Write-Host $_;
    Write-Output "Error occurred while creating Action Group. Error Message: $_.Message";
    exit;   
}