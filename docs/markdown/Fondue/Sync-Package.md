---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://steviecoaster.github.io/Fondue/Sync-Package
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Sync-Package
---

# Sync-Package

## SYNOPSIS

Runs choco sync on a system

## SYNTAX

### Default (Default)

```
Sync-Package [-OutputDirectory <string>] [<CommonParameters>]
```

### Package

```
Sync-Package -Id <string> -DisplayName <string> [-OutputDirectory <string>] [<CommonParameters>]
```

### Map

```
Sync-Package -Map <hashtable> [-OutputDirectory <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Run choco sync against a system with eiher a single item or from a map

## EXAMPLES

### EXAMPLE 1

Sync-Package

Sync everything from Programs and Features not under Chocolatey management

### EXAMPLE 2

Sync-Package -Id googlechrome -DisplayName 'Google Chrome'

Sync the Google Chrome application from Programs and Features to the googlechrome package id

### EXAMPLE 3

Sync-Package -Map @{'Google Chrome' = 'googlechrome'}

Sync from a hashtable of DisplayName:PackageId pairs

## PARAMETERS

### -DisplayName

The Diplay Name From Programs and Features

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Package
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The Package id for the synced package

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Package
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Map

A hashtable of DisplayName and PackageIds

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Map
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputDirectory

{{ Fill OutputDirectory Description }}

```yaml
Type: System.String
DefaultValue: $PWD
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Package
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Map
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default
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

Requires a Chocolatey For Business license


## RELATED LINKS

{{ Fill in the related links here }}

