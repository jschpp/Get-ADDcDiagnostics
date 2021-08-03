#Requires -Module Microsoft.PowerShell.Crescendo

$buildPath = ".\out"
if (Test-Path $buildPath) {
    Remove-Item -Recurse $buildPath
}
$buildPath = New-Item -ItemType Directory -Path $buildPath
$tmpJson = Join-Path -Path $buildPath -ChildPath "finished.json"
Copy-Item .\Microsoft.PowerShell.Crescendo.Schema.json -Destination $buildPath

$handler = Get-Content '.\dcdiaghandler.ps1'
$code = ""
foreach ($line in $handler) {
    $trimmed = $line.trim()
    if ($trimmed[-1] -in @("(", "{")) {
        $code += $trimmed
    } else {
        $code += $trimmed + ";" 
    }
}
$code = $code -replace "{;" ,"{" -replace "\(;","(" -replace ";\)",")" -replace ";}","}" -replace "\\","\\"

$json = (Get-Content .\Get-ADDcDiagnostics.json -Raw -Encoding utf8) -replace "__REPLACE_ME__", $code
$json | Out-File -Encoding utf8 -FilePath $tmpJson

Export-CrescendoModule -ConfigurationFile $tmpJson -ModuleName "$buildPath\Get-ADDcDiagnostics"