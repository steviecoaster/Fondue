---
external help file: Fondue-help.xml
Module Name: Fondue
online version: https://docs.chocolatey.org/en-us/guides/create/
schema: 2.0.0
---

# Remove-Dependency

## SYNOPSIS
Removes a dependency from a NuGet package specification file.

## SYNTAX

```
Remove-Dependency [-PackageNuspec] <String> [-Dependency] <String[]> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-Dependency function takes a NuGet package specification (.nuspec) file and an array of dependencies as input. 
It removes the specified dependencies from the .nuspec file.

## EXAMPLES

### EXAMPLE 1
```
Remove-Dependency -PackageNuspec "C:\path\to\package.nuspec" -Dependency "Dependency1", "Dependency2"
```

This example removes the dependencies "Dependency1" and "Dependency2" from the .nuspec file at the specified path.

## PARAMETERS

### -PackageNuspec
The path to the .nuspec file from which to remove dependencies.
This parameter is mandatory.

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

### -Dependency
An array of dependencies to remove from the .nuspec file.
This parameter is mandatory.

```yaml
Type: String[]
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
The function does not support removing dependencies that are not directly listed in the .nuspec file.

## RELATED LINKS
