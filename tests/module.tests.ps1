[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [String]
    $Module
)
Import-Module -Name $Module
Describe 'Public function availability tests' {
    BeforeDiscovery {
        $expectedPublicFunctions = 'Function1', 'Function2', 'Function3'
        $publicFunctions = (Get-Command -Module 'PathToYourModule').Name
    }
    It 'Public function <_> is available' -ForEach $publicFunctions {
        $_ | Should -BeIn $expectedPublicFunctions
    }
}