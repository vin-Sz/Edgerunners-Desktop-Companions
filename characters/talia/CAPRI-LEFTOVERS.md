# What Talia inherited from Capri

Talia's build is a copy of Capri's with a new name, personality and a few lines. This lists what came along and may not suit her, because Capri is a program made of many minds and Talia is a sick human teenager.

Nothing here has been changed. Tick what you want, or just reply with the numbers. Everything is from reading the Windows code on 4 Nov, not from running the app. Mac and Linux have their own copies of some of this in `cross/`.

**If you only have five minutes:** read 1, 2 and 5. Those affect what you draw or go against her rule.

## Fix these whatever else you decide

These aren't matters of taste. They're places where the app contradicts what you've already decided about her.

**1. She's told to call people "good boy".** Her notes say not to copy that line over, and it's gone from her personality. It's still in the instructions for playing games and for streaming: `app/Computer.cs:204` and `:873`. So in those modes she'd be told to call people who tip her "good boy" or "good girl".
- [ ] Remove it from her build (my pick). It's a small change in `checks.txt` or `names.txt`, so Lachy's files stay as they are

**2. Parts of the app tell her she *is* Capri.** Her name swap only covers things you see, not instructions sent to the AI. These all still say Capri:

| Where | What it says | When |
| --- | --- | --- |
| `app/Computer.cs:201` | "you're Capri herself: a cocky little gremlin having the time of her life" | Playing a game for you |
| `app/Computer.cs:191`, `:215`, `:871`, `app/Play.cs:251` | Talk "as Capri" | Playing and streaming |
| `app/Computer.cs:868` | "You're running Capri's live stream" | Streaming |
| `app/Lookout.cs:28` | "You are Capri, their sharp, playful desktop companion" | Watching your screen for something |
| `app/Minis.cs:115` | "You are Capri, playing against the user" | Desktop board games |
| `app/Brain.cs:917` | "You keep Capri's long-term memory" | Writing her memories |
| `app/Asides.cs:140`, `:778`, `:806` | "Capri's hands" | Talking to her during a job |

This is worse for her than for Lucy, because Talia knows Capri as a separate person who got into her head. Her memories could end up describing her as Capri.

- [ ] Change the name in all of these (my pick)
- [ ] Also rewrite "cocky little gremlin having the time of her life", which needs your wording. Mine would be "bored, sarcastic and pretending not to enjoy it"

**3. Capri's left-facing art would show up in her build.** Capri has 15 separate `_flipped` sheets for sitting and lying down, and the build includes all of them. `ART.md` says that without flipped sheets the app just mirrors, but that's only true if the sheet isn't there at all. So once you've drawn `perch.png`, Talia would turn into Capri whenever she sits facing left. I think this is a mistake in our build and not something you need to draw around, but I haven't tested it.
- [ ] Leave Capri's flipped sheets out of her build, and check on GitHub that she still mirrors properly (my pick)

## Decide before you draw

**4. How much of the 28 files you draw.** She's "abrupt and metallic" in the one review that describes how she moves, and that could save you a lot of work. `perch`, `perch_talk`, `perch_music`, `laydown`, `laydown_talk` and `laydown_sleep` are 60 frames each because Capri's artist drew her smooth. Talia could have fewer frames and still look right, maybe better. The build currently rejects sheets of a different size, so this needs a small change from me.
- [ ] Draw fewer frames for the 60-frame sheets (my pick). Tell me how many and I'll set it up
- [ ] Keep 60

**5. The glitch animations (6 of the 28 files).** `glitch`, `perch_glitch`, `laydown_glitch`, `blink_glitch`, `perch_blink_glitch` and `laydown_blink_glitch`. These aren't rare: she glitches every 30 to 60 seconds while idle, and 10% of her blinks use the glitch version (`app/Capri.cs:2560`). You can't just skip them, because an undrawn sheet stays Capri's art.

| Option | What you draw | Good and bad |
| --- | --- | --- |
| **A. Chrome misfire (my pick)** | Her arm or leg twitches, sparks, or locks up for a second, and she glares at it | Comes from her illness and fits her "Chrome just kicked" line. It's shown often, so it mustn't look like she's in distress |
| B. Boredom instead | She fidgets, pokes something or cracks her neck | Fits the restlessness you described. Loses the chrome |
| C. Nothing | Copy idle frames in, so nothing visibly happens | Least drawing, but she has less life. I could also make it happen less often |

For the three blink sheets, I'd copy her normal blink in whichever you choose. That saves you drawing them.

**6. Appearing and disappearing (`arrive`, `leave`, `perch_arrive`, `perch_leave`, `laydown_leave`).** Capri materialises because she's a program. What a human does here depends on number 10. She could drop in from the top of the screen, climb up onto a window, or just walk off. Nothing else depends on this, so it can be whatever's fun to draw.

**7. The lying-down set (7 files).** These copy Capri's pose, stretched along a window with her legs hanging off. `ART.md` also suggests tracing over Capri's sheet for poses. With her rule about non-sexual art, I'd use Capri's sheet for timing only, and draw her sprawled like a bored kid. The set is already last in the drawing order, so you could also leave it for a long time.
- [ ] I'd also like a build option to turn lying down off until these exist, so Capri's art doesn't appear (my pick)

