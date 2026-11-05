# Learning log

One short entry per change: what changed, why, and one idea worth knowing. Newest at the top.
Read one when you have 10 minutes. If something doesn't click, ask Claude about that entry.

---

## 5 Nov: Do Lachy's mods make Talia's branch useless?

**Answer: no.** A mod can change how she looks and add names she answers to. It can't make her a different character. This comes from reading the code in Capri 0.8.3 (`app/Mods.cs`, `app/SkinMods.cs`, `app/CodeMods.cs`). Nothing was run.

| What Talia needs | Mod | Our branch |
| --- | --- | --- |
| Her art | Yes, a skin, on Windows, Mac and Linux | Yes, Windows only so far |
| Her 16-frame sitting and lying sheets | No. A skin's sheets must be exactly Capri's size | Yes |
| Mirroring her when she faces left | No. A skin has to include all 15 left-facing sheets | Yes |
| Answering to "Talia" | Yes, a settings mod with `wake_names` | Not yet (still "Hey Capri") |
| Her personality as the default | No. People would paste it in by hand | Yes |
| Her own lines (`Character.cs`), name in menus, icon, greetings | No | Yes |
| Her own memory and chats | No | Yes |
| Installing beside a real Capri, with her own updates | No. She'd be a costume on Capri | Yes |
| Fixing "You are Capri" in the app's prompts | No | Possible, waiting on your decision |

**The three kinds of mod:**
- **Settings mod (`.capri-mod`):** extra names, spellings of those names, and colours. The app tells her the extra names are nicknames, so she'd still be Capri, answering to Talia as well.
- **Skin (`.capri-skin`):** a zip of pictures with the same names as Capri's sheets. Only pictures are accepted, so no voice and no icon.
- **Code mod (`.capri-code`):** C# that the app compiles and runs, Windows only. Its official tools are small: say a line, write to the log, load art, play one of five sounds, play an intro. It has no way to change her prompt. It runs with full access to the PC, so it could probably reach inside the app and swap her personality anyway, but I haven't tried that. It would be a hack that any Lachy update could break, and everyone installing it would have to approve a mod that can do anything on their PC.

**What mods do better:** no merging at all. Someone on official Capri would get Lachy's updates straight away, and a skin works on Mac and Linux, where our character swap doesn't exist yet.

**Your art isn't locked in:** a small script could later turn her finished sheets into a skin, by repeating frames to reach 60 and mirroring for the left-facing ones. That's an estimate: the 16-to-60 stretch would be slightly uneven, and I haven't built it. Nothing needs doing now, since there's no finished art yet.

**Things I noticed and left alone:**
- **Talia's build gets the mods window too, pointed at Lachy's directory.** So someone using Talia can install the Maid Suit skin, or anything else made for Capri. I haven't looked at that skin's pictures, so whether it fits "her art stays non-sexual" is unchecked. Hiding skins or the directory in her build is your call.
- **A skin made for Capri stops fitting once her 16-frame sheets are in.** The app would refuse it with a "has to match hers" message, which is safe, just a bit confusing.
- **Lachy's mods repo already mentions a fourth kind, skills, for 0.8.4.** That's not out yet and isn't in this update.

**One idea worth knowing:** a mod system only opens the doors its author chose to open. Lachy opened looks, names and sounds, and kept who she is in the code. So the question to ask of any mod system isn't "how powerful is it?" but "is the thing I want to change behind one of its doors?"

---

## 5 Nov: 116 of Lachy's updates come in (his 0.8.3 and a bit more)

**What changed:** the scheduled job merged Lachy's update into `main`. The new things are: she can join your Discord call for you and launch the game your friends pick, she hears Zoom, Teams and other call apps, and she knows who said what. Friends can ask her for things and you confirm (off by default). You can pick your speaker and screens. Any OpenAI-compatible provider now works on Windows, there are new Mainframe colours, and she tells you what's new once after an update. She can edit her notes in Mainframe and set reminders on dates, and there's a Play menu for mini-games. Mac and Linux get the full Mainframe, Mods and Code/Husk Mode, plus an AppImage on Linux. Package managers can now install her, and she keeps more passwords and tokens out of her logs.

