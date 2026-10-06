"""Run every Linux install command in the current radar on a bare Ubuntu, the way /dev-check
would, then run the skill's own Step 2 checks against the radar floors.

Mirrors dev-check Step 7: dependency order from `requires`, `bash -o pipefail`, the nvm and uv prefixes,
and sudo (passwordless here — on a real machine the developer runs those lines).
"""
import csv, re, subprocess, sys, time

radar = "radar/" + open("radar/LATEST").read().strip()
head, *rows = list(csv.reader(open(radar)))
tools = {r[0]: dict(zip(head, r)) for r in rows}
NVM = ". ~/.nvm/nvm.sh && { nvm use --silent default >/dev/null 2>&1 || :; } && "
UV = 'export PATH="$HOME/.local/bin:$PATH" && '

def runnable(t):
    return t in tools and tools[t]["linux"] not in ("", "-")

order, seen = [], set()
def visit(t):
    if t in seen or not runnable(t):
        return
    seen.add(t)
    for r in filter(None, tools[t]["requires"].split(";")):
        visit(r)
    order.append(t)
for t in tools:
    visit(t)

results, failed = [], set()
for t in order:
    reqs = [r for r in tools[t]["requires"].split(";") if r]
    if any(r in failed for r in reqs):
        failed.add(t); results.append((t, "skipped", 0, "a requirement failed")); continue
    cmd = tools[t]["linux"]
    if {"Node.js", "nvm"} & set(reqs):
        cmd = NVM + cmd
    if "uv" in reqs:
        cmd = UV + cmd
    start = time.time()
    p = subprocess.run(["bash", "-o", "pipefail", "-c", cmd], capture_output=True, text=True,
                       stdin=subprocess.DEVNULL)
    tail = (p.stdout + p.stderr).strip().splitlines()[-1:] if p.returncode else []
    if p.returncode:
        failed.add(t)
    results.append((t, f"rc={p.returncode}", round(time.time() - start), " ".join(tail)[:150]))

skill = open(".claude/skills/dev-check/SKILL.md").read()
step2 = skill[skill.index("## Step 2"):skill.index("## Step 3")]
checks = {re.sub(r"[†‡]| \(macOS only\)", "", n).strip(): c.replace("\\|", "|")
          for n, c in re.findall(r"^\| ([^|`]+?) \| `(.+)` \|$", step2, re.M)}

def floor_ok(out, floor):
    if floor == "any":
        return bool(out.strip())
    m = re.search(r"\d+(?:\.\d+)*", out)
    if not m:
        return False
    have = [int(x) for x in m.group().split(".")]
    want = [int(x) for x in floor.rstrip("+").split(".")]
    return have[:len(want)] >= want

for t in order:
    if t in failed or t not in checks:
        continue
    # A new interactive shell, as the developer's next terminal would be.
    p = subprocess.run(["bash", "-ic", checks[t]], capture_output=True, text=True, stdin=subprocess.DEVNULL)
    out = p.stdout.strip().splitlines()[0] if p.stdout.strip() else ""
    if not floor_ok(out, tools[t]["version"]):
        failed.add(t)
        results.append((t, "check", 0, f"floor {tools[t]['version']}, saw {out or p.stderr.strip()[-80:]!r}"))

print(f"radar {radar}\n")
for t, status, secs, note in results:
    mark = "FAIL" if t in failed else "ok"
    print(f"{mark:4} {t:20} {status:8} {secs:4}s  {note}")
manual = [t for t, r in tools.items() if r["linux"] == ""]
print(f"\nmanual on Linux (no command): {', '.join(manual) or 'none'}")
sys.exit(1 if failed else 0)
