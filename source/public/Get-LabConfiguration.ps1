function Get-LabConfiguration {
    <#
    .SYNOPSIS
    Returns a configuration object
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Name
    The name of the configuration to return
    
    .EXAMPLE
    Get-LabConfiguration -Name Example
    
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Name
    )

    end {
        Import-Configuration -Name $Name -CompanyName $env:USERNAME
    }
}