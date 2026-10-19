---
name: mac-cleanup
description: >
  Survey this Mac and free space by clearing regenerable junk only — caches,
  leftover installers, unused package-manager store objects — never documents,
  photos, projects, VMs, models, or app profiles. Use when the user wants to
  clean up the Mac, free disk space, clear caches, make it smoother or faster,
  reclaim storage, or runs /mac-cleanup.
metadata:
  short-description: Free Mac space without touching real files
---

# Mac cleanup

This Mac, this moment. Look at what is actually using space, then decide.

There is no fixed list of folders to wipe. Last time’s targets may be empty;
something new may have grown. Measure, classify, act on regenerable stuff,
reclaim the APFS space, and say what you left alone.

If it isn’t macOS, stop.

## The test

For each large thing, ask: **if this vanished, is the unique work gone, or
can a toolchain just download it again?**

- Unique → leave it. Documents, Desktop, Downloads, Photos, iCloud, project
  trees, mail, messages, SSH keys, keychains, `.env`, credentials.
- Chosen downloads → leave unless they name it. VMs (Colima/Docker disks),
  local LLM weights (LM Studio, Hugging Face), editor local history
  (Cursor `snapshots`), app profiles and settings (`Application Support/…/User`,
  browser profiles — not `Library/Caches`).
- Regenerable → fair game. Package-manager caches, browser/updater/toolchain
  caches under `Library/Caches`, old logs, Xcode DerivedData, leftover
  Homebrew kegs, `npx` extract trees, bun/uv/pip/pnpm unused store objects.

Prefer the tool’s own cleanup (`brew cleanup`, `npm cache clean`, `uv cache prune`,
`pip cache purge`, `pnpm store prune`) over inventing `rm -rf`. If there is no
tool, only delete a directory you have classified as cache.

Do not `sudo`. Do not empty Trash unless asked. Do not touch `/Applications`
or system paths. Do not “tidy” files by moving them around.

## How to look

Start from free space (`df`) and the largest items under `$HOME` and
`$HOME/Library`. Then open only the buckets that are large. Typical ones here:

- `~/Library/Application Support` — Cursor has been huge; **User** and
  **snapshots** are settings/history, not cache. Logs / CachedData / GPUCache
  are cache.
- `~/Library/Caches` — usually safe by folder, once you’ve named what it is.
- `~/.npm`, `~/.bun/install/cache`, `~/.cache/uv`, `~/Library/pnpm` — caches.
- `~/.colima`, `~/.lmstudio/models`, `~/Documents`, `~/Downloads` — not caches.

Skip a path you cannot classify.

## How to act

1. Record free space before.
2. Clear only what you classified as regenerable.
3. APFS often keeps the blocks in **local Time Machine snapshots**. After
   deletes, reclaim with `tmutil thinlocalsnapshots / <bytes> 4` so `df`
   actually moves. That drops on-disk restore points, not the files, and not
   an external Time Machine backup. Don’t delete `com.apple.os.update-*`.
4. Record free space after.

If they asked to free a lot and the only remaining wins are Colima, models, or
Cursor snapshots, **name the sizes and wait**. Don’t take those on a default
cleanup.

## What to say after

Lead with how much space moved (`df` before → after). Then:

- what you cleared (and that it will come back on next install/run)
- what you left, and why
- one or two optional next targets, only if they are actually large

If they ask whether they lost anything: **no**, unless you thinned local
snapshots (restore-points for *today on this Mac* may be gone) or you cleared
a cache they would have to re-download. Their files should still be there.
