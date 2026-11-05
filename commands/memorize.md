# /memorize: Pin Something to Memory Now

Adapted from lucasrosati/claude-code-memory-setup (MIT). Writes to `~/.claude/memory/`.

Use mid-session to pin a decision, lesson or convention right away. /save does this at the end of a session.

1. With an argument: treat it as the one candidate. Without one: review the session for candidates (decision with its reason, reusable lesson, changed convention, durable fact, correction).
2. If it meets none of those, say why and write nothing.
3. Search `~/.claude/memory/` for the key term. Update an existing file if one covers it. Otherwise write one file for one topic and add one line to `MEMORY.md`.
4. Do not create a session log.
5. Report the file path and a one-line reason. If nothing was written, end with exactly: `Memory: nothing new to memorize.`
