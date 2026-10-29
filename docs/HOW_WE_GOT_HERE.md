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

## 10. Deep study: one failed proof in Rescale

This walks through one real GNATprove failure, step by step: the obligation,
the prover's message, what was missing and the ghost lemma that closes it.

**Where the failure comes from.** While v0.2 was being developed,
non-linear assertions in `Rescale` timed out repeatedly until each fact got
its own ghost lemma. Those intermediate logs were not kept, so this failure
is **reproduced**. I took the committed `src/boids.adb` (v0.2.1, all 810
checks proved), replaced one ghost call with `null;` in a scratch copy and
re-ran GNATprove FSF 16.1.0 on `Rescale` alone:

```sh
gnatprove -P murmuration.gpr -j0 --mode=all --level=2 --timeout=60 \
  --report=fail -u boids.adb --limit-subp=boids.ads:91
```

The repository itself was never changed. To reproduce it, make the same
one-line edit at `src/boids.adb:196` in a copy and run the command above.

### The code around it

`Rescale (V, T)` returns `V` scaled to length `T`. After normalising `V`
to `(WX, WY)` with `N = WX² + WY²` and `S = Isqrt (N)`, each component is

```ada
RX := WX * T / S;      --  integer division, truncates toward zero
RY := WY * T / S;
```

The upper half of the postcondition, `|R|² ≤ T² + T`, is proven by a chain
of assertions. Its first link is "each component squared, times S², is at
most the exact value squared":

```ada
A  : constant Big := abs RX;     B  : constant Big := abs RY;
PX : constant Big := abs WX * T; PY : constant Big := abs WY * T;
T2 : constant Big := T * T;      S2 : constant Big := S * S;
...
Lemma_Sq_Mono (A * S, PX);
Lemma_Sq_Mono (B * S, PY);                          -- line 196
pragma Assert (A * A * S2 <= WX * WX * T2);
pragma Assert (B * B * S2 <= WY * WY * T2);         -- line 198
pragma Assert (Q * S2 <= N * T2);
```

### The failure

With line 196 replaced by `null;`, the result is:

```
 medium: assertion might fail
--> boids.adb:198:25
  198 |             pragma Assert (B * B * S2 <= WY * WY * T2);
      |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~
      + possible fix: precondition of subprogram at boids.ads:91 should mention T
      --> boids.ads:91:04
   91 |       function Rescale (V : Vec; T : Len_T) return Vec
      |       ^
      + provers reached time limit before completing the proof
```

How to read it:

* **`medium`** means the property may well be true, but no prover found a
  proof in time. "Provers reached time limit" confirms that: this is a
  timeout, not a counterexample.
* **The "possible fix" is a red herring.** GNATprove saw that the assertion
  depends on `T` and that `Rescale` has no precondition on `T`. But `T` is
  already bounded by its subtype `Len_T` (0 .. 2¹³), and no extra
  precondition would help. The real problem is that the solver cannot find
  the non-linear reasoning step. Read hints like this as guesses, not
  diagnoses.
* The X line (197) still proves, because its lemma call is still there.
  The two lines are symmetric, which makes this a clean experiment.

### What was missing

What the provers already know at line 198:

1. From `Lemma_Div (WY, T, S, RY)` (called earlier):
   `|RY| * S ≤ |WY| * T`, that is `B * S ≤ PY`. Lemma_Div is a `null`
   procedure: its postcondition follows directly from the definition of
   truncating division, which the solvers handle.
2. Both sides are non-negative and small: `PY ≤ 2²⁹` (|WY| ≤ 2¹⁶,
   T ≤ 2¹³), so `B * S ≤ 2²⁹` as well.

