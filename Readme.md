# Get-ADDcDiagnostics

This repository will be used to get dcdiag playing nicely with powershell.

---

## Warning

This This repository is using the german version of `dcdiag.exe`

---

The state of this repository can be considered experimental at best... Soo take
everything in here with a healthy grain of caution!!

## Components

This repository consists mainly out of the following files:

* `dcdiaghandler.ps1` - A 'function' to handle the output of dcdiag
* `Get-ADDcDiagnostics.json` - The Crescendo json file without the function handler
* `build.ps1` - A build script which will take the above to files merge them into one and then generate the Crescendo module
