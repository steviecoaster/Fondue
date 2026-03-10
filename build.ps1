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

$build = Build-Module -SemVer $SemVer -Passthru
if ($PassThru) { $build }

$scriptRoot = Split-Path -parent $MyInvocation.MyCommand.Definition
$source = Join-Path $scriptRoot -ChildPath 'source'
$docs = Join-Path $scriptRoot -ChildPath 'docs'
$testPath = Join-Path $source -ChildPath 'module_tests'
Copy-Item $testPath -Recurse -Destination $build.ModuleBase -Force

$psd1 = Join-Path $build.ModuleBase -ChildPath 'Fondue.psd1'

Import-Module $psd1 -Force

New-MarkdownHelp -Module Fondue -OutputFolder $docs