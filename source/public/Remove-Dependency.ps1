function Remove-Dependency {
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
        $xmlDoc.Save($PackageNuspec)
    }
}