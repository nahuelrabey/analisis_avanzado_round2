/* Dibujos del primer parcial 1C 2024. Los valores y funciones de cada dibujo son elegidos para ilustrar; no forman parte de la resolución. */
const ID = "p1-1c2024";
const $id = (s) => ID + "-" + s;
const SUPD = "⁰¹²³⁴⁵⁶⁷⁸⁹", SUBD = "₀₁₂₃₄₅₆₇₈₉";
const sup = (n) => String(n).replace(/\d/g, (c) => SUPD[+c]);
const sub = (n) => String(n).replace(/\d/g, (c) => SUBD[+c]);
const minus = (s) => String(s).replace(/-/g, "−");
const C = (t) => PP.css(t);

function arrow(ctx, x1, y1, x2, y2, color) {
  PP.path(ctx, [[x1, y1], [x2, y2]], color, 1.4);
  const a = Math.atan2(y2 - y1, x2 - x1), L = 7;
  PP.path(ctx, [[x2, y2], [x2 - L * Math.cos(a - 0.45), y2 - L * Math.sin(a - 0.45)], [x2 - L * Math.cos(a + 0.45), y2 - L * Math.sin(a + 0.45)]], null, 0, null, true, color);
}
function clipBox(ctx, T) {
  ctx.save(); ctx.beginPath();
  ctx.rect(T.p.l, T.p.t, T.w - T.p.l - T.p.r, T.h - T.p.t - T.p.b); ctx.clip();
}
function graph(ctx, T, fn, x0, x1, color, width, dash) {
  const pts = [], N = 300;
  for (let i = 0; i <= N; i++) { const x = x0 + (x1 - x0) * i / N; pts.push([T.X(x), T.Y(fn(x))]); }
  PP.path(ctx, pts, color, width, dash);
}
/* extremo de un intervalo: lleno si está, hueco si no */
function endpoint(ctx, x, y, closed, color) { PP.dot(ctx, x, y, 4.2, closed ? color : C("--bg"), color); }

/* ---------- Ej. 1 (a): la codificación Φ ---------- */
const gcd = (a, b) => (b ? gcd(b, a % b) : Math.abs(a));
/* Enumeración de ℚ elegida para el dibujo: 0 y después ±p/q irreducibles por p + q creciente. φ(RATS[k − 1]) = k. */
const RATS = [[0, 1]];
for (let s = 2; RATS.length < 24; s++) for (let p = 1; p < s; p++) { const q = s - p; if (gcd(p, q) === 1) RATS.push([p, q], [-p, q]); }
const ratStr = ([p, q]) => (q === 1 ? minus(p) : minus(p) + "/" + q);
const PRIMES = [2, 3, 5, 7];
function polyStr(coefs) {
  let s = "";
  for (let j = coefs.length - 1; j >= 0; j--) {
    const [p, q] = coefs[j];
    if (p === 0) continue;
    const ap = Math.abs(p), mon = j === 0 ? "" : j === 1 ? "x" : "x" + sup(j);
    let c = q === 1 ? String(ap) : ap + "/" + q;
    if (j > 0 && ap === 1 && q === 1) c = "";
    else if (j > 0 && q !== 1) c = "(" + c + ")";
    s += s === "" ? (p < 0 ? "−" : "") + c + mon : (p < 0 ? " − " : " + ") + c + mon;
  }
  return s || "0";
}

