function Remove-Dependency {
    <#
        .SYNOPSIS
        Removes a dependency from a NuGet package specification file.

        .DESCRIPTION
        The Remove-Dependency function takes a NuGet package specification (.nuspec) file and an array of dependencies as input. 
        It removes the specified dependencies from the .nuspec file.

        .PARAMETER PackageNuspec
        The path to the .nuspec file from which to remove dependencies. This parameter is mandatory.

        .PARAMETER Dependency
        An array of dependencies to remove from the .nuspec file. This parameter is mandatory.

        .EXAMPLE
        Remove-Dependency -PackageNuspec "C:\path\to\package.nuspec" -Dependency "Dependency1", "Dependency2"

        This example removes the dependencies "Dependency1" and "Dependency2" from the .nuspec file at the specified path.

        .NOTES
        The function does not support removing dependencies that are not directly listed in the .nuspec file.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $PackageNuspec,

        [Parameter(Mandatory)]
        [String[]]
        $Dependency
    )

    process {
        $xmlDoc = [System.Xml.XmlDocument]::new()
        $xmlDoc.Load($PackageNuspec)

        # Create an XmlNamespaceManager and add the namespace
        $nsManager = New-Object System.Xml.XmlNamespaceManager($xmlDoc.NameTable)
        $nsManager.AddNamespace('ns', $xmlDoc.DocumentElement.NamespaceURI)

        # Use the XmlNamespaceManager when selecting nodes
        $dependenciesNode = $xmlDoc.SelectSingleNode('//ns:metadata/ns:dependencies', $nsManager)
        foreach ($d in $Dependency) {
            if ($null -ne $dependenciesNode) {
                $dependencyToRemove = $dependenciesNode.SelectSingleNode("ns:dependency[@id='$d']", $nsManager)
        
                if ($null -ne $dependencyToRemove) {
                    $null = $dependenciesNode.RemoveChild($dependencyToRemove)
                }
            }
        }

        $settings = New-Object System.Xml.XmlWriterSettings
        $settings.Indent = $true
        $settings.Encoding = [System.Text.Encoding]::UTF8

        $writer = [System.Xml.XmlWriter]::Create($PackageNuspec, $settings)
        try {
            $xmlDoc.WriteTo($writer)
        }
        finally {
            $writer.Flush()
            $writer.Close()
        }
    }
}