What line 198 needs is the **squared** form,
`(B * S)² ≤ (|WY| * T)²`, rearranged as `B·B·S·S ≤ WY·WY·T·T`.
The rearranging (commutativity, associativity, `|WY|² = WY²`) is easy for
the solvers. The hard part is **"0 ≤ x ≤ y implies x² ≤ y²"** when x and y
are themselves products of four variables. That is non-linear integer
arithmetic, which is undecidable in general. The SMT solvers (CVC5, Z3,
Alt-Ergo) use heuristics, and with all of `Rescale`'s context in view they
do not find the monotonicity step within 60 s.

### The lemma that closes it

```ada
subtype Nat30 is Big range 0 .. 2 ** 30;

procedure Lemma_Sq_Mono (X, Y : Nat30)
  with Ghost, Pre => X <= Y, Post => X * X <= Y * Y;

procedure Lemma_Sq_Mono (X, Y : Nat30) is
begin
   pragma Assert (X * X <= X * Y);
   pragma Assert (X * Y <= Y * Y);
end Lemma_Sq_Mono;
```

It is called as `Lemma_Sq_Mono (A * S, PX)` / `(B * S, PY)`. At the call,
GNATprove must show the precondition: both arguments in `Nat30` (fact 2
above) and `B * S ≤ PY` (fact 1). After the call it may assume the
postcondition `(B*S) * (B*S) ≤ PY * PY`. Line 198 is then only a
rearrangement of that fact.

### Why that lemma is enough

The lemma splits one hard step into two that solvers handle reliably, and
it does so in an empty context. Inside the lemma the solver sees only
`X`, `Y`, their bounds and `X ≤ Y`, not the forty-odd facts of `Rescale`.
Each assertion multiplies a known inequality by a single non-negative
variable: `X ≤ Y` times `X` gives `X·X ≤ X·Y`, and times `Y` gives
`X·Y ≤ Y·Y`. Transitivity then gives the postcondition. The `Nat30`
subtype supplies the non-negativity that makes multiplying an inequality
sound, and keeps every product below 2⁶⁰ so no overflow check gets in the
way. Back in `Rescale`, the call turns a non-linear goal into a linear one:
the solver no longer has to *discover* monotonicity of squaring, only to
*match* the lemma's postcondition against the assertion. That matching is
syntactic rearrangement, which solvers do well. The ghost call is erased
from the WebAssembly, so the extra proof structure costs nothing at run time.

### Things noticed while experimenting

I also removed each of the other 13 ghost calls in `Rescale` one at a time.

* Six removals still proved everything: both `Lemma_Div` calls,
  `Lemma_Sq_Mono (A * S, PX)`, both `Lemma_Cancel` calls and
  `Lemma_Comp_Bound`. With 16.1 and the surrounding asserts, those steps
  are within the solvers' reach. Some of these lemmas were added under
  older, less helpful assertion chains and are now partly redundant. They
  are kept because they make each step explicit and keep the proof robust
  across prover versions.
* The other removals each left one or more assertions unproved (timeouts).
  In a few cases the first failure reported was an assertion *before* the
  removed call; for example, removing line 200 reported line 198. Asserts
  near the solver time limit are sensitive to the whole verification
  condition, not just the lines above them, so treat the exact line as a
  hint.

The general recipe used throughout this repository:

1. When an assertion with products times out, write the single
   non-linear fact it needs as a ghost lemma with narrow subtypes.
2. Prove the lemma in its own small context; split it further if needed.
3. Call it right before the assertion, with arguments that match the
   assertion's terms.

## 11. Deep study: the neighbour grid in pictures

This section draws the three shapes the grid proofs talk about. Under each picture you get the contract clauses that say the same thing. Names are from `src/boids-flocks.ads` / `.adb`. Coordinates are fixed point (`Sub` = 256 units per pixel), but the pictures use small whole numbers.

### 11.1 Cells and the wider last cell (`Axis`, `Geometry_OK`)

Per axis, `Axis` picks a cell size `Cs = max(R, Size/Max_G + 1)` and a count `G = max(1, Size/Cs)`. A bird's cell is `Cell_X = min(X / Csx, Gx - 1)`. Because `G` rounds down, `G*Cs <= Size`, and whatever is left over goes into the **last** cell:

