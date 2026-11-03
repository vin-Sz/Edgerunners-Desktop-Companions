# Checks that every "Capri's words" => "hers" line in characters/app.txt and characters/<name>/names.txt still finds its
# words in app/*.cs, the same check characters/Use-Character.ps1 warns about when building. Run it after merging capri-desktop:
#   python3 ci/check-names.py
# It prints each line whose words are gone and exits 1 if there are any.
import glob
import os
import re
import sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
code = "".join(open(path, encoding="utf-8").read() for path in glob.glob(os.path.join(root, "app", "*.cs")))
lists = [os.path.join(root, "characters", "app.txt")] + sorted(glob.glob(os.path.join(root, "characters", "*", "names.txt")))
missing = 0
for path in lists:
    for line in open(path, encoding="utf-8"):
        rule = re.match(r'^"(.+)"\s*=>\s*"(.*)"\s*$', line.strip())
        if rule and rule.group(1) not in code:
            print(os.path.relpath(path, root) + ': "' + rule.group(1) + "\" isn't in app/*.cs any more")
            missing += 1
print("All name lines still match." if missing == 0 else str(missing) + " name line(s) need updating.")
sys.exit(1 if missing else 0)
