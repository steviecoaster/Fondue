---
external help file: Chocolatier-help.xml
Module Name: Chocolatier
online version:
schema: 2.0.0
---

# Convert-Xml

## SYNOPSIS
Converts a Chocolatey package nuspec file from a URL or a file to a hash table.

## SYNTAX

```powershell
Convert-Xml [[-Url] <String>] [[-File] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Convert-Xml function takes a URL or a file path as input and converts the Chocolatey package nuspec content to a hash table. 
If a URL is provided, the function downloads the nuspec content from the URL. 
If a file path is provided, the function reads the nuspec content from the file. 
The function then converts the nuspec content to a hash table and returns it.

## EXAMPLES

### EXAMPLE 1
```powershell
Convert-Xml -Url "http://example.com/data.nuspec"
```

This example downloads the nuspec content from the specified URL and converts it to a hash table.

## PARAMETERS

### -Url
Specifies the URL to download the nuspec content from.

### -File
Specifies the file path to read the nuspec content from.

### -ProgressAction
Specifies the action to take if a progress bar is displayed.

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS