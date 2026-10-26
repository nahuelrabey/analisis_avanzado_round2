/* Dibujos de los ejemplos de la Práctica 3, primera parte (Bloques 1 y 2). Usa window.PP. */
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const F = (x, d) => PP.fmt(x, d === undefined ? 3 : d);
const FONT = "'IBM Plex Sans', system-ui, sans-serif";

/* Marco con la misma escala en x y en y, centrado verticalmente en yc. */
function eqFrame(w, h, x0, x1, yc, pad) {
  const p = Object.assign({ l: 12, r: 12, t: 12, b: 12 }, pad || {});
  const half = (x1 - x0) * (h - p.t - p.b) / (w - p.l - p.r) / 2;
  return PP.frame(w, h, { x0, x1, y0: yc - half, y1: yc + half }, p);
}

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
    try { redraw(); } catch (err) { console.error(err); }
  });
  const end = () => { active = null; cv.style.cursor = "grab"; };
  cv.addEventListener("pointerup", end);
  cv.addEventListener("pointercancel", end);
}
/* El punto más cercano (en píxeles) entre pts, si está a menos de tol. */
function nearest(pts, px, py, T, tol) {
  let best = null, bd = tol || 22;
  pts.forEach((q, i) => { const d = Math.hypot(T.X(q[0]) - px, T.Y(q[1]) - py); if (d < bd) { bd = d; best = i; } });
  return best;
}
/* Ejes cartesianos livianos (sin números) para dibujos en el plano. */
function planeAxes(ctx, T, labels) {
  const { box } = T;
  ctx.save(); ctx.strokeStyle = C("--muted"); ctx.lineWidth = 1;
  if (box.y0 < 0 && box.y1 > 0) { ctx.beginPath(); ctx.moveTo(T.X(box.x0), T.Y(0)); ctx.lineTo(T.X(box.x1), T.Y(0)); ctx.stroke(); }
  if (box.x0 < 0 && box.x1 > 0) { ctx.beginPath(); ctx.moveTo(T.X(0), T.Y(box.y0)); ctx.lineTo(T.X(0), T.Y(box.y1)); ctx.stroke(); }
  ctx.restore();
  if (labels !== false) {
    PP.label(ctx, "x", T.X(box.x1) - 4, T.Y(0) - 4, C("--muted"), "right", "bottom", 12);
    PP.label(ctx, "y", T.X(0) + 5, T.Y(box.y1) + 4, C("--muted"), "left", "top", 12);
  }
}
/* Punto con etiqueta. */
function pt(ctx, T, p, color, text, dx, dy, r) {
  PP.dot(ctx, T.X(p[0]), T.Y(p[1]), r || 5.5, color);
  if (text) PP.label(ctx, text, T.X(p[0]) + (dx === undefined ? 8 : dx), T.Y(p[1]) + (dy === undefined ? -6 : dy), color, (dx || 8) < 0 ? "right" : "left", "bottom", 13);
}
/* Normas de R^2 y bolas con su forma. */
const NORM = {
  "2": (v) => Math.hypot(v[0], v[1]),
  "1": (v) => Math.abs(v[0]) + Math.abs(v[1]),
  "inf": (v) => Math.max(Math.abs(v[0]), Math.abs(v[1])),
};
const MNAME = { "2": "d₂", "1": "d₁", "inf": "d∞" };
function ball(ctx, T, c, r, m, stroke, fill, dash, width) {
  const s = T.X(1) - T.X(0);
  if (m === "2") { PP.circle(ctx, T.X(c[0]), T.Y(c[1]), r * s, stroke, fill, dash, width); return; }
  const pts = m === "1"
    ? [[c[0] + r, c[1]], [c[0], c[1] + r], [c[0] - r, c[1]], [c[0], c[1] - r]]
    : [[c[0] + r, c[1] + r], [c[0] - r, c[1] + r], [c[0] - r, c[1] - r], [c[0] + r, c[1] - r]];
  const px = pts.map((q) => [T.X(q[0]), T.Y(q[1])]);
  if (fill) PP.path(ctx, px, null, 0, null, true, fill);
  if (stroke) PP.path(ctx, px, stroke, width || 1.5, dash, true);
}
/* Escala v para que su norma no pase de lim. */
function capNorm(v, m, lim) {
  const n = NORM[m](v);
  return n > lim && n > 0 ? [v[0] * lim / n, v[1] * lim / n] : v;
}
/* Una curva y = fn(x) muestreada en [a, b]. */
function curve(T, fn, a, b, N) {
  const n = N || 240, out = [];
  for (let i = 0; i <= n; i++) { const x = a + (b - a) * i / n; out.push([T.X(x), T.Y(fn(x))]); }
  return out;
}
/* Recta real horizontal con marcas. */
function realLine(ctx, T, y, ticks) {
  const { box } = T;
  PP.path(ctx, [[T.X(box.x0), T.Y(y)], [T.X(box.x1), T.Y(y)]], C("--muted"), 1.2);
  PP.label(ctx, "ℝ", T.X(box.x1) - 2, T.Y(y) - 4, C("--muted"), "right", "bottom", 12);
  (ticks || []).forEach(([v, txt]) => {
    PP.path(ctx, [[T.X(v), T.Y(y) - 5], [T.X(v), T.Y(y) + 5]], C("--ink"), 1.2);
    PP.label(ctx, txt, T.X(v), T.Y(y) + 8, C("--ink"), "center", "top", 12);
  });
}
/* Intervalo abierto (a, b) dibujado a la altura y, con extremos huecos. */
function openInterval(ctx, T, a, b, y, color, width) {
  PP.path(ctx, [[T.X(a), T.Y(y)], [T.X(b), T.Y(y)]], color, width || 4);
  [a, b].forEach((v) => PP.circle(ctx, T.X(v), T.Y(y), 4.5, color, C("--bg"), null, 2));
}

/* ===================== C3-6 · métrica del peine ===================== */
const PEINE = { P: [[-2, 1.5], [2, 2], [0.5, -1]], T: null };
const peineD = (A, B) => (A[0] === B[0] ? Math.abs(A[1] - B[1]) : Math.abs(A[0] - B[0]) + Math.abs(A[1]) + Math.abs(B[1]));
const peinePath = (T, A, B) => (A[0] === B[0]
  ? [[T.X(A[0]), T.Y(A[1])], [T.X(B[0]), T.Y(B[1])]]
  : [[T.X(A[0]), T.Y(A[1])], [T.X(A[0]), T.Y(0)], [T.X(B[0]), T.Y(0)], [T.X(B[0]), T.Y(B[1])]]);
