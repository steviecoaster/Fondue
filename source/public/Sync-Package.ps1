function Sync-Package {
    <#
    .SYNOPSIS
    Runs choco sync on a system
    
    .DESCRIPTION
    Run choco sync against a system with eiher a single item or from a map
    
    .PARAMETER Id
    The Package id for the synced package
    
    .PARAMETER DisplayName
    The Diplay Name From Programs and Features
    
    .PARAMETER Map
    A hashtable of DisplayName and PackageIds
    
    .EXAMPLE
    Sync-Package

    Sync everything from Programs and Features not under Chocolatey management

    .EXAMPLE
    Sync-Package -Id googlechrome -DisplayName 'Google Chrome'

    Sync the Google Chrome application from Programs and Features to the googlechrome package id

    .EXAMPLE
    Sync-Package -Map @{'Google Chrome' = 'googlechrome'}

    Sync from a hashtable of DisplayName:PackageId pairs
    
    .NOTES
    Requires a Chocolatey For Business license
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default', HelpUri = 'https://steviecoaster.github.io/Fondue/Sync-Package')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'Package')]
        [String]
        $Id,

        [Parameter(Mandatory, ParameterSetName = 'Package')]
        [String]
        $DisplayName,

        [Parameter(Mandatory, ParameterSetName = 'Map')]
        [hashtable]
        $Map,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Map')]
        [Parameter(ParameterSetName = 'Package')]
        [String]
        $OutputDirectory = $PWD
    )

    begin {
        
        $licenseValid = Assert-LicenseValid
        $extensionInstalled = Test-Path "$env:ChocolateyInstall\lib\chocolatey.extension"

        if (-not $licenseValid) {
            throw 'A valid Chocolatey license is required to use -File but was not found on this system.'
        }

        if (-not $extensionInstalled) {
            throw 'A valid license file was found, but the Chocolatey Licensed Extension is not installed. The Chocolatey Licensed Extension is required to use -File.'
        }
    }
    end {
        switch ($PSCmdlet.ParameterSetName) {
            'Package' {
                choco sync --id="$DisplayName" --package-id="$Id" --output-directory="$OutputDirectory"
                $packageFolder = Join-path $OutputDirectory -ChildPath "sync\$Id"
                $todo = Join-Path $packageFolder -ChildPath 'TODO.txt'

                if (Test-Path $todo) {
                    Write-Warning (Get-Content $todo)
                }
            }

            'Map' {
                $map.GetEnumerator() | Foreach-Object {
                    choco sync --id="$($_.Key)" --package-id="$($_.Value)" --output-directory="$OutputDirectory"
                    $packageFolder = Join-path $OutputDirectory -ChildPath $_.Value
                    $todo = Join-Path $packageFolder -ChildPath 'TODO.txt'

                    if (Test-Path $todo) {
                        Write-Warning (Get-Content $todo)
                    }
                }
            }

            default {
                choco sync --output-directory="$OutputDirectory"
            }
        }
    }
}