---
external help file: Fondue-help.xml
Module Name: Fondue
online version: https://docs.chocolatey.org/en-us/guides/create/
schema: 2.0.0
---

# Sync-Package

## SYNOPSIS
Runs choco sync on a system

## SYNTAX

### Default (Default)
```
Sync-Package [-OutputDirectory <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Package
```
Sync-Package -Id <String> -DisplayName <String> [-OutputDirectory <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Map
```
Sync-Package -Map <Hashtable> [-OutputDirectory <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Run choco sync against a system with eiher a single item or from a map

## EXAMPLES

### EXAMPLE 1
```
Sync-Package
```

Sync everything from Programs and Features not under Chocolatey management

### EXAMPLE 2
```
Sync-Package -Id googlechrome -DisplayName 'Google Chrome'
```

Sync the Google Chrome application from Programs and Features to the googlechrome package id

### EXAMPLE 3
```
Sync-Package -Map @{'Google Chrome' = 'googlechrome'}
```

Sync from a hashtable of DisplayName:PackageId pairs

## PARAMETERS

### -Id
The Package id for the synced package

```yaml
Type: String
Parameter Sets: Package
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
The Diplay Name From Programs and Features

```yaml
Type: String
Parameter Sets: Package
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Map
A hashtable of DisplayName and PackageIds

```yaml
Type: Hashtable
Parameter Sets: Map
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputDirectory
{{ Fill OutputDirectory Description }}

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
Requires a Chocolatey For Business license

## RELATED LINKS