function drawPeine() {
  const { ctx, w, h } = PP.canvas("ejp3-c36-cv", 0.72);
  const T = eqFrame(w, h, -4.3, 4.3, 0.4);
  PEINE.T = T;
  // dientes del peine: rectas verticales en las abscisas enteras
  for (let k = -4; k <= 4; k++) PP.path(ctx, [[T.X(k), T.Y(T.box.y0)], [T.X(k), T.Y(T.box.y1)]], C("--rule"), 1);
  planeAxes(ctx, T);
  const [P, Q, R] = PEINE.P;
  const off = (pts) => pts.map(([a, b]) => [a + 4, b + 4]); // corrido para que no tape al camino azul
  PP.path(ctx, off(peinePath(T, P, R)), C("--seq2"), 3, [7, 5]);
  PP.path(ctx, off(peinePath(T, R, Q)), C("--seq2"), 3, [7, 5]);
  PP.path(ctx, peinePath(T, P, Q), C("--accent"), 2.5);
  pt(ctx, T, P, C("--accent"), "(x, y)");
  pt(ctx, T, Q, C("--accent"), "(x′, y′)");
  pt(ctx, T, R, C("--seq2"), "(x″, y″)", 8, 18);
  const x = P[0], x1 = Q[0], x2 = R[0];
  let caso;
  if (x === x1 && x1 === x2) caso = "x = x′ = x″";
  else if (x === x1) caso = "x = x′ ≠ x″";
  else if (x2 === x) caso = "x″ = x ≠ x′";
  else if (x2 === x1) caso = "x″ = x′ ≠ x";
  else caso = "x, x′, x″ distintas";
  const L = peineD(P, Q), a = peineD(P, R), b = peineD(R, Q);
  PP.read("ejp3-c36-read", [
    ["caso", caso],
    ["d((x,y),(x′,y′))", F(L, 2)],
    ["pasando por (x″,y″)", F(a, 2) + " + " + F(b, 2) + " = " + F(a + b, 2)],
    ["¿desigualdad triangular?", L <= a + b + 1e-9 ? "sí" : "no", L <= a + b + 1e-9 ? "good" : "bad"],
  ]);
}
PP.register(drawPeine, []);
draggable("ejp3-c36-cv", () => PEINE.T, (px, py, T) => nearest(PEINE.P, px, py, T), (i, x, y, T) => {
  PEINE.P[i] = [clamp(Math.round(x * 2) / 2, -4, 4), clamp(Math.round(y * 10) / 10, T.box.y0 + 0.2, T.box.y1 - 0.3)];
}, drawPeine);

/* ===================== C3-7 · métrica C¹ ===================== */
PP.register(function drawC1() {
  const k = PP.val("ejp3-c37-k");
  PP.out("ejp3-c37-k-o", String(k));
  const { ctx, w, h } = PP.canvas("ejp3-c37-cv", 0.95);
  const f = (x) => 0.5 + 0.3 * Math.sin(2 * Math.PI * x);
  const g = (x) => f(x) + 0.4 * Math.sin(k * Math.PI * x) / k;
  const df = (x) => 0.6 * Math.PI * Math.cos(2 * Math.PI * x);
  const dg = (x) => df(x) + 0.4 * Math.PI * Math.cos(k * Math.PI * x);
  const mid = h / 2;
  const T1 = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.25, y1: 1.25 }, { l: 40, r: 14, t: 12, b: h - mid + 16 });
  const T2 = PP.frame(w, h, { x0: 0, x1: 1, y0: -3.4, y1: 3.4 }, { l: 40, r: 14, t: mid + 12, b: 24 });
  PP.axes(ctx, T1, { yTicks: 3, xTicks: 4 });
  PP.axes(ctx, T2, { yTicks: 3, xTicks: 4 });
  const supOf = (u, v) => { let best = 0, xb = 0; for (let i = 0; i <= 600; i++) { const x = i / 600, d = Math.abs(u(x) - v(x)); if (d > best) { best = d; xb = x; } } return [best, xb]; };
  const [s0, x0] = supOf(f, g), [s1, x1] = supOf(df, dg);
  PP.path(ctx, curve(T1, f, 0, 1), C("--accent"), 2.2);
  PP.path(ctx, curve(T1, g, 0, 1, 500), C("--seq2"), 2);
  PP.path(ctx, [[T1.X(x0), T1.Y(f(x0))], [T1.X(x0), T1.Y(g(x0))]], C("--ink"), 2.5);
  PP.path(ctx, curve(T2, df, 0, 1), C("--accent"), 2.2);
  PP.path(ctx, curve(T2, dg, 0, 1, 500), C("--seq2"), 2);
  PP.path(ctx, [[T2.X(x1), T2.Y(df(x1))], [T2.X(x1), T2.Y(dg(x1))]], C("--ink"), 2.5);
  PP.label(ctx, "f y g", (T1.p.l + w - T1.p.r) / 2, T1.p.t, C("--ink"), "center", "top", 12);
  PP.label(ctx, "f′ y g′", (T2.p.l + w - T2.p.r) / 2, T2.p.t - 2, C("--ink"), "center", "top", 12);
  PP.label(ctx, "f", w - 16, T1.Y(f(1)) - 4, C("--accent"), "right", "bottom", 12);
  PP.label(ctx, "g", w - 16, T1.Y(g(1)) + 4, C("--seq2"), "right", "top", 12);
  PP.read("ejp3-c37-read", [
    ["k", String(k)],
    ["sup |f − g|", "≈ " + F(s0, 3)],
    ["sup |f′ − g′|", "≈ " + F(s1, 3)],
    ["d(f, g)", "≈ " + F(s0 + s1, 3)],
  ]);
}, ["ejp3-c37-k"]);

