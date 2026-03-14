function New-Metapackage {
    <#
    .SYNOPSIS
    Creates a new Chocolatey Meta (virtual) package
    
    .DESCRIPTION
    This function generates the necessary nuspec needed to create a Chocolatey metapackage
    
    .PARAMETER Id
    The id of the meta package to create
    
    .PARAMETER Summary
    Provide a brief summary of what the metapackage provides
    
    .PARAMETER Dependency
    An array of hashtables containing the id and (optional) version of the package to include in the metapackage.
    
    .PARAMETER Path
    The folder in which to generate the metapackage
    
    .PARAMETER Version
    A valid semver for the package. Defaults to 0.1.0
    
    .EXAMPLE
    A minimal example of a metapackage using mandatory parameters

    $newMetapackageSplat = @{
        Id = 'example'
        Summary = 'This is a simple example'
        Dependency = @{id='putty'}, @{id='git';version = '2.5.98'}
    }

    New-Metapackage @newMetapackageSplat    

    .EXAMPLE
    Create a meta package with a pre-release version, and save it to C:\chocopackages

    $newMetapackageSplat = @{
        Id = 'example'
        Summary = 'This is a simple example'
        Dependency = @{id='putty'}, @{id='git';version = '2.5.98'}
        Version = 1.0.0-pre
        Path = C:\chocopackages
    }

    New-Metapackage @newMetapackageSplat    

    .NOTES
    General notes
    #>
    [Alias('New-VirtualPackage')]
    [CmdletBinding(HelpUri = 'https://chocolatey-solutions.github.io/Fondue/New-Metapackage')]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [String]
        $Id,

        [Parameter(Position = 1, Mandatory)]
        [String]
        $Summary,

        [Parameter(Position = 2, Mandatory)]
        [Hashtable[]]
        $Dependency,

        [Parameter(Mandatory)]
        [ValidateScript({
                if ($_.Length -ge 30) {
                    $true
                }
                else {
                    throw "Description must be at least 30 characters long."
                }
            })]
        [String]
        $Description,

        [Parameter()]
        [String]
        $Path = $PWD,

        [Parameter()]
        [ValidateScript({
                $matcher = '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
                $_ -match $matcher
            })]
        [String]
        $Version = '0.1.0'
    )

    begin {
        $chocoTemplatesPath = 'C:\ProgramData\chocolatey\templates'

        if (-not (Test-Path $chocoTemplatesPath)) {
            $null = New-Item -ItemType Directory -Path $chocoTemplatesPath -Force
        }

        $copyItemSplat = @{
            Path        = Join-Path $PSScriptRoot 'template\metapackage'
            Destination = $chocoTemplatesPath
            Recurse     = $true
            Force       = $true
        }
        Copy-Item @copyItemSplat
    }

    end {
        $chocoArgs = @('new', "$Id", '--template="metapackage"', "Id=$Id", "Summary=$Summary", "Description=$Description", "Version=$Version")
        & choco @chocoArgs
    }
}