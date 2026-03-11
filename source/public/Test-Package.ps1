function Test-Package {
    <#
        .SYNOPSIS
        Tests a NuGet package for compliance with specified rules.

        .DESCRIPTION
        The Test-Package function takes a NuGet package and a set of rules as input. It tests the package for compliance with the specified rules. The function can test for compliance with only the required rules, or it can also test for compliance with all system rules. Additional tests can be specified.

        .PARAMETER PackagePath
        The path to the NuGet package to test. This parameter is mandatory and validated to ensure that it is a valid path.

        .PARAMETER OnlyRequiredRules
        A switch that, when present, causes the function to test for compliance with only the required rules.

        .PARAMETER AdditionalTest
        An array of additional tests to run. This parameter is optional.

        .EXAMPLE
        Test-Package -PackagePath "C:\path\to\package.nupkg" -OnlyRequiredRules

        This example tests the NuGet package at the specified path for compliance with only the required rules.

        .EXAMPLE
        Test-Package -PackagePath "C:\path\to\package.nupkg" -AdditionalTest "Test1", "Test2"

        This example tests the NuGet package at the specified path and runs the additional tests "Test1" and "Test2".

        .NOTES
        The function uses the Fondue module to perform the tests.
    #>
    [CmdletBinding(HelpUri = 'https://steviecoaster.github.io/Fondue/Test-Package')]
    Param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ })]
        [String]
        $PackagePath,

        [Parameter()]
        [Switch]
        $OnlyRequiredRules,

        [Parameter()]
        [String[]]
        $AdditionalTest
    )

    process {

        $Data = @{ PackagePath = $PackagePath }
        $moduleRoot = (Get-Module Fondue).ModuleBase
        
        $SystemTests = (Get-ChildItem (Join-Path $moduleRoot -ChildPath 'module_tests') -Recurse -Filter package*.tests.ps1) | Select-Object Name, FullName

        $containerCollection = [System.Collections.Generic.List[psobject]]::new()

        if ($OnlyRequiredRules) {
            $tests = ($SystemTests | Where-Object Name -match 'required').FullName
            $containerCollection.Add($tests)
        }
        else {
            $tests = ($SystemTests).FullName
            $containerCollection.Add($tests)
        }

        if ($AdditionalTest) {
            $AdditionalTest | ForEach-Object { $containerCollection.Add($_) }
        }
        
        $containers = $containerCollection | Foreach-object { New-PesterContainer -Path $_ -Data $Data }

        $configuration = [PesterConfiguration]@{
            Run        = @{
                Container = $Containers
                Passthru  = $true
            }
            Output     = @{
                Verbosity = 'Detailed'
            }
            TestResult = @{
                Enabled = $false
            }
        }
    
        $results = Invoke-Pester -Configuration $configuration

    } 
    
}