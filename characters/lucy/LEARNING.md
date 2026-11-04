# Learning log

One short entry per change: what changed, why, and one idea worth knowing. Newest at the top.
Read one when you have 10 minutes. If something doesn't click, ask Claude about that entry.

---

## 4 Nov: 58 of Lachy's updates come in

**What changed:** the daily Sync upstream run had been failing, so the fork had fallen 58 commits behind Lachy. This merges them by hand. The new things are mods (a Mods tab and a gallery, plus code mods and skin mods), Code/Husk Mode (she acts out what Claude Code and Codex are doing), calls that feel more like calls, her Settings window on Mac and Linux, any OpenAI-compatible provider with a key, a note saying why she closed if she closes by herself, and a Meta Quest port in `quest/`.

**The three conflicts:** `README.md` stayed ours. In `ci/build-windows.ps1` we took Lachy's list of files and put `'Character', 'YouTubeMusic'` and the `if ($Character)` line back. In `cross/Capri.Cross.csproj` we kept both sides. `Safety` in `app/Brain.cs` is word for word what it was.

**Idea: a rule that still matches isn't the same as a name that's covered.** The build warns when a line in `names.txt` or `app.txt` no longer finds its words, and all 61 still do. But it can't warn about words that are new. Some of Lachy's new text says Capri and has no rule yet, like "Import a Capri mod" and "Capri closed unexpectedly", so Talia's build shows those for now. Which of them to change is the owner's call, so none were added here.

---

## 2 Nov: room for Talia, and the rename

**What changed:** the repo is now Edgerunners Desktop Companions, and Talia has her own folder, `characters/talia`. A `-Character talia` build shows her name and says her own lines. Every character's build is now called Edgerunners Desktop, and the release workflow is `release.yml`, which asks which characters to build.

**Why the lines moved:** `app/Character.cs` held Lucy's lines, and every build used that file, so Talia would have talked like Lucy. Now each character has her own `Character.cs`, and the build uses it in place of the one in `app/`. That file went back to Capri's words, so a plain build is plain Capri again. The swap is in `Use-Character.ps1` on Windows and `cross/Capri.Cross.csproj` on Mac and Linux.

**Why the installer name has her name in it:** all characters share one list of releases, and the updater picks an installer by its name. If they all had the same name, Lucy's install could update itself into Talia. So the name is in each character's `names.txt`, not the shared `app.txt`. It has one catch: once a character has a release, she needs to be in every later one too, or her installs find nothing to update to.

**Why the workflows had to change with the rename:** both start with "only run if this repo is `vin-Sz/lucy-desktop`". After a rename that's false, and GitHub just skips the job with no error, so the Capri sync would have quietly stopped until someone noticed.

**Idea: keep what's shared apart from what's hers.** The app's name, settings folder and updater are the same for everyone, so they're in one file. Her name, lines, art and personality are hers, so they're in her folder. Adding a third character now only means adding a folder.

**Why Talia isn't written like Lucy:** she's a teenager in the show, so she's a friend and nothing romantic. Her draft says so outright, and Lucy's "good boy" line stays out.

**Not done: her personality isn't built in.** A Talia build still starts as "You are Capri" until you paste `characters/talia/personality.md` in through YOU > Personality. Building it in also means updating the self-test's fingerprint, so that's best done once her text is final.

**Checked:** all four builds compile (`-Character talia`, `-Character lucy`, plain Capri, and Mac/Linux with Talia). The self-test and the release workflow haven't been run.

---

## 2 Nov: merging Capri 0.7.10

**What changed:** 30 of Lachy's commits came in. Check-ins now show in her bubble and speak, she lies on the taskbar instead of floating above it, clicks go through her over full-screen games, she can watch your screen while listening and comment in your language, and there's a long list of fixes (Gemini keys, Discord deafen, clearing her drawings, idle CPU).

Two files conflicted, and the answer in both was "keep both":

- `app/Player.cs`: Lachy split `SendToSession` in two, so a key press always waits a beat afterwards (`Pressed()`). Our one YouTube Music line was sitting right at the split. It moved into the new `SendNow`, so a like still reaches YouTube Music and gets the same beat.
- `cross/Smoke.cs` (the Mac and Linux self-test): Lachy added a check that she recognises herself in screenshots. In the same spot, Capri's self-test has a check that says "no personality.md to edit", and ours tests `personality.md`. We keep the new check and our personality test, and drop the "no personality.md" check, because for Lucy it isn't true.

