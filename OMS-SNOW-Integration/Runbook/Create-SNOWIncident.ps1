
param (
    [Parameter(Mandatory=$false)]
    [object]
    $WebhookData = '{"WebhookName":"Project16","RequestBody":"{\"schemaId\":\"AzureMonitorMetricAlert\",\"data\":{\"version\":\"2.0\",\"properties\":null,\"status\":\"Deactivated\",\"context\":{\"timestamp\":\"2019-03-01T06:03:05.5149375Z\",\"id\":\"/subscriptions/732cc012-4fed-4fe9-bfc2-7cf4788d5433/resourceGroups/MyResourceGroup/providers/microsoft.insights/metricAlerts/CPU%20greater%20than%2025\",\"name\":\"CPU greater than 25\",\"description\":\"\",\"conditionType\":\"MultipleResourceMultipleMetricCriteria\",\"severity\":\"2\",\"condition\":{\"windowSize\":\"PT1M\",\"allOf\":[{\"metricName\":\"Percentage CPU\",\"metricNamespace\":\"Microsoft.Compute/virtualMachines\",\"operator\":\"GreaterThan\",\"threshold\":\"25\",\"timeAggregation\":\"Maximum\",\"dimensions\":[{\"name\":\"microsoft.resourceId\",\"value\":\"/subscriptions/732cc012-4fed-4fe9-bfc2-7cf4788d5433/resourceGroups/MyResourceGroup/providers/Microsoft.Compute/virtualMachines/Window10\"},{\"name\":\"microsoft.resourceType\",\"value\":\"Microsoft.Compute/virtualMachines\"}],\"metricValue\":8.44}]},\"subscriptionId\":\"732cc012-4fed-4fe9-bfc2-7cf4788d5433\",\"resourceGroupName\":\"MyResourceGroup\",\"resourceName\":\"Window10\",\"resourceType\":\"Microsoft.Compute/virtualMachines\",\"resourceId\":\"/subscriptions/732cc012-4fed-4fe9-bfc2-7cf4788d5433/resourceGroups/MyResourceGroup/providers/Microsoft.Compute/virtualMachines/Window10\",\"portalLink\":\"https://portal.azure.com/#resource/subscriptions/732cc012-4fed-4fe9-bfc2-7cf4788d5433/resourceGroups/MyResourceGroup/providers/Microsoft.Compute/virtualMachines/Window10\"}}}","RequestHeader":{"Expect":"100-continue","Host":"s2events.azure-automation.net","User-Agent":"IcMBroadcaster/1.0","X-CorrelationContext":"RkkKACgAAAACAAAAEACoOQg9KJ/3TZMcKBuGUQEvAQAQAB+8fkvxH2ZPjopKqbGv/YI=","x-ms-request-id":"d876db67-4e26-4f55-9dc3-1442e0916f5b"}}'
)

Write-Output $WebhookData;

$data = ConvertFrom-Json -InputObject $WebhookData;

$WebhookName = $data.WebhookName;
$RequestBody = $data.RequestBody;
$RequestHeader = $data.RequestHeader;

$snowEndpoint = Get-AutomationVariable -Name 'snowEndpoint';
$restCrential = Get-AutomationPSCredential -Name 'SNOW-Connection';

$payload = .\Get-SNOWIncPayload.ps1 -AlertInput $RequestBody

Write-Output "payload: $payload";

Invoke-WebRequest -Uri $snowEndpoint -Body $payload -Credential $restCrential -ContentType 'application/json' -Method Post -UseBasicParsing