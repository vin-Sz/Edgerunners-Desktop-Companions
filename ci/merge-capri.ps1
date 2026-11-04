#Requires -Version 7
# Merges Lachy's capri-desktop into the branch you're on, fixes the conflicts that keep coming back, compiles the result
# and commits it. It never pushes, and it never runs the app or the self-test.
#   ./ci/merge-capri.ps1                    merge his latest
#   ./ci/merge-capri.ps1 -GiveUpOnFailure   undo the merge if it needs a person (Sync upstream uses this)
# Exit code: 0 merged or nothing new, 2 it needs a person (what's left is printed), 1 it couldn't start.
#
# The fixes only run when they can't lose anything: each one first checks that this fork changed nothing else in that
# file since Lachy's version. If it did, the file is left for a person.
param(
    [string]$Upstream,            # a ref to merge instead of fetching his main, for replaying a past merge
    [string[]]$Characters = @('talia'),
    [switch]$NoCompile,
    [switch]$GiveUpOnFailure
)
$ErrorActionPreference = 'Stop'

# Runs git and returns its exit code and text as UTF-8, whatever this PC's console uses.
function Invoke-Git([string[]]$Arguments) {
    $info = [Diagnostics.ProcessStartInfo]::new('git')
    foreach ($argument in $Arguments) { $info.ArgumentList.Add($argument) }
    $info.WorkingDirectory = (Get-Location).Path
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $info.StandardOutputEncoding = [Text.UTF8Encoding]::new($false)
    $process = [Diagnostics.Process]::Start($info)
    $errors = $process.StandardError.ReadToEndAsync()
    $output = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    return [pscustomobject]@{ Code = $process.ExitCode; Text = $output; Errors = $errors.Result }
}
function Get-Stage([int]$Stage, [string]$Path) {
    $result = Invoke-Git @('show', ":${Stage}:$Path")
    if ($result.Code -ne 0) { return $null }
    return $result.Text
}
function Save-Resolved([string]$Path, [string]$Text) {
    [IO.File]::WriteAllText((Join-Path (Get-Location).Path $Path), $Text, [Text.UTF8Encoding]::new($false))
    [void](Invoke-Git @('add', '--', $Path))
}
function Write-Report([string[]]$Lines) {
    $Lines | Write-Output
    if ($env:GITHUB_STEP_SUMMARY) { $Lines | ForEach-Object { "$_  " } | Add-Content -LiteralPath $env:GITHUB_STEP_SUMMARY }
}

# Our three changes to ci/build-windows.ps1, applied to any version of it. Returns $null if a place for one has gone.
function Add-OurBuildLines([string]$Text) {
    $crlf = $Text.Contains("`r`n")
    $lf = $Text.Replace("`r`n", "`n")
    $param = [regex]::new('(?m)^param\((.*)\)$')
    $sources = [regex]::new('(?m)^\$sources = @\(.*''Player'', .*$')
    if (-not $param.IsMatch($lf) -or -not $sources.IsMatch($lf)) { return $null }
    if ($lf.Contains('[string]$Character') -or $lf.Contains("'YouTubeMusic'")) { return $null }
    $lf = $param.Replace($lf, { param($m) 'param(' + $m.Groups[1].Value + ', [string]$Character)' }, 1)
    $lf = $sources.Replace($lf, { param($m) $m.Value.Replace("'Player', ", "'Player', 'Character', 'YouTubeMusic', ") + "`n" + 'if ($Character) { . (Join-Path $root ''characters\Use-Character.ps1'') -Character $Character }' }, 1)
    if ($crlf) { return $lf.Replace("`n", "`r`n") }
    return $lf
}
function Resolve-BuildScript([string]$Path) {
    $base = Get-Stage 1 $Path; $ours = Get-Stage 2 $Path; $theirs = Get-Stage 3 $Path
    if ($null -eq $base -or $null -eq $ours -or $null -eq $theirs) { return $false }
    $expected = Add-OurBuildLines $base
    if ($null -eq $expected -or $expected.Replace("`r`n", "`n") -ne $ours.Replace("`r`n", "`n")) { return $false }
    $merged = Add-OurBuildLines $theirs
    if ($null -eq $merged) { return $false }
    Save-Resolved $Path $merged
    return $true
}

