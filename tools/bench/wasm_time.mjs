// node tools/bench/wasm_time.mjs [preset=after|before|page|plain] [birds=1200] [steps=2000]
// Times mf_tick of the WebAssembly embedded in docs/index.html (the live
// binary; nothing is rebuilt) for the three README worlds, seeds 5 / 9 / 11.
// Reports mean ms/step over the last 200 steps, like tools/bench/metrics.
import {readFileSync} from "node:fs";
const [preset = "after", birds = "1200", steps = "2000"] = process.argv.slice(2);
const html = readFileSync(new URL("../../docs/index.html", import.meta.url), "utf8");
const b64 = html.match(/WASM = "([A-Za-z0-9+/=]+)"/)[1];
const {instance} = await WebAssembly.instantiate(Buffer.from(b64, "base64"));
const a = instance.exports;
// same order and scaling as web/template.html apply(); force differs by preset
const P = {
  before: {9: 1024, 8: 512, 3: 50,  4: 16, 5: 150, 6: 100, 7: 100, 10: 31},
  after:  {9: 1024, 8: 640, 3: 110, 4: 40, 5: 300, 6: 250, 7: 250, 10: 60},
  page:   {9: 1024, 8: 640, 3: 110, 4: 40, 5: 300, 6: 250, 7: 250, 10: 59},
  plain:  {3: 50},
}[preset];
const worlds = preset === "plain" ? [[1280, 720]] : [[2560, 1440], [1920, 1080], [1280, 720]];
const seeds = preset === "plain" ? [42] : [5, 9, 11];
for (const [w, h] of worlds) {
  const out = [];
  for (const seed of seeds) {
    a.mf_set_param(11, 0); a.mf_set_param(1, w); a.mf_set_param(2, h);
    for (const [k, v] of Object.entries(P)) a.mf_set_param(+k, v);
    a.mf_set_param(11, +birds);
    a.mf_start(seed);
    const n = +steps, tail = Math.min(200, n);
    for (let s = 0; s < n - tail; s++) a.mf_tick();
    const t0 = performance.now();
    for (let s = 0; s < tail; s++) a.mf_tick();
    out.push(((performance.now() - t0) / tail).toFixed(1));
  }
  console.log(`${preset} ${w}x${h} ${a.mf_count()} birds, seeds ${seeds.join("/")}: ${out.join(" / ")} ms/step`);
}
