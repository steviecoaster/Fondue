# Update-ChocolateyMetadata

## SYNOPSIS
Updates the metadata of a Chocolatey package.

## SYNTAX

```
Update-ChocolateyMetadata [-Metadata] <Hashtable> [-NuspecFile] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Update-ChocolateyMetadata function takes a metadata hash table and a .nuspec file as input. It updates the metadata of the Chocolatey package specified by the .nuspec file with the values in the metadata hash table.

## EXAMPLES

### Example 1
```powershell
$Metadata = @{ id = "newId"; version = "1.0.1" }
Update-ChocolateyMetadata -Metadata $Metadata -NuspecFile "C:\path\to\package.nuspec"
```

This example updates the id and version of the Chocolatey package specified by the .nuspec file at the specified path.

## PARAMETERS

### -Metadata
A hash table of metadata to update. The keys should be the names of the metadata elements to update, and the values should be the new values for these elements.

```yaml
Type: Hashtable
Parameter Sets: (All)
```