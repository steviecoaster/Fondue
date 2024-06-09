[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [String]
    $Module
)
Write-Warning "Got $Module"
Import-Module -Name $Module
Describe 'Public function availability tests' {
    BeforeDiscovery {
        $expectedPublicFunctions = @('Convert-Xml','New-Package','New-Dependency','New-MetaPackage')
        $publicFunctions = (Get-Command -Module Chocolatier).Name
    }

    Context 'Public functions are available to the module' {
        It 'Public function <_> is available' -ForEach $expectedpublicFunctions {
            $_ | Should -BeIn $PublicFunctions
        }
    }

}