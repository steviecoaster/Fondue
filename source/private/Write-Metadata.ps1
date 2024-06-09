function Write-Metadata {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [Hashtable]
        $Metadata,

        [Parameter(Mandatory)]
        [String]
        $NuspecFile
    )

    process {
        [xml]$xmlDoc = Get-Content $NuspecFile

        $namespaceManager = New-Object System.Xml.XmlNamespaceManager($xmlDoc.NameTable)
        $namespaceManager.AddNamespace("ns", "http://schemas.microsoft.com/packaging/2011/08/nuspec.xsd")
        $metadataNode = $xmlDoc.SelectSingleNode("//*[local-name()='metadata']", $namespaceManager)

        $Metadata.GetEnumerator() | ForEach-Object {
            $node = $xmlDoc.SelectSingleNode("//*[local-name()='$($_.Key)']", $namespaceManager)
            if (-not $node) {
                $node = $xmlDoc.CreateElement($_.Key)
            } else {
                'Node exists: {0}, updating' -f $_.Key
            }
            $null = $node.InnerText = $_.Value
            $null = $metadataNode.AppendChild($node)
        }

        #we don't need the namespace on all the nodes, so strip it off
        $xmlDoc = $xmlDoc.OuterXml -replace 'xmlns=""', ''
        $settings = New-Object System.Xml.XmlWriterSettings
        $settings.Indent = $true
        $settings.Encoding = [System.Text.Encoding]::UTF8

        $writer = [System.Xml.XmlWriter]::Create($NuspecFile, $settings)
        try {
            $xmlDoc.WriteTo($writer)
        }
        finally {
            $writer.Flush()
            $writer.Close()
            $writer.Dispose()
        }
    }
}