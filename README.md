# mac-cleanup

Agent skill that frees space on a Mac by clearing regenerable junk only: caches, leftover installers, and unused package-manager store objects. Default cleanup does not touch documents, photos, projects, VMs, model weights, app profiles, or credentials. It also audits app credential remnants using metadata only. When you explicitly name obsolete apps to remove, it cleans only their verified files and credential items, with recoverable file removal and checks for shared dependencies.

Measure what is large, classify it, then delete only what a toolchain can download again. Prefer each tool's own cleanup (`brew cleanup`, `npm cache clean`, `uv cache prune`) over a blanket `rm`.

## Install

```bash
git clone https://github.com/vagdotdev/mac-cleanup.git
cd mac-cleanup
./install.sh            # ~/.agents/skills/mac-cleanup
./install.sh --claude   # ~/.claude/skills/mac-cleanup
./install.sh --cursor   # ~/.cursor/skills/mac-cleanup
./install.sh --grok     # ~/.grok/skills/mac-cleanup
```

Trigger it by asking the agent to clean the Mac, free disk space, or clear caches.

## License

MIT
