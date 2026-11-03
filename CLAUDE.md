# Edgerunners Desktop Companions

A fork of [capri-desktop](https://github.com/lachydotmcg/capri-desktop) (called "upstream" here) that swaps Capri for other
Edgerunners characters. Almost all of the code is upstream's. The fork's own changes are kept small so syncing stays easy.

## Merging capri-desktop

`.github/workflows/sync-upstream.yml` merges upstream into `main` every 6 hours. When the merge conflicts, it starts Claude
on a `sync/capri-<sha>` branch with the merge already in progress, and these are the rules for finishing it.

**Default: take upstream's side.** It's their app. Keep the fork's side only for what the fork owns:

- **README.md:** always the fork's.
- **Character lines:** `app/Character.cs` and `characters/<name>/Character.cs` belong to the fork. Upstream's files refer
  to them instead of holding the text (`Character.PopLines`, `Character.Declined`, `Character.Sparked`,
  `Character.HalloweenLines`, `Character.VaultNote`, `Character.Speaker`). When upstream changes one of those texts, keep the
  `Character.X` reference and copy Capri's new wording into `app/Character.cs`. If upstream moves or renames the code
  around them, follow upstream and put the reference back.
- **YouTube Music:** `app/YouTubeMusic.cs` is the fork's. Its hooks in `Hands.cs`, `Player.cs` (`Tune.Hearts`) and
  `Capri.cs` (`ReadHeart`, the `YouTubeMusic.Check()` smoke check) stay. When upstream reworks the code they sit in, fit
  the hook into upstream's new version rather than keeping the old code.
- **Build files:**
  - `ci/build-windows.ps1`: take upstream's `$sources` list, then make sure `'Character', 'YouTubeMusic'` are in it
    (right after `'Player'`) and that the `if ($Character) { . (Join-Path $root 'characters\Use-Character.ps1') -Character $Character }`
    line comes right after it.
  - `cross/Capri.Cross.csproj`: keep the fork's `Character.cs` and `YouTubeMusic.cs` lines and its `$(Character)` ItemGroup.
- **When upstream adds something the fork had its own version of, take upstream's and delete the fork's copy.** Don't
  keep both. For example, Capri 0.8.0 brought personality.md back, so the fork's own personality.md code in `Brain.cs`,
  `Mainframe.cs`, `cross/Pet.cs` and both smoke tests was dropped for upstream's. Search for leftovers of the fork's version
  (duplicate members, a second menu item, a second smoke check) after resolving.
- Keep the fork's extra `"5439461f01a6744c"` in `Brain.Retired`.

### Checks before committing

```bash
git diff --name-only --diff-filter=U        # nothing left unmerged
grep -rnE '^(<<<<<<<|>>>>>>>)' app cross ci characters .github README.md   # no conflict markers
dotnet build cross/Capri.Cross.csproj -c Release                       # Mac/Linux build, as Capri
dotnet build cross/Capri.Cross.csproj -c Release -p:Character=talia
dotnet build cross/Capri.Cross.csproj -c Release -p:Character=lucy
python3 ci/check-names.py                   # every names.txt / app.txt line still finds its words
```

The Windows app can't be built on Linux. CI builds it and runs both smoke tests on the pull request.

If a names.txt line no longer matches, find what upstream's code says now and update the line's left side.

### Commit message

```
Merge capri-desktop <version> from upstream

Brings in capri-desktop up to <sha> (<n> new commits).
<one short paragraph per conflict: what clashed and which side won, and why>
README keeps this fork's version.
```
