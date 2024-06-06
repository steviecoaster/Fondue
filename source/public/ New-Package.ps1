function New-Package {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Parameter(Mandatory, ParameterSetName = 'Metapackage')]
        [String]
        $Name,

        [Parameter(ParameterSetName = 'Metapackage')]
        [Switch]
        $IsMetapackage,

        [Parameter(Mandatory, ParameterSetName = 'File')]
        [ValidateScript({ Test-Path $_ })]
        [String]
        $File,

        [Parameter(Mandatory, ParameterSetName = 'Url')]
        [String]
        $Url,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'File')]
        [Parameter(ParameterSetName = 'Url')]
        [Parameter(Mandatory, ParameterSetName = 'Metapackage')]
        [Hashtable[]]
        $Dependency,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'File')]
        [Parameter(ParameterSetName = 'Url')]
        [Parameter(ParameterSetName = 'Metapackage')]
        [Hashtable]
        $Metadata,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'File')]
        [Parameter(ParameterSetName = 'Url')]
        [Parameter(ParameterSetName = 'Metapackage')]
        [String]
        $OutputDirectory = $PWD,

        [Parameter(ParameterSetName = 'FIle')]
        [Parameter(ParameterSetName = 'Url')]
        [Parameter(ParameterSetName = 'MetaPackage')]
        [Switch]
        $Recompile
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'File' {
                $chocoArgs = @('new', "--file='$file'", "--output-directory='$OutputDirectory'", '--build-package')
                $i = 4
            }
            'Url' {
                $chocoArgs = @('new', "--url='$url'", "--output-directory='$OutputDirectory'", '--build-package', '--no-progress')
                $i = 7
            }

            'Metapackage' {
                $chocoArgs = @('new', "$Name", "--output-directory='$OutputDirectory'", "--template='metapackage'")
                $i = 4
            }

            default {
                $chocoArgs = @('new', "$Name", "--output-directory='$OutputDirectory'")
                $i = 3
            }
        }

        $matcher = "(?<nuspec>(?<=').*(?='))"

        $choco = & choco @chocoArgs
        Write-Verbose -Message $('Matching against {0}' -f $choco[$i])
        $null = $choco[$i] -match $matcher

        if ($matches.nuspec) {
            if ($IsMetapackage) {
                'Adding dependencies to package {0}' -f $Name
            }
            else {
                'Adding dependencies to package {0}, if any' -f $matches.nuspec
            }
        }
        else {
            throw 'Something went wrong, check the chocolatey.log file for details!'
        }

        if ($Dependency) {
            $newDependencySplat = @{
                Nuspec          = $matches.nuspec
                Dependency      = $Dependency
                OutputDirectory = $OutputDirectory
            }

            New-Dependency @newDependencySplat
        }

        if($Metadata){
            Write-Metadata -Metadata $Metadata -NuspecFile $matches.nuspec
        }
        
        if ($Recompile) {
            $chocoArgs = ('pack', $matches.nuspec, $OutputDirectory)
            $choco = (Get-Command choco).Source
            $null = & $choco @chocoArgs

            if ($LASTEXITCODE -eq 0) {
                'Package is ready and available at {0}' -f $OutputDirectory
            }
            else {
                throw 'Recompile had an error, see chocolatey.log for details'
            }

        }
    }
}