**Idea: a clean merge isn't the same as a correct one.** Git only spots two edits to the same lines. It can't tell that a change broke something a file away. So after a merge, I also check what Git can't see: is her personality text unchanged (it is, so her fingerprint is still right), and did all her name swaps still find their phrases?

**Not done: on Mac and Linux she's told she's Capri with red hair.** This update's new line says "the small red-haired anime girl with a speech bubble is you, Capri", so she knows not to describe herself in screenshots. It's only in the Mac and Linux code. Those builds don't get her name swaps (`names.txt` only covers the Windows copy), so Lucy on those systems gets that line as written. Her Windows build isn't affected.

**Checked:** all three builds compile (plain Capri, `-Character lucy`, and Mac/Linux). The self-test is yours to run.

---

## 1 Nov: merging Capri 0.7.9

**What changed:** 37 of Lachy's commits came in. The big one is **chaos mode** (`app/Clones.cs`, new): she copies herself across your desktop, the copies keep doubling, drag your windows around, and holding Esc puts everything back. It's marked beta. Also: she draws diagrams and talks you through them, her Discord status moves, she reads her own clock when you ask the time, and a pile of fixes for freezing and quitting.

Only one file conflicted: `ci/build-windows.ps1`, the build's guest list again. He added `Clones` to his list. Ours has `Character` and `YouTubeMusic` in it. The fix is both: our list with `Clones` added, and our `-Character` line kept.

**Idea: new code can wear her art for free.** The clones don't load pictures of their own. They're handed the same idle, walk, grin and glitch animations she uses. Our build swaps Capri's sprite sheets for Lucy's before anything else sees them, so the clones show up as Lucy without us touching `Clones.cs`. When you swap things at the bottom layer, new features built on top get your version too.

**Not done: her Discord status still looks like Capri.** Lucy uses Capri's Discord app, so it already said "Playing Capri" before this update. Now it also shows his moving GIFs from his website (`site/assets/presence/`). Changing that means making our own Discord app and hosting Lucy's GIFs somewhere public. It's a job for when her art is done.

**Checked:** both builds compile (plain Capri and `-Character lucy`), and the Lucy build found all 136 of her name swaps. The self-test is yours to run.

---

## 1 Nov: merging Capri 0.7.8

**What changed:** about 180 of Lachy's commits came in (streaming, Gaming Mode, chess, drawing on screen, reminders, file reading and more). Git merged most of it by itself. Five files had conflicts, where we and Lachy had both changed the same lines:

- `app/Capri.cs`: her pop-up lines stay `Character.PopLines` (he added four new Capri lines; Lucy keeps hers). His new reminders line and our `personality.md` lines both stay.
- `app/Hands.cs`: two tool descriptions. We take his new "which browser" option for `open_website`, and keep our like/unlike for `media`.
- `app/Mainframe.cs`: the Obsidian hint takes his new "that vault wasn't there" message but keeps our note name. His new memory-size and reply-length settings sit next to our personality row.
- `ci/build-windows.ps1`: his list of new files, plus our `Character` and `YouTubeMusic`, plus our `-Character` line.
- `README.md`: ours, since it describes the fork.

**Idea: a test that guards a fingerprint.** Lachy rewrote part of her default personality. Our self-test checks it by its *SHA-256*: a short code worked out from the text, which changes completely if even one letter does. So the new text needed its new code (`todaysPersona`, and her length is now 6964 characters). In `Brain.cs`, `DefaultStamp` is a shorter fingerprint of the same text, so it changed too. The old one went into `Retired`. That list is how she knows an untouched old `personality.md` is safe to update to the new default, while one you edited stays yours.

**Idea: "point, don't move" paid off.** The `PopLines` conflict was one line, and the fix was obvious. That's what the 31 Oct entry was about.

---

## 1 Nov: the app becomes Lucy Desktop, with its own releases

**What changed:** a `-Character lucy` build is now its own app, **Lucy Desktop**, not a Capri in disguise. It has its own settings folder, autostart entry, Start menu entry and uninstall entry, so it runs next to your real Capri without either one noticing. Its updater looks at *your* GitHub releases, and the **Release Lucy Desktop** button on GitHub (Actions tab) makes one. Details are under "Releases" in `NOTES.md`.