/* ===================== C3-8 · truncar una métrica ===================== */
const TRUNC = { p: [0, 0.6, 1.2], T: null }; // x, z, y (valores elegidos)
const TNAME = ["x", "z", "y"];
function drawTrunc() {
  const { ctx, w, h } = PP.canvas("ejp3-c38-cv", 0.6);
  const T = PP.frame(w, h, { x0: -0.35, x1: 2.75, y0: 0, y1: 4 }, { l: 14, r: 14, t: 10, b: 10 });
  TRUNC.T = T;
  const [x, z, y] = TRUNC.p;
  realLine(ctx, T, 0.7, []);
  // regla de longitud 1
  PP.path(ctx, [[T.X(1.6), T.Y(0.18)], [T.X(2.6), T.Y(0.18)]], C("--ink"), 2);
  PP.label(ctx, "longitud 1", T.X(2.1), T.Y(0.18) - 4, C("--muted"), "center", "bottom", 11);
  const bar = (a, b, lev, color, band, name) => {
    const lo = Math.min(a, b), hi = Math.max(a, b), d = hi - lo, cut = Math.min(1, d);
    PP.rect(ctx, T.X(lo), T.Y(lev + 0.22), T.X(lo + cut) - T.X(lo), T.Y(lev - 0.22) - T.Y(lev + 0.22), null, band);
    PP.path(ctx, [[T.X(lo), T.Y(lev)], [T.X(hi), T.Y(lev)]], color, 2);
    PP.path(ctx, [[T.X(lo), T.Y(lev) - 6], [T.X(lo), T.Y(lev) + 6]], color, 2);
    PP.path(ctx, [[T.X(hi), T.Y(lev) - 6], [T.X(hi), T.Y(lev) + 6]], color, 2);
    if (d > 1) PP.path(ctx, [[T.X(lo + 1), T.Y(lev) - 8], [T.X(lo + 1), T.Y(lev) + 8]], C("--ink"), 1.5, [3, 2]);
    PP.label(ctx, name + " = " + F(d, 2) + (d > 1 ? "  → d′ = 1" : ""), T.X(lo), T.Y(lev + 0.28), color, "left", "bottom", 12);
  };
  bar(x, y, 1.6, C("--accent"), C("--area"), "d(x, y)");
  bar(x, z, 2.55, C("--seq2"), C("--area2"), "d(x, z)");
  bar(z, y, 3.45, C("--seq2"), C("--area2"), "d(z, y)");
  TRUNC.p.forEach((v, i) => {
    PP.dot(ctx, T.X(v), T.Y(0.7), 6, i === 1 ? C("--seq2") : C("--accent"));
    PP.label(ctx, TNAME[i], T.X(v), T.Y(0.7) + 9, C("--ink"), "center", "top", 13);
  });
  const dxy = Math.abs(x - y), dxz = Math.abs(x - z), dzy = Math.abs(z - y);
  const m = (t) => Math.min(1, t);
  let sub;
  if (dxy >= 1) sub = dxz >= 1 || dzy >= 1 ? "Caso 1, algún término de la derecha vale 1" : "Caso 1, ninguno llega a 1 (el que olvida el manuscrito)";
  else sub = dxz >= 1 || dzy >= 1 ? "Caso 2, algún término de la derecha vale 1" : "Caso 2, los dos mínimos son los valores";
  const ok = m(dxy) <= m(dxz) + m(dzy) + 1e-9;
  PP.read("ejp3-c38-read", [
    ["caso", sub],
    ["d′(x, y)", F(m(dxy), 2)],
    ["d′(x, z) + d′(z, y)", F(m(dxz), 2) + " + " + F(m(dzy), 2) + " = " + F(m(dxz) + m(dzy), 2)],
    ["¿(⋆)?", ok ? "sí" : "no", ok ? "good" : "bad"],
  ]);
}
PP.register(drawTrunc, []);
draggable("ejp3-c38-cv", () => TRUNC.T, (px, py, T) => {
  let best = null, bd = 24;
  TRUNC.p.forEach((v, i) => { const d = Math.abs(T.X(v) - px) + 0.3 * Math.abs(T.Y(0.7) - py); if (d < bd) { bd = d; best = i; } });
  return best;
}, (i, x) => { TRUNC.p[i] = clamp(Math.round(x * 20) / 20, -0.3, 2.7); }, drawTrunc);

/* ===================== 17 · distancia del máximo ===================== */
const MAXD = { P: [[0.8, 0.8], [2.6, 3.2], [4.6, 1.6]], T: null }; // x, y, z
function drawMax() {
  const { ctx, w, h } = PP.canvas("ejp3-17-cv", 0.72);
  const T = eqFrame(w, h, -0.6, 5.6, 2);
  MAXD.T = T;
  for (let k = 0; k <= 5; k++) {
    PP.path(ctx, [[T.X(k), T.Y(T.box.y0)], [T.X(k), T.Y(T.box.y1)]], C("--rule"), 1);
    if (k <= 4) PP.path(ctx, [[T.X(T.box.x0), T.Y(k)], [T.X(T.box.x1), T.Y(k)]], C("--rule"), 1);
  }
  planeAxes(ctx, T, false);
  const [X, Y, Z] = MAXD.P;
  const legs = (A, B, color, thick, dash) => {
    const hx = Math.abs(A[0] - B[0]), hy = Math.abs(A[1] - B[1]);
    PP.path(ctx, [[T.X(A[0]), T.Y(A[1])], [T.X(B[0]), T.Y(A[1])]], color, thick && hx >= hy ? 4 : 1.6, dash);
    PP.path(ctx, [[T.X(B[0]), T.Y(A[1])], [T.X(B[0]), T.Y(B[1])]], color, thick && hy > hx ? 4 : 1.6, dash);
  };
  legs(X, Y, C("--seq2"), false, [5, 4]);
  legs(Y, Z, C("--seq2"), false, [5, 4]);
  legs(X, Z, C("--accent"), true);
  pt(ctx, T, X, C("--accent"), "x", -8, -6);
  pt(ctx, T, Y, C("--seq2"), "y");
  pt(ctx, T, Z, C("--accent"), "z");
  const dm = (A, B) => Math.max(Math.abs(A[0] - B[0]), Math.abs(A[1] - B[1]));
  const dxy = dm(X, Y), dyz = dm(Y, Z), dxz = dm(X, Z);
  const row = (i) => {
    const a = Math.abs(X[i] - Y[i]), b = Math.abs(Y[i] - Z[i]), c = Math.abs(X[i] - Z[i]);
    return [`i = ${i + 1}`, `|x${i ? "₂" : "₁"} − z${i ? "₂" : "₁"}| = ${F(c, 2)} ≤ ${F(a, 2)} + ${F(b, 2)} ≤ ${F(dxy + dyz, 2)}`];
  };
  PP.read("ejp3-17-read", [
    row(0), row(1),
    ["d∞(x, y) + d∞(y, z)", F(dxy, 2) + " + " + F(dyz, 2) + " = " + F(dxy + dyz, 2)],
    ["d∞(x, z)", F(dxz, 2) + " ≤ " + F(dxy + dyz, 2), "good"],
  ]);
}
PP.register(drawMax, []);
draggable("ejp3-17-cv", () => MAXD.T, (px, py, T) => nearest(MAXD.P, px, py, T), (i, x, y, T) => {
  MAXD.P[i] = [clamp(Math.round(x * 10) / 10, -0.4, 5.4), clamp(Math.round(y * 10) / 10, T.box.y0 + 0.2, T.box.y1 - 0.2)];
}, drawMax);

