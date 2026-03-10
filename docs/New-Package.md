---
external help file: Fondue-help.xml
Module Name: Fondue
online version: https://docs.chocolatey.org/en-us/guides/create/
schema: 2.0.0
---

# New-Package

## SYNOPSIS
Generates a new Chocolatey Package

## SYNTAX

### Default (Default)
```
New-Package -Name <String> [-Dependency <Hashtable[]>] [-Metadata <Hashtable>] [-OutputDirectory <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### File
```
New-Package -File <String> [-Dependency <Hashtable[]>] [-Metadata <Hashtable>] [-OutputDirectory <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Url
```
New-Package -Url <String> [-Dependency <Hashtable[]>] [-Metadata <Hashtable>] [-OutputDirectory <String>]
 [-Recompile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### FIle
```
New-Package [-Recompile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Generates a Chocolatey Package.
Can be used to generate from an installer (licensed versions only), meta (virtual) packages, or FOSS style packages

## EXAMPLES

### EXAMPLE 1
```
Creating a basic package with a name:
```

$params = @{
    Name = "MyPackage"
}
New-Package @params

### EXAMPLE 2
```
Create a package from an installer file
```

New-Package -Name "MyInstallerPackage" -File "C:\path\to\installer.exe"

### EXAMPLE 3
```
Create a package from an installer URL
```

New-Package -Name "MyUrlPackage" -Url "http://example.com/installer.exe"

### EXAMPLE 4
```
Create a package with metadata
```

New-Package -Name "MyPackageWithMetadata" -Metadata @{Author="Me"; Version="1.0.0"}

### EXAMPLE 5
```
Create a package in a specific output directory
```

New-Package -Name "MyPackage" -OutputDirectory "C:\path\to\output\directory"

## PARAMETERS

### -Name
The name (Id) to give to the package

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
An installer to package.
Should be of type exe, msi, msu, or zip

```yaml
Type: String
Parameter Sets: File
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
The url of an installer to package.
Installer will be downloaded and embedded into package.
Supports same extensions as -File parameter.

```yaml
Type: String
Parameter Sets: Url
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Dependency
Dependencies to inject into the package.
Required when using -IsMetaPackage.

```yaml
Type: Hashtable[]
Parameter Sets: Default, File, Url
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Metadata
A hashtable of MetaData to include in the Nuspec File

```yaml
Type: Hashtable
Parameter Sets: Default, File, Url
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputDirectory
This is where the Chocolatey packaging will be generated.
Defaults to the current working directory.

```yaml
Type: String
Parameter Sets: Default, File, Url
Aliases:

Required: False
Position: Named
Default value: $PWD
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recompile
When used runs the pack command against the nuspec file

```yaml
Type: SwitchParameter
Parameter Sets: Url, FIle
Aliases:

Required: False
Position: Named
Default value: False
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

## RELATED LINKS

[https://docs.chocolatey.org/en-us/guides/create/](https://docs.chocolatey.org/en-us/guides/create/)

