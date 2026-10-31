# Learning log

One short entry per change: what changed, why, and one idea worth knowing. Newest at the top.
Read one when you have 10 minutes. If something doesn't click, ask Claude about that entry.

---

## 1 Nov: building Lucy with `-Character lucy`

**What changed:** `ci/build-windows.ps1 -Character lucy` builds *Lucy*. Each drawing you put in `characters/lucy/sprites/` (same name as Capri's, like `idle.png`) replaces Capri's, and the rest stays Capri's. Her name replaces Capri's in 42 places you see: menus, tray, talk box, messages. Without `-Character`, the build is plain Capri, like Lachy's.

**Idea: change a copy, not the original.** For her name, the build copies the code into the output folder, swaps the phrases from `characters/lucy/names.txt` in the *copy*, and compiles that. Lachy's files never change, so a sync can't conflict over her name. That's the hook idea taken one step further: here there's no hook in his code at all, except the one line that calls our script. One catch: a compile error then points at the copy (`out\...\character-lucy\Talk.cs`). Fix it in `app\`, not in the copy.

**Idea: fail early, with a reason.** Her animations cut each sheet into frames using sizes fixed in the code. A sheet of the wrong size wouldn't crash; she'd just look broken in a confusing way. So the build checks each drawing's size first and stops with "idle.png is 900x384 px, but Capri's is 960x384". Checking right where the mistake comes in is much kinder than finding it later.

**Idea: dot-sourcing.** `. script.ps1` (with a dot and a space in front) runs a PowerShell script *inside* the one that called it, so it can change that script's variables (`$resources`, `$sources`). Without the dot, a script gets its own private variables.

**Why not "Capri Mainframe" yet:** those words are also in her prompt, and the self-test checks her prompt's fingerprint (a SHA-256). Changing it now would make the self-test stop there. It changes together with her personality.

**Try it (optional):** add a line to `names.txt`, like `"Capri update ready" => "Lucy update ready"`, then build with `-Character lucy`. Then add one with a typo on the left and read the warning the build gives.

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
