# Lucy: plan and notes

Everything Lucy-specific lives in this folder, so syncing updates from capri-desktop stays easy.
The folder is named `characters/lucy` so other characters (even Capri) could sit next to her later.

## What's here

| File | What it is |
| --- | --- |
| `personality.md` | Her personality, as plain text in markdown. It becomes `DefaultPersonality` in `app/Brain.cs` |
| `lines.md` | Her netrunner tags and the lines Capri says straight from the code, rewritten for Lucy |
| `ART.md` | Everything her drawings must match, animation by animation |
| `LEARNING.md` | One short entry per code change: what, why, and one idea worth knowing |
| `templates/` | Guide images to draw on, one per animation (made by `make-templates.ps1`) |
| `sprites/` | *(later)* her animations, same file names and sizes as `assets/sprites` |
| `voice/` | *(later)* her spoken greetings |
| `icon.ico`, `icon.png` | *(later)* her icon |

## Plan

**Step 1: this folder** *(now)*
- [x] Draft her personality
- [x] Draft her lines and netrunner tags
- [x] Bring back an editable `personality.md` (Capri 0.7.6 dropped it), with `Safety` still fixed in code after it
- [ ] Try the personality in the real app and tweak it: YOU > Personality > Edit personality.md, paste this folder's `personality.md` in and save

- [x] Sync the big capri-desktop patch (0.7.6, 30 Oct) before changing any app code
- [x] Sync capri-desktop 0.7.7 (30 Oct): lie-down set, perch talking frames, Halloween lines, donation lines
- [x] A GitHub Action (`.github/workflows/sync-upstream.yml`) that merges capri-desktop into `main` when it updates

**Step 2: art and voice**
- [x] Build script: `ci/build-windows.ps1 -Character lucy` (Mac/Linux: `dotnet build -p:Character=lucy`) takes each file in `sprites/` and `voice/` here, and `icon.ico`, when it's there and Capri's otherwise, so sprites can be swapped one at a time. A sheet of the wrong size stops the build with a message (`characters/Use-Character.ps1`). Not yet: the installer's `chip.png`, and the Mac/Linux icon
- [x] Check the sprite list and sizes again after the patch: the perch is new (60 frames, narrower frames) and `perch_music` was added. `ART.md` and the templates are updated
- [x] Again for 0.7.7: `perch_talk` and seven `laydown_*` sheets (372 or 440 × 250 px). `ART.md` and the templates are updated
- [ ] Lucy's art, voice and icon

