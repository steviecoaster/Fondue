---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://steviecoaster.github.io/Fondue/New-Package
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: New-Package
---

# New-Package

## SYNOPSIS

Generates a new Chocolatey Package

## SYNTAX

### Default (Default)

```
New-Package -Name <string> [-Dependency <hashtable[]>] [-Metadata <hashtable>]
 [-OutputDirectory <string>] [<CommonParameters>]
```

### File

```
New-Package -File <string> [-Dependency <hashtable[]>] [-Metadata <hashtable>]
 [-OutputDirectory <string>] [<CommonParameters>]
```

### Url

```
New-Package -Url <string> [-Dependency <hashtable[]>] [-Metadata <hashtable>]
 [-OutputDirectory <string>] [-Recompile] [<CommonParameters>]
```

### FIle

```
New-Package [-Recompile] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Generates a Chocolatey Package.
Can be used to generate from an installer (licensed versions only), meta (virtual) packages, or FOSS style packages

## EXAMPLES

### EXAMPLE 1

Creating a basic package with a name:

$params = @{
    Name = "MyPackage"
}
New-Package @params

### EXAMPLE 2

Create a package from an installer file

New-Package -Name "MyInstallerPackage" -File "C:\path\to\installer.exe"

### EXAMPLE 3

Create a package from an installer URL

New-Package -Name "MyUrlPackage" -Url "http://example.com/installer.exe"

### EXAMPLE 4

Create a package with metadata

New-Package -Name "MyPackageWithMetadata" -Metadata @{Author="Me"; Version="1.0.0"}

### EXAMPLE 5

Create a package in a specific output directory

New-Package -Name "MyPackage" -OutputDirectory "C:\path\to\output\directory"

## PARAMETERS

### -Dependency

Dependencies to inject into the package.
Required when using -IsMetaPackage.

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Url
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: File
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

### -File

An installer to package.
Should be of type exe, msi, msu, or zip

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: File
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Metadata

A hashtable of MetaData to include in the Nuspec File

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Url
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: File
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

### -Name

The name (Id) to give to the package

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Default
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

This is where the Chocolatey packaging will be generated.
Defaults to the current working directory.

```yaml
Type: System.String
DefaultValue: $PWD
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Url
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: File
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

### -Recompile

When used runs the pack command against the nuspec file

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Url
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: FIle
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Url

The url of an installer to package.
Installer will be downloaded and embedded into package.
Supports same extensions as -File parameter.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Url
  Position: Named
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

## RELATED LINKS

- [](https://docs.chocolatey.org/en-us/guides/create/)