**Why the app has a name of its own, apart from the character:** the character is a skin (art, name, lines, voice). The app is the program, with your own features in it. If the settings folder were named after the character, switching characters would lose your settings. So the app is always Lucy Desktop, and the character inside can change.

**Idea: identity is more than the name you see.** Windows tells programs apart by things you never see: the folder they keep settings in, the name of their autostart entry, the name of a *mutex* (a lock that makes sure only one copy runs: start Capri twice and the second one just wakes the first). If two apps share these, they fight over them. That's why `characters/app.txt` renames those, not just the words on screen.

**Idea: versions are compared number by number.** `0.7.7.2` is newer than `0.7.7.1`, and `0.7.8.1` is newer than both, because the third number is checked before the fourth. That's why our releases add a fourth number to Capri's: Capri's numbers only go up, so ours do too. The release workflow also writes that number into the program itself, so an installed copy knows it's `0.7.7.1` and doesn't offer itself as an update.

**Idea: checksums.** A checksum (SHA-256) is a fingerprint of a file: change one byte and it's completely different. The release lists the installer's fingerprint in `SHA256SUMS.txt`, and the updater only runs a download whose fingerprint matches. That way a broken or swapped download never runs. (Lachy also *signs* his, which proves who made it. That costs money, so ours uses the checksum alone.)

---

## 1 Nov: building Lucy with `-Character lucy`

