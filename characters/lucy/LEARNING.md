# Learning log

One short entry per change: what changed, why, and one idea worth knowing. Newest at the top.
Read one when you have 10 minutes. If something doesn't click, ask Claude about that entry.

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
