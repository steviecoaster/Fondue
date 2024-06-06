#Region './private/Write-Metadata.ps1' 0
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
        $xmlDoc.Save($NuspecFile)
    }
}
#EndRegion './private/Write-Metadata.ps1' 36
#Region './public/ New-Package.ps1' 0
function New-Package {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Parameter(Mandatory, ParameterSetName = 'Metapackage')]
        [String]
        $Name,

        [Parameter(ParameterSetName = 'Metapackage')]
        [Switch]
        $IsMetapackage,

        [Parameter(Mandatory, ParameterSetName = 'File')]
        [ValidateScript({ Test-Path $_ })]
        [String]
        $File,

        [Parameter(Mandatory, ParameterSetName = 'Url')]
        [String]
        $Url,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'File')]
        [Parameter(ParameterSetName = 'Url')]
        [Parameter(Mandatory, ParameterSetName = 'Metapackage')]
        [Hashtable[]]
        $Dependency,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'File')]
        [Parameter(ParameterSetName = 'Url')]
        [Parameter(ParameterSetName = 'Metapackage')]
        [Hashtable]
        $Metadata,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'File')]
        [Parameter(ParameterSetName = 'Url')]
        [Parameter(ParameterSetName = 'Metapackage')]
        [String]
        $OutputDirectory = $PWD,

        [Parameter(ParameterSetName = 'FIle')]
        [Parameter(ParameterSetName = 'Url')]
        [Parameter(ParameterSetName = 'MetaPackage')]
        [Switch]
        $Recompile
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'File' {
                $chocoArgs = @('new', "--file='$file'", "--output-directory='$OutputDirectory'", '--build-package')
                $i = 4
            }
            'Url' {
                $chocoArgs = @('new', "--url='$url'", "--output-directory='$OutputDirectory'", '--build-package', '--no-progress')
                $i = 7
            }

            'Metapackage' {
                $chocoArgs = @('new', "$Name", "--output-directory='$OutputDirectory'", "--template='metapackage'")
                $i = 4
            }

            default {
                $chocoArgs = @('new', "$Name", "--output-directory='$OutputDirectory'")
                $i = 3
            }
        }

        $matcher = "(?<nuspec>(?<=').*(?='))"

        $choco = & choco @chocoArgs
        Write-Verbose -Message $('Matching against {0}' -f $choco[$i])
        $null = $choco[$i] -match $matcher

        if ($matches.nuspec) {
            if ($IsMetapackage) {
                'Adding dependencies to package {0}' -f $Name
            }
            else {
                'Adding dependencies to package {0}, if any' -f $matches.nuspec
            }
        }
        else {
            throw 'Something went wrong, check the chocolatey.log file for details!'
        }

        if ($Dependency) {
            $newDependencySplat = @{
                Nuspec          = $matches.nuspec
                Dependency      = $Dependency
                OutputDirectory = $OutputDirectory
            }

            New-Dependency @newDependencySplat
        }

        if($Metadata){
            Write-Metadata -Metadata $Metadata -NuspecFile $matches.nuspec
        }
        
        if ($Recompile) {
            $chocoArgs = ('pack', $matches.nuspec, $OutputDirectory)
            $choco = (Get-Command choco).Source
            $null = & $choco @chocoArgs

            if ($LASTEXITCODE -eq 0) {
                'Package is ready and available at {0}' -f $OutputDirectory
            }
            else {
                throw 'Recompile had an error, see chocolatey.log for details'
            }

        }
    }
}
#EndRegion './public/ New-Package.ps1' 119
#Region './public/Convert-Xml.ps1' 0
Function Convert-Xml {
    [cmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $Url,

        [Parameter()]
        [String]
        $File
    )

    process {    
        if ($url) {
            [xml]$xml = [System.Net.WebClient]::new().DownloadString($url)
        }

        if ($File) {
            [xml]$xml = Get-Content $File
        }

        $hash = @{}

        foreach ($node in ($xml.package.metadata.ChildNodes | Where-Object {$_.Name -notmatch 'dependencies|#comment'})) {
            $hash.Add($node.Name, $node.'#text')
        }

        return $hash
    }
}
#EndRegion './public/Convert-Xml.ps1' 31
#Region './public/Invoke-PackageInternalizer.ps1' 0
function Invoke-PackageInternalizer {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory)]
        [String[]]
        $PackageList,

        [Parameter(Mandatory)]
        [String]
        $DestinationRepository,

        [Parameter()]
        [String]
        $ApiKey,

        [Parameter(Mandatory, ParameterSetName = 'Dependency')]
        [Switch]
        $RemoveDependency,

        [Parameter(Mandatory, ParameterSetName = 'Dependency')]
        [string[]]
        $Dependency
    )

    process {
        $temp = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).Guid
        $null = New-Item -Path $temp -ItemType Directory
        Write-Output "Created temporary directory '$temp'."
        $PackageList | ForEach-Object {
            $c = choco download $_ --no-progress --internalize --force --internalize-all-urls --append-use-original-location --output-directory=$temp --source='https://community.chocolatey.org/api/v2/'
            switch ($PSCmdlet.ParameterSetName) {
                'Dependency' {
                    $matcher = "(?<nuspec>(?<=').*(?='))"
                    if ($c[-1] -match $matcher) {
                        $nuspecFile = (Get-ChildItem $matches.nuspec -Filter *.nuspec -Recurse).FullName
                        Remove-Dependency -PackageNuspec $nuspecFile -Dependency $Dependency
                    }
                }
            }
            if ($LASTEXITCODE -eq 0) {
                (Get-Item -Path (Join-Path -Path $temp -ChildPath "*.nupkg")).fullname | ForEach-Object {
                    choco push $_ --source="$($DestinationRepository)" --api-key="$($ApiKey)" --force
                    if ($LASTEXITCODE -eq 0) {
                        Write-Verbose "Package '$_' pushed to '$($DestinationRepository)'.";
                    }
                    else {
                        Write-Verbose "Package '$_' could not be pushed to '$($DestinationRepository)'.`nThis could be because it already exists in the repository at a higher version and can be mostly ignored. Check error logs."
                    }
                }
            }
            else {
                Write-Output "Failed to download package '$_'"
            }

            # Clean up, ready for next execution
            Remove-Item -Path (Join-Path -Path $temp -ChildPath "*.nupkg") -Force
        }

        Remove-Item -Path $temp -Force -Recurse
    }
}
#EndRegion './public/Invoke-PackageInternalizer.ps1' 62
#Region './public/New-ConfigurationPackage.ps1' 0
function New-ConfigurationPackage {
    <#
    .SYNOPSIS
    Generate a package that configures Windows
    
    .DESCRIPTION
    This package can manipulate Registry Keys, Files, Environment Variables, or Firewall Rules
    
    .PARAMETER Name
    The name of the package
    
    .PARAMETER RegistryKey
    #This hashtable will be splatted to New-ItemProperty. Run 'Get-Help New-ItemPropery -Parameter *' for a list of options
    
    .PARAMETER ConfigFile
    This hashtable should include the file you wish to include, and its destination path on the target filesystem
    
    .PARAMETER FirewallRule
    This hashtable will be splatted to New-NetFirewallRule. Run 'Get-Help New-NetFirewallRule -Parameter *' for a list of options
    
    .PARAMETER EnvironmentVariable
    The hashtable must contain Name,Value, and Scope keys. Scope may be one of: Machine,User,or Process. Names and values must be under 32,767 characters.
    
    .PARAMETER OutputDirectory
    Directory to store the compiled package. Default to $PWD
    
    .EXAMPLE
    New-ConfigurationPackage -Name registry-config -RegistryKey $r =
    
    .EXAMPLE
    New-ConfigurationPackage -Name sys-config -RegistryKey $r -ConfigFile $c -FirewallRule $f -EnvironmentVariable $e
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateScript({ ($_).EndsWith('-config')})]
        [String]
        $Name,

        
        [Parameter()]
        [Hashtable[]]
        $RegistryKey,

        #
        [Parameter()]
        [Hashtable[]]
        $ConfigFile,

        #
        [Parameter()]
        [Hashtable[]]
        $FirewallRule,

        #T 
        [Parameter()]
        [Hashtable[]]
        $EnvironmentVariable,

        [Parameter()]
        [String]
        $OutputDirectory = $PWD
    )
    begin {
        if ($null -eq $PSBoundParameters) {
            throw 'At least one of the following is required: RegistryKey,ConfigFile,FirewallRule,EnvironmentVariable'
        }
    }
    process {

        #Build the package and get the tools dir so we can play with it
        $chocoArgs = @('new', "$Name", "--output-directory='$OutputDirectory'", "--template='configuration'")
        $i = 6
        $choco = & choco @chocoArgs
        $matcher = "(?<toolsdir>(?<=').*(?='))"
        $null = $choco[$i] -match $matcher
        $toolsdir = Split-Path -Parent $matches.toolsdir

        if ($FirewallRule) {
            $fwconfiguration = [System.Collections.Generic.List[String]]::new()
            $fwscript = Join-Path $toolsdir -ChildPath 'firewall.ps1'
            $null = New-Item $fwscript -ItemType File

            Foreach ($rule in $FirewallRule) {
                $strings = @()
                $rule.GetEnumerator() | ForEach-Object { $strings += '{0} = "{1}"' -f $_.Key, $_.Value }
                $hash = @"
@{
    $($strings -join [System.Environment]::NewLine)
}
"@
                    
                $sb = @'
$rule = {0}
                    
New-NetFirewallRule @rule
'@ -f $hash
                $fwconfiguration.Add($sb)                    
            }
                
            foreach ($fwrule in $fwconfiguration) {
                #create the script
                $fwrule | Add-Content $fwscript
            }
        }#firewall

        if ($RegistryKey) {
            $registryconfiguration = [System.Collections.Generic.list[string]]::new()
            $regscript = Join-Path $toolsdir -ChildPath 'registry.ps1'
            $null = New-Item $regscript -ItemType File

            foreach ($Regkey in $RegistryKey) {
                $strings = @()
                $Regkey.GetEnumerator() | ForEach-Object { $strings += '{0} = "{1}"' -f $_.Key, $_.Value }
                $hash = @"
@{
    $($strings -join [System.Environment]::NewLine)
}
"@

                $sb = @'

$key = {0}

New-ItemProperty @key
'@ -f $hash.TrimEnd().TrimStart().Trim()
                $registryconfiguration.Add($sb)
            }


            foreach ($rk in $registryconfiguration) {
                $rk | Add-Content $regscript
            }
        }#registry

        if ($ConfigFile) {
            $copyconfiguration = [System.Collections.Generic.list[string]]::new()
            $configscript = Join-Path $toolsdir -ChildPath 'config.ps1'
            $null = New-Item $configscript -ItemType File

            $sb = @'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
'@

            $copyconfiguration.Add($sb)

            foreach ($config in $ConfigFile) {
                Copy-Item $config.File -Destination $toolsdir
                #We need the filename
                $cf = Split-Path $config.File -Leaf

                $sb = @'
$file = Join-Path $toolsDir -Childpath "{0}"
Write-host "Copying configuration"
Copy-Item $file -Destination "{1}"
'@ -f $cf, $Config.Destination
                $copyconfiguration.Add($sb)
            }


            foreach ($c in $copyconfiguration) {
                $c | Add-Content $configscript
            }
        }#config

        if ($EnvironmentVariable) {
            $envconfiguration = [System.Collections.Generic.list[string]]::new()
            $envscript = Join-Path $toolsdir -ChildPath 'environment.ps1'
            $null = New-Item $envscript -ItemType File
    
            foreach ($ev in $EnvironmentVariable) {
               
    
                $sb = @'
Write-Host "Setting environment variable: {3}"
[Environment]::SetEnvironmentVariable("{0}","{1}","{2}")

'@ -f $ev.Name, $ev.Value, $ev.Scope, $ev.Name
    
                if ($sb -notin $envconfiguration) {
                    $envconfiguration.Add($sb)
                }
    
               
            }
            foreach ($ec in $envconfiguration) {
                $ec | Add-Content $envscript
            }
        }#environment
    }#process
}
#EndRegion './public/New-ConfigurationPackage.ps1' 192
#Region './public/New-Dependency.ps1' 0
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

New-Dependency -Nuspec C:\packages\foo.1.1.0.nuspec -Dependency @{id='baz'},@{id='boo';version=[1.0.1,2.9.0]}

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
    [CmdletBinding()]
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
        $xmlContent.Save($Nuspec)

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

                if($LASTEXITCODE -eq 0){
                    'Package is ready and available at {0}' -f $OD
                } else {
                    throw 'Recompile had an error, see chocolatey.log for details'
                }
            }
        }
    }
}
#EndRegion './public/New-Dependency.ps1' 170
#Region './public/New-MetaPackage.ps1' 0
#EndRegion './public/New-MetaPackage.ps1' 1
#Region './public/Remove-Dependency.ps1' 0
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
#EndRegion './public/Remove-Dependency.ps1' 35
#Region './public/Update-Metadata.ps1' 0
function Update-ChocolateyMetadata {
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
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
#EndRegion './public/Update-Metadata.ps1' 18
#Region './Suffix.ps1' 0
#EndRegion './Suffix.ps1' 1
