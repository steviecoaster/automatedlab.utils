function New-CustomRole {
    <#
    .SYNOPSIS
    Creates a new Custom Role in AutomatedLab
    
    .PARAMETER Name
    The name of the custom role
    
    .PARAMETER InitScript
    If you already have the role script written, provide it with -InitScript
    
    .PARAMETER AdditionalFiles
    Provide the file path of any additional files the role requires to function
    
    .EXAMPLE
    New-CustomRole -Name SampleRole

    Create a new role called SampleRole. It will be bootstrapped for you.

    .EXAMPLE
    NEw-CustomRole -Name SampleRole -InitScript C:\scripts\role_scripts\SampleRole.ps1

    Create a new role called SampleRole, and use an existing InitScript

    .EXAMPLE
    New-CustomRole -Name SampleRole -AdditionalFiles C:\temp\cert.pfx,C:\temp\my.lic

    Create a new role called SampleRole and provide some additonal files it requires
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter()]
        [ValidateScript({ 
                if ((Test-Path $_) -and ((Get-Item $_).Name -eq "$Name.ps1")) {
                    $true
                } 
                else {
                    throw "The init script must be named $Name.ps1"
                }
            })]
        [String]
        $InitScript,

        [Parameter()]
        [ValidateScript({
                $af = $_
                $af | ForEach-Object { Test-Path $_ }
            })]
        [String[]]
        $AdditionalFiles
    )

    end {

        $LabSourcesLocation = Get-LabSourcesLocation
        $rolePath = Join-Path (Join-Path $LabSourcesLocation -ChildPath 'CustomRoles') -ChildPath $Name
        if (-not (Test-Path $rolePath)) {
            $null = New-Item $rolePath -ItemType Directory

            #If user provides an init script, put it in the role folder
            if ($InitScript) {
                Copy-Item $InitScript -Destination $rolePath
            }
            else {
                # otherwise create an empty one
                $null = New-Item -Path $rolePath -Name "$($Name).ps1" -ItemType File
            }
            if ($AdditionalFiles) {
                Copy-Item $AdditionalFiles -Destination $rolePath
            }
        }
        else {
            throw 'Role already exists. Please choose a different name.'
        }
    }
}