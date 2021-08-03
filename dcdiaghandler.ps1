param (
    $lines = (Get-Content .\dcdiag.txt)
)
$regex = [regex]::new('[\s\.]+ (?<Good>(?<NameGood>[a-zA-Z0-9\._\-]+) hat den Test (?<TestGood>[a-zA-Z0-9\._\-]+) bestanden)|(?<Bad>Der Test (?<TestBad>[a-zA-Z0-9\._\-]+) für (?<NameBad>[a-zA-Z0-9\._\-]+) ist)')
$idx = 0
foreach ($line in $lines ) {
    $match = $regex.Match($line)
    if ($match.Success) {
        $Suffix = if ($match.Groups['Bad'].Value) {'Bad'} else {'Good'}
        $Passed = $Suffix -ne 'Bad'
        $result = [PSCustomObject]@{
            Passed = $Suffix -ne 'Bad'
            Name   = $match.Groups['Name'+$Suffix]
            Test   = $match.Groups['Test'+$Suffix]
        }
        if (-not $Passed) {
            $result | Add-Member -MemberType NoteProperty -Name 'Error' -Value $lines[$idx-2].Trim()
        }
        $result
    }
    $idx++
}