**The five conflicts:** `README.md` stayed ours. In `ci/build-windows.ps1` we took Lachy's list of files and put `'Character', 'YouTubeMusic'` and the `if ($Character)` line back. In `.github/workflows/ci.yml` we kept our short build folder and his new package test, pointed at that folder. In `app/Hands.cs` both sides had added a line in the same spot, so both stayed, with his "that errand has ended" check first so a cancelled errand can't start music. In `app/Mainframe.cs` one line had both his new colour and our change to the memory note's name, so it has both now. No words changed there. `Safety` in `app/Brain.cs` is word for word what it was, and Lachy didn't change it either. Nothing under `characters/` conflicted.

**New text that still says Capri in Talia's build** (none of it changed, since it's your call):
- **Telling you to say her name:** "Call mode (beta) on. Say Capri for your requests.", and the same idea in the call panel and in "Call mode is on; say Capri to ask."
- **What the AI is told:** the rule that requests on a call are the ones addressed to Capri, and "Capri handles spoken messages" in the call job.
- **Her what's-new note:** the fixed line "better calls, Mods and Capri VR", and "You just updated to Capri".
- **Capri VR:** "Capri Room" and `Capri-VR-Quest.apk` in her help text. That's Capri's own Quest app, so it isn't a version of Talia.
- **Menus and windows:** "Play a mini-game with Capri", "Open Capri Mainframe and change SECURITY", "Edgerunners Desktop is installed. Get it later in Capri Mainframe".
- **Help answers:** new ones in `SelfKnow.cs` say "Capri" where the rest of the line says Talia, for example "Mainframe > TALIA > Quit Talia closes Capri".
- **Code/Husk Mode on Mac and Linux:** "I need Capri's full app path" and "Move Capri into Applications".
- **Package errors:** "Capri doesn't know the package manager".
- **Lachy's Discord:** her menus now send people to `discord.gg/capridesktop`, which is his server. It doesn't say Capri on screen, but Talia's users would land there.

**One idea worth knowing:** two people can change the same line without disagreeing. Git only sees that the line changed twice and stops. Here Lachy changed a colour and we changed a name, so the fix was to keep both changes rather than pick a side. A real disagreement is when both change the same thing, like two different words for one sentence.
---

## 4 Nov: Left for you in the morning

**First, see how the night's tests went:** run `./ci/status.ps1`. The PC was turned off while the tests for `c1d5505` were still running, so nobody has read their results. The self-test passed on the commit just before these changes. The Mac build often can't get a machine from GitHub, and that isn't a code failure.

**Yours to decide, so left as they are:**
- **Should `talia-built-in` go into `main`?** It's on GitHub but not in `main`. A new cloud session starts from `main` unless you name this branch, and the new Sync upstream only takes effect once it's in `main`.
- **Where should Talia's build stop saying Capri?** Lachy's new text says "Import a Capri mod" and "Capri closed unexpectedly". Her help text says the Quit button "closes Capri". The rest of what she inherited is in `characters/talia/CAPRI-LEFTOVERS.md`.

**Tonight's merge needs this PC:** "Merge tonight's Capri update" runs in the Claude app on this PC, so it waits while the PC is off and runs the next time the app starts. Sync upstream runs on GitHub at about 07:17 anyway, but gives up if a merge conflicts.

---

## 4 Nov: Talia's sitting and lying sheets have 16 frames

**What changed:** her ten sitting and lying Krita files went from 60 frames to 16, and their blinks from 8 frames to 4. All of them play at 8 frames a second. Her Krita files have new templates in `characters/talia/templates`, with Capri's art cut down to matching frames underneath. Those ten files were still empty, so no drawing was lost. Lucy's files and Capri's build are unchanged.

**Why the build reads the width:** the frame count and speed are written in the code, but any sheet you haven't drawn is still Capri's. Setting everything to 16 now would slice her 60-frame sheets into wrong pieces. So the build measures each sheet of hers: if it's 16 frames wide, that one sheet gets the new numbers. The small code changes this needs are in `characters/fewer-frames.txt`.

**Why 16 frames still takes 2 seconds:** 60 frames at 30 a second and 16 at 8 a second are both a 2-second loop, so she doesn't move at a different pace. It just has fewer drawings in it.

**One idea worth knowing:** frames that have to line up need to change together, or they drift. Her blink replaces frames 9–12 of the sitting loop, like her standing blink does, and talking swaps in the same moment of the loop. That's why those numbers moved with the frame count.