/* ===================== 18 · bolas unitarias ===================== */
const BOLAS = { p: [0.6, 0.55], T: null };
const MCOL = { "2": "--accent", "1": "--seq3", "inf": "--seq2" };
const MAREA = { "2": "--area", "1": "--area3", "inf": "--area2" };
function drawBolas() {
  const m = PP.radio("ejp3-18-m") || "2";
  const { ctx, w, h } = PP.canvas("ejp3-18-cv", 0.8);
  const T = eqFrame(w, h, -1.9, 1.9, 0);
  BOLAS.T = T;
  ball(ctx, T, [0, 0], 1, m, C(MCOL[m]), C(MAREA[m]), [6, 4], 2);
  planeAxes(ctx, T);
  [[1, 0], [-1, 0], [0, 1], [0, -1]].forEach(([a, b]) => {
    PP.dot(ctx, T.X(a), T.Y(b), 2.5, C("--ink"));
  });
  PP.label(ctx, "1", T.X(1) + 4, T.Y(0) + 4, C("--muted"), "left", "top", 11);
  PP.label(ctx, "1", T.X(0) + 5, T.Y(1) - 2, C("--muted"), "left", "bottom", 11);
  PP.label(ctx, "B((0,0), 1) con " + MNAME[m], T.X(-1.85), T.Y(1.0 + (T.box.y1 - 1) * 0.7), C(MCOL[m]), "left", "middle", 12);
  const p = BOLAS.p, n = (k) => NORM[k](p);
  const inside = n(m) < 1;
  PP.dot(ctx, T.X(p[0]), T.Y(p[1]), 6, inside ? C("--ok") : C("--fail"));
  PP.label(ctx, "p", T.X(p[0]) + 8, T.Y(p[1]) - 4, C("--ink"), "left", "bottom", 13);
  const yn = (k) => (n(k) < 1 ? "∈ B" : "∉ B");
  PP.read("ejp3-18-read", [
    ["p", "(" + F(p[0], 2) + ", " + F(p[1], 2) + ")"],
    ["d₂(p, 0)", F(n("2"), 3) + "  " + yn("2"), m === "2" ? (n("2") < 1 ? "good" : "bad") : ""],
    ["d₁(p, 0)", F(n("1"), 3) + "  " + yn("1"), m === "1" ? (n("1") < 1 ? "good" : "bad") : ""],
    ["d∞(p, 0)", F(n("inf"), 3) + "  " + yn("inf"), m === "inf" ? (n("inf") < 1 ? "good" : "bad") : ""],
  ]);
}
PP.register(drawBolas, ["input[name='ejp3-18-m']"]);
draggable("ejp3-18-cv", () => BOLAS.T, (px, py, T) => nearest([BOLAS.p], px, py, T, 30), (i, x, y, T) => {
  BOLAS.p = [clamp(Math.round(x * 100) / 100, -1.8, 1.8), clamp(Math.round(y * 100) / 100, T.box.y0 + 0.05, T.box.y1 - 0.05)];
}, drawBolas);

/* ===================== 19 · banda funcional ===================== */
PP.register(function drawBanda() {
  const A = PP.val("ejp3-19-A") / 100;
  PP.out("ejp3-19-A-o", F(A, 2));
  const { ctx, w, h } = PP.canvas("ejp3-19-cv", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 8.6, y0: -0.2, y1: 5.3 }, { l: 10, r: 44, t: 10, b: 26 });
  const xa = 0.8, xb = 7.6, x0 = 5.0;
  const f = (x) => 2.7 + 0.5 * Math.sin(0.9 * x);
  const g = (x) => f(x) + A * Math.sin(2.3 * x + 0.5);
  const hh = (x) => f(x) - 0.35 + 2.1 * Math.exp(-Math.pow(x - x0, 2) / 0.5);
  const up = curve(T, (x) => f(x) + 1, xa, xb), dn = curve(T, (x) => f(x) - 1, xa, xb);
  PP.path(ctx, up.concat(dn.slice().reverse()), null, 0, null, true, C("--band"));
  PP.path(ctx, up, C("--accent"), 1.2, [5, 4]);
  PP.path(ctx, dn, C("--accent"), 1.2, [5, 4]);
  // ejes
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(8.6), T.Y(0)]], C("--muted"), 1.2);
  PP.path(ctx, [[T.X(0.3), T.Y(-0.2)], [T.X(0.3), T.Y(5.2)]], C("--muted"), 1.2);
  [[xa, "a"], [xb, "b"]].forEach(([x, t]) => {
    PP.path(ctx, [[T.X(x), T.Y(0) - 4], [T.X(x), T.Y(0) + 4]], C("--ink"), 1.2);
    PP.label(ctx, t, T.X(x), T.Y(0) + 6, C("--ink"), "center", "top", 12);
    PP.path(ctx, [[T.X(x), T.Y(0)], [T.X(x), T.Y(f(x) - 1)]], C("--rule"), 1, [2, 3]);
  });
  PP.path(ctx, curve(T, f, xa, xb), C("--accent"), 2.6);
  // h y x0
  PP.path(ctx, [[T.X(x0), T.Y(0)], [T.X(x0), T.Y(hh(x0))]], C("--fail"), 1, [2, 3]);
  PP.label(ctx, "x₀", T.X(x0), T.Y(0) + 6, C("--fail"), "center", "top", 12);
  PP.path(ctx, curve(T, hh, xa, xb), C("--fail"), 2);
  PP.dot(ctx, T.X(x0), T.Y(hh(x0)), 4.5, C("--fail"));
  PP.dot(ctx, T.X(x0), T.Y(f(x0)), 4, C("--accent"));
  // g y su mayor separación
  let best = 0, xbst = xa;
  for (let i = 0; i <= 800; i++) { const x = xa + (xb - xa) * i / 800, d = Math.abs(g(x) - f(x)); if (d > best) { best = d; xbst = x; } }
  const inB = best < 1;
  PP.path(ctx, curve(T, g, xa, xb, 400), inB ? C("--ok") : C("--fail"), 2);
  PP.path(ctx, [[T.X(xbst), T.Y(f(xbst))], [T.X(xbst), T.Y(g(xbst))]], C("--ink"), 2);
  PP.label(ctx, "g", T.X(3.2), T.Y(g(3.2) + 0.3), inB ? C("--ok") : C("--fail"), "center", "bottom", 13);
  PP.label(ctx, "h", T.X(x0 + 0.35), T.Y(hh(x0 + 0.35) + 0.15), C("--fail"), "left", "bottom", 13);
  PP.label(ctx, "f + 1", T.X(xb) + 4, T.Y(f(xb) + 1), C("--accent"), "left", "middle", 11);
  PP.label(ctx, "f", T.X(xb) + 4, T.Y(f(xb)), C("--accent"), "left", "middle", 12);
  PP.label(ctx, "f − 1", T.X(xb) + 4, T.Y(f(xb) - 1), C("--accent"), "left", "middle", 11);
  PP.read("ejp3-19-read", [
    ["A", F(A, 2)],
    ["sup |f − g|", "≈ " + F(best, 3) + " (en x ≈ " + F(xbst, 2) + ")"],
    ["g ∈ B(f, 1)", inB ? "sí" : "no", inB ? "good" : "bad"],
    ["|f(x₀) − h(x₀)|", "1.75 ≥ 1, así que h ∉ B(f, 1)", "bad"],
  ]);
}, ["ejp3-19-A"]);

