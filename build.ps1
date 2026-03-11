#requires -Modules ModuleBuilder
[CmdletBinding()]
param(
    # The version of the module
    [Parameter()]
    [Alias('Version')]
    [String]$SemVer = $(
        if (Get-Command gitversion -ErrorAction SilentlyContinue) {
            gitversion /showvariable SemVer
        }
        else {
            '0.1.0'
        }
    ),

    [Parameter()]
    [Switch]
    $Build,

    [Parameter()]
    [Switch]
    $Test,

    [Parameter()]
    [Switch]
    $Publish,

    [Parameter()]
    [Switch]
    $Document,

    [Parameter()]
    [Switch]
    $LoadModule
)

end {
    $scriptRoot = Split-Path -parent $MyInvocation.MyCommand.Definition
    $source = Join-Path $scriptRoot -ChildPath 'source'
    $docs = Join-Path $scriptRoot -ChildPath 'docs'
    $testPath = Join-Path $source -ChildPath 'module_tests'

    if ($Build) { 
        $module = Build-Module -SemVer $SemVer -Passthru
        Copy-Item $testPath -Recurse -Destination $module.ModuleBase -Force

        $templatePath = Join-Path $source -ChildPath 'template'
        Copy-Item $templatePath -Recurse -Destination $module.ModuleBase -Force
    }

    if ($Test) {
        $psd1 = Join-Path $module.ModuleBase -ChildPath 'Fondue.psd1'
        Import-Module $psd1 -Force
        & (Join-Path $scriptRoot harness.ps1) -Module Fondue

    }
    
   if ($Publish) {
        Publish-PSResource -ApiKey $env:PSGALLERY_KEY -Repository PSGallery -Path $module.ModuleBase
   }

    if ($Document) {
        New-ModuleHelp -ModuleName Fondue -OutputFolder $docs -ErrorAction SilentlyContinue

        $fondueDoc  = Join-Path $docs 'markdown\Fondue\Fondue.md'
        $indexDoc   = Join-Path $docs 'markdown\Fondue\index.md'

        if (Test-Path $fondueDoc) {
            Move-Item -Path $fondueDoc -Destination $indexDoc -Force
        }

        # Remove the auto-generated ## Fondue command listing — nav in mkdocs.yml handles it
        $content = Get-Content $indexDoc -Raw
        $content = $content -replace '(?s)\r?\n## Fondue\r?\n.+', ''
        Set-Content -Path $indexDoc -Value $content.TrimEnd()
    }

     if ($LoadModule) {
        $psd1 = Join-Path $module.ModuleBase -ChildPath 'Fondue.psd1'
        Import-Module $psd1 -Force
    }
}