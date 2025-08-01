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

    try {

        Import-Lab -Name $Name -ErrorAction Stop
        Get-LabVM | Stop-LabVM
    }
    catch {
        Write-Error -Message 'Lab was not found. Use Start-Lab to start or build first' -Exception ([System.IO.FileNotFoundException]::New())
    }
}