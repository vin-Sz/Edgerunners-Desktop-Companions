# Edgerunners Desktop Companions

Desktop companions of characters from *Cyberpunk: Edgerunners*, built on top of [capri-desktop](https://github.com/lachydotmcg/capri-desktop) by lachydotmcg.

## Characters

| Character | From | Status |
|---|---|---|
| **Talia Yang** | *Cyberpunk: Edgerunners 2* | Main focus. Her name, lines and personality are in; her art is next |
| **Lucy** | *Cyberpunk: Edgerunners* | On hold for now. Personality and lines are drafted, her art is in progress |

## Why this fork exists

capri-desktop turns Capri into a desktop companion who sits on your windows, talks back, and helps out on your PC. I loved the idea but wanted other characters too, so this fork makes room for more than one.

**Almost everything here is capri-desktop's work.** The app, the brain, voice, voice chat, PC jobs, the Mainframe, the animations system: all of that comes from the original project. This fork mainly adds, for each character:

- **Personality:** who she is and how she talks
- **Artwork:** her own sprites, icon and images in place of Capri's
- **Small text changes:** her name and lines where you'd see them

Features of my own may come later, based on what I need, like the YouTube Music support that's already here. The fork stays in sync with capri-desktop, so its updates and fixes keep coming here too.

## How the characters work

Each character has her own folder in [characters/](characters), and you pick one when building:

```powershell
./ci/build-windows.ps1 -Character talia
```

Any drawing or voice line a character doesn't have yet falls back to Capri's, so the art can go in one piece at a time. You can't switch characters inside the app yet. [characters/talia/NOTES.md](characters/talia/NOTES.md) and [characters/lucy/NOTES.md](characters/lucy/NOTES.md) have the details.

## Status

🛠️ **Work in progress.** There's no download yet. If you want a working companion today, get [Capri](https://github.com/lachydotmcg/capri-desktop).

- [x] Building with a character's own art, voice, icon, name and lines
- [x] Talia's folder, name and lines
- [x] Talia's personality, built in as her default (Windows)
- [ ] Talia's sprites, animations and icon
- [ ] Talia's voice lines
- [ ] First build you can download

## Made with help from Claude

I'm using [Claude](https://claude.ai) (Anthropic's AI) to help plan this fork and to help with the code. I'm also using this project to learn: I want to understand how the app works and write parts of it myself, so some changes are mine, some are Claude's, and a lot are both.

## Credits and licence

- **Original project:** [capri-desktop](https://github.com/lachydotmcg/capri-desktop) by lachydotmcg. All credit for the app goes there. Join their [Discord](https://discord.gg/F4fDHfGtFk) for the original.
- **Capri's art and animations:** from the [Capri project](https://github.com/lachydotmcg/capri-desktop), drawn by Capri's artist, who prefers to stay private. Until a character's own art replaces them, the sprites here are theirs.
- **Licence:** PolyForm Noncommercial 1.0.0, same as the original. Free for anything non-commercial; no selling it or putting it in paid products. Full terms in [LICENSE.md](LICENSE.md).
- **Talia, Lucy** and *Cyberpunk: Edgerunners* belong to CD Projekt Red and Studio Trigger. This is an unofficial, non-commercial fan project, not affiliated with them.
- Font: Share Tech Mono (OFL). Free voice: Kokoro-82M (Apache-2.0). Her own ears: NVIDIA Parakeet TDT 0.6B [v2](https://huggingface.co/nvidia/parakeet-tdt-0.6b-v2) and [v3](https://huggingface.co/nvidia/parakeet-tdt-0.6b-v3) (CC-BY-4.0), run with [sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx) (Apache-2.0). HD voice: [Qwen3-TTS 1.7B](https://github.com/QwenLM/Qwen3-TTS) (Apache-2.0), run with [qwentts.cpp](https://github.com/ServeurpersoCom/qwentts.cpp) (MIT).
