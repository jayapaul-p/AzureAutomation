Param
(
    [Parameter(Mandatory = $true)]
    $AutomationAccountName,

    [Parameter(Mandatory = $true)]
    $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    $ResourceGroupLocation="westeurope",

    [Parameter(Mandatory = $true)]
    $ServiceNowInstanceName,

    [Parameter(Mandatory = $true)]
    [PSCredential]
    $ServiceNowCredential
)


try {
    New-AzAutomationAccount -Name $AutomationAccountName -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -ErrorAction Stop;
}
catch {

    Write-Error $_;
    exit;
}

try {
    Set-Location ~ -ErrorAction Stop;
    Set-Location ./AzureAutomation/OMS-SNOW-Integration/Runbook/ -ErrorAction Stop;
    Import-AzAutomationRunbook -Path ./Create-SNOWIncident.ps1 -Type PowerShell -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Name Create-SNOWIncident -ErrorAction Stop;
	Import-AzAutomationRunbook -Path ./Get-SNOWIncPayload.ps1 -Type PowerShell -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Name Get-SNOWIncPayload -ErrorAction Stop;
}
catch {
    Write-Error $_;
    exit
}


try {
    Publish-AzAutomationRunbook -Name Create-SNOWIncident -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -ErrorAction Stop;
}
catch {
    Write-Error $_;
    exit
}

try {
    New-AzAutomationCredential -Name SNOW-Connection -ResourceGroupName $ResourceGroupName -Value $ServiceNowCredential -AutomationAccountName $AutomationAccountName -ErrorAction Stop;
}
catch {
    Write-Host $_;
    exit;
}

try {
    New-AzAutomationVariable -Name snowInstaceName -Value $ServiceNowInstanceName -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Encrypted $false -ErrorAction Stop;
	New-AzAutomationVariable -Name snowEndpoint -Value "/api/now/v1/table/incident" -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Encrypted $false -ErrorAction Stop;
}
catch {
    Write-Host $_;
    exit;
}

try {
    New-AzAutomationWebhook -Name ServiceNow-Incident -ExpiryTime "12/12/2019" -RunbookName "Create-SNOWIncident" -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -IsEnabled $true -Force -ErrorAction Stop;
}
catch {
    Write-Host $_;
    exit;
    
}