#requires -Modules ModuleBuilder
[CmdletBinding()]
param(
    # The version of the module
    [Parameter()]
    [Alias('Version')]
    [string]$SemVer = $(
        if (Get-Command gitversion -ErrorAction SilentlyContinue) {
            gitversion /showvariable SemVer
        } else {
            '0.1.0'
        }
    ),

    # Returns the built module
    [switch]$PassThru
)

Build-Module -SemVer $SemVer -Passthru:$PassThru