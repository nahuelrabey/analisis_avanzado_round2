/* Dibujos de los ejemplos alternativos de la Práctica 4, tercera parte (Bloques 10 a 13). Usa window.PP. */
const ID = "ejp4alt-";
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const SUB = "₀₁₂₃₄₅₆₇₈₉";
const sub = (n) => String(n).split("").map((d) => SUB[+d]).join("");

/* Recorta al rectángulo de dibujo del marco T mientras corre fn. */
function clipped(ctx, T, fn) {
  ctx.save();
  ctx.beginPath();
  ctx.rect(T.p.l, T.p.t, T.w - T.p.l - T.p.r, T.h - T.p.t - T.p.b);
  ctx.clip();
  fn();
  ctx.restore();
}

/* Grafica y = f(x) muestreando en los x que devuelve xs(i); corta el trazo donde f no es finita o se va lejos. */
function curve(ctx, T, f, xs, n, color, width, dash) {
  const span = T.box.y1 - T.box.y0, lo = T.box.y0 - 3 * span, hi = T.box.y1 + 3 * span;
  let pts = [];
  const flush = () => { if (pts.length > 1) PP.path(ctx, pts, color, width, dash); pts = []; };
  for (let i = 0; i <= n; i++) {
    const x = xs(i / n), y = f(x);
    if (!isFinite(y) || y < lo || y > hi) { flush(); continue; }
    pts.push([T.X(x), T.Y(y)]);
  }
  flush();
}
const lin = (a, b) => (s) => a + (b - a) * s;

/* Marco con la misma escala en x y en y. */
function eqFrame(w, h, x0, x1, y0, pad) {
  const p = Object.assign({ l: 10, r: 10, t: 10, b: 10 }, pad || {});
  const span = (x1 - x0) * (h - p.t - p.b) / (w - p.l - p.r);
  return PP.frame(w, h, { x0, x1, y0, y1: y0 + span }, p);
}

/* Arrastre de puntos sobre un canvas (como en los parciales). */
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

/* ===================== Bloque 10 ===================== */

/* O2-11: 1/x con x = δ y x' = δ/2. */
PP.register(function o211() {
  const d = PP.val(ID + "o2-11-d") / 100;
  PP.out(ID + "o2-11-d-o", PP.fmt(d, 2));
  const { ctx, w, h } = PP.canvas(ID + "o2-11-c1", 0.66);
  const ymax = Math.max(2 / d * 1.15, 3);
  const T = PP.frame(w, h, { x0: 0, x1: 1.1, y0: 0, y1: ymax }, { l: 42, r: 14, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "f(x) = 1/x" });
  clipped(ctx, T, () => curve(ctx, T, (x) => 1 / x, (s) => 0.004 + (1.1 - 0.004) * s * s, 600, C("--ink"), 1.6));
  // barra ε = 1
  const bx = T.p.l + 10;
  PP.path(ctx, [[bx, T.Y(0)], [bx, T.Y(1)]], C("--ok"), 5);
  PP.label(ctx, "ε = 1", bx + 6, T.Y(1) - 2, C("--ok"), "left", "bottom", 11);
  const x = d, xp = d / 2;
  // tramo horizontal y vertical
  PP.path(ctx, [[T.X(xp), T.Y(1 / x)], [T.X(x), T.Y(1 / x)]], C("--accent"), 2.5);
  PP.path(ctx, [[T.X(xp), T.Y(1 / x)], [T.X(xp), T.Y(1 / xp)]], C("--fail"), 2.5);
  PP.path(ctx, [[T.X(x), T.Y(1 / x)], [T.X(x), T.Y(0)]], C("--muted"), 1, [4, 4]);
  PP.path(ctx, [[T.X(xp), T.Y(1 / x)], [T.X(xp), T.Y(0)]], C("--muted"), 1, [4, 4]);
  PP.dot(ctx, T.X(x), T.Y(1 / x), 5, C("--accent"));
  PP.dot(ctx, T.X(xp), T.Y(1 / xp), 5, C("--seq2"));
  PP.label(ctx, "δ", T.X(x), T.Y(0) - 4, C("--accent"), "center", "bottom", 12);
  PP.label(ctx, "δ/2", T.X(xp) - 3, T.Y(0) - 4, C("--seq2"), "right", "bottom", 12);
  PP.label(ctx, "1/δ", T.X(xp) + 6, (T.Y(1 / x) + T.Y(1 / xp)) / 2, C("--fail"), "left", "middle", 12);
  PP.read(ID + "o2-11-r1", [
    ["δ", PP.fmt(d, 2)],
    ["|x − x′| = δ/2", PP.fmt(d / 2, 3) + " < δ", "good"],
    ["|f(x) − f(x′)| = 1/δ", PP.fmt(1 / d, 3) + " > 1 = ε", "bad"],
  ]);
}, [ID + "o2-11-d"]);

