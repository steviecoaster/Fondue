[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [hashtable]
    $Metadata
)

Describe 'Chocolatey Community Repository Nuspec Requirements' {

    Context 'Required Metadata' {
        
        It "<Property> is defined" -ForEach @(
            @{Property = 'id' }
            @{Property = 'version' }
            @{Property = 'summary' }
            @{Property = 'description' }
            @{Property = 'authors' }
        ) {
            $metadata.$($_.Property)  | Should -Not -BeNullOrEmpty -Because "$($_.Property) is required to run choco pack against this nuspec file."
        }

    }

    Context 'All required Urls are defined' {
        It "<Property> is defined" -ForEach @(
            @{Property = 'projectUrl' ; Rule = 'CPMR0009 - ProjectUrl Missing (nuspec)' }
            @{Property = 'packageSourceUrl' ; Rule = 'CPMR0040 - PackageSourceUrl Missing (nuspec)' }
            @{Property = 'iconUrl' ; Rule = 'CPMR0033 - IconUrl Missing (nuspec)' }
        ) {
            $metadata.$($_.Property)  | Should -Not -BeNullOrEmpty -Because $_.Rule
        }

        It 'projectSourceUrl matches ProjectUrl' {
            $metadata.projectSourceUrl -eq $metadata.projectUrl | Should -Be $true -Because 'CPMR0041 - ProjectSourceUrl Matches ProjectUrl (nuspec)'
        }
    }

    Context 'Templated values are not in use' {
        BeforeDiscovery {
            $data = @()
            $Metadata.GetEnumerator() | ForEach-Object {
                $data += @{Node = $_.Name; Value = $_.Value }
            }
        }
        It "<Node> does not have template values" -foreach $data {
            $matcher = '__.+__|SPACE_SEPARATED'
            $Value -match $matcher | Should -Be $false -Because "CPMR0019: The element $Node contained a templated value. Templated values should not be present in the Metadata file"
        }
        
    }

    Context 'All fields are valid lengths' {

        It 'Description > 30 characters' {
            ($metadata.description).length -gt 30 | Should -Be $true -Because 'CPMR0032 - Description Character count below 30 (nuspec)'
        }

        It 'Description less than 4000 characters' {
            ($metadata.description).Length -lt 4000 | Should -Be $true -Because 'CPMR0026 - Description Character Count Above 4000 (nuspec)'
        }

        It 'Copyright is >= 4 characters' {
            ($Metadata.copyright).length -ge 4 | Should -be $true -Because 'CPMR0001 - Copyright character count below 4 (nuspec)'
        }
    }

    Context 'Package id validation' {
        It 'Id does not use resevered name' {
            ($Metadata.id).EndsWith('.config') | Should -Be $false -Because 'CPMR0029 - Package Id Does Not End With .config (nuspec)'
        }

        It 'Does not contain prerelease information' {
            $matcher = '(alpha|beta)$'
            $Metadata.id -match $matcher | Should -Be $false -Because "CPMR0024 - Prerelease information shouldn't be included as part of Package Id (nuspec)"
        }
    }
    
    Context 'Tag validation' {

        It 'Tags are required for the package' {
            $Metadata.tags | should -Not -BeNullOrEmpty -Because 'CPMR0023 - Tags Missing (nuspec)'
        }

        It 'Tags should be space separated' {
            It 'Tags should be space separated' {
                $Metadata.tags | Should -Match '^(\S+ )+\S+$' -Because 'CPMR0014 - Tags Have Commas (nuspec)'
            }
        }
    }
    
    Context 'Description content' {
        BeforeDiscovery {
            $lines = $metadata.description -split '\n'
            $headings = $lines | Where-Object { $_ -match '^#' }
        }
        
        It 'Description is not null' {
            $metadata.description | Should -Not -BeNullOrEmpty -Because 'CPMR0002 - Description missing (nuspec)'
        }

        It "<_> is a valid heading" -foreach $headings {
            $_ | Should -Match '^#{1,6} .+' -Because 'CPMR0030 - Description Contains Invalid Markdown Heading (nuspec)'
        }
    }

    Context 'Version validation' {
        It 'Version is proper semver' {
            $semvermatch = '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
            $metadata.version -match $semvermatch | Should -Be $true
        }

        Context 'LicenseUrl is used correctly' {
            It 'Should have valid licenseUrl when requiring license acceptance' {
                if ($metadata.requireLicenseAcceptance) {
                    $metadata.licenseUrl | Should -not -BeNullOrEmpty -Because 'CPMR0007 - License Url Missing / License Acceptance is True (nuspec)'
                }
            }
        }

    }

    # TODO: https://docs.chocolatey.org/en-us/community-repository/moderation/package-validator/rules/cpmr0017
    # TODO: https://docs.chocolatey.org/en-us/community-repository/moderation/package-validator/rules/cpmr0020
}