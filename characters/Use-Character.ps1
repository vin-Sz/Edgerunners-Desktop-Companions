# Swaps Capri's art, voice and icon for a character's own, file by file, when building with -Character (see characters/lucy/NOTES.md).
# Each file in characters/<name>/sprites or voice with the same name as one in assets/ is used instead of Capri's, and
# characters/<name>/icon.ico replaces her chip icon, so drawings go in one at a time as they're finished.
# Her name goes in the same way: characters/<name>/names.txt lists Capri's words and hers, changed in a copy of the code,
# along with the app's own identity from characters/app.txt (Edgerunners Desktop: its settings folder, updates and installer).
# Her own lines go in from characters/<name>/Character.cs, in place of app/Character.cs.
# ci/build-windows.ps1 dot-sources this, so it changes that script's $shared, $resources, $icon, $sources and $root.
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
# The app's identity (characters/app.txt) and her name (characters/<name>/names.txt) go into a copy of app\, which both the
# app and the installer are built from. The installer's line in ci/build-windows.ps1 reads app\ and assets\chip.png from
# $root, so $root becomes the copy's folder once the rest of the build has what it needs from the real one.
$rules = New-Object System.Collections.Generic.List[object]
foreach ($list in @((Join-Path $root 'characters\app.txt'), (Join-Path $characterRoot 'names.txt'))) {
    if (-not (Test-Path -LiteralPath $list)) { continue }
    foreach ($line in Get-Content -LiteralPath $list -Encoding UTF8) {
        $rule = [regex]::Match($line, '^"(.+)"\s*=>\s*"(.*)"\s*$')
        if ($rule.Success) { $rules.Add(@((Split-Path -Leaf $list), $rule.Groups[1].Value, $rule.Groups[2].Value)) }
    }
}
$version = $env:CHARACTER_VERSION
if ($version -and $version -notmatch '^\d+\.\d+\.\d+\.\d+$') { throw "CHARACTER_VERSION is $version, but it needs four numbers, like 0.7.7.1." }
$staged = Join-Path $out ('character-' + $Character)
New-Item -ItemType Directory -Path (Join-Path $staged 'app'), (Join-Path $staged 'assets') -Force | Out-Null
$found = @{}
$utf8 = New-Object System.Text.UTF8Encoding($false)
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $root 'app') -Filter *.cs) {
    # A character's own lines (characters/<name>/Character.cs) take the place of app/Character.cs.
    $ownLines = Join-Path $characterRoot 'Character.cs'
    $code = [IO.File]::ReadAllText($(if ($file.Name -eq 'Character.cs' -and (Test-Path -LiteralPath $ownLines)) { $ownLines } else { $file.FullName }), $utf8)
    foreach ($rule in $rules) {
        $count = ([regex]::Matches($code, [regex]::Escape($rule[1]))).Count
        if ($count -gt 0) { $code = $code.Replace($rule[1], $rule[2]); $found[$rule[1]] = $found[$rule[1]] + $count }
    }
    # A release's own number (GitHub's release workflow sets it), so the updater knows which release is installed.
    if ($version -and $file.Name -eq 'AssemblyInfo.cs') { $code = [regex]::Replace($code, '(Assembly(?:File)?Version\(")[^"]*', '${1}' + $version) }
    [IO.File]::WriteAllText((Join-Path $staged ('app\' + $file.Name)), $code, $utf8)
}
foreach ($rule in $rules) { if (-not $found.ContainsKey($rule[1])) { Write-Warning ($rule[0] + ": `"" + $rule[1] + "`" isn't in the code any more. Check what Capri's code says now and update the line.") } }
$sources = @($sources | ForEach-Object { Join-Path $staged ('app\' + (Split-Path -Leaf $_)) })
$ownPicture = Join-Path $characterRoot 'icon.png'
Copy-Item -LiteralPath $(if (Test-Path -LiteralPath $ownPicture) { $ownPicture } else { Join-Path $root 'assets\chip.png' }) -Destination (Join-Path $staged 'assets\chip.png') -Force
$root = $staged
$swapped.Add('names in ' + ($found.Values | Measure-Object -Sum).Sum + ' places' + $(if ($version) { ', version ' + $version } else { '' }))
Write-Output ("Building as $Character" + $(if ($swapped.Count -eq 0) { ": nothing of hers yet, so all of Capri's art, voice and icon" } else { " with her own " + ($swapped -join ', ') }))
