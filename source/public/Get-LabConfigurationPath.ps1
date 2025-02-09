function Get-LabConfigurationPath {
    <#
    .SYNOPSIS
    Returns the path to the lab configuration
        
    .PARAMETER Name
    The lab to return
    
    .EXAMPLE
    Get-LabCOnfiguration -Name MyLab
    
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Name
    )

    end {
        Get-ConfigurationPath -Name $Name -CompanyName $env:USERNAME -Scope User
    }
}