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
        [String]
        $Name
    )

    if($PSCmdlet.ShouldProcess($Name,'Remove the lab configuration')){
        Get-ConfigurationPath -Name $Name -CompanyName $env:USERNAME -Scope User | Remove-Item -Recurse -Force
    }
}