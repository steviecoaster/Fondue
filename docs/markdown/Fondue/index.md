---
document type: module
Help Version: 1.0.0.0
HelpInfoUri: https://steviecoaster.github.io/Fondue/
Locale: en-US
Module Guid: 20f7494c-ab60-4780-b9d6-5a9abc894075
Module Name: Fondue
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Fondue Module
---

# Fondue

> A PowerShell module that melts away the complexity of creating and managing Chocolatey packages.

Fondue provides a rich set of cmdlets that streamline every step of the Chocolatey package lifecycle — from scaffolding new packages and metapackages, to managing dependencies, updating metadata, syncing installed software, and validating your work before publishing.

---

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Commands](#commands)
  - [New-Package](#new-package)
  - [New-Metapackage](#new-metapackage)
  - [New-Dependency](#new-dependency)
  - [Remove-Dependency](#remove-dependency)
  - [Update-ChocolateyMetadata](#update-chocolateymetadata)
  - [Sync-Package](#sync-package)
  - [Convert-Xml](#convert-xml)
  - [Test-Nuspec](#test-nuspec)
  - [Test-Package](#test-package)
  - [Open-FondueHelp](#open-fonduehelp)
- [Building from Source](#building-from-source)
- [Support](#support)

---

## Requirements

- PowerShell 5.1+ / PowerShell 7+
- [Chocolatey](https://chocolatey.org/) installed
- Some commands require a **Chocolatey for Business** license (noted per-command below)

---

## Installation

```powershell
Install-Module -Name Fondue
```

Or import a locally built copy:

```powershell
Import-Module .\Output\Fondue\Fondue.psd1
```

---

## Commands

### New-Package

Scaffolds a new Chocolatey package. Supports basic package creation, packaging from a local installer file, packaging from a URL, and creating metapackages — all with optional metadata injection.

_Some features, like passing -File and -Url, require a Chocolatey for Business license_


#### Create a basic named package in the current directory

```powershell
$newPackageSplat = @{
    Name = 'MyApp'
}

New-Package @newPackageSplat
```

#### Scaffold a package from a local installer

```powershell
$newPackageSplat = @{
    Name = 'MyApp'
    File = 'C:\installers\myapp-setup.exe'
}

New-Package @newPackageSplat
```

#### Scaffold a package from a download URL (installer is downloaded and embedded)

```powershell
$newPackageSplat = @{
    Name = 'MyApp'
    Url  = 'https://example.com/myapp-setup.exe'
}

New-Package @newPackageSplat
```

#### Create a package with rich metadata

```powershell
$newPackageSplat = @{
    Name     = 'MyApp'
    Metadata = @{
        Authors     = 'Acme Corp'
        Version     = '2.1.0'
        Description = 'The best app ever made'
        ProjectUrl  = 'https://example.com'
    }
}

New-Package @newPackageSplat
```

#### Scaffold and immediately compile to .nupkg

```powershell
$newPackageSplat = @{
    Name      = 'MyApp'
    Recompile = $true
}

New-Package @newPackageSplat
```

#### Write output to a specific directory

```powershell
$newPackageSplat = @{
    Name            = 'MyApp'
    OutputDirectory = 'C:\chocopackages'
}

New-Package @newPackageSplat
```

---

### New-Metapackage

Creates a Chocolatey meta (virtual) package — a package that contains no software itself but declares a set of dependencies that will be installed together.

#### Minimal metapackage

```powershell
$newMetapackageSplat = @{
    Id          = 'dev-tools'
    Summary     = 'Common developer tools'
    Description = 'Installs a curated set of developer tooling for new machines.'
    Dependency  = @{id = 'git'}, @{id = 'vscode'}, @{id = 'nodejs'}
}

New-Metapackage @newMetapackageSplat
```

#### Pin specific dependency versions

```powershell
$newMetapackageSplat = @{
    Id          = 'dev-tools'
    Summary     = 'Common developer tools'
    Description = 'Installs a curated set of developer tooling for new machines.'
    Dependency  = @{id = 'git'; version = '2.44.0'}, @{id = 'putty'}
}

New-Metapackage @newMetapackageSplat
```

#### Set an explicit version and save to a custom path

```powershell
$newMetapackageSplat = @{
    Id          = 'dev-tools'
    Summary     = 'Common developer tools'
    Description = 'Installs a curated set of developer tooling for new machines.'
    Dependency  = @{id = 'git'; version = '2.44.0'}, @{id = 'putty'}
    Version     = '1.0.0'
    Path        = 'C:\chocopackages'
}

New-Metapackage @newMetapackageSplat
```

#### Pre-release version

```powershell
$newMetapackageSplat = @{
    Id          = 'dev-tools'
    Summary     = 'Common developer tools'
    Description = 'Installs a curated set of developer tooling for new machines.'
    Dependency  = @{id = 'git'}
    Version     = '1.0.0-pre'
}

New-Metapackage @newMetapackageSplat
```

> **Alias:** `New-VirtualPackage`

---

### New-Dependency

Injects one or more `<dependency>` nodes into an existing `.nuspec` file, with an optional step to recompile the package afterwards.

#### Add a single versioned dependency

```powershell
$newDependencySplat = @{
    Nuspec     = 'C:\packages\myapp.1.0.0.nuspec'
    Dependency = @{id = 'vcredist140'; version = '14.30.0'}
}

New-Dependency @newDependencySplat
```

#### Add multiple dependencies at once

```powershell
$newDependencySplat = @{
    Nuspec     = 'C:\packages\myapp.1.0.0.nuspec'
    Dependency = @{id = 'git'; version = '2.44.0'}, @{id = 'nodejs'; version = '[18.0.0,20.0.0)'}
}

New-Dependency @newDependencySplat
```

#### Add a dependency and immediately repack

```powershell
$newDependencySplat = @{
    Nuspec     = 'C:\packages\myapp.1.0.0.nuspec'
    Dependency = @{id = 'vcredist140'; version = '14.30.0'}
    Recompile  = $true
}

New-Dependency @newDependencySplat
```

#### Add, repack, and save to a different output folder

```powershell
$newDependencySplat = @{
    Nuspec          = 'C:\packages\myapp.1.0.0.nuspec'
    Dependency      = @{id = 'vcredist140'}
    Recompile       = $true
    OutputDirectory = 'C:\recompiled'
}

New-Dependency @newDependencySplat
```

---

### Remove-Dependency

Removes one or more dependencies from an existing `.nuspec` file.


#### Remove a single dependency

```powershell
$removeDependencySplat = @{
    PackageNuspec = 'C:\packages\myapp.nuspec'
    Dependency    = 'vcredist140'
}

Remove-Dependency @removeDependencySplat
```

#### Remove multiple dependencies

```powershell
$removeDependencySplat = @{
    PackageNuspec = 'C:\packages\myapp.nuspec'
    Dependency    = 'vcredist140', 'dotnetfx'
}

Remove-Dependency @removeDependencySplat
```

---

### Update-ChocolateyMetadata

Updates one or more metadata fields inside a `.nuspec` file from a hashtable.


#### Bump the version and add a release note

```powershell
$updateMetadataSplat = @{
    NuspecFile = 'C:\packages\myapp.nuspec'
    Metadata   = @{
        version      = '2.2.0'
        releaseNotes = 'Fixed a critical bug.'
    }
}

Update-ChocolateyMetadata @updateMetadataSplat
```

#### Pipeline usage

```powershell
$updateMetadataSplat = @{
    NuspecFile = 'C:\packages\myapp.nuspec'
}
@{version = '3.0.0'} | Update-ChocolateyMetadata @updateMetadataSplat
```

---

### Sync-Package

Brings software already installed on the machine (visible in **Programs and Features**) under Chocolatey management using `choco sync`.

> **Requires:** Chocolatey for Business license + Chocolatey Licensed Extension


#### Sync everything not already managed by Chocolatey

```powershell
Sync-Package
```

#### Sync a single application by display name and desired package ID

```powershell
$syncPackageSplat = @{
    Id          = 'googlechrome'
    DisplayName = 'Google Chrome'
}

Sync-Package @syncPackageSplat
```

#### Sync from a hashtable map of DisplayName → PackageId pairs

```powershell
$syncPackageSplat = @{
    Map = @{
        'Google Chrome' = 'googlechrome'
        'Notepad++'     = 'notepadplusplus'
    }
}

Sync-Package @syncPackageSplat
```

#### Write synced packages to a custom output directory

```powershell
$syncPackageSplat = @{
    Map             = @{'Notepad++' = 'notepadplusplus'}
    OutputDirectory = 'C:\synced'
}

Sync-Package @syncPackageSplat
```

---

### Convert-Xml

Reads a `.nuspec` file (from disk or a URL) and converts the package metadata into a PowerShell hashtable — great for piping into `Update-ChocolateyMetadata` or `Test-Nuspec`.


#### Convert a local nuspec to a hashtable

```powershell
$convertXmlSplat = @{
    File = 'C:\packages\myapp.nuspec'
}

$meta = Convert-Xml @convertXmlSplat
```

#### Fetch and convert a nuspec from a URL

```powershell
$convertXmlSplat = @{
    Url = 'https://packages.example.com/myapp/myapp.nuspec'
}

$meta = Convert-Xml @convertXmlSplat
```

#### Pipe the result into Update-ChocolateyMetadata

```powershell
$convertXmlSplat = @{
    File = 'C:\packages\myapp.nuspec'
}
$updateMetadataSplat = @{
    NuspecFile = 'C:\packages\myapp.nuspec'
}

Convert-Xml @convertXmlSplat | Update-ChocolateyMetadata @updateMetadataSplat
```

---

### Test-Nuspec

Validates a `.nuspec` file (or a raw metadata hashtable) against Fondue's built-in rule set. You can also supply additional Pester-based test scripts for organization-specific requirements.


#### Run all built-in tests against a nuspec

```powershell
$testNuspecSplat = @{
    NuspecFile = 'C:\packages\myapp.nuspec'
}

Test-Nuspec @testNuspecSplat
```

#### Test a raw metadata hashtable instead of a file

```powershell
$testNuspecSplat = @{
    Metadata = @{id = 'myapp'; version = '1.0.0'}
}

Test-Nuspec @testNuspecSplat
```

#### Skip built-in tests and run only your own

```powershell
$testNuspecSplat = @{
    NuspecFile       = 'C:\packages\myapp.nuspec'
    SkipBuiltinTests = $true
    AdditionalTest   = 'C:\tests\my-nuspec-rules.tests.ps1'
}

Test-Nuspec @testNuspecSplat
```
#### Combine built-in tests with additional custom tests

```powershell
$testNuspecSplat = @{
    NuspecFile     = 'C:\packages\myapp.nuspec'
    AdditionalTest = 'C:\tests\my-nuspec-rules.tests.ps1'
}

Test-Nuspec @testNuspecSplat
```

---

### Test-Package

Validates an already-packed `.nupkg` file against Fondue's package-level rule set. Useful as a gate before publishing.

#### Run all built-in package tests

```powershell
$testPackageSplat = @{
    PackagePath = 'C:\packages\myapp.2.0.0.nupkg'
}

Test-Package @testPackageSplat
```

#### Run only the mandatory (required) rules

```powershell
$testPackageSplat = @{
    PackagePath       = 'C:\packages\myapp.2.0.0.nupkg'
    OnlyRequiredRules = $true
}

Test-Package @testPackageSplat
```

#### Add extra Pester test scripts on top of the built-in suite

```powershell
$testPackageSplat = @{
    PackagePath    = 'C:\packages\myapp.2.0.0.nupkg'
    AdditionalTest = 'C:\tests\internal-policy.tests.ps1'
}

Test-Package @testPackageSplat
```

---

### Open-FondueHelp

Opens the Fondue documentation website in your default browser.

```powershell
Open-FondueHelp
```

---

## Building from Source

Fondue uses [ModuleBuilder](https://github.com/PoshCode/ModuleBuilder) to compile the module from the `source/` directory.

```powershell
# Install required modules
.\Requirements.ps1

# Build the module (output lands in .\Fondue\)
.\build.ps1 -Build

# Run the Pester test harness
.\harness.ps1 -Module Fondue
```

---

## Support

Commercial support for this module is not available, however community assistance can be found
by joining our [Discord](https://ch0.co/community) server!
