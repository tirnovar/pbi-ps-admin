# Install-Module -Name MicrosoftPowerBIMgmt

Login-PowerBI

$token = (Get-PowerBIAccessToken)["Authorization"]
# Workspace ID
$groupId = '<ID>'

# a function that detects the URI of PowerBI the cluster where the workspace is currently located
function get-powerbiAPIclusterURI () {
  $reply = Invoke-RestMethod -uri "https://api.powerbi.com/v1.0/myorg/datasets" -Headers @{ "Authorization"=$token } -Method GET
  $unaltered = $reply.'@odata.context'
  $stripped = $unaltered.split('/')[2]
  $clusterURI = "https://$stripped/beta/myorg/groups"
  return $clusterURI
}

function getWorkspaceUsageMetrics($workspaceId) {
    $url = get-powerbiAPIclusterURI
    $data = Invoke-WebRequest -Uri "$url/$workspaceId/usageMetricsReportV2?experience=power-bi" -Headers @{ "Authorization"=$token }
    $response = $data.Content.ToString().Replace("nextRefreshTime", "NextRefreshTime").Replace("lastRefreshTime","LastRefreshTime") | ConvertFrom-Json
    return $response.models[0].dbName
}


$result = getWorkspaceUsageMetrics -workspaceId $groupId
$result