**What changed:** `ci/build-windows.ps1 -Character lucy` builds *Lucy*. Each drawing you put in `characters/lucy/sprites/` (same name as Capri's, like `idle.png`) replaces Capri's, and the rest stays Capri's. Her name replaces Capri's in 42 places you see: menus, tray, talk box, messages. Without `-Character`, the build is plain Capri, like Lachy's.

**Idea: change a copy, not the original.** For her name, the build copies the code into the output folder, swaps the phrases from `characters/lucy/names.txt` in the *copy*, and compiles that. Lachy's files never change, so a sync can't conflict over her name. That's the hook idea taken one step further: here there's no hook in his code at all, except the one line that calls our script. One catch: a compile error then points at the copy (`out\...\character-lucy\Talk.cs`). Fix it in `app\`, not in the copy.

**Idea: fail early, with a reason.** Her animations cut each sheet into frames using sizes fixed in the code. A sheet of the wrong size wouldn't crash; she'd just look broken in a confusing way. So the build checks each drawing's size first and stops with "idle.png is 900x384 px, but Capri's is 960x384". Checking right where the mistake comes in is much kinder than finding it later.

**Idea: dot-sourcing.** `. script.ps1` (with a dot and a space in front) runs a PowerShell script *inside* the one that called it, so it can change that script's variables (`$resources`, `$sources`). Without the dot, a script gets its own private variables.

**Why not "Capri Mainframe" yet:** those words are also in her prompt, and the self-test checks her prompt's fingerprint (a SHA-256). Changing it now would make the self-test stop there. It changes together with her personality.

**Try it (optional):** add a line to `names.txt`, like `"Capri is asleep" => "Lucy is asleep"` (find a real phrase with Ctrl+Shift+F in `app\`), then build with `-Character lucy`. Then add one with a typo on the left and read the warning the build gives.

---

## 31 Oct: YouTube Music support (`app/YouTubeMusic.cs`)

**What changed:** the Music Bar's heart works for YouTube Music for Desktop. "Like this song" works in chat for it and for Spotify. "Play numb on YouTube Music" plays in the app. "Open the player" finds its window.

**Idea: an API is a door an app leaves open for other programs.** Spotify has none for likes, so Lachy's code finds Spotify's heart button on screen (UI Automation) or presses its keyboard shortcut. Your YouTube Music app has a small web server built in, on `http://127.0.0.1:13091`. `127.0.0.1` means "this PC", so nothing goes to the internet. Lucy sends it requests like `POST /track/like` with `true`, and it answers. That's sturdier than clicking buttons, which break when an app moves them.

**Idea: GET asks, POST does.** `GET /track/state` only asks ("is this song liked?"). `POST /track/like` changes something. Most web APIs follow this split.

**Idea: hooks, in practice.** Lachy's files got small changes like these:
- `Player.cs`: a new `Hearts` (Spotify *or* YouTube Music) in the places that used to say `Spotify` for the heart. Plus one line each in like and open: "if it's YouTube Music, ask `YouTubeMusic.cs`".
- `Hands.cs`: "youtube music" added next to "youtube" in two patterns, plus a few one-line "ask `YouTubeMusic.cs`" lines.
- `Capri.cs`: the self-test calls `YouTubeMusic.Check()`. The real checks live in our file.

**Idea: tests swap out the real world.** `YouTubeMusic.Call` is a *variable holding a function*. Normally it holds `Ask`, which really talks to the app. The self-test puts a fake in it that writes down what was sent and gives canned answers. So the test checks Lucy's side without needing the app, the internet or a real song. Lachy's code does the same with `Hands.Run` and `Tunes.Send`.

**Idea: `@"..."` strings.** In a normal C# string, `\` starts a code like `\n` (new line). Regex patterns are full of `\s` and `\d`, so they use `@"..."`, where `\` is just `\`. I forgot one `@`, and the compiler said "unrecognized escape sequence". Same lesson as last time: read the error's line and column, then look right there.

**Try it (optional):** in `YouTubeMusic.cs`, find `Liking`. Add your own way of saying it, like `love` next to `like|heart`. Then add a line for it to the `asks` list in `Check()`, so the self-test checks it too.

---

## Why: Lucy's code goes in Lucy's files, even when Capri has the same thing built in

You asked: Spotify support is inside `Player.cs`, so why does YouTube Music get its own file?

**Because `Player.cs` is Lachy's.** He wrote it and keeps changing it, and every sync brings his changes into our copy. If our code sits inside his file, sooner or later his change lands right next to ours and Git can't choose: a merge conflict, in code you didn't write.

**So the rule for this fork:** Lucy's code goes in files Lachy doesn't have (`Character.cs`, `YouTubeMusic.cs`). His files only get small *hooks*, one line saying "ask our file". If a hook ever conflicts, it's one obvious line.

**The cost:** it's less tidy. Spotify is in one place and YouTube Music in another. In a single project you'd put them together. In a fork that keeps pulling updates, staying out of the owner's way matters more, especially when capri-desktop's team ships features you'll want too.

**When it changes:** if Lachy takes a feature into capri-desktop, it becomes his code and he decides where it goes. Our file then goes away.

---

## 31 Oct: her other lines move into `Character.cs`

**What changed:** her "no" line, her error line, her Halloween lines and the `LUCY: ` name in her chat log now come from `app/Character.cs`. The Mac/Linux app uses the same file now too (`cross/Capri.Cross.csproj` got one line saying "also compile `Character.cs`").

**Idea: the same name can mean two things.** Lachy's `Brain` class already has something called `Character` (her whole prompt). Inside `Brain`, the word `Character` means *that one*, so the compiler said "a string has no `Declined`". Writing the full name, `CapriDesktop.Character.Declined`, says "the `Character` class in the `CapriDesktop` namespace", which is ours. It's like two people called Alex in one room: you add the family name.

**Idea: `const` vs `static readonly`.** Both mean "never changes". `const` is baked in when the app is built, and only works for simple values like text and numbers. `static readonly` is set once when the app starts, and works for anything, like a list of lines. `Brain.Declined` was a `const`, so Lucy's version has to be a `const` too.

**Try it (optional):** open `app/Character.cs`, change a word in one `PopLines` line, and run `ci/build-windows.ps1`. Then break it on purpose (delete a `"`) and read the error. Change it back after.

---

## 31 Oct: her pop-up lines move into `Character.cs`

**What changed:** the six things she says when she pops in now live in `app/Character.cs`. In `app/Capri.cs`, the old list became one line: `PopLines = Character.PopLines;`.

**Idea: point, don't move.** Lachy keeps updating `Capri.cs`, and a sync merges his changes into ours. If we both change the same lines, Git can't choose (a *merge conflict*). Deleting his list and editing every place that used it would touch many lines. Instead, his list stays but points at ours, so only one line differs from his. If a sync ever conflicts there, the fix is obvious.

**Idea: the build has a guest list.** `ci/build-windows.ps1` only compiles the files it names. A new `.cs` file does nothing until it's added to `$sources`.
