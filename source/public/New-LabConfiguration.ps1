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

        [Parameter(Mandatory, ParameterSetName = 'Git')]
        [Parameter(Mandatory, ParameterSetName = 'default')]
        [Hashtable]
        $Parameters,

        [Parameter(Mandatory, ParameterSetName = 'Git')]
        [String]
        $Url
    )

    end {

        #Add the name
        $Parameters.Add('Name', $Name)
        
        switch ($PSCmdlet.ParameterSetName) {
            'Git' {
                $script = [System.Net.WebClient]::new().DownloadString($Url)
            }
            default {
                $script = Get-Content $Definition -Raw
            }
        }

        @{
            Definition = [Scriptblock]::Create($script)
            Parameters = $Parameters
        } | Export-Configuration -CompanyName $env:USERNAME -Name $Name -Scope User
    }
}