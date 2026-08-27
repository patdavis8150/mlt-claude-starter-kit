# Mountain Lodge Telluride — Organization-Wide Claude Standards

> This file loads automatically at every Claude session. All staff follow these practices.
> Lines marked [FILL IN: ...] must be completed before using this file.

---

## Memory

- [Property Profile](~/.claude/memory/property-profile.md) — core property facts, staff, systems, comp set
- [Team Roster](~/.claude/memory/team-roster.md) — staff profiles, roles, preferences
- [Memory Index](~/.claude/memory/MEMORY.md) — full index, add project files here as work accumulates

> To update memory after a session: `/anthropic-skills:consolidate-memory`  
> To add a project: ask Claude to save a memory file, then add it to MEMORY.md

---

## Your Property Profile

```
Property:    Mountain Lodge Telluride
Address:     457 Mountain Village Blvd, Telluride, CO 81435
Website:     mountainlodgetelluride.com
Phone:       970-369-5000
Type:        Mountain resort — lodge rooms, suites, condominiums, 10 luxury log cabins
Location:    Mountain Village, ski-in/ski-out, 0.3 miles from regional airport

Rooms/Units: [FILL IN: total room/unit/cabin count]
F&B:         The View Restaurant, poolside food & beverages
Amenities:   Ski-in/ski-out, outdoor heated pool, 2 hot tubs, fitness center, steam room,
             EV charging (Tesla/Rivian/J-1772), ski shop, free shuttle, on-site parking
Opened:      1999

Managing Director:       Casey Kaut
Board President:         Dana Conneally
Sales & Digital Marketing Manager: Hank Williams (O: 970-369-6018)
[FILL IN: Revenue Manager, Events Manager, F&B Director, Front Office Manager]

PMS / Booking System:  [FILL IN: e.g. Amadeus, Opera, Delphi, Salesforce]
CMS (website):         [FILL IN: e.g. WordPress, ProcessWire, Squarespace]
Web Developer:         [FILL IN: Name + email of your dev contact for server-side changes]
GSC Email:             [FILL IN: Google account used for Google Search Console]

Ownership / Management Company: [FILL IN: if applicable]

Top 3–5 Competitors:
  [FILL IN: e.g. Madeline Hotel Telluride, Hotel Telluride, Element 52, Inn at Lost Creek]

Primary Group Segments:
  [FILL IN: e.g. corporate retreats, ski groups, weddings, incentive travel, associations]

Events Space:
  [FILL IN: room names, capacities, sq footage — e.g. "Mountain View Room: 80 pax, 1,200 sq ft"]

F&B Minimums:
  [FILL IN: e.g. "Dinner buyout: $8,000 minimum / Corporate lunch: $3,500 minimum"]

Awards / Recognition:
  [FILL IN: TripAdvisor Traveler's Choice, Forbes, AAA Diamond, local awards]
```

---

## Power Features

### 1. ultrathink (max reasoning on hard problems)
Add `ultrathink` to any prompt involving architecture decisions, revenue strategy, complex debugging.

```
ultrathink: redesign our group booking workflow to handle peak ski season volume
```

### 2. Plan Mode (Ctrl+G to edit before execution)
For multi-step projects, start in Plan Mode. Claude creates a plan. Press Ctrl+G to edit it.

```
claude --permission-mode plan
```

### 3. Interview Mode (write the spec before you build)
Before any new initiative:

```
I want to build [brief description]. Interview me in detail
using the AskUserQuestion tool. Ask about technical implementation,
edge cases, and tradeoffs. Keep interviewing until we've covered everything,
then write a complete spec to SPEC.md.
```

### 4. Subagents (keep main context clean)
For research, file exploration, or system mapping, use subagents.

```
Use subagents to investigate how our current wedding pricing compares
to competitor properties in Telluride and summarize findings.
```

### 5. /compact Focus on X (targeted summarization)
When context fills up, never use /clear. Instead:

```
/compact Focus on the revenue analysis and group booking data
```

### 6. Writer/Reviewer Pattern
Session A writes. Session B reviews with fresh context.
Use for proposals, pitch decks, contracts, marketing copy, any high-stakes deliverable.

---

## Agents & Skills (in this repo — pull to update, no more zip files)

Two agents and three skills live in `agents/` and `skills/` at the repo root. Setup, once:

```
Copy each file in agents/  into ~/.claude/agents/
Copy each folder in skills/ into ~/.claude/skills/
Restart Claude Code, or start a new session.
```

