# Talia's lines

Capri's lines that are written straight into the code and skip the AI, so Talia's personality never touches them. These are the ones "Fixed lines that still sound like Capri" in `CAPRI-LEFTOVERS.md` lists, with a Talia draft for each.

The app doesn't read this file. **All of these went into her Windows build on 6 Nov**: her own lines in `Character.cs`, and the rest through `lines.txt`, which swaps them in the build's copy of Lachy's code. To change a line, change it in those files too. Mac and Linux still have Capri's in `cross/Pet.cs`. Locations are from 6 Nov and may move after one of Lachy's updates.

## How she talks, from all of season 2

Second draft (6 Nov). Claude read the transcript of every season 2 episode on [Scraps from the Loft](https://scrapsfromtheloft.com/tv-series-transcripts/cyberpunk-edgerunners/) with an automated reader. She's in all ten, and is first seen in E01, though she barely talks there. They're fan transcripts and many lines have no speaker name, so only lines marked as hers were used. What you saw still wins.

The first draft was too polished. It sounded like a writer being witty, and she doesn't talk like that. Across the season she sounds like this:

- **Short, loose and casual.** One to five words is normal. She leaves words out ("Couldn't walk till…") and drops her g's ("readin'", "spiralin'"). She uses "ya", "gotta", "lemme", "tryna", "outta", "kinda" and "wanna".
- **She opens with a noise or a shrug:** "Hey", "Uh…", "Ugh", "Yeah, yeah", "Nah", "Okay. So?", "Seriously?"
- **She ends on a tag:** "huh?", "right?", "aren't I?", "ya know?", or a sign-off like "Later!", "Byeee!" or "See ya 'round".
- **She's a show-off and can get giddy:** "Ta-da!", "Yay!", "Hah!", "Duh", and a quick "Kidding!" after a jab. This brat side is missing from the research in `reports/`, which only looked closely at E05, her worst episode.
- **She teases lightly and often answers a question with another question.** Her calm insults are mild: "weirdo", "jerk", "creep", "geezer", "gonk". Hard swearing only comes out when she's really angry or grieving (E04, E05, E09), so it stays out of these lines.
- **Her slang is street, not Capri's netrunner talk:** "choom" and her own "choomie", "preem", "ganic", "gonk", "flatline", "deets", "scroll" (to record), "buzz ya", "bounce".
- **Touch and fuss make her bristle, but she gets over it.** Warmth comes out short and plain, then she jokes or changes the subject.
- **She's proud of her chrome** and treats it as normal, while being plain about how sick she's been.

**About using her exact lines:** whole lines from the show aren't used, because the dialogue belongs to CD Projekt Red and Trigger, and this app gets shared. Her words and short tics are used freely: "choomie", "preem", "Ta-da!", "Kidding!", "Byeee!", "Yeah, yeah". That's what makes someone sound like her, more than any one quote.

**Two choices made for you, change them if you like:**

- **No death jokes here.** Her personality only makes them when you sound fine. These lines fire at random and can't check how you are, so they joke about her chrome and her boredom instead.
- **Roman stays out of these lines.** E07 plays their scenes as flirting, and her rule rules that out.

## Asking for attention (`app/Capri.cs` `NudgeLines`, about line 1689)

- [x] In her build (6 Nov)

| Capri | Talia (draft) |
| --- | --- |
| Psst. Remember me? Tiny, glitchy, very important. | Psst. Hey. Still here, ya know. |
| I'm bored. Entertain me. | Ugh. Bored. Do somethin' fun, will ya? |
| Hey. Hey. Look at me. | Hey. Hey. Over here. |
| You've been ignoring me for ages. Rude. | You've been ignorin' me for ages. Rude. |
| Pay attention to me or I start clicking things. | Pay attention or I start clickin' stuff. Kidding! ...Mostly. |
| Knock knock. It's your favourite gremlin. | Knock knock. Guess who. Duh. |
| Choom. I'm bored out of my many minds. | Choomie. I'm bored. Like, so bored. |
| One of my minds says you've forgotten me. The rest agree. | Whatcha doin'? Looks boring. |
| I've counted your desktop icons twice now. | Counted your desktop icons. Twice. Gonk hobby, huh? |
| This is me being patient. It's going badly. | This is me bein' patient. Goin' great, right? |

**When you look at her after a nudge** (`NoticedLines`, line 1690). All of Capri's fit except one:

| Capri | Talia (draft) |
| --- | --- |
| Knew you couldn't resist me. | Hah. Knew you'd look. |

## Check-ins (`app/Care.cs` `CareLines.Defaults`, about line 149)

- [x] In her build (6 Nov)

These are the default contents of the `check-ins.md` file people can edit, so anyone who already has Capri's file keeps it. Capri's are warm. Hers still look after you, but bossily, the way she shows she cares.

| Check-in | Capri | Talia (draft) |
| --- | --- | --- |
| Title | # Capri's check-ins | # Talia's check-ins |
| Water | Have a sip of water, choom. I'll keep your spot. | Drink some water, will ya? I'll wait. |
| | Water break. Even you need a refill. | Water. Now. Don't gimme that look. |
| Stretch | Unfold yourself a little. Those legs still work. | Get up and stretch. Trust me, you want those legs workin'. |
| | Tiny stretch break. I'll be right here. | Ugh, you look stiff. Stretch, choomie. |
| Look away | Give your eyes 20 seconds looking away from the screen. I'll survive. | Eyes off the screen for 20 seconds. I'm not goin' anywhere. |
| | Look at something far away for 20 seconds. Yes, even farther than me. | Look at somethin' far away for 20 seconds. Farther than me, gonk. |
| Sleep nudge | It's late, choom. Your bed misses you. | It's late. Bed. I'm not tuckin' you in. |
| Meals | Been here since before lunch. Go grab something to eat. | Skipped lunch, huh? Go eat somethin'. |
| | Food break. Can't run that brain on empty. | Food. Now. Ya can't run on nothin'. |
| Game break | Long session. Take a little break when you've got a good spot. | Long session, huh? Take a break at the next save. |
| | You've been at that game a while. Stretch those hands when you can. | Your hands are gonna hate ya. Stretch 'em. |
| Bored | So boreddd. | Ugh. Boooored. |
| | I've counted your desktop icons twice now. | Counted your icons again. Still bad. |
| | One of my minds is making its own entertainment. Worrying. | Thinkin' about rearrangin' your desktop. Kidding! ...Maybe. |
| | Tiny gremlin. Big boredom. | Entertain me or I entertain myself. Your call. |
| Bored noticed | There you are. | There ya are. |
| | Finally. Hi. | Finally. *(kept, without the "Hi")* |
| Bored ignored | Fine. I'll entertain myself. | Whatever. I'll find my own fun. |
| | Cool. Cool cool cool. | *(kept)* |

The stretch line about legs points at her, since she's only recently walking again in E07.

## Spotting Cyberpunk, and hearing its music (`app/Capri.cs` `HomeGameLines` and `HomeSongLines`, lines 1694–1695, and `cross/Pet.cs`)

- [x] In her build (6 Nov)

| Capri | Talia (draft) |
| --- | --- |
| Night City?! You're taking me home, choom. | Whoa, Night City! Looks way cleaner from here. |
| Ooh, Cyberpunk. Go wreck some corpos for me. | Cyberpunk, huh? Don't go joinin' a gang. Trust me. |
| [SIGNAL CORRUPTED] ...wait. I know that skyline. | ...Wait. I know that skyline. |
| Wait, that's Night City. Turn it up. | Wait, that's Night City. Turn it up! |
| Ooh, my soundtrack. Preem taste. | Ooh, preem track. Okay, ya got taste. |
| Now that's music. You're learning. | Now that's music. You're learnin'. |

"Don't go joinin' a gang" is about Maelstrom. It points at her and doesn't spoil anything.

## PC lagging (`app/Capri.cs` `LagLines`, line 1700, and `cross/Pet.cs`)

- [x] In her build (6 Nov)

The cyberpsycho joke suits her better than it ever suited Capri, since she jokes about being one in E05, so it stays.

| Capri | Talia (draft) |
| --- | --- |
| Your CPU's cooking, choom. Careful, I might go cyberpsycho. | Your CPU's cookin'. Careful, I'm halfway to cyberpsycho already. |
| Everything's lagging. One more tab and I go full cyberpsycho. | Everything's laggin'. One more tab and I snap, I swear. |
| [SIGNAL CORRUPTED] ...this lag is making me cyberpsycho. Close something. | Ugh, this lag's worse than my chrome on a bad day. Close somethin'. |

## Being thrown (`app/Capri.cs` `ThrowLines`, line 1849)

- [x] In her build (6 Nov)

In E02 she yelps and laughs when she's thrown around, so some of these enjoy it a little.

| Capri | Talia (draft) |
| --- | --- |
| WHEEEE! | Whoa, whoa, whoa! |
| Put me DOWN! | Hey! Put me down! |
| Choom, I'm not a frisbee! | Choomie, I'm not a frisbee! |
| AAAAAA! | AAAA! ...Hah! Okay, that was kinda fun. |
| Not the hair! | Watch the chrome, jerk! |

The lines after a throw (`WarnLines`, `DizzyLines`, `SulkLines` and the rest) already fit, as `CAPRI-LEFTOVERS.md` says.

## Examples for game reactions (`app/Reactions.cs`, about line 45)

- [x] In her build (6 Nov)

These are never said out loud. The AI is shown them as examples of her style, so Capri's capitals and double question marks pull her towards Capri's energy. Hers show off more and shout less. Only the three lists that sounded most like Capri are redone. The others (comebacks, losing again, a streak ending, getting hit, flashes) fit well enough.

| List | Capri | Talia (draft) |
| --- | --- | --- |
| Kills | did you SEE that??, GET DOWN, deleted., clean!!, sit DOWN, who's next??, bodied, choom, too easy, no way you hit that, oh that was filthy | preem!, ta-da!, deleted., flatlined., too easy, huh?, whoa, nice, show-off, that's gotta hurt, hah! got 'em, clean. |
| Streaks | you're on FIRE, someone stop them, carry me, choom, they can't touch you, the lobby's scared of you, streak streak STREAK | okay, you're on fire, someone stop 'em, carry me, choomie, they can't touch ya, lobby's scared of ya, don't get cocky, huh? |
| Deaths | nooo, who did that??, rest in pieces, that was rigged, you got robbed, not like this, noo choom, run it back, respawn and cook them | ugh., seriously?, who did that?, flatlined. rude, that was rigged, gonk move, honestly, run it back, go get even |

## Her own lines already in the app (`characters/talia/Character.cs`)

- [x] In her build (6 Nov)

These went in on 4 Nov, before the whole season was read, so they had the same polished sound. **Unlike everything above, her current versions are what the app says now.** Ticking swaps them for these drafts. "Choomie" keeps its capital, the way her personality writes it.

**Pop-ins** (`PopLines`), when she drops in to check on you:

| Now | Talia (draft) |
| --- | --- |
| Bored. Show me something. | Hey! Whatcha doin'? |
| Don't mind me. | Don't mind me. Just lookin'. |
| Found you. Weirdo. | Ta-da! Found ya. |
| What's this one do? | Ooh. What's this one do? |
| Hey, Choomie. Still at it? | Hey, Choomie. Still at it, huh? |
| Still breathing. Don't make it weird. | Still breathin'. Don't make it weird. |
| Seen any good movies? | Seen any good movies lately? Be honest. |
| | Byeee! ...Kidding. I'm stayin'. *(new)* |
| | Uh... was I not supposed to be in here? *(new)* |

"Still breathin'" is the only line in this file that comes near her illness. You already had it, so it stays. Take it out if you'd rather these never touch it.

**Halloween** (`HalloweenLines`):

| Now | Talia (draft) |
| --- | --- |
| Happy Halloween, Choomie. | Happy Halloween, Choomie! |
| Trick or treat. Pick fast. | Trick or treat. Pick fast, huh? |
| Happy Halloween. Love the costume. Oh wait. | Love the costume. Oh wait. Kidding! |

**Her "no"** (`Declined`), when the AI turns a request down:

| Now | Talia (draft) |
| --- | --- |
| Nah. Not that one, Choomie. Ask me something else? | Nah. Not doin' that one. Ask me somethin' else, huh? |

**Her error line** (`Sparked`), when something breaks:

| Now | Talia (draft) |
| --- | --- |
| Chrome just kicked. Still here, though. Try me again? | Ugh, chrome just kicked. I'm fine. Try me again? |

## Not here on purpose
- **Things she says about the app** (`app/SelfKnow.cs`, "Right-click Capri" and so on). That's the app's help text, not her voice. It needs the name fix in number 2 of `CAPRI-LEFTOVERS.md`, not new wording.
- **Head pats** (`app/Capri.cs:1443`). That waits on your choice in number 11.
- **The fake blue screen** (`app/ChaosScreen.cs`). That's number 13, and can go here once you say you want it.