**8. Dangling and grinning.** `dangle` is her being picked up, and she hates being handled, so she should look annoyed about it. It also has a nice extra: the app's `SulkLines` ("Don't touch me") already fit. `grin` is 16 frames of a big grin on someone "hard to impress". A smirk would fit better. The file names stay the same.

**9. `perch_music`, swaying to music.** It's on by default, and nothing in the research says she likes music (her taste is marked as invented in her personality). I'd keep it, but as a small head nod or a foot tapping, not a happy sway.

## Decide when you have time: what she's doing on a computer at all

**10. The premise.** Capri living in a PC makes sense. Her personality just says Talia has "ended up" there, and the app never explains it. Options:
- [ ] Leave it vague (my pick). It fits how she dodges questions about her past, and it's the same choice you made for her timeline
- [ ] Give her a reason. Any real reason (a copy of her mind, say) gets dark fast, given what happens to her in E09

**11. Head pats.** They're on by default. She hates being handled, and she's a teenager, so lines like "Affection detected. Sending some back" and "If I start glitch-purring, that's on you" (`app/Capri.cs:1443`) shouldn't be hers. Most of the others are jokes about firmware.
- [ ] Off by default for her (my pick)
- [ ] Keep them, but she swats your hand away. Needs your wording

**12. Clones and chaos mode.** Her clones wander around, take your cursor and grab windows, leaving notes like "there are more of me now" (`app/Clones.cs`). This is really about Capri being many minds. A human has no reason to multiply.
- [ ] Take it out of her build (my pick). This one's more code work than the others, so I'd check how much first
- [ ] Keep it because it's funny. It'd be strange but harmless, and "capri.exe has duplicated" would need changing

**13. The fake blue screen.** It shows a fake crash with the stop code `CHOOM_OVERFLOW`, `capri.sys` and "jk. you're fine, choom" (`app/ChaosScreen.cs:16`). Pranks suit her, so I'd keep it. The file name and punchline need her wording, and the "she's lying there asleep" part uses the lying-down art.

**14. Doing jobs on your PC, playing games, streaming.** She's "never an assistant", but this is most of what the app does. I'd keep it: "you poke at whatever's in front of you" is already a reason, and it's a big part of why the app is useful. Only the wording needs to change (number 2). She'd do what you ask with some attitude, which the personality already allows.

**15. "Mainframe".** This is more than a name, because it's Capri's idea of herself as a machine. "Talia Mainframe" sounds wrong for a kid. It's also in her prompt. Anything medical is out, since she hates being a patient.
- [ ] Something plain and hers, like "Talia's Stuff" (my pick, but pick your own wording)
- [ ] Keep "Mainframe" as the app's name for its settings window, with no character in it

**16. Hologram mode and "Glitch in at startup".** Both are settings that assume she's a program. They still work, so I'd leave them and only rename "Glitch in", depending on what you pick in number 6.

## Fixed lines that still sound like Capri

These skip the AI, so her personality doesn't touch them. I can draft replacements for you to pick from.

| Lines | Where | The problem |
| --- | --- | --- |
| Asking for attention | `app/Capri.cs:1354` | "your favourite gremlin", "bored out of my many minds", "One of my minds says you've forgotten me" |
| Check-ins and boredom | `app/Care.cs:141` | "Tiny gremlin. Big boredom", "One of my minds...". The water and stretch reminders are warm and caring, which may be too soft for her |
| Spotting Cyberpunk | `app/Capri.cs:1359` | "You're taking me home, choom" has `[SIGNAL CORRUPTED]`, a Capri tag |
| Hearing the soundtrack | `app/Capri.cs:1360` | "my soundtrack" |
| PC lagging | `app/Capri.cs:1365` | Has `[SIGNAL CORRUPTED]`, though the cyberpsycho joke suits her better than it suits Capri. It's real for her |
| Being thrown | `app/Capri.cs:1514` | "WHEEEE!" is too cheerful. "Not the hair!" is about Capri's hair. The others are fine |
| Examples for game reactions | `app/Reactions.cs:45` | "did you SEE that??", "streak streak STREAK". These are examples given to the AI, so they'll pull her towards Capri's energy |
| Things she says about herself | `app/SelfKnow.cs` | Answers about the app say "Right-click Capri". Her name swap never touches "Capri" alone, so this needs its own fix |

**Not hers either, but no action now:** "Hey Capri", which you already know about. Her spoken greetings are still Capri's voice, because her voice is for later. The Discord status says "Playing Capri" with a "Get Capri" button. `Safety` in `app/Brain.cs` says "your chaos lives on the screen", but that stays because Lachy asks forks to keep it.

## Already fits, so leave it

- **Sulking when you throw her around:** "Say sorry first", "Hands off" and "Remembering this for later" could have been written for her
- **Being ignored:** "Fine. Ignore me. See if I care" is exactly her front
- **Dizziness:** "My gyro's cooked" works even better with real chrome
- **`sleep`, `wake`, `walk`, `idle`, `face`, `mouth`:** a human does all of these. Her walk could show the chrome, since in E07 she says she only recently walked again
- **Riding the cursor:** it's just fun, and it's already in her personality