PP.register(function drawPhi() {
  const n = +(PP.radio($id("ej1-grado")) || 2);
  const idx = [0, 1, 2, 3].map((j) => PP.val($id("ej1-a" + j)));
  [0, 1, 2, 3].forEach((j) => {
    PP.out($id("ej1-a" + j + "-o"), ratStr(RATS[idx[j] - 1]));
    const row = document.getElementById($id("ej1-a" + j)).closest(".slider");
    if (row) row.style.display = j <= n ? "" : "none";
  });
  const { ctx, w, h } = PP.canvas($id("ej1-c1"), 0.62);
  const ink = C("--ink"), mut = C("--muted"), acc = C("--accent"), s2 = C("--seq2"), fail = C("--fail");
  const bad = idx[n] === 1;
  const padX = 8, cw = (w - 2 * padX) / (n + 1), bw = Math.min(cw - 10, 96);
  const y1 = 34, y2 = Math.round(h * 0.42), y3 = Math.round(h * 0.64);
  for (let j = 0; j <= n; j++) {
    const cx = padX + cw * (j + 0.5), col = bad && j === n ? fail : acc;
    PP.label(ctx, "a" + sub(j), cx, y1 - 18, mut, "center", "middle", 12);
    PP.rect(ctx, cx - bw / 2, y1 - 6, bw, 26, col, C("--band"));
    PP.label(ctx, ratStr(RATS[idx[j] - 1]), cx, y1 + 7, col, "center", "middle", 14);
    arrow(ctx, cx, y1 + 22, cx, y2 - 13, mut);
    PP.label(ctx, "φ", cx + 6, (y1 + 22 + y2 - 13) / 2, mut, "left", "middle", 12);
    PP.label(ctx, String(idx[j]), cx, y2, ink, "center", "middle", 14);
    arrow(ctx, cx, y2 + 11, cx, y3 - 16, mut);
    PP.rect(ctx, cx - bw / 2, y3 - 15, bw, 30, s2, C("--area2"));
    PP.label(ctx, PRIMES[j] + sup(idx[j]), cx, y3, s2, "center", "middle", 15);
  }
  const factors = [];
  let N = 1n;
  for (let j = 0; j <= n; j++) { factors.push(PRIMES[j] + sup(idx[j])); N *= BigInt(PRIMES[j]) ** BigInt(idx[j]); }
  const ds = N.toString();
  const valStr = ds.length <= 15 ? ds.replace(/\B(?=(\d{3})+(?!\d))/g, " ") : ds.slice(0, 5) + "…  (" + ds.length + " cifras)";
  PP.label(ctx, "Φ(p) = " + factors.join(" · "), w / 2, h - 34, bad ? fail : ink, "center", "middle", 14);
  PP.label(ctx, bad ? "no definido: a" + sub(n) + " = 0" : "= " + valStr, w / 2, h - 13, mut, "center", "middle", 12);
  const coefs = idx.slice(0, n + 1).map((k) => RATS[k - 1]);
  const rows = [["p(x)", polyStr(coefs)]];
  if (bad) rows.push(["a" + sub(n), "= 0: p no es de grado " + n, "bad"]);
  rows.push(["Φ(p)", factors.join(" · ") + (bad ? "" : " = " + valStr)]);
  rows.push(["decodificar", "exponentes " + idx.slice(0, n + 1).join(", ") + " → coeficientes " + coefs.map(ratStr).join(", "), bad ? "" : "good"]);
  PP.read($id("ej1-read"), rows);
}, [$id("ej1-a0"), $id("ej1-a1"), $id("ej1-a2"), $id("ej1-a3"), `input[name="${ID}-ej1-grado"]`]);

/* ---------- Ej. 1 (b): raíces ---------- */
const POLS = [
  { c: [-2, 0, 1], s: "x² − 2" },
  { c: [0, -1, 0, 1], s: "x³ − x" },
  { c: [1, -3, 2], s: "2x² − 3x + 1" },
  { c: [1, -3, 0, 1], s: "x³ − 3x + 1" },
  { c: [1, 0, 1], s: "x² + 1" },
];
const horner = (c, x) => c.reduceRight((acc, a) => acc * x + a, 0);
function realRoots(c, x0, x1) {
  const out = [], N = 2400;
  let xp = x0, fp = horner(c, xp);
  for (let i = 1; i <= N; i++) {
    const x = x0 + (x1 - x0) * i / N, fx = horner(c, x);
    if (fp === 0) out.push(xp);
    else if (fp * fx < 0) {
      let a = xp, b = x;
      for (let k = 0; k < 60; k++) { const m = (a + b) / 2; if (horner(c, a) * horner(c, m) <= 0) b = m; else a = m; }
      out.push((a + b) / 2);
    }
    xp = x; fp = fx;
  }
  return out.filter((r, i) => i === 0 || Math.abs(r - out[i - 1]) > 1e-6);
}
function polyFrame(id, ratio) {
  const { ctx, w, h } = PP.canvas(id, ratio);
  const T = PP.frame(w, h, { x0: -2.5, x1: 2.5, y0: -3, y1: 3 }, { l: 30 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "p(x)" });
  return { ctx, T };
}

