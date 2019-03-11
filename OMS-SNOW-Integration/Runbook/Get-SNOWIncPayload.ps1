param (
    [object]
    $AlertInput
)

if($AlertInput) {
	Write-Error "Alert inputs were empty" -ErrorAction Stop
}

$data = ConvertFrom-Json -InputObject $AlertInput

$computerName = $data.data.context.resourceName;
$alertName = $data.data.context.name;

$input = @{};
$input.short_description = "$alertName - $computerName" #Short Description
$input.caller_id = '' #User Id
$input.category = '' #Inquiry type
$input.service_offering = '' #Service
$input.cmdb_ci = '' #Configuration item
$input.assignment_group ='' #Assignment Group
$input.priority = '' #Priority
$input.comments = "$alertName - $computerName"

$body = ConvertTo-Json -InputObject $input;

return $body;