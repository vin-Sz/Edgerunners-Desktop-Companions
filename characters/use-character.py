# The Mac and Linux half of characters/Use-Character.ps1: puts a character's name, lines and personality into a copy of the
# code that dotnet build -p:Character=<name> compiles (characters/Character.targets runs this, see characters/lucy/NOTES.md).
#
# It reads the same rule files as the Windows build, "Capri's code" => "hers", exact words, applied in order:
#   characters/<name>/names.txt, lines.txt and prompts.txt, then characters/<name>/mac-linux.txt for words that are only
#   in the Mac and Linux code (cross/), or that are worded differently there.
# Left out on purpose, because they're Windows work that Mac and Linux don't have yet: characters/app.txt (the app's own
# name, settings folder and updates), own-files.txt (her own folder), fewer-frames.txt and double-size.txt (her art), and
# her checks.txt, which is for the Windows self-test. Her mac-linux.txt has the Mac and Linux self-test's own swaps.
#
# python3 characters/use-character.py <character> <repo root> <list of files in> <folder for the copies> <list of files out>
# Files outside the repository, or in an obj/ or bin/ folder (ones dotnet makes itself), go through unchanged.
import hashlib
import os
import re
import sys


def fail(message):
    # MSBuild shows a line starting with "error :" as a build error.
    print("error : " + message)
    sys.exit(1)


def rules_from(path, character):
    rules = []
    if not os.path.isfile(path):
        return rules
    with open(path, encoding="utf-8-sig") as lines:
        for line in lines:
            rule = re.match(r'^"(.+)"\s*=>\s*"(.*)"\s*$', line.rstrip("\r\n"))
            if rule:
                rules.append((os.path.basename(path), rule.group(1), rule.group(2).replace("{character}", character.lower())))
    return rules


def personality_literal(path):
    # The same steps as Use-Character.ps1: no comments, no empty lines, no spaces at line ends, as one C# string.
    with open(path, encoding="utf-8-sig") as text:
        plain = text.read().replace("\r\n", "\n").replace("\r", "\n")
    plain = re.sub(r"<!--.*?(-->|$)", "", plain, flags=re.S)
    plain = "\n".join(line.rstrip() for line in plain.split("\n") if line.strip())
    if not plain:
        fail(path + " has no text.")
    stamp = hashlib.sha256(plain.encode("utf-8")).hexdigest()[:16]
    return '"' + plain.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"', stamp


def wear_personality(brain, literal, stamp):
    capri_stamp = re.search(r'internal const string DefaultStamp = "([0-9a-f]{16})";', brain)
    default = re.compile(r'internal const string DefaultPersonality =.*?";(?=\r?\n\s*\r?\n)', re.S)
    if not capri_stamp or not default.search(brain) or "Retired = new List<string> { " not in brain:
        fail("Can't find her default personality in Brain.cs any more. Check what Capri's code says now and update characters/use-character.py.")
    brain = default.sub(lambda _: "internal const string DefaultPersonality = " + literal + ";", brain, count=1)
    brain = brain.replace(capri_stamp.group(0), 'internal const string DefaultStamp = "' + stamp + '";')
    # Capri's stamp goes in Retired, so an untouched personality.md from Capri moves to hers and an edited one is kept.
    return brain.replace("Retired = new List<string> { ", 'Retired = new List<string> { "' + capri_stamp.group(1) + '", ')


def main():
    if len(sys.argv) != 6:
        fail("Usage: use-character.py <character> <repo root> <files in> <folder for the copies> <files out>")
    character, root, files_in, staged, files_out = sys.argv[1:]
    root = os.path.abspath(root)
    character_root = os.path.join(root, "characters", character)
    if not os.path.isdir(character_root):
        fail("No character called " + character + " in characters/.")

    rules = []
    for name in ("names.txt", "lines.txt", "prompts.txt", "mac-linux.txt"):
        rules += rules_from(os.path.join(character_root, name), character)
    own_personality = None
    if os.path.isfile(os.path.join(character_root, "builtin-personality.txt")):
        path = os.path.join(character_root, "personality.md")
        if not os.path.isfile(path):
            fail(path + " is missing.")
        own_personality = personality_literal(path)

    with open(files_in, encoding="utf-8-sig") as listed:
        sources = [line.strip() for line in listed if line.strip()]
    found = {}
    out = []
    wore_personality = False
    for source in sources:
        full = os.path.abspath(source)
        relative = os.path.relpath(full, root)
        parts = relative.replace("\\", "/").split("/")
        if relative.startswith("..") or "obj" in parts or "bin" in parts or not full.endswith(".cs"):
            out.append(source)
            continue
        with open(full, encoding="utf-8-sig") as text:
            code = text.read()
        for list_name, capri, hers in rules:
            count = code.count(capri)
            if count:
                code = code.replace(capri, hers)
                found[capri] = found.get(capri, 0) + count
        if own_personality and relative.replace("\\", "/") == "app/Brain.cs":
            code = wear_personality(code, *own_personality)
            wore_personality = True
        copy = os.path.join(staged, relative)
        os.makedirs(os.path.dirname(copy), exist_ok=True)
        # Only a changed file is written, so dotnet doesn't compile everything again when nothing changed.
        old = None
        if os.path.isfile(copy):
            with open(copy, encoding="utf-8") as text:
                old = text.read()
        if old != code:
            with open(copy, "w", encoding="utf-8", newline="") as text:
                text.write(code)
        out.append(copy)
    if own_personality and not wore_personality:
        fail("app/Brain.cs isn't in the build any more, so her personality can't go in. Update characters/use-character.py.")

    with open(files_out, "w", encoding="utf-8") as listed:
        listed.write("\n".join(out) + "\n")
    # Her mac-linux.txt is only for this build, so a line in it that matches nothing means Capri's code changed.
    for list_name, capri, hers in rules:
        if list_name == "mac-linux.txt" and capri not in found:
            print("warning : mac-linux.txt: \"" + capri + "\" isn't in the code any more. Check what Capri's code says now and update the line.")
    used = sum(1 for _, capri, _ in rules if capri in found)
    print("Building as " + character + ": " + str(used) + " of " + str(len(rules)) + " of her lines and names are in the Mac and Linux code ("
          + str(sum(found.values())) + " places)" + (", with her own personality (stamp " + own_personality[1] + ")" if own_personality else "")
          + ". The rest are only in the Windows code.")


main()