No build step, no config. `git pull` any time to get the latest version — nothing to re-download or re-send.

| Name | Type | Use For |
|---|---|---|
| `fresh-eyes-reviewer` | agent, call by name | Pass/fail review with zero shared context — point it at a schema push, contract, or client email before it ships |
| `opus-advisor` | agent, call by name | Stronger second opinion when an agent gets stuck — gives direction only, never writes code |
| `stuck-protocol` | skill, activates on its own | Escalates to the advisor at the right moment in a long agent run |
| `standing-goals` | skill, activates on its own | Rechecks things already confirmed working, so regressions surface on their own |
| `graph-engineering` | skill, activates on its own | Checklist for designing multi-agent fan-out work before it runs |

---

## Hooks — Automate What You Keep Forgetting

Hooks run shell commands at specific points in Claude's workflow.
See `settings.json` for the full hook config included in this kit.

### What's pre-configured
- **SessionStart**: loads your property profile + org standards every session
- **UserPromptSubmit**: enforces brainstorm → plan → execute workflow on build tasks
- **PostToolUse**: reminds to run /simplify after every file write
- **PostToolUse (Bash)**: detects repeated errors, suggests switching to Gemini 2.5 Pro

---

## Caveman Mode — Response Style

Caveman mode enforces ultra-terse, high-signal responses. Drops filler, keeps substance.

Activate: `/caveman full` or `/caveman ultra`  
Deactivate: `stop caveman` or `normal mode`

Pattern: `[thing] [action] [reason]. [next step].`

Automatically suspends for security warnings, irreversible actions, and multi-step sequences.

---

## Skills Quick Reference

Skills are invoked with `/skill-name`. Key ones for your team:

### General Manager
| Skill | Use For |
|---|---|
| `/ceo-advisor` | Board prep, owner communications, strategic decisions |
| `/chief-of-staff` | Routing complex decisions, cross-dept alignment |
| `/accountability-engine` | Meeting transcript → action items with owners |
| `/the-radar` | Weekly competitive intelligence briefing |
| `/meeting-prep` | Full briefing doc before any meeting |
| `/pptagent` | Board decks, owner presentations |

### Sales & Marketing
| Skill | Use For |
|---|---|
| `/sales:call-prep` | Briefing before a group sales call |
| `/sales:draft-outreach` | Brand-consistent cold emails and follow-ups |
| `/sales:account-research` | Research any lead before contact |
| `/marketing:content-creation` | Brand-consistent content |
| `/brand-voice:enforce-voice` | Run content through brand guidelines |
| `/ai-discoverability-audit` | Score how AI describes your property |

### Events
| Skill | Use For |
|---|---|
| `/pptagent` | Event proposals and presentations |
| `/accountability-engine` | Post-event debrief → action items |
| `/operations:process-doc` | Document event SOPs |

### Guest Services
| Skill | Use For |
|---|---|
| `/customer-support:draft-response` | Guest response drafts |
| `/customer-support:ticket-triage` | Issue prioritization |
| `/content-humanizer` | Make responses sound human |

---

## Behavioral Standards (Auto-Applied Every Session)

### Before Starting Any Work
1. Use AskUserQuestion to clarify scope, audience, and deliverable format
2. Create a TodoList for any task with 3+ steps
3. Read relevant memory files before creating documents

### Quality Standards
1. Guest-facing content: warm, confident, mountain-authentic tone
2. All documents: Arial 11 unless specified otherwise
3. Emails and client comms: no dashes, under 120 words, one idea per line, clear next step
4. Revenue and strategy work: frame at GM/ownership level with portfolio impact
5. Every deliverable gets a verification step before presenting to user

### Senior Mindset
1. 80% effort on planning and review, 20% on execution
2. Brainstorm requirements first, then plan, then execute, then review
3. Every code change auto-formatted, auto-linted via hooks

---

## Department Quick Reference

| Department | Priority Skills |
|---|---|
| GM / Leadership | ceo-advisor, chief-of-staff, accountability-engine, the-radar |
| Sales & Marketing | sales:*, marketing:*, brand-voice:*, ai-discoverability-audit |
| Revenue | pricing-strategy, sales:forecast, data:analyze, data:build-dashboard |
| Events | pptagent, meeting-prep, operations:process-doc, accountability-engine |
| Guest Services | customer-support:*, content-humanizer, testimonial-collector |
| HR | accountability-engine, operations:process-doc, internal-narrative |
| Engineering / IT | mcp-builder, tech-debt-tracker, security-review, operations:runbook |