/* ===================== guía-1 · d∞ y d₁ ===================== */
PP.register(function drawPico() {
  const eps = PP.val("ejp3-g1-eps") / 100, del = PP.val("ejp3-g1-del") / 100;
  PP.out("ejp3-g1-eps-o", F(eps, 2));
  PP.out("ejp3-g1-del-o", F(del, 2));
  const { ctx, w, h } = PP.canvas("ejp3-g1-cv1", 0.66);
  const T = PP.frame(w, h, { x0: -0.08, x1: 1.12, y0: -1.75, y1: 3.3 }, { l: 34, r: 12, t: 10, b: 12 });
  const c = 0.6, wd = Math.min(0.9 * del / eps, 0.76);
  PP.rect(ctx, T.X(0), T.Y(eps), T.X(1) - T.X(0), T.Y(-eps) - T.Y(eps), null, C("--band"));
  PP.path(ctx, [[T.X(0), T.Y(eps)], [T.X(1), T.Y(eps)]], C("--accent"), 1.2, [5, 4]);
  PP.path(ctx, [[T.X(0), T.Y(-eps)], [T.X(1), T.Y(-eps)]], C("--accent"), 1.2, [5, 4]);
  // ejes
  PP.path(ctx, [[T.X(-0.06), T.Y(0)], [T.X(1.1), T.Y(0)]], C("--muted"), 1);
  PP.path(ctx, [[T.X(-0.03), T.Y(-1.7)], [T.X(-0.03), T.Y(3.25)]], C("--muted"), 1);
  [[eps, "ε"], [2 * eps, "2ε"], [-eps, "−ε"]].forEach(([y, t]) => {
    PP.path(ctx, [[T.X(-0.03) - 4, T.Y(y)], [T.X(-0.03) + 4, T.Y(y)]], C("--ink"), 1.2);
    PP.label(ctx, t, T.X(-0.03) - 6, T.Y(y), C("--ink"), "right", "middle", 12);
  });
  [[0, "a"], [1, "b"]].forEach(([x, t]) => {
    PP.path(ctx, [[T.X(x), T.Y(0) - 4], [T.X(x), T.Y(0) + 4]], C("--ink"), 1.2);
    PP.label(ctx, t, T.X(x) - 4, T.Y(0) + 5, C("--ink"), "right", "top", 12);
  });
  const pico = [[T.X(c - wd / 2), T.Y(0)], [T.X(c), T.Y(2 * eps)], [T.X(c + wd / 2), T.Y(0)]];
  PP.path(ctx, pico, null, 0, null, true, C("--failband"));
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(0)]], C("--accent"), 2, [6, 4]);
  PP.path(ctx, [[T.X(0), T.Y(0)]].concat(pico, [[T.X(1), T.Y(0)]]), C("--fail"), 2.4);
  PP.path(ctx, [[T.X(-0.03), T.Y(2 * eps)], [T.X(c), T.Y(2 * eps)]], C("--rule"), 1, [2, 3]);
  // base del pico
  const yb = -0.45;
  PP.path(ctx, [[T.X(c - wd / 2), T.Y(yb)], [T.X(c + wd / 2), T.Y(yb)]], C("--ink"), 1.2);
  PP.path(ctx, [[T.X(c - wd / 2), T.Y(yb) - 4], [T.X(c - wd / 2), T.Y(yb) + 4]], C("--ink"), 1.2);
  PP.path(ctx, [[T.X(c + wd / 2), T.Y(yb) - 4], [T.X(c + wd / 2), T.Y(yb) + 4]], C("--ink"), 1.2);
  PP.label(ctx, "w", T.X(c), T.Y(yb) + 4, C("--ink"), "center", "top", 12);
  PP.label(ctx, "g", T.X(c) + 8, T.Y(2 * eps), C("--fail"), "left", "middle", 13);
  PP.label(ctx, "B∞(f, ε)", T.X(0.05), T.Y(eps) - 3, C("--accent"), "left", "bottom", 12);
  PP.label(ctx, "f = 0", T.X(0.05), T.Y(0) + 4, C("--accent"), "left", "top", 12);
  const area = wd * eps;
  PP.read("ejp3-g1-read1", [
    ["w", F(wd, 3) + " < δ/ε = " + F(del / eps, 3)],
    ["d₁(f, g) = área = wε", F(area, 3) + " < δ = " + F(del, 2), "good"],
    ["d∞(f, g) = 2ε", F(2 * eps, 2) + " ≥ ε = " + F(eps, 2), "bad"],
    ["g ∈ B₁(f, δ), g ∉ B∞(f, ε)", "sí"],
  ]);
}, ["ejp3-g1-eps", "ejp3-g1-del"]);

