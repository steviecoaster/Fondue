---
external help file: Chocolatier-help.xml
Module Name: Chocolatier
online version:
schema: 2.0.0
---

# Test-Nuspec

## SYNOPSIS
Tests a NuGet package specification (.nuspec) file for compliance with specified rules.

## SYNTAX

```
Test-Nuspec [[-NuspecFile] <String>] [[-Metadata] <Hashtable>] [-OnlyRequiredRules] [-TestCommunityRules]
 [[-AdditionalTest] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Test-Nuspec function takes a .nuspec file and a set of rules as input.
It tests the .nuspec file for compliance with the specified rules.
The function can test for compliance with only the required rules, or it can also test for compliance with community rules.
Additional tests can be specified.

## EXAMPLES

### EXAMPLE 1
```powershell
Test-Nuspec -NuspecFile "C:\path\to\package.nuspec" -OnlyRequiredRules
```

This example tests the .nuspec file at the specified path for compliance with only the required rules.

### EXAMPLE 2
```powershell
Test-Nuspec -NuspecFile "C:\path\to\package.nuspec" -TestCommunityRules -AdditionalTest "Test1", "Test2"
```

This example tests the .nuspec file at the specified path for compliance with community rules and runs the additional tests "Test1" and "Test2".

## PARAMETERS

### -NuspecFile
The path to the .nuspec file to test.
This parameter is validated to ensure that it is a valid path.

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

### -Metadata
A hash table of metadata to test.
This parameter is optional.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlyRequiredRules
A switch that, when present, causes the function to test for compliance with only the required rules.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestCommunityRules
A switch that, when present, causes the function to test for compliance with community rules.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdditionalTest
An array of additional tests to run.
This parameter is optional.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
The function uses the Convert-Xml function to convert the .nuspec file to a hash table of metadata.

## RELATED LINKS
