# **OMS - ServiceNow Integration**

# Project Overview
This project delineate the process involved to convert the alerts from Azure OMS(Operations management Suite) portal to incident tickets in ServiceNow . For more insights on OMS and its functionalities, watch the video [Azure Automation in OMS](https://azure.microsoft.com/en-in/resources/videos/automate-everywhere-with-the-new-azure-automation-in-oms-with-special-guest-jeffrey-snover/).

Follow below steps to configure OMS-ServiceNow without manual intervention. For manual configuration steps please refer the [Link](./Manual_Steps_README.md).

# **Automated Steps**

Login to Azure portal and open **cloud shell** (located top corner with PowerShell icon). or go to https://shell.azure.com/
Clone the repository and execute setup.ps1 PowerShell script
```
cd ~
git clone https://github.com/jayapaul-p/AzureAutomation.git
```

## Syntax
```
./setup.ps1 -AutomationAccountName <String> -ResourceGroupName <String> -ResourceGroupLocation <String> -ServiceNowInstanceName <String> -ServiceNowCredential <PSCredential>
```

## Description
The **setup.ps1** script creates integration between OMS and ServiceNow.

## Example:
### Create a OMS-SNOW integration
```
PS C:\> ./setup.ps1 -AutomationAccountName "scriptee" -ResourceGroupName "MyResourceGroup" -ResourceGroupLocation "westeurope" -ServiceNowInstanceName "https://apazha.service-now.com" -ServiceNowCredential "rest_admin"
```
This command creates an integration between ServiceNow and OMS

## Parameters
| Parameter               |  Type         | Description                   |
| :---------------------- | :------------:|:----------------------------- | 
| -AutomationAccountName  | String        |Name of the Automation Account |
| -ResourceGroupName      | String        |Name of the already existed Resource Group|
| -ResourceGroupLocation  | String        |Resource Group Location|
| -ServiceNowInstanceName | String        |URL of the ServiceNow instance|
| -ServiceNowCredential   | PSCredential  |REST API access credential|

   
# Create Action Group
An action group is a collection of notification preferences defined by the owner of an Azure subscription , to create the action        group follow the steps from the azure portal [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/action-groups). 

<p align="center">(OR)</p>

Execute below commands to create action group with webhook receiver

```
$actionGroupReceiver = New-AzureRmActionGroupReceiver -WebhookReceiver -ServiceUri webhookUri -Name SNOW-Incident
Set-AzureRmActionGroup -Name 'SNOW-Incident' -ResourceGroupName MyResourceGroup -ShortName "SNOW-INC" -Receiver $actionGroupReceiver
```

# Link Action Group with Alerts
Once after the action group is created, it should be linked with the alerts that will be later created as an incident ticket in ServiceNow. Follow the [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric) to create alerts

# ServiceNow Payload Configuration
Edit **Get-SNOWIncPayload.ps1** and make necessary changes in the payload.

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
