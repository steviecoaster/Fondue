function Test-Nuspec {
    <#
        .SYNOPSIS
        Tests a NuGet package specification (.nuspec) file for compliance with specified rules.

        .DESCRIPTION
        The Test-Nuspec function takes a .nuspec file and a set of rules as input. It tests the .nuspec file for compliance with the specified rules. The function can test for compliance with only the required rules, or it can also test for compliance with community rules. Additional tests can be specified.

        .PARAMETER NuspecFile
        The path to the .nuspec file to test. This parameter is validated to ensure that it is a valid path.

        .PARAMETER Metadata
        A hash table of metadata to test. This parameter is optional.

        .PARAMETER OnlyRequiredRules
        A switch that, when present, causes the function to test for compliance with only the required rules.

        .PARAMETER TestCommunityRules
        A switch that, when present, causes the function to test for compliance with community rules.

        .PARAMETER AdditionalTest
        An array of additional tests to run. This parameter is optional.

        .EXAMPLE
        Test-Nuspec -NuspecFile "C:\path\to\package.nuspec" -OnlyRequiredRules

        This example tests the .nuspec file at the specified path for compliance with only the required rules.

        .EXAMPLE
        Test-Nuspec -NuspecFile "C:\path\to\package.nuspec" -TestCommunityRules -AdditionalTest "Test1", "Test2"

        This example tests the .nuspec file at the specified path for compliance with community rules and runs the additional tests "Test1" and "Test2".

        .NOTES
        The function uses the Convert-Xml function to convert the .nuspec file to a hash table of metadata.
    #>
    [CmdletBinding(HelpUri = 'https://steviecoaster.github.io/Fondue/Test-Nuspec')]
    Param(
        [Parameter()]
        [ValidateScript({ Test-Path $_ })]
        [String]
        $NuspecFile,

        [Parameter()]
        [Hashtable]
        $Metadata,

        [Parameter()]
        [Switch]
        $SkipBuiltinTests,

        [Parameter()]
        [String[]]
        $AdditionalTest
    )

    process {

        $data = if ($NuspecFile) {
            $Metadata = Convert-Xml -File $NuspecFile
            @{ metadata = $Metadata }
        }
        else {
            @{ Metadata = $Metadata }
        }

        $moduleRoot = (Get-Module Fondue).ModuleBase
        $SystemTests = (Get-ChildItem (Join-Path $moduleRoot -ChildPath 'module_tests') -Recurse -Filter nuspec*.tests.ps1) | Select-Object Name, FullName
        $containerCollection = [System.Collections.Generic.List[psobject]]::new()

        if(-not $SkipBuiltinTests){
            $SystemTests |ForEach-Object{ $containerCollection.Add($_.FullName)}
        }

        if ($AdditionalTest) {
            $AdditionalTest | ForEach-Object { $containerCollection.Add($_) }
        }

        if($SkipBuiltinTests -and (-not $AdditionalTest)){
            throw '-SkipBuiltinTests was passed, but not additional tests. Please pass additional tests, or remove -SkipBuiltinTests'
        }
       
        $containers = $containerCollection | Foreach-object { New-PesterContainer -Path $_ -Data $data }

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