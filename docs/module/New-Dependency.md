---
external help file: Chocolatier-help.xml
Module Name: Chocolatier
online version:
schema: 2.0.0
---

# New-Dependency

## SYNOPSIS
Injects a \<dependency\> node into a Chocolatey package nuspec file

## SYNTAX

```powershell
New-Dependency [-Nuspec] <String> [-Dependency] <Hashtable[]> [-Recompile] [[-OutputDirectory] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Injects a \<dependency\> node into a Chocolatey package nuspec file

## EXAMPLES

### EXAMPLE 1

Add a single dependency with a version

```powershell
New-Dependency -Nuspec C:\packages\foo.1.1.1.nuspec -dependency @{id= 'baz'; version='3.4.2'}
```

### EXAMPLE 2

Add multiple dependencies

```powershell
New-Dependency -Nuspec C:\packages\foo.1.1.0.nuspec -Dependency @{id='baz'; version='1.1.1'},@{id='boo';version=\[1.0.1,2.9.0\]}
```

### EXAMPLE 3

Add a dependency and recompile the package

```powershell
$newDependencySplat = @{
    Nuspec = 'C:\packagesfoo.1.1.1.nuspec'
    Dependency = @{id= 'baz'; version='3.4.2'}
    Recompile = $true
}

New-Dependency @newDependencySplat
```

### EXAMPLE 4

Add a dependency, recompile the package, and save it to a new location

```powershell
$newDependencySplat = @{
    Nuspec = 'C:\packagesfoo.1.1.1.nuspec'
    Dependency = @{id= 'baz'; version='3.4.2'}
    Recompile = $true
    OutputDirectory = 'C:\recompiled'
}

New-Dependency @newDependencySplat
```

## PARAMETERS

### -Nuspec
THe Chocolatey package nuspec to which add a dependency

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
A hashtable containing the package id and version range for the dependency

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recompile
Recompile the Chocolatey package with the new dependency information.

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

### -OutputDirectory
Save the recompiled Chocolatey Package to this location

```yaml
Type: String
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

## RELATED LINKS
