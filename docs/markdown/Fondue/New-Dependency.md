---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://steviecoaster.github.io/Fondue/New-Dependency
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: New-Dependency
---

# New-Dependency

## SYNOPSIS

Injects a <dependency> node into a Chocolatey package nuspec file

## SYNTAX

### __AllParameterSets

```
New-Dependency [-Nuspec] <string> [-Dependency] <hashtable[]> [[-OutputDirectory] <string>]
 [-Recompile] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Long description

## EXAMPLES

### EXAMPLE 1

Add a single dependency with a version

New-Dependency -Nuspec C:\packages\foo.1.1.1.nuspec -dependency @{id= 'baz'; version='3.4.2'}

### EXAMPLE 2

Add multiple dependencies

New-Dependency -Nuspec C:\packages\foo.1.1.0.nuspec -Dependency @{id='baz'; version='1.1.1'},@{id='boo';version=[1.0.1,2.9.0]}

### EXAMPLE 3

Add a dependency and recompile the package

$newDependencySplat = @{
    Nuspec = 'C:\packagesfoo.1.1.1.nuspec'
    Dependency = @{id= 'baz'; version='3.4.2'}
    Recompile = $true
}

New-Dependency @newDependencySplat

### EXAMPLE 4

Add a dependency, recompile the package, and save it to a new location

$newDependencySplat = @{
    Nuspec = 'C:\packagesfoo.1.1.1.nuspec'
    Dependency = @{id= 'baz'; version='3.4.2'}
    Recompile = $true
    OutputDirectory = 'C:\recompiled'
}

New-Dependency @newDependencySplat

## PARAMETERS

### -Dependency

A hashtable containing the package id and version range for the dependency

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Nuspec

THe Chocolatey package nuspec to which add a dependency

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputDirectory

Save the recompiled Chocolatey Package to this location

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Recompile

Recompile the Chocolatey package with the new dependency information.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

