# Mountain Lodge Telluride — Memory Index

> This file is Claude's memory index. It loads every session via CLAUDE.md.
> Each line points to a memory file. Claude reads linked files automatically.
> Add new entries as projects accumulate. Remove stale ones during cleanup.

---

## Active Memory Files

- [Property Profile](property-profile.md) — core property facts, staff, systems, comp set
- [Team Roster](team-roster.md) — staff profiles, roles, preferences, working styles

---

## How to Add a Project Memory

When you start a significant project (SEO overhaul, PMS migration, wedding season prep, etc.):

1. Ask Claude: `Save a memory file for this project to ~/.claude/memory/`
2. Claude creates `project-[name].md` with current state, decisions, and next steps
3. Add the file to this index: `- [Project Name](project-name.md) — one-line description`

Claude will then load that project context in every future session automatically.

---

## How to Update Memory

At the end of any significant work session, run:

```
/anthropic-skills:consolidate-memory
```

Claude reviews the session, extracts what's worth remembering, and updates the relevant memory files. Takes about 30 seconds. Saves hours of re-explaining context in future sessions.

---

## Memory Files Archive

Move completed or stale entries here rather than deleting — useful for lookback.

<!-- Example:
- [Project GEO Optimization 2026](archive/project-geo-2026.md) — completed Mar 2026
-->