PP.register(function drawRoots() {
  const P = POLS[+(PP.radio($id("ej1b-pol")) || 0)];
  const { ctx, T } = polyFrame($id("ej1b-c1"), 0.62);
  clipBox(ctx, T); graph(ctx, T, (x) => horner(P.c, x), -2.5, 2.5, C("--accent"), 2); ctx.restore();
  const R = realRoots(P.c, -2.5, 2.5);
  R.forEach((r, i) => {
    PP.dot(ctx, T.X(r), T.Y(0), 5, C("--seq2"));
    PP.label(ctx, PP.fmt(r, 3), T.X(r), T.Y(0) + (i % 2 ? 20 : -9), C("--seq2"), "center", i % 2 ? "top" : "bottom", 11);
  });
  PP.label(ctx, "p(x) = " + P.s, T.p.l + 8, T.p.t + 18, C("--accent"), "left", "top", 13);
  PP.read($id("ej1b-read"), [
    ["p(x)", P.s],
    ["Rₚ", R.length ? "{" + R.map((r) => PP.fmt(r, 3)).join(", ") + "}" : "∅"],
    ["#Rₚ", R.length + " (finito)", "good"],
  ]);
}, [`input[name="${ID}-ej1b-pol"]`]);

PP.register(function drawAlpha() {
  const k = PP.val($id("ej1b-alpha")), g = gcd(k, 8), a = k / 8, aStr = ratStr([k / g, 8 / g]);
  PP.out($id("ej1b-alpha-o"), aStr);
  const { ctx, T } = polyFrame($id("ej1b-c2"), 0.5);
  clipBox(ctx, T); graph(ctx, T, (x) => x - a, -2.5, 2.5, C("--accent"), 2); ctx.restore();
  PP.dot(ctx, T.X(a), T.Y(0), 5.5, C("--seq2"));
  PP.label(ctx, "α = " + aStr, T.X(a) + 8, T.Y(0) + 6, C("--seq2"), "left", "top", 12);
  const pStr = k === 0 ? "x" : "x " + (k > 0 ? "− " : "+ ") + ratStr([Math.abs(k) / g, 8 / g]);
  PP.read($id("ej1b-read2"), [["p(x)", pStr], ["Rₚ", "{" + aStr + "}"], ["α ∈ ℬ", "sí", "good"]]);
}, [$id("ej1b-alpha")]);

/* ---------- Ej. 2 ---------- */
const f2 = (x) => 0.45 + 0.25 * Math.sin(2 * Math.PI * x);
function integrate(fn, N) { N = N || 600; let s = 0; for (let i = 0; i <= N; i++) { const x = i / N; s += (i === 0 || i === N ? 0.5 : 1) * fn(x); } return s / N; }

