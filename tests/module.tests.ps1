[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [String]
    $Module
)

Describe 'Public function availability tests' {
    BeforeDiscovery {
        $expectedPublicFunctions = @('Convert-Xml',
        'New-Package',
        'New-Dependency',
        'New-MetaPackage',
        'New-VirtualPackage',
        'Open-FondueHelp',
        'Remove-Dependency',
        'Test-Nuspec',
        'Test-Package',
        'Update-ChocolateyMetadata')
        $publicFunctions = (Get-Command -Module Fondue).Name
    }

    Context 'Public functions are available to the module' {
        It 'Public function <_> is available' -ForEach $expectedPublicFunctions {
            $_ | Should -BeIn (Get-Command -Module Fondue).Name
        }
    }

}