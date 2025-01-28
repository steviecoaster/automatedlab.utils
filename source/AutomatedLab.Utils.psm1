# This is for initial development only
Get-ChildItem -Path $PSScriptRoot -Recurse -File -Include *.ps1 | ForEach-Object {
    . $_.FullName
}