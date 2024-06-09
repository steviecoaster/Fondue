---
external help file: Chocolatier-help.xml
Module Name: Chocolatier
online version:
schema: 2.0.0
---

# Test-Package

## SYNOPSIS
Tests a NuGet package for compliance with specified rules.

## SYNTAX

```
Test-Package [-PackagePath] <String> [-OnlyRequiredRules] [[-AdditionalTest] <String[]>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Test-Package function takes a NuGet package and a set of rules as input.
It tests the package for compliance with the specified rules.
The function can test for compliance with only the required rules, or it can also test for compliance with all system rules.
Additional tests can be specified.

## EXAMPLES

### EXAMPLE 1
```powershell
Test-Package -PackagePath "C:\path\to\package.nupkg" -OnlyRequiredRules
```

This example tests the NuGet package at the specified path for compliance with only the required rules.

### EXAMPLE 2
```powershell
Test-Package -PackagePath "C:\path\to\package.nupkg" -AdditionalTest "Test1", "Test2"
```

This example tests the NuGet package at the specified path and runs the additional tests "Test1" and "Test2".

## PARAMETERS

### -PackagePath
The path to the NuGet package to test.
This parameter is mandatory and validated to ensure that it is a valid path.

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

### -AdditionalTest
An array of additional tests to run.
This parameter is optional.

```yaml
Type: String[]
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
The function uses the Chocolatier module to perform the tests.

## RELATED LINKS
