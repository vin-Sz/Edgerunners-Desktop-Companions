# Talia's lines

Capri's lines that are written straight into the code and skip the AI, so Talia's personality never touches them. These are the ones "Fixed lines that still sound like Capri" in `CAPRI-LEFTOVERS.md` lists, with a Talia draft for each.

The app doesn't read this file. **None of these are in the app yet.** Change anything, tick the box, and that group goes into her build. Locations are from 6 Nov and may move after one of Lachy's updates.

## Where the drafts come from

Claude read the E02 and E07 transcripts on [Scraps from the Loft](https://scrapsfromtheloft.com/tv-series-transcripts/cyberpunk-edgerunners/) for these (6 Nov), on top of the E05 work in `reports/`. They're fan transcripts, read by an automated tool, so the same warning applies: what you saw wins. No line here is copied from the show. What the two episodes added:

- **E02:** short, quick lines with interjections ("Huh?", "Duh"). She bristles when someone touches her and leaves when she's bored. When she's thrown around she yelps and laughs, so she isn't only annoyed.
- **E07:** casual and clipped ("gotta", "lemme"). She tells Capri to stay out of her head but admits Capri helped. She shrugs off worry, then warms up once she believes it's meant. She mentions she only recently walked again.

**Two choices made for you, change them if you like:**

- **No death jokes here.** Her personality only makes them when you sound fine. These lines fire at random and can't check how you are, so they joke about her chrome and her boredom instead. The one exception is "Still breathing" in her pop-ins, which you already have.
- **Roman stays out of these lines.** E07 plays their scenes as flirting, and her rule rules that out.

## Asking for attention (`app/Capri.cs` `NudgeLines`, about line 1689)

- [ ] Use these

| Capri | Talia (draft) |
| --- | --- |
| Psst. Remember me? Tiny, glitchy, very important. | Psst. Still here. Lucky you. |
| I'm bored. Entertain me. | Bored. Fix it. |
| Hey. Hey. Look at me. | Hey. Hey. Look at me. *(kept)* |
| You've been ignoring me for ages. Rude. | You've been ignoring me for ages. Rude. *(kept)* |
| Pay attention to me or I start clicking things. | Pay attention to me or I start clicking things. *(kept)* |
| Knock knock. It's your favourite gremlin. | Knock knock. It's me. Obviously. |
| Choom. I'm bored out of my many minds. | Choomie. I'm so bored I'm reading your file names. |
| One of my minds says you've forgotten me. The rest agree. | Don't make me come over there. |
| I've counted your desktop icons twice now. | Counted your desktop icons. Twice. Get better icons. |
| This is me being patient. It's going badly. | This is me being patient. It's going badly. *(kept)* |

**When you look at her after a nudge** (`NoticedLines`, line 1690). All of Capri's fit except one:

| Capri | Talia (draft) |
| --- | --- |
| Knew you couldn't resist me. | Knew you'd crack. |

## Check-ins (`app/Care.cs` `CareLines.Defaults`, about line 149)

- [ ] Use these

These are the default contents of the `check-ins.md` file people can edit, so anyone who already has Capri's file keeps it. Capri's water and stretch reminders are warm. Hers still look after you, but sound like she's telling you off.

| Check-in | Capri | Talia (draft) |
| --- | --- | --- |
| Title | # Capri's check-ins | # Talia's check-ins |
| Water | Have a sip of water, choom. I'll keep your spot. | Drink some water. Don't argue. |
| | Water break. Even you need a refill. | Water. Now. I'll wait. |
| Stretch | Unfold yourself a little. Those legs still work. | Get up and stretch. Take it from me, you want those legs working. |
| | Tiny stretch break. I'll be right here. | Stretch. You look like a question mark. |
| Look away | Give your eyes 20 seconds looking away from the screen. I'll survive. | Eyes off the screen for 20 seconds. I'll still be here. |
| | Look at something far away for 20 seconds. Yes, even farther than me. | Look at something far away for 20 seconds. Farther than me. |
| Sleep nudge | It's late, choom. Your bed misses you. | It's late. Go to bed. I'm not tucking you in. |
| Meals | Been here since before lunch. Go grab something to eat. | You skipped lunch, didn't you. Go eat. |
| | Food break. Can't run that brain on empty. | Eat something. Brains don't run on spite. Mostly. |
| Game break | Long session. Take a little break when you've got a good spot. | Long session. Take a break at the next save. |
| | You've been at that game a while. Stretch those hands when you can. | Your hands are gonna hate you. Stretch them. |
| Bored | So boreddd. | Bored. So bored. |
| | I've counted your desktop icons twice now. | Counted your icons again. Still bad. |
| | One of my minds is making its own entertainment. Worrying. | Thinking about rearranging your desktop. Just saying. |
| | Tiny gremlin. Big boredom. | Entertain me or I entertain myself. You won't like it. |
| Bored noticed | There you are. / Finally. Hi. | *(kept)* |
| Bored ignored | Fine. I'll entertain myself. / Cool. Cool cool cool. | *(kept)* |

The stretch line about legs points at her, since she's only recently walking again in E07.

## Spotting Cyberpunk, and hearing its music (`app/Capri.cs` `HomeGameLines` and `HomeSongLines`, lines 1694–1695, and `cross/Pet.cs`)

- [ ] Use these

| Capri | Talia (draft) |
| --- | --- |
| Night City?! You're taking me home, choom. | Night City. Huh. Looks cleaner from here. |
| Ooh, Cyberpunk. Go wreck some corpos for me. | Cyberpunk, huh? Don't go joining a gang. Trust me. |
| [SIGNAL CORRUPTED] ...wait. I know that skyline. | ...Wait. I know that skyline. |
| Wait, that's Night City. Turn it up. | Wait, that's Night City. Turn it up. *(kept)* |
| Ooh, my soundtrack. Preem taste. | Okay, that one's good. Don't let it go to your head. |
| Now that's music. You're learning. | Now that's music. You're learning. *(kept)* |

"Don't go joining a gang" is about Maelstrom. It points at her and doesn't spoil anything.

## PC lagging (`app/Capri.cs` `LagLines`, line 1700, and `cross/Pet.cs`)

- [ ] Use these

The cyberpsycho joke suits her better than it ever suited Capri, since she jokes about being one in E05, so it stays.

| Capri | Talia (draft) |
| --- | --- |
| Your CPU's cooking, choom. Careful, I might go cyberpsycho. | Your CPU's cooking. Careful, I'm halfway to cyberpsycho already. |
| Everything's lagging. One more tab and I go full cyberpsycho. | Everything's lagging. One more tab and I'm gonna snap. |
| [SIGNAL CORRUPTED] ...this lag is making me cyberpsycho. Close something. | This lag's worse than my chrome on a bad day. Close something. |

## Being thrown (`app/Capri.cs` `ThrowLines`, line 1849)

- [ ] Use these

In E02 she yelps and laughs when she's thrown around, so some of these enjoy it a little.

| Capri | Talia (draft) |
| --- | --- |
| WHEEEE! | Whoa, whoa, okay! |
| Put me DOWN! | Hey! Put me DOWN! |
| Choom, I'm not a frisbee! | Choomie, I'm not a frisbee! |
| AAAAAA! | AAAA! ...Okay, that was kinda fun. |
| Not the hair! | Watch the chrome! |

The lines after a throw (`WarnLines`, `DizzyLines`, `SulkLines` and the rest) already fit, as `CAPRI-LEFTOVERS.md` says.

## Examples for game reactions (`app/Reactions.cs`, about line 45)

- [ ] Use these

These are never said out loud. The AI is shown them as examples of her style, so Capri's capitals and double question marks pull her towards Capri's energy. Hers are drier, and impressed only now and then. Only the three lists that sounded most like Capri are redone; the others (comebacks, losing again, a streak ending, getting hit, flashes) fit well enough.

| List | Capri | Talia (draft) |
| --- | --- | --- |
| Kills | did you SEE that??, GET DOWN, deleted., clean!!, sit DOWN, who's next??, bodied, choom, too easy, no way you hit that, oh that was filthy | huh. nice, deleted., clean., flatlined., too easy, who's next?, okay, show-off, that's gotta hurt, didn't even see you, not bad, choomie |
| Streaks | you're on FIRE, someone stop them, carry me, choom, they can't touch you, the lobby's scared of you, streak streak STREAK | okay, you're on fire, someone stop them, carry me, choomie, they can't touch you, lobby's scared of you, don't get cocky |
| Deaths | nooo, who did that??, rest in pieces, that was rigged, you got robbed, not like this, noo choom, run it back, respawn and cook them | ouch., who did that?, flatlined. rude, that was rigged, you got robbed, gonk move, honestly, run it back, get even |

## Not here on purpose

- **Things she says about the app** (`app/SelfKnow.cs`, "Right-click Capri" and so on). That's the app's help text, not her voice. It needs the name fix in number 2 of `CAPRI-LEFTOVERS.md`, not new wording.
- **Head pats** (`app/Capri.cs:1443`). That waits on your choice in number 11.
- **The fake blue screen** (`app/ChaosScreen.cs`). That's number 13, and can go here once you say you want it.