/* O6-10 a): x(x + δ/2)ε contra δ/2. */
PP.register(function o610() {
  const eps = PP.val(ID + "o6-10-e") / 100, d = PP.val(ID + "o6-10-d") / 100;
  PP.out(ID + "o6-10-e-o", PP.fmt(eps, 2));
  PP.out(ID + "o6-10-d-o", PP.fmt(d, 2));
  const { ctx, w, h } = PP.canvas(ID + "o6-10-c1", 0.62);
  const x1 = 1 - d / 2;
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: 0, y1: 1.6 * d }, { l: 46, r: 14, t: 14, b: 28 });
  const xs = (-d / 2 + Math.sqrt(d * d / 4 + 2 * d / eps)) / 2; // donde la curva cruza δ/2
  const xf = Math.min(xs, x1);
  PP.rect(ctx, T.X(0), T.p.t, T.X(xf) - T.X(0), T.h - T.p.t - T.p.b, null, C("--failband"));
  PP.axes(ctx, T, { xLabel: "x", yLabel: "" });
  clipped(ctx, T, () => {
    PP.path(ctx, [[T.X(0), T.Y(d / 2)], [T.X(x1), T.Y(d / 2)]], C("--seq2"), 2);
    curve(ctx, T, (x) => x * (x + d / 2) * eps, lin(0, x1), 300, C("--accent"), 2.2);
  });
  PP.path(ctx, [[T.X(x1), T.p.t], [T.X(x1), T.h - T.p.b]], C("--muted"), 1, [3, 4]);
  PP.label(ctx, "δ/2", T.X(x1) - 4, T.Y(d / 2) - 3, C("--seq2"), "right", "bottom", 12);
  PP.label(ctx, "x(x + δ/2)ε", T.X(Math.min(x1, Math.max(xs * 1.6, 0.35))), T.Y(Math.min(1.5 * d, Math.max(xs * 1.6, 0.35) * (Math.max(xs * 1.6, 0.35) + d / 2) * eps)) - 4, C("--accent"), "right", "bottom", 12);
  if (xf > 0.02) PP.label(ctx, "falla", T.X(xf / 2), T.p.t + 4, C("--fail"), "center", "top", 11);
  const xt = xf / 2, yt = xt + d / 2;
  PP.read(ID + "o6-10-r1", [
    ["ε, δ", PP.fmt(eps, 2) + ", " + PP.fmt(d, 2)],
    ["la curva queda debajo para", "0 < x ≤ " + PP.fmt(xf, 4), "bad"],
    ["ejemplo: x = " + PP.fmt(xt, 4) + ", y = x + δ/2", "|1/x − 1/y| = " + PP.fmt(1 / xt - 1 / yt, 3) + " ≥ ε", "bad"],
  ]);
}, [ID + "o6-10-e", ID + "o6-10-d"]);

/* O7-2, paso 1: ventana fija alrededor de (m, m²). */
PP.register(function o72a() {
  const m = PP.val(ID + "o7-2-m");
  PP.out(ID + "o7-2-m-o", String(m));
  const { ctx, w, h } = PP.canvas(ID + "o7-2-c1", 0.66);
  const m2 = m * m;
  const T = PP.frame(w, h, { x0: m - 0.5, x1: m + 0.5, y0: m2 - 1.5, y1: m2 + 2.5 }, { l: 48, r: 14, t: 14, b: 28 });
  const a = m, b = m + 1 / (2 * m);
  clipped(ctx, T, () => {
    PP.rect(ctx, T.X(m), T.p.t, T.X(Math.min(m + 1 / m, m + 0.5)) - T.X(m), T.h - T.p.t - T.p.b, null, C("--band"));
  });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "x²" });
  clipped(ctx, T, () => {
    curve(ctx, T, (x) => x * x, lin(m - 0.5, m + 0.5), 200, C("--ink"), 1.8);
    PP.path(ctx, [[T.X(a), T.Y(a * a)], [T.X(a), T.h - T.p.b]], C("--muted"), 1, [4, 4]);
    PP.path(ctx, [[T.X(b), T.Y(b * b)], [T.X(b), T.h - T.p.b]], C("--muted"), 1, [4, 4]);
    PP.path(ctx, [[T.X(b) + 10, T.Y(a * a)], [T.X(b) + 10, T.Y(b * b)]], C("--fail"), 3);
    PP.path(ctx, [[T.X(a), T.Y(a * a)], [T.X(b) + 10, T.Y(a * a)]], C("--fail"), 1, [3, 3]);
    const ex = T.X(m + 0.42);
    PP.path(ctx, [[ex, T.Y(m2 - 1.2)], [ex, T.Y(m2 - 0.2)]], C("--ok"), 5);
    PP.label(ctx, "ε = 1", ex - 6, T.Y(m2 - 0.7), C("--ok"), "right", "middle", 11);
  });
  PP.dot(ctx, T.X(a), T.Y(a * a), 5, C("--accent"));
  PP.dot(ctx, T.X(b), T.Y(b * b), 5, C("--seq2"));
  PP.label(ctx, "a" + sub(m), T.X(a) - 6, T.Y(a * a) + 2, C("--accent"), "right", "top", 12);
  PP.label(ctx, "b" + sub(m), T.X(b) + 14, T.Y(b * b), C("--seq2"), "left", "middle", 12);
  PP.label(ctx, "[m, m + δₘ)", T.X(m) + 4, T.p.t + 4, C("--accent"), "left", "top", 11);
  PP.read(ID + "o7-2-r1", [
    ["δₘ = 1/m", PP.fmt(1 / m, 4)],
    ["|aₘ − bₘ| = 1/(2m)", PP.fmt(1 / (2 * m), 4) + " < δₘ", "good"],
    ["|f(aₘ) − f(bₘ)|", PP.fmt(1 + 1 / (4 * m2), 4) + " > 1 = ε", "bad"],
  ]);
}, [ID + "o7-2-m"]);

