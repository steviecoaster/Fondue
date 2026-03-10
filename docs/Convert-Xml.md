---
external help file: Fondue-help.xml
Module Name: Fondue
online version:
schema: 2.0.0
---

# Convert-Xml

## SYNOPSIS
Converts XML from a URL or a file to a hash table.

## SYNTAX

```
Convert-Xml [[-Url] <String>] [[-File] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Convert-Xml function takes a URL or a file path as input and converts the XML content to a hash table. 
If a URL is provided, the function downloads the XML content from the URL. 
If a file path is provided, the function reads the XML content from the file. 
The function then converts the XML content to a hash table and returns it.

## EXAMPLES

### EXAMPLE 1
```
Convert-Xml -Url "http://example.com/data.xml"
```

This example downloads the XML content from the specified URL and converts it to a hash table.

### EXAMPLE 2
```
Convert-Xml -File "C:\path\to\data.xml"
```

This example reads the XML content from the specified file and converts it to a hash table.

## PARAMETERS

### -Url
The URL of the XML content to convert.
If this parameter is provided, the function will download the XML content from the URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
The file path of the XML content to convert.
If this parameter is provided, the function will read the XML content from the file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The function does not support XML content that contains dependencies or comments.

## RELATED LINKS
