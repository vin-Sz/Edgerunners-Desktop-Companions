param([string]$Out, [switch]$FewerFrames)
# -FewerFrames makes only the sitting and lying sheets that can be shorter (16 frames, blinks 4), like characters/talia/templates.
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force $Out | Out-Null

$sheets = @(
  @('idle',16,'stand'), @('blink',4,'blink'), @('blink_glitch',4,'blink'), @('mouth',5,'mouth'),
  @('grin',16,'stand'), @('glitch',10,'stand'), @('dangle',24,'stand'), @('sleep',16,'stand'),
  @('wake',13,'stand'), @('walk',12,'stand'), @('arrive',14,'stand'), @('leave',12,'stand'),
  @('perch',60,'perch',196), @('perch_blink',8,'pblink',196), @('perch_blink_glitch',8,'pblink',196),
  @('perch_music',60,'perch',196), @('perch_glitch',10,'perch',288), @('perch_arrive',14,'perch',288),
  @('perch_leave',12,'perch',288), @('perch_talk',60,'perch',196),
  @('laydown',60,'lie',372), @('laydown_talk',60,'lie',372), @('laydown_blink',8,'lblink',372),
  @('laydown_blink_glitch',8,'lblink',372), @('laydown_sleep',60,'lie',372), @('laydown_glitch',10,'lie',440),
  @('laydown_leave',12,'lie',440)
)
# Where the blink sits in a sitting or lying loop, and how long it is.
$blinkAt = 28; $blinkCells = 8
if ($FewerFrames) {
  $blinkAt = 9; $blinkCells = 4
  $short = @()
  foreach ($s in $sheets) {
    if ($s[1] -eq 60) { $short += , @($s[0], 16, $s[2], $s[3]) }
    elseif ($s[2] -eq 'pblink' -or $s[2] -eq 'lblink') { $short += , @($s[0], 4, $s[2], $s[3]) }
  }
  $sheets = $short
}
# Since 0.7.6 perch cells are cut narrower than her 384 px square: their middle sits 26 px left of it and their top 36 px
# down it (PerchShiftX and PerchShiftY in app/Capri.cs). The seat (115, 303) and grab box (81, 65 to 265, 376) are in the square.
$shiftX = -26; $shiftY = 36
# Since 0.7.7 the lie-down cells are 250 px high, centred across the square and starting 161 px down it (LieShiftY,
# LieHeight in app/Capri.cs). Her hip sits at (309, 303) of the square (LieRight, SitY), her body box is LyingRight.
$lieTop = 161
$mouthNames = @('closed','small','small','open','wide')

$border = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(200,120,120,120)), 1
$ground = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(230,230,40,60)), 2
$center = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(160,0,190,210)), 1
$center.DashStyle = 'Dash'
$body = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(170,60,110,230)), 1
$body.DashStyle = 'Dot'
$mouthPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(200,240,140,20)), 1
$text = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220,90,90,90))
$red = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(230,230,40,60))
$font = New-Object System.Drawing.Font 'Segoe UI', 10
$small = New-Object System.Drawing.Font 'Segoe UI', 8

foreach ($s in $sheets) {
  $name = $s[0]; $count = $s[1]; $kind = $s[2]
  $perch = $kind -eq 'perch' -or $kind -eq 'pblink'
  $lie = $kind -eq 'lie' -or $kind -eq 'lblink'
  $fw = if ($perch -or $lie) { $s[3] } else { 240 }
  $fh = if ($lie) { 250 } else { 384 }
  $left = if ($lie) { 192 - $fw / 2 } else { 192 + $shiftX - $fw / 2 }
  $bmp = New-Object System.Drawing.Bitmap ($fw * $count), $fh
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.TextRenderingHint = 'AntiAlias'
  for ($i = 0; $i -lt $count; $i++) {
    $x = $i * $fw
    $g.DrawRectangle($border, $x, 0, $fw - 1, $fh - 1)
    if ($lie) {
      $bl = [Math]::Max(0, 10 - $left); $br = [Math]::Min($fw - 1, 374 - $left)
      $g.DrawRectangle($body, $x + $bl, 166 - $lieTop, $br - $bl, $fh - 1 - (166 - $lieTop))
      $sx = 309 - $left; $sy = 303 - $lieTop
      $g.DrawLine($ground, $x + 2, $sy, $x + $fw - 2, $sy)
      $g.DrawLine($ground, $x + $sx, $sy - 15, $x + $sx, $sy + 15)
      $g.FillEllipse($red, $x + $sx - 3, $sy - 3, 6, 6)
      $g.DrawString('hip', $small, $red, $x + $sx + 5, $sy + 2)
    } elseif ($perch) {
      $bl = [Math]::Max(0, 81 - $left); $br = [Math]::Min($fw - 1, 265 - $left)
      $g.DrawRectangle($body, $x + $bl, 65 - $shiftY, $br - $bl, 311)
      $sx = 115 - $left; $sy = 303 - $shiftY
      $g.DrawLine($ground, $x + $sx - 30, $sy, $x + $sx + 30, $sy)
      $g.DrawLine($ground, $x + $sx, $sy - 15, $x + $sx, $sy + 15)
      $g.FillEllipse($red, $x + $sx - 3, $sy - 3, 6, 6)
      $g.DrawString('seat', $small, $red, $x + $sx + 5, $sy + 2)
    } else {
      $g.DrawLine($center, $x + 120, 0, $x + 120, 383)
      $g.DrawRectangle($body, $x + 33, 19, 177, 346)
      $g.DrawLine($ground, $x + 10, 362, $x + 230, 362)
      $g.DrawString('feet', $small, $red, $x + 12, 364)
    }
    if ($kind -eq 'mouth' -or ($name -eq 'idle')) { $g.DrawRectangle($mouthPen, $x + 122, 126, 20, 14) }
    $label = [string]$i
    if ($name -eq 'idle' -and $i -ge 9 -and $i -le 12) { $label = "$i  (blink " + ($i - 9) + ")" }
    if (($name -eq 'perch' -or $name -eq 'laydown') -and $i -ge $blinkAt -and $i -lt $blinkAt + $blinkCells) { $label = "$i  (b" + ($i - $blinkAt) + ")" }
    if ($kind -eq 'blink' -or $kind -eq 'pblink') { $label = "$i  = idle " + ($i + 9) }
    if ($kind -eq 'pblink') { $label = "$i = perch " + ($i + $blinkAt) }
    if ($kind -eq 'lblink') { $label = "$i  = laydown " + ($i + $blinkAt) }
    if ($kind -eq 'mouth') { $label = "$i  " + $mouthNames[$i] }
    $g.DrawString($label, $font, $text, $x + 4, 2)
  }
  $g.DrawString($name, $small, $text, 4, 18)
  $g.Dispose()
  $bmp.Save((Join-Path $Out ($name + '.png')), [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}

if ($FewerFrames) { return }
$bmp = New-Object System.Drawing.Bitmap 400, 400
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.DrawRectangle($border, 0, 0, 399, 399)
$g.DrawString('face (square portrait)', $font, $text, 4, 2)
$g.Dispose()
$bmp.Save((Join-Path $Out 'face.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
