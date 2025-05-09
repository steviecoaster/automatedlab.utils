# AutomatedLab.Utils

This module allows for the management of AutomatedLab definitions in your environment.
By storing definitions as configuration you Are able to very quickly define, build,
and manage labs in your environment.

This module uses the [Configuration](https://github.com/PoshCode/Configuration) module
to persist your lab configurations to disk in a secure manner. For simplicity sake configurations
are saved using $env:USERNAME scope, although additional scopes _may_ be added in the future.

## Installation

### BEFORE YOU BEGIN

Ensure that you have installed AutomatedLab (We'll assume you have since you wish to use this thing, but if not, see https://automatedlab.org/en/latest/Wiki/Basic/install/)

### Build from source

Building from source will require ModuleBuilder from the PowerShell Gallery:

```powershell
Install-Module ModuleBuilder -Scope CurrentUser
git clone https:github.com/steviecoaster/automatedlab.utils.git
cd automatedlab.utils
. ./Build.ps1
Import-Module ./AutomatedLab.Utils/0.1.0/AutomatedLab.Utils.psd1
```

### Install through the PowerShell Gallery

#### Windows PowerShell

```powershell
Install-Module AutomatedLab.Utils -Scope CurrentUser
```

#### PowerShell 7+

```powershell
Install-PSResource AutomatedLab.Utils -Scope CurrentUser
```

### Chocolatey (COMING SOON)

```powershell
choco install automatedlab.utils -y -s https://community.chocolatey.org/api/v2
```

## Defining A Lab Configuration

Defining a lab requires 3 pieces of information:

- Name: This is a name for  your configuration. (TIP! Make this the same as the name in your definition file)
- Definition: This is a PowerShell script that defines how your lab is built. You can supply a definition via `-Definition` for a local file,
or via `-Url` to provide a link to a ps1 script hosted as a Github gist, or in a repository. See [Defining a Lab Definition](Definitions.md) for more information.
- Parameters: This is a hashtable of parameters to pass to the PowerShell script

For example, here is my configuration for my lab based on [Chocolatey's Quickstart Guide](https://docs.chocolatey.org/en-us/c4b-environments/quick-start-environment/chocolatey-for-business-quick-start-guide/).

```powershell
$params =  @{
    Name = 'QSG'
    Definition = "C:\Users\stephen\Documents\Git\ChocoStuff\LabEnvironments\QuickStartGuide\Lab\Definition.ps1"
    Parameters = @{
        Credential = Get-Credential
        DatabaseCredential = Get-Credential
        CertificateDnsName = 'chocolatey.steviecoaster.dev'
    }
}

New-LabConfiguration @params
```

## Adding a Custom Role

One of AutomatedLabs best features is the ability to define Custom Roles. These Roles are PowerShell that run after the VM has been provisioned, but before it is handed back to you for use. Think of a Custom Role _kind of_ like activities  you can define during Sysprep. They have a specific shape, and this command makes it very easy for you to just provide what you want to include with the Role, and it gets created.

```powershell
new-customRole -Name InedoProGet -InitScript "C:\LabSources\CustomRoles\Inedo\InedoProGet.ps1" -AdditionalFiles "C:\LabSources\CustomRoles\Inedo\inedohub.1.4.4.nupkg","C:\LabSources\CustomRoles\Inedo\proget.24.0.4.nupkg","C:\LabSources\CustomRoles\Inedo\helpers.ps1","C:\LabSources\CustomRoles\Inedo\cert.pfx"
$roleParams = @{
    Name = 'DemoRole'
    InitScript = 'C:\temp\DemoRole.ps1'
    AdditionalFiles = 'C:\git\DemoRole\firewallrules.csv'
}

New-CustomRole @roleParams
```

## Getting Lab Configuration Information

### The Get-CustomRole command

You can use `Get-CustomRole` to return a list of all of the available Custom Roles on the system.

### The Get-LabConfiguration command

You can use `Get-LabConfiguration` to return the configuration information saved for the lab specified by the `-Name` parameter.

### The Get-LabConfigurationPath command

This will return the path on disk where the configuration is stored. Used internally for saving Defintions with configuration
but exported publicly as it could be useful to use in scripting scenarios

## Starting A Lab

Once you have a lab configuration, you can start the lab based on it.

```powershell
Start-Lab -Name QSG
```

You may at times need to pass in additional parameters to your lab. You can use `-AdditonalParameters` for this:

```powershell
Start-Lab -Name QSG -AdditionalParametes @{ Widget = 'Fizzbuzz'}
```

## Stopping A Lab

When you are finished with a lab, you likely want to stop it running. You can do so like this:

```powershell
Stop-Lab -Name QSG
```
