function Stop-Lab {
    <#
    .SYNOPSIS
    Stops a running lab
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Name
    The lab to stop
    
    .EXAMPLE
    Stop-Lab -Name Example

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Name
    )

    Import-Lab -Name $Name
    Get-LabVM | Stop-LabVM
}