# Talia: plan and notes

Everything Talia-specific lives in this folder, the same way as `characters/lucy`. How building and releasing work is in [Lucy's notes](../lucy/NOTES.md).

## What's here

| File | What it is |
| --- | --- |
| `personality.md` | Her personality, first draft. Not built in yet: paste it in through YOU > Personality |
| `Character.cs` | Her lines from the code (pop-ups, Halloween, her "no", her error line), first drafts. Used in place of `app/Character.cs` |
| `names.txt` | Her name where you see it, and her installer's name |
| `krita/` | One ready-to-draw `.kra` per animation. Remake with `powershell -File characters\lucy\make-krita-files.ps1 -Out characters\talia\krita -Character Talia` |
| `sprites/` | *(later)* her animations, same file names and sizes as `assets/sprites`. `characters/lucy/ART.md` and `characters/lucy/templates` apply to her too |
| `voice/` | *(later)* her spoken greetings |
| `icon.ico`, `icon.png` | *(later)* her icon |

## Plan

- [x] Her folder, her name and her own lines in a `-Character talia` build
- [x] Research her (`reports/Talia Yang personality and voice.md`). Its speech analysis leans on one unofficial transcript of one episode, and nobody compiling it watched the show, so what you saw wins
- [x] Second draft of `personality.md` and her lines, from that research and your answers: she talks about her family and illness, and she knows Capri
- [ ] Check the draft against the show: E02 for her teasing, E07 for how she bickers with Capri
- [x] Where she is on the show's timeline: kept vague on purpose. She knows her history but doesn't say how it ended, so she keeps her chrome jokes and doesn't spoil the finale
- [ ] Try the personality in the real app, then build it in as her default
- [ ] Her art, voice and icon
- [ ] "Capri Mainframe" and "Hey Capri": still Capri's, for the same reasons as in Lucy's notes

## One rule that stays

She's a teenager in the show, so she's a friend and nothing else: no flirting or romance in her personality or lines, and her art stays non-sexual. The app's fixed safety lines also rule out anything sexual or romantic. Don't copy Lucy's "good boy" line over.

Her age isn't stated outright in the show. One guide works it out as 16, from her saying she's a teenager and being called a kid, and fans guess 14 to 19. So her prompt says teenager, without a number.

**Why her jokes have a limit:** her best-documented humour is about her own death. On a companion that could hit someone who's really struggling, so the joke only ever points at her, and she drops it if they sound down.
