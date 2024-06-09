# Chocolatier - A Chocolatey Package Authoring module

Chocolatier aims to reduce the friction in creating Chocolatey packages. It accomplishes this by providing you with a set of PowerShell commands that make various aspects of package authoring simpler. In the navigation menu on the left you will find the documentation for each of the commands available as part of the Chocolatier module.

You can get to the individual documentation page for each function simply by running `Get-Help <FunctionName> -Online` in your PowerShell terminal of choice. Looking to easily get to this page? Run `Open-ChocolatierHelp`!


## Raising Issues

Thank you so much for trying this module! I'm sorry if something you tried didn't work quite right. Please let me know about it by filing an [issue](https://github.com/steviecoaster/Chocolatier/issues) on the Chocolatier repository and I'll look into it!

## Contributing

Have something that you find useful and think would make a great addition to this module? I welcome your contribution! Start with an [issue](https://github.com/steviecoaster/Chocolatier/issues) and then you can work up a Pull Request!

When raising a Pull Request, any commits made to your source branch should include the issue number your Pull Request is in reference too in the fist line of the commit message. Remember, commit messages are developer-facing documentation, and good commit messages help ease the maintenance burden of a code base.

A good example commit message:

```text
(#123) Fix bug where using [Semver] fails on Windows

Prior to this change, when using this tool on a Windows platform users
would encounter a problem where they could not use the -Version parameter
as it uses a [Semver] dotnet type that does not exist in PowerShell versions
less than 7.0.

This change changes the validation method of the -Version parameter to use
a regex match for proper semver strings, ensuring cross platform compatibility.
```

When raising your Pull Request the last line should include [linking keywords](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/using-keywords-in-issues-and-pull-requests#linking-a-pull-request-to-an-issue) referencing the issue number it resolves.