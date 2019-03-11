param (
    [object]
    $AlertInput
)

if(-not $AlertInput) {
	Write-Error "Alert inputs were empty" -ErrorAction Stop
}

$data = ConvertFrom-Json -InputObject $AlertInput

$alertRule = $data.AlertRuleName;
$description = $data.Description;

$input = @{};
$input.short_description = "$alertRule" #Short Description
$input.caller_id = '' #User Id
$input.category = '' #Inquiry type
$input.service_offering = '' #Service
$input.cmdb_ci = '' #Configuration item
$input.assignment_group ='' #Assignment Group
$input.priority = '' #Priority
$input.comments = "$description"

$body = ConvertTo-Json -InputObject $input;

return $body;