```
 Size = 23, R = 5  ->  Cs = 5, G = 4   (4*5 = 20 <= 23)

 x:  0    5    10   15        23 (= 0, wraps)
     |----|----|----|-------|
     | 0  | 1  | 2  |   3    |     cell 3 is 8 wide: [15, 23)
     |----|----|----|-------|
                    ^ min(X/Cs, G-1) clamps x = 20..22 into cell 3
```

Contract link: `Geometry_OK` keeps exactly two facts. `Cs >= Radius` means no cell is narrower than the radius. `G = 1 or G*Cs <= Size` means the remainder is non-negative, so the last cell is **at least** `Cs` wide, never narrower. Nothing says the last cell is *exactly* `Cs`. The proofs never need that, because a wider cell only makes "same or adjacent cell" easier to reach.

### 11.2 Cell chains (`Build_Grid`, `Chains_OK`)

`Key(J) = Cell_Y*Gx + Cell_X`. `Build_Grid` walks `J = 1..N` and pushes each bird onto the front of its cell's list:

```
   C := Key(J);  Next(J) := Head(C);  Head(C) := J;
```

Worked example, `Gx = Gy = 4` (16 cells), six birds:

```
 bird J :  1   2   3   4   5   6
 Key(J) :  5   9   5   0   5   9

 after the loop:

 Head(0) = 4 --> 4 --> 0(end)
 Head(5) = 5 --> 5 --> 3 --> 1 --> 0
 Head(9) = 6 --> 6 --> 2 --> 0
 Head(other) = 0

 Next:  J    1  2  3  4  5  6
        Next 0  0  1  0  3  2      (always Next(J) < J)
```

Each chain runs in **decreasing** index order, and it has no gaps: between two links of a chain there is no bird with the same key. That no-gap property is exactly what `Chains_OK (F, G, Upto)` states. It is also `Build_Grid`'s loop invariant, with `Upto = J`:

| Picture fact | Clause of `Chains_OK` |
|---|---|
| `Head(C)` is the newest bird seen so far | `Head(C) <= Upto` |
| the head really lives in cell C | `Head(C) /= 0 -> Key(Head(C)) = C` |
| nobody newer than the head is in C | no `J in Head(C)+1 .. Upto` with `Key(J) = C` |
| arrows point to older birds | `Next(J) < J` (so walks terminate; 0 = end) |
| an arrow stays in the cell | `Next(J) /= 0 -> Key(Next(J)) = Key(J)` |
| an arrow skips no same-cell bird | no `J2 in Next(J)+1 .. J-1` with `Key(J2) = Key(J)` |

Why the invariant is preserved: the step for bird J only changes `Head(Key(J))` and `Next(J)`. The old head becomes `Next(J)`, and the "no newer bird" clause for the old head turns into the "skips nothing" clause for J. Every other cell is untouched. At the end, `Grid_OK = Geometry_OK and Chains_OK (F, G, F.N)`.

The payoff: walking a chain from `Head(C)` along `Next` visits **every** bird with `Key = C`, each once, in decreasing order. That is the fact `Scan_Cell` relies on.

### 11.3 Scanning one chain (`Scan_Cell`)

```
 Head(5) = 5 --> 3 --> 1 --> 0
                 ^Cur
 already decided: birds > Cur in cell 5     still to visit: Cur, then older
```

`Scan_Cell`'s loop invariant is the picture: for every bird J,
`Marks(J) = Marks'Entry(J) or (J > Cur and Key(J) = C and Is_Neighbour(F, I, J))`.
Because of the no-gap clauses, "J > Cur and Key(J) = C" is exactly "already walked past". When `Cur` reaches 0, that becomes "every bird in C", which is the post:

```
 Marks(J) = Marks'Old(J) or (Key(J) = C and Is_Neighbour(F, I, J))
```

