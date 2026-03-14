---
document type: cmdlet
external help file: Fondue-Help.xml
HelpUri: https://chocolatey-solutions.github.io/Fondue/Convert-Xml
Locale: en-US
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Convert-Xml
---

# Convert-Xml

## SYNOPSIS

Converts XML from a URL or a file to a hash table.

## SYNTAX

### __AllParameterSets

```
Convert-Xml [[-Url] <string>] [[-File] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Convert-Xml function takes a URL or a file path as input and converts the XML content to a hash table.

If a URL is provided, the function downloads the XML content from the URL.

If a file path is provided, the function reads the XML content from the file.

The function then converts the XML content to a hash table and returns it.

## EXAMPLES

### EXAMPLE 1

Convert-Xml -Url "http://example.com/data.xml"

This example downloads the XML content from the specified URL and converts it to a hash table.

### EXAMPLE 2

Convert-Xml -File "C:\path\to\data.xml"

This example reads the XML content from the specified file and converts it to a hash table.

## PARAMETERS

### -File

The file path of the XML content to convert.
If this parameter is provided, the function will read the XML content from the file.

```yaml
Type: System.String
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

### -Url

The URL of the XML content to convert.
If this parameter is provided, the function will download the XML content from the URL.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

The function does not support XML content that contains dependencies or comments.


## RELATED LINKS

{{ Fill in the related links here }}