/* O7-2, paso 2: el cono de pendientes ±2M. */
PP.register(function o72b() {
  const M = PP.val(ID + "o7-2-M") / 10, t = PP.val(ID + "o7-2-b") / 100, b = t * M;
  PP.out(ID + "o7-2-M-o", PP.fmt(M, 1));
  PP.out(ID + "o7-2-b-o", PP.fmt(t, 2));
  const { ctx, w, h } = PP.canvas(ID + "o7-2-c2", 0.66);
  const X1 = M + 1;
  const T = PP.frame(w, h, { x0: -X1, x1: X1, y0: -0.6, y1: X1 * X1 * 1.02 }, { l: 40, r: 14, t: 14, b: 28 });
  PP.rect(ctx, T.X(-M), T.p.t, T.X(M) - T.X(-M), T.h - T.p.t - T.p.b, null, C("--band"));
  PP.axes(ctx, T, { xLabel: "x", yLabel: "x²" });
  clipped(ctx, T, () => {
    curve(ctx, T, (x) => x * x, lin(-X1, X1), 300, C("--muted"), 1.4, [5, 4]);
    curve(ctx, T, (x) => x * x, lin(-M, M), 300, C("--accent"), 2.6);
    const L = 2 * M;
    PP.path(ctx, [[T.X(-X1), T.Y(b * b + L * (-X1 - b))], [T.X(X1), T.Y(b * b + L * (X1 - b))]], C("--seq2"), 1.6, [6, 4]);
    PP.path(ctx, [[T.X(-X1), T.Y(b * b - L * (-X1 - b))], [T.X(X1), T.Y(b * b - L * (X1 - b))]], C("--seq2"), 1.6, [6, 4]);
  });
  PP.dot(ctx, T.X(b), T.Y(b * b), 5.5, C("--seq2"));
  PP.label(ctx, "−M", T.X(-M), T.h - T.p.b - 4, C("--accent"), "center", "bottom", 11);
  PP.label(ctx, "M", T.X(M), T.h - T.p.b - 4, C("--accent"), "center", "bottom", 11);
  PP.read(ID + "o7-2-r2", [
    ["M, b", PP.fmt(M, 1) + ", " + PP.fmt(b, 2)],
    ["constante 2M", PP.fmt(2 * M, 2)],
    ["máx de |a + b| con a ∈ [−M, M]", PP.fmt(M + Math.abs(b), 2) + " ≤ 2M", "good"],
  ]);
}, [ID + "o7-2-M", ID + "o7-2-b"]);

/* O2-12, paso 3: cuerda de (0, 0) a (a, √a). */
PP.register(function o212() {
  const s = PP.val(ID + "o2-12-a");
  const a = Math.pow(10, -4 + 4 * s / 100);
  PP.out(ID + "o2-12-a-o", a < 0.01 ? a.toExponential(1).replace("e-", "·10⁻").replace("⁻1", "⁻¹").replace("⁻2", "⁻²").replace("⁻3", "⁻³").replace("⁻4", "⁻⁴") : PP.fmt(a, 3));
  const { ctx, w, h } = PP.canvas(ID + "o2-12-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 1.05, y0: 0, y1: 1.1 }, { l: 40, r: 14, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "√x" });
  clipped(ctx, T, () => {
    curve(ctx, T, Math.sqrt, (u) => 1.05 * u * u, 300, C("--accent"), 2.2);
    const k = 1 / Math.sqrt(a);
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1.1), T.Y(1.1 * k)]], C("--seq2"), 1.2, [5, 4]);
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(a), T.Y(Math.sqrt(a))]], C("--seq2"), 2.6);
  });
  PP.dot(ctx, T.X(a), T.Y(Math.sqrt(a)), 5, C("--seq2"));
  PP.dot(ctx, T.X(0), T.Y(0), 4, C("--ink"));
  PP.read(ID + "o2-12-r1", [
    ["a", PP.fmt(a, 5)],
    ["pendiente 1/(√a + √0)", PP.fmt(1 / Math.sqrt(a), 2), 1 / Math.sqrt(a) > 10 ? "bad" : ""],
  ]);
}, [ID + "o2-12-a"]);

