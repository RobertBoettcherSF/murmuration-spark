# How we got here

A guide for Ada/SPARK programmers — human or machine — who want to study
murmuration-spark or continue it. Read this first, then the sources in the
order `src/boids.ads` → `src/boids-flocks.ads` → `src/boids-api.ads`
(specs before bodies). About 1300 lines in total, every one of them in SPARK.

## 1. What it is

A boids flock (Craig Reynolds, 1987) whose whole simulation core is written
in SPARK, proven at Gold level by GNATprove, compiled to WebAssembly and run
by a single HTML page: <https://robertboettchersf.github.io/murmuration-spark/>.
JavaScript only draws the birds and moves the sliders.

## 2. The three Reynolds rules

Each bird looks at its *neighbours* — every other bird closer than
`Radius` (torus distance, strict `<`) — and adds three steering forces to its
velocity:

| Rule | Desired direction | Code |
|---|---|---|
| Separation | away from neighbours inside `Sep_Radius`, closer ones pushing harder (`d × (R² − d²)/R²`) | `Separation` |
| Alignment | the neighbours' mean velocity | `Alignment` |
| Cohesion | towards the neighbours' centre | `Cohesion` |

All three go through `Steer`: average → rescale to `Max_Speed` → subtract
the current velocity → limit to `Max_Force` → multiply by the rule's weight
(percent) → limit to `Cap = Max_Force × weight / 100`. The new velocity is
clamped to `Min_Speed .. Max_Speed` (`Clamp_Speed`) and the bird moves and
wraps around the edges. `Step` computes all new velocities from the old
state first, then moves everyone, so bird order does not matter.

## 3. Integer fixed point: 1 px = 256 units

Everything is an integer in *units*, `Sub = 256` per pixel. Positions are
`0 .. 4096 px`, speeds up to 16 px/step. Why not `Float`:

* every bound in a contract is exact — no "up to rounding error" clauses;
* SMT solvers handle integer arithmetic much better than IEEE floats;
* WebAssembly and native builds give bit-identical results.

The price is rounding in divisions and square roots, which has to be proven
harmless (section 6). All arithmetic is in one type, `Big` (±2⁶²); subtypes
(`Coord`, `Delta_T`, `Comp`, `Len_T`, …) keep every product far from
overflow.

## 4. Silver, then Gold

AdaCore's levels: Stone (valid SPARK), Bronze (flow analysis), Silver
(absence of run-time errors), Gold (functional contracts).

* **Silver** came first: every overflow, range, index and division check is
  discharged. This is what justifies compiling the WebAssembly with `-gnatp`
  (checks off): a check that provably cannot fail need not run.
* **Gold** postconditions then say what the code *does*: forces never exceed
  their cap, speeds are always clamped, birds stay in the world, `Wrap` and
  `Torus_Delta` are correct, and the neighbour searches return exactly the
  neighbour set.

Non-linear arithmetic is the hard part for provers. The pattern used
throughout: put each non-linear fact into a tiny **ghost lemma** (a
procedure with `Ghost`, a narrow subtype for its parameters, and often a
`null` body), and call it where the fact is needed. Ghost code is checked
and then erased from the binary. Loop invariants carry everything else.

Current status: **810 checks, 810 proved, 0 justified, 0 unproved**
(GNATprove FSF 16.1, `--level=2 --timeout=60`). No `pragma Annotate`,
`pragma Assume`, `pragma Unreferenced` or suppressed warnings in `src/`.

## 5. Neighbour search: all-pairs as reference, grid for speed

`Find_Neighbours` (all-pairs) is the obvious algorithm: test every bird.
It is easy to prove, so it is the **reference**: its postcondition is
`Exact_Set` — every neighbour present, only neighbours, no duplicates.

It costs N² tests per step (4 million at 2000 birds), so v0.2 added a
**uniform grid** (`Build_Grid`, `Find_Neighbours_Grid`), used by `Step`:

* cells are at least `Radius` wide (at most 64 × 64 cells); each cell keeps a
  chain of its birds (`Head`, `Next`);
* a neighbour is at most one cell away on each axis — including across the
  wrap-around seam, where the last cell can be wider (`Lemma_Axis_Near`,
  `Lemma_All_Near`);
* so scanning the 9 surrounding cells finds them all; `Marks` remove
  duplicates when a small world has fewer than 3 cells per axis.

