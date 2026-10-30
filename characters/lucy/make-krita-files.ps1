param([string]$Out, [string]$Krita = 'C:\Program Files\Krita (x64)\bin\krita.com')
# One ready-to-draw file per animation: an empty layer for Lucy on top, Capri's sheet faded under it, the template at
# the bottom. Built as OpenRaster (.ora) and turned into .kra by Krita itself, so the layers come out exactly right.
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$templates = Join-Path $PSScriptRoot 'templates'
$capri = Join-Path $root 'assets\sprites'
New-Item -ItemType Directory -Force $Out | Out-Null
$Out = (Resolve-Path $Out).Path
$work = Join-Path ([IO.Path]::GetTempPath()) "lucy-krita-$PID"
New-Item -ItemType Directory -Force $work | Out-Null

function Add-Entry($zip, $name, $bytes, $level) {
  $e = $zip.CreateEntry($name, $level)
  $s = $e.Open(); $s.Write($bytes, 0, $bytes.Length); $s.Close()
}
function Png-Bytes($bmp) {
  $ms = New-Object IO.MemoryStream
  $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
  $ms.ToArray()
}

foreach ($file in Get-ChildItem $templates -Filter *.png) {
  $name = $file.BaseName
  $guide = [System.Drawing.Image]::FromFile($file.FullName)
  $w = $guide.Width; $h = $guide.Height
  $ref = Join-Path $capri "$name.png"
  $empty = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

  # What Krita shows before it has read the layers: the guide with Capri faded over it
  $merged = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($merged)
  $g.DrawImage($guide, 0, 0, $w, $h)
  if (Test-Path $ref) {
    $capriImg = [System.Drawing.Image]::FromFile($ref)
    $fade = New-Object System.Drawing.Imaging.ColorMatrix; $fade.Matrix33 = 0.25
    $attr = New-Object System.Drawing.Imaging.ImageAttributes; $attr.SetColorMatrix($fade)
    $g.DrawImage($capriImg, (New-Object System.Drawing.Rectangle 0, 0, $w, $h), 0, 0, $w, $h, 'Pixel', $attr)
    $capriBytes = [IO.File]::ReadAllBytes($ref)
    $capriImg.Dispose()
  } else { $capriBytes = $null }
  $g.Dispose()
  $scale = [Math]::Min(1.0, 256.0 / [Math]::Max($w, $h))
  $thumb = New-Object System.Drawing.Bitmap $merged, ([int][Math]::Max(1, $w * $scale)), ([int][Math]::Max(1, $h * $scale))

  $layers = @('    <layer name="Lucy - draw here" src="data/lucy.png" x="0" y="0" opacity="1.0" visibility="visible" composite-op="svg:src-over"/>')
  if ($capriBytes) {
    $layers += '    <layer name="Capri - poses only, HIDE before export" src="data/capri.png" x="0" y="0" opacity="0.25" visibility="visible" composite-op="svg:src-over"/>'
  }
  $layers += '    <layer name="Guides - HIDE before export" src="data/guides.png" x="0" y="0" opacity="1.0" visibility="visible" composite-op="svg:src-over"/>'
  $stack = "<?xml version=""1.0"" encoding=""UTF-8""?>`n<image version=""0.0.1"" w=""$w"" h=""$h"" xres=""72"" yres=""72"">`n  <stack>`n" + ($layers -join "`n") + "`n  </stack>`n</image>`n"

  $ora = Join-Path $work "$name.ora"
  $fs = [IO.File]::Open($ora, 'Create')
  $zip = New-Object IO.Compression.ZipArchive $fs, ([IO.Compression.ZipArchiveMode]::Create)
  Add-Entry $zip 'mimetype' ([Text.Encoding]::ASCII.GetBytes('image/openraster')) 'NoCompression'
  Add-Entry $zip 'stack.xml' ([Text.Encoding]::UTF8.GetBytes($stack)) 'Optimal'
  Add-Entry $zip 'data/lucy.png' (Png-Bytes $empty) 'Optimal'
  if ($capriBytes) { Add-Entry $zip 'data/capri.png' $capriBytes 'Optimal' }
  Add-Entry $zip 'data/guides.png' ([IO.File]::ReadAllBytes($file.FullName)) 'Optimal'
  Add-Entry $zip 'Thumbnails/thumbnail.png' (Png-Bytes $thumb) 'Optimal'
  Add-Entry $zip 'mergedimage.png' (Png-Bytes $merged) 'Optimal'
  $zip.Dispose(); $fs.Close()
  $guide.Dispose(); $empty.Dispose(); $merged.Dispose(); $thumb.Dispose()

  $kra = Join-Path $Out "$name.kra"
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
    "$name.kra"
  } else { Copy-Item $ora $Out; "$name.ora (Krita didn't convert it; open the .ora in Krita instead)" }
}
Remove-Item -Recurse -Force $work
