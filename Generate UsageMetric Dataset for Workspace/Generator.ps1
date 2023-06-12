# Install-Module -Name MicrosoftPowerBIMgmt

Login-PowerBI

$token = (Get-PowerBIAccessToken)["Authorization"]
# Workspace ID
$groupId = '<ID>'
# Power BI REST API PROXY URL
# WEST EUROPE LINK https://wabi-west-europe-d-primary-redirect.analysis.windows.net/beta/myorg/groups
$url = '<URL>'

function getWorkspaceUsageMetrics($workspaceId) {
    
    $data = Invoke-WebRequest -Uri "$url/$workspaceId/usageMetricsReportV2?experience=power-bi" -Headers @{ "Authorization"=$token }
    $response = $data.Content.ToString().Replace("nextRefreshTime", "NextRefreshTime").Replace("lastRefreshTime","LastRefreshTime") | ConvertFrom-Json
    return $response.models[0].dbName
}


$result = getWorkspaceUsageMetrics -workspaceId $groupId
$result