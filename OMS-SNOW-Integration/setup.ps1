Param
(
    [Parameter(Mandatory = $false)]
    $AutomationAccountName,

    [Parameter(Mandatory = $false)]
    $ResourceGroupName,

    [Parameter(Mandatory = $false)]
    $ResourceGroupNameLocation,

    [Parameter(Mandatory = $false)]
    $ServiceNowInstanceName,

    [Parameter(Mandatory = $true)]
    [PSCredential]
    $ServiceNowCredential
)


try {
    New-AzAutomationAccount -Name scripte1 -ResourceGroupName MyResourceGroup -Location 'westeurope-20' -ErrorAction Stop;
}
catch {

    Write-Host $_;
    exit;

}

try {
    Set-Location ~ -ErrorAction Stop
    Set-Location ./AzureAutomation/OMS-SNOW-Integration/Runbook/ -ErrorAction Stop
    Import-AzAutomationRunbook -Path ./Create-SNOWIncident.ps1 -Type PowerShell -ResourceGroupName MyResourceGroup -AutomationAccountName scripte -Name Create-SNOWIncident -ErrorAction Stop
}
catch {
    Write-Host $_;
    exit
}


try {
    Publish-AzAutomationRunbook -Name Create-SNOWIncident -ResourceGroupName MyResourceGroup -AutomationAccountName scripte 
}
catch {
    Write-Host $_;
    exit
}

try {

    New-AzAutomationCredential -Name SNOW-Connection -ResourceGroupName MyResourceGroup -AutomationAccountName scripte
 
}
catch {
    Write-Host $_;
    exit;
}


try {
    New-AzAutomationVariable -Name snowInstaceNam -Value https://dev54236.service-now.com/ -ResourceGroupName MyResourceGroup -AutomationAccountName scripte -Encrypted $false 
}
catch {
    Write-Host $_;
    exit;
}

try {
    New-AzAutomationWebhook -Name SNOWINC -ExpiryTime "12/12/2019" -RunbookName "Create-SNOWIncident" -ResourceGroupName "MyResourceGroup" -AutomationAccountName scripte -IsEnabled $true -Force 
}
catch {
    Write-Host $_;
    exit;
    
}