[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [String]
    $PackagePath
)


BeforeAll {
    $packageData = Get-ChildItem $PackagePath -Recurse -Force
}

Describe 'Required Package Contents Tests' {

    Context 'Illegal files in package' {
       
        
        It 'Does not contain [Content_Types].xml' {
            $packageData | Where-Object Name -eq '[Content_Types].xml' | Should -BeNullOrEmpty -Because 'CPMR0004 - Do Not Package Internal Files (package)'
        }
        It 'Does not contain a _rels directory' {
            $packageData | Where-Object Name -eq '_rels' | Should -BeNullOrEmpty -Because 'CPMR0004 - Do Not Package Internal Files (package)'
        }

        It 'Does not contain files ending in .rels' {
            $packageData | Where-Object { $_.Extension -eq '.rels' } | Should -BeNullOrEmpty -Because 'CPMR0004 - Do Not Package Internal Files (package)'
        }
        It 'Does not contain files ending in .psmdcp' {
            $packageData | Where-Object { $_.Extension -eq '.psmdcp' } | Should -BeNullOrEmpty -Because 'CPMR0004 - Do Not Package Internal Files (package)'
        }

        It 'Does not contain source files' {
            '.git' -in $packageData.Name | Should -Be $false -Because 'CPMR0013 - Source Control Files Are Packaged (package)'
        }

        It 'Does not contain a .gitignore file' {
            '.gitignore' -in $packageData.Name | Should -Be $false -Because 'CPMR0025 - Source Control Ignore Files Are Packaged (package)'
        }
    }

    Context 'Scripts have been named properly' {
        BeforeDiscovery {
            $installScript = $packageData | Where-Object Name -eq 'chocolateyInstall.ps1'
            $uninstallScript = $packageData | Where-Object Name -eq 'chocolateyUninstall.ps1'
        }

        It 'Install script has the correct name' {
            'chocolateyInstall.ps1' | Should -BeIn $packageData.Name -Because 'CPMR0003 - Install Script Named Incorrectly (package)'
        }

        It 'Uninstall script has the correct name' {
            'chocolateyUninstall.ps1' | Should -BeIn $packageData.Name -Because 'CPMR0015 - Uninstall Script Named Incorrectly (script)'
        }
    }

    BeforeDiscovery {
        $matcher = '\.exe|\.msi'
        $binaries = $packageData | Where-Object { $_.Extension -match $matcher }
    }
    
    Context 'License.txt and Verification.txt exists for included binaries' {
         
        if ($binaries) {
            It 'LICENSE.txt is present' {
                'LICENSE.txt' -in $packageData.Name | Should -Be $true -Because 'CPMR0005 - LICENSE.txt file missing when binaries included (package)'
            }

            It 'Verification.txt is present' {
                'Verification.txt' -in $packageData.Name | Should -Be $true -Because 'CPMR0006 - VERIFICATION.txt file missing when binaries included (package)'
            }
        }
    }
}