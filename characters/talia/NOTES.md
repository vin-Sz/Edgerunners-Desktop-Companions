# Talia: plan and notes

Everything Talia-specific lives in this folder, the same way as `characters/lucy`. How building and releasing work is in [Lucy's notes](../lucy/NOTES.md).

## What's here

| File | What it is |
| --- | --- |
| `personality.md` | Her personality. A `-Character talia` build on Windows makes it her default, because `builtin-personality.txt` is here. Mac and Linux builds don't have this yet |
| `Character.cs` | Her lines from the code (pop-ups, Halloween, her "no", her error line). Used in place of `app/Character.cs` |
| `names.txt` | Her name where you see it, and her installer's name |
| `checks.txt` | The self-test's checks of Capri's personality, changed in a copy of the code to fit Talia's text |
| `CAPRI-LEFTOVERS.md` | What she inherited from Capri that may not suit her, with decisions waiting. Read it before drawing |
| `krita/` | One ready-to-draw `.kra` per animation. Remake with `powershell -File characters\lucy\make-krita-files.ps1 -Out characters\talia\krita -Character Talia` |
| `templates/` | Her shorter sitting and lying sheets (see below). They take the place of the same files in `characters/lucy/templates` |
| `sprites/` | *(later)* her animations, same file names as `assets/sprites`, and the same sizes apart from her shorter sheets. `characters/lucy/ART.md` and `characters/lucy/templates` apply to her too |
| `voice/` | *(later)* her spoken greetings |
| `icon.ico`, `icon.png` | *(later)* her icon |

## Plan

- [x] Her folder, her name and her own lines in a `-Character talia` build
- [x] Research her (`reports/Talia Yang personality and voice.md`). Its speech analysis leans on one unofficial transcript of one episode, and nobody compiling it watched the show, so what you saw wins
- [x] Second draft of `personality.md` and her lines, from that research and your answers: she talks about her family and illness, and she knows Capri
- [x] Where she is on the show's timeline: kept vague on purpose. She knows her history but doesn't say how it ended, so she keeps her chrome jokes and doesn't spoil the finale
- [x] Build the personality in as her default (4 Nov). Not checked against the show on purpose: you chose not to rewatch E02 and E07, so her teasing and her bickering with Capri rest on the research. If something sounds wrong when you do talk to her, say so and it gets fixed
- [x] Self-test on GitHub instead of your PC: the **Talia self-test** Action runs when `characters/` or `ci/` changes
- [ ] Her art and icon
- [ ] Her voice: later, on purpose. It's the least important part for now
- [ ] "Capri Mainframe" and "Hey Capri": still Capri's, for the same reasons as in Lucy's notes

## Her shorter sheets

You chose 16 frames at 8 a second for sitting and lying (4 Nov), which is what Capri's sitting art used to be. These are the numbers to use in place of the ones in `characters/lucy/ART.md`:

| Sheets | Frames and speed | One sheet's size in the app | Notes |
| --- | --- | --- | --- |
| `perch`, `perch_talk`, `perch_music` | 16 at 8 a second | 3136×384 | A 2-second loop, the same length as Capri's |
| `perch_blink`, `perch_blink_glitch` | 4 at 8 a second | 784×384 | Frames 0–3 replace `perch` frames 9–12 |
| `laydown`, `laydown_talk`, `laydown_sleep` | 16 at 8 a second | 5952×250 | A 2-second loop |
| `laydown_blink`, `laydown_blink_glitch` | 4 at 8 a second | 1488×250 | Frames 0–3 replace `laydown` frames 9–12 |

Her Krita files are already these shapes, at twice the size. A sheet of hers uses the new numbers from the moment it goes in, and any sheet you haven't drawn stays Capri's 60 frames, so sitting and lying can look uneven until a set is finished. The "perch fps" slider does nothing to a 16-frame sheet.

## One rule that stays

She's a teenager in the show, so she's a friend and nothing else: no flirting or romance in her personality or lines, and her art stays non-sexual. The app's fixed safety lines also rule out anything sexual or romantic. Don't copy Lucy's "good boy" line into her personality. Lachy's own "good boy" lines for people who tip, in the game and stream instructions (`app/Computer.cs`), are supposed to stay.

Her age isn't stated outright in the show. One guide works it out as 16, from her saying she's a teenager and being called a kid, and fans guess 14 to 19. So her prompt says teenager, without a number.

**Why her jokes have a limit:** her best-documented humour is about her own death. On a companion that could hit someone who's really struggling, so the joke only ever points at her, and she drops it if they sound down.
