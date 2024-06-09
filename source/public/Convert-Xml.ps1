Function Convert-Xml {
    <#
    .SYNOPSIS
    Converts XML from a URL or a file to a hash table.

    .DESCRIPTION
    The Convert-Xml function takes a URL or a file path as input and converts the XML content to a hash table. 
    If a URL is provided, the function downloads the XML content from the URL. 
    If a file path is provided, the function reads the XML content from the file. 
    The function then converts the XML content to a hash table and returns it.

    .PARAMETER Url
    The URL of the XML content to convert. If this parameter is provided, the function will download the XML content from the URL.

    .PARAMETER File
    The file path of the XML content to convert. If this parameter is provided, the function will read the XML content from the file.

    .EXAMPLE
    Convert-Xml -Url "http://example.com/data.xml"

    This example downloads the XML content from the specified URL and converts it to a hash table.

    .EXAMPLE
    Convert-Xml -File "C:\path\to\data.xml"

    This example reads the XML content from the specified file and converts it to a hash table.

    .NOTES
    The function does not support XML content that contains dependencies or comments.
    #>
    [cmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $Url,

        [Parameter()]
        [String]
        $File
    )

    process {    
        if ($url) {
            [xml]$xml = [System.Net.WebClient]::new().DownloadString($url)
        }

        if ($File) {
            [xml]$xml = Get-Content $File
        }

        $hash = @{}

        foreach ($node in ($xml.package.metadata.ChildNodes | Where-Object {$_.Name -notmatch 'dependencies|#comment'})) {
            $hash.Add($node.Name, $node.'#text')
        }

        return $hash
    }
}