/* O6-11 b): √x contra Kx. */
PP.register(function o611() {
  const K = PP.val(ID + "o6-11-K") / 10;
  PP.out(ID + "o6-11-K-o", PP.fmt(K, 1));
  const { ctx, w, h } = PP.canvas(ID + "o6-11-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: 0, y1: 1.1 }, { l: 40, r: 14, t: 14, b: 28 });
  const xc = 1 / (K * K);
  PP.rect(ctx, T.X(0), T.p.t, T.X(Math.min(xc, 1)) - T.X(0), T.h - T.p.t - T.p.b, null, C("--failband"));
  PP.axes(ctx, T, { xLabel: "x", yLabel: "" });
  clipped(ctx, T, () => {
    curve(ctx, T, Math.sqrt, (u) => u * u, 300, C("--accent"), 2.2);
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(K)]], C("--seq2"), 2);
  });
  PP.label(ctx, "√x", T.X(0.92), T.Y(Math.sqrt(0.92)) + 4, C("--accent"), "right", "top", 12);
  const lx = Math.min(0.95, 1.05 / K);
  PP.label(ctx, "Kx", T.X(lx) + 4, T.Y(K * lx), C("--seq2"), "left", "middle", 12);
  PP.label(ctx, "1/K²", T.X(Math.min(xc, 1)), T.h - T.p.b - 4, C("--fail"), "left", "bottom", 11);
  const xt = xc / 4;
  PP.read(ID + "o6-11-r1", [
    ["K", PP.fmt(K, 1)],
    ["√x > Kx para", "0 < x < 1/K² = " + PP.fmt(xc, 4), "bad"],
    ["en x = 1/(4K²)", "√x = " + PP.fmt(Math.sqrt(xt), 4) + " > Kx = " + PP.fmt(K * xt, 4), "bad"],
  ]);
}, [ID + "o6-11-K"]);

/* O6-12 c): una continua periódica. */
PP.register(function o612() {
  const P = PP.val(ID + "o6-12-P") / 10, x0 = PP.val(ID + "o6-12-x") / 10;
  PP.out(ID + "o6-12-P-o", PP.fmt(P, 1));
  PP.out(ID + "o6-12-x-o", PP.fmt(x0, 1));
  const f = (x) => Math.sin(2 * Math.PI * x / P) + 0.4 * Math.sin(6 * Math.PI * x / P);
  const { ctx, w, h } = PP.canvas(ID + "o6-12-c1", 0.6);
  const T = PP.frame(w, h, { x0: -6, x1: 6, y0: -1.7, y1: 1.9 }, { l: 34, r: 12, t: 14, b: 28 });
  PP.rect(ctx, T.X(0), T.p.t, T.X(P) - T.X(0), T.h - T.p.t - T.p.b, null, C("--band"));
  PP.axes(ctx, T, { xLabel: "x", yLabel: "f(x)" });
  clipped(ctx, T, () => {
    curve(ctx, T, f, lin(-6, 6), 800, C("--muted"), 1.5);
    curve(ctx, T, f, lin(0, P), 300, C("--accent"), 2.6);
  });
  const y0 = f(x0);
  PP.path(ctx, [[T.X(x0), T.Y(y0)], [T.X(x0 + P), T.Y(y0)]], C("--ok"), 1.5, [4, 4]);
  PP.dot(ctx, T.X(x0), T.Y(y0), 5, C("--ok"));
  PP.dot(ctx, T.X(x0 + P), T.Y(y0), 5, C("--ok"));
  PP.label(ctx, "x", T.X(x0), T.Y(y0) - 7, C("--ok"), "center", "bottom", 12);
  PP.label(ctx, "x + P", T.X(x0 + P), T.Y(y0) - 7, C("--ok"), "center", "bottom", 12);
  PP.label(ctx, "[0, P]", T.X(P / 2), T.p.t + 2, C("--accent"), "center", "top", 11);
  PP.read(ID + "o6-12-r1", [
    ["P", PP.fmt(P, 1)],
    ["f(x), f(x + P)", PP.fmt(y0, 3) + ", " + PP.fmt(f(x0 + P), 3), "good"],
  ]);
}, [ID + "o6-12-P", ID + "o6-12-x"]);

/* ===================== Bloque 11 ===================== */

