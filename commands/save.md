# /save: Save the Session and Consolidate Memory

Adapted from lucasrosati/claude-code-memory-setup (MIT). Writes to your Claude memory folder, no Obsidian needed.

Memory folder: `~/.claude/memory/` (the one from Step 5 of the README). Session logs go in `~/.claude/memory/sessions/`.

Run both phases in order. When in doubt in Phase 2, do not write.

## Phase 1: Session log (always)

1. Create `~/.claude/memory/sessions/YYYY-MM-DD-short-description.md` (kebab-case). Never overwrite. If the name exists, add HHMM after the date.
2. Keep it short:
   - `## What was done`
   - `## Decisions made` (or "No new decisions.")
   - `## Pending`
   - `## State for resume`: task, tests run and result, blockers, exact next action
   - `## Files modified` (path, what changed)
   - `## Memory written` (filled after Phase 2)
3. Never paste the raw conversation. Never write passwords, keys or guest personal data.
4. Do not add session logs to `MEMORY.md`. The index is for durable facts only.

## Phase 2: Memory consolidation (conditional)

A candidate must be one of: a decision with its reason, a reusable lesson or pitfall, a changed convention, a durable fact (rates, systems, contacts, policies), or a correction of something already remembered. Progress, finished tasks and unresolved investigations are not candidates.

For each candidate:
1. Search `~/.claude/memory/` for the key term first. If a file covers it, update that file. Never create a duplicate. Remove a memory that turned out wrong.
2. Otherwise write one file for one topic, then add one line to `MEMORY.md`.
3. A convention that changes how Claude behaves: show the proposed line and wait for a yes before writing it.

## Report

```
Session log: <path>
Memory:
- created: <path> (reason)
- updated: <path> (reason)
```
or
```
Session log: <path>
Memory: nothing to consolidate this session
```
