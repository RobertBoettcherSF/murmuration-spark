# murmuration-spark

A starling murmuration (Reynolds *Boids*: **separation**, **alignment**,
**cohesion**) whose entire simulation is written in **Ada/SPARK** and proven
with GNATprove to **SPARK Gold**, compiled to WebAssembly and run live in the
browser.

**Live page:** https://robertboettchersf.github.io/murmuration-spark/

**New here? Start with [docs/HOW_WE_GOT_HERE.md](docs/HOW_WE_GOT_HERE.md)**: the
rules, the fixed-point arithmetic, how the proofs are built, what changed in
each version and what is still open. Then read the specs in `src/` in the
order it suggests.
For a deep, step-by-step study of one real GNATprove failure and the ghost
lemma that fixed it, jump to
[Deep study: one failed proof in Rescale](docs/HOW_WE_GOT_HERE.md#10-deep-study-one-failed-proof-in-rescale). The grid is drawn in [Deep study: the neighbour grid in pictures](docs/HOW_WE_GOT_HERE.md#11-deep-study-the-neighbour-grid-in-pictures). To re-measure the speed and flock-metric tables below, see [tools/README.md](tools/README.md).

The page (`docs/index.html`, one self-contained file) embeds the WebAssembly
module as base64. JavaScript only draws the birds, shows menus and writes
logs; every bird is moved by the proven Ada code.

## Controls

| Key / control | Action |
|---|---|
| Preset menu | Starling swirl, Fish school, Chaos |
| **Space** | next preset |
| **Settings** | sliders: the three rule weights, neighbour radius, personal space, bird count (1–2000), min/max speed, max force |
| **F9** | downloads a feedback file (JSON): settings, fps, alignment, sample birds, proof summary, errors, event log |
| Proof badge | click for the GNATprove summary of the build |
| Crash report | if the previous session did not end cleanly, or WebAssembly traps, a panel offers a crash-report download |

## The model

* World: a torus (the edges wrap), size = browser window, up to 4096 × 4096 px.
* Numbers: integers, 1 px = 256 units (fixed point). No floating point, so
  every bound is exact.
* Neighbours of bird *i*: every other bird *j* with torus distance² < radius².
  Neighbour search uses a uniform grid (proven to return exactly the all-pairs set), `Max_Birds = 2000`.
* Each rule computes a desired direction, scales it to max speed, subtracts the
  current velocity, limits it to `Max_Force` and multiplies by its weight
  (0–400 %, capped at `Max_Force × weight / 100`).
* New velocity = old + the three forces, clamped to `[Min_Speed, Max_Speed]`;
  new position = old + velocity, wrapped into the world.

## Source layout

| File | Contents |
|---|---|
| `src/boids.ads/.adb` | bounded vectors, `Limit`, `Clamp_Speed`, `Torus_Delta`, `Wrap`, `Isqrt` |
| `src/boids-flocks.ads/.adb` | flock, neighbour definition, `Find_Neighbours` (all-pairs) and the uniform grid, the three rules, `Step` |
| `src/boids-api.ads/.adb` | WebAssembly exports (`mf_*`), parameter clamping, random start; also SPARK |
| `web/template.html` | the page; `build.sh` fills in the WASM and the proof summary |
| `tests/` | smoke test and neighbour brute-force check |
| `docs/HOW_WE_GOT_HERE.md` | guide for new readers: design, proof approach, history, open limits |
| `proof/gnatprove.out` | the GNATprove summary of the current sources |

## Proof status

GNATprove FSF 16.1.0, `--mode=all --level=2 --timeout=60`, all three units in
SPARK (including the WebAssembly export layer). **810 checks, 810 proved,
0 justified, 0 unproved.** No `pragma Annotate`, no `pragma Assume`, no
suppressed warnings, no `pragma Unreferenced` anywhere in `src/`.

| Level | What | Status |
|---|---|---|
| Stone | valid SPARK | ✓ 3 units |
| Bronze | flow analysis (initialization, data dependencies, aliasing) | ✓ 41 checks |
| Silver | no run-time errors: overflow, range, index, division by zero; loops terminate | ✓ 416 run-time checks + 42 termination |
| Gold | functional contracts | ✓ 165 contracts + 146 assertions/loop invariants |

Gold properties (postconditions):

* `Rescale (V, T)` (V ≠ 0): `(T−2)² ≤ |Result|² ≤ T² + T` — the integer
  square-root scaling is analysed exactly, not checked after the fact.
* `Limit (V, M)`: `|Result|² ≤ M²`; unchanged if already short enough.
  There is **no fallback**: the old "check, else return zero" branch is gone;
  only `M = 0` returns zero, which is the only vector of length 0.
* `Clamp_Speed (V, Lo, Hi)` (needs `Hi ≥ Lo + 3`): `Lo² ≤ |Result|² ≤ Hi²`;
  unchanged if already in range. The only special case is the zero vector,
  which has no direction and becomes `(Lo, 0)` — not a fallback for rounding.
  The API keeps `Max_Speed ≥ Min_Speed + 3` (in 1/256 px).
* `Separation`, `Alignment`, `Cohesion`: `|Result|² ≤ Cap²` and each component
  `≤ Cap`, with `Cap = Max_Force × weight / 100`. Neighbour sums are now plain
  integer sums: the proof bounds them by `count × (largest term)` from the
  declared limits (positions < 4096 px, speeds ≤ 16 px, ≤ 2000 birds) and then
  averages. The `Sat` saturation of v0.1 is removed.
* `Wrap`, `Torus_Delta`: as before (result in `[0, Size)`; `|Δ| ≤ Size/2`).
* `Find_Neighbours` (all-pairs, reference): exactly the neighbour set, sorted.
* `Build_Grid` + `Find_Neighbours_Grid` (uniform grid, cells ≥ radius,
  ≤ 64 × 64 cells, wrap-around): the result is **exactly the same set** as
  `Find_Neighbours` — no duplicates, every entry a neighbour, every neighbour
  present. Proven via: the cell chains are correct (`Chains_OK`), and any
  neighbour is in the same or an adjacent cell on each axis, including across
  the wrap seam (`Lemma_All_Near`, a ghost procedure erased from the binary).
* `Step` uses the grid; all birds stay in the world, every speed is clamped,
  velocity components stay bounded, count and parameters unchanged.
* API: every exported procedure keeps the flock valid, whatever values the page sends.

Honest notes on what the proofs do **not** say:

* Nothing is proven about the *look* of the flock — that's what the page is for.
* The grid proof is about the set; that the grid is *faster* is measured, not proven.
* The WebAssembly is compiled with `-gnatp` (no run-time checks in the
  binary), which is justified by the Silver proof above; the JavaScript side
  is not verified, and neither is the compiler.

## Speed (native, `-O2`, 1280 × 720, radius 50 px, after 100 warm-up steps, mean of 200 steps)

| Birds | v0.1 all-pairs | v0.2 grid |
|---|---|---|
| 1200 | 13.4 ms/step | 2.2 ms/step |
| 2000 | 33.0 ms/step | 5.2 ms/step |

## Flock metrics (v0.2.1)

The top bar shows, once per second, **alignment** (length of the mean unit
heading: 1 = everyone flies the same way) and the number of **clusters**
(connected groups of ≥ 5 birds, linked when closer than 50 px, with
wrap-around). Both are also in the F9 feedback file, with the last two minutes
of history. They are computed in JavaScript for display only.

Starling swirl was retuned in v0.2.1 (radius 50 → 110 px, personal space
16 → 40 px, separation 150 → 300 %, alignment and cohesion 100 → 250 %,
min speed 2 → 2.5 px, max force 0.12 → 0.23). 1200 birds, after 2000 steps,
seeds 5 / 9 / 11, native:

| World | Clusters before | Clusters after | Largest after | Alignment before (mean of last 200 steps) | after |
|---|---|---|---|---|---|
| 2560 × 1440 | 12 / 12 / 14 | 3 / 4 / 2 | 754 / 857 / 1046 | 0.83 / 0.39 / 0.90 | 0.89 / 0.92 / 0.71 |
| 1920 × 1080 | 7 / 7 / 10 | 2 / 1 / 2 | 1157 / 1200 / 710 | 0.80 / 0.91 / 0.87 | 0.91 / 0.99 / 0.92 |
| 1280 × 720 | 5 / 5 / 4 | 1 / 1 / 1 | 1199 / 1200 / 1200 | 0.85 / 0.91 / 0.93 | 0.98 / 0.95 / 0.97 |

The merged clouds are dense, so a step costs more (native 2.5–8.6 ms instead
of 1.4–2.8 ms; WebAssembly in node 3–10 ms) — still inside a 60 fps frame on a
desktop. Fish school and Chaos are unchanged.
Reproduce these numbers with [tools/README.md](tools/README.md).

## Commit badge

The badge shows "built from <commit>": the source commit the page was built
from (a file cannot contain the hash of the commit that contains it). The page
then asks the GitHub API which commit last changed `docs/index.html` — the
commit actually served — and shows it, with ✓ if its parent is the source
commit. Deploys are therefore two commits: sources, then `docs/index.html`.

## Build, prove, test

Tools used: GNAT 16 / gprbuild / GNATprove 16 from Alire, and the
AdaWebPack 24 (GNAT-LLVM) compiler for WebAssembly plus `wasm-ld`.

```sh
alr toolchain --select gnat_native gprbuild   # or any GNAT >= 14
alr get gnatprove                              # GNATprove >= 14
tools/get-toolchain.sh                         # Ada -> WebAssembly compiler into ./toolchain
                                               #   (needs: rpm2cpio cpio lld libedit2)
./prove.sh        # GNATprove, writes proof/gnatprove.out
./build.sh        # WebAssembly + proof summary -> docs/index.html
gprbuild -P tests/tests.gpr && obj/tests/smoke && obj/tests/neighbours_check
```

Then open `docs/index.html` in a browser (no server needed).

## Tests

* `smoke`: 600 birds, 1280 × 720 world, seed 42, 500 steps; checks every
  bird every step: inside the world and speed in range.
* `neighbours_check`: 200 random flocks (3 with up to 2000 birds, random world
  sizes, radii up to 400 px so 1-, 2- and 3-cell grids and the wrap seam are
  hit), for every bird: `Find_Neighbours` vs a naive floating-point all-pairs
  computation, and `Find_Neighbours_Grid` vs `Find_Neighbours` (same multiset).

## Roadmap

* Prove the grid's cost bound (each bird scans at most 9 cells) as a contract.
* Interactive predator / obstacles.

## License

MIT