/* O6-8: la cola de 1/n y la cola de sus imágenes. */
PP.register(function o68() {
  const mode = PP.radio(ID + "o6-8-f") || "lin", M = PP.val(ID + "o6-8-M");
  PP.out(ID + "o6-8-M-o", String(M));
  const { ctx, w, h } = PP.canvas(ID + "o6-8-c1", 0.5);
  const l = 24, r = 24, yT = h * 0.3, yB = h * 0.74;
  const Xt = (x) => l + x * (w - l - r);
  const top = 1, bot = mode === "lin" ? 0.5 : 62;
  const Xb = (y) => l + y / bot * (w - l - r);
  const f = mode === "lin" ? (x) => x / 2 : (x) => 1 / x;
  // bandas de la cola
  PP.rect(ctx, Xt(0), yT - 12, Xt(1 / M) - Xt(0), 24, null, C("--band"));
  if (mode === "lin") PP.rect(ctx, Xb(0), yB - 12, Xb(1 / (2 * M)) - Xb(0), 24, null, C("--band"));
  else PP.rect(ctx, Xb(M), yB - 12, w - r - Xb(M), 24, null, C("--band"));
  [[yT, Xt, top], [yB, Xb, bot]].forEach(([y, X, t]) => {
    PP.path(ctx, [[X(0), y], [w - r + 10, y]], C("--muted"), 1.2);
    PP.label(ctx, "0", X(0), y + 14, C("--muted"), "center", "top", 11);
    PP.label(ctx, PP.fmt(t, 1), X(t), y + 14, C("--muted"), "center", "top", 11);
    PP.path(ctx, [[X(t), y - 4], [X(t), y + 4]], C("--muted"), 1.2);
  });
  PP.label(ctx, "xₙ = 1/n", l, yT - 18, C("--ink"), "left", "bottom", 12);
  PP.label(ctx, mode === "lin" ? "f(xₙ) = xₙ/2" : "f(xₙ) = 1/xₙ = n", l, yB - 18, C("--ink"), "left", "bottom", 12);
  for (let n = 60; n >= 1; n--) {
    const x = 1 / n, y = f(x), inTail = n >= M;
    const col = inTail ? C("--accent") : C("--seq2");
    PP.dot(ctx, Xt(x), yT, inTail ? 3 : 4, col);
    if (Xb(y) <= w - r + 6) PP.dot(ctx, Xb(y), yB, inTail ? 3 : 4, col);
  }
  if (mode === "inv") PP.label(ctx, "→ ∞", w - r + 8, yB - 8, C("--fail"), "right", "bottom", 12);
  PP.read(ID + "o6-8-r1", [
    ["diámetro de {xₙ : n ≥ M}", PP.fmt(1 / M, 4), "good"],
    ["diámetro de {f(xₙ) : n ≥ M}", mode === "lin" ? PP.fmt(1 / (2 * M), 4) : "∞ (no acotado)", mode === "lin" ? "good" : "bad"],
  ]);
}, [ID + "o6-8-M", `input[name="${ID}o6-8-f"]`]);