# Keeps both sides, but only when every conflicting line is one file in the list to compile.
function Resolve-ProjectList([string]$Path) {
    $base = Get-Stage 1 $Path; $ours = Get-Stage 2 $Path; $theirs = Get-Stage 3 $Path
    if ($null -eq $base -or $null -eq $ours -or $null -eq $theirs) { return $false }
    $folder = Join-Path ([IO.Path]::GetTempPath()) ('merge-capri-' + [guid]::NewGuid())
    [void](New-Item -ItemType Directory -Path $folder)
    try {
        $encoding = [Text.UTF8Encoding]::new($false)
        $files = @('ours', 'base', 'theirs') | ForEach-Object { Join-Path $folder $_ }
        [IO.File]::WriteAllText($files[0], $ours, $encoding)
        [IO.File]::WriteAllText($files[1], $base, $encoding)
        [IO.File]::WriteAllText($files[2], $theirs, $encoding)
        $marked = (Invoke-Git @('-c', 'merge.conflictStyle=merge', 'merge-file', '-p', $files[0], $files[1], $files[2])).Text
        $inside = $false
        foreach ($line in ($marked -split '\r?\n')) {
            if ($line.StartsWith('<<<<<<< ')) { $inside = $true; continue }
            if ($line.StartsWith('>>>>>>> ')) { $inside = $false; continue }
            if (-not $inside -or $line -eq '=======') { continue }
            if ($line -notmatch '^\s*<Compile Include="[^"]+" Link="[^"]+" />\s*$') { return $false }
        }
        $union = Invoke-Git @('merge-file', '-p', '--union', $files[0], $files[1], $files[2])
        Save-Resolved $Path $union.Text
        return $true
    } finally { Remove-Item -LiteralPath $folder -Recurse -Force }
}

# Prints the conflicts short enough to read, so nobody has to open a huge file to see them.
function Show-Conflict([string]$Path) {
    Write-Report @("  $Path")
    $full = Join-Path (Get-Location).Path $Path
    if (-not (Test-Path -LiteralPath $full)) { Write-Report @('    (deleted on one side)'); return }
    $number = 0; $shown = 0; $inside = $false
    foreach ($line in [IO.File]::ReadLines($full)) {
        $number++
        if ($line.StartsWith('<<<<<<< ')) { $inside = $true; $shown = 0 }
        if ($inside) {
            $shown++
            if ($shown -le 16) { Write-Report @(('    {0}: {1}' -f $number, $(if ($line.Length -gt 200) { $line.Substring(0, 200) + '...' } else { $line }))) }
            elseif ($shown -eq 17) { Write-Report @('    (longer than this, see the file)') }
        }
        if ($line.StartsWith('>>>>>>> ')) { $inside = $false }
    }
}
function Stop-ForPerson([string]$Why) {
    Write-Report @($Why)
    if ($GiveUpOnFailure) {
        [void](Invoke-Git @('merge', '--abort'))
        Write-Report @('The merge was undone.')
    } else {
        Write-Report @('The merge is still in progress here: fix what is listed, then git commit. git merge --abort undoes it.')
    }
    exit 2
}

$top = Invoke-Git @('rev-parse', '--show-toplevel')
if ($top.Code -ne 0) { Write-Output 'This is not inside the repository.'; exit 1 }
Set-Location -LiteralPath $top.Text.Trim()
if ((Invoke-Git @('status', '--porcelain')).Text.Trim()) { Write-Output 'This folder has uncommitted changes, so nothing was merged. Run this somewhere clean, like its own worktree.'; exit 1 }

if (-not $Upstream) {
    if ((Invoke-Git @('remote', 'get-url', 'upstream')).Code -ne 0) { [void](Invoke-Git @('remote', 'add', 'upstream', 'https://github.com/lachydotmcg/capri-desktop.git')) }
    $fetch = Invoke-Git @('fetch', '--no-tags', 'upstream', 'main')
    if ($fetch.Code -ne 0) { Write-Output ("Couldn't fetch capri-desktop: " + $fetch.Errors); exit 1 }
    $Upstream = 'upstream/main'
}
if ((Invoke-Git @('merge-base', '--is-ancestor', $Upstream, 'HEAD')).Code -eq 0) { Write-Report @('Already up to date with capri-desktop.'); exit 0 }

