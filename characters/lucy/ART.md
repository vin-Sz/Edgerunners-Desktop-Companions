# Drawing Lucy

Everything the app needs from her art, measured from capri-desktop 0.7.7. Check it again after big updates (new animations may appear).

## Using the templates

**Ready-made Krita files:** `krita/` has one `.kra` per animation with the three layers below already set up and the two helper layers locked. They're 2× the app's size (480×768 per standing frame) so there's room for detail, so every guide number below is doubled in them. Export them at that size; the app scales her down.

Remake them after the templates change with the line below. Close them in Krita first. Your own layers are carried over (scaled to fit) and the old file is kept as `name (before remake).kra`. `-Only idle,blink` remakes just those.

`powershell -File characters\lucy\make-krita-files.ps1 -Out characters\lucy\krita`

`templates/` has one guide PNG per animation, the same size as Capri's sheet. In Krita, layers from top to bottom:

1. Your drawing
2. Capri's sheet from `assets/sprites/` at 20–30% opacity, only for poses and timing. Don't trace her shape.
3. The template

Hide both helper layers before exporting. Export as PNG with a transparent background, named like Capri's file (`idle.png`, …), into `characters/lucy/sprites/`.

**Bigger is fine:** draw at 2× (480×768 per standing frame) if you like. Keep the same proportions and every guide scales with it.

## What the guide lines mean

| Line | Meaning | Must match? |
| --- | --- | --- |
| Gray box | One frame. Every frame in a sheet is the same size, side by side in one row | Yes |
| Red line, **feet** (standing) | Her feet touch this line (y 362 of 384) | Yes, or she floats/sinks when standing on windows |
| Red cross, **seat** (perch) | The point that sits on a window edge. Its spot in the frame depends on the frame width (see Sitting frames below) | Yes, or she floats/sinks when sitting |
| Cyan dashes | Center of the frame. Keep her roughly centered | Roughly |
| Blue dots | Where you can click and grab her | Roughly, can be adjusted in code |
| Orange box (idle, mouth) | Where **Capri's** mouth is | No, just a hint. Lucy's mouth goes wherever her face is |

Hair, effects or a raised arm may go outside the blue box, but stay inside the gray frame.

**Facing:** draw her facing the same way as Capri. The app mirrors her when she turns.

## The animations

Standing frames are 240×384. Sitting (`perch_*`) frames are 196×384 or 288×384, lying (`laydown_*`) frames 372×250 or 440×250, see the table. fps = frames per second.

| File | Frames | fps | What it is | Must match |
| --- | --- | --- | --- | --- |
| `idle` | 16 | 8 | Standing still, the one you see most. Start here | Face stays in the **same spot** in every frame (the mouth is drawn on top) |
| `blink` | 4 | 8 | Blink | Frame 0–3 = idle 9–12 with eyes closing. Swapped in for those frames |
| `blink_glitch` | 4 | 8 | A "glitchy" blink. Netrunner idea: eyes/interface flashing | Same as blink |
| `mouth` | 5 | – | Mouth shapes, drawn **on top of** idle while she talks | Only the mouth, rest transparent, same spot as idle's mouth |
| `grin` | 16 | 8 | Grinning | Feet line |
| `glitch` | 10 | 15 | Capri glitching. Netrunner idea: jacking in, code over her | Feet line |
| `dangle` | 24 | 10 | Hanging while you drag her | Starts and ends close to idle |
| `sleep` | 16 | 6 | Sleeping | Feet line |
| `wake` | 13 | 15 | Waking up | Ends close to idle |
| `walk` | 12 | 12 | Walking along a window | Feet line, loops |
| `arrive` | 14 | 15 | Appearing | Ends close to idle |
| `leave` | 12 | 15 | Disappearing | Starts close to idle |
| `perch` | 60 | 30 | Sitting on a window edge, 196 px frames | Seat point |
| `perch_blink` | 8 | 30 | Blink while sitting, 196 px frames | Frame 0–7 = perch 28–35 with eyes closing |
| `perch_blink_glitch` | 8 | 30 | Glitchy blink while sitting, 196 px frames | Same as perch_blink |
| `perch_music` | 60 | 30 | Swaying to music while sitting, 196 px frames. The app adds a beat nod on top | Seat point, loops |
| `perch_glitch` | 10 | 15 | Glitch while sitting, 288 px frames | Seat point |
| `perch_arrive` | 14 | 15 | Appearing onto a ledge, 288 px frames | Ends close to perch |
| `perch_leave` | 12 | 15 | Disappearing from a ledge, 288 px frames | Starts close to perch |
| `perch_talk` | 60 | 30 | Talking while sitting, 196 px frames (since 0.7.7) | Seat point, loops |
| `laydown` | 60 | 30 | Lying along a ledge, 372×250 frames (since 0.7.7) | Hip point, loops |
| `laydown_talk` | 60 | 30 | Talking while lying, 372×250 | Hip point, loops |
| `laydown_blink` | 8 | 30 | Blink while lying, 372×250 | Frame 0–7 = laydown 28–35 with eyes closing |
| `laydown_blink_glitch` | 8 | 30 | Glitchy blink while lying, 372×250 | Same as laydown_blink |
| `laydown_sleep` | 60 | 30 | Sleeping while lying, 372×250 | Hip point, loops |
| `laydown_glitch` | 10 | 15 | Glitching into lying down, 440×250 | Hip point |
| `laydown_leave` | 12 | 15 | Disappearing while lying, 440×250 | Starts close to laydown |
| `face` | 1 | – | 400×400 portrait, shown when she takes over an app | Square |

