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
    
    .PARAMETER ScriptBlock
    A PowerShell script block that will be saved as the definition
    
    .EXAMPLE
    $conf = @{
        Name = 'MyDomainLab'
        Definition = 'C:\Labs\DomainController.ps1'
        Parameters = @{
            DomainName = 'contoso.com'
            AdminPassword = 'P@ssw0rd123!'
        }
    }

    New-LabConfiguration @conf
    
    .EXAMPLE
    $conf = @{
        Name = 'SQLServerLab'
        Url = 'https://raw.githubusercontent.com/AutomatedLab/AutomatedLab/main/LabSources/SampleScripts/Introduction/03%20SQL%20Server%20and%20client,%20domain%20joined.ps1'
        Parameters = @{
            SQLServiceAccount = 'CONTOSO\SQLService'
            DatabaseName = 'ProductionDB'
        }
    }

    New-LabConfiguration @conf

    .EXAMPLE
    $scriptBlock = {
        New-LabDefinition -Name $Parameters.LabName -DefaultVirtualizationEngine HyperV
        Add-LabDomainDefinition -Name contoso.com -AdminUser Install -AdminPassword P@ssw0rd123!
        Add-LabMachineDefinition -Name DC01 -Memory 2GB -Roles RootDC -DomainName contoso.com
        Add-LabMachineDefinition -Name Client01 -Memory 1GB -OperatingSystem 'Windows 10 Enterprise' -DomainName contoso.com
        Install-Lab
    }

    New-LabConfiguration -Name 'BasicDomainLab' -ScriptBlock $scriptBlock -Parameters @{ LabName = 'TestDomain' }


    #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'default')]
        [Parameter(Mandatory, ParameterSetName = 'Git')]
        [Parameter(Mandatory, ParameterSetName = 'ScriptBlock')]
        [String]
        $Name,

        [Parameter(Mandatory, ParameterSetName = 'default')]
        [String]
        $Definition,

        [Parameter(ParameterSetName = 'Git')]
        [Parameter(ParameterSetName = 'default')]
        [Parameter(ParameterSetName = 'ScriptBlock')]
        [Hashtable]
        $Parameters,

        [Parameter(Mandatory, ParameterSetName = 'Git')]
        [String]
        $Url,

        [Parameter(Mandatory, ParameterSetName = 'ScriptBlock')]
        [ScriptBlock]
        $ScriptBlock
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
            'ScriptBlock' {
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
        # where the definition will be saved when downloading from a Url or saving a ScriptBlock.
        # So we postpone processing until we have exported the configuration with the correct
        # value, and then just drop the file there.
        if ($url) {
            [System.Net.WebClient]::new().DownloadFile($Url, $Definition)       
        }
        
        if ($ScriptBlock) {
            $ScriptBlock.ToString() | Out-File -FilePath $Definition -Encoding UTF8
        }         

    }
}