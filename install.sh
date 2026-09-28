#!/bin/sh
# Bootstrap a machine for the Haviland Software development guide:
#   1. install Claude Code if it is missing (Anthropic's official installer)
#   2. install the /dev-check skill for your user, so it runs from any directory
# Then run `claude` and type /dev-check — it audits the machine and hands you the fix commands.
#
#   curl -fsSL https://raw.githubusercontent.com/havilandsoftware/development-guide/main/install.sh | sh
#
# Safe to re-run: it refreshes the skill and leaves an existing Claude Code install alone.
set -eu

SKILL_URL="https://raw.githubusercontent.com/havilandsoftware/development-guide/main/.claude/skills/dev-check/SKILL.md"
DEST="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/dev-check"

fetch() {
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$1"
  elif command -v wget >/dev/null 2>&1; then wget -qO- "$1"
  else echo "error: need curl or wget" >&2; exit 1
  fi
}

# 1. Claude Code
if command -v claude >/dev/null 2>&1 || [ -x "$HOME/.local/bin/claude" ]; then
  echo "✓ Claude Code already installed"
else
  command -v bash >/dev/null 2>&1 || { echo "error: the Claude Code installer needs bash" >&2; exit 1; }
  echo "→ Installing Claude Code (https://claude.ai/install.sh)"
  fetch https://claude.ai/install.sh | bash
fi

# 2. /dev-check skill — download to a temp file and only move it into place if it looks like a skill,
#    so a failed or partial download never replaces a working copy.
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
fetch "$SKILL_URL" > "$tmp"
[ "$(head -n 1 "$tmp")" = "---" ] || { echo "error: downloaded file is not a skill: $SKILL_URL" >&2; exit 1; }
mkdir -p "$DEST"
mv "$tmp" "$DEST/SKILL.md"
echo "✓ /dev-check installed to $DEST"

if ! command -v claude >/dev/null 2>&1; then
  echo
  echo "Claude Code is in ~/.local/bin, which this shell does not have on PATH yet."
  echo "Open a new terminal (or add ~/.local/bin to PATH) first."
fi
echo
echo "Next: run  claude  and type  /dev-check"
