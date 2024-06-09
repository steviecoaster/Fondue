function New-ConfigurationPackage {
    <#
    .SYNOPSIS
    Generate a package that configures Windows
    
    .DESCRIPTION
    This package can manipulate Registry Keys, Files, Environment Variables, or Firewall Rules
    
    .PARAMETER Name
    The name of the package
    
    .PARAMETER RegistryKey
    #This hashtable will be splatted to New-ItemProperty. Run 'Get-Help New-ItemPropery -Parameter *' for a list of options
    
    .PARAMETER ConfigFile
    This hashtable should include the file you wish to include, and its destination path on the target filesystem
    
    .PARAMETER FirewallRule
    This hashtable will be splatted to New-NetFirewallRule. Run 'Get-Help New-NetFirewallRule -Parameter *' for a list of options
    
    .PARAMETER EnvironmentVariable
    The hashtable must contain Name,Value, and Scope keys. Scope may be one of: Machine,User,or Process. Names and values must be under 32,767 characters.
    
    .PARAMETER OutputDirectory
    Directory to store the compiled package. Default to $PWD
    
    .EXAMPLE
    New-ConfigurationPackage -Name registry-config -RegistryKey $r =
    
    .EXAMPLE
    New-ConfigurationPackage -Name sys-config -RegistryKey $r -ConfigFile $c -FirewallRule $f -EnvironmentVariable $e
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateScript({ ($_).EndsWith('-config')})]
        [String]
        $Name,

        
        [Parameter()]
        [Hashtable[]]
        $RegistryKey,

        #
        [Parameter()]
        [Hashtable[]]
        $ConfigFile,

        #
        [Parameter()]
        [Hashtable[]]
        $FirewallRule,

        #T 
        [Parameter()]
        [Hashtable[]]
        $EnvironmentVariable,

        [Parameter()]
        [String]
        $OutputDirectory = $PWD
    )
    begin {
        if ($null -eq $PSBoundParameters) {
            throw 'At least one of the following is required: RegistryKey,ConfigFile,FirewallRule,EnvironmentVariable'
        }
    }
    process {

        #Build the package and get the tools dir so we can play with it
        $chocoArgs = @('new', "$Name", "--output-directory='$OutputDirectory'", "--template='configuration'")
        $i = 6
        $choco = & choco @chocoArgs
        $matcher = "(?<toolsdir>(?<=').*(?='))"
        $null = $choco[$i] -match $matcher
        $toolsdir = Split-Path -Parent $matches.toolsdir

        if ($FirewallRule) {
            $fwconfiguration = [System.Collections.Generic.List[String]]::new()
            $fwscript = Join-Path $toolsdir -ChildPath 'firewall.ps1'
            $null = New-Item $fwscript -ItemType File

            Foreach ($rule in $FirewallRule) {
                $strings = @()
                $rule.GetEnumerator() | ForEach-Object { $strings += '{0} = "{1}"' -f $_.Key, $_.Value }
                $hash = @"
@{
    $($strings -join [System.Environment]::NewLine)
}
"@
                    
                $sb = @'
$rule = {0}
                    
New-NetFirewallRule @rule
'@ -f $hash
                $fwconfiguration.Add($sb)                    
            }
                
            foreach ($fwrule in $fwconfiguration) {
                #create the script
                $fwrule | Add-Content $fwscript
            }
        }#firewall

        if ($RegistryKey) {
            $registryconfiguration = [System.Collections.Generic.list[string]]::new()
            $regscript = Join-Path $toolsdir -ChildPath 'registry.ps1'
            $null = New-Item $regscript -ItemType File

            foreach ($Regkey in $RegistryKey) {
                $strings = @()
                $Regkey.GetEnumerator() | ForEach-Object { $strings += '{0} = "{1}"' -f $_.Key, $_.Value }
                $hash = @"
@{
    $($strings -join [System.Environment]::NewLine)
}
"@

                $sb = @'

$key = {0}

New-ItemProperty @key
'@ -f $hash.TrimEnd().TrimStart().Trim()
                $registryconfiguration.Add($sb)
            }


            foreach ($rk in $registryconfiguration) {
                $rk | Add-Content $regscript
            }
        }#registry

        if ($ConfigFile) {
            $copyconfiguration = [System.Collections.Generic.list[string]]::new()
            $configscript = Join-Path $toolsdir -ChildPath 'config.ps1'
            $null = New-Item $configscript -ItemType File

            $sb = @'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
'@

            $copyconfiguration.Add($sb)

            foreach ($config in $ConfigFile) {
                Copy-Item $config.File -Destination $toolsdir
                #We need the filename
                $cf = Split-Path $config.File -Leaf

                $sb = @'
$file = Join-Path $toolsDir -Childpath "{0}"
Write-host "Copying configuration"
Copy-Item $file -Destination "{1}"
'@ -f $cf, $Config.Destination
                $copyconfiguration.Add($sb)
            }


            foreach ($c in $copyconfiguration) {
                $c | Add-Content $configscript
            }
        }#config

        if ($EnvironmentVariable) {
            $envconfiguration = [System.Collections.Generic.list[string]]::new()
            $envscript = Join-Path $toolsdir -ChildPath 'environment.ps1'
            $null = New-Item $envscript -ItemType File
    
            foreach ($ev in $EnvironmentVariable) {
               
    
                $sb = @'
Write-Host "Setting environment variable: {3}"
[Environment]::SetEnvironmentVariable("{0}","{1}","{2}")

'@ -f $ev.Name, $ev.Value, $ev.Scope, $ev.Name
    
                if ($sb -notin $envconfiguration) {
                    $envconfiguration.Add($sb)
                }
    
               
            }
            foreach ($ec in $envconfiguration) {
                $ec | Add-Content $envscript
            }
        }#environment
    }#process
}