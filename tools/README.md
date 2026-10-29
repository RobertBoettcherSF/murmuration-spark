# tools/

| File | What it is |
|---|---|
| `get-toolchain.sh` | fetches the GNAT-LLVM / AdaWebPack toolchain used by `build.sh` |
| `embed.py` | puts the WebAssembly and the GNATprove summary into `docs/index.html` (used by `build.sh`) |
| `bench/metrics.adb` | **flock metrics**: runs Starling swirl natively, prints clusters, largest clusters, alignment, ms/step |
| `bench/steptime.adb` | **step timing**: mean native ms/step for the README "Speed" table |
| `bench/presets.ads/.adb` | the Starling presets `before` (v0.2), `after` (v0.2.1 as measured), `page` (v0.2.1 as the page sends it) |
| `bench/bench.gpr` | builds both programs against `src/` or against any older checkout |
| `bench/wasm_time.mjs` | times `mf_tick` of the WebAssembly **embedded in `docs/index.html`** under node |

None of these change `src/` or `docs/index.html`. Nothing here proves or rebuilds the page.

All commands run from the repository root, after `. ./env.sh`.

## Build

```sh
gprbuild -q -P tools/bench/bench.gpr            # -> obj/bench/cur-off/{metrics,steptime}
CHECKS=on gprbuild -q -P tools/bench/bench.gpr  # same with run-time checks -> obj/bench/cur-on/
```

`CHECKS=off` (the default) compiles with `-gnatp`, like the WebAssembly build.

## README "Flock metrics" table (1200 birds, 2000 steps, seeds 5 / 9 / 11)

```sh
for w in "2560 1440" "1920 1080" "1280 720"; do for s in 5 9 11; do
  for k in before after; do obj/bench/cur-off/metrics $k $w $s; done; done; done
```

Usage: `metrics before|after|page WIDTH HEIGHT SEED [BIRDS=1200] [STEPS=2000]`.

- *Clusters* means connected groups of at least 5 birds, linked when closer than 50 px with wrap-around. This is the same rule as `flockMetrics()` in `web/template.html`.
- *Largest* lists the three biggest clusters.
- *Alignment mean of last 200 steps* is the table's alignment column.

Example output (29 Oct 2026, matches the table exactly):

```
BEFORE 2560 x 1440  seed 5,  1200 birds, 2000 steps
clusters: 12   largest: 274 204 164
alignment mean of last 200 steps: 83 %   at end: 84 %
AFTER 2560 x 1440  seed 5,  1200 birds, 2000 steps
clusters: 3   largest: 754 303 143
alignment mean of last 200 steps: 89 %   at end: 91 %
```

All 18 runs reproduce the table: cluster counts, the largest cluster and the mean alignment.

**`after` vs `page`.** The table was measured with max force 60/256 px (0.234). The page shows 0.23 and sends `round(0.23 * 256)` = 59. So `after` reproduces the README, and `page` is what the live page actually runs. That one unit matters for single seeds. For example, at 2560 × 1440 seed 5, `page` gives 5 clusters (largest 886) where `after` gives 3 (largest 754). Overall the result is the same: a few large clouds instead of 12–14 small groups.

## README "Speed" table (1280 × 720, radius 50 px, 100 warm-up + mean of 200 steps)

```sh
obj/bench/cur-off/steptime 1200; obj/bench/cur-off/steptime 2000      # v0.2 grid
git worktree add /tmp/mf-v01 4ae1368                                   # v0.1 all-pairs
SRC=/tmp/mf-v01/src TAG=v01 gprbuild -q -P tools/bench/bench.gpr
obj/bench/v01-off/steptime 1200; obj/bench/v01-off/steptime 2000
git worktree remove /tmp/mf-v01
```

Usage: `steptime BIRDS [RADIUS_PX=50] [WIDTH=1280] [HEIGHT=720] [SEED=42]`. Other parameters are the Ada defaults.

Measured 29 Oct 2026 on the build box (8 cores, load about 1), in ms/step:

| Birds | v0.1 README | v0.1 checks on / off | v0.2 README | v0.2 checks on / off |
|---|---|---|---|---|
| 1200 | 13.4 | 15.0 / 9.5 | 2.2 | 2.7 / 2.5 |
| 2000 | 33.0 | 35.9 / 22.6 | 5.2 | 7.3 / 6.9 |

The speed-up (about 5×) reproduces, but the absolute numbers drift by 10–40 %. Wall-clock timing on a shared box moves that much from run to run, and the original seed and switches were not recorded. Treat the README speed table as "about", not exact.

## WebAssembly timing (README: "WebAssembly in node 3–10 ms")

```sh
node tools/bench/wasm_time.mjs after     # v0.2.1 Starling, 3 worlds x seeds 5/9/11
node tools/bench/wasm_time.mjs before
node tools/bench/wasm_time.mjs page      # force 59, as the page sends it
```

Usage: `wasm_time.mjs [after|before|page|plain] [BIRDS=1200] [STEPS=2000]`.

This uses the exact binary served by the live page, decoded from `docs/index.html`. Measured 29 Oct 2026, node 24, ms/step over the last 200 of 2000 steps:

```
after 2560x1440 1200 birds, seeds 5/9/11: 2.5 / 2.4 / 2.6 ms/step
after 1920x1080 1200 birds, seeds 5/9/11: 4.6 / 6.9 / 2.9 ms/step
after 1280x720 1200 birds, seeds 5/9/11: 6.7 / 5.5 / 4.7 ms/step
before 2560x1440 1200 birds, seeds 5/9/11: 1.4 / 1.6 / 1.4 ms/step
```

That is 2.4–6.9 ms, inside or a little below the README's 3–10 ms, and well under a 16.7 ms frame.
