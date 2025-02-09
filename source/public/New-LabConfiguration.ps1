function New-LabConfiguration {
    <#
    .SYNOPSIS
    Creates a new lab configuration
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Name
    The name for the configuration
    
    .PARAMETER Definition
    A .ps1 file you wish to save with the configuration
    
    .PARAMETER Parameters
    A hashtable of Parameters that will be passed to the Definition when executed
    
    .PARAMETER Url
    A url to a PowerShell script you wish to include as the definition
    
    .EXAMPLE
    $conf = @{
    Name = 'Example'
    Definition = 'C:\temp\sample.ps1'
    Parameters = @{
        Animal = 'Dog'
        Breed = 'Lab'
        }
    }

    New-LabConfiguration @conf
    
    .EXAMPLE
    $conf = @{
    Name = 'Example'
    Url = 'https://files.fabrikam.com/myscript.ps1'
    Parameters = @{
        Animal = 'Dog'
        Breed = 'Lab'
       }
    }

    New-LabConfiguration @conf


    #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'default')]
        [Parameter(Mandatory, ParameterSetName = 'Git')]
        [String]
        $Name,

        [Parameter(Mandatory, ParameterSetName = 'default')]
        [String]
        $Definition,

        [Parameter(ParameterSetName = 'Git')]
        [Parameter(ParameterSetName = 'default')]
        [Hashtable]
        $Parameters,

        [Parameter(Mandatory, ParameterSetName = 'Git')]
        [String]
        $Url
    )

    end {

        $ConfigurationBase = Join-Path $env:LOCALAPPDATA -ChildPath 'PowerShell'
        $slug = Join-Path $env:USERNAME -ChildPath $Name

        $Configuration = Join-Path $ConfigurationBase -ChildPath $slug

        if (-not $Parameters) {
            $Parameters = @{}
        }

        #Add the name
        $Parameters.Add('Name', $Name)
        
        switch ($PSCmdlet.ParameterSetName) {
            'Git' {
                $Definition = Join-Path $Configuration -ChildPath 'Definition.ps1' 
            }
            default {
                $Definition = Resolve-Path $Definition
            }
        }

        @{
            Definition = $Definition
            Parameters = $Parameters
        } | Export-Configuration -CompanyName $env:USERNAME -Name $Name -Scope User

        # The configuration has to exist on disk before we can use it to build the path
        # where the definition will be saved when downloading from a Url.
        # So we postpone processing until we have exported the configuration with the correct
        # value, and then just drop the file there.
        if ($url) {
            [System.Net.WebClient]::new().DownloadFile($Url, $Definition)       
        }         

    }
}