`Inv` holds throughout: every list entry is a neighbour, marked and distinct, and every marked bird is in the list. A bird is appended only if it is an unmarked neighbour, and it is marked at once.

### 11.4 The 9-cell scan and the seam (`Find_Neighbours_Grid`, `Lemma_Axis_Near`)

Around bird I in cell `(CX, CY)`:

```
 Xs = ((CX+Gx-1) mod Gx, CX, (CX+1) mod Gx)     Ys likewise
 Cells((A-1)*3 + B) = Ys(A)*Gx + Xs(B)

            Xs(1)   Xs(2)   Xs(3)
          +-------+-------+-------+
   Ys(1)  |   1   |   2   |   3   |
          +-------+-------+-------+
   Ys(2)  |   4   | I : 5 |   6   |
          +-------+-------+-------+
   Ys(3)  |   7   |   8   |   9   |
          +-------+-------+-------+
```

At the edge, the `mod` wraps the scan across the seam. With bird I in cell 0 of the 4-cell axis above:

```
 x:  0    5    10   15        23|0
     | 0  | 1  | 2  |   3    |
       I    +1             -1      Xs = (3, 0, 1)
       ^--- a neighbour at x = 21 is 2 px away across the seam
```

**Why nine cells are enough** is the ghost `Lemma_All_Near`. For each neighbour J it uses `Lemma_Neighbour_Close` (via `Lemma_Sq_Rev`) to get `|DX| < R` and `|DY| < R` on the wrapped torus distance. Then `Lemma_Axis_Near` turns "closer than R <= Cs" into "same or adjacent cell (mod G)". It has three cases:

1. **No wrap.** The birds are within `Cs` of each other on the plane, so their `X/Cs` values differ by at most 1 (`Lemma_Div_Close`). The `min(..., G-1)` clamp only merges values into the last cell, so it cannot push them apart.
2. **Wrap, I on the left.** `X1 < Cs` gives `X1/Cs = 0`, so I is in cell 0. The other bird has `X2 >= Size - Cs >= (G-1)*Cs` (this is where `G*Cs <= Size` from 11.1 is used), so it is in cell `G-1`, and `0 = (G-1)+1 mod G`.
3. **Wrap, mirrored.** The same argument with the roles swapped.

The wider last cell is harmless for the same reason: it only makes "`X2` is in cell `G-1`" easier to satisfy.

**Duplicates.** When `G < 3` on an axis, `Xs` repeats a cell (for `G = 1` all three are cell 0; for `G = 2`, -1 and +1 are the same cell). The same chain is then scanned twice. The marks from 11.3 keep the list duplicate-free: a marked bird is never appended again. Afterwards the marks of the listed birds are cleared, which gives `No_Marks`.

**Putting it together into `Exact_Set`:**

| `Exact_Set` clause | Where it comes from |
|---|---|
| every `List(K)` is a neighbour, `<= F.N` | `Inv`, kept by every `Scan_Cell` |
| no two entries equal | `Inv` + marks (11.3, duplicates paragraph) |
| every neighbour J appears | `Lemma_All_Near` puts `Key(J)` among the 9 `Cells`. That cell's `Scan_Cell` post marks J, and `Inv` says marked birds are in the list |

`List_Max = 9 * Max_Birds` is the size bound: each of the 9 scans adds at most `F.N` entries (`Count <= Count'Old + F.N`).

### 11.5 What this section does not show

- The arithmetic inside `Lemma_Div_Close` and `Lemma_Sq_Rev`. Read those bodies directly.
- How the prover is steered through the `Chains_OK` preservation step. That step is proved without extra lemmas, so there is nothing more to draw.

## 12. Measuring instead of proving

The proofs say nothing about speed or about how the flock looks (see the honest notes in the README). Those numbers are measured with the programs in [`tools/bench/`](../tools/README.md). It has one-command recipes for the README tables, reproduced on 29 Oct 2026, and it notes where they drift.

