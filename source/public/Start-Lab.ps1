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

        if($AdditionalParameters){
            $AdditionalParameters.GetEnumerator() | ForEach-Object{
                $parameters.Add($_.Key,$_.Value)
            }
        }
        & $configuration['Definition'] @parameters
    }
}