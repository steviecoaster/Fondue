function New-Package {
    <#
    .SYNOPSIS
    Generates a new Chocolatey Package
    
    .DESCRIPTION
    Generates a Chocolatey Package. Can be used to generate from an installer (licensed versions only), meta (virtual) packages, or FOSS style packages
    
    .PARAMETER Name
    The name (Id) to give to the package
    
    .PARAMETER IsMetapackage
    Instructs Chocolatey to create a MetaPackage
    
    .PARAMETER File
    An installer to package. Should be of type exe, msi, msu, or zip
    
    .PARAMETER Url
    The url of an installer to package. Installer will be downloaded and embedded into package. Supports same extensions as -File parameter.
    
    .PARAMETER Dependency
    Dependencies to inject into the package. Required when using -IsMetaPackage.
    
    .PARAMETER Metadata
    A hashtable of MetaData to include in the Nuspec File
    
    .PARAMETER OutputDirectory
    This is where the Chocolatey packaging will be generated. Defaults to the current working directory.
    
    .PARAMETER Recompile
    When used runs the pack command against the nuspec file
    
    .EXAMPLE

    Creating a basic package with a name:

    $params = @{
        Name = "MyPackage"
    }
    New-Package @params

    .EXAMPLE

    Create a package from an installer file

    New-Package -Name "MyInstallerPackage" -File "C:\path\to\installer.exe"
    
    .EXAMPLE

    Create a package from an installer URL

    New-Package -Name "MyUrlPackage" -Url "http://example.com/installer.exe"

    .EXAMPLE

    Create a package with metadata

    New-Package -Name "MyPackageWithMetadata" -Metadata @{Author="Me"; Version="1.0.0"}

    .EXAMPLE

    Create a package in a specific output directory

    New-Package -Name "MyPackage" -OutputDirectory "C:\path\to\output\directory"

    .NOTES
    
    .LINK
    https://docs.chocolatey.org/en-us/guides/create/
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default', HelpUri = 'https://chocolatey-solutions.github.io/Fondue/New-Package')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [String]
        $Name,

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
        [Hashtable[]]
        $Dependency,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'File')]
        [Parameter(ParameterSetName = 'Url')]
        [Hashtable]
        $Metadata,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'File')]
        [Parameter(ParameterSetName = 'Url')]
        [String]
        $OutputDirectory = $PWD,

        [Parameter(ParameterSetName = 'FIle')]
        [Parameter(ParameterSetName = 'Url')]
        [Switch]
        $Recompile
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'File' {

                $licenseValid = Assert-LicenseValid
                $extensionInstalled = Test-Path "$env:ChocolateyInstall\lib\chocolatey.extension"

                if (-not $licenseValid) {
                    throw 'A valid Chocolatey license is required to use -File but was not found on this system.'
                }

                if (-not $extensionInstalled) {
                    throw 'A valid license file was found, but the Chocolatey Licensed Extension is not installed. The Chocolatey Licensed Extension is required to use -File.'
                }

                $chocoArgs = @('new', "--file='$file'", "--output-directory='$OutputDirectory'", '--build-package')
                $i = 4
            }
            'Url' {

                $licenseValid = Assert-LicenseValid
                $extensionInstalled = Test-Path "$env:ChocolateyInstall\lib\chocolatey.extension"

                if (-not $licenseValid) {
                    throw 'A valid Chocolatey license is required to use -Url but was not found on this system.'
                }

                if (-not $extensionInstalled) {
                    throw 'A valid license file was found, but the Chocolatey Licensed Extension is not installed. The Chocolatey Licensed Extension is required to use -Url.'
                }

                $chocoArgs = @('new', "--url='$url'", "--output-directory='$OutputDirectory'", '--build-package', '--no-progress')
                $i = 7
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
            'Adding dependencies to package {0}, if any' -f $matches.nuspec
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

        if ($Metadata) {
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