## 13. Deep study: the Rescale rounding window

`Rescale (V, T)` returns `V` scaled to length about `T`, using integers only. Its contract (`src/boids.ads`) is

```
Norm2 (R) <= T*T + T                         -- upper
if T >= 2 then Norm2 (R) >= (T - 2)**2       -- lower
```

This section derives both inequalities step by step, in the same order as the `pragma Assert`s in `src/boids.adb`. It then shows why aiming at `T - 1` / `T - 2` makes the v0.1 "compute, check, fall back" code unnecessary. Section 10 looked at one failing step of this proof; this one walks through all of it.

### 13.1 Names and the two facts everything rests on

| Name | Meaning in the code | Range |
|---|---|---|
| `WX, WY` | `V` after `Normalise`, i.e. doubled or halved into a fixed window | `\|WX\|, \|WY\| <= 2**16` |
| `N` | `WX*WX + WY*WY` | `2**30 <= N <= 2**33` |
| `S` | `Isqrt (N)` | `2**15 <= S < 2**17` |
| `T` | target length (`Len_T`) | `0 <= T <= 2**13` |
| `RX, RY` | `WX*T/S`, `WY*T/S` (Ada `/` truncates toward 0) | |
| `A, B` | `abs RX`, `abs RY` | |
| `PX, PY` | `abs WX * T`, `abs WY * T` | |
| `Q` | `A*A + B*B` = `Norm2 (R)` | |
| `T2, S2` | `T*T`, `S*S` | |

**Fact 1, the square root** (post of `Isqrt`):

```
S*S <= N < (S+1)*(S+1)                                   (I)
```

**Fact 2, the division**, once per component (post of `Lemma_Div`). Truncation of `PX / S` gives `A`, so

```
A*S <= PX < (A+1)*S          B*S <= PY < (B+1)*S        (D)
```

`Normalise` exists only to make the ranges above true. It guarantees `S >= 2**15`, and since `T <= 2**13` this gives

```
S >= 2*T + 1   and   S >= T                              (W)
```

All the products also stay far below `2**62`, so no step can overflow. `T = 0` is handled first: then `RX = RY = 0` and both bounds hold trivially (`0 <= 0`).

Intuition: each component of `R` is the exact value `WX*T/sqrt(N)` minus two small errors. One comes from the floor in `Isqrt`, the other from the truncating `/`. Each error is below one unit per component. The proof turns "below one unit" into a statement about squared lengths without taking any square root.

### 13.2 Upper bound: `Q <= T*T + T`

**Step U1, square (D).** Both sides of `A*S <= PX` are non-negative, so squaring keeps the order (`Lemma_Sq_Mono (A*S, PX)`):

```
A*A*S2 <= WX*WX*T2         B*B*S2 <= WY*WY*T2
```

**Step U2, add.**

```
Q*S2 = (A*A + B*B)*S2 <= (WX*WX + WY*WY)*T2 = N*T2
```

**Step U3, use the square root from above.** `N < (S+1)^2` from (I), times `T2 > 0` (`Lemma_Mul_Lt_B`):

```
N*T2 < (S+1)*(S+1)*T2
```

**Step U4, bound `(S+1)^2*T2` by a multiple of `S2`.** We want

```
(S+1)^2 * T2 <= (T2 + T + 1) * S2
<=> (S2 + 2S + 1)*T2 <= T2*S2 + T*S2 + S2
<=>        2S*T2 + T2 <= T*S2 + S2                       (*)
```

From (W), `2T + 1 <= S`. Multiplying by `T*S >= 0` (`Lemma_Mul_Le (2*T+1, S, T*S)`) gives

```
(2T+1)*T*S <= S*T*S   i.e.   2S*T2 + T*S <= T*S2
```

`S >= T` gives `T*S >= T2`, so

