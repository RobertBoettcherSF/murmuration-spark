# Workflow for other threads (Ada → live browser app)

How Murmuration SPARK was built with Robert. Copy this pattern when the deliverable is a **live link** (Gist/githack or GitHub Pages) whose **logic is all Ada**, and Robert tests by opening the URL on phone or desktop.

## What the setup looks like

1. **Logic in Ada.** Simulation / domain code lives in `src/` (SPARK when proofs matter). JavaScript only draws, menus, F9 feedback, crash reports.
2. **One live URL.** Single-file HTML with Ada compiled to WebAssembly embedded (see symmetry-visualizations / murmuration-spark), or a secret Gist + gist.githack.com for private phone apps.
3. **Robert tests the link.** He does not need a build on his machine. Screenshots and “looks good / looser / Go” are the feedback loop.
4. **No feature until Go.** Post a **numbered plan**, wait for **Go**, then build only that plan. Do not start the next chunk until he asks.

## Why chunk into items

Complex features tempt lean stubs. Chunking forces depth:

- One **item** = one coherent deliverable (e.g. “failed-proof walkthrough”, “grid diagrams”, “measuring tools”).
- Robert asks for **plan for item N**, edits if needed, then **Go**.
- You implement that item **almost fully** (depth over stubs). Feedback can deepen it further; it should not be a half-empty shell that “we’ll fill later”.

Stub only when Robert explicitly accepts a stub, or when the plan names a temporary seam. Default: ship a study-ready or play-ready slice.

## The loop (copy this)

1. **Orient.** Short hello of what you’re starting; confirm live URL / repo if needed.
2. **Propose a backlog.** A short numbered list of items (not a giant mega-plan). Example: proofs → page → tune preset → docs items 1–4.
3. **When he asks “plan for item X?”** Reply with a **numbered plan for that item only** (4–6 steps). Ask “Any changes, or Go?”
4. **On Go.** Mark that item in progress. Build it. Push. Send the **concrete result** (link, metrics, what stayed unproven / unfinished).
5. **Do not start item X+1** until he asks for its plan or says Go on the next one.
6. **Honesty bar.** Say what is proven vs measured, what is reconstructed vs archived, mismatches (e.g. README number vs page parameter). No `Annotate Intentional` to hide gaps when the project aims at SPARK Silver/Gold.

## Plan shape (good)

```
Plan for item N only (short name):
1. …
2. …
3. Keep Ada/page unchanged unless this item needs it.
4. Push / link from README if docs.
Any changes, or Go?
```

Bad: a plan that mixes three features, or “implement everything and stubs for the rest”.

## Live-page apps (mental health tracker, CDDA clone, murmuration)

| Piece | Expectation |
|---|---|
| Share link | Always post URL after deploy; remind to hard-reload if needed |
| Ada core | Real behaviour for the item; not empty stubs |
| UI | Enough to exercise the item; F9 / feedback file when debug budget allows |
| Tests | Smoke + whatever the item claims (cross-check, metrics) |
| Docs | For teaching repos: HOW_WE_GOT_HERE + deep-study sections one at a time |

## Phrases Robert uses

- **“Plan for item N?”** → numbered plan for N only, then wait.
- **“Go”** → build that plan; do not expand scope.
- **“Good as is”** → plan approved; still wait for Go unless he already said Go.
- Screenshots / “looks good” → treat as UX acceptance of the live page, not of unfinished backlog items.

## What this is not

- Not a form or checklist for the user.
- Not permission to keep coding the next item in the background after Go on N.
- Not a substitute for the project’s own rules (e.g. Human Viewer “wait for Go”, Seelenlog privacy, SPARK no-Annotate).

## Murmuration example (worked)

1. Repo + Gold Boids + live Pages (v0.1–v0.2.1).
2. Docs pass: comments + `docs/HOW_WE_GOT_HERE.md`.
3. Deep-study backlog of **four items**, done **one by one**: failed proof → grid pictures → `tools/bench` → Rescale derivation.
4. Each item: plan → Go → push → link in chat.

Repo: https://github.com/RobertBoettcherSF/murmuration-spark  
Live: https://robertboettchersf.github.io/murmuration-spark/  
Guide: [HOW_WE_GOT_HERE.md](HOW_WE_GOT_HERE.md)
