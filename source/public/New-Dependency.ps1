function New-Dependency {
    <#
.SYNOPSIS
Injects a <dependency> node into a Chocolatey package nuspec file

.DESCRIPTION
Long description

.PARAMETER Nuspec
THe Chocolatey package nuspec to which add a dependency

.PARAMETER Dependency
A hashtable containing the package id and version range for the dependency

.PARAMETER Recompile
Recompile the Chocolatey package with the new dependency information.

.PARAMETER OutputDirectory
Save the recompiled Chocolatey Package to this location

.EXAMPLE
Add a single dependency with a version

New-Dependency -Nuspec C:\packages\foo.1.1.1.nuspec -dependency @{id= 'baz'; version='3.4.2'}

.EXAMPLE
Add multiple dependencies

New-Dependency -Nuspec C:\packages\foo.1.1.0.nuspec -Dependency @{id='baz'; version='1.1.1'},@{id='boo';version=[1.0.1,2.9.0]}

.EXAMPLE
Add a dependency and recompile the package

$newDependencySplat = @{
    Nuspec = 'C:\packagesfoo.1.1.1.nuspec'
    Dependency = @{id= 'baz'; version='3.4.2'}
    Recompile = $true
}

New-Dependency @newDependencySplat
        
.EXAMPLE
Add a dependency, recompile the package, and save it to a new location

$newDependencySplat = @{
    Nuspec = 'C:\packagesfoo.1.1.1.nuspec'
    Dependency = @{id= 'baz'; version='3.4.2'}
    Recompile = $true
    OutputDirectory = 'C:\recompiled'
}

New-Dependency @newDependencySplat
#>
    [CmdletBinding(HelpUri = 'https://chocolatey-solutions.github.io/Fondue/New-Dependency')]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Nuspec,

        [Parameter(Mandatory)]
        [Hashtable[]]
        $Dependency,

        [Parameter()]
        [Switch]
        $Recompile,

        [Parameter()]
        [String]
        [ValidateScript({ Test-Path $_ })]
        $OutputDirectory
    )

    process {
        [xml]$xmlContent = Get-Content $Nuspec

        # Define the XML namespace
        $namespaceManager = New-Object System.Xml.XmlNamespaceManager($xmlContent.NameTable)
        $namespaceManager.AddNamespace("ns", "http://schemas.microsoft.com/packaging/2015/08/nuspec.xsd")

        # Check if the package node exists and verify its namespace
        $packageNode = $xmlContent.SelectSingleNode("//*[local-name()='package']", $namespaceManager)
        if ($null -eq $packageNode) {
            Write-Error "Package node not found. Exiting." -Category ObjectNotFound
            break
        }
        else {
            Write-Verbose "Package node found."
        }

        # Check if the metadata node exists within the package node
        $metadataNode = $xmlContent.SelectSingleNode("//*[local-name()='metadata']", $namespaceManager)
        if ($null -eq $metadataNode) {
            Write-Error "Metadata node not found." -Category ObjectNotFound
            break
        }
        else {
            Write-Verbose "Metadata node found."
        }

        # Find the dependencies node
        $dependenciesNode = $xmlContent.SelectSingleNode("//*[local-name()='dependencies']", $namespaceManager)

        if ($null -eq $dependenciesNode) {
            $null = $dependenciesNode = $xmlContent.CreateElement('dependencies')
            $null = $metadataNode.AppendChild($dependenciesNode)
        }
        else {
            Write-Verbose "Dependencies node found."
        }

        #Loop over the given dependencies and create new nodes for each
        foreach ($D in $Dependency) {
            # Create a new XmlDocument
            $newDoc = New-Object System.Xml.XmlDocument

            # Create a new dependency element in the new document
            $newDependency = $newDoc.CreateElement("dependency")
            $newDependency.SetAttribute("id", "$($D['id'])")
            if ($D.version) {

                # Check if the version string contains invalid characters
                # Valid ranges: https://learn.microsoft.com/en-us/nuget/concepts/package-versioning?tabs=semver20sort#version-ranges
                if ($($D['version']) -match '\([^,]*?\)') {
                    Write-Error "Invalid version string: $($D['version']) for package $($D['id'])"
                    continue
                }
                $newDependency.SetAttribute("version", "$($D['version'])")
            }
            # Import the new dependency into the original document
            $importedDependency = $xmlContent.ImportNode($newDependency, $true)

            # Append the imported dependency to the dependencies node
            $null = $dependenciesNode.AppendChild($importedDependency)
        }

        # Save the xml back to the nuspec file
        $settings = New-Object System.Xml.XmlWriterSettings
        $settings.Indent = $true
        $settings.Encoding = [System.Text.Encoding]::UTF8

        $writer = [System.Xml.XmlWriter]::Create($Nuspec, $settings)
        try {
            $xmlContent.WriteTo($writer)
        }
        finally {
            $writer.Flush()
            $writer.Close()
            $writer.Dispose()
        }

        # Stupid hack to get rid of the 'xlmns=' part of the new dependency nodes. .Net methods are "overly helpful"
        $content = Get-Content -Path $Nuspec -Raw
        $content = $content -replace ' xmlns=""', ''
        Set-Content -Path $Nuspec -Value $content

        if ($Recompile) {
            if (-not (Get-Command choco)) {
                Write-Error "Choco is required to recompile the package but was not found on this system" -Category ResourceUnavailable
            }
            else {
                $OD = if ($OutputDirectory) {
                    $OutputDirectory
                }
                else {
                    Split-Path -Parent $Nuspec
                }

                $chocoArgs = ('pack', $Nuspec, $OD)
                $choco = (Get-Command choco).Source
                $null = & $choco @chocoArgs

                if ($LASTEXITCODE -eq 0) {
                    'Package is ready and available at {0}' -f $OD
                }
                else {
                    throw 'Recompile had an error, see chocolatey.log for details'
                }
            }
        }
    }
}