The grid has the **same Gold postcondition** (`Exact_Set`) as all-pairs.
All-pairs stays in the code as the readable reference, and the tests check
grid = all-pairs = a naive floating-point brute force on 200 random flocks.
Result: 1200 birds 13.4 → 2.2 ms/step, 2000 birds 33.0 → 5.2 ms/step
(native).

One lesson: a proof-only loop left in a normal procedure still runs. The
first grid version was no faster because such a loop was O(N) per bird;
moving it into a ghost procedure (`Lemma_All_Near`) erased it.

## 6. v0.2: two honest gaps removed

v0.1 was Gold, but with two shortcuts that v0.2 removed:

* **isqrt fallback.** `Limit` and `Clamp_Speed` scaled with an integer
  square root, then *checked* the result and fell back to a safe vector if
  rounding had pushed it out of bounds. The bound was proven; that the
  fallback was never taken was not — and for `Clamp_Speed` with
  `Min_Speed ≈ Max_Speed` it actually could be. Now `Rescale` normalises the
  vector into a window (`2³⁰ ≤ |W|² ≤ 2³³`) where the rounding error is
  provably small: `(T−2)² ≤ |R|² ≤ T² + T`. `Limit` aims at `M − 1`,
  `Clamp_Speed` at `Hi − 1` / `Lo + 2`, and the parameters must satisfy
  `Max_Speed ≥ Min_Speed + 3` (the API enforces it). No fallback remains;
  the zero vector (no direction) becomes `(Min_Speed, 0)` by definition.
* **Sat.** Neighbour sums used saturating addition at ±2²⁴ to make overflow
  impossible without proving the sums small. Now loop invariants bound
  each sum by `count × largest term` from the declared limits, and the rules
  average before steering (`Lemma_Avg`, `Lemma_Frac`).

## 7. v0.2.1: the Starling retune

On a large screen the original Starling preset (radius 50 px) broke into
~12 small clusters: the page sizes the world to the window, so birds were
too sparse to meet. A suspected code regression (alignment 0.61 → 0.18 in
the smoke test) turned out to be one seed at one step; over several seeds
v0.1 and v0.2 behave the same. The fix was parameters only: radius 110 px,
personal space 40, separation 300 %, alignment and cohesion 250 %, min speed
2.5, max force 0.23. 1200 birds now form 1–4 large clouds (2560 × 1440:
12–14 clusters → 2–4). The top bar shows live alignment and cluster count
(also in the F9 feedback file). Denser clouds cost more: 2.5–8.6 ms/step.

## 8. Proof, badge and Pages

* `./prove.sh` runs GNATprove and copies the summary to
  `proof/gnatprove.out` (committed).
* `./build.sh` compiles `src/*.adb` to WebAssembly (AdaWebPack GNAT-LLVM,
  `-gnatp`, `wasm-ld`, 2 MB stack) and `tools/embed.py` embeds the WASM and
  the proof summary into `web/template.html` → `docs/index.html`.
* GitHub Pages serves `docs/` from `main`.
* The badge is computed from `proof/gnatprove.out` at build time. A file
  cannot contain its own commit hash, so the page shows "built from
  <source commit>" and asks the GitHub API which commit last changed
  `docs/index.html`; ✓ means that commit's parent is the source commit.
  Hence every deploy is two commits: sources, then page.
* Tests: `gprbuild -P tests/tests.gpr && obj/tests/smoke && obj/tests/neighbours_check`.

## 9. Open limits

* **JavaScript is unproven**: drawing, sliders, metrics, crash log.
* **`-gnatp`**: the binary has no run-time checks; this rests on the Silver
  proof and on the compiler (GNAT-LLVM for wasm32) being correct, which is
  not verified.
* **Behaviour is measured, not proven**: alignment, cluster counts, how
  the flock looks, and speed (the grid's 6× is a benchmark, not a theorem).
* Dense clouds make neighbour lists long (the work per bird grows with
  local density); 2000 birds in one cloud would not reach 60 fps. Real
  starlings watch about 7 nearest birds (topological neighbours) — a
  natural next step, needing new proofs.
* Not yet proven: the grid's cost bound (at most 9 cells per bird).

## Where to start changing things

* New rule or parameter: `Params` and the rules in `boids-flocks.ads`, then
  `Set_Param` in `boids-api.adb`, then the sliders in `web/template.html`.
* Run `./prove.sh` after every Ada change; aim for 0 unproved without
  `Annotate`/`Assume`. When a non-linear step does not prove, isolate it in a
  ghost lemma with narrow subtypes.