PP.register(function drawCuenta() {
  const c = PP.val($id("ej2-c")) / 100, wd = PP.val($id("ej2-w")) / 100;
  PP.out($id("ej2-c-o"), PP.fmt(c, 2)); PP.out($id("ej2-w-o"), PP.fmt(wd, 2));
  const bump = (x) => 0.35 * Math.exp(-(((x - c) / wd) ** 2));
  const g = (x) => f2(x) + bump(x);
  let dinf = 0; for (let i = 0; i <= 1000; i++) dinf = Math.max(dinf, bump(i / 1000));
  const d1 = integrate((x) => x * bump(x), 1000);
  const { ctx, w, h } = PP.canvas($id("ej2-c1"), 0.9);
  const mid = Math.round(h * 0.5);
  const T1 = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.05, y1: 1.15 }, { l: 38, r: 12, t: 12, b: h - mid + 8 });
  const T2 = PP.frame(w, h, { x0: 0, x1: 1, y0: 0, y1: 0.4 }, { l: 38, r: 12, t: mid + 30, b: 26 });
  PP.axes(ctx, T1, { yTicks: 3 });
  PP.axes(ctx, T2, { yTicks: 3 });
  graph(ctx, T1, f2, 0, 1, C("--accent"), 2);
  graph(ctx, T1, g, 0, 1, C("--seq2"), 2);
  PP.label(ctx, "f", T1.X(0.04), T1.Y(f2(0.04)) - 6, C("--accent"), "left", "bottom", 13);
  PP.label(ctx, "g", T1.X(Math.min(0.95, c + 0.04)), T1.Y(g(Math.min(0.95, c + 0.04))) - 6, C("--seq2"), "left", "bottom", 13);
  /* abajo: triángulo x·d∞, curva |f − g| y área de x|f − g| */
  PP.path(ctx, [[T2.X(0), T2.Y(0)], [T2.X(1), T2.Y(dinf)], [T2.X(1), T2.Y(0)]], null, 0, null, true, C("--band"));
  PP.path(ctx, [[T2.X(0), T2.Y(dinf)], [T2.X(1), T2.Y(dinf)]], C("--muted"), 1, [3, 4]);
  PP.path(ctx, [[T2.X(0), T2.Y(0)], [T2.X(1), T2.Y(dinf)]], C("--accent"), 1.5, [6, 4]);
  graph(ctx, T2, bump, 0, 1, C("--muted"), 1.3);
  const pts = [[T2.X(0), T2.Y(0)]];
  for (let i = 0; i <= 300; i++) { const x = i / 300; pts.push([T2.X(x), T2.Y(x * bump(x))]); }
  pts.push([T2.X(1), T2.Y(0)]);
  PP.path(ctx, pts, C("--seq2"), 2, null, true, C("--area2"));
  PP.label(ctx, "d∞", T2.X(0) + 4, T2.Y(dinf) - 3, C("--muted"), "left", "bottom", 11);
  PP.label(ctx, "x·d∞", T2.X(1) - 4, T2.Y(dinf) + 4, C("--accent"), "right", "top", 11);
  PP.read($id("ej2-read"), [
    ["d∞(f, g)", PP.fmt(dinf, 3)],
    ["d₁(Ψf, Ψg)", PP.fmt(d1, 4) + "  (área naranja)"],
    ["d∞(f, g)/2", PP.fmt(dinf / 2, 4) + "  (triángulo)"],
    ["d₁ ≤ d∞/2", d1 <= dinf / 2 + 1e-12 ? "sí" : "no", d1 <= dinf / 2 + 1e-12 ? "good" : "bad"],
  ]);
}, [$id("ej2-c"), $id("ej2-w")]);

PP.register(function drawDelta() {
  const eps = PP.val($id("ej2-eps")) / 100, r = PP.val($id("ej2-r")) / 100, delta = eps;
  PP.out($id("ej2-eps-o"), PP.fmt(eps, 2)); PP.out($id("ej2-r-o"), PP.fmt(r, 2));
  const hh = (x) => r * delta * Math.cos(3 * Math.PI * x);
  const g = (x) => f2(x) + hh(x);
  const dinf = r * delta, d1 = integrate((x) => x * Math.abs(hh(x)), 1200);
  const { ctx, w, h } = PP.canvas($id("ej2-c2"), 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.9, y1: 1.8 }, { l: 38 });
  PP.axes(ctx, T, { yTicks: 5 });
  clipBox(ctx, T);
  const up = [], lo = [];
  for (let i = 0; i <= 200; i++) { const x = i / 200; up.push([T.X(x), T.Y(f2(x) + delta)]); lo.push([T.X(x), T.Y(f2(x) - delta)]); }
  PP.path(ctx, up.concat(lo.slice().reverse()), null, 0, null, true, C("--band"));
  PP.path(ctx, up, C("--accent"), 1, [4, 4]); PP.path(ctx, lo, C("--accent"), 1, [4, 4]);
  graph(ctx, T, f2, 0, 1, C("--accent"), 2);
  const inside = r < 1;
  graph(ctx, T, g, 0, 1, inside ? C("--ok") : C("--fail"), 2);
  ctx.restore();
  PP.label(ctx, "f ± δ", T.X(0.02), T.Y(f2(0.02) + delta) - 4, C("--accent"), "left", "bottom", 12);
  PP.read($id("ej2-read2"), [
    ["δ = ε", PP.fmt(delta, 2)],
    ["d∞(f, g)", PP.fmt(dinf, 3) + (inside ? " < δ" : " ≥ δ"), inside ? "good" : "bad"],
    ["d₁(Ψf, Ψg)", PP.fmt(d1, 4)],
    ["ε/2", PP.fmt(eps / 2, 3)],
    ["conclusión", inside ? "d₁(Ψf, Ψg) < ε/2 < ε" : "fuera de la bola: (2) no da nada con este δ", inside ? "good" : ""],
  ]);
}, [$id("ej2-eps"), $id("ej2-r")]);

