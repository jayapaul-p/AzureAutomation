# **OMS - ServiceNow Integration**

# Project Overview
This project delineate the process involved to convert the alerts from Azure OMS(Operations management Suite) portal to incident tickets in ServiceNow . For more insights on OMS and its functionalities,watch the video [Azure Automation in OMS](https://azure.microsoft.com/en-in/resources/videos/automate-everywhere-with-the-new-azure-automation-in-oms-with-special-guest-jeffrey-snover/).

# **Manual Steps**

## 1. Create Automation Account
   
Use the below script to create an automation account.

```
New-AzAutomationAccount -Name scripte -ResourceGroupName MyResourceGroup -Location 'westeurope'
```  
<p align="center">(OR)</p>  

For more information on creation of automation account, refer the Microsoft [documentaion](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account).

## 2. Import Runbook
Go to home directory and clone this git repository using below commands

```
cd ~
git clone https://github.com/jayapaul-p/AzureAutomation.git
```
Import the runbook using below commands

```
cd ./AzureAutomation/OMS-SNOW-Integration/Runbook/
Import-AzAutomationRunbook -Path ./Create-SNOWIncident.ps1 -Type PowerShell -ResourceGroupName MyResourceGroup -AutomationAccountName scriptee -Name Create-SNOWIncident
Import-AzAutomationRunbook -Path ./Get-SNOWIncPayload.ps1 -Type PowerShell -ResourceGroupName MyResourceGroup -AutomationAccountName scriptee -Name Get-SNOWIncPayload
```  
<p align="center">(OR)</p>  

Refer the [documetation](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-runbook) to create and         import a runbook. 

## 3. Publish Runbook
Once after the runbook is imported and tested,follow the [steps](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-runbook#test-the-runbook) to publish the runbook.
     <p align="center">(OR)</p>
```
Publish-AzAutomationRunbook -Name Create-SNOWIncident -ResourceGroupName MyResourceGroup -AutomationAccountName scriptee
Publish-AzAutomationRunbook -Name Get-SNOWIncPayload -ResourceGroupName MyResourceGroup -AutomationAccountName scriptee
```  
  
## 4. Create Automation Credential
To create an automation credential with Azure portal and Powershell , follow the steps from [Creating a new credential asset](https://docs.microsoft.com/en-us/azure/automation/automation-credentials#creating-a-new-credential-asset).
   
<p align="center">(OR)</p>

```
New-AzAutomationCredential -Name SNOW-Connection -ResourceGroupName MyResourceGroup -AutomationAccountName scriptee -Value "rest_admin"
```  
     
## 5. Create Variables
After creating an automation credential , an automation variable should be created and the required steps are available in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-variables#creating-a-new-automation-variable).
  
<p align="center">(OR)</p>
  
Use the below commands  
 ```
New-AzAutomationVariable -Name snowInstaceName -Value "https://apazha.service-now.com" -ResourceGroupName MyResourceGroup -         AutomationAccountName scriptee -Encrypted $false
New-AzAutomationVariable -Name snowEndpoint -Value "/api/now/v1/table/incident" -ResourceGroupName MyResourceGroup -         AutomationAccountName scriptee -Encrypted $false
```  
 
## 6. Create Webhook
To create a webhook for the runbook , the required steps are available in the [document](https://docs.microsoft.com/en-us/azure/automation/automation-webhooks#creating-a-webhook).
 
<p align="center">(OR)</p>
   
Below cmdlet can be used for the creation of webhook
   
```
New-AzAutomationWebhook -Name ServiceNow-Incident -ExpiryTime "12/12/2019" -RunbookName "Create-SNOWIncident" -ResourceGroupName "MyResourceGroup" -AutomationAccountName scripte -IsEnabled $true -Force
```  
# Create Action Group
An action group is a collection of notification preferences defined by the owner of an Azure subscription , to create the action        group follow the steps from the azure portal [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/action-groups). 

<p align="center">(OR)</p>

Execute below commands to create action group with webhook receiver

```
$actionGroupReceiver = New-AzureRmActionGroupReceiver -WebhookReceiver -ServiceUri webhookUri -Name SNOW-Incident
Set-AzureRmActionGroup -Name 'SNOW-Incident' -ResourceGroupName MyResourceGroup -ShortName "SNOW-INC" -Receiver $actionGroupReceiver
```
  
# Link Action Group with Alerts
Once after the action group is created, it should be linked with the alerts that will be later created as an incident ticket in ServiceNow. Follow the [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric) to create alerts.

# ServiceNow Payload Configuration
Edit **Get-SNOWIncPayload.ps1** and make necessary changes in the payload based on project requirement.

```
$input.short_description = "$alertName - $computerName" #Short Description
$input.caller_id         = '' #User Id
$input.category          = '' #Inquiry type
$input.service_offering  = '' #Service
$input.cmdb_ci           = '' #Configuration item
$input.assignment_group  = '' #Assignment Group
$input.priority          = ''
$input.comments          = "$alertName - $computerName"
```

Refer ServiceNow Incident Table API [Link](https://docs.servicenow.com/bundle/geneva-servicenow-platform/page/integrate/inbound_rest/task/t_GetStartedCreateInt.html) for more information.


**Note: Alerts may send different type of inputs to runbook (Create-SNOWIncident.ps1), make neccessary changes based on project requirement.**
