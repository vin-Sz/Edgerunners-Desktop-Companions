param([string]$Out, [int]$Scale = 2, [string[]]$Only,[string]$Krita = 'C:\Program Files\Krita (x64)\bin\krita.com', [string]$Character = 'Lucy')
# One ready-to-draw file per animation: an empty layer for $Character on top, Capri's sheet faded under it, the template at
# the bottom, all $Scale times the app's size so there's room for detail (the app scales her to her on-screen size).
# Built as OpenRaster (.ora) and turned into .kra by Krita itself, so the layers come out exactly right.
# A file that already exists keeps its drawing: every layer but the two helpers is carried over, scaled to fit.
# A template in characters/<name>/templates takes the place of the shared one, for a character's sheets with fewer frames.
# Capri's sheet is then cut down to evenly spaced frames, so each one lines up with a cell.
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$templates = Join-Path $PSScriptRoot 'templates'
$ownTemplates = Join-Path $root ('characters\' + $Character.ToLowerInvariant() + '\templates')
$capri = Join-Path $root 'assets\sprites'
New-Item -ItemType Directory -Force $Out | Out-Null
$Out = (Resolve-Path $Out).Path
$work = Join-Path ([IO.Path]::GetTempPath()) "lucy-krita-$PID"
New-Item -ItemType Directory -Force $work | Out-Null
$helper = '^(Capri|Guides) - '
$Only = $Only -split ',' | Where-Object { $_ }

function Add-Entry($zip, $name, $bytes, $level) {
  $e = $zip.CreateEntry($name, $level)
  $s = $e.Open(); $s.Write($bytes, 0, $bytes.Length); $s.Close()
}
function Png-Bytes($bmp) {
  $ms = New-Object IO.MemoryStream
  $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
  $ms.ToArray()
}
function Read-Entry($zip, $name) {
  $ms = New-Object IO.MemoryStream
  $s = $zip.GetEntry($name).Open(); $s.CopyTo($ms); $s.Close()
  $ms.ToArray()
}
function Esc($s) { [Security.SecurityElement]::Escape($s) }
# Draws $img onto a new $w x $h canvas, $f times bigger, at ($x, $y) of the old canvas
function Scaled($img, $w, $h, $f, $x, $y, $mode) {
  $bmp = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = $mode
  $g.PixelOffsetMode = 'Half'
  $g.DrawImage($img, [float]($x * $f), [float]($y * $f), [float]($img.Width * $f), [float]($img.Height * $f))
  $g.Dispose()
  $bmp
}
# Capri's sheet with only evenly spaced frames, as wide as a template with fewer frames. Her loops have 60 frames, her blinks 8.
function Fewer-Frames($img, $name, $wide) {
  $before = if ($name -like '*blink*') { 8 } else { 60 }
  $cell = $img.Width / $before
  $after = [int]($wide / $cell)
  $bmp = New-Object System.Drawing.Bitmap $wide, $img.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  for ($i = 0; $i -lt $after; $i++) {
    $from = [int][Math]::Floor($i * $before / $after) * $cell
    $g.DrawImage($img, (New-Object System.Drawing.Rectangle ($i * $cell), 0, $cell, $img.Height), $from, 0, $cell, $img.Height, 'Pixel')
  }
  $g.Dispose()
  $bmp
}
# Whether any pixel of a layer has been drawn on
function Has-Drawing($img) {
  $bmp = New-Object System.Drawing.Bitmap $img
  $data = $bmp.LockBits((New-Object System.Drawing.Rectangle 0, 0, $bmp.Width, $bmp.Height), 'ReadOnly', ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb))
  $bytes = New-Object byte[] ($data.Stride * $bmp.Height)
  [Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
  $bmp.UnlockBits($data); $bmp.Dispose()
  for ($i = 3; $i -lt $bytes.Length; $i += 4) { if ($bytes[$i] -ne 0) { return $true } }
  $false
}

$sheetFiles = @{}
foreach ($file in Get-ChildItem $templates -Filter *.png) { $sheetFiles[$file.BaseName] = $file }
if (Test-Path $ownTemplates) { foreach ($file in Get-ChildItem $ownTemplates -Filter *.png) { $sheetFiles[$file.BaseName] = $file } }
foreach ($name in ($sheetFiles.Keys | Sort-Object)) {
  $file = $sheetFiles[$name]
  if ($Only -and $Only -notcontains $name) { continue }
  $guideSmall = [System.Drawing.Image]::FromFile($file.FullName)
  $w = $guideSmall.Width * $Scale; $h = $guideSmall.Height * $Scale
  $guide = Scaled $guideSmall $w $h $Scale 0 0 'NearestNeighbor'
  $guideSmall.Dispose()
  $ref = Join-Path $capri "$name.png"
  $kra = Join-Path $Out "$name.kra"

  # Her own layers from the file already there, top first, or one empty layer for a new file
  $own = @()
  if (Test-Path $kra) {
    $old = Join-Path $work "$name-old.ora"
    & $Krita $kra --export --export-filename $old 2>&1 | Out-Null
    if (-not (Test-Path $old)) { throw "Krita couldn't read $name.kra, so it was left alone. Is it open in Krita?" }
    $oldZip = [IO.Compression.ZipFile]::OpenRead($old)
    $stack = [xml][Text.Encoding]::UTF8.GetString((Read-Entry $oldZip 'stack.xml'))
    $f = $w / [double]$stack.image.w
    # A different number of frames changes the sheet's shape, so a drawing can't just be scaled to fit.
    $newShape = [Math]::Abs($h / [double]$stack.image.h - $f) -gt 0.001
    foreach ($l in $stack.SelectNodes('//layer')) {
      if ($l.name -match $helper) { continue }
      $img = [System.Drawing.Image]::FromStream((New-Object IO.MemoryStream (, (Read-Entry $oldZip $l.src))))
      if ($newShape) {
        $drawn = Has-Drawing $img
        $img.Dispose()
        if ($drawn) { $oldZip.Dispose(); throw "$name.kra has a drawing, and the new sheet has a different number of frames. It was left alone, so its frames need moving by hand." }
        continue
      }
      $bmp = Scaled $img $w $h $f ([double]$l.x) ([double]$l.y) 'HighQualityBicubic'
      $own += @{ Name = $l.name; Png = (Png-Bytes $bmp); Opacity = $(if ($l.opacity) { $l.opacity } else { '1.0' }); Visibility = $(if ($l.visibility) { $l.visibility } else { 'visible' }) }
      $img.Dispose(); $bmp.Dispose()
    }
    $oldZip.Dispose()
    # Nothing to back up when the old file was still empty and the sheet changes shape.
    if (-not $newShape) { Copy-Item $kra (Join-Path $Out "$name (before remake).kra") }
    Remove-Item $kra
  }
  if ($own.Count -eq 0) {
    $empty = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $own = @(@{ Name = "$Character - draw here"; Png = (Png-Bytes $empty); Opacity = '1.0'; Visibility = 'visible' })
    $empty.Dispose()
  }

  # What Krita shows before it has read the layers: the guide with Capri faded over it
  $capriBig = $null
  if (Test-Path $ref) {
    $capriImg = [System.Drawing.Image]::FromFile($ref)
    if ($capriImg.Width -ne $w / $Scale) {
      $capriFull = $capriImg
      $capriImg = Fewer-Frames $capriFull $name ($w / $Scale)
      $capriFull.Dispose()
    }
    $capriBig = Scaled $capriImg $w $h $Scale 0 0 'HighQualityBicubic'
    $capriImg.Dispose()
  }
  $merged = New-Object System.Drawing.Bitmap $guide
  if ($capriBig) {
    $g = [System.Drawing.Graphics]::FromImage($merged)
    $fade = New-Object System.Drawing.Imaging.ColorMatrix; $fade.Matrix33 = 0.25
    $attr = New-Object System.Drawing.Imaging.ImageAttributes; $attr.SetColorMatrix($fade)
    $g.DrawImage($capriBig, (New-Object System.Drawing.Rectangle 0, 0, $w, $h), 0, 0, $w, $h, 'Pixel', $attr)
    $g.Dispose()
  }
  $thumbScale = [Math]::Min(1.0, 256.0 / [Math]::Max($w, $h))
  $thumb = New-Object System.Drawing.Bitmap $merged, ([int][Math]::Max(1, $w * $thumbScale)), ([int][Math]::Max(1, $h * $thumbScale))

  $layers = @()
  for ($i = 0; $i -lt $own.Count; $i++) {
    $layers += "    <layer name=""$(Esc $own[$i].Name)"" src=""data/own$i.png"" x=""0"" y=""0"" opacity=""$($own[$i].Opacity)"" visibility=""$($own[$i].Visibility)"" composite-op=""svg:src-over""/>"
  }
  if ($capriBig) {
    $layers += '    <layer name="Capri - poses only, HIDE before export" src="data/capri.png" x="0" y="0" opacity="0.25" visibility="visible" composite-op="svg:src-over"/>'
  }
  $layers += '    <layer name="Guides - HIDE before export" src="data/guides.png" x="0" y="0" opacity="1.0" visibility="visible" composite-op="svg:src-over"/>'
  $stackXml = "<?xml version=""1.0"" encoding=""UTF-8""?>`n<image version=""0.0.1"" w=""$w"" h=""$h"" xres=""72"" yres=""72"">`n  <stack>`n" + ($layers -join "`n") + "`n  </stack>`n</image>`n"

  $ora = Join-Path $work "$name.ora"
  $fs = [IO.File]::Open($ora, 'Create')
  $zip = New-Object IO.Compression.ZipArchive $fs, ([IO.Compression.ZipArchiveMode]::Create)
  Add-Entry $zip 'mimetype' ([Text.Encoding]::ASCII.GetBytes('image/openraster')) 'NoCompression'
  Add-Entry $zip 'stack.xml' ([Text.Encoding]::UTF8.GetBytes($stackXml)) 'Optimal'
  for ($i = 0; $i -lt $own.Count; $i++) { Add-Entry $zip "data/own$i.png" $own[$i].Png 'Optimal' }
  if ($capriBig) { Add-Entry $zip 'data/capri.png' (Png-Bytes $capriBig) 'Optimal' }
  Add-Entry $zip 'data/guides.png' (Png-Bytes $guide) 'Optimal'
  Add-Entry $zip 'Thumbnails/thumbnail.png' (Png-Bytes $thumb) 'Optimal'
  Add-Entry $zip 'mergedimage.png' (Png-Bytes $merged) 'Optimal'
  $zip.Dispose(); $fs.Close()
  $guide.Dispose(); $merged.Dispose(); $thumb.Dispose()
  if ($capriBig) { $capriBig.Dispose() }

  & $Krita $ora --export --export-filename $kra 2>&1 | Out-Null
  if (Test-Path $kra) {
    # Lock the helper layers so nothing gets painted on them by mistake
    $zip = [IO.Compression.ZipFile]::Open($kra, 'Update')
    $entry = $zip.GetEntry('maindoc.xml')
    $r = New-Object IO.StreamReader $entry.Open(); $doc = $r.ReadToEnd(); $r.Close()
    $doc = [regex]::Replace($doc, '<layer [^>]*name="(Capri|Guides) - [^>]*', { $args[0].Value -replace 'locked="0"', 'locked="1"' })
    $entry.Delete()
    Add-Entry $zip 'maindoc.xml' ([Text.Encoding]::UTF8.GetBytes($doc)) 'Optimal'
    $zip.Dispose()
    "$name.kra ($w x $h)"
  } else { Copy-Item $ora $Out; "$name.ora (Krita didn't convert it; open the .ora in Krita instead)" }
}
Remove-Item -Recurse -Force $work