/* ---------- Ej. 3: X = [0, 1], f(x) = 4x(1 − x), A = (0.1, 0.3) ∪ (0.7, 0.9) ---------- */
const F3 = (x) => 4 * x * (1 - x);
const APIECES = [[0.1, 0.3], [0.7, 0.9]];
function frame3(id) {
  const { ctx, w, h } = PP.canvas(id, 0.72);
  const T = PP.frame(w, h, { x0: -0.16, x1: 1.04, y0: -0.1, y1: 1.1 }, { l: 36 });
  PP.axes(ctx, T, { xLabel: "X", yLabel: "Y", yTicks: 5 });
  graph(ctx, T, F3, 0, 1, C("--muted"), 1.6);
  return { ctx, T };
}
function bandX(ctx, T, a, b, color) { PP.path(ctx, [[T.X(a), T.Y(0)], [T.X(b), T.Y(0)]], color, 9); }
function bandY(ctx, T, a, b, color) { PP.path(ctx, [[T.X(0), T.Y(a)], [T.X(0), T.Y(b)]], color, 9); }
function drawSets(ctx, T, closed) {
  APIECES.forEach(([a, b]) => {
    bandX(ctx, T, a, b, C("--area"));
    endpoint(ctx, T.X(a), T.Y(0), closed, C("--accent")); endpoint(ctx, T.X(b), T.Y(0), closed, C("--accent"));
  });
  bandY(ctx, T, F3(0.1), F3(0.3), C("--area2"));
  endpoint(ctx, T.X(0), T.Y(F3(0.1)), closed, C("--seq2")); endpoint(ctx, T.X(0), T.Y(F3(0.3)), closed, C("--seq2"));
}
function guide(ctx, T, x, y, color) {
  PP.path(ctx, [[T.X(x), T.Y(0)], [T.X(x), T.Y(y)], [T.X(0), T.Y(y)]], color, 1, [4, 4]);
}

PP.register(function drawSeqClos() {
  const n = PP.val($id("ej3-n")); PP.out($id("ej3-n-o"), String(n));
  const a = (k) => 0.3 - 0.18 / (k + 1);
  const { ctx, T } = frame3($id("ej3-c1"));
  drawSets(ctx, T, false);
  const an = a(n);
  guide(ctx, T, an, F3(an), C("--muted"));
  for (let k = 1; k <= n; k++) {
    const last = k === n;
    PP.dot(ctx, T.X(a(k)), T.Y(0), last ? 4.5 : 2.6, C("--accent"));
    PP.dot(ctx, T.X(0), T.Y(F3(a(k))), last ? 4.5 : 2.6, C("--seq2"));
  }
  PP.circle(ctx, T.X(0.3), T.Y(0), 7.5, C("--ok"), null, null, 2);
  PP.circle(ctx, T.X(0), T.Y(0.84), 7.5, C("--ok"), null, null, 2);
  PP.label(ctx, "x", T.X(0.3), T.Y(0) - 11, C("--ok"), "center", "bottom", 13);
  PP.label(ctx, "y", T.X(0) - 11, T.Y(0.84), C("--ok"), "right", "middle", 13);
  PP.label(ctx, "aₙ", T.X(an), T.Y(0) + 9, C("--accent"), "center", "top", 12);
  PP.read($id("ej3-read1"), [
    ["aₙ", PP.fmt(an, 4)],
    ["d(aₙ, x)", PP.fmt(Math.abs(an - 0.3), 4)],
    ["f(aₙ)", PP.fmt(F3(an), 4)],
    ["d(f(aₙ), y)", PP.fmt(Math.abs(F3(an) - 0.84), 4)],
    ["x = 0.3", "∉ A, pero ∈ Ā"],
    ["y = 0.84", "∉ f(A), pero ∈ clausura de f(A)", "good"],
  ]);
}, [$id("ej3-n")]);

