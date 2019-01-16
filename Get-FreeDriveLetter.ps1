function Get-FreeDriveLetter {
    $regex = "[A-Z]:"
    $netuseOutput = net use
    $driveArray = @()
    $providers = Get-PSDrive -PSProvider FileSystem
    $psdriveDriveLetters = $providers.Name
    $driveArray += $psdriveDriveLetters

    # Don't append to $driveArray if there's no mapped drives found via net use
    if ($netuseOutput.Length -gt 4) {
        $netuseDriveLetters = ($netuseOutput | Select-String -Pattern $regex).Matches.Value
        $netuseDriveLetters = $netuseDriveLetters -replace ':', ""
        $driveArray += $netuseDriveLetters    
    }
    $badLetters = ($driveArray) | Select-Object -Unique
    $exclude = foreach ($badLetter in $badLetters) {
        [byte][char]$badLetter
    }
    $range = 65..90
    $Random = $range | Where-Object {$exclude -notcontains $_}
    $driveLetter = [char](Get-Random -InputObject $Random)
    Return $driveLetter
}