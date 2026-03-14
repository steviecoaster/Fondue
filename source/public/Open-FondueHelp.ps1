function Open-FondueHelp {
    <#
    .SYNOPSIS
    
    Opens the documentation for the Fondue PowerShell module
    #>
    [CmdletBinding(HelpUri = 'https://chocolatey-solutions.github.io/Fondue/Open-FondueHelp')]
    Param()

    end {
        Start-Process https://chocolatey-solutions.github.io/Fondue/
    }
}