PP.register(function drawBandaD1() {
  const eps = PP.val("ejp3-g1-eps2") / 100;
  PP.out("ejp3-g1-eps2-o", F(eps, 2));
  const a = 0, b = 2, del = eps / (b - a);
  const { ctx, w, h } = PP.canvas("ejp3-g1-cv2", 0.62);
  const T = PP.frame(w, h, { x0: -0.05, x1: 2.05, y0: 0, y1: 2 }, { l: 40, r: 12, t: 10, b: 26 });
  PP.axes(ctx, T, { xTicks: 4, yTicks: 4 });
  const f = (x) => 1 + 0.4 * Math.sin(2 * x);
  const g = (x) => f(x) + 0.9 * del * Math.sin(5 * x + 1);
  const up = curve(T, (x) => f(x) + del, a, b), dn = curve(T, (x) => f(x) - del, a, b);
  PP.path(ctx, up.concat(dn.slice().reverse()), null, 0, null, true, C("--band"));
  PP.path(ctx, up, C("--accent"), 1.2, [5, 4]);
  PP.path(ctx, dn, C("--accent"), 1.2, [5, 4]);
  const gf = curve(T, f, a, b, 300), gg = curve(T, g, a, b, 300);
  PP.path(ctx, gf.concat(gg.slice().reverse()), null, 0, null, true, C("--area2"));
  PP.path(ctx, gf, C("--accent"), 2.4);
  PP.path(ctx, gg, C("--ok"), 2);
  PP.label(ctx, "f", T.X(0.02), T.Y(f(0.02)) - 6, C("--accent"), "left", "bottom", 13);
  PP.label(ctx, "g", T.X(0.25), T.Y(g(0.25)) - 6, C("--ok"), "center", "bottom", 13);
  let sup = 0, d1 = 0;
  const N = 2000;
  for (let i = 0; i <= N; i++) { const x = a + (b - a) * i / N, d = Math.abs(f(x) - g(x)); sup = Math.max(sup, d); if (i < N) d1 += d * (b - a) / N; }
  PP.read("ejp3-g1-read2", [
    ["δ = ε/(b − a)", F(del, 3)],
    ["d∞(f, g)", "≈ " + F(sup, 3) + " < δ"],
    ["d₁(f, g)", "≈ " + F(d1, 3)],
    ["d∞(f, g)·(b − a)", "≈ " + F(sup * (b - a), 3) + " < ε = " + F(eps, 2), "good"],
  ]);
}, ["ejp3-g1-eps2"]);

/* ===================== 20 · interior de [0, 1] ===================== */
PP.register(function drawIntervalo() {
  const x = PP.val("ejp3-20-x") / 100;
  PP.out("ejp3-20-x-o", F(x, 2));
  const { ctx, w, h } = PP.canvas("ejp3-20-cv1", 0.36);
  const T = PP.frame(w, h, { x0: -0.15, x1: 1.15, y0: -1.1, y1: 1 }, { l: 12, r: 12, t: 8, b: 8 });
  const r = Math.min(x, 1 - x);
  realLine(ctx, T, 0, [[0, "0"], [1, "1"]]);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(0)]], C("--accent"), 5);
  // bola
  openInterval(ctx, T, x - r, x + r, 0.55, C("--seq2"), 3);
  PP.label(ctx, "B(x, r)", T.X(x), T.Y(0.55) - 8, C("--seq2"), "center", "bottom", 12);
  PP.dot(ctx, T.X(x), T.Y(0), 5.5, C("--ink"));
  PP.label(ctx, "x", T.X(x), T.Y(0) - 8, C("--ink"), "center", "bottom", 13);
  // distancias a los extremos
  const yb = -0.6;
  const seg = (u, v, txt, on) => {
    const col = on ? C("--seq2") : C("--muted");
    PP.path(ctx, [[T.X(u), T.Y(yb)], [T.X(v), T.Y(yb)]], col, on ? 2.5 : 1.3);
    [u, v].forEach((s) => PP.path(ctx, [[T.X(s), T.Y(yb) - 5], [T.X(s), T.Y(yb) + 5]], col, 1.3));
    PP.label(ctx, txt, T.X((u + v) / 2), T.Y(yb) + 7, col, "center", "top", 12);
  };
  seg(0, x, "x", x <= 1 - x);
  seg(x, 1, "1 − x", 1 - x < x);
  PP.read("ejp3-20-read1", [
    ["x, 1 − x", F(x, 2) + ", " + F(1 - x, 2)],
    ["r = mín(x, 1 − x)", F(r, 2)],
    ["B(x, r)", "(" + F(x - r, 2) + ", " + F(x + r, 2) + ") ⊆ [0, 1]", "good"],
  ]);
}, ["ejp3-20-x"]);

PP.register(function drawExtremos() {
  const r = PP.val("ejp3-20-r") / 100;
  PP.out("ejp3-20-r-o", F(r, 2));
  const { ctx, w, h } = PP.canvas("ejp3-20-cv2", 0.36);
  const T = PP.frame(w, h, { x0: -0.62, x1: 1.62, y0: -0.8, y1: 1 }, { l: 12, r: 12, t: 8, b: 8 });
  realLine(ctx, T, 0, [[0, "0"], [1, "1"]]);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(0)]], C("--accent"), 5);
  PP.label(ctx, "E", T.X(0.5), T.Y(0) - 6, C("--accent"), "center", "bottom", 13);
  openInterval(ctx, T, -r, r, 0.55, C("--seq2"), 3);
  openInterval(ctx, T, 1 - r, 1 + r, 0.55, C("--seq2"), 3);
  PP.label(ctx, "B(0, r)", T.X(0), T.Y(0.55) - 8, C("--seq2"), "center", "bottom", 12);
  PP.label(ctx, "B(1, r)", T.X(1), T.Y(0.55) - 8, C("--seq2"), "center", "bottom", 12);
  PP.dot(ctx, T.X(-r / 2), T.Y(0.55), 4.5, C("--fail"));
  PP.dot(ctx, T.X(1 + r / 2), T.Y(0.55), 4.5, C("--fail"));
  PP.read("ejp3-20-read2", [
    ["r", F(r, 2)],
    ["−r/2 ∈ B(0, r) ∖ E", F(-r / 2, 3), "bad"],
    ["1 + r/2 ∈ B(1, r) ∖ E", F(1 + r / 2, 3), "bad"],
  ]);
}, ["ejp3-20-r"]);

