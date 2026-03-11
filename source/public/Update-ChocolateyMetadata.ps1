function Update-ChocolateyMetadata {
    <#
        .SYNOPSIS
        Updates the metadata of a Chocolatey package.

        .DESCRIPTION
        The Update-ChocolateyMetadata function takes a metadata hash table and a .nuspec file as input. It updates the metadata of the Chocolatey package specified by the .nuspec file with the values in the metadata hash table.

        .PARAMETER Metadata
        A hash table of metadata to update. The keys should be the names of the metadata elements to update, and the values should be the new values for these elements.

        .PARAMETER NuspecFile
        The path to the .nuspec file of the Chocolatey package to update. This parameter is mandatory and validated to ensure that it is a valid path.

        .EXAMPLE
        $Metadata = @{ id = "newId"; version = "1.0.1" }
        Update-ChocolateyMetadata -Metadata $Metadata -NuspecFile "C:\path\to\package.nuspec"

        This example updates the id and version of the Chocolatey package specified by the .nuspec file at the specified path.

        .NOTES
        The function uses the Write-Metadata function to write the updated metadata to the .nuspec file.
    #>
    [CmdletBinding(HelpUri = 'https://steviecoaster.github.io/Fondue/Update-ChocolateyMetadata')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromRemainingArguments)]
        [Hashtable]
        $Metadata,

        [Parameter(Mandatory)]
        [ValidateScript({Test-Path $_})]
        [String]
        $NuspecFile
    )

    process {
        Write-metadata -MetaData $Metadata -Nuspecfile $NuspecFile
    }
}