**Step 3: text in the app**
- [x] `characters/lucy/Character.cs` holding her lines, used in place of `app/Character.cs` (Capri's lines, for a plain build), with one-line pointers in Capri's files (`Brain.cs`, `Capri.cs`, `Talk.cs`, and `cross/Pet.cs`, `cross/Talk.cs` for Mac/Linux): pop-ups, Halloween, her "no", her error line, `LUCY: ` in her chat log
- [ ] Her lines still waiting for your OK: the drafts at the top of `lines.md` (Cyberpunk spotted, lag)
- [ ] Her personality in `Character.cs` too, once you've tried it in the app (the item in Step 1). Her prompt also says "a glitch tag like [SIGNAL CORRUPTED]" (`Brain.cs`), which changes with it
- [ ] Update the personality checks in the smoke test (`Capri.cs`): `todaysPersona` (a SHA-256 of the whole prompt) and its length, 5659 since 0.7.7, next to it, and the check a little before it that looks for Capri phrases like "a playful chaos gremlin". Also any tests that check lines word for word
- [ ] Leave `Safety` and `Machinery` in `Brain.cs` as they are: Lachy asks forks to keep her safety rules. `Safety` has a little Capri wording ("your chaos lives on the screen"); decide later whether that's fine for Lucy or worth asking Lachy about
- [ ] "Hey Capri" → "Hey Lucy" (see `lines.md`)
- [x] Her name in menus, the tray, her talk box, the mini player and messages: `names.txt` here, applied by `-Character lucy` to a copy of the code, so Capri's files don't change. Windows only for now
- [ ] "Capri Mainframe" → "Lucy Mainframe": it's in her prompt too, so it goes with her personality (the self-test checks the prompt)
- [ ] The installer's names (`Setup.cs`, its own build line)
- [x] **The app's own identity: Edgerunners Desktop** (`characters/app.txt`, used by every `-Character` build, whichever character it wears). Settings and install in `%LOCALAPPDATA%\Edgerunners Desktop`, its own autostart entry, Start menu shortcut, uninstall entry and single-copy lock, so it runs next to a real Capri without touching it. Updates come from this repository's releases. Still Capri's on purpose: the file name `Capri.exe`, her voice pack and HD voice downloads, and links to Lachy's website. Windows only; Mac/Linux still use Capri's
- [ ] Not yet renamed: the speaker "Capri" in her chat history (`Brain.cs` `Transcribe`), which the self-test may check

## Releases

- **Make one:** GitHub → Actions → **Release** → Run workflow, with the characters (`talia` by default) and the number (1 for the first). GitHub builds each one and publishes `EdgerunnersDesktop-Talia-Setup-<version>.exe` (and so on) and `SHA256SUMS.txt` (`.github/workflows/release.yml`). Not run yet: the first run is its test
- **Each character updates to her own installer:** the name comes from her `names.txt`. So once a character has a release, keep naming her in new ones, or her installs have nothing to update to
- **Versions:** Capri's version plus our own fourth number: `0.7.7.1`, `0.7.7.2`, … and after a Capri update `0.7.8.1`. Each one is newer than all before it, so the updater always offers the latest
- **The updater** in an installed Edgerunners Desktop checks this repository's latest release every few hours. It only takes an installer whose checksum matches `SHA256SUMS.txt`, since ours isn't signed like Lachy's
- **Until the first release** it says "Couldn't check for updates" in Mainframe, because there's nothing to find yet
- **Windows will warn** ("Windows protected your PC", unknown publisher) the first time someone runs the installer, because it isn't signed. More info → Run anyway. Signing costs money every year; not worth it for a fan project unless you share it widely
- **Don't release before** the self-test passes with `-Character talia`, or whichever characters you're releasing
- [x] The Obsidian vault note is `Lucy Memories.md` (`Character.VaultNote`)

**YouTube Music** (`app/YouTubeMusic.cs`, for YouTube Music for Desktop / ytmdesktop2)
- [x] Mini player heart, "like this song" (also for Spotify), "play X on YouTube Music", "Open the player" for its window
- [ ] Turn on its API: in YouTube Music for Desktop's settings, the API section (port 13091, no login needed). Without it the heart won't stick and songs open on youtube.com instead
- [ ] Try it for real and run the self-test. Not checked yet: that Windows calls its media session `net.venipa.ytmdesktop` (if not, the heart won't show for it, and `Owns` needs the right name), and that starting it again brings its window up from the tray
- [ ] Not yet: "like this song" in ElevenLabs voice chat (Agent.cs has its own tool list), and "play X" without saying YouTube Music still goes to Spotify. Making YouTube Music your default is one small change, if you want it
- [ ] Maybe offer it to Lachy for capri-desktop; then it's his code, and our file goes away

**Later, maybe**
- [ ] Netrunner look in place of Capri's glitch effects, like the crimson tendrils when she starts (`Tendrils` in `Talk.cs`)
- [ ] Choosing the character inside the app instead of when building

## Notes

- **Sprites** (capri-desktop 0.7.7): every animation is one row of frames, 384 px tall except lying down (250 px). Standing frames are 240 px wide; sitting (`perch_*`) frames are 196 or 288 px wide; lying (`laydown_*`) frames are 372 or 440 px wide (see `ART.md`). Frame counts are set in `app/Capri.cs` (search `new Clip(`).
- **Personality:** Capri 0.7.6 fixed her personality in code, because her safety lines had moved into `personality.md` in 0.7.5 and anyone could delete them there. Lucy brings the file back (next to `me.md`, with a Personality menu in the YOU band on Windows and two settings menu items on Mac/Linux), but her prompt is `personality.md` + `Safety` + `Machinery`: the safety lines stay fixed in code after whatever the file says. A missing, empty or unreadable file gives `DefaultPersonality`. When `DefaultPersonality` changes, the smoke test asks for its new `DefaultStamp` and the old stamp goes into `Retired`, so untouched copies of the file move to the new default while edits are kept.
- **Upstream merges:** this touches the same spots as Lachy's code (`Brain.cs` near `Persona`, the YOU band in `Mainframe.cs`, the personality check in the smoke test), so a capri-desktop sync that changes those may conflict and need merging by hand.
- **How the art gets in:** `ci/build-windows.ps1` packs `assets/sprites`, `assets/voice` and the icon into the .exe when building. The app doesn't read them from a folder.
- **Syncing:** the Sync upstream Action checks capri-desktop once a day and merges it into `main` through `ci/merge-capri.ps1`, which fixes the conflicts that keep coming back and only pushes a merge that compiles. If it can't, the run goes red and its summary page says why; then run the script in a clean worktree and fix what it lists. After a sync, check `ART.md`, `lines.md` and this file against what changed.
- **Testing:** the smoke test (`powershell -ExecutionPolicy Bypass -File ciuild-windows.ps1 -SmokeTest -SmokeSeconds 180`) runs hundreds of checks on the real app and stops at the first failure. It's how we'll know Lucy's changes didn't break anything, but three things get in the way today (checked 30 Oct, 0.7.7):
  - On a German Windows it stops at "Crash recovery", and at a second crash-log check after it: both look for the English `at CapriDesktop.` in the error log, and German Windows writes `bei CapriDesktop.`. Not an app bug. Worth telling Lachy, so the fix lands upstream and not as a fork-only change that could conflict. With both loosened in a throwaway copy, "Her voice server took over 30 s" failed once and passed on a rerun (flaky), and the full run needs internet for her speech model
  - The CI workflow's Windows job fails upstream too (23 of 30 runs), on GitHub's machine with no sound, mic or GPU. Turn it off under Actions → CI → ⋯ → Disable workflow (no file change, so no merge conflicts) so syncs don't send failure emails, and back on when Lucy has code of her own
  - Many checks expect Capri word for word: her personality's SHA-256 and length, her lines, sprite frame counts like `PerchBlinkFrom`. Every Lucy change to those needs its check changed in the same commit