PP.register(function drawCompact() {
  const closed = PP.radio($id("ej3-modo")) === "C";
  const { ctx, T } = frame3($id("ej3-c2"));
  APIECES.forEach(([a, b]) => graph(ctx, T, F3, a, b, C("--accent"), 3));
  drawSets(ctx, T, closed);
  [0.1, 0.3].forEach((x) => PP.path(ctx, [[T.X(0), T.Y(F3(x))], [T.X(1 - x), T.Y(F3(x))]], C("--muted"), 1, [3, 4]));
  PP.label(ctx, "0.36", T.X(0) - 8, T.Y(0.36), C("--seq2"), "right", "middle", 11);
  PP.label(ctx, "0.84", T.X(0) - 8, T.Y(0.84), C("--seq2"), "right", "middle", 11);
  PP.label(ctx, closed ? "Ā" : "A", T.X(0.8), T.Y(0) - 10, C("--accent"), "center", "bottom", 13);
  PP.label(ctx, closed ? "f(Ā)" : "f(A)", T.X(0) + 9, T.Y(0.6), C("--seq2"), "left", "middle", 13);
  PP.read($id("ej3-read2"), closed ? [
    ["Ā", "[0.1, 0.3] ∪ [0.7, 0.9]  (cerrado en [0, 1])"],
    ["f(Ā)", "[0.36, 0.84]"],
    ["¿f(Ā) cerrado?", "sí", "good"],
    ["clausura de f(A)", "[0.36, 0.84] ⊆ f(Ā)", "good"],
  ] : [
    ["A", "(0.1, 0.3) ∪ (0.7, 0.9)"],
    ["f(A)", "(0.36, 0.84)"],
    ["¿f(A) cerrado?", "no: le faltan 0.36 y 0.84", "bad"],
  ]);
}, [`input[name="${ID}-ej3-modo"]`]);

PP.register(function drawSubseq() {
  const m = PP.val($id("ej3-m")); PP.out($id("ej3-m-o"), String(m));
  const showSub = document.getElementById($id("ej3-sub")).checked;
  const yk = (k) => 0.84 - 0.3 / (k + 1);
  const xl = (y) => (1 - Math.sqrt(1 - y)) / 2;
  const ak = (k) => (k % 2 ? xl(yk(k)) : 1 - xl(yk(k)));
  const { ctx, T } = frame3($id("ej3-c3"));
  drawSets(ctx, T, false);
  guide(ctx, T, ak(m), yk(m), C("--muted"));
  for (let k = 1; k <= m; k++) {
    const last = k === m, inSub = showSub && k % 2 === 0;
    PP.dot(ctx, T.X(0), T.Y(yk(k)), last ? 4.5 : 2.6, C("--seq2"));
    PP.dot(ctx, T.X(ak(k)), T.Y(0), last ? 4.5 : inSub ? 3.4 : 2.6, inSub ? C("--accent") : C("--muted"));
  }
  PP.circle(ctx, T.X(0), T.Y(0.84), 7.5, C("--ok"), null, null, 2);
  PP.label(ctx, "y", T.X(0) - 11, T.Y(0.84), C("--ok"), "right", "middle", 13);
  if (showSub) {
    PP.circle(ctx, T.X(0.7), T.Y(0), 7.5, C("--ok"), null, null, 2);
    PP.label(ctx, "x", T.X(0.7), T.Y(0) - 11, C("--ok"), "center", "bottom", 13);
  }
  PP.label(ctx, "aₙ", T.X(ak(m)), T.Y(0) + 9, m % 2 === 0 && showSub ? C("--accent") : C("--muted"), "center", "top", 12);
  PP.read($id("ej3-read3"), [
    ["yₙ", PP.fmt(yk(m), 4)],
    ["aₙ", PP.fmt(ak(m), 4) + (m % 2 ? "  (rama izquierda)" : "  (rama derecha)")],
    ["(aₙ)", "no converge: salta entre ≈ 0.3 y ≈ 0.7", "bad"],
    ["aₙₖ = a₂ₖ", "→ 0.7 = x ∈ Ā", "good"],
    ["f(x)", "0.84 = y", "good"],
  ]);
}, [$id("ej3-m"), $id("ej3-sub")]);

