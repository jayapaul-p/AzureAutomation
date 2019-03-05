# **OMS - SNOW Integration**

# Project Overview
  This project provides the steps to integrate Azure OMS (Operations management Suite) with ServiceNow. For more insights on OMS and its   functionalities,watch the video [Azure Automation in OMS](https://azure.microsoft.com/en-in/resources/videos/automate-everywhere-with-the-new-azure-automation-in-oms-with-special-guest-jeffrey-snover/).

# **Fully Automated Method**

Login to Azure portal and open **cloud shell** (located top corner with PowerShell icon). or go to https://shell.azure.com/

Clone the repository and execute setup.ps1 PowerShell script

```
cd ~
git clone https://github.com/jayapaul-p/AzureAutomation.git
```

## SYNTAX

```
./setup.ps1 -AutomationAccountName <String> -ResourceGroupName <String> -ResourceGroupLocation <String> -ServiceNowInstanceName <String> -ServiceNowCredential <PSCredential>
```

## DESCRIPTION
The **setup.ps1** script creates integration between OMS and ServiceNow.

## EXAMPLES

### Example 1: Create a OMS-SNOW integration
```
PS C:\> ./setup.ps1 -AutomationAccountName "scriptee" -ResourceGroupName "MyResourceGroup" -ResourceGroupLocation "westeurope" -ServiceNowInstanceName "https://apazha.service-now.com" -ServiceNowCredential "rest_admin"
```

This command creates a integration between ServiceNow and OMS

## PARAMETERS

### -AutomationAccountName

Name of the Automation Account

```yaml
Type: String
```
### -ResourceGroupName

Name of the Resource Group Name

```yaml
Type: String
```
### -ResourceGroupLocation

To be updated

```yaml
Type: String
```

### -ServiceNowInstanceName

Name of the ServiceNow instance

```yaml
Type: String
```

### -ServiceNowCredential

Name of the ServiceNow instance

```yaml
Type: PSCredential
```


# **Manual Method**

   ## 1.Create Automation Account
   
   Use the below script to create an automation account.
   ```
   New-AzAutomationAccount -Name scripte -ResourceGroupName MyResourceGroup -Location 'westeurope'
   ```  
   *(OR)*  
   
   Follow the steps available in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account).

   ## 2.Import Runbook
   
   ### Clone git repo

```
cd ~
git clone https://github.com/jayapaul-p/AzureAutomation.git
```
### Import Runbook
```
cd ./AzureAutomation/OMS-SNOW-Integration/Runbook/
Import-AzAutomationRunbook -Path ./Create-SNOWIncident.ps1 -Type PowerShell -ResourceGroupName MyResourceGroup -AutomationAccountName scripte -Name Create-SNOWIncident

```  
   *(OR)*  
   


   
   Follow the steps in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-runbook) to create and    import a runbook. 

   ## 3.Publish Runbook
   
   ```
   Publish-AzAutomationRunbook -Name Create-SNOWIncident -ResourceGroupName MyResourceGroup -AutomationAccountName scripte
   ```  
   *(OR)*  
   
   Once after the runbook is imported and tested,follow the [steps](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-runbook#test-the-runbook) to publish the runbook.
 
  ## 4.Create Automation Credential
  
  ```
  New-AzAutomationCredential -Name SNOW-Connection -ResourceGroupName MyResourceGroup -AutomationAccountName scripte -Value admin

```  
   *(OR)*  
   
  
  To create an automation credential with Azure portal and Powershell , follow the steps from [Creating a new credential asset](https://docs.microsoft.com/en-us/azure/automation/automation-credentials#creating-a-new-credential-asset).

  ## 5.Create Variables
  
  ```
  New-AzAutomationVariable -Name snowInstaceNam -Value https://dev54236.service-now.com/ -ResourceGroupName MyResourceGroup -AutomationAccountName scripte -Encrypted $false
  ```  
   *(OR)*  
   
  
  After creating an automation credential , an automation variable should be created and the required steps are available in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-variables#creating-a-new-automation-variable).

  ## 6.Create Webhook
  
  ```
  New-AzAutomationWebhook -Name SNOWINC -ExpiryTime "12/12/2019" -RunbookName "Create-SNOWIncident" -ResourceGroupName "MyResourceGroup" -AutomationAccountName scripte -IsEnabled $true -Force
  ```  
   *(OR)*  
   
  
  To create a webhook for the runbook , the required steps are available in the [document](https://docs.microsoft.com/en-us/azure/automation/automation-webhooks#creating-a-webhook).
  
  ## 7.Create Action Group
  An action group is a collection of notification preferences defined by the owner of an Azure subscription , to create the action group follow the steps from the azure portal [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/action-groups#create-an-action-group-by-using-the-azure-portal).
  
  ## 8.Link Action Group with Alerts
  Once after the  action group is creted , it should be linked with the alerts.......... 
