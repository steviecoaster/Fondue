function Assert-LicenseValid {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $LicenseFile = "$env:ChocolateyInstall\license\chocolatey.license.xml"
    )

    end {

        $licenseFound = Test-Path $LicenseFile

        $xmlDoc = [System.Xml.XmlDocument]::new()
        $xmlDoc.Load($LicenseFile)

        $licenseNode = $xmlDoc.SelectSingleNode('/license')
        $expirationDate = [datetime]::Parse($licenseNode.Attributes["expiration"].Value)
        $LicenseExpired = $expirationDate -lt (Get-Date)

        if($licenseFound -and (-not $LicenseExpired)){
            return $true
        } else {
            return $false
        }

    }
}