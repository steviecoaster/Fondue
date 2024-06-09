function Open-ChocolatierHelp {
    <#
    .SYNOPSIS
    Opens the documentation for the Chocolatier PowerShell module
    #>
    [CmdletBinding()]
    Param()

    end {
        Start-Process https://steviecoaster.dev
    }
}