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
    
    .PARAMETER InitUrl
    This is a url to a PowerShell hosted online, e.g a gist or repository.

    .EXAMPLE
    New-CustomRole -Name SampleRole

    Create a new role called SampleRole. It will be bootstrapped for you.

    .EXAMPLE
    New-CustomRole -Name SampleRole -InitScript C:\scripts\role_scripts\SampleRole.ps1

    Create a new role called SampleRole, and use an existing InitScript

    .EXAMPLE
    New-CustomRole -Name SampleRole -AdditionalFiles C:\temp\cert.pfx,C:\temp\my.lic

    Create a new role called SampleRole and provide some additonal files it requires

    .EXAMPLE
    New-CustomRole -Name SampleRole -InitUrl https://fabrikam.com/roles/SampleRole/role.ps1

    Creates a new role called SampleRole and downloads the role script from a url and saves it as SampleRole.ps1
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter()]
        [ValidateScript({ 
                if ((Test-Path $_) -and ((Get-Item $_).Extension -eq ".ps1")) {
                    $true
                } 
                else {
                    throw "The init script either doesn't exist or must be a .ps1 file!"
                }
            })]
        [String]
        $InitScript,

        [Parameter()]
        [string]
        $InitUrl,

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

           
            if ($InitScript) {
                # If user provides an init script, put it in the role folder
                Copy-Item $InitScript -Destination "$rolePath\$Name.ps1"
            }

            elseif($InitUrl) {
                # When provided a url it downloads the scipt contents and saves it as the role script
                $Script = Join-Path $rolePath -ChildPath "$($Name).ps1"
                $contents = [System.Net.WebClient]::New().DownloadString($InitUrl)
                $contents | Out-File $Script
            }

            else {
                # Otherwise we just create a blank role script
                $null = New-Item -Path $rolePath -Name "$($Name).ps1" -ItemType File
            }
            
            # Copy any additional files to the role
            if ($AdditionalFiles) {
                Copy-Item (Resolve-Path $AdditionalFiles) -Destination $rolePath
            }
        }

        else {
            throw 'Role already exists. Please choose a different name.'
        }
    }
}