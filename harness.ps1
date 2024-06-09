[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [String]
    $Module
)

end {
    $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $tests = Join-Path $scriptRoot -ChildPath 'tests'

    $Data = @{ Module = $Module }
    $containers = (Get-ChildItem $tests -Recurse -Filter '*.tests.ps1').FullName | Foreach-object { New-PesterContainer -Path $_ -Data $Data }

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