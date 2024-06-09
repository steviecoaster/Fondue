#requires -Modules ModuleBuilder
[CmdletBinding()]
param(
    # The version of the module
    [Parameter()]
    [Alias('Version')]
    [string]$SemVer = $(
        if (Get-Command gitversion -ErrorAction SilentlyContinue) {
            gitversion /showvariable SemVer
        }
        else {
            '0.1.0'
        }
    ),

    # Returns the built module
    [switch]$PassThru,

    [Parameter()]
    [switch]
    $Build,

    [Parameter()]
    [switch]
    $RunTest,

    [Parameter()]
    [switch]
    $WriteDocs,

    [Parameter()]
    [switch]
    $PublishModule
)


$scriptRoot = Split-Path -parent $MyInvocation.MyCommand.Definition
$source = Join-Path $scriptRoot -ChildPath 'source'
$tests = Join-Path $scriptRoot -ChildPath 'tests'
$docs = Join-Path $scriptRoot -ChildPath 'docs'

$moduleFolder = Join-Path $scriptRoot -ChildPath $build.Version
$psd1 = Join-Path $moduleFolder -ChildPath 'Chocolatier.psd1'

#Copy the tests that ship with the module to the module folder
$moduletestPath = Join-Path $source -ChildPath 'module_tests'
Copy-Item $moduletestPath -Recurse -Destination $build.ModuleBase

if ($PublishModule) {
    Publish-Module -Path $moduleFolder -Repository PowerShell -NuGetApiKey 605022a4-ab59-33c0-998c-7b60b5c6e801
}

switch ($true) {

    $Build {
        Build-Module -SemVer $SemVer -Passthru:$PassThru -OutVariable build
        Import-Module $psd1 -Force
    }
    $RunTest {

            $Containers = (Get-Childitem $tests -Filter *.tests.ps1).FullName | Foreach-object { New-PesterContainer -Path $_ -Data $data }

            $Configuration = [PesterConfiguration]@{
                Run        = @{
                    Container = $Containers
                    Passthru  = $true
                }
                Output     = @{
                    Verbosity = 'Detailed'
                }
                TestResult   = @{
                    Enabled      = $true
                    OutputPath   = "$root\TestResults.xml"
                    OutputFormat = "JUnitXml"
    
            }
        
            $results = Invoke-Pester -Configuration $Configuration


        }
    
        if (Test-Path $TestConfiguration.Run.Path.Value) {
            Invoke-Pester -Configuration $Configuration
        }
    }

    $WriteDocs {
        New-MarkdownHelp -Module Chocolatier -OutputFolder $docs
    }
}


