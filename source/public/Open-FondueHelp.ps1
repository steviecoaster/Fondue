function Open-FondueHelp {
    <#
    .SYNOPSIS
    
    Opens the documentation for the Fondue PowerShell module
    #>
    [CmdletBinding(HelpUri = 'https://steviecoaster.github.io/Fondue/Open-FondueHelp')]
    Param()

    end {
        Start-Process https://steviecoaster.github.io/Fondue/
    }
}