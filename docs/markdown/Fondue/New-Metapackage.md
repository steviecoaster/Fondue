---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://steviecoaster.github.io/Fondue/New-Metapackage
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: New-Metapackage
---

# New-Metapackage

## SYNOPSIS

Creates a new Chocolatey Meta (virtual) package

## SYNTAX

### __AllParameterSets

```
New-Metapackage [-Id] <string> [-Summary] <string> [-Dependency] <hashtable[]> -Description <string>
 [-Path <string>] [-Version <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function generates the necessary nuspec needed to create a Chocolatey metapackage

## EXAMPLES

### EXAMPLE 1

A minimal example of a metapackage using mandatory parameters

$newMetapackageSplat = @{
    Id = 'example'
    Summary = 'This is a simple example'
    Dependency = @{id='putty'}, @{id='git';version = '2.5.98'}
}

New-Metapackage @newMetapackageSplat

### EXAMPLE 2

Create a meta package with a pre-release version, and save it to C:\chocopackages

$newMetapackageSplat = @{
    Id = 'example'
    Summary = 'This is a simple example'
    Dependency = @{id='putty'}, @{id='git';version = '2.5.98'}
    Version = 1.0.0-pre
    Path = C:\chocopackages
}

New-Metapackage @newMetapackageSplat

## PARAMETERS

### -Dependency

An array of hashtables containing the id and (optional) version of the package to include in the metapackage.

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

{{ Fill Description Description }}

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
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

The id of the meta package to create

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

### -Path

The folder in which to generate the metapackage

```yaml
Type: System.String
DefaultValue: $PWD
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

### -Summary

Provide a brief summary of what the metapackage provides

```yaml
Type: System.String
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

### -Version

A valid semver for the package.
Defaults to 0.1.0

```yaml
Type: System.String
DefaultValue: 0.1.0
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

General notes


## RELATED LINKS

{{ Fill in the related links here }}

