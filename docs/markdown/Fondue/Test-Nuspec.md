---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://chocolatey-solutions.github.io/Fondue/Test-Nuspec
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Test-Nuspec
---

# Test-Nuspec

## SYNOPSIS

Tests a NuGet package specification (.nuspec) file for compliance with specified rules.

## SYNTAX

### __AllParameterSets

```
Test-Nuspec [[-NuspecFile] <string>] [[-Metadata] <hashtable>] [[-AdditionalTest] <string[]>]
 [-SkipBuiltinTests] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Test-Nuspec function takes a .nuspec file and a set of rules as input.
It tests the .nuspec file for compliance with the specified rules.
The function can test for compliance with only the required rules, or it can also test for compliance with community rules.
Additional tests can be specified.

## EXAMPLES

### EXAMPLE 1

Test-Nuspec -NuspecFile "C:\path\to\package.nuspec" -OnlyRequiredRules

This example tests the .nuspec file at the specified path for compliance with only the required rules.

### EXAMPLE 2

Test-Nuspec -NuspecFile "C:\path\to\package.nuspec" -TestCommunityRules -AdditionalTest "Test1", "Test2"

This example tests the .nuspec file at the specified path for compliance with community rules and runs the additional tests "Test1" and "Test2".

## PARAMETERS

### -AdditionalTest

An array of additional tests to run.
This parameter is optional.

```yaml
Type: System.String[]
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

### -Metadata

A hash table of metadata to test.
This parameter is optional.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NuspecFile

The path to the .nuspec file to test.
This parameter is validated to ensure that it is a valid path.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipBuiltinTests

{{ Fill SkipBuiltinTests Description }}

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

The function uses the Convert-Xml function to convert the .nuspec file to a hash table of metadata.


## RELATED LINKS

{{ Fill in the related links here }}

