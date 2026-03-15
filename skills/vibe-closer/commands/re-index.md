---
description: "Re-index workspace files — update CLAUDE.md and AGENTS.md to reflect any new, renamed, or removed files"
---

# Re-Index Workspace

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Step 1: Crawl the workspace

List all files in the pipeline directory recursively. **Exclude** these from the index:
- `progress/` directory (learnings and performance reports — tracked separately)
- `.context/` directory (internal agent state)
- Hidden files and directories (`.git/`, `.DS_Store`, etc.)
- `CLAUDE.md` and `AGENTS.md` themselves (they are the index, not indexed content)

## Step 2: Parse the current index

Read the existing `CLAUDE.md` and extract the **Quick Reference** section. Build a set of all file paths currently listed (the backtick-wrapped paths, e.g. `config.md`, `profile/icps.md`).

## Step 3: Diff filesystem vs index

Compare the files found on disk (Step 1) against the indexed paths (Step 2):

- **Added**: files on disk that are NOT in the Quick Reference
- **Removed**: paths in Quick Reference that no longer exist on disk

If there are no differences, tell the user: "Workspace index is up to date — no changes needed." Update `{{LAST_REINDEX_CHECK}}` in `config.md` to the current ISO 8601 timestamp and stop.

## Step 4: Describe new files

For each **added** file, read its full content. Infer:
- A short **label** (1-3 words, matching the style of existing entries like "ICPs", "Tone", "Email Templates")
- A brief **description** (matching style: "ideal customer profiles", "voice and style guidelines")

## Step 5: Present changes

Show the user a summary before applying:

```
## Workspace Index Changes

### New files to add
- **[Label]**: `[path]` — [description]
- ...

### Files to remove (no longer on disk)
- `[path]` — [old label]
- ...
```

Wait for user confirmation before proceeding.

## Step 6: Update the index

1. Update the **Quick Reference** section in `CLAUDE.md`:
   - Add entries for new files
   - Remove entries for deleted files
   - Preserve the order and formatting of unchanged entries
2. Copy the updated `CLAUDE.md` content to `AGENTS.md` — these must stay in sync
3. Update `{{LAST_REINDEX_CHECK}}` in `config.md` to the current ISO 8601 timestamp

## Step 7: Confirm

Print a short confirmation:
```
Re-index complete: [N] added, [M] removed. CLAUDE.md and AGENTS.md updated.
```
