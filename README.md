# Mountain Lodge Telluride — Claude Starter Kit

Provided by: Patrick Davis, DOSM, Manor Vail Lodge  
Contact: patrick.davis@manorvail.com

---

## What's in This Kit

| File | Purpose |
|---|---|
| `CLAUDE.md` | Global org standards — loads every Claude session automatically |
| `settings.json` | Hooks + plugin config — workflow discipline, caveman mode, quality checks |
| `property-profile.md` | Your property memory file — Claude loads this every session |
| `agents/`, `skills/` | Fresh Eyes Reviewer, Opus Advisor, Stuck Protocol, Standing Goals, Graph Engineering — see Step 6 |
| `hooks/` | `gemini-fallback.sh` — required by the PostToolUse hook in `settings.json` |
| `README.md` | This file |

---

## Step 1: Install Claude Code

Claude Code is the CLI tool that powers everything.

```bash
npm install -g @anthropic-ai/claude-code
```

Requires Node.js 18+. Then authenticate:

```bash
claude
```

Follow the login prompt with your Anthropic/Claude account.

---

## Step 2: Drop CLAUDE.md into your user config

```bash
# Mac/Linux
cp CLAUDE.md ~/.claude/CLAUDE.md

# Windows (PowerShell)
cp CLAUDE.md "$env:USERPROFILE\.claude\CLAUDE.md"
```

**Before you do this:** Open `CLAUDE.md` and fill in every line marked `[FILL IN: ...]`.  
These are property-specific details Claude will use in every session.

---

## Step 3: Drop settings.json into your user config

```bash
# Mac/Linux
cp settings.json ~/.claude/settings.json

# Windows (PowerShell)
cp settings.json "$env:USERPROFILE\.claude\settings.json"
```

**Before you do this:** Open `settings.json` and update any file paths that reference a username.  
Search for `YOUR_USERNAME` and replace with your Windows/Mac username.

Also copy the hook script it depends on:

```bash
# Mac/Linux
cp hooks/gemini-fallback.sh ~/.claude/hooks/

# Windows (PowerShell)
cp hooks\gemini-fallback.sh "$env:USERPROFILE\.claude\hooks\"
```

---

## Step 4: Install plugins

Run these two commands in your terminal:

```bash
claude plugin install superpowers@claude-plugins-official
claude plugin install code-simplifier@claude-plugins-official
```

These give you:
- **Superpowers**: brainstorm → plan → execute → simplify workflow discipline
- **Code Simplifier**: auto-quality-checks after every file write

---

## Step 5: Set up persistent memory

Copy all three memory files into your Claude memory directory:

```bash
# Mac/Linux
mkdir -p ~/.claude/memory
cp memory/MEMORY.md ~/.claude/memory/MEMORY.md
cp memory/property-profile.md ~/.claude/memory/property-profile.md
cp memory/team-roster.md ~/.claude/memory/team-roster.md

# Windows (PowerShell)
mkdir "$env:USERPROFILE\.claude\memory"
cp memory\MEMORY.md "$env:USERPROFILE\.claude\memory\MEMORY.md"
cp memory\property-profile.md "$env:USERPROFILE\.claude\memory\property-profile.md"
cp memory\team-roster.md "$env:USERPROFILE\.claude\memory\team-roster.md"
```

The `CLAUDE.md` in this kit already references these files — Claude loads them automatically every session.

**Fill in before using:**
- `property-profile.md` — room count, systems, comp set, event space specs, F&B minimums
- `team-roster.md` — full staff roster with emails and focus areas

**To build memory dynamically** (Claude writes its own notes as projects accumulate):
```
/anthropic-skills:consolidate-memory
```
Run this at the end of any significant work session. Claude extracts what's worth remembering and updates the relevant files. Add new project files to `MEMORY.md` as they're created.

**How memory grows over time:**
1. Start a project → Claude creates `~/.claude/memory/project-[name].md`
2. Add it to `MEMORY.md` index
3. Every future session loads it automatically — no re-explaining context

---

## Step 6: Copy the agents and skills

```bash
# Mac/Linux
cp agents/*.md ~/.claude/agents/
cp -r skills/* ~/.claude/skills/

# Windows (PowerShell)
cp agents\*.md "$env:USERPROFILE\.claude\agents\"
cp -r skills\* "$env:USERPROFILE\.claude\skills\"
```

Restart Claude Code. `fresh-eyes-reviewer` and `opus-advisor` you call by name; `stuck-protocol`, `standing-goals`, and `graph-engineering` activate on their own. Full descriptions in `CLAUDE.md` under "Agents & Skills."

To get updates later, just `git pull` — no more zip files over email.

---

## Step 7: Install MCP Connectors (optional but high-value)

Each connector plugs Claude into a real app. Install only what you use.

**Outlook / Teams / SharePoint** (highest ROI for sales teams):
```bash
claude mcp add @anthropic/mcp-outlook
```

**Desktop Commander** (file system access):
```bash
claude mcp add @anthropic/desktop-commander
```

**PDF Tools**:
```bash
claude mcp add @anthropic/pdf-tools
```

Full connector list and install instructions:  
https://docs.anthropic.com/claude-code/mcp

---

## Step 8: Test it

Open a new Claude Code session:

```bash
claude
```

Type: `/plan-my-day`  
If it runs a structured daily planning workflow, the setup worked.

Type: `/sales:call-prep`  
If it asks you for a prospect name and builds a briefing doc, skills are working.

---

## What to Build Next (30-Day Roadmap)

**Week 1:** Get team members set up with the same CLAUDE.md + settings.json  
**Week 2:** Connect Outlook MCP — Claude reads email history before drafting outreach  
**Week 3:** Run `brand-voice:generate-guidelines` — feed it your existing marketing docs  
**Week 4:** Set up weekly Radar briefing — competitive intel delivered automatically  

---

## Questions

Reach out to Patrick Davis at Manor Vail Lodge.  
We've been running this setup since early 2026 and are happy to share what works.

patrick.davis@manorvail.com | 970.343.6119
