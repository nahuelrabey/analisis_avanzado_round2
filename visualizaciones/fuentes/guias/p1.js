/* Dibujos de la guía de la Práctica 1 (enunciados). Usa window.PP. */
const G = "guiap1";
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const SUB = "₀₁₂₃₄₅₆₇₈₉";
const sub = (n) => String(n).split("").map((d) => SUB[+d]).join("");

/* Arrastre de puntos: pick(px, py, T) devuelve un id o null; move(id, x, y, T) actualiza. */
function draggable(id, getT, pick, move, redraw) {
  const cv = document.getElementById(id);
  if (!cv) return;
  cv.style.touchAction = "none";
  cv.style.cursor = "grab";
  let active = null;
  const pos = (e) => { const r = cv.getBoundingClientRect(); return [e.clientX - r.left, e.clientY - r.top]; };
  cv.addEventListener("pointerdown", (e) => {
    const T = getT(); if (!T) return;
    const [px, py] = pos(e);
    active = pick(px, py, T);
    if (active !== null) { cv.setPointerCapture(e.pointerId); cv.style.cursor = "grabbing"; e.preventDefault(); }
  });
  cv.addEventListener("pointermove", (e) => {
    if (active === null) return;
    const T = getT(); const [px, py] = pos(e);
    move(active, T.iX(px), T.iY(py), T);
    redraw();
  });
  const end = () => { active = null; cv.style.cursor = "grab"; };
  cv.addEventListener("pointerup", end);
  cv.addEventListener("pointercancel", end);
}

/* Recta real horizontal con marcas enteras, a la altura y0 (en píxeles). */
function realLine(ctx, T, y0, x0, x1, step) {
  PP.path(ctx, [[T.X(x0), y0], [T.X(x1), y0]], C("--muted"), 1.2);
  for (let k = Math.ceil(x0 / step) * step; k <= x1 + 1e-9; k += step) {
    PP.path(ctx, [[T.X(k), y0 - 4], [T.X(k), y0 + 4]], C("--muted"), 1);
    PP.label(ctx, PP.fmt(k, 2), T.X(k), y0 + 7, C("--muted"), "center", "top", 11);
  }
}

/* Gráfico de una o más sucesiones: series = [{f, color, ring}], con banda opcional. */
function seqPlot(cid, N, series, opts) {
  const o = Object.assign({ y0: -1, y1: 1, lines: [], band: null, links: null }, opts || {});
  const { ctx, w, h } = PP.canvas(cid, 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: N + 1, y0: o.y0, y1: o.y1 }, { l: 40, r: 12, t: 14, b: 28 });
  if (o.band) {
    const [lo, hi] = o.band;
    const a = clamp(lo, o.y0, o.y1), b = clamp(hi, o.y0, o.y1);
    PP.rect(ctx, T.X(0), T.Y(b), T.X(N + 1) - T.X(0), T.Y(a) - T.Y(b), null, C("--band"));
  }
  PP.axes(ctx, T, { xLabel: "n", intX: true });
  o.lines.forEach(([v, color, txt, dash]) => {
    if (v < o.y0 || v > o.y1) return;
    PP.path(ctx, [[T.X(0), T.Y(v)], [T.X(N + 1), T.Y(v)]], color, 1.6, dash || []);
    if (txt) PP.label(ctx, txt, T.X(N + 1) - 4, T.Y(v) - 3, color, "right", "bottom", 11);
  });
  if (o.links) {
    for (let n = 1; n <= N; n++) {
      const a = o.links[0](n), b = o.links[1](n);
      PP.path(ctx, [[T.X(n), T.Y(clamp(a, o.y0, o.y1))], [T.X(n), T.Y(clamp(b, o.y0, o.y1))]], C("--rule"), 1.5);
    }
  }
  const r = N <= 30 ? 3.4 : N <= 60 ? 2.6 : 2;
  series.forEach((s) => {
    for (let n = 1; n <= N; n++) {
      const v = s.f(n);
      if (v < o.y0 - 1e-9 || v > o.y1 + 1e-9) continue;
      const col = typeof s.color === "function" ? s.color(n, v) : s.color;
      if (col) PP.dot(ctx, T.X(n), T.Y(v), r, col);
      if (s.ring && s.ring(n)) PP.circle(ctx, T.X(n), T.Y(v), r + 3.5, C("--seq3"), null, null, 2);
    }
  });
  return { ctx, T, w, h };
}

