---
external help file: Fondue-help.xml
Module Name: Fondue
online version:
schema: 2.0.0
---

# New-Metapackage

## SYNOPSIS
Creates a new Chocolatey Meta (virtual) package

## SYNTAX

```
New-Metapackage [-Id] <String> [-Summary] <String> [-Dependency] <Hashtable[]> -Description <String>
 [-Path <String>] [-Version <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function generates the necessary nuspec needed to create a Chocolatey metapackage

## EXAMPLES

### EXAMPLE 1
```
A minimal example of a metapackage using mandatory parameters
```

$newMetapackageSplat = @{
    Id = 'example'
    Summary = 'This is a simple example'
    Dependency = @{id='putty'}, @{id='git';version = '2.5.98'}
}

New-Metapackage @newMetapackageSplat

### EXAMPLE 2
```
Create a meta package with a pre-release version, and save it to C:\chocopackages
```

$newMetapackageSplat = @{
    Id = 'example'
    Summary = 'This is a simple example'
    Dependency = @{id='putty'}, @{id='git';version = '2.5.98'}
    Version = 1.0.0-pre
    Path = C:\chocopackages
}

New-Metapackage @newMetapackageSplat

## PARAMETERS

### -Id
The id of the meta package to create

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Summary
Provide a brief summary of what the metapackage provides

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

### -Dependency
An array of hashtables containing the id and (optional) version of the package to include in the metapackage.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{ Fill Description Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The folder in which to generate the metapackage

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PWD
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
A valid semver for the package.
Defaults to 0.1.0

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0.1.0
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
General notes

## RELATED LINKS
