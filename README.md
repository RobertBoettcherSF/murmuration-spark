# murmuration-spark

A starling murmuration (Reynolds *Boids*: **separation**, **alignment**,
**cohesion**) whose entire simulation is written in **Ada/SPARK** and proven
with GNATprove to **SPARK Gold**, compiled to WebAssembly and run live in the
browser.

**Live page:** https://robertboettchersf.github.io/murmuration-spark/

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
  Search is all-pairs (O(n²)), `Max_Birds = 2000`.
* Each rule computes a desired direction, scales it to max speed, subtracts the
  current velocity, limits it to `Max_Force` and multiplies by its weight
  (0–400 %, capped at `Max_Force × weight / 100`).
* New velocity = old + the three forces, clamped to `[Min_Speed, Max_Speed]`;
  new position = old + velocity, wrapped into the world.

## Source layout

| File | Contents |
|---|---|
| `src/boids.ads/.adb` | bounded vectors, `Limit`, `Clamp_Speed`, `Torus_Delta`, `Wrap`, `Isqrt` |
| `src/boids-flocks.ads/.adb` | flock, neighbour definition, `Find_Neighbours`, the three rules, `Step` |
| `src/boids-api.ads/.adb` | WebAssembly exports (`mf_*`), parameter clamping, random start; also SPARK |
| `web/template.html` | the page; `build.sh` fills in the WASM and the proof summary |
| `tests/` | smoke test and neighbour brute-force check |
| `proof/gnatprove.out` | the GNATprove summary of the current sources |

## Proof status

GNATprove FSF 16.1.0, `--mode=all --level=2`, all three units in SPARK
(including the WebAssembly export layer). **254 checks, 254 proved,
0 justified, 0 unproved.** No `pragma Annotate`, no `pragma Assume`, no
suppressed warnings, no `pragma Unreferenced` anywhere in `src/`.

| Level | What | Status |
|---|---|---|
| Stone | valid SPARK | ✓ 3 units |
| Bronze | flow analysis (initialization, data dependencies) | ✓ 18 checks |
| Silver | no run-time errors: overflow, range, index, division by zero; loops terminate | ✓ 107 run-time checks + 29 termination |
| Gold | functional contracts | ✓ 70 contracts + 30 assertions/loop invariants |

Gold properties (postconditions):

* `Limit`: `Norm2 (Result) <= M²`.
* `Separation`, `Alignment`, `Cohesion`: `Norm2 (Result) <= Cap (P, W)²`,
  with `Cap = Max_Force × weight / 100` (at weight 100 %: ≤ `Max_Force`).
* `Clamp_Speed`: `Min_Speed² <= Norm2 (Result) <= Max_Speed²`.
* `Wrap`: result in `[0, Size)` and congruent to the input mod `Size`.
* `Torus_Delta`: `|Result| <= Size/2`, and it differs from `B − A` by 0 or ±Size.
* `Find_Neighbours`: the list is **exactly** the neighbour set: every entry is a
  neighbour (distance² < radius², not itself), entries are strictly increasing
  (no duplicates), and every neighbour is in the list.
* `Step`: all birds stay in the world, every speed is clamped, count and
  parameters unchanged.
* API: every exported procedure keeps the flock valid, whatever values the page sends.

Honest notes on what the proofs do **not** say:

* `Limit` and `Clamp_Speed` scale with an integer square root and then check
  the result; if rounding ever left the result outside the bound they fall back
  to a safe vector (zero, or `(Min_Speed, 0)`). The bound is proven
  unconditionally; that the fallback is never taken is *not* proven (it is
  just expected from the arithmetic).
* Sums of neighbour vectors saturate at ±2²⁴ units (`Sat`). With the declared
  limits they cannot reach it, but that is not proven either; saturating
  keeps overflow impossible.
* Nothing is proven about the *look* of the flock — that's what the page is for.
* The WebAssembly is compiled with `-gnatp` (no run-time checks in the
  binary), which is justified by the Silver proof above; the JavaScript side
  is not verified.

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
* `neighbours_check`: 40 random flocks (3 with up to 2000 birds, random world
  sizes and radii), compares `Find_Neighbours` with a naive floating-point
  all-pairs computation for every bird.

## Roadmap

* Grid-based neighbour search for speed, checked against the all-pairs
  version (which is proven).
* Remove the `Sat` / fallback gaps above by proving the tighter arithmetic.

## License

MIT