/* ===================== Ejercicio 1 ===================== */
const e1 = { x: 1.45, y: 1, T: null };
function drawEj1() {
  const eps = PP.val(G + "-ej1-eps") / 100;
  PP.out(G + "-ej1-eps-o", PP.fmt(eps, 2));
  const { ctx, w, h } = PP.canvas(G + "-ej1-c", 0.42);
  const T = PP.frame(w, h, { x0: -0.5, x1: 3, y0: 0, y1: 1 }, { l: 16, r: 16, t: 10, b: 10 });
  e1.T = T;
  const y0 = h * 0.62;
  // zona x < y + ε
  PP.rect(ctx, T.X(-0.5), y0 - 18, T.X(e1.y + eps) - T.X(-0.5), 36, null, C("--band"));
  realLine(ctx, T, y0, -0.5, 3, 0.5);
  PP.path(ctx, [[T.X(e1.y + eps), y0 - 24], [T.X(e1.y + eps), y0 + 24]], C("--accent"), 1.5, [5, 4]);
  PP.label(ctx, "y + ε", T.X(e1.y + eps), y0 - 26, C("--accent"), "center", "bottom", 12);
  PP.dot(ctx, T.X(e1.y), y0, 7, C("--seq2"));
  PP.label(ctx, "y", T.X(e1.y), y0 - 12, C("--seq2"), "center", "bottom", 13);
  const ok = e1.x < e1.y + eps;
  PP.dot(ctx, T.X(e1.x), y0, 7, C("--ink"));
  PP.label(ctx, "x", T.X(e1.x), y0 + 26, C("--ink"), "center", "top", 13);
  PP.read(G + "-ej1-read", [
    ["x, y", PP.fmt(e1.x, 2) + ", " + PP.fmt(e1.y, 2)],
    ["y + ε", PP.fmt(e1.y + eps, 3)],
    ["¿x < y + ε para este ε?", ok ? "sí" : "no", ok ? "good" : "bad"],
  ]);
}
PP.register(drawEj1, [G + "-ej1-eps"]);
draggable(G + "-ej1-c", () => e1.T,
  (px, py, T) => { const dx = Math.abs(px - T.X(e1.x)), dy = Math.abs(px - T.X(e1.y)); return Math.min(dx, dy) > 22 ? null : dx <= dy ? "x" : "y"; },
  (id, x) => { e1[id] = Math.round(clamp(x, -0.4, 2.9) * 100) / 100; }, drawEj1);

