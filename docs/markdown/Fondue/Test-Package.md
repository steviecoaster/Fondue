---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://steviecoaster.github.io/Fondue/Test-Package
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Test-Package
---

# Test-Package

## SYNOPSIS

Tests a NuGet package for compliance with specified rules.

## SYNTAX

### __AllParameterSets

```
Test-Package [-PackagePath] <string> [[-AdditionalTest] <string[]>] [-OnlyRequiredRules]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Test-Package function takes a NuGet package and a set of rules as input.
It tests the package for compliance with the specified rules.
The function can test for compliance with only the required rules, or it can also test for compliance with all system rules.
Additional tests can be specified.

## EXAMPLES

### EXAMPLE 1

Test-Package -PackagePath "C:\path\to\package.nupkg" -OnlyRequiredRules

This example tests the NuGet package at the specified path for compliance with only the required rules.

### EXAMPLE 2

Test-Package -PackagePath "C:\path\to\package.nupkg" -AdditionalTest "Test1", "Test2"

This example tests the NuGet package at the specified path and runs the additional tests "Test1" and "Test2".

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
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OnlyRequiredRules

A switch that, when present, causes the function to test for compliance with only the required rules.

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

### -PackagePath

The path to the NuGet package to test.
This parameter is mandatory and validated to ensure that it is a valid path.

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

The function uses the Fondue module to perform the tests.


## RELATED LINKS

{{ Fill in the related links here }}

