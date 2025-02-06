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

    try {

        Import-Lab -Name $Name -ErrorAction Stop
        Get-LabVM | Stop-LabVM
    }
    catch {
        Write-Error -Message 'Lab was not found. Use Start-Lab to start or build first' -Exception ([System.IO.FileNotFoundException]::New())
    }
}