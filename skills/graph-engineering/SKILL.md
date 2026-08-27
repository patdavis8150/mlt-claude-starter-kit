---
name: graph-engineering
description: |
  Pre-flight checklist for designing a multi-agent Workflow script BEFORE
  writing it — not a replacement for the Workflow tool's own documentation,
  a distilled mental model to run through first. Use when about to build
  anything with parallel()/pipeline()/agent() fan-outs, when a task feels
  like it wants "many agents," or when deciding whether a graph is even
  the right shape for the job.
---

# Graph engineering checklist

A multi-step agent task is a graph whether you draw it or not. Most people
draw the worst possible one by default: a straight line, where step two
waits for step one even when it doesn't need to. This is the checklist that
catches that before tokens get spent on it.

## Step 0 — do you need a graph at all?

Skip it if any of these are true:
- The task is small or isolated (one function, one bug). Coordination is
  pure overhead.
- You want to approve every step. A graph's whole point is running wide
  without a human in the loop at each node — a tight leash defeats it.
- It's exploratory — you don't yet know what "done" looks like. One
  steerable agent beats a fleet committed to a plan you wrote before you
  understood the problem.
- The steps genuinely depend on each other in sequence. Forcing width onto
  sequential work adds coordination cost for zero speedup.

## Step 1 — the fake-edge test (5 minutes, no tools, do this first)

Write every step as a box. Draw an arrow between each consecutive pair.
Then, for every arrow, ask one question:

**Does this step read the output of the step before it?**

Yes → the edge is real, keep the order. No → there's no edge, and the wait
between those boxes is pure latency bought for nothing. The tell is "and
then" — check whether you meant "and then, using that result" or just "and
then, next." Two or three fake edges hide in almost every workflow drawn
as a straight line. If the test finds zero fake edges, there's no graph
to build — it's a loop, and a loop is fine as-is.

## Step 2 — give every node a contract

A node you can't reason about is a node you can't parallelize:
- **One bounded job.** "Research this one competitor's pricing," not
  "research the market and summarize and check sources" (that's three
  nodes wearing one prompt).
- **Defined input**, passed explicitly — never assumed from shared context.
- **Defined output shape**, schema-validated. Free text between nodes means
  the next node has to guess, which means a human ends up permanently
  wedged in the middle of the graph. In a Workflow script this is the
  `schema` option on `agent()` — validation happens at the tool-call layer,
  so a mismatch retries instead of handing back prose to parse.

## Step 3 — the one topology worth memorizing: the diamond

Fan out → reduce → synthesize. One node splits the job, several work in
parallel, plain code compresses what they found, one node writes the
final answer from what survived. This is the shape behind a market scan,
a comp-set audit, a code review — Anthropic's own deep-research pattern
runs this exact shape.

**Reduce in code, not in a model.** Flattening a list, deduping, counting,
filtering — those are a few lines of JavaScript, not a reason to spawn
another agent. An agent on every edge pays token rent on its own wiring.
Save agents for judgment calls, not merges.

## Step 4 — barrier vs. pipeline (the money question)

A barrier (`parallel()`) is correct ONLY when a stage genuinely needs
every result from the prior stage at once — deduping across the full set,
ranking against each other, an early-exit on an empty total. Everything
else is a pipeline: item A can reach stage three while item B is still on
stage one. The smell test: fan-out → plain transform → fan-out again, with
no cross-item dependency in that middle transform, means the barrier
latency bought nothing — every item waited for the slowest one for no
reason.

## Step 5 — the verifier never shares the worker's context

Models are structurally weak graders of their own output — not laziness,
they've already read the reasoning that produced the claim and prefer
conclusions consistent with it. So:
- The agent that did the work never checks the work.
- The verifier gets a **fresh, empty context** — the artifact and the
  rubric, nothing about who produced it or how. A verifier fed the
  worker's chat isn't verifying anything; it already agrees with the
  reasoning, just in a different font.
- It checks a **real signal**: a test that actually passed, a URL that
  actually resolves, a number that actually appears in the source — never
  "did the agent say it was done."

For anything where a finding can be wrong in more than one way, use
different lenses per verifier (correctness / freshness / source-is-real)
rather than three identical checks — identical checks share identical
blind spots.

## Step 6 — anchors: the nodes nothing can argue with

The failure mode that's easy to build accidentally: every node watches
another node, every check reads a report the same pipeline produced, and
everything agrees — because nothing has touched anything outside the
system. That's Goodhart's law with a bigger bill: once a measure becomes
the target, the system optimizes the measure instead of the thing it stood
for.

A graph needs at least one node that touches ground truth: a test that
actually ran, a URL that actually resolves, a number pulled from the
source system instead of from a summary of it. Freeze the rules an
optimizer would be tempted to weaken to "pass" — those are exactly the
ones it will bend.

## The three ways graphs fail silently

- **Context collapse** — fanning out to dozens of nodes, then trying to
  feed all their raw output into one synthesis step and blowing the
  window before synthesis even starts. Fix: layered fan-in — batch, 
  summarize each batch, combine the summaries.
- **False independence** — two nodes look independent because their
  prompts never mention each other, then both write to the same file or
  hammer the same rate-limited API. That's a hidden edge. Fix: isolate
  workers (separate worktrees/scratch space), and treat any two nodes
  touching the same resource as needing an edge, not parallelism.
- **Silent node failure** — one dead node among many slips into a report
  that looks complete, because nothing counted what came back against
  what was expected. Fix: every fan-in step checks its input count against
  what it expected and flags the gap instead of quietly synthesizing on
  partial data.

## How this maps to the Workflow tool already in use here

This checklist is upstream of writing the script, not a substitute for the
Workflow tool's own reference (pipeline/parallel semantics, the
adversarial-verify and judge-panel patterns, the loop-until-dry pattern,
budget tracking). Run this checklist first to decide *whether* and *how*
to shape the graph; consult the Workflow tool's own docs for the exact
`agent()`/`pipeline()`/`parallel()` calls once the shape is decided.
