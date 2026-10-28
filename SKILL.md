---
name: mac-cleanup
description: >
  Survey this Mac and free space by clearing regenerable junk only — caches,
  leftover installers, unused package-manager store objects — never documents,
  photos, projects, VMs, models, or app profiles. Use when the user wants to
  clean up the Mac, free disk space, clear caches, make it smoother or faster,
  reclaim storage, audit leftover app credential records, or runs /mac-cleanup.
  Remove obsolete apps and their credential remnants only when the user
  explicitly names or approves those apps.
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

Do not `sudo`. Do not empty Trash unless asked. Do not touch `/Applications` on a default cleanup or modify system paths.
An explicit request to uninstall named obsolete apps is handled by the
app-remnant workflow below; it does not authorize removing unrelated apps. Do not “tidy” files by moving them around.

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

## App and credential remnants

Include a metadata-only check for obsolete app storage in a Mac survey. Check
user Keychain generic-password service/label metadata for `Safe Storage` records
and other app-specific credential services, alongside installed application
bundle IDs, CLI/package inventories and the matching Application Support,
Preferences, Containers, Group Containers, LaunchAgents and dot-config paths.
Never dump password/token values or use `security dump-keychain -d` to discover
remnants. Keep account identifiers out of public reports.

An absent app is a candidate, not proof that its key is unused. A browser,
editor or Electron app can still need its storage key to decrypt its profile;
a CLI may be installed without an application bundle. Check exact identities,
shared components and retained profiles before classifying an item as obsolete.
Do not treat a credential record as a cache or remove all `Safe Storage` items.

Default cleanup reports these candidates without deleting their profiles,
settings, credentials or keychains. When the user explicitly names apps to
remove, that request authorizes cleanup of those apps only:

- Inventory exact bundle IDs, package names, paths, credential services and
  matching accounts first. Distinguish current apps from historical entries.
- Quit the named apps normally. Prefer the vendor/package-manager uninstaller;
  preserve unique work from their profiles and do not remove shared runtimes.
- Use recoverable Trash or an explicit quarantine for app files and settings.
  Explain any retained recovery copy. Do not empty Trash by default.
- Delete only exact app-owned credential items covered by the request, with
  supported export/backup when recovery matters. Never replace/delete the
  entire login keychain, numbered Local Items/iCloud folders, passkeys, SSH
  keys or unrelated app secrets. Keep native authentication controls in place.
- Verify app/CLI/package and matching credential remnants after removal.
  Report any protected or ambiguous paths that remain. A failed permission
  check is not evidence that cleanup succeeded, and deleting a local token
  does not revoke its remote session.

During migration, explicitly retired apps and services must also be excluded
from restoration. A recovery archive may retain a disclosed backup; do not
silently reintroduce that app's profile or key during a general restore.

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
