function Invoke-PackageInternalizer {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory)]
        [String[]]
        $PackageList,

        [Parameter(Mandatory)]
        [String]
        $DestinationRepository,

        [Parameter()]
        [String]
        $ApiKey,

        [Parameter(Mandatory, ParameterSetName = 'Dependency')]
        [Switch]
        $RemoveDependency,

        [Parameter(Mandatory, ParameterSetName = 'Dependency')]
        [string[]]
        $Dependency
    )

    process {
        $temp = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).Guid
        $null = New-Item -Path $temp -ItemType Directory
        Write-Output "Created temporary directory '$temp'."
        $PackageList | ForEach-Object {
            $c = choco download $_ --no-progress --internalize --force --internalize-all-urls --append-use-original-location --output-directory=$temp --source='https://community.chocolatey.org/api/v2/'
            switch ($PSCmdlet.ParameterSetName) {
                'Dependency' {
                    $matcher = "(?<nuspec>(?<=').*(?='))"
                    if ($c[-1] -match $matcher) {
                        $nuspecFile = (Get-ChildItem $matches.nuspec -Filter *.nuspec -Recurse).FullName
                        Remove-Dependency -PackageNuspec $nuspecFile -Dependency $Dependency
                    }
                }
            }
            if ($LASTEXITCODE -eq 0) {
                (Get-Item -Path (Join-Path -Path $temp -ChildPath "*.nupkg")).fullname | ForEach-Object {
                    choco push $_ --source="$($DestinationRepository)" --api-key="$($ApiKey)" --force
                    if ($LASTEXITCODE -eq 0) {
                        Write-Verbose "Package '$_' pushed to '$($DestinationRepository)'.";
                    }
                    else {
                        Write-Verbose "Package '$_' could not be pushed to '$($DestinationRepository)'.`nThis could be because it already exists in the repository at a higher version and can be mostly ignored. Check error logs."
                    }
                }
            }
            else {
                Write-Output "Failed to download package '$_'"
            }

            # Clean up, ready for next execution
            Remove-Item -Path (Join-Path -Path $temp -ChildPath "*.nupkg") -Force
        }

        Remove-Item -Path $temp -Force -Recurse
    }
}