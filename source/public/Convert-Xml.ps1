Function Convert-Xml {
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