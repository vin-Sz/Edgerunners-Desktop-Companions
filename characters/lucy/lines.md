# Lucy's lines

Lines Capri says that are written straight into the code, with a Lucy version for each.
The app doesn't read this file. Lines marked **in the app** are copied into `app/Character.cs`, so change them there too. Locations are from capri-desktop 0.7.7 and may move after an update. This entire folder is to avoid merging conflicts with the update.

## Netrunner tags (replace [SIGNAL CORRUPTED])

- [ICE DETECTED]
- [CONNECTION LOST]
- [DAEMON INTERRUPT]
- [NET DISCONECTED]
- [TRACE BLOCKED]

## Drafts waiting for you

Claude's drafts for lines `lines.md` didn't have yet. Change anything, then tick the box and they go into `Character.cs`.

- [ ] **When she spots Cyberpunk running** (`Capri.cs` `HomeGameLines`, and `cross/Pet.cs`)

| Capri | Lucy (draft) |
| --- | --- |
| Night City?! You're taking me home, choom. | Night City. ...Didn't think I'd miss it. |
| Ooh, Cyberpunk. Go wreck some corpos for me. | Cyberpunk, huh. Give Arasaka hell for me. |
| [SIGNAL CORRUPTED] ...wait. I know that skyline. | [TRACE BLOCKED] ...I know that skyline. Too well. |

- [ ] **When your PC is lagging** (`Capri.cs` `LagLines`, and `cross/Pet.cs`)

| Capri | Lucy (draft) |
| --- | --- |
| Your CPU's cooking, choom. Careful, I might go cyberpsycho. | Your CPU's running hot, choom. Ease off before something fries. |
| Everything's lagging. One more tab and I go full cyberpsycho. | Everything's lagging. One more tab and I'm jacking out. |
| [SIGNAL CORRUPTED] ...this lag is making me cyberpsycho. Close something. | [ICE DETECTED] ...this lag. Close something, choom. |

## When something fails or she turns a request down (**in the app**)

| Where | Capri | Lucy |
| --- | --- | --- |
| `Brain.cs` `Declined` | [SIGNAL CORRUPTED] Lost that one in the static. Ask me something else? | [CONNECTION LOST] Dropped that one somewhere in the Net. Ask me something else? |
| `Brain.cs` (end of the error messages, about line 1906) | [SIGNAL CORRUPTED] Something in my head just sparked. Try me again? | [DAEMON INTERRUPT] Something got in my head for a second. Try me again? |

### No longer in the app (since 0.7.6)

Capri used to have ready-made safety replies (`Safety.Deflect`, `Safety.Refusals`, `Safety.Careful`, `Safety.HelpLine`). In 0.7.6 they're gone: `Safety` in `Brain.cs` is now one block of instructions sent to the AI with her personality, and she answers in her own words. Lachy asks forks to keep that block as it is. Lucy's versions are kept here in case they're useful as examples of how she'd say no:

| Was | Lucy |
| --- | --- |
| Deflect | [NET DROPOUT] Lost that thought in the subnet. Try me again? |
| Refusals | Not running that program, choom. Ask me something else. |
| | [ICE DETECTED] ...not touching that one. Next question. |
| | No. Even Arasaka had better ideas than that. |
| Careful | No. Your real-life hardware doesn't respawn, choom. Stay safe and pick something on-screen. |
| | Not happening. Real bodies don't respawn. Let's cause trouble on your desktop instead. |
| | [TRACE BLOCKED] ...no. I've lost enough people. Ask me something else. |
| HelpLine | Hey. No jokes for a sec: please talk to someone you trust right now, or find a free helpline at findahelpline.com. I want you around, choom. |

## When she pops in to check on you (`Capri.cs` `PopLines`, and the same list in `cross/Pet.cs` for Mac and Linux) (**in the app**)

| Capri | Lucy |
| --- | --- |
| Boo. Just checking on you. | Just checking on you, choom. |
| Hi! Don't mind me. | Don't mind me. |
| Peekaboo. | Found you. |
| Miss me? I missed you. | Miss me? ...Don't answer that. |
| Hey, you. Having fun? | Hey. Having fun? |
| Surprise. I got bored without you. | Got quiet without you. |

## Halloween (new in 0.7.7, `Brain.cs` `HalloweenLines`) (**in the app**)

On 31 October her startup hello is one of these, or she says one once that day if she's already running. The smoke test checks each line contains "Happy Halloween".

| Capri | Lucy |
| --- | --- |
| Happy Halloween, choom! | Happy Halloween, choom. |
| Happy Halloween, choom. Trick or treat? | Happy Halloween. Trick or treat, choom? |
| Boo! Happy Halloween, choom. | [ICE DETECTED] ...kidding. Happy Halloween, choom. |

## Other things to check later

- ~~`Talk.cs` `Speaker = "CAPRI: "` (twice): the name shown in her chat log → `LUCY: `~~ **in the app**
- **"Hey Capri"** (new in 0.7.6, off by default): the wake word. The phrase it listens for is `Phrases` in `WakeWord` in `app/Ears.cs` (`"▁HE Y ▁CA P RI"`, the speech model's word pieces). "Hey Lucy" needs new pieces from the model's own `bpe.model`, and `Boost` and `Threshold` were tuned for "Hey Capri", so it needs testing again. The name "Hey Capri" also shows in the SECURITY window and messages
- `assets/voice/hello-morning.wav`, `hello-late.wav`, `hello-miss.wav`: her spoken greetings, need new recordings or removing
- `Hands.cs` `MoonSong` is already "I Really Want to Stay at Your House". It fits Lucy perfectly, keep it
- **Donations** (new in 0.7.7, in `DefaultPersonality` and `Computer.Playing`): she thanks donors, calls them a good boy, and sends anyone asking about donating to `ko-fi.com/lachysdev`. Lucy has no tip jar of her own, so pointing at Lachy's Ko-fi is fair; just keep the smoke test's check for those phrases in step if the wording changes
- The tests check some of these lines word for word, so changing a line also means changing its test