---

## 4 Nov: Lachy's update tonight merges itself

**What changed:** nothing in the app. A scheduled job called "Merge tonight's Capri update" checks for his update at about 23:50 on 4 Nov, then at about 01:50, 03:50, 05:50, 07:50, 09:50 and 23:50 on 5 Nov. It merges the update into `main`, waits for GitHub's tests, then merges `main` into `talia-built-in` and pushes both. It runs inside the Claude app on this PC, so the PC has to be awake and the app open. If it misses a time, it runs the next time the app starts.

**Why not just Sync upstream?** That run is on GitHub and doesn't need this PC, but it only comes once a day, at about 07:17 here, and it gives up on any conflict. It's still there as the backup for a clean merge.

**What it won't do:** it won't force a push, make a release or tag, or touch her wording. If a conflict touches characters, a prompt or `Safety`, or the compile fails, it stops without pushing and says why. New text that says Capri gets listed for you and isn't changed.

**How it's allowed to push:** the list in `C:\Users\vince\.claude\settings.json` under `permissions` names the exact commands, limited to one separate folder, `edgerunners-merge` in Temp. Pushing is allowed to `main` and `talia-built-in` and nowhere else. The job also runs in Auto mode, where a safety check still looks at each action. Delete those lines and the job after tonight if you'd rather be asked again.

**One idea worth knowing:** a second working folder for the same repo is called a worktree. It has its own checked-out files but shares the same history, so the job can merge there without disturbing whatever another session is doing in the main folder.

---

## 4 Nov: Each character gets her own memory

**What changed:** a character build now keeps her notes, memories, chat logs, current chat and edited personality in `characters\<name>` inside the app's folder. `characters/own-files.txt` says which files. Her memory file's title and the instructions for writing it use her name too. Capri's facing-left art also leaves the build as soon as a character has her own version of that sheet.

**Why:** all characters share one app folder, so that switching doesn't lose settings. That was right for settings, but it meant Talia would have read Lucy's memories as her own. Personality went along for the same reason: an edit to Talia's shouldn't change Lucy.

**Still shared on purpose:** settings, keys, downloaded voices and game notes, because those belong to you or the game, not to her.

**One idea worth knowing:** "same folder" and "same character" are separate questions. Sharing is good for what belongs to the person using the app, and bad for what belongs to the character.

---

## 4 Nov: A list of what Talia inherited from Capri

**What changed:** nothing in the app. `characters/talia/CAPRI-LEFTOVERS.md` is a new list of everything in her build that came from Capri and may not suit her, with decisions for you to make.

**Why:** the fork treated characters as interchangeable: same app, new name, lines and art. That works when the characters are similar, but Capri is a program and Talia is a human, so some of what she inherited only makes sense for Capri. Her animation list is the clearest case: `glitch` makes sense for software, but not automatically for a person.

**One idea worth knowing:** a find-and-replace can only change what it's told to look for. Her name list deliberately covers only whole phrases, so it never touches instructions like "you're Capri herself", which you never see on screen but the AI does. So a build can look finished and still be telling the AI she's someone else.

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

---

## 4 Nov: Talia's personality goes in at build time

**What changed:** a `-Character talia` build now takes `characters/talia/personality.md` and makes it her default personality. `Use-Character.ps1` does this in the build's temporary copy of the code, so `app/Brain.cs` stays exactly as Lachy wrote it. The self-test also runs on her build on GitHub now, instead of on your PC.

**Why not edit `Brain.cs`?** The notes' first plan was to move her personality into `Character.cs`, which means changing Lachy's lines. Those lines change in nearly every Capri update, so we'd get merge conflicts again and again. Changing the copy means his updates merge cleanly, and the build stops with a clear message if it can't find what it's looking for.

**Idea: a test that checks its own answer proves less.** The self-test compares her prompt to a fixed checksum. Her build can't use Capri's, so it works one out from her own text, and that check always agrees with itself in her build. It's still fine, because the plain Capri build keeps the fixed checksum, and that's what guards the safety lines. 
**Worth knowing:** the same research-based text now has a few of Lachy's tuned rules, like asking something back at most one reply in four. He learned those from real users, and they were missing from her draft.

