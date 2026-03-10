---
external help file: Fondue-help.xml
Module Name: Fondue
online version: https://docs.chocolatey.org/en-us/guides/create/
schema: 2.0.0
---

# Update-ChocolateyMetadata

## SYNOPSIS
Updates the metadata of a Chocolatey package.

## SYNTAX

```
Update-ChocolateyMetadata [-Metadata] <Hashtable> [-NuspecFile] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Update-ChocolateyMetadata function takes a metadata hash table and a .nuspec file as input.
It updates the metadata of the Chocolatey package specified by the .nuspec file with the values in the metadata hash table.

## EXAMPLES

### EXAMPLE 1
```
$Metadata = @{ id = "newId"; version = "1.0.1" }
Update-ChocolateyMetadata -Metadata $Metadata -NuspecFile "C:\path\to\package.nuspec"
```

This example updates the id and version of the Chocolatey package specified by the .nuspec file at the specified path.

## PARAMETERS

### -Metadata
A hash table of metadata to update.
The keys should be the names of the metadata elements to update, and the values should be the new values for these elements.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NuspecFile
The path to the .nuspec file of the Chocolatey package to update.
This parameter is mandatory and validated to ensure that it is a valid path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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
The function uses the Write-Metadata function to write the updated metadata to the .nuspec file.

## RELATED LINKS
