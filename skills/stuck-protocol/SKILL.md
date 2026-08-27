---
name: stuck-protocol
description: |
  Escalate to the opus-advisor subagent when progress stalls, instead of
  quietly retrying or giving up. Use when the same error appears twice, when
  two consecutive steps produce no file changes while errors persist, when a
  fix attempt fails after two genuinely different tries, or when the user
  says an agent is going in circles. Designed to slot into overnight-code's
  existing 5-attempt verification loop, one step before it flags for human
  review.
---

# Stuck protocol (advisor inversion)

The driver — whatever model or session is doing the work — stays cheap, and that's a feature: execution is bulk, advice is grams. But a driver doesn't get to decide for itself that it's stuck; overconfidence is exactly the failure mode this guards against. Check the signals below instead of trusting a gut feeling.

## Stuck signals (any one fires the protocol)

1. The same error string on two consecutive attempts.
2. Two consecutive attempts with zero files changed while errors persist.
3. The same check (test, schema validation, build) failing after two genuinely different fix attempts.

If you're running inside `overnight-code`'s existing loop: this fires **between attempt 3 and attempt 5**, not at attempt 1 — let the cheap driver take its normal shot first. Don't let this replace that loop's own error-type classification; use it in addition, right before the loop would otherwise give up.

## Procedure

1. **Count consults this task.** At 3, stop: mark the task BLOCKED with the error attached, summarize for Patrick, move on. Never a 4th consult on the same goal — a third failure is a spec problem, not a model problem.
2. **Build the brief, nothing else in it:**
   ```
   GOAL: one line
   ATTEMPT x2: the last two attempts, ~200 characters each
   ERROR: the exact error or check failure, ~300 characters
   ```
3. Spawn `opus-advisor` with the brief. It returns guidance, never code.
4. Apply the guidance in the very next step, before anything of your own.
5. Log one line to the task's work log: consult #N, what it said, whether it worked.

## Hard rules

- Never ask the advisor to do the work. If its reply contains a full implementation, take the idea and discard the code — that's a sign it broke its own contract, not a gift.
- Never pad the brief with your own reasoning history. The advisor's value is clean context; a long brief poisons it.
- If the guidance fails, that counts as one of your two attempts toward the next consult.
- Three failed consults means the task is above this session's pay grade, and saying so — clearly, with the error attached — is the correct output, not a failure.
