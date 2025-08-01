function Get-PSULabInfo {
    <#
    .SYNOPSIS
    Imports a lab by name and returns basic information about the lab machines.
    
    .DESCRIPTION
    This function imports an AutomatedLab by name and returns information about each machine
    including the name, processor count, memory, and operating system.
    
    .PARAMETER LabName
    The name of the lab to import and analyze.
    
    .EXAMPLE
    Get-LabInfo -LabName "MyTestLab"
    
    .EXAMPLE
    Get-LabInfo "MyTestLab" | Format-Table -AutoSize
    
    .NOTES
    This function requires the AutomatedLab module to be installed and available.
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            try {
                $availableLabs = Get-Lab -List
                $availableLabs | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
            }
            catch {
                # Return empty array if Get-Lab fails
                @()
            }
        })]
        [string]$LabName
    )
    
    try {
        # Import the specified lab
        Write-Verbose "Importing lab: $LabName"
        Import-Lab -Name $LabName -NoValidation | Out-Null
        
        # Get all machines in the lab
        $machines = Get-LabVM
        $status = Get-LabVMStatus -AsHashTable
        if (-not $machines) {
            Write-Warning "No machines found in lab '$LabName'"
            return
        }
        
        # Create custom objects with the requested information
        $labInfo = foreach ($machine in $machines) {
            [PSCustomObject]@{
                Name = $machine.Name
                ProcessorCount = $machine.Processors
                Memory = $machine.Memory
                OperatingSystem = $machine.OperatingSystem.OperatingSystemName
                MemoryGB = [Math]::Round($machine.Memory / 1GB, 2)
                Status = $status[$machine.Name]
            }
        }
        
        Write-Verbose "Retrieved information for $($labInfo.Count) machines"
        return $labInfo
    }
    catch {
        Write-Error "Failed to import lab '$LabName': $($_.Exception.Message)"
        throw
    }
}

# Example usage and testing function
function Test-GetLabInfo {
    <#
    .SYNOPSIS
    Test function to demonstrate Get-LabInfo usage.
    #>
    
    # Get list of available labs
    Write-Host "Available labs:" -ForegroundColor Green
    $availableLabs = Get-Lab -List
    
    if ($availableLabs) {
        $availableLabs | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
        
        # Example of how to use the function
        Write-Host "`nExample usage:" -ForegroundColor Green
        Write-Host "Get-LabInfo -LabName '$($availableLabs[0])'" -ForegroundColor Cyan
        Write-Host "Get-LabInfo '$($availableLabs[0])' | Format-Table -AutoSize" -ForegroundColor Cyan
        Write-Host "Get-LabInfo '$($availableLabs[0])' | Where-Object { `$_.ProcessorCount -gt 2 }" -ForegroundColor Cyan
    }
    else {
        Write-Host "No labs found. Create a lab first using AutomatedLab." -ForegroundColor Red
    }
}