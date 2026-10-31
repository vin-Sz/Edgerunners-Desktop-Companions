# Swaps Capri's art, voice and icon for a character's own, file by file, when building with -Character (see characters/lucy/NOTES.md).
# Each file in characters/<name>/sprites or voice with the same name as one in assets/ is used instead of Capri's, and
# characters/<name>/icon.ico replaces her chip icon, so drawings go in one at a time as they're finished.
# Her name goes in the same way: characters/<name>/names.txt lists Capri's words and hers, changed in a copy of the code.
# ci/build-windows.ps1 dot-sources this, so it changes that script's $shared, $resources, $icon and $sources.
param([Parameter(Mandatory = $true)][string]$Character)

$characterRoot = Join-Path $root ('characters\' + $Character)
if (-not (Test-Path -LiteralPath $characterRoot)) { throw "No character called $Character in characters/." }

# A PNG's width and height, from its header.
function Get-PngSize([string]$path) {
    $stream = [IO.File]::OpenRead($path)
    try {
        $header = New-Object byte[] 24
        if ($stream.Read($header, 0, 24) -ne 24) { throw "$path is too short to be a PNG." }
        $number = { param($at) ([int]$header[$at] -shl 24) -bor ([int]$header[$at + 1] -shl 16) -bor ([int]$header[$at + 2] -shl 8) -bor [int]$header[$at + 3] }
        return @((& $number 16), (& $number 20))
    } finally { $stream.Dispose() }
}

$swapped = New-Object System.Collections.Generic.List[string]
$swap = {
    param([string]$argument)
    $resource = [regex]::Match($argument, '^/resource:(.+),Capri\.(Sprite|Voice)\.(.+)$')
    if (-not $resource.Success) { return $argument }
    $folder = if ($resource.Groups[2].Value -eq 'Sprite') { 'sprites' } else { 'voice' }
    $own = Join-Path $characterRoot ($folder + '\' + $resource.Groups[3].Value)
    if (-not (Test-Path -LiteralPath $own)) { return $argument }
    if ($folder -eq 'sprites') {
        # Her frame counts and sizes are set in the code, so a sheet of another size would cut her frames wrong.
        $capri = Get-PngSize $resource.Groups[1].Value
        $theirs = Get-PngSize $own
        if ($capri[0] -ne $theirs[0] -or $capri[1] -ne $theirs[1]) { throw ("$own is $($theirs[0])x$($theirs[1]) px, but Capri's is $($capri[0])x$($capri[1]). See characters/$Character/ART.md.") }
    }
    $swapped.Add($folder + '/' + $resource.Groups[3].Value)
    return '/resource:' + $own + ',Capri.' + $resource.Groups[2].Value + '.' + $resource.Groups[3].Value
}
$resources = @($resources | ForEach-Object { & $swap $_ })

$ownIcon = Join-Path $characterRoot 'icon.ico'
if (Test-Path -LiteralPath $ownIcon) {
    $shared = @($shared | ForEach-Object { if ($_ -eq ('/win32icon:' + $icon)) { '/win32icon:' + $ownIcon } else { $_ } })
    $resources = @($resources | ForEach-Object { if ($_ -eq ('/resource:' + $icon + ',Capri.Chip.ico')) { '/resource:' + $ownIcon + ',Capri.Chip.ico' } else { $_ } })
    $icon = $ownIcon
    $swapped.Add('icon.ico')
}
$names = Join-Path $characterRoot 'names.txt'
if (Test-Path -LiteralPath $names) {
    $rules = @(Get-Content -LiteralPath $names -Encoding UTF8 | ForEach-Object { [regex]::Match($_, '^"(.+)"\s*=>\s*"(.*)"\s*$') } | Where-Object { $_.Success })
    $staged = Join-Path $out ('character-' + $Character)
    New-Item -ItemType Directory -Path $staged -Force | Out-Null
    $found = @{}
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    $sources = @($sources | ForEach-Object {
        $code = [IO.File]::ReadAllText($_, $utf8)
        foreach ($rule in $rules) {
            $was = $rule.Groups[1].Value
            $count = ([regex]::Matches($code, [regex]::Escape($was))).Count
            if ($count -gt 0) { $code = $code.Replace($was, $rule.Groups[2].Value); $found[$was] = $found[$was] + $count }
        }
        $copy = Join-Path $staged (Split-Path -Leaf $_)
        [IO.File]::WriteAllText($copy, $code, $utf8)
        $copy
    })
    foreach ($rule in $rules) { if (-not $found.ContainsKey($rule.Groups[1].Value)) { Write-Warning ("names.txt: `"" + $rule.Groups[1].Value + "`" isn't in the code any more. Check what Capri says now and update the line.") } }
    $swapped.Add('name in ' + ($found.Values | Measure-Object -Sum).Sum + ' places')
}
Write-Output ("Building as $Character" + $(if ($swapped.Count -eq 0) { ": nothing of hers yet, so all of Capri's art, voice and icon" } else { " with her own " + ($swapped -join ', ') }))
