# /resume: Load Context from the Previous Session

Adapted from lucasrosati/claude-code-memory-setup (MIT). Reads your Claude memory folder, no Obsidian needed.

Session logs are in `~/.claude/memory/sessions/`.

## Load

1. List `~/.claude/memory/sessions/` newest first. Read the latest 3 logs, or the number requested.
2. A pending item is a snapshot of the past. A quoted deadline counts as pending only if the date has not passed.

## Variants

- `/resume`: last 3 logs
- `/resume 5`: last 5 logs
- `/resume 5 wedding`: last 5 plus a search for "wedding" across all logs

## Output

- **Last session:** date and what was done
- **Decisions:** from the logs
- **Pending:** open items, with dates checked
- **State for resume:** from the latest log
- **Active context:** what was being worked on

If the `sessions/` folder does not exist yet, say so and suggest running /save at the end of this session.

End with: "Context loaded. What are we working on today?"