/* ===================== 20 (b) · interior de ℚ ===================== */
function gcd(a, b) { a = Math.abs(a); b = Math.abs(b); while (b) { [a, b] = [b, a % b]; } return a; }
function fracStr(p, q) {
  const g = gcd(p, q) || 1; p /= g; q /= g;
  const s = (p < 0 ? "−" : "") + Math.abs(p);
  return q === 1 ? s : s + "/" + q;
}
PP.register(function drawQ() {
  const k = PP.val("ejp3-202-q"), rk = PP.val("ejp3-202-r");
  const q = k / 4, r = rk / 20;
  PP.out("ejp3-202-q-o", fracStr(k, 4));
  PP.out("ejp3-202-r-o", F(r, 2));
  const half = Math.max(1.3, r * 1.18);
  const { ctx, w, h } = PP.canvas("ejp3-202-cv", 0.36);
  const T = PP.frame(w, h, { x0: q - half, x1: q + half, y0: -0.9, y1: 1 }, { l: 12, r: 12, t: 8, b: 8 });
  const ticks = [];
  for (let n = Math.ceil(q - half); n <= Math.floor(q + half); n++) ticks.push([n, PP.fmt(n, 0)]);
  realLine(ctx, T, 0, ticks);
  // racionales de denominador ≤ 6 en la bola
  for (let d = 1; d <= 6; d++) {
    for (let n = Math.ceil((q - r) * d); n <= Math.floor((q + r) * d); n++) {
      const v = n / d;
      if (v > q - r && v < q + r) PP.dot(ctx, T.X(v), T.Y(0.55), 2, C("--accent"));
    }
  }
  openInterval(ctx, T, q - r, q + r, 0.55, C("--seq2"), 1.5);
  PP.dot(ctx, T.X(q), T.Y(0), 5.5, C("--accent"));
  PP.label(ctx, "q", T.X(q), T.Y(0) - 8, C("--accent"), "center", "bottom", 13);
  const t = q + r / Math.SQRT2;
  PP.dot(ctx, T.X(t), T.Y(0.55), 6, C("--seq2"));
  PP.label(ctx, "q + r/√2", T.X(t), T.Y(0.55) - 9, C("--seq2"), "center", "bottom", 12);
  PP.read("ejp3-202-read", [
    ["q, r", fracStr(k, 4) + ", " + fracStr(rk, 20)],
    ["B(q, r)", "(" + F(q - r, 3) + ", " + F(q + r, 3) + ")"],
    ["q + r/√2", "≈ " + F(t, 4) + ", irracional"],
    ["B(q, r) ∩ ℚᶜ ≠ ∅", "sí", "good"],
  ]);
}, ["ejp3-202-q", "ejp3-202-r"]);

/* ===================== 21 · diámetro de una bola ===================== */
const DIAM = { P: [[-0.6, 0.35], [0.5, -0.6]], T: null };
function drawDiam() {
  const { ctx, w, h } = PP.canvas("ejp3-21-cv", 0.8);
  const T = eqFrame(w, h, -1.55, 1.55, 0);
  DIAM.T = T;
  ball(ctx, T, [0, 0], 1, "2", C("--accent"), C("--area"), [6, 4], 1.8);
  const [X, Y] = DIAM.P;
  PP.path(ctx, [[T.X(X[0]), T.Y(X[1])], [T.X(0), T.Y(0)], [T.X(Y[0]), T.Y(Y[1])]], C("--seq2"), 2.2, [6, 4]);
  PP.path(ctx, [[T.X(X[0]), T.Y(X[1])], [T.X(Y[0]), T.Y(Y[1])]], C("--accent"), 2.6);
  pt(ctx, T, [0, 0], C("--ink"), "x₀", 8, 16, 4);
  pt(ctx, T, X, C("--accent"), "x", -8);
  pt(ctx, T, Y, C("--accent"), "y");
  PP.label(ctx, "B(x₀, 1)", T.X(-0.72), T.Y(0.9), C("--accent"), "right", "bottom", 12);
  const a = Math.hypot(X[0], X[1]), b = Math.hypot(Y[0], Y[1]), c = Math.hypot(X[0] - Y[0], X[1] - Y[1]);
  PP.read("ejp3-21-read", [
    ["d(x, x₀) + d(x₀, y)", F(a, 3) + " + " + F(b, 3) + " = " + F(a + b, 3) + " < 2r = 2"],
    ["d(x, y)", F(c, 3) + " ≤ " + F(a + b, 3), "good"],
  ]);
}
PP.register(drawDiam, []);
draggable("ejp3-21-cv", () => DIAM.T, (px, py, T) => nearest(DIAM.P, px, py, T), (i, x, y) => {
  DIAM.P[i] = capNorm([x, y], "2", 0.97);
}, drawDiam);

/* ===================== 23 · la bola unitaria es abierta ===================== */
const BU = { p: [0.35, 0.15], u: [-0.45, 0.4], T: null }; // q = p + r·u
function drawBU() {
  const { ctx, w, h } = PP.canvas("ejp3-23-cv", 0.8);
  const T = eqFrame(w, h, -1.6, 1.6, 0);
  BU.T = T;
  ball(ctx, T, [0, 0], 1, "2", C("--accent"), C("--area"), [6, 4], 1.8);
  planeAxes(ctx, T);
  PP.label(ctx, "B((0,0), 1)", T.X(0.75), T.Y(0.8), C("--accent"), "left", "bottom", 12);
  const p = BU.p, np = Math.hypot(p[0], p[1]), r = 1 - np;
  const dir = np > 1e-6 ? [p[0] / np, p[1] / np] : [1, 0];
  const q = [p[0] + r * BU.u[0], p[1] + r * BU.u[1]];
  ball(ctx, T, p, r, "2", C("--fail"), C("--failband"), [5, 4], 1.6);
  PP.path(ctx, [[T.X(p[0]), T.Y(p[1])], [T.X(p[0] + r * dir[0]), T.Y(p[1] + r * dir[1])]], C("--fail"), 1.6);
  PP.label(ctx, "r", T.X(p[0] + r * dir[0] / 2) + 4, T.Y(p[1] + r * dir[1] / 2) - 4, C("--fail"), "left", "bottom", 12);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(p[0]), T.Y(p[1])]], C("--muted"), 1.2, [3, 3]);
  pt(ctx, T, p, C("--ink"), "p", -8, 16);
  pt(ctx, T, q, C("--seq2"), "q", 8, -6, 4.5);
  const dq = Math.hypot(q[0], q[1]), dqp = Math.hypot(q[0] - p[0], q[1] - p[1]);
  PP.read("ejp3-23-read", [
    ["√(x₀² + y₀²)", F(np, 3)],
    ["r = 1 − √(x₀² + y₀²)", F(r, 3)],
    ["d₂(q, p)", F(dqp, 3) + " < r"],
    ["d₂(q, 0)", F(dq, 3) + " ≤ " + F(dqp, 3) + " + " + F(np, 3) + " < 1", "good"],
  ]);
}
PP.register(drawBU, []);
draggable("ejp3-23-cv", () => BU.T, (px, py, T) => {
  const p = BU.p, r = 1 - Math.hypot(p[0], p[1]);
  const q = [p[0] + r * BU.u[0], p[1] + r * BU.u[1]];
  const i = nearest([q, p], px, py, T);
  return i === null ? null : i;
}, (i, x, y) => {
  if (i === 1) { BU.p = capNorm([x, y], "2", 0.94); return; }
  const p = BU.p, r = 1 - Math.hypot(p[0], p[1]);
  BU.u = capNorm([(x - p[0]) / r, (y - p[1]) / r], "2", 0.95);
}, drawBU);

