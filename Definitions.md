# Getting started with AutomatedLab definitions

AutomatedLab definitions are simply PowerShell scripts that define all of the virtual machines, networking, and additional vm configurations you require in your lab.
While defining a lab is outside the scope of this module (See https://automatedlab.org), how you begin to write  your definitions is important.

## Use Advanced Parameter Syntax

Each definition should define a Parameter block with at least a Name parameter:

```powershell
[CmdletBinding()]
Param(
    [Parameter()]
    [String]
    $Name
)
```

## New-LabDefinition

Immediately following your parameter block, you should call the `New-LabDefinition cmdlet and provide the name of your lab, and the default virtualization engine.
Valid options for the virtualization engine are `HyperV` and `Azure`.

```powershell
New-LabDefinition -Name $Name -DefaultVirtualizationEngine Hyperv
```

## Next Steps

With this required information in place you may continue to define your lab requirements. Once you are satisfied, save your PowerShell script so you can provide it `New-LabConfiguration` using the `-Definition` parameter.