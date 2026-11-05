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

# Sheets that may also come with fewer frames: Capri's count and speed, then the shorter count and speed. A sheet is read as
# shorter from its width, so each one changes when hers goes in, and Capri's own art keeps her own numbers until then.
$fewerFrames = @{
    'perch' = @(60, 30, 16, 8); 'perch_talk' = @(60, 30, 16, 8); 'perch_music' = @(60, 30, 16, 8)
    'perch_blink' = @(8, 30, 4, 8); 'perch_blink_glitch' = @(8, 30, 4, 8)
    'laydown' = @(60, 30, 16, 8); 'laydown_talk' = @(60, 30, 16, 8); 'laydown_sleep' = @(60, 30, 16, 8)
    'laydown_blink' = @(8, 30, 4, 8); 'laydown_blink_glitch' = @(8, 30, 4, 8)
}
$sheetWidths = @{}
$shorterSheets = @{}
$swapped = New-Object System.Collections.Generic.List[string]
$swap = {
    param([string]$argument)
    $resource = [regex]::Match($argument, '^/resource:(.+),Capri\.(Sprite|Voice)\.(.+)$')
    if (-not $resource.Success) { return $argument }
    $folder = if ($resource.Groups[2].Value -eq 'Sprite') { 'sprites' } else { 'voice' }
    $own = Join-Path $characterRoot ($folder + '\' + $resource.Groups[3].Value)
    $hasOwn = Test-Path -LiteralPath $own
    if ($folder -eq 'sprites') {
        # Her frame counts and sizes are set in the code, so a sheet of another size would cut her frames wrong.
        $capri = Get-PngSize $resource.Groups[1].Value
        $sheetWidths[$resource.Groups[3].Value] = $capri[0]
        if ($hasOwn) {
            $theirs = Get-PngSize $own
            # Windows silently draws nothing from a picture wider than this, so she'd just vanish.
            if ($theirs[0] -gt 32767) { throw "$own is $($theirs[0]) px wide, and Windows can't draw a picture wider than 32767. Use fewer frames, or Capri's size. See characters/talia/NOTES.md." }
            $sheetWidths[$resource.Groups[3].Value] = $theirs[0]
            $clipName = [regex]::Replace($resource.Groups[3].Value, '(_flipped)?\.png$', '')
            $shorter = $fewerFrames[$clipName]
            # A sheet can also be double Capri's size: the app cuts it by its own width and scales it to fit (characters/double-size.txt).
            $scale = if ($theirs[1] -eq $capri[1] * 2) { 2 } else { 1 }
            $isShorter = $shorter -and $capri[1] * $scale -eq $theirs[1] -and $theirs[0] -eq ($capri[0] / $shorter[0] * $shorter[2] * $scale)
            if ($isShorter) { $shorterSheets[$clipName] = $shorter }
            elseif ($capri[0] * $scale -ne $theirs[0] -or $capri[1] * $scale -ne $theirs[1]) {
                $allowed = if ($shorter) { ", or $($capri[0] / $shorter[0] * $shorter[2] * 2)x$($capri[1] * 2) or $($capri[0] / $shorter[0] * $shorter[2])x$($capri[1]) for $($shorter[2]) frames" } else { '' }
                throw ("$own is $($theirs[0])x$($theirs[1]) px, but it should be $($capri[0] * 2)x$($capri[1] * 2) at double size or $($capri[0])x$($capri[1]) at Capri's$allowed. See characters/lucy/ART.md.")
            }
        }
    }
    if (-not $hasOwn) { return $argument }
    $swapped.Add($folder + '/' + $resource.Groups[3].Value)
    return '/resource:' + $own + ',Capri.' + $resource.Groups[2].Value + '.' + $resource.Groups[3].Value
}
$resources = @($resources | ForEach-Object { & $swap $_ })
# A facing-left sheet has to be cut like the facing-right one, since the app uses one frame count for both.
foreach ($sheet in @($sheetWidths.Keys | Where-Object { $_ -like '*_flipped.png' })) {
    $right = $sheet.Replace('_flipped.png', '.png')
    $hasOwnLeft = Test-Path -LiteralPath (Join-Path $characterRoot ('sprites\' + $sheet))
    if ($hasOwnLeft -and $sheetWidths[$right] -ne $sheetWidths[$sheet]) { throw "characters/$Character/sprites/$sheet is $($sheetWidths[$sheet]) px wide, but $right is $($sheetWidths[$right]). They need the same number of frames." }
}
# Capri's facing-left sheets are drawn separately, not mirrored. Once a character has her own sheet, Capri's facing-left one
# leaves the build, or she'd turn into Capri when she faces left. With none, the app mirrors hers (Clip's flippable).
$resources = @($resources | Where-Object {
    $left = [regex]::Match($_, ',Capri\.Sprite\.(.+)_flipped\.png$')
    if (-not $left.Success) { return $true }
    $sprites = Join-Path $characterRoot 'sprites'
    (Test-Path -LiteralPath (Join-Path $sprites ($left.Groups[1].Value + '_flipped.png'))) -or -not (Test-Path -LiteralPath (Join-Path $sprites ($left.Groups[1].Value + '.png')))
})

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
foreach ($list in @((Join-Path $root 'characters\app.txt'), (Join-Path $root 'characters\own-files.txt'), (Join-Path $root 'characters\fewer-frames.txt'), (Join-Path $root 'characters\double-size.txt'), (Join-Path $characterRoot 'names.txt'), (Join-Path $characterRoot 'checks.txt'))) {
    if (-not (Test-Path -LiteralPath $list)) { continue }
    foreach ($line in Get-Content -LiteralPath $list -Encoding UTF8) {
        $rule = [regex]::Match($line, '^"(.+)"\s*=>\s*"(.*)"\s*$')
        if ($rule.Success) { $rules.Add(@((Split-Path -Leaf $list), $rule.Groups[1].Value, $rule.Groups[2].Value.Replace('{character}', $Character.ToLowerInvariant()))) }
    }
}
foreach ($clipName in $shorterSheets.Keys) {
    $numbers = $shorterSheets[$clipName]
    $rules.Add(@('her shorter sheet', ('new Clip("' + $clipName + '", ' + $numbers[0] + ', ' + $numbers[1] + ','), ('new Clip("' + $clipName + '", ' + $numbers[2] + ', ' + $numbers[3] + ',')))
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
# A character with a builtin-personality.txt gets her personality.md as her default personality, in the copy of the code.
# The self-test can't know her text's checksum and length ahead of time, so in the copy it works them out from her own text.
# The plain build's self-test still pins Capri's safety lines exactly.
$ownPersonality = Join-Path $characterRoot 'personality.md'
if (Test-Path -LiteralPath (Join-Path $characterRoot 'builtin-personality.txt')) {
    if (-not (Test-Path -LiteralPath $ownPersonality)) { throw "$ownPersonality is missing." }
    $plain = [regex]::Replace([IO.File]::ReadAllText($ownPersonality, $utf8).TrimStart([char]0xFEFF).Replace("`r`n", "`n").Replace("`r", "`n"), '<!--.*?(-->|$)', '', 'Singleline')
    $plain = (($plain -split "`n") | Where-Object { $_.Trim().Length -gt 0 } | ForEach-Object { $_.TrimEnd() }) -join "`n"
    if ($plain.Length -eq 0) { throw "$ownPersonality has no text." }
    $sha = [Security.Cryptography.SHA256]::Create()
    $stamp = ([BitConverter]::ToString($sha.ComputeHash($utf8.GetBytes($plain)), 0, 8)).Replace('-', '').ToLowerInvariant()
    $sha.Dispose()
    $literal = '"' + $plain.Replace('\', '\\').Replace('"', '\"').Replace("`n", '\n') + '"'
    $brainPath = Join-Path $staged 'app\Brain.cs'
    $brain = [IO.File]::ReadAllText($brainPath, $utf8)
    $capriStamp = [regex]::Match($brain, 'internal const string DefaultStamp = "([0-9a-f]{16})";')
    $defaultPattern = '(?s)internal const string DefaultPersonality =.*?";(?=\r?\n\s*\r?\n)'
    if (-not $capriStamp.Success -or -not [regex]::IsMatch($brain, $defaultPattern)) { throw "Can't find her default personality in Brain.cs any more. Check what Capri's code says now and update Use-Character.ps1." }
    $brain = ([regex]$defaultPattern).Replace($brain, { param($m) 'internal const string DefaultPersonality = ' + $literal + ';' }, 1)
    $brain = $brain.Replace($capriStamp.Value, 'internal const string DefaultStamp = "' + $stamp + '";')
    $brain = $brain.Replace('Retired = new List<string> { ', 'Retired = new List<string> { "' + $capriStamp.Groups[1].Value + '", ')
    [IO.File]::WriteAllText($brainPath, $brain, $utf8)
    $capriPath = Join-Path $staged 'app\Capri.cs'
    $capri = [IO.File]::ReadAllText($capriPath, $utf8)
    $hashPattern = 'const string todaysPersona = "[0-9a-f]{64}";'
    $lengthPattern = 'Brain\.Persona\.Length == \d+'
    if (-not [regex]::IsMatch($capri, $hashPattern) -or -not [regex]::IsMatch($capri, $lengthPattern)) { throw "Can't find the self-test's personality checksum in Capri.cs any more. Check what Capri's code says now and update Use-Character.ps1." }
    $capri = ([regex]$hashPattern).Replace($capri, { param($m) 'string todaysPersona; using (System.Security.Cryptography.SHA256 ownSha = System.Security.Cryptography.SHA256.Create()) todaysPersona = BitConverter.ToString(ownSha.ComputeHash(new System.Text.UTF8Encoding(false).GetBytes(Brain.DefaultPersonality + "\n" + Brain.Safety + "\n" + Brain.Machinery))).Replace("-", "").ToLowerInvariant();' })
    $capri = [regex]::Replace($capri, $lengthPattern, 'Brain.Persona.Length > 0')
    [IO.File]::WriteAllText($capriPath, $capri, $utf8)
    $swapped.Add('personality (stamp ' + $stamp + ')')
}
foreach ($rule in $rules) { if (-not $found.ContainsKey($rule[1])) { Write-Warning ($rule[0] + ": `"" + $rule[1] + "`" isn't in the code any more. Check what Capri's code says now and update the line.") } }
$sources = @($sources | ForEach-Object { Join-Path $staged ('app\' + (Split-Path -Leaf $_)) })
$ownPicture = Join-Path $characterRoot 'icon.png'
Copy-Item -LiteralPath $(if (Test-Path -LiteralPath $ownPicture) { $ownPicture } else { Join-Path $root 'assets\chip.png' }) -Destination (Join-Path $staged 'assets\chip.png') -Force
$root = $staged
$swapped.Add('names in ' + ($found.Values | Measure-Object -Sum).Sum + ' places' + $(if ($version) { ', version ' + $version } else { '' }))
Write-Output ("Building as $Character" + $(if ($swapped.Count -eq 0) { ": nothing of hers yet, so all of Capri's art, voice and icon" } else { " with her own " + ($swapped -join ', ') }))
