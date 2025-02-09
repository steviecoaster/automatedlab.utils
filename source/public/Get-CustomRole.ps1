function Get-CustomRole {
    <#
    .SYNOPSIS
    List available custom roles
    
    .EXAMPLE
    Get-CustomRole
    #>
    [CmdletBinding()]
    Param()

    end {
        $LabSource = Get-LabSourcesLocation
        $RolePath = Join-Path $LabSource -ChildPath 'CustomRoles'

        (Get-ChildItem $RolePath -Directory).Name
    }
}