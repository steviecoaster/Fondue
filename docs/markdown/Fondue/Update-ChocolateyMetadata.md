---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://chocolatey-solutions.github.io/Fondue/Update-ChocolateyMetadata
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Update-ChocolateyMetadata
---

# Update-ChocolateyMetadata

## SYNOPSIS

Updates the metadata of a Chocolatey package.

## SYNTAX

### __AllParameterSets

```
Update-ChocolateyMetadata [-Metadata] <hashtable> [-NuspecFile] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Update-ChocolateyMetadata function takes a metadata hash table and a .nuspec file as input.
It updates the metadata of the Chocolatey package specified by the .nuspec file with the values in the metadata hash table.

## EXAMPLES

### EXAMPLE 1

$Metadata = @{ id = "newId"; version = "1.0.1" }
Update-ChocolateyMetadata -Metadata $Metadata -NuspecFile "C:\path\to\package.nuspec"

This example updates the id and version of the Chocolatey package specified by the .nuspec file at the specified path.

## PARAMETERS

### -Metadata

A hash table of metadata to update.
The keys should be the names of the metadata elements to update, and the values should be the new values for these elements.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: true
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NuspecFile

The path to the .nuspec file of the Chocolatey package to update.
This parameter is mandatory and validated to ensure that it is a valid path.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Collections.Hashtable

{{ Fill in the Description }}

## OUTPUTS

## NOTES

The function uses the Write-Metadata function to write the updated metadata to the .nuspec file.


## RELATED LINKS

{{ Fill in the related links here }}

