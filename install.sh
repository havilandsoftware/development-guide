#!/bin/sh
# Bootstrap a machine for the Haviland Software development guide:
#   1. install Claude Code if it is missing (Anthropic's official installer)
#   2. install the /dev-check skill for your user, so it runs from any directory
#   3. install the current technology radar (radar/*.csv) the skill checks against
# Then run `claude` and type /dev-check — it audits the machine and offers to install what is missing.
#
#   curl -fsSL https://raw.githubusercontent.com/havilandsoftware/development-guide/main/install.sh | sh
#
# Use a different radar by passing a radar file name, a local path, or a URL:
#   curl -fsSL .../install.sh | sh -s -- 2026-09-28.csv
#   sh install.sh ./my-radar.csv
#
# Safe to re-run: it refreshes the skill and radar and leaves an existing Claude Code install alone.
set -eu

REPO=havilandsoftware/development-guide
RAW="https://raw.githubusercontent.com/$REPO/main"
DEST="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/dev-check"
RADAR="${1:-}"

fetch() {
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$1"
  elif command -v wget >/dev/null 2>&1; then wget -qO- "$1"
  else echo "error: need curl or wget" >&2; exit 1
  fi
}
die() { echo "error: $*" >&2; exit 1; }

# 1. Claude Code
if command -v claude >/dev/null 2>&1 || [ -x "$HOME/.local/bin/claude" ]; then
  echo "✓ Claude Code already installed"
else
  command -v bash >/dev/null 2>&1 || die "the Claude Code installer needs bash"
  echo "→ Installing Claude Code (https://claude.ai/install.sh)"
  fetch https://claude.ai/install.sh | bash
fi

# 2 + 3. Download everything to temp files first and only move them into place once both look
#        right, so a failed or partial download never replaces a working copy.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fetch "$RAW/.claude/skills/dev-check/SKILL.md" > "$tmp/SKILL.md"
[ "$(head -n 1 "$tmp/SKILL.md")" = "---" ] || die "downloaded skill is not a skill file"

if [ -z "$RADAR" ]; then
  # Newest radar = the YYYY-MM-DD.csv name that sorts last.
  RADAR=$(fetch "https://api.github.com/repos/$REPO/contents/radar?ref=main" \
    | grep -oE '"name": *"[0-9]{4}-[0-9]{2}-[0-9]{2}[^"]*\.csv"' | sed 's/.*"\([^"]*\)"$/\1/' \
    | sort | tail -n 1)
  [ -n "$RADAR" ] || die "could not find a radar file in $REPO/radar"
fi
case "$RADAR" in
  http://*|https://*) fetch "$RADAR" > "$tmp/radar.csv" ;;
  *) if [ -f "$RADAR" ]; then cp "$RADAR" "$tmp/radar.csv"
     else fetch "$RAW/radar/$(basename "$RADAR")" > "$tmp/radar.csv"; fi ;;
esac
[ "$(head -n 1 "$tmp/radar.csv" | tr -d '\r')" = "technology,version,url" ] \
  || die "$RADAR is not a radar file (first line must be: technology,version,url)"

mkdir -p "$DEST"
mv "$tmp/SKILL.md" "$DEST/SKILL.md"
mv "$tmp/radar.csv" "$DEST/radar.csv"
echo "✓ /dev-check installed to $DEST"
echo "✓ radar: $(basename "$RADAR")"
echo
echo "/dev-check checks these (project-only tools just when a project needs them),"
echo "then offers a checklist to install whichever are missing:"
tail -n +2 "$DEST/radar.csv" | tr -d '\r' | awk -F, '{ printf "  %-20s %-8s %s\n", $1, $2, $3 }'

if ! command -v claude >/dev/null 2>&1; then
  echo
  echo "Claude Code is in ~/.local/bin, which this shell does not have on PATH yet."
  echo "Open a new terminal (or add ~/.local/bin to PATH) first."
fi
echo
echo "Next: run  claude  and type  /dev-check"