/* ===================== Ejercicio 2 ===================== */
const e2 = { x: 0.35, y: 1.15, T: null };
function drawEj2() {
  const n = PP.val(G + "-ej2-n");
  PP.out(G + "-ej2-n-o", String(n));
  const { ctx, w, h } = PP.canvas(G + "-ej2-c", 0.42);
  const T = PP.frame(w, h, { x0: -1.2, x1: 3.2, y0: 0, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  e2.T = T;
  const y0 = h * 0.58;
  if (e2.x > e2.y) { const t = e2.x; e2.x = e2.y; e2.y = t; }
  PP.rect(ctx, T.X(e2.x), y0 - 26, T.X(e2.y) - T.X(e2.x), 52, null, C("--band"));
  PP.path(ctx, [[T.X(-1.2), y0], [T.X(3.2), y0]], C("--muted"), 1.2);
  let between = 0, ints = 0;
  for (let m = Math.ceil(-1.2 * n); m <= 3.2 * n; m++) {
    const q = m / n;
    const isInt = m % n === 0;
    const inside = q > e2.x && q < e2.y;
    if (inside) between++;
    if (inside && isInt) ints++;
    const L = isInt ? 12 : 6;
    PP.path(ctx, [[T.X(q), y0 - L], [T.X(q), y0 + L]], inside ? C("--accent") : C("--muted"), isInt ? 1.8 : 1.1);
    if (isInt) PP.label(ctx, String(m / n).replace("-", "−"), T.X(q), y0 + 16, C("--muted"), "center", "top", 11);
  }
  PP.dot(ctx, T.X(e2.x), y0, 7, C("--seq2"));
  PP.label(ctx, "x", T.X(e2.x), y0 - 30, C("--seq2"), "center", "bottom", 13);
  PP.dot(ctx, T.X(e2.y), y0, 7, C("--seq2"));
  PP.label(ctx, "y", T.X(e2.y), y0 - 30, C("--seq2"), "center", "bottom", 13);
  PP.read(G + "-ej2-read", [
    ["x, y", PP.fmt(e2.x, 2) + ", " + PP.fmt(e2.y, 2)],
    ["y − x", PP.fmt(e2.y - e2.x, 2)],
    ["enteros entre x e y", String(ints)],
    ["fracciones m/" + n + " entre x e y", String(between)],
  ]);
}
PP.register(drawEj2, [G + "-ej2-n"]);
draggable(G + "-ej2-c", () => e2.T,
  (px, py, T) => { const dx = Math.abs(px - T.X(e2.x)), dy = Math.abs(px - T.X(e2.y)); return Math.min(dx, dy) > 22 ? null : dx <= dy ? "x" : "y"; },
  (id, x) => { e2[id] = Math.round(clamp(x, -1.1, 3.1) * 100) / 100; }, drawEj2);

/* ===================== Ejercicio 3 ===================== */
PP.register(function drawEj3() {
  const i = PP.val(G + "-ej3-i") / 100, eps = PP.val(G + "-ej3-eps") / 100;
  PP.out(G + "-ej3-i-o", PP.fmt(i, 2)); PP.out(G + "-ej3-eps-o", PP.fmt(eps, 2));
  const { ctx, w, h } = PP.canvas(G + "-ej3-c", 0.42);
  const T = PP.frame(w, h, { x0: 0.4, x1: 2.1, y0: 0, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  const y0 = h * 0.55;
  PP.rect(ctx, T.X(i), y0 - 22, T.X(i + eps) - T.X(i), 44, null, C("--band"));
  realLine(ctx, T, y0, 0.5, 2, 0.5);
  let cota = true, hit = 0;
  for (let n = 1; n <= 60; n++) {
    const a = 1 + 1 / n;
    if (a < i) cota = false;
    const inBand = a >= i && a < i + eps;
    if (inBand) hit++;
    PP.dot(ctx, T.X(a), y0, n <= 10 ? 4 : 2.6, inBand ? C("--accent") : C("--seq2"));
  }
  PP.path(ctx, [[T.X(i), y0 - 30], [T.X(i), y0 + 30]], C("--ink"), 2);
  PP.label(ctx, "i", T.X(i), y0 - 32, C("--ink"), "center", "bottom", 13);
  PP.label(ctx, "i + ε", T.X(i + eps), y0 + 26, C("--accent"), "center", "top", 11);
  PP.read(G + "-ej3-read", [
    ["¿i ≤ a para todo a dibujado?", cota ? "sí" : "no", cota ? "good" : "bad"],
    ["puntos de A en [i, i + ε)", String(hit) + (hit === 60 ? " o más" : ""), hit > 0 ? "good" : "bad"],
  ]);
}, [G + "-ej3-i", G + "-ej3-eps"]);

/* ===================== Ejercicio 4 ===================== */
PP.register(function drawEj4() {
  const it = PP.radio(G + "-ej4-it"), N = PP.val(G + "-ej4-N");
  PP.out(G + "-ej4-N-o", String(N));
  if (it === "d") {
    const { ctx, w, h } = PP.canvas(G + "-ej4-c", 0.62);
    const T = PP.frame(w, h, { x0: -2, x1: 3, y0: -2, y1: 5 }, { l: 40, r: 12, t: 14, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yLabel: "y" });
    const f = (x) => x * x - x - 1;
    const pts = [];
    for (let k = 0; k <= 200; k++) { const x = -2 + 5 * k / 200; pts.push([T.X(x), T.Y(f(x))]); }
    PP.path(ctx, pts, C("--accent"), 2);
    const step = 1 / N;
    let cnt = 0;
    for (let x = -2; x <= 3 + 1e-9; x += step) {
      const v = f(x);
      if (v > 5) continue;
      cnt++;
      PP.dot(ctx, T.X(x), T.Y(v), 2.4, C("--accent"));
      PP.path(ctx, [[T.X(x), T.Y(v)], [T.X(0), T.Y(v)]], C("--rule"), 1);
      PP.dot(ctx, T.X(0), T.Y(v), 3, C("--seq2"));
    }
    PP.read(G + "-ej4-read", [["conjunto", "{x² − x − 1 : x ∈ ℝ}"], ["x de la grilla", "paso 1/" + N + " en [−2, 3]"], ["valores dibujados", String(cnt)]]);
    return;
  }
  const { ctx, w, h } = PP.canvas(G + "-ej4-c", 0.42);
  const box = it === "a" ? { x0: 0, x1: 4, y0: 0, y1: 1 } : { x0: -0.1, x1: 0.6, y0: 0, y1: 1 };
  const T = PP.frame(w, h, box, { l: 16, r: 16, t: 10, b: 10 });
  const y0 = h * 0.55;
  realLine(ctx, T, y0, box.x0 < 0 ? 0 : box.x0, box.x1, it === "a" ? 1 : 0.1);
  if (it === "a") {
    PP.path(ctx, [[T.X(1), y0], [T.X(3), y0]], C("--accent"), 5);
    PP.circle(ctx, T.X(1), y0, 6, C("--accent"), C("--bg"), null, 2);
    PP.dot(ctx, T.X(3), y0, 6, C("--accent"));
    PP.label(ctx, "a", T.X(1), y0 - 12, C("--accent"), "center", "bottom", 13);
    PP.label(ctx, "b", T.X(3), y0 - 12, C("--accent"), "center", "bottom", 13);
    PP.read(G + "-ej4-read", [["conjunto", "(a, b] con a = 1, b = 3"]]);
    return;
  }
  for (let n = 1; n <= N; n++) {
    const v = 1 / Math.pow(2, n);
    if (v < box.x0) continue;
    PP.dot(ctx, T.X(v), y0, n <= 5 ? 5 : 3.4, C("--accent"));
    if (n <= 4) PP.label(ctx, "1/" + Math.pow(2, n), T.X(v), y0 - 12, C("--accent"), "center", "bottom", 11);
  }
  if (it === "c") {
    PP.dot(ctx, T.X(0), y0, 6, C("--seq2"));
    PP.label(ctx, "0", T.X(0), y0 - 12, C("--seq2"), "center", "bottom", 12);
  }
  PP.read(G + "-ej4-read", [
    ["conjunto", it === "b" ? "B = {1/2ⁿ : n ∈ ℕ}" : "B ∪ {0}"],
    ["términos dibujados", "n = 1, …, " + N],
    ["menor término dibujado", "1/2" + (N > 1 ? "^" + N : "") + " = " + PP.fmt(1 / Math.pow(2, N), 5)],
  ]);
}, ["input[name='" + G + "-ej4-it']", G + "-ej4-N"]);

/* ===================== Ejercicio 6 ===================== */
PP.register(function drawEj6() {
  const c = PP.val(G + "-ej6-cc") / 100;
  PP.out(G + "-ej6-cc-o", PP.fmt(c, 2));
  const { ctx, w, h } = PP.canvas(G + "-ej6-c", 0.62);
  const T = PP.frame(w, h, { x0: -4.6, x1: 4.6, y0: 0, y1: 1 }, { l: 36, r: 14, t: 10, b: 10 });
  const rows = [["A", 1, C("--accent")], ["−A", -1, C("--seq2")], ["cA", c, C("--seq3")]];
  rows.forEach(([name, k, col], j) => {
    const y = h * (0.2 + 0.3 * j);
    realLine(ctx, T, y, -4, 4, 1);
    PP.label(ctx, name, 6, y, col, "left", "middle", 13);
    const a1 = k * 0.5, a2 = k * 1.5, p = k * -1;
    PP.path(ctx, [[T.X(Math.min(a1, a2)), y], [T.X(Math.max(a1, a2)), y]], col, 6);
    PP.dot(ctx, T.X(a1), y, 4, col); PP.dot(ctx, T.X(a2), y, 4, col);
    PP.dot(ctx, T.X(p), y, 5.5, col);
  });
  PP.read(G + "-ej6-read", [
    ["A", "{−1} ∪ [0.5, 1.5]"],
    ["−A", "{1} ∪ [−1.5, −0.5]"],
    ["cA", "{" + PP.fmt(-c, 2) + "} ∪ [" + PP.fmt(0.5 * c, 3) + ", " + PP.fmt(1.5 * c, 3) + "]"],
  ]);
}, [G + "-ej6-cc"]);

/* ===================== Ejercicio 7 ===================== */
PP.register(function drawEj7() {
  const it = PP.radio(G + "-ej7-it"), eps = PP.val(G + "-ej7-eps") / 100, N = PP.val(G + "-ej7-N");
  PP.out(G + "-ej7-eps-o", PP.fmt(eps, 2)); PP.out(G + "-ej7-N-o", String(N));
  const D = {
    a: { f: (n) => (3 - 2 * n) / (n + 1), l: -2, y0: -2.4, y1: 0.7, txt: "(3 − 2n)/(n + 1)" },
    b: { f: (n) => Math.sin(n) / n, l: 0, y0: -0.6, y1: 0.95, txt: "sen(n)/n" },
    c: { f: (n) => (Math.pow(2, n) - 3) / (Math.pow(2, n) + 4), l: 1, y0: -0.3, y1: 1.25, txt: "(2ⁿ − 3)/(2ⁿ + 4)" },
  }[it];
  let out = 0;
  seqPlot(G + "-ej7-c", N, [{ f: D.f, color: (n, v) => { const o = Math.abs(v - D.l) >= eps; if (o) out++; return o ? C("--seq2") : C("--accent"); } }],
    { y0: D.y0, y1: D.y1, band: [D.l - eps, D.l + eps], lines: [[D.l, C("--ok"), "ℓ = " + PP.fmt(D.l)]] });
  PP.read(G + "-ej7-read", [
    ["xₙ", D.txt],
    ["límite del enunciado", PP.fmt(D.l)],
    ["términos dibujados fuera de la banda", String(out)],
  ]);
}, ["input[name='" + G + "-ej7-it']", G + "-ej7-eps", G + "-ej7-N"]);

/* ===================== Ejercicio 8 ===================== */
PP.register(function drawEj8() {
  const N = PP.val(G + "-ej8-N");
  PP.out(G + "-ej8-N-o", String(N));
  const a = (n) => 2 / Math.sqrt(n), x = (n) => 1 + a(n) * Math.sin(n);
  const { ctx, T } = seqPlot(G + "-ej8-c", N, [], { y0: -1.2, y1: 3.2, lines: [[1, C("--ok"), "ℓ = 1"]] });
  const up = [], dn = [];
  for (let k = 0; k <= 200; k++) { const n = 1 + (N - 1) * k / 200; up.push([T.X(n), T.Y(1 + a(n))]); dn.push([T.X(n), T.Y(1 - a(n))]); }
  PP.path(ctx, up, C("--seq2"), 1.5, [5, 4]); PP.path(ctx, dn, C("--seq2"), 1.5, [5, 4]);
  for (let n = 1; n <= N; n++) PP.dot(ctx, T.X(n), T.Y(x(n)), N <= 30 ? 3.4 : 2.6, C("--accent"));
  PP.read(G + "-ej8-read", [
    ["n = " + N, "xₙ = " + PP.fmt(x(N), 4)],
    ["aₙ", PP.fmt(a(N), 4)],
    ["|xₙ − ℓ| ≤ aₙ", "sí", "good"],
  ]);
}, [G + "-ej8-N"]);

/* ===================== Ejercicio 9 ===================== */
PP.register(function drawEj9() {
  const it = PP.radio(G + "-ej9-it"), N = PP.val(G + "-ej9-N"), sum = document.getElementById(G + "-ej9-sum").checked;
  PP.out(G + "-ej9-N-o", String(N));
  const xa = (n) => 1 + Math.pow(-1, n) / n;
  const D = {
    a: { x: xa, y: (n) => 2 - 1 / n, y0: -0.2, y1: 3.8, lx: "ℓ₁ = 1", ly: "ℓ₂ = 2" },
    b: { x: xa, y: (n) => n / 3, y0: -0.2, y1: 16, lx: "ℓ₁ = 1", ly: "ℓ₂ = +∞" },
    c: { x: (n) => Math.sqrt(n), y: (n) => n / 4, y0: -0.2, y1: 17, lx: "ℓ₁ = +∞", ly: "ℓ₂ = +∞" },
  }[it];
  const ser = [{ f: D.x, color: C("--accent") }, { f: D.y, color: C("--seq2") }];
  if (sum) ser.push({ f: (n) => D.x(n) + D.y(n), color: C("--seq3") });
  const lines = it === "a" ? [[1, C("--accent"), "", [4, 4]], [2, C("--seq2"), "", [4, 4]]] : it === "b" ? [[1, C("--accent"), "", [4, 4]]] : [];
  seqPlot(G + "-ej9-c", N, ser, { y0: D.y0, y1: D.y1, lines });
  const rows = [["xₙ (azul)", D.lx], ["yₙ (naranja)", D.ly], ["n = " + N, "xₙ + yₙ = " + PP.fmt(D.x(N) + D.y(N), 3)]];
  PP.read(G + "-ej9-read", rows);
}, ["input[name='" + G + "-ej9-it']", G + "-ej9-N", G + "-ej9-sum"]);

/* ===================== Ejercicio 10 ===================== */
PP.register(function drawEj10() {
  const it = PP.radio(G + "-ej10-it"), N = PP.val(G + "-ej10-N");
  PP.out(G + "-ej10-N-o", String(N));
  const x = (n) => 1 - 1 / n;
  const y = it === "0" ? (n) => 1.5 + Math.pow(-1, n) / (2 * n) : (n) => 1 + 1 / n;
  const l2 = it === "0" ? 1.5 : 1;
  seqPlot(G + "-ej10-c", N, [{ f: x, color: C("--accent") }, { f: y, color: C("--seq2") }],
    { y0: -0.1, y1: 2.1, links: [x, y], lines: [[1, C("--accent"), "", [4, 4]], [l2, C("--seq2"), "", [4, 4]]] });
  let okAll = true;
  for (let n = 1; n <= N; n++) if (x(n) > y(n)) okAll = false;
  PP.read(G + "-ej10-read", [
    ["¿xₙ ≤ yₙ en los dibujados?", okAll ? "sí" : "no", okAll ? "good" : "bad"],
    ["ℓ₁, ℓ₂", "1, " + PP.fmt(l2)],
  ]);
}, ["input[name='" + G + "-ej10-it']", G + "-ej10-N"]);

/* ===================== Ejercicio 11 ===================== */
PP.register(function drawEj11() {
  const N = PP.val(G + "-ej11-N"), prod = document.getElementById(G + "-ej11-prod").checked;
  PP.out(G + "-ej11-N-o", String(N));
  const x = (n) => 1 / Math.sqrt(n), y = (n) => 1.5 * Math.cos(n);
  const ser = [{ f: x, color: C("--accent") }, { f: y, color: C("--seq2") }];
  if (prod) ser.push({ f: (n) => x(n) * y(n), color: C("--seq3") });
  seqPlot(G + "-ej11-c", N, ser, { y0: -1.8, y1: 1.8, band: [-1.5, 1.5], lines: [[1.5, C("--seq2"), "M", [4, 4]], [-1.5, C("--seq2"), "−M", [4, 4]]] });
  PP.read(G + "-ej11-read", [
    ["xₙ = 1/√n", "→ 0"],
    ["|yₙ| ≤ M", "M = 1.5"],
    ["n = " + N, "xₙ yₙ = " + PP.fmt(x(N) * y(N), 4)],
  ]);
}, [G + "-ej11-N", G + "-ej11-prod"]);

/* ===================== Ejercicio 12 ===================== */
PP.register(function drawEj12() {
  const it = PP.radio(G + "-ej12-it"), N = PP.val(G + "-ej12-N");
  PP.out(G + "-ej12-N-o", String(N));
  const f = it === "a" ? (n) => 1 + 2 / n : (n) => 2 - Math.sqrt(n);
  const y0 = it === "a" ? 0 : 2 - Math.sqrt(N) - 0.5, y1 = it === "a" ? 3.2 : 1.3;
  const { ctx, T } = seqPlot(G + "-ej12-c", N, [], { y0, y1 });
  for (let n = 1; n < N; n++) PP.path(ctx, [[T.X(n), T.Y(f(n))], [T.X(n + 1), T.Y(f(n + 1))]], C("--rule"), 1.5);
  for (let n = 1; n <= N; n++) PP.dot(ctx, T.X(n), T.Y(f(n)), N <= 30 ? 3.4 : 2.6, C("--accent"));
  PP.read(G + "-ej12-read", [
    ["xₙ", it === "a" ? "1 + 2/n" : "2 − √n"],
    ["n = " + N, "xₙ = " + PP.fmt(f(N), 4)],
    ["¿xₙ₊₁ ≤ xₙ?", "sí, siempre", "good"],
  ]);
}, ["input[name='" + G + "-ej12-it']", G + "-ej12-N"]);

/* ===================== Ejercicio 16 ===================== */
PP.register(function drawEj16() {
  const it = PP.radio(G + "-ej16-it"), N = PP.val(G + "-ej16-N");
  PP.out(G + "-ej16-N-o", String(N));
  const f = (n) => 1 + Math.pow(-1, n) / n;
  seqPlot(G + "-ej16-c", N, [{ f, color: (n) => (n % 2 === 0 ? C("--accent") : C("--seq2")), ring: it === "b" ? (n) => n % 3 === 0 : null }],
    { y0: -0.1, y1: 1.65 });
  const idx = (pred) => { const a = []; for (let n = 1; n <= Math.min(N, 12); n++) if (pred(n)) a.push(n); return a.join(", ") + (N > 12 ? ", …" : ""); };
  const rows = [["pares (azul)", idx((n) => n % 2 === 0)], ["impares (naranja)", idx((n) => n % 2 === 1)]];
  if (it === "b") rows.push(["múltiplos de 3 (anillo)", idx((n) => n % 3 === 0)]);
  PP.read(G + "-ej16-read", rows);
}, ["input[name='" + G + "-ej16-it']", G + "-ej16-N"]);

/* ===================== Anexo ===================== */
PP.register(function drawAnexo() {
  const { ctx, w, h } = PP.canvas(G + "-anexo-c", 0.8);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.08, y1: 1.02 }, { l: 40, r: 14, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "y", xTicks: 5, yTicks: 5 });
  const f = (x) => (x < 0.6 ? 0.35 + 0.3 * x : 0.75 + 0.2 * x);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(1)]], C("--muted"), 1.2, [5, 4]);
  // conjunto {f(x) > x}
  const yb = T.Y(-0.04);
  let start = null;
  for (let k = 0; k <= 1000; k++) {
    const x = k / 1000, inS = f(x) > x;
    if (inS && start === null) start = x;
    if ((!inS || k === 1000) && start !== null) { PP.path(ctx, [[T.X(start), yb], [T.X(x), yb]], C("--seq2"), 6); start = null; }
  }
  PP.path(ctx, [[T.X(0), T.Y(f(0))], [T.X(0.6), T.Y(f(0.6 - 1e-9))]], C("--accent"), 2.4);
  PP.path(ctx, [[T.X(0.6), T.Y(f(0.6))], [T.X(1), T.Y(f(1))]], C("--accent"), 2.4);
  PP.circle(ctx, T.X(0.6), T.Y(0.35 + 0.18), 4, C("--accent"), C("--bg"), null, 2);
  PP.dot(ctx, T.X(0.6), T.Y(f(0.6)), 4, C("--accent"));
  PP.label(ctx, "f", T.X(0.3), T.Y(f(0.3)) - 6, C("--accent"), "center", "bottom", 13);
  PP.label(ctx, "y = x", T.X(0.92), T.Y(0.92) + 4, C("--muted"), "left", "top", 11);
  PP.read(G + "-anexo-read", [
    ["f(a) = f(0)", "0.35 > 0 = a", "good"],
    ["{x : f(x) > x} (naranja)", "[0, 0.5) ∪ [0.6, 0.9375)"],
  ]);
}, []);