```
2S*T2 + T2 <= 2S*T2 + T*S <= T*S2 <= T*S2 + S2
```

which is (*). These are the asserts `T*S2 >= 2*S*T2 + T*S`, `T*S >= T2` and `(S+1)*(S+1)*T2 <= (T2+T+1)*S2`.

**Step U5, chain and cancel.**

```
Q*S2 <= N*T2 < (S+1)^2*T2 <= (T2+T+1)*S2
=>  Q*S2 < (T2+T+1)*S2
=>  Q < T2 + T + 1          (Lemma_Cancel, S2 > 0)
=>  Q <= T2 + T             (integers)
```

The `+ T` slack is there because `S` is the floor of the square root, so dividing by `S` slightly *enlarges* the result. The size of that enlargement is `(S+1)^2/S^2`, which (W) keeps below `1 + 1/T`. Truncating the division can only make `A` and `B` smaller, so it does not contribute here.

`Lemma_Comp_Bound (R, T + 1)` then turns `Q <= T2 + T < (T+1)^2` into `|RX|, |RY| <= T + 1`.

### 13.3 Lower bound: `Q >= (T-2)^2` when `T >= 2`

**Step L1, square the other half of (D)** (`Lemma_Sq_Strict (PX, (A+1)*S)`):

```
WX*WX*T2 < (A+1)^2*S2       WY*WY*T2 < (B+1)^2*S2
```

**Step L2, add.**

```
N*T2 < ((A+1)^2 + (B+1)^2) * S2
```

**Step L3, use the square root from below.** `S2 <= N` from (I), times `T2` (`Lemma_Mul_Le_B`):

```
S2*T2 <= N*T2 < ((A+1)^2 + (B+1)^2) * S2
```

**Step L4, cancel `S2`** (`Lemma_Cancel`):

```
T2 < (A+1)^2 + (B+1)^2 = Q + 2(A+B) + 2                 (L)
```

Read (L) as: the true length `T` is less than the length you get by adding one unit back to each component.

**Step L5, bound `A+B` by `Q`** (`Lemma_Sum_Sq`, from `(A-B)^2 >= 0`):

```
(A+B)^2 <= 2*(A*A + B*B) = 2Q
```

**Step L6, proof by contradiction.** Assume `Q < (T-2)^2`. If `T = 2` this says `Q < 0`, which is impossible. So `T >= 3` and `(T-2)^2 > 0`, and:

```
(2(A+B))^2 = 4(A+B)^2 <= 8Q < 8(T-2)^2 < 9(T-2)^2 = (3(T-2))^2
=>  2(A+B) < 3(T-2)            (Lemma_Sq_Rev: squares ordered => bases ordered)
```

Using the assumption once more:

```
Q + 2(A+B) + 2  <  (T-2)^2 + 3(T-2) + 2
                 = T2 - 4T + 4 + 3T - 6 + 2
                 = T2 - T
                 <= T2
```

This contradicts (L). In the code, the `if Q < (T - 2) * (T - 2)` branch asserts exactly these two lines and ends in `pragma Assert (False)`, so the prover sees that the branch is dead. Hence `Q >= (T-2)^2`.

The window is lopsided, `-2` below and `+T/T` above, for this reason. The upper side loses only the square-root floor, while the lower side has to absorb a full unit of truncation in *each* component. The `2(A+B) <= 3(T-2)` estimate is coarse, using 8 < 9 and `sqrt 2 < 3/2`. A tighter constant than 2 would need a sharper version of L5/L6. The `-2` is what the integer argument above can carry without real numbers.

### 13.4 Why aiming at `T - 1` / `T - 2` removes the fallback

v0.1 called the rescaler and then *checked* the result. If rounding had pushed it outside the allowed range, it fell back to a safe value. That fallback was correct, but the proof had to cover a branch that never ran, and its "why" was a run-time test. v0.2 knows the window in advance, so each caller simply picks a target whose whole window fits:

