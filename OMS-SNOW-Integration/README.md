# OMS - SNOW Integration

# **Fully Automated Method**
Clone the repo and execute setup.ps1

# **Manual Method*

## 1.Create Automation Account
```
 New-AzAutomationAccount -Name scripte -ResourceGroupName MyResourceGroup -Location 'westeurope'
```
*(OR)*
Follow the steps available in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account).

## 2.Import Runbook
Follow the steps in the [link](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-runbook) to create a runbook.

## 3.Publish Runbook
Once after the runbook is imported and tested , follow the [steps](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-runbook#test-the-runbook) to publish the runbook.

## 4.Create Automation Credential

## 5.Create Variables

## 6.Create Webhook

## 7.Create Action Group

## 8.Link Action Group with Alerts