Not needed: `dance.png`. The app dances standing by reusing idle. (`perch_dance.png` is gone since 0.7.6; `perch_music` replaced it.)

### Sitting frames (since 0.7.6)

Capri's perch is now 60 smooth frames by her artist, so 16 frames at 8 fps became 60 at 30 fps. The perch frames are also cut narrower than her 384×384 square: each frame's middle sits 26 px left of the square's middle, and its top 36 px below the square's top (`PerchShiftX`, `PerchShiftY` in `app/Capri.cs`). That gives two frame widths with the seat in a different spot:

| Frame width | Sheets | Seat (x, y in the frame) |
| --- | --- | --- |
| 196 | `perch`, `perch_blink`, `perch_blink_glitch`, `perch_music` | 47, 267 |
| 288 | `perch_glitch`, `perch_arrive`, `perch_leave` | 93, 267 |

The templates already draw this, so just follow the red cross. If 60 frames is too much to draw, a sitting or lying sheet can have 16 at 8 fps instead, and a blink 4: the build works it out from the sheet's width. Talia's are set up this way, see "Her shorter sheets" in `characters/talia/NOTES.md`.

### Lying frames (since 0.7.7)

After sitting quietly a few minutes on a ledge with room, she glitches into lying along it, hair and an arm off one end and legs off the other. The cells are 250 px high, centred across her 384 px square and starting 161 px down it (`LieShiftY`, `LieHeight`). Her hip sits on the same seat row as the perch, at `LieRight` (0.806) of the square, so her body reaches back along the ledge from it:

| Frame width | Sheets | Hip (x, y in the frame) |
| --- | --- | --- |
| 372 | `laydown`, `laydown_talk`, `laydown_blink`, `laydown_blink_glitch`, `laydown_sleep` | 303, 142 |
| 440 | `laydown_glitch`, `laydown_leave` | 337, 142 |

The blink uses `PerchBlinkFrom` (28) like the perch. All of these load only while she lies, so they can wait until last.

**Facing left (optional):** the app can show separate facing-left perch frames, named like `perch_flipped.png` with the same size, for art that doesn't mirror well (Capri's red arm and leg swap sides). Without them it just mirrors. Since 0.7.7 Capri ships flipped sets for every perch and lie-down sheet. Lucy probably doesn't need them.

Frame counts and fps can change: if Lucy's idle works better with 12 frames, that's one number in `app/Capri.cs` (search `new Clip(`). Write the new count here so we remember.

## Mouth shapes

| Frame | Shape | Used for |
| --- | --- | --- |
| 0 | closed | m, b, p, pauses |
| 1 | small | most consonants |
| 2 | small, a little different | i, u, y and other consonants |
| 3 | open | a, e, o |
| 4 | wide | shouted (capital) a, e, o |

Once your first idle frame exists, draw a box around her mouth on your own layer. All idle frames and all 5 mouth frames keep the mouth inside it.

## Order that makes sense

1. One `idle` frame and one `perch` frame, then test them in the app before drawing more
2. All of `idle`, then `mouth` and `blink`. With these she already works for everyday use
3. `perch` and `perch_blink`, then `perch_music` and `perch_talk`
4. `walk`, `arrive`, `leave`, `perch_arrive`, `perch_leave`
5. The rest, with the `laydown_*` set last. Any sheet you haven't drawn yet stays Capri's for now

## If she doesn't fit

Lucy is shaped differently from Capri. If her feet, seat or grab area don't line up with the guides, that's fine: the numbers live in `app/Capri.cs` (`StandY`, `SitRight`, `SitY`, `BodyRight`, `PerchedRight`) and can be changed to fit her. Then change the same numbers in `make-templates.ps1` and run it to remake the templates:

`powershell -File characters\lucy\make-templates.ps1 -Out characters\lucy\templates`
