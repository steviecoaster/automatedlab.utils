function New-HostsFileEntry {
    <#
    .SYNOPSIS
    Adds an entry to the HOSTS file for the given ip address and hostname
        
    .PARAMETER IPAddress
    The ip address to add
    
    .PARAMETER Hostname
    The hostname to add
    
    .PARAMETER Note
    An optional note about the entry

    .EXAMPLE
    New-HostsFileEntry -IpAddress 127.0.0.1 -Hostname widget.fabrikam.com
    
    .EXAMPLE
    New-HostsFileEntry -IpAddress 10.10.10.100 -Hostname widget.fabrikam.com -Note 'this is my fancy widget server'
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $IPAddress,

        [Parameter(Mandatory)]
        [String]
        $Hostname,

        [Parameter()]
        [String]
        $Note
    )
begin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "This function requires administrator privileges. Please elevate your terminal, and try this command again."
    }
}
    end {
        $entry = '{0}  {1}' -f $IPAddress, $Hostname

        if ($Note) {
            $entry = "$entry #{0}" -f $Note
        }

        $hostFile = 'C:\Windows\system32\drivers\etc\hosts'
        $entry | Out-File -FilePath $hostFile -Encoding utf8 -Append
    }
}

