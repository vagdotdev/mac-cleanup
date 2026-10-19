#!/usr/bin/env bash
# Install mac-cleanup next to other agent skills.
#   ./install.sh            -> ~/.agents/skills/mac-cleanup
#   ./install.sh --claude   -> ~/.claude/skills/mac-cleanup
#   ./install.sh --cursor   -> ~/.cursor/skills/mac-cleanup
#   ./install.sh --grok     -> ~/.grok/skills/mac-cleanup
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.agents/skills/mac-cleanup"
case "${1:-}" in
  --claude) dest="$HOME/.claude/skills/mac-cleanup" ;;
  --cursor) dest="$HOME/.cursor/skills/mac-cleanup" ;;
  --grok) dest="$HOME/.grok/skills/mac-cleanup" ;;
  "") ;;
  *) echo "usage: ./install.sh [--claude|--cursor|--grok]" >&2; exit 2 ;;
esac
mkdir -p "$dest"
cp "$ROOT/SKILL.md" "$dest/SKILL.md"
echo "installed $dest/SKILL.md"