/* ---------- Ej. 4 ---------- */
PP.register(function drawBall() {
  const x = PP.val($id("ej4-x")) / 100, r = PP.val($id("ej4-r")) / 100;
  PP.out($id("ej4-x-o"), PP.fmt(x, 2)); PP.out($id("ej4-r-o"), PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas($id("ej4-c1"), 0.36);
  const T = PP.frame(w, h, { x0: -3.2, x1: 3.2, y0: 0, y1: 1 }, { l: 16, r: 16, t: 10, b: 10 });
  const yl = T.Y(0.42);
  PP.path(ctx, [[T.X(-3.2), yl], [T.X(3.2), yl]], C("--muted"), 1);
  for (let t = -3; t <= 3; t++) {
    PP.path(ctx, [[T.X(t), yl - 4], [T.X(t), yl + 4]], C("--muted"), 1);
    PP.label(ctx, minus(t), T.X(t), yl + 9, C("--muted"), "center", "top", 11);
  }
  const inner = r - Math.abs(x);
  if (inner > 0) {
    const a = Math.min(inner, 3.2);
    PP.path(ctx, [[T.X(-a), yl], [T.X(a), yl]], C("--area2"), 12);
    PP.path(ctx, [[T.X(-a), yl], [T.X(a), yl]], C("--seq2"), 2.5);
    if (inner < 3.2) { endpoint(ctx, T.X(-a), yl, false, C("--seq2")); endpoint(ctx, T.X(a), yl, false, C("--seq2")); }
  }
  PP.dot(ctx, T.X(x), yl, 5.5, C("--accent"));
  PP.label(ctx, "xₘ", T.X(x), yl - 12, C("--accent"), "center", "bottom", 13);
  PP.read($id("ej4-read1"), [
    ["|xₘ|", PP.fmt(Math.abs(x), 2)],
    ["ε − |xₘ|", PP.fmt(inner, 2)],
    ["d(xⱼ, xₘ) < ε ⇔", inner > 0 ? "xⱼ = xₘ  o  |xⱼ| < " + PP.fmt(inner, 2) : "xⱼ = xₘ", inner > 0 ? "" : "bad"],
  ]);
}, [$id("ej4-x"), $id("ej4-r")]);

const SEQ1 = [0.05, 1.1, -0.1, 0.9, 0.35, -0.4, 0.75].concat(Array(17).fill(0.6)); /* x₁ … x₂₄ */
const d4 = (a, b) => (a === b ? 0 : Math.abs(a) + Math.abs(b));
function nOf(eps) {
  for (let N = 1; N <= SEQ1.length; N++) {
    let ok = true;
    for (let j = N; j <= SEQ1.length && ok; j++) for (let m = N; m <= SEQ1.length; m++) if (d4(SEQ1[j - 1], SEQ1[m - 1]) >= eps) { ok = false; break; }
    if (ok) return N;
  }
  return SEQ1.length;
}
PP.register(function drawCaso1() {
  const e0 = PP.val($id("ej4-e0")) / 100; PP.out($id("ej4-e0-o"), PP.fmt(e0, 2));
  const S = []; SEQ1.forEach((v, i) => { if (Math.abs(v) >= e0) S.push(i + 1); });
  const N0 = nOf(e0), k0 = S.findIndex((nk) => nk >= N0) + 1, nk0 = S[k0 - 1], val = SEQ1[nk0 - 1];
  const { ctx, w, h } = PP.canvas($id("ej4-c2"), 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 25, y0: -0.6, y1: 1.3 }, { l: 36 });
  PP.rect(ctx, T.X(0), T.Y(e0), T.X(25) - T.X(0), T.Y(-e0) - T.Y(e0), null, C("--band"));
  PP.axes(ctx, T, { xLabel: "n", intX: true, yTicks: 5 });
  PP.path(ctx, [[T.X(0), T.Y(e0)], [T.X(25), T.Y(e0)]], C("--accent"), 1, [4, 4]);
  PP.path(ctx, [[T.X(0), T.Y(-e0)], [T.X(25), T.Y(-e0)]], C("--accent"), 1, [4, 4]);
  PP.path(ctx, [[T.X(N0), T.Y(-0.6)], [T.X(N0), T.Y(1.3)]], C("--muted"), 1.2, [5, 4]);
  PP.label(ctx, "n(ε₀)", T.X(N0) + 4, T.Y(1.3) + 2, C("--muted"), "left", "top", 11);
  PP.path(ctx, [[T.X(nk0), T.Y(val)], [T.X(24.6), T.Y(val)]], C("--ok"), 1.5, [3, 3]);
  SEQ1.forEach((v, i) => {
    const n = i + 1, inS = Math.abs(v) >= e0;
    PP.dot(ctx, T.X(n), T.Y(v), inS ? 4 : 3, inS ? C("--seq2") : C("--muted"));
  });
  PP.circle(ctx, T.X(nk0), T.Y(val), 8, C("--ok"), null, null, 2);
  PP.label(ctx, "ε₀", T.X(25) - 2, T.Y(e0) - 3, C("--accent"), "right", "bottom", 11);
  PP.read($id("ej4-read2"), [
    ["ε₀", PP.fmt(e0, 2)],
    ["nₖ  (|xₙ| ≥ ε₀)", S.slice(0, 7).join(", ") + ", …"],
    ["n(ε₀)", String(N0)],
    ["k₀ y nₖ₀", k0 + " y " + nk0],
    ["xₙₖ₀", PP.fmt(val, 2)],
    ["xₙₖ = xₙₖ₀ si k ≥ k₀", S.slice(k0 - 1).every((nk) => SEQ1[nk - 1] === val) ? "sí" : "no", "good"],
  ]);
}, [$id("ej4-e0")]);

