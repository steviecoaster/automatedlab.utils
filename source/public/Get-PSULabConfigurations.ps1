function Get-PSULabConfiguration {
    <#
    .SYNOPSIS
    Returns lab configuration objects
    
    .DESCRIPTION
    Returns all lab configurations when no Name is specified, or a specific configuration when Name is provided.
       
    .PARAMETER Name
    The name of the specific configuration to return. If not specified, all configurations are returned.
    
    .EXAMPLE
    Get-AllLabConfigurations
    
    Returns all available lab configurations.
    
    .EXAMPLE
    Get-AllLabConfigurations -Name Example
    
    Returns the specific configuration named 'Example'.
    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

            $configPath = Join-Path $env:LocalAppData -ChildPath "powershell\$env:USERNAME"
            if (Test-Path $configPath) {
                Get-ChildItem -Path $configPath -Directory | Where-Object {
                    $_.Name -like "$wordToComplete*"
                } | ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Name)
                }
            }
        })]
        [String]
        $Name
    )

    end {
        if ($Name) {
            Import-Configuration -Name $Name -CompanyName $env:USERNAME
        } else {
            $configPath = Join-Path $env:LocalAppData -ChildPath "powershell\$env:USERNAME"
            if (Test-Path $configPath) {
                Get-ChildItem -Path $configPath -Directory | ForEach-Object {
                    $config = Import-Configuration -Name $_.Name -CompanyName $env:USERNAME
                    $config.Name = $_.Name
                    $config
                }
            }
        }
    }
}
