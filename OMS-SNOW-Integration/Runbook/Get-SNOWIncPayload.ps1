param (
    [object]
    $AlertInput
)

$data = ConvertFrom-Json -InputObject $AlertInput

$computerName = $data.data.context.resourceName;
$alertName = $data.data.context.name;

$input = @{};
$input.short_description = "$alertName - $computerName"
$input.caller_id = ''
$input.category = ''
$input.cmdb_ci = ''
$input.assignment_group =''
$input.priority = ''
$input.comments = "$alertName - $computerName"

$body = ConvertTo-Json -InputObject $input;

return $body;