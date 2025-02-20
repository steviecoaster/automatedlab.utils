function Start-Lab {
    <#
    .SYNOPSIS
    Starts a Lab from the configuration
    
    .DESCRIPTION
    
    
    .PARAMETER Name
    The lab to build
    
    .PARAMETER AdditionalParameters
    Any additonal parameter to pass to the lab. Will get added to configuration parameters.
    
    .EXAMPLE
    Start-Lab -Name Example

    .EXAMPLE

    Start-Lab -Name Example -AdditionalParameters @{ Car = 'Corvette'}
    
    #>
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter()]
        [Hashtable]
        $AdditionalParameters
    )

    end {

        $configuration = Get-LabConfiguration -Name $Name
        $parameters = $configuration['Parameters']

        if ($AdditionalParameters) {
            $AdditionalParameters.GetEnumerator() | ForEach-Object {
                $parameters[$_.Key] = $_.Value
            }
        }

        try {
            Write-Warning "Attempting to start lab: $Name"
            Import-Lab -Name $Name -ErrorAction Stop
        }
        catch {
            Write-Warning "Lab $Name doesn't exist, creating and starting..."
            & $configuration['Definition'] @parameters
        }
    }
}