function Get-LabConfiguration {
    <#
    .SYNOPSIS
    Returns a configuration object
       
    .PARAMETER Name
    The name of the configuration to return
    
    .EXAMPLE
    Get-LabConfiguration -Name Example
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
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
        Import-Configuration -Name $Name -CompanyName $env:USERNAME
    }
}