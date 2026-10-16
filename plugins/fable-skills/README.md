# fable-skills

Engineering-discipline skills for Claude Code, vendored from [adamentwistle/fable-skills](https://github.com/adamentwistle/fable-skills) at commit `c4d7ee0` (2026-09-04). MIT license, see `LICENSE`.

Skills load on demand when a task matches their description. Everything is namespaced `fable-skills:`, so nothing collides with personal skills or agents of the same name.

## What's included

- **39 skills** in `skills/`: verification and honest reporting, root-cause debugging, data-loss guard, untrusted-content guard (prompt injection), edge-case sweep, escalate-vs-decide, git hygiene, test design, security reflexes, and more.
- **5 agents** in `agents/`: `skeptic` (tries to refute a claim), `done-gate` (checks work against the original request), `plan-premortem` (critiques a plan before it runs), `fresh-eyes-reviewer` (zero-context code review), `blind-judge` (grades candidates with provenance stripped). All five run on Opus.

## What's left out

- `agents/codex.md`: drives OpenAI's Codex CLI and sends code to OpenAI. Needs a ChatGPT plan we don't run.
- `benchmark/`: grading data, not needed at runtime.

## Local changes from upstream

- The `description:` line in `skills/explain-at-the-right-level`, `skills/llm-app-code`, `agents/fresh-eyes-reviewer` and `agents/skeptic` is now a quoted string. Upstream leaves it unquoted with a `: ` inside, which is invalid YAML, so Claude Code dropped the description and those four never triggered. Wording is unchanged. Re-apply this when updating.

## Cost note

The skill and agent descriptions add about 20 KB (roughly 5k tokens) to every session where this plugin is enabled. The skill bodies only load when used.

## Updating

Re-copy `*/SKILL.md` and the five agent files from upstream, bump `version` in `.claude-plugin/plugin.json`, and update the commit hash above.
