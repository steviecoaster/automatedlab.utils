
Get-ChildItem -Path (Join-Path $PSScriptRoot -ChildPath 'public') -Recurse -File -Include *.ps1 | ForEach-Object {
    . $_.FullName
}