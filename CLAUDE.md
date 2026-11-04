# Edgerunners Desktop Companions

A fork of [capri-desktop](https://github.com/lachydotmcg/capri-desktop) that adds other characters. Talia Yang is the main focus and Lucy is on hold. Start with [characters/talia/NOTES.md](characters/talia/NOTES.md); building and releasing are in [characters/lucy/NOTES.md](characters/lucy/NOTES.md).

## How to work here

- **Do what was asked, and flag the rest.** Don't add rules or change a character's wording or the app's prompts unless asked, even if you're sure it's better. Say what you noticed and let the owner decide.
- **Work on your own and explain in writing.** The owner has little time and spends it drawing. Use small, separate commits, and explain them in plain language in `characters/lucy/LEARNING.md`, including the answer whenever they ask why something works the way it does.
- **Only stop for what's really theirs:** character wording and tone, art, and decisions like the ones above.
- **Other sessions may be working in this folder at the same time.** Before committing, look at `git status` and `git log -3`, and commit only your own files (`git commit -- <paths>`), never with `git add -A`.

## Testing

- **Never run the self-test or launch the app on the owner's PC.** It's their working computer, and the test takes over sound, mic and windows for minutes. Compiling with `ci/build-windows.ps1` (no `-SmokeTest`) is fine.
- **Compile outside OneDrive:** `./ci/build-windows.ps1 -Character talia -OutputDirectory "$env:TEMP\edgerunners-build"`. This PC's Windows is German, so compiler errors come out in German.
- **Run the self-test on GitHub by pushing a branch:** `ci.yml` tests Capri's build and `talia-smoke.yml` tests Talia's. Commits that only change notes, research or Krita files skip them.
- **Read the results with `./ci/status.ps1`** (`-Branch main` for another branch). It gives each workflow's result and the reason for a failure. `gh` isn't installed here.
- **`app/` is C# 5, and a new `.cs` file needs adding to `$sources` in `ci/build-windows.ps1`.** `CONTRIBUTING.md` has the rest of Lachy's house rules.

## Characters

- **Talia:** don't ask the owner to watch episodes to check her. Use the research in `reports/` and say what rests on thin evidence. Her voice comes later.
- **The rule in Talia's notes stays:** she's a teenager in the show, so she's a friend and nothing else. See "One rule that stays" in her notes.

## capri-desktop's code

- Put fork code in our own files, with small hooks in Lachy's, or change a build copy through `characters/Use-Character.ps1`, so his updates keep merging.
- Keep `Safety` in `app/Brain.cs` as it is. Lachy asks forks to keep those lines.
- **To merge his updates, run `./ci/merge-capri.ps1` in a clean worktree, not by hand.** It fixes the conflicts that keep coming back (`README.md`, `$sources` in `ci/build-windows.ps1`, the `Compile` list in `cross/Capri.Cross.csproj`), compiles both builds and commits. It never pushes. Only read what it prints under "Needs a person", and don't open `app/Capri.cs` whole: it's over 40,000 lines, so search it. If a new kind of conflict keeps coming back, add a fix to the script. Then check the result on GitHub before anything else builds on it.
