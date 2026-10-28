#!/usr/bin/env python3
"""Embed the WebAssembly module and the real GNATprove summary into the page.
usage: embed.py mf.wasm gnatprove.out template.html out.html"""
import base64, json, re, sys, subprocess, datetime

wasm, prove, template, out = sys.argv[1:5]
text = open(prove).read()
rows = {}
for line in text.splitlines():
    m = re.match(r"^(Data Dependencies|Flow Dependencies|Initialization|Non-Aliasing|"
                 r"Run-time Checks|Assertions|Functional Contracts|LSP Verification|"
                 r"Termination|Concurrency|Total)\s+(\S+)\s+(.*)$", line)
    if not m:
        continue
    cells = re.split(r"\s{2,}", m.group(3).strip())
    num = lambda s: 0 if s in (".", "") else int(s.split()[0])
    total = num(m.group(2))
    # remaining columns: Flow, Provers, Justified, Unproved
    flow, provers, justified, unproved = (cells + ["."] * 4)[:4]
    rows[m.group(1)] = {"total": total, "flow": num(flow), "provers": num(provers),
                        "justified": num(justified), "unproved": num(unproved)}

def clean(*cats):
    return all(rows.get(c, {"unproved": 0, "justified": 0})["unproved"] == 0 and
               rows.get(c, {"justified": 0})["justified"] == 0 for c in cats)

units = re.search(r"Analyzed (\d+) units", text)
levels = [
    ["Stone", "valid SPARK, all units analysed", bool(units)],
    ["Bronze", "flow analysis: initialization, data dependencies", clean("Data Dependencies", "Flow Dependencies", "Initialization")],
    ["Silver", "absence of run-time errors (no overflow, range, index, division errors) + termination", clean("Run-time Checks", "Termination")],
    ["Gold", "functional contracts: force caps, speed clamp, wrap, neighbour set", clean("Assertions", "Functional Contracts")],
]
version = "unknown"
try:
    version = open(prove.replace("gnatprove.out", "version.txt")).read().strip()
except OSError:
    pass
proof = {"rows": rows, "levels": levels, "units": int(units.group(1)) if units else 0,
         "gnatprove": version,
         "assumes": len(re.findall(r"[1-9]\d* pragma Assume", text)),
         "built": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%d %H:%M UTC")}
try:
    proof["commit"] = subprocess.check_output(["git", "rev-parse", "--short", "HEAD"], text=True).strip()
except Exception:
    proof["commit"] = "?"
page = open(template).read()
page = page.replace("__WASM_BASE64__", base64.b64encode(open(wasm, "rb").read()).decode())
page = page.replace("__PROOF_JSON__", json.dumps(proof))
open(out, "w").write(page)
