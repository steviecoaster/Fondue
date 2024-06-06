function Update-Metadata {
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Metadata,

        [Parameter(Mandatory)]
        [ValidateScript({Test-Path $_})]
        [String]
        $NuspecFile
    )

    process {
        Write-metadata -MetaData $Metadata -Nuspecfile $NuspecFile
    }
}