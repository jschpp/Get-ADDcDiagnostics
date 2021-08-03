BeforeAll {
    $tmp = New-Item -ItemType File -Path "TestDrive:\HandlerMock.ps1"
    "function HandlerMock{`n" | Out-File -FilePath $tmp -Encoding utf8
    Get-Content $PSScriptRoot/../dcdiaghandler.ps1 -Raw | Out-File -FilePath $tmp -Encoding utf8 -Append
    "`n}" | Out-File -FilePath $tmp -Encoding utf8 -Append
    . $tmp
}

Describe "dcdiag Handler" {
    It "should exist" {
        $Function:HandlerMock | Should -Not -BeNullOrEmpty
    }

    It "should correctly parse passed Tests" {
        $res = HandlerMock "......................... DC7 hat den Test Connectivity bestanden."
        $res | Should -Not -BeNullOrEmpty
        $res.Test | Should -Not -BeNullOrEmpty
        $res.Test | Should -BeExactly "Connectivity"
        $res.Passed | Should -Not -BeNullOrEmpty
        $res.Passed | Should -BeTrue
        $res.Name | Should -Not -BeNullOrEmpty
        $res.Name | Should -BeExactly "DC7"
    }

    It "should correctly parse failed Tests" {
        $txt = Get-Content "$PSScriptRoot/data/failed.txt"
        $res = HandlerMock $txt
        $res | Should -Not -BeNullOrEmpty
        $res.Test | Should -Not -BeNullOrEmpty
        $res.Test | Should -BeExactly "DFSREvent"
        $res.Passed | Should -Not -BeNullOrEmpty
        $res.Passed | Should -BeFalse
        $res.Name | Should -Not -BeNullOrEmpty
        $res.Name | Should -BeExactly "DC7"
    }
}

Describe "json file" {
    It "Should pass the schema test" {
        $content = Get-Content "$PSScriptRoot/../Get-ADDcDiagnostics.json" -Raw -Encoding utf8
        Test-Json $content | Should -BeTrue
    }
}