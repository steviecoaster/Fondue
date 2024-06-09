#requires -Modules ModuleBuilder
[CmdletBinding()]
param(
    # The version of the module
    [Parameter()]
    [Alias('Version')]
    [string]$SemVer = $(
        if (Get-Command gitversion -ErrorAction SilentlyContinue) {
            gitversion /showvariable SemVer
        } else {
            '0.1.0'
        }
    ),

    # Returns the built module
    [switch]$PassThru
)

Build-Module -SemVer $SemVer -Passthru:$PassThru -OutVariable build

$scriptRoot = Split-Path -parent $MyInvocation.MyCommand.Definition
$source = Join-Path $scriptRoot -ChildPath 'source'
$docs = Join-Path $scriptRoot -ChildPath 'docs'
$testPath = Join-Path $source -ChildPath 'tests'
Copy-Item $testPath -Recurse -Destination $build.ModuleBase
$moduleFolder = Join-Path $scriptRoot -ChildPath $build.Version

$psd1 = Join-Path $moduleFolder -ChildPath 'Chocolatier.psd1'

Publish-Module -Path $moduleFolder -Repository PowerShell -NuGetApiKey 605022a4-ab59-33c0-998c-7b60b5c6e801

Import-Module $psd1 -Force

New-MarkdownHelp -Module Chocolatier -OutputFolder $docs