---
name: standing-goals
description: |
  Re-verify things that were already confirmed working, on a schedule,
  forever — so a silent regression (a page losing its schema, a rate no
  longer matching, a template drifting) gets caught by a cron job instead
  of by Patrick noticing months later. Use when something just got verified
  and shipped (a live page, a schema push, a report) and is worth protecting
  from silently breaking again. Different from a one-time verification: this
  is the mechanism that keeps checking after everyone stops watching.
---

# Standing goals (regression watch)

A goal you verify once is an assumption with a timestamp. This skill turns "I checked it and it worked" into a fact that gets re-checked automatically, so a break shows up as an alert instead of as something Patrick discovers by accident.

## When to create a standing goal

Right after you ship and verify something load-bearing:
- A live page/schema push (matches this session's AEO deployment — verified via `curl` at ship time, but nothing re-checks it afterward without this).
- A report or feed that needs to keep matching its source.
- Any "this is now true" claim you'd be embarrassed to have quietly stop being true.

Don't create one for anything that's obviously going to change on its own (seasonal copy, a promo that's meant to expire) — a standing goal is for things that should stay true until someone deliberately changes them.

## Creating a goal

One file per goal in `goals/`, named for what it protects:

```markdown
---
predicate: <a shell command; exit 0 means the goal holds>
born: <date created>
status: satisfied
last-pass: <date last confirmed>
on-violation: alert. do not auto-fix.
---

One line: what this protects and why it matters.
```

Rules for the predicate:
- It must be a real shell command, not an adjective. If a shell can't check it, a model can't either — don't write a goal you can't automate.
- Cheap and read-only. `curl` + `grep`, `JSON.parse`, a test command — never something that mutates state.
- A timeout counts as a violation, not a pass. An expensive predicate is a broken one.

## Running the check

`scripts/verify_goals.py goals/` runs every goal's predicate and reports exactly which ones broke, with the date they last held. Wire it into a scheduled task (daily is reasonable for anything web-facing) alongside the existing `offers-page-audit` and `aeo-radar-weekly` tasks — same cron pattern, different job.

**On violation: wake Patrick up, don't silently fix it.** Auto-fixing a regression hides the fact that something upstream broke it (a CMS update, an accidental edit, a template change) — the fix belongs to a human decision, the detection doesn't.

## Example

See `goals/aeo-schema-live.md` for a real one, created from this session's ProcessWire/AEO schema deployment — it re-checks the exact `curl` assertions used to verify the pages went live in the first place.