$new = (Invoke-Git @('rev-list', '--count', "HEAD..$Upstream")).Text.Trim()
$tip = (Invoke-Git @('rev-parse', '--short', $Upstream)).Text.Trim()
Write-Report @("Merging $new commit(s) from capri-desktop, up to $tip.")
$merge = Invoke-Git @('-c', 'merge.conflictStyle=merge', '-c', 'rerere.enabled=false', 'merge', '--no-ff', '--no-commit', $Upstream)
if (-not (Test-Path -LiteralPath (Join-Path (Invoke-Git @('rev-parse', '--git-dir')).Text.Trim() 'MERGE_HEAD'))) {
    Write-Report @("The merge didn't start: " + $merge.Errors + $merge.Text)
    exit 1
}

$fixed = @(); $left = @()
foreach ($path in @((Invoke-Git @('diff', '--name-only', '--diff-filter=U')).Text -split '\r?\n' | Where-Object { $_ })) {
    $done = switch ($path) {
        'README.md' { (Invoke-Git @('checkout', '--ours', '--', $path)).Code -eq 0 -and (Invoke-Git @('add', '--', $path)).Code -eq 0 }
        'ci/build-windows.ps1' { Resolve-BuildScript $path }
        'cross/Capri.Cross.csproj' { Resolve-ProjectList $path }
        default { $false }
    }
    if ($done) { $fixed += $path } else { $left += $path }
}
if ($fixed) { Write-Report @('Fixed on its own: ' + ($fixed -join ', ')) }
if ($left) {
    Write-Report @('Needs a person:')
    foreach ($path in $left) { Show-Conflict $path }
    Stop-ForPerson 'These files conflict in a way this script has no safe fix for.'
}

if (-not $NoCompile) {
    # Built in its own temp folder, because OneDrive shouldn't sync builds and Windows' 260-letter path limit is close.
    $shell = (Get-Process -Id $PID).Path
    foreach ($character in @('') + $Characters) {
        $label = if ($character) { $character } else { 'Capri' }
        $arguments = @('-NoProfile', '-File', 'ci/build-windows.ps1', '-OutputDirectory', (Join-Path ([IO.Path]::GetTempPath()) ('edgerunners-merge-check-' + $label)))
        if ($character) { $arguments += @('-Character', $character) }
        $output = & $shell @arguments 2>&1 | ForEach-Object { "$_" }
        $code = $LASTEXITCODE
        # A rule in a names list that no longer matches doesn't stop the build, but her text might say Capri again.
        $notes = @($output | Where-Object { $_ -match "isn't in the code any more" })
        if ($notes) { Write-Report (@("Worth checking in the $label build:") + ($notes | ForEach-Object { '  ' + $_ })) }
        if ($code -ne 0) {
            $errors = @($output | Where-Object { $_ -match 'error CS|Exception|failed|throw|not found' } | Select-Object -First 20 | ForEach-Object { if ($_.Length -gt 300) { $_.Substring(0, 300) + '...' } else { $_ } })
            Write-Report (@("The $label build doesn't compile:") + ($errors | ForEach-Object { '  ' + $_ }))
            Stop-ForPerson 'The merge has no conflicts left, but it does not compile.'
        }
        Write-Report @("The $label build compiles.")
    }
}

$release = Invoke-Git @('show', "${Upstream}:site/release.json")
$version = [regex]::Match($release.Text, '"tag_name"\s*:\s*"v?([^"]+)').Groups[1].Value
$message = "Merge capri-desktop$(if ($version) { " $version" }) from upstream`n`nBrings in lachydotmcg/capri-desktop up to $tip ($new new commits)."
if ($fixed) { $message += "`nFixed by ci/merge-capri.ps1: " + ($fixed -join ', ') + '.' }
$commit = Invoke-Git @('commit', '-m', $message)
if ($commit.Code -ne 0) { Write-Report @("The commit failed: " + $commit.Errors + $commit.Text); exit 1 }
Write-Report @('Committed the merge. Nothing was pushed, and the self-test still needs to run on GitHub.')