**`Limit (V, M)`** wants `Norm2 <= M*M`. It aims at `T = M - 1`:

```
Norm2 (R) <= (M-1)^2 + (M-1) = M*M - M <= M*M
```

This is the assert in `Limit`. `M = 0` is handled separately: the result is `Zero`.

**`Clamp_Speed (V, Lo, Hi)`** wants `Lo*Lo <= Norm2 <= Hi*Hi`. Its precondition is `1 <= Lo` and `Lo + 3 <= Hi`.

- Too fast: it aims at `T = Hi - 1`, and `T >= 2` holds because `Hi >= 4`.
  ```
  upper: (Hi-1)^2 + (Hi-1) = Hi*Hi - Hi <= Hi*Hi
  lower: (Hi-3)^2 >= Lo*Lo                because Lo <= Hi - 3   (Lemma_Sq_Mono (Lo, Hi - 3))
  ```
- Too slow: it aims at `T = Lo + 2`, and `T >= 3` holds.
  ```
  lower: (Lo+2-2)^2 = Lo*Lo
  upper: (Lo+2)^2 + (Lo+2) = Lo*Lo + 5Lo + 6 <= Lo*Lo + 6Lo + 9 = (Lo+3)^2 <= Hi*Hi
                                          (the assert, then Lemma_Sq_Mono (Lo + 3, Hi))
  ```
- A zero vector has no direction, so it becomes `(Lo, 0)`.

Both cases need `Hi - Lo >= 3`. The window `T-2 .. T+½` is about 2½ units wide, and both ends must fit between `Lo` and `Hi`. That is the reason `Valid_Params` and `Boids.API.Set_Param` keep `Max_Speed >= Min_Speed + 3` (3 units = 3/256 px, which nobody sees).

### 13.5 Map: step to code

| Step | Fact | Where in `src/boids.adb` |
|---|---|---|
| (I) | `S*S <= N < (S+1)^2` | `Isqrt` post |
| (D) | `A*S <= PX < (A+1)*S` | `Lemma_Div (WX, T, S, RX)`, same for Y |
| (W) | `S >= 2T+1` | `Normalise` window + `pragma Assert (S >= Small)` |
| U1–U2 | `Q*S2 <= N*T2` | `Lemma_Sq_Mono (A*S, PX)` and the three asserts after it |
| U3 | `N*T2 < (S+1)^2*T2` | `Lemma_Mul_Lt_B` |
| U4 | `(S+1)^2*T2 <= (T2+T+1)*S2` | `Lemma_Mul_Le (2*T+1, S, T*S)` and three asserts |
| U5 | `Q <= T2+T` | `Lemma_Cancel (Q, T2+T+1, S2)` |
| L1–L2 | `N*T2 < ((A+1)^2+(B+1)^2)*S2` | `Lemma_Sq_Strict` ×2 and asserts |
| L3–L4 | `T2 < Q + 2(A+B) + 2` | `Lemma_Mul_Le_B (S2, N, T2)`, `Lemma_Cancel (T2, ..., S2)` |
| L5 | `(A+B)^2 <= 2Q` | `Lemma_Sum_Sq (A, B)` |
| L6 | contradiction | `Lemma_Sq_Rev (2*(A+B), 3*(T-2))`, `pragma Assert (False)` |
| 13.4 | targets `M-1`, `Hi-1`, `Lo+2` | `Limit`, `Clamp_Speed` |

Section 10 shows what happens when one of these lemma calls (U1's `Lemma_Sq_Mono`) is removed.

## Where to start changing things

* New rule or parameter: `Params` and the rules in `boids-flocks.ads`, then
  `Set_Param` in `boids-api.adb`, then the sliders in `web/template.html`.
* Run `./prove.sh` after every Ada change; aim for 0 unproved without
  `Annotate`/`Assume`. When a non-linear step does not prove, isolate it in a
  ghost lemma with narrow subtypes.