/* ===================== 23 (b) · toda bola abierta es abierta ===================== */
const BA = { x: [0.45, 0.25], u: [0.5, -0.4], T: null }; // y = x + t·u, con u de norma < 1
function drawBA() {
  const m = PP.radio("ejp3-232-m") || "2";
  const { ctx, w, h } = PP.canvas("ejp3-232-cv", 0.8);
  const T = eqFrame(w, h, -1.6, 1.6, 0);
  BA.T = T;
  BA.x = capNorm(BA.x, m, 0.92);
  BA.u = capNorm(BA.u, m, 0.95);
  ball(ctx, T, [0, 0], 1, m, C("--accent"), C("--area"), [6, 4], 1.8);
  PP.label(ctx, "B(x₀, r)", T.X(-1.5), T.Y(1.1), C("--accent"), "left", "bottom", 12);
  const x = BA.x, dx = NORM[m](x), t = 1 - dx;
  const y = [x[0] + t * BA.u[0], x[1] + t * BA.u[1]];
  ball(ctx, T, x, t, m, C("--seq2"), C("--area2"), [5, 4], 1.6);
  PP.path(ctx, [[T.X(y[0]), T.Y(y[1])], [T.X(x[0]), T.Y(x[1])], [T.X(0), T.Y(0)]], C("--muted"), 1.2, [3, 3]);
  pt(ctx, T, [0, 0], C("--ink"), "x₀", -8, 16, 4);
  pt(ctx, T, x, C("--seq2"), "x", -8, -6);
  pt(ctx, T, y, C("--ink"), "y", 8, -6, 4.5);
  const dyx = NORM[m]([y[0] - x[0], y[1] - x[1]]), dy0 = NORM[m](y);
  PP.read("ejp3-232-read", [
    ["métrica", MNAME[m] + ", r = 1"],
    ["t = r − d(x, x₀)", "1 − " + F(dx, 3) + " = " + F(t, 3)],
    ["d(y, x)", F(dyx, 3) + " < t"],
    ["d(y, x₀)", F(dy0, 3) + " ≤ " + F(dyx, 3) + " + " + F(dx, 3) + " < r", "good"],
  ]);
}
PP.register(drawBA, ["input[name='ejp3-232-m']"]);
draggable("ejp3-232-cv", () => BA.T, (px, py, T) => {
  const m = PP.radio("ejp3-232-m") || "2", x = BA.x, t = 1 - NORM[m](x);
  const y = [x[0] + t * BA.u[0], x[1] + t * BA.u[1]];
  return nearest([y, x], px, py, T);
}, (i, px, py) => {
  const m = PP.radio("ejp3-232-m") || "2";
  if (i === 1) { BA.x = capNorm([px, py], m, 0.92); return; }
  const x = BA.x, t = 1 - NORM[m](x);
  BA.u = capNorm([(px - x[0]) / t, (py - x[1]) / t], m, 0.95);
}, drawBA);

/* ===================== C4-4 · funciones inyectivas ===================== */
PP.register(function drawInyNoAbierto() {
  const eps = PP.val("ejp3-c44-eps") / 100;
  PP.out("ejp3-c44-eps-o", F(eps, 2));
  const { ctx, w, h } = PP.canvas("ejp3-c44-cv1", 0.7);
  const T = PP.frame(w, h, { x0: -0.04, x1: 1.04, y0: -0.4, y1: 1.4 }, { l: 40, r: 12, t: 10, b: 26 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 4 });
  const band = [[T.X(0), T.Y(eps)], [T.X(1), T.Y(1 + eps)], [T.X(1), T.Y(1 - eps)], [T.X(0), T.Y(-eps)]];
  PP.path(ctx, band, null, 0, null, true, C("--band"));
  PP.path(ctx, [band[0], band[1]], C("--accent"), 1.2, [5, 4]);
  PP.path(ctx, [band[3], band[2]], C("--accent"), 1.2, [5, 4]);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(1)]], C("--accent"), 2.2);
  const e2 = Math.min(eps / 2, 1);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(e2), T.Y(0)]], C("--seq2"), 3);
  if (e2 < 1) {
    PP.path(ctx, [[T.X(e2), T.Y(e2)], [T.X(1), T.Y(1)]], C("--seq2"), 3);
    PP.circle(ctx, T.X(e2), T.Y(e2), 4.5, C("--seq2"), C("--bg"), null, 2);
  }
  PP.dot(ctx, T.X(e2), T.Y(0), 4, C("--seq2"));
  PP.dot(ctx, T.X(0), T.Y(0), 5.5, C("--fail"));
  PP.dot(ctx, T.X(eps / 4), T.Y(0), 5.5, C("--fail"));
  PP.label(ctx, "f", T.X(0.62), T.Y(0.62) - 8, C("--accent"), "right", "bottom", 13);
  PP.label(ctx, "f̃", T.X(0.8), T.Y(0.8) + 8, C("--seq2"), "left", "top", 13);
  PP.label(ctx, "B(f, ε)", T.X(0.98), T.Y(0.98 + eps) + 6, C("--accent"), "right", "top", 12);
  PP.read("ejp3-c44-read1", [
    ["ε", F(eps, 2)],
    ["f̃(0) = f̃(ε/4)", "0 = 0: no inyectiva", "bad"],
    ["d∞(f, f̃) = sup |x| en [0, ε/2]", F(e2, 3) + " < ε", "good"],
  ]);
}, ["ejp3-c44-eps"]);

PP.register(function drawInyNoCerrado() {
  const n = PP.val("ejp3-c44-n");
  PP.out("ejp3-c44-n-o", String(n));
  const { ctx, w, h } = PP.canvas("ejp3-c44-cv2", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 1.05, y0: -0.08, y1: 1.08 }, { l: 40, r: 12, t: 10, b: 26 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 4 });
  for (let j = 1; j < n; j++) PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(1 / j)]], C("--muted"), 1);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(0)]], C("--fail"), 2.4);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(1 / n)]], C("--accent"), 2.6);
  PP.path(ctx, [[T.X(1.02), T.Y(0)], [T.X(1.02), T.Y(1 / n)]], C("--ink"), 2);
  PP.label(ctx, "f" + (n < 10 ? "₀₁₂₃₄₅₆₇₈₉"[n] : "ₙ"), T.X(0.5), T.Y(0.5 / n) - 6, C("--accent"), "center", "bottom", 13);
  PP.label(ctx, "0", T.X(0.25), T.Y(0) + 4, C("--fail"), "center", "top", 12);
  PP.read("ejp3-c44-read2", [
    ["n", String(n)],
    ["d∞(fₙ, 0) = fₙ(1)", "1/" + n + " = " + F(1 / n, 3)],
    ["límite", "la función nula, no inyectiva", "bad"],
  ]);
}, ["ejp3-c44-n"]);