---

## 4 Nov: GitHub's tests run when they're useful

**What changed:**
- Saving a Krita file or a note no longer starts any tests. `ci.yml` skips `characters/` and the research, because Capri's own build doesn't use them.
- Talia's self-test now also runs when `app/` or `assets/` change. Before, a Capri change could break her build and nothing would notice.
- Sync upstream runs once a day and writes the conflicting files on its summary page.
- `./ci/status.ps1` shows what GitHub last said about a branch and why anything failed.

**Why did Sync upstream change?** It was meant to open an issue when a merge conflicted, but this fork has issues turned off. Opening one failed silently, and all you got was a red run every 6 hours, with no reason unless you opened the log. The conflicts themselves are small: both of you added a word to the same long line.

**Idea: a `paths` filter, read from top to bottom.** A list of paths says which changes start a workflow, and a line starting with `!` takes some back out. The last line that matches a file wins. That's why `characters/talia/personality.md` comes last in `talia-smoke.yml`: `!**/*.md` skips notes, but that one `.md` file goes into her build.

**Idea: Git can't merge two changes that touch.** Git compares by lines, so even two different edits conflict if they're on the same line or right next to each other. That's why moving our `'Character', 'YouTubeMusic'` names to their own line wouldn't help: nothing can go between `$sources` and the line after it without touching his line.

---

## 4 Nov: The self-test still looked for Capri's name in one more place

**What changed:** one more line in `characters/talia/checks.txt`, so the self-test expects "You are Talia" in what her build sends to ElevenLabs.

**Why did the last fix miss it?** A rule in that file swaps one exact piece of text, and the same words can be written differently in the code. The last rule matched `"You are Capri" }`, as the chat checks write it. The ElevenLabs check writes `\"You are Capri"`, with a backslash in front because the words sit inside a piece of JSON. Same words, different characters, so the rule didn't touch them.

**Correction to what this note first said:** I wrote that the self-test stops at its first failure. It doesn't. After a failed step it starts a fresh copy of the app and carries on, so one run can find several problems.

---

## 4 Nov: Why Talia's self-test failed without saying why

**What changed:**
- The run's summary page, and so `./ci/status.ps1`, now shows the checks that failed and why the script stopped. Before, it only showed `failure.txt`.
- The check on the labels she knows about now reads the copy of the code she was built from. It's another line in `characters/talia/checks.txt`.

**Why was it silent?** The self-test writes two files. `failure.txt` only gets some kinds of failure, and every result goes in `smoke-test.txt`. A whole section can fail and appear only in the second file. The summary page read only the first, and the full log needs a GitHub login, so the run just said it failed. Once the page listed the results, the answer was one line out of 869 results that passed or failed.

**Why did that check fail?** It makes sure that when she explains a button, the button really exists, by searching the source files for its label. Her build has "Quit Talia", but the check was searching Lachy's `app/Mainframe.cs`, which rightly still says "Quit Capri". Her app was fine. The test was looking at the wrong file.

**Idea: test what you built.** Her build is made from a changed copy of the code, so any check that reads source files needs to read that copy, or it's comparing her to Capri.

---

## 4 Nov: a script does the routine part of merging Lachy's updates

**What changed:** `ci/merge-capri.ps1` merges his latest into the branch you're on. It fixes three conflicts that keep coming back, compiles the Capri and Talia builds, and commits, but it never pushes. Sync upstream on GitHub now uses it too, so a routine update can finish with nobody involved. If anything's left, it prints only those conflicts.

**Why a script?** The same few conflicts came back with each update, and working them out by hand used up time and Claude's tokens on something with one right answer. Saved in a script, that answer costs nothing to run again.

**Idea: a fix has to prove it's safe.** Taking Lachy's version of `ci/build-windows.ps1` and re-adding our lines would quietly lose anything else we'd changed there. So the script first applies our lines to the older version both sides started from, and checks that the result is exactly our file. If it isn't, we changed something else, and the file is left for a person.

**How it was tested:** by replaying real past merges in a throwaway copy, without running the app. For the 58-commit merge, the result was identical to the one done by hand. Two older merges with real decisions in them (`app/Capri.cs`, `app/Player.cs`) were correctly left for a person. Sync upstream's new version can only be tried once it's on `main`.