const SEQ2 = Array.from({ length: 30 }, (_, i) => { const n = i + 1; return n % 4 === 0 ? 0 : (n % 2 ? -1 : 1) * 1.1 / n; });
PP.register(function drawCaso2() {
  const eps = PP.val($id("ej4-eps")) / 100; PP.out($id("ej4-eps-o"), PP.fmt(eps, 2));
  const dist = SEQ2.map((v) => d4(v, 0));
  let n0 = SEQ2.length;
  for (let N = 1; N <= SEQ2.length; N++) if (dist.slice(N - 1).every((d) => d < eps)) { n0 = N; break; }
  const mx = Math.max(...dist.slice(n0 - 1));
  const { ctx, w, h } = PP.canvas($id("ej4-c3"), 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 31, y0: -1.15, y1: 1.15 }, { l: 36 });
  PP.rect(ctx, T.X(0), T.Y(eps), T.X(31) - T.X(0), T.Y(0) - T.Y(eps), null, C("--okband"));
  PP.axes(ctx, T, { xLabel: "n", intX: true, yTicks: 4 });
  PP.path(ctx, [[T.X(0), T.Y(eps)], [T.X(31), T.Y(eps)]], C("--ok"), 1, [4, 4]);
  PP.path(ctx, [[T.X(n0), T.Y(-1.15)], [T.X(n0), T.Y(1.15)]], C("--ok"), 1.2, [5, 4]);
  PP.label(ctx, "n₀", T.X(n0) + 4, T.Y(1.15) + 2, C("--ok"), "left", "top", 11);
  PP.label(ctx, "ε", T.X(31) - 2, T.Y(eps) - 3, C("--ok"), "right", "bottom", 11);
  const bw = Math.max(2, (T.X(1) - T.X(0)) * 0.42);
  SEQ2.forEach((v, i) => {
    const n = i + 1;
    PP.dot(ctx, T.X(n), T.Y(v), 2.4, C("--muted"));
    if (dist[i] > 0) PP.rect(ctx, T.X(n) - bw / 2, T.Y(dist[i]), bw, T.Y(0) - T.Y(dist[i]), null, n >= n0 ? C("--ok") : C("--accent"));
  });
  PP.read($id("ej4-read3"), [
    ["ε", PP.fmt(eps, 2)],
    ["n₀", String(n0)],
    ["máx d(xₙ, 0), n ≥ n₀", PP.fmt(mx, 3) + " < ε", "good"],
    ["d(xₙ, 0) = 0", "en n = 4, 8, 12, … (xₙ = 0)"],
  ]);
}, [$id("ej4-eps")]);
