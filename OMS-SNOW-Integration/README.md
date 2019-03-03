# OMS - SNOW Integration

# **Fully Automated Method**
Clone the repo and execute setup.ps1

# **Manual Method**

   ## 1.Create Automation Account
   Use the below script to create an automation account.
   ```
   New-AzAutomationAccount -Name scripte -ResourceGroupName MyResourceGroup -Location 'westeurope'
   ```
   *(OR)*
   Follow the steps available in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account).

   ## 2.Import Runbook
   Follow the steps in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-runbook) to create a        runbook. 

   ## 3.Publish Runbook
   Once after the runbook is imported and tested,follow the [steps](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-runbook#test-the-runbook) to publish the runbook.
 
  ## 4.Create Automation Credential
  To create an automation credential with Azure portal and Powershell , follow the steps from [Creating a new credential asset](https://docs.microsoft.com/en-us/azure/automation/automation-credentials#creating-a-new-credential-asset).

  ## 5.Create Variables
  After creating an automation credential , an automation variable should be created and the required steps are available in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-variables#creating-a-new-automation-variable).

  ## 6.Create Webhook
  To create a webhook for the runbook , the required steps are available in the [document](https://docs.microsoft.com/en-us/azure/automation/automation-webhooks#creating-a-webhook).
  ## 7.Create Action Group
  An action group is a collection of notification preferences defined by the owner of an Azure subscription , to create the action group follow the steps from the azure portal [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/action-groups#create-an-action-group-by-using-the-azure-portal).
  ## 8.Link Action Group with Alerts
  Once after the  action group is creted , it should be linked with the alerts.......... 
