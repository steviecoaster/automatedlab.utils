function Remove-LabConfiguration {
    <#
    .SYNOPSIS
    Removes a lab configuration
    
    .PARAMETER Name
    The configuration to remove
    
    .EXAMPLE
    Remove-LabConfiguration -Name TestConfig
    #>
    [CmdletBinding(ConfirmImpact =  'Medium',SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
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

    if($PSCmdlet.ShouldProcess($Name,'Remove the lab configuration')){
        Get-ConfigurationPath -Name $Name -CompanyName $env:USERNAME -Scope User | Remove-Item -Recurse -Force
    }
}