/* O14-9: log en (0, 1] con los puntos 1/n. */
PP.register(function o149() {
  const N = PP.val(ID + "o14-9-N");
  PP.out(ID + "o14-9-N-o", String(N));
  const { ctx, w, h } = PP.canvas(ID + "o14-9-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 1.05, y0: -4.4, y1: 0.6 }, { l: 40, r: 14, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "log x" });
  clipped(ctx, T, () => curve(ctx, T, Math.log, (u) => 0.011 + (1.05 - 0.011) * u * u, 400, C("--ink"), 1.6));
  for (let n = 1; n <= N; n++) {
    const x = 1 / n, y = -Math.log(n);
    PP.dot(ctx, T.X(x), T.Y(y), n === N ? 5.5 : 3.5, C("--accent"));
    PP.path(ctx, [[T.X(x), T.Y(0) - 4], [T.X(x), T.Y(0) + 4]], C("--accent"), 1.5);
    PP.path(ctx, [[T.p.l - 4, T.Y(y)], [T.p.l + 4, T.Y(y)]], C("--seq2"), 1.5);
  }
  PP.label(ctx, "1/n", T.X(1 / Math.min(N, 3)) + 4, T.Y(0) - 6, C("--accent"), "left", "bottom", 11);
  PP.label(ctx, "−log n", T.p.l + 8, T.Y(-Math.log(N)), C("--seq2"), "left", "middle", 11);
  PP.read(ID + "o14-9-r1", [
    ["x_N = 1/N", PP.fmt(1 / N, 4)],
    ["log(x_N) = −log N", PP.fmt(-Math.log(N), 3), "bad"],
  ]);
}, [ID + "o14-9-N"]);

/* O3-9: proyección estereográfica. */
PP.register(function o39() {
  const t = PP.val(ID + "o3-9-t") / 10, N = PP.val(ID + "o3-9-N");
  PP.out(ID + "o3-9-t-o", PP.fmt(t, 1));
  PP.out(ID + "o3-9-N-o", String(N));
  const { ctx, w, h } = PP.canvas(ID + "o3-9-c1", 0.5);
  const T = eqFrame(w, h, -4.7, 4.7, -0.55, { l: 10, r: 10, t: 10, b: 10 });
  const s = T.X(1) - T.X(0);
  const f = (u) => [4 * u / (4 + u * u), 2 - 8 / (4 + u * u)];
  clipped(ctx, T, () => {
    PP.path(ctx, [[T.X(-4.7), T.Y(0)], [T.X(4.7), T.Y(0)]], C("--muted"), 1.2);
    PP.path(ctx, [[T.X(0), T.Y(-0.5)], [T.X(0), T.Y(T.box.y1)]], C("--rule"), 1);
    PP.circle(ctx, T.X(0), T.Y(1), s, C("--accent"), null, null, 2.2);
    // recta por (t, 0) y (0, 2), un poco prolongada
    const ext = 1.25;
    PP.path(ctx, [[T.X(t), T.Y(0)], [T.X(-t * (ext - 1)), T.Y(2 * ext)]], C("--seq2"), 1.6);
    for (let n = 1; n <= 4; n++) {
      PP.path(ctx, [[T.X(n), T.Y(0) - 5], [T.X(n), T.Y(0) + 5]], C("--ok"), 2);
      PP.label(ctx, String(n), T.X(n), T.Y(0) + 7, C("--ok"), "center", "top", 11);
    }
    for (let n = 1; n <= N; n++) { const [x, y] = f(n); PP.dot(ctx, T.X(x), T.Y(y), n === N ? 4.5 : 3, C("--ok")); }
  });
  PP.circle(ctx, T.X(0), T.Y(2), 5, C("--ink"), C("--bg"), null, 1.6);
  PP.label(ctx, "(0, 2) ∉ Y", T.X(0) + 9, T.Y(2) - 2, C("--ink"), "left", "bottom", 11);
  const [fx, fy] = f(t);
  PP.dot(ctx, T.X(t), T.Y(0), 5, C("--seq2"));
  PP.dot(ctx, T.X(fx), T.Y(fy), 6, C("--accent"));
  PP.label(ctx, "f(t)", T.X(fx) + (fx >= 0 ? 9 : -9), T.Y(fy), C("--accent"), fx >= 0 ? "left" : "right", "middle", 12);
  PP.label(ctx, "(t, 0)", T.X(t), T.Y(0) - 8, C("--seq2"), "center", "bottom", 11);
  const [nx, ny] = f(N);
  PP.read(ID + "o3-9-r1", [
    ["f(t)", "(" + PP.fmt(fx, 3) + ", " + PP.fmt(fy, 3) + ")"],
    ["2x/(2 − y) en f(t)", PP.fmt(2 * fx / (2 - fy), 3) + " = t"],
    ["d(f(N), (0, 2))", PP.fmt(Math.hypot(nx, ny - 2), 4), "good"],
    ["f⁻¹(f(N)) = N", String(N), "bad"],
  ]);
}, [ID + "o3-9-t", ID + "o3-9-N"]);

/* O3-10: t_n = d(z_n, x) con x arrastrable. */
const o310 = { x: [3.3, 0.45], T: null };
const z310 = (n) => [1.5 + 0.9 * Math.pow(-1, n) / n, 1 + 0.7 / n];
function drawO310() {
  const N = PP.val(ID + "o3-10-N");
  PP.out(ID + "o3-10-N-o", String(N));
  const { ctx, w, h } = PP.canvas(ID + "o3-10-c1", 0.62);
  const T = eqFrame(w, h, 0, 4, -0.1, { l: 10, r: 10, t: 10, b: 10 });
  o310.T = T;
  const [px, py] = o310.x;
  for (let n = 1; n <= N; n++) {
    const [zx, zy] = z310(n);
    PP.path(ctx, [[T.X(px), T.Y(py)], [T.X(zx), T.Y(zy)]], n === N ? C("--seq2") : C("--rule"), n === N ? 2 : 1);
  }
  for (let n = 1; n <= N; n++) {
    const [zx, zy] = z310(n);
    PP.dot(ctx, T.X(zx), T.Y(zy), n <= 2 ? 4.5 : 3, C("--accent"));
  }
  PP.label(ctx, "z₁", T.X(z310(1)[0]) - 7, T.Y(z310(1)[1]), C("--accent"), "right", "middle", 12);
  PP.label(ctx, "z₂", T.X(z310(2)[0]) + 7, T.Y(z310(2)[1]), C("--accent"), "left", "middle", 12);
  PP.circle(ctx, T.X(1.5), T.Y(1), 5, C("--ok"), null, null, 1.6);
  PP.label(ctx, "z = lim zₙ", T.X(1.5) - 6, T.Y(1) + 8, C("--ok"), "right", "top", 11);
  PP.dot(ctx, T.X(px), T.Y(py), 7, C("--seq2"));
  PP.label(ctx, "x (arrastrá)", T.X(px), T.Y(py) + 11, C("--seq2"), "center", "top", 11);
  const t = (n) => Math.hypot(z310(n)[0] - px, z310(n)[1] - py);
  const rows = [["t" + sub(N) + " = d(z" + sub(N) + ", x)", PP.fmt(t(N), 4)]];
  if (N > 1) rows.push(["|t" + sub(N) + " − t" + sub(N - 1) + "|", PP.fmt(Math.abs(t(N) - t(N - 1)), 4) + " ≤ d(z" + sub(N) + ", z" + sub(N - 1) + ") = " + PP.fmt(Math.hypot(z310(N)[0] - z310(N - 1)[0], z310(N)[1] - z310(N - 1)[1]), 4), "good"]);
  rows.push(["φ(x) = d(z, x)", PP.fmt(Math.hypot(1.5 - px, 1 - py), 4)]);
  PP.read(ID + "o3-10-r1", rows);
}
PP.register(drawO310, [ID + "o3-10-N"]);
draggable(ID + "o3-10-c1", () => o310.T,
  (px, py, T) => (Math.hypot(px - T.X(o310.x[0]), py - T.Y(o310.x[1])) < 22 ? 0 : null),
  (k, x, y, T) => { o310.x = [clamp(x, T.box.x0 + 0.1, T.box.x1 - 0.1), clamp(y, T.box.y0 + 0.1, T.box.y1 - 0.1)]; },
  drawO310);

/* O2-6: dos sucesiones de racionales hacia x = 1/√2. */
PP.register(function o26() {
  const n = PP.val(ID + "o2-6-n");
  PP.out(ID + "o2-6-n-o", String(n));
  const { ctx, w, h } = PP.canvas(ID + "o2-6-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0.5, x1: 0.9, y0: 0.2, y1: 0.85 }, { l: 44, r: 14, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "f" });
  const x = Math.SQRT1_2, f = (q) => q * q;
  clipped(ctx, T, () => {
    for (let q = 1; q <= 14; q++) for (let p = 0; p <= q; p++) {
      const r = p / q;
      if (r >= 0.5 && r <= 0.9) PP.dot(ctx, T.X(r), T.Y(f(r)), 2.4, C("--muted"));
    }
    PP.path(ctx, [[T.X(x), T.p.t], [T.X(x), T.h - T.p.b]], C("--ok"), 1, [4, 4]);
    PP.path(ctx, [[T.p.l, T.Y(0.5)], [T.w - T.p.r, T.Y(0.5)]], C("--ok"), 1, [4, 4]);
  });
  let xa = 0, xb = 0;
  for (let k = 1; k <= n; k++) {
    xa = Math.floor(10 * k * x) / (10 * k); xb = Math.ceil(10 * k * x) / (10 * k);
    const last = k === n, r = last ? 5.5 : 3.5;
    if (xa >= 0.5) PP.dot(ctx, T.X(xa), T.Y(f(xa)), r, C("--accent"));
    if (xb <= 0.9) PP.dot(ctx, T.X(xb), T.Y(f(xb)), r, C("--seq2"));
  }
  PP.circle(ctx, T.X(x), T.Y(0.5), 7, C("--ok"), null, null, 2);
  PP.label(ctx, "x = 1/√2 ∉ A", T.X(x) + 5, T.h - T.p.b - 4, C("--ok"), "left", "bottom", 11);
  PP.label(ctx, "g(x)", T.X(x) - 10, T.Y(0.5) - 4, C("--ok"), "right", "bottom", 12);
  PP.read(ID + "o2-6-r1", [
    ["xₙ, f(xₙ)", PP.fmt(xa, 4) + ", " + PP.fmt(f(xa), 4)],
    ["x′ₙ, f(x′ₙ)", PP.fmt(xb, 4) + ", " + PP.fmt(f(xb), 4)],
    ["|f(xₙ) − f(x′ₙ)|", PP.fmt(Math.abs(f(xb) - f(xa)), 4), "good"],
  ]);
}, [ID + "o2-6-n"]);

/* O6-9: tres funciones en (0, 1) y dos sucesiones hacia 0. */
PP.register(function o69() {
  const mode = PP.radio(ID + "o6-9-f") || "xs", n = PP.val(ID + "o6-9-n");
  PP.out(ID + "o6-9-n-o", String(n));
  const F = { xs: (x) => x * Math.sin(1 / x), s: (x) => Math.sin(1 / x), inv: (x) => 1 / x }[mode];
  const box = mode === "inv" ? { x0: -0.03, x1: 1, y0: -1, y1: 30 } : mode === "s" ? { x0: -0.03, x1: 1, y0: -1.35, y1: 1.35 } : { x0: -0.03, x1: 1, y0: -0.6, y1: 1.0 };
  const { ctx, w, h } = PP.canvas(ID + "o6-9-c1", 0.66);
  const T = PP.frame(w, h, box, { l: 40, r: 14, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "" });
  clipped(ctx, T, () => {
    curve(ctx, T, F, (u) => 1 / (1 + 499 * u), 6000, C("--ink"), 1.1);
    if (mode === "s") {
      PP.path(ctx, [[T.p.l, T.Y(1)], [T.w - T.p.r, T.Y(1)]], C("--accent"), 1, [4, 4]);
      PP.path(ctx, [[T.p.l, T.Y(-1)], [T.w - T.p.r, T.Y(-1)]], C("--seq2"), 1, [4, 4]);
    }
  });
  const xk = (k) => 1 / (2 * Math.PI * k + Math.PI / 2), yk = (k) => 1 / (2 * Math.PI * k - Math.PI / 2);
  for (let k = 1; k <= n; k++) {
    const r = k === n ? 5.5 : 3.5;
    if (F(xk(k)) <= box.y1) PP.dot(ctx, T.X(xk(k)), T.Y(F(xk(k))), r, C("--accent"));
    if (F(yk(k)) <= box.y1) PP.dot(ctx, T.X(yk(k)), T.Y(F(yk(k))), r, C("--seq2"));
  }
  if (mode === "xs") {
    PP.circle(ctx, T.X(0), T.Y(0), 6, C("--ok"), null, null, 2);
    PP.label(ctx, "L_a = 0", T.X(0) + 9, T.Y(0) + 6, C("--ok"), "left", "top", 12);
  } else if (mode === "s") {
    PP.label(ctx, "L₁ = 1", T.w - T.p.r - 4, T.Y(1) - 3, C("--accent"), "right", "bottom", 12);
    PP.label(ctx, "L₂ = −1", T.w - T.p.r - 4, T.Y(-1) + 3, C("--seq2"), "right", "top", 12);
  }
  const fx = F(xk(n)), fy = F(yk(n));
  const concl = { xs: ["L₁ = L₂ = 0", "existe L_a", "good"], s: ["L₁ = 1 ≠ −1 = L₂", "no existe L_a", "bad"], inv: ["f(xₙ) → ∞", "no es de Cauchy", "bad"] }[mode];
  PP.read(ID + "o6-9-r1", [
    ["xₙ, f(xₙ)", PP.fmt(xk(n), 4) + ", " + PP.fmt(fx, 4)],
    ["yₙ, f(yₙ)", PP.fmt(yk(n), 4) + ", " + PP.fmt(fy, 4)],
    [concl[0], concl[1], concl[2]],
  ]);
}, [ID + "o6-9-n", `input[name="${ID}o6-9-f"]`]);

/* O3-12 b): sen(1/t) y la imagen de (0, δ). */
PP.register(function o312() {
  const d = PP.val(ID + "o3-12-d") / 100;
  PP.out(ID + "o3-12-d-o", PP.fmt(d, 2));
  const { ctx, w, h } = PP.canvas(ID + "o3-12-c1", 0.66);
  const T = PP.frame(w, h, { x0: -0.04, x1: 1, y0: -1.3, y1: 1.3 }, { l: 40, r: 14, t: 14, b: 28 });
  PP.rect(ctx, T.X(0), T.p.t, T.X(d) - T.X(0), T.h - T.p.t - T.p.b, null, C("--band"));
  PP.axes(ctx, T, { xLabel: "t", yLabel: "" });
  const f = (t) => Math.sin(1 / t);
  clipped(ctx, T, () => curve(ctx, T, f, (u) => 1 / (1 + 499 * u), 6000, C("--ink"), 1.1));
  let lo = Infinity, hi = -Infinity;
  for (let i = 1; i <= 20000; i++) { const t = d * i / 20000, y = f(t); lo = Math.min(lo, y); hi = Math.max(hi, y); }
  PP.path(ctx, [[T.X(0) - 6, T.Y(lo)], [T.X(0) - 6, T.Y(hi)]], C("--ok"), 5);
  PP.label(ctx, "f((0, δ))", T.X(0) - 2, T.p.t + 2, C("--ok"), "left", "top", 11);
  for (let n = 1; n <= 80; n++) {
    const tn = 1 / (n * Math.PI), sn = 1 / (Math.PI / 2 + 2 * n * Math.PI);
    if (tn < d) PP.dot(ctx, T.X(tn), T.Y(0), 3, C("--seq2"));
    if (sn < d) PP.dot(ctx, T.X(sn), T.Y(1), 3, C("--accent"));
  }
  PP.label(ctx, "(0, δ)", T.X(d) + 4, T.h - T.p.b - 4, C("--accent"), "left", "bottom", 11);
  PP.read(ID + "o3-12-r1", [
    ["δ", PP.fmt(d, 2)],
    ["sup − ínf de f en (0, δ)", PP.fmt(hi - lo, 3), "bad"],
  ]);
}, [ID + "o3-12-d"]);

/* ===================== Bloque 12 ===================== */

/* O6-7: pares que se acercan en (0, 1] con imágenes a distancia 2. */
PP.register(function o67() {
  const n = PP.val(ID + "o6-7-n");
  PP.out(ID + "o6-7-n-o", String(n));
  const { ctx, w, h } = PP.canvas(ID + "o6-7-c1", 0.66);
  const T = PP.frame(w, h, { x0: -0.012, x1: 0.24, y0: -1.35, y1: 1.35 }, { l: 40, r: 14, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "" });
  const f = (x) => Math.sin(1 / x);
  clipped(ctx, T, () => curve(ctx, T, f, (u) => 1 / (4.2 + 795 * u), 6000, C("--ink"), 1.1));
  const xk = (k) => 1 / (2 * Math.PI * k + Math.PI / 2), yk = (k) => 1 / (2 * Math.PI * k - Math.PI / 2);
  for (let k = 1; k <= n; k++) {
    const last = k === n, r = last ? 5.5 : 3;
    PP.dot(ctx, T.X(xk(k)), T.Y(1), r, C("--accent"));
    PP.dot(ctx, T.X(yk(k)), T.Y(-1), r, C("--seq2"));
  }
  const a = xk(n), b = yk(n);
  PP.path(ctx, [[T.X(a), T.Y(1)], [T.X(b), T.Y(-1)]], C("--fail"), 1.6, [4, 3]);
  PP.circle(ctx, T.X(0), T.Y(0), 6, C("--ink"), C("--bg"), null, 1.6);
  PP.label(ctx, "c = 0 ∉ (0, 1]", T.X(0) + 9, T.Y(0) + 4, C("--ink"), "left", "top", 11);
  PP.label(ctx, "xₙ", T.X(a), T.Y(1) - 8, C("--accent"), "center", "bottom", 12);
  PP.label(ctx, "yₙ", T.X(b), T.Y(-1) + 8, C("--seq2"), "center", "top", 12);
  PP.read(ID + "o6-7-r1", [
    ["xₙ, yₙ", PP.fmt(a, 4) + ", " + PP.fmt(b, 4)],
    ["|xₙ − yₙ|", PP.fmt(b - a, 4) + " < 1/n = " + PP.fmt(1 / n, 3), "good"],
    ["|f(xₙ) − f(yₙ)|", PP.fmt(Math.abs(f(a) - f(b)), 3) + " ≥ ε = 1", "bad"],
  ]);
}, [ID + "o6-7-n"]);
