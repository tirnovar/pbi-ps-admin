<#
  _____        _          ____            _   _                   
 |  __ \      | |        |  _ \          | | | |                  
 | |  | | __ _| |_ __ _  | |_) |_ __ ___ | |_| |__   ___ _ __ ___ 
 | |  | |/ _` | __/ _` | |  _ <| '__/ _ \| __| '_ \ / _ \ '__/ __|
 | |__| | (_| | || (_| | | |_) | | | (_) | |_| | | |  __/ |  \__ \
 |_____/ \__,_|\__\__,_| |____/|_|  \___/ \__|_| |_|\___|_|  |___/                                                              

#>

<# REQUIREMENTS #>
#Requires -Modules @{ ModuleName="MicrosoftPowerBIMgmt"; ModuleVersion="1.2.1077" }

<# FUNCTIONS #>
function Post-Rebind {
    param(
        [string]$dataset,
        [string]$report,
        [string]$group
    )
    
    $preparedBody = @{ "datasetId" = $dataset }
    
    try {
        Invoke-PowerBIRestMethod -Url "groups/$($group)/reports/$($report)/Rebind" -Method Post -Body ($preparedBody | ConvertTo-Json)
        Write-Host -ForegroundColor Green "The rebinding process has finished successfully"
    }
    catch {
        $_.Exception
    }
    
}

<# PROMPT #>
function ShowPrompt() {
    while ($true) {
        while ($true) {
            Write-Host -ForegroundColor Yellow "Report Rebinder"
            Write-Host "Choose action:"
            Write-Host " [r] - Start Rebinding"
            Write-Host " [q] - Quit"
    
            $action = Read-Host -Prompt "Please, choose action"
    
            break
        }
    
        if ($action -and ($action -ne "r")) {
            if ($action -eq "q") {
                Write-Host "Have a nice day!"
                return $false | Out-Null
                
            }
            Clear-Host
            Write-Host -ForegroundColor Red "  Invalid action!  "
            Write-Host ""
        }
        elseif ($action -eq "r") {
            break
        }
    }
    Login-PowerBI
    
    $targetDatasetId = Read-Host -Prompt "Enter target dataset ID"
    if (!$targetDatasetId) {
        Write-Error "Invalid dataset id"
    }
    
    $targetGroupId = Read-Host -Prompt "Enter group (workspace) ID"
    if (!$targetDatasetId) {
        Write-Error "Invalid group id"
    }
    
    $targetReportId = Read-Host -Prompt "Enter report ID"
    if (!$targetDatasetId) {
        Write-Error "Invalid report id"
    }
        
    if ($action -eq "r") {
        Post-Rebind -dataset $targetDatasetId -group $targetGroupId -report $targetReportId
    }
}

<# START OF CODE #>
ShowPrompt