---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://steviecoaster.github.io/Fondue/Remove-Dependency
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-Dependency
---

# Remove-Dependency

## SYNOPSIS

Removes a dependency from a NuGet package specification file.

## SYNTAX

### __AllParameterSets

```
Remove-Dependency [-PackageNuspec] <string> [-Dependency] <string[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Remove-Dependency function takes a NuGet package specification (.nuspec) file and an array of dependencies as input.

It removes the specified dependencies from the .nuspec file.

## EXAMPLES

### EXAMPLE 1

Remove-Dependency -PackageNuspec "C:\path\to\package.nuspec" -Dependency "Dependency1", "Dependency2"

This example removes the dependencies "Dependency1" and "Dependency2" from the .nuspec file at the specified path.

## PARAMETERS

### -Dependency

An array of dependencies to remove from the .nuspec file.
This parameter is mandatory.

```yaml
Type: System.String[]
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

### -PackageNuspec

The path to the .nuspec file from which to remove dependencies.
This parameter is mandatory.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

The function does not support removing dependencies that are not directly listed in the .nuspec file.


## RELATED LINKS

{{ Fill in the related links here }}

