/* Recuperatorio del primer parcial, 2C 2025: dibujos. */
const ID = "r1-2c2025";
const $ = (s) => ID + "-" + s;
const C = (t) => PP.css(t);

/* Línea vertical / horizontal punteada en coordenadas de pantalla. */
function vline(ctx, x, y0, y1, color, dash) { PP.path(ctx, [[x, y0], [x, y1]], color, 1.2, dash || [4, 4]); }
function hline(ctx, y, x0, x1, color, dash) { PP.path(ctx, [[x0, y], [x1, y]], color, 1.2, dash || [4, 4]); }
/* Marco con la misma escala en x e y (para dibujos en el plano). */
function isoFrame(w, h, cx, cy, spanX, pad) {
  const p = Object.assign({ l: 12, r: 12, t: 12, b: 12 }, pad || {});
  const ux = (w - p.l - p.r) / spanX;
  const spanY = (h - p.t - p.b) / ux;
  return PP.frame(w, h, { x0: cx - spanX / 2, x1: cx + spanX / 2, y0: cy - spanY / 2, y1: cy + spanY / 2 }, p);
}

/* ---------------- Ejercicio 1 ---------------- */
const D = (n) => (n - 4) * (n - 4) + 2;

PP.register(function drawD() {
  const { ctx, w, h } = PP.canvas($("ej1-c1"), 0.6);
  const T = PP.frame(w, h, { x0: 0.3, x1: 10.7, y0: 0, y1: 40 });
  PP.axes(ctx, T, { xLabel: "n", yLabel: "Dₙ", intX: true, xTicks: 10 });
  const curve = [];
  for (let t = 0.3; t <= 10.7; t += 0.05) curve.push([T.X(t), T.Y(D(t))]);
  PP.path(ctx, curve, C("--muted"), 1.2, [3, 4]);
  hline(ctx, T.Y(2), T.X(0.3), T.X(10.7), C("--seq2"));
  PP.label(ctx, "2", T.X(10.6), T.Y(2) - 3, C("--seq2"), "right", "bottom", 12);
  for (let n = 1; n <= 10; n++) {
    PP.dot(ctx, T.X(n), T.Y(D(n)), n === 4 ? 5 : 3.5, n === 4 ? C("--seq2") : C("--accent"));
  }
  PP.label(ctx, "D₄ = 2", T.X(4), T.Y(2) - 10, C("--seq2"), "center", "bottom", 12);
}, []);

PP.register(function drawA() {
  const k = PP.val($("ej1-n"));
  PP.out($("ej1-n-o"), String(k));
  const { ctx, w, h } = PP.canvas($("ej1-c2"), 0.6);
  const T = PP.frame(w, h, { x0: 0.3, x1: 16.7, y0: 0, y1: 0.6 });
  PP.axes(ctx, T, { xLabel: "n", yLabel: "aₙ", intX: true, xTicks: 8 });
  hline(ctx, T.Y(0.5), T.X(0.3), T.X(16.7), C("--seq2"));
  PP.label(ctx, "1/2: cota superior", T.X(16.6), T.Y(0.5) - 4, C("--seq2"), "right", "bottom", 12);
  for (let n = 1; n <= 16; n++) {
    const on = n === k;
    PP.dot(ctx, T.X(n), T.Y(1 / D(n)), on ? 5.5 : 3.5, n === 4 ? C("--seq2") : C("--accent"), on ? C("--ink") : null);
  }
  PP.read($("ej1-read2"), [
    ["Dₙ", String(D(k))],
    ["aₙ = 1/Dₙ", "1/" + D(k) + " ≈ " + PP.fmt(1 / D(k), 4)],
    ["aₙ ≤ 1/2", "sí" + (k === 4 ? " (igual: a₄ = 1/2 ∈ A)" : ""), "good"],
  ]);
}, [$("ej1-n")]);

PP.register(function drawEps() {
  const eps = PP.val($("ej1-eps")) / 100;
  PP.out($("ej1-eps-o"), PP.fmt(eps, 2));
  const bound = 4 + 1 / eps;
  const n = Math.floor(bound) + 1;
  const xmax = Math.max(14, n + 3);
  const { ctx, w, h } = PP.canvas($("ej1-c3"), 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: xmax + 0.5, y0: 0, y1: 0.56 });
  PP.rect(ctx, T.X(0), T.Y(eps), T.X(xmax + 0.5) - T.X(0), T.Y(0) - T.Y(eps), null, C("--okband"));
  PP.axes(ctx, T, { xLabel: "n", yLabel: "aₙ", intX: true, xTicks: 7 });
  hline(ctx, T.Y(eps), T.X(0), T.X(xmax + 0.5), C("--ok"), [2, 3]);
  PP.label(ctx, "ε", T.X(xmax + 0.4), T.Y(eps) - 3, C("--ok"), "right", "bottom", 13);
  vline(ctx, T.X(bound), T.Y(0), T.Y(0.56), C("--seq2"));
  PP.label(ctx, "4 + 1/ε", T.X(bound) - 4, T.Y(0.5), C("--seq2"), "right", "middle", 12);
  const r = xmax > 40 ? 2.2 : 3.2;
  for (let m = 1; m <= xmax; m++) PP.dot(ctx, T.X(m), T.Y(1 / D(m)), m === n ? 5.5 : r, m === n ? C("--ok") : C("--accent"), m === n ? C("--ink") : null);
  PP.read($("ej1-read3"), [
    ["4 + 1/ε", PP.fmt(bound, 3)],
    ["n elegido", String(n)],
    ["n − 4 > 1/ε", PP.fmt(n - 4, 0) + " > " + PP.fmt(1 / eps, 3), "good"],
    ["Dₙ", String(D(n))],
    ["aₙ = 1/Dₙ", PP.fmt(1 / D(n), 5) + " < ε = " + PP.fmt(eps, 2), "good"],
  ]);
}, [$("ej1-eps")]);

PP.register(function drawT() {
  const t = PP.val($("ej1-t")) / 20;
  PP.out($("ej1-t-o"), PP.fmt(t, 2));
  const { ctx, w, h } = PP.canvas($("ej1-c4"), 0.62);
  const T = PP.frame(w, h, { x0: -2.2, x1: 3.2, y0: -2.5, y1: 9 });
  PP.axes(ctx, T, { xLabel: "t", yTicks: 5 });
  const par = [], lin = [];
  for (let s = -2.2; s <= 3.2001; s += 0.04) { par.push([T.X(s), T.Y(s * s + 2)]); lin.push([T.X(s), T.Y(s)]); }
  PP.path(ctx, par, C("--accent"), 2);
  PP.path(ctx, lin, C("--seq2"), 2);
  PP.label(ctx, "y = t² + 2", T.X(-2.1), T.Y(7.2), C("--accent"), "left", "bottom", 12);
  PP.label(ctx, "y = t", T.X(3.1), T.Y(3.1) + 14, C("--seq2"), "right", "top", 12);
  PP.path(ctx, [[T.X(t), T.Y(t)], [T.X(t), T.Y(t * t + 2)]], C("--ok"), 3);
  PP.dot(ctx, T.X(t), T.Y(t * t + 2), 4, C("--accent"));
  PP.dot(ctx, T.X(t), T.Y(t), 4, C("--seq2"));
  vline(ctx, T.X(0.5), T.Y(0.5), T.Y(2.25), C("--muted"), [2, 3]);
  const gap = t * t - t + 2;
  PP.read($("ej1-read4"), [
    ["t² + 2", PP.fmt(t * t + 2, 4)],
    ["t", PP.fmt(t, 2)],
    ["t² − t + 2", PP.fmt(gap, 4) + " ≥ 7/4 = 1.75", "good"],
    ["(t − 1/2)² + 7/4", PP.fmt((t - 0.5) * (t - 0.5) + 1.75, 4)],
  ]);
}, [$("ej1-t")]);

/* ---------------- Ejercicio 2 ---------------- */
/* Funciones de ejemplo: listas de excepciones [q, valor, rótulo]. */
const FUN = [
  { name: "f", exc: [[-2, 7, "−2"], [0, 5, "0"], [0.5, 1, "1/2"]] },
  { name: "g", exc: [[-1, 1, "−1"], [1.5, 2, "3/2"]] },
  { name: "3", exc: [] },
];

function drawFun(canvasId, exc, label) {
  const { ctx, w, h } = PP.canvas(canvasId, 0.58);
  const T = PP.frame(w, h, { x0: -3.2, x1: 3.2, y0: 0, y1: 8.5 }, { l: 34 });
  PP.axes(ctx, T, { xLabel: "q", yTicks: 4 });
  PP.path(ctx, [[T.X(-3.2), T.Y(3)], [T.X(3.2), T.Y(3)]], C("--accent"), 2);
  PP.label(ctx, label + " = 3", T.X(-3.1), T.Y(3) - 4, C("--accent"), "left", "bottom", 12);
  exc.forEach(([q, v, lab]) => {
    PP.dot(ctx, T.X(q), T.Y(3), 4, C("--bg"), C("--accent"));
    vline(ctx, T.X(q), T.Y(3), T.Y(v), C("--muted"), [2, 3]);
    PP.dot(ctx, T.X(q), T.Y(v), 4.5, C("--seq2"));
    PP.label(ctx, "(" + lab + ", " + v + ")", T.X(q) + 7, T.Y(v), C("--seq2"), "left", "middle", 12);
  });
}
const setStr = (xs) => xs.length ? "{" + xs.join(", ") + "}" : "∅";

PP.register(function drawEj2a() {
  const F = FUN[+PP.radio($("ej2-f"))];
  const lbl = F.name === "3" ? "h" : F.name;
  drawFun($("ej2-c1"), F.exc, F.name === "3" ? "h(q)" : lbl + "(q)");
  PP.read($("ej2-read1"), [
    ["E_" + lbl, setStr(F.exc.map((e) => e[2]))],
    ["G(" + lbl + ")", setStr(F.exc.map((e) => "(" + e[2] + ", " + e[1] + ")"))],
    ["#G(" + lbl + ")", String(F.exc.length) + " (finito)", "good"],
  ]);
}, ['input[name="' + $("ej2-f") + '"]']);

PP.register(function drawEj2b() {
  const k = PP.val($("ej2-k"));
  PP.out($("ej2-k-o"), String(k));
  const exc = k === 3 ? [] : [[0, k, "0"]];
  drawFun($("ej2-c2"), exc, "fₖ(q)");
  PP.read($("ej2-read2"), [
    ["fₖ(0)", String(k)],
    ["E_fₖ", setStr(exc.map((e) => e[2])) + " ⊆ {0}", "good"],
    ["G(fₖ)", setStr(exc.map((e) => "(0, " + e[1] + ")"))],
  ]);
}, [$("ej2-k")]);

/* ---------------- Ejercicio 3 ---------------- */
const A3 = { x: 0, y: 0, r: 1.5 };
const B3 = { x: 2.0, y: 0.2, r: 0.9 };

PP.register(function drawEj3a() {
  const th = Math.PI + PP.val($("ej3-th")) / 100;
  PP.out($("ej3-th-o"), PP.fmt(PP.val($("ej3-th")) / 100, 2));
  const { ctx, w, h } = PP.canvas($("ej3-c1"), 0.66);
  const T = isoFrame(w, h, 0.75, 0, 4.9);
  const s = T.X(1) - T.X(0);
  PP.circle(ctx, T.X(A3.x), T.Y(A3.y), A3.r * s, C("--accent"), C("--band"), [5, 4]);
  PP.circle(ctx, T.X(B3.x), T.Y(B3.y), B3.r * s, C("--seq2"), C("--area2"), [5, 4]);
  PP.label(ctx, "A", T.X(-1.0), T.Y(1.05), C("--accent"), "center", "middle", 15);
  PP.label(ctx, "B", T.X(2.55), T.Y(0.95), C("--seq2"), "center", "middle", 15);
  const x = { x: B3.x + B3.r * Math.cos(th), y: B3.y + B3.r * Math.sin(th) };
  const nx = Math.hypot(x.x, x.y);
  const r = A3.r - nx;
  const ux = (B3.x - x.x) / B3.r, uy = (B3.y - x.y) / B3.r;
  const y = { x: x.x + ux * r / 2, y: x.y + uy * r / 2 };
  PP.circle(ctx, T.X(x.x), T.Y(x.y), r * s, C("--ink"), C("--area"), [3, 3]);
  PP.dot(ctx, T.X(x.x), T.Y(x.y), 4.5, C("--ink"));
  PP.label(ctx, "x", T.X(x.x) - 7, T.Y(x.y) - 4, C("--ink"), "right", "bottom", 13);
  PP.dot(ctx, T.X(y.x), T.Y(y.y), 4.5, C("--ok"));
  PP.label(ctx, "y", T.X(y.x) + 6, T.Y(y.y) + 3, C("--ok"), "left", "top", 13);
  PP.label(ctx, "B(x, r)", T.X(x.x), T.Y(x.y - r) + 4, C("--ink"), "center", "top", 12);
  const dyB = Math.hypot(y.x - B3.x, y.y - B3.y);
  PP.read($("ej3-read1"), [
    ["x ∈ A", "sí (|x| = " + PP.fmt(nx, 3) + " < 1.5)", "good"],
    ["x ∈ B̄ \\ B", "sí (x está en el borde de B)"],
    ["r = 1.5 − |x|", PP.fmt(r, 3) + " → B(x, r) ⊆ A"],
    ["y ∈ B(x, r) ∩ B", "d(x, y) = " + PP.fmt(r / 2, 3) + " < r, d(y, centro de B) = " + PP.fmt(dyB, 3) + " < 0.9", "good"],
  ]);
}, [$("ej3-th")]);

PP.register(function drawEj3b() {
  const r = PP.val($("ej3-r")) / 100;
  PP.out($("ej3-r-o"), PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas($("ej3-c2"), 0.42);
  const T = PP.frame(w, h, { x0: -1, x1: 1.4, y0: -1, y1: 1 }, { l: 16, r: 16, t: 14, b: 30 });
  const y0 = T.Y(0);
  PP.rect(ctx, T.X(-r), y0 - 22, T.X(r) - T.X(-r), 44, null, C("--area"));
  vline(ctx, T.X(-r), y0 - 22, y0 + 22, C("--accent"), [3, 3]);
  vline(ctx, T.X(r), y0 - 22, y0 + 22, C("--accent"), [3, 3]);
  PP.path(ctx, [[T.X(-1), y0], [T.X(1.4), y0]], C("--muted"), 1);
  PP.path(ctx, [[T.X(0), y0], [T.X(1), y0]], C("--seq2"), 4);
  PP.dot(ctx, T.X(1), y0, 4.5, C("--bg"), C("--seq2"));
  PP.dot(ctx, T.X(0), y0, 5, C("--accent"));
  PP.dot(ctx, T.X(r / 2), y0, 4, C("--fail"));
  PP.label(ctx, "r/2", T.X(r / 2), y0 + 8, C("--fail"), "center", "top", 12);
  PP.label(ctx, "A = {0}", T.X(0) - 6, y0 - 26, C("--accent"), "center", "bottom", 12);
  PP.label(ctx, "B = (0, 1)", T.X(1), y0 - 6, C("--seq2"), "right", "bottom", 12);
  PP.label(ctx, "−r", T.X(-r), y0 + 26, C("--accent"), "center", "top", 11);
  PP.label(ctx, "r", T.X(r), y0 + 26, C("--accent"), "center", "top", 11);
  PP.label(ctx, "1", T.X(1), y0 + 8, C("--muted"), "center", "top", 11);
  PP.read($("ej3-read2"), [
    ["B(0, r)", "(−" + PP.fmt(r, 2) + ", " + PP.fmt(r, 2) + ")"],
    ["B(0, r) ⊆ A", "no: r/2 = " + PP.fmt(r / 2, 3) + " ∈ B(0, r) y r/2 ≠ 0", "bad"],
  ]);
}, [$("ej3-r")]);

/* ---------------- Ejercicio 4 ---------------- */
const p4 = { x: 0.3, y: 0.55 };
let T4 = null;
const delta = (a, b) => (a === b ? 0 : 1);

function drawEj4a() {
  const { ctx, w, h } = PP.canvas($("ej4-c1"), 0.7);
  const T = isoFrame(w, h, 0, 0, 2.7, { l: 34, r: 12, t: 12, b: 26 });
  T4 = T;
  PP.axes(ctx, T, { xLabel: "x", yLabel: "y", xTicks: 6, yTicks: 4 });
  const y0 = T.Y(0);
  PP.path(ctx, [[T.X(-0.5), y0], [T.X(0.5), y0]], C("--accent"), 5);
  PP.dot(ctx, T.X(-0.5), y0, 4.5, C("--bg"), C("--accent"));
  PP.dot(ctx, T.X(0.5), y0, 4.5, C("--bg"), C("--accent"));
  PP.label(ctx, "B((0,0), 1/2)", T.X(-0.5), y0 - 8, C("--accent"), "left", "bottom", 12);
  PP.dot(ctx, T.X(0), y0, 3, C("--ink"));
  const dl = delta(p4.y, 0);
  const q = p4.x * p4.x + dl * dl;
  const inside = q < 0.25;
  if (p4.y !== 0) hline(ctx, T.Y(p4.y), T.X(T.box.x0), T.X(T.box.x1), C("--fail"), [2, 4]);
  PP.dot(ctx, T.X(p4.x), T.Y(p4.y), 6, inside ? C("--ok") : C("--fail"), C("--ink"));
  PP.label(ctx, "p", T.X(p4.x) + 8, T.Y(p4.y) - 6, C("--ink"), "left", "bottom", 13);
  PP.read($("ej4-read1"), [
    ["p", "(" + PP.fmt(p4.x, 2) + ", " + PP.fmt(p4.y, 2) + ")"],
    ["δ(y, 0)", String(dl)],
    ["x² + δ(y, 0)²", PP.fmt(q, 4) + (inside ? " < 1/4" : " ≥ 1/4")],
    ["d(p, (0,0))", PP.fmt(Math.sqrt(q), 4)],
    ["p ∈ B((0,0), 1/2)", inside ? "sí" : "no", inside ? "good" : "bad"],
  ]);
}
PP.register(drawEj4a, []);
(function dragEj4() {
  const cv = document.getElementById($("ej4-c1"));
  if (!cv) return;
  let drag = false;
  const move = (e) => {
    if (!T4) return;
    const r = cv.getBoundingClientRect();
    let x = T4.iX(e.clientX - r.left), y = T4.iY(e.clientY - r.top);
    x = Math.max(T4.box.x0 + 0.05, Math.min(T4.box.x1 - 0.05, x));
    y = Math.max(T4.box.y0 + 0.05, Math.min(T4.box.y1 - 0.05, y));
    if (Math.abs(y) < 0.07) y = 0;
    p4.x = Math.round(x * 100) / 100; p4.y = Math.round(y * 100) / 100;
    drawEj4a();
  };
  cv.addEventListener("pointerdown", (e) => { drag = true; try { cv.setPointerCapture(e.pointerId); } catch (_) { /* nada */ } move(e); });
  cv.addEventListener("pointermove", (e) => { if (drag) move(e); });
  const stop = () => { drag = false; };
  cv.addEventListener("pointerup", stop);
  cv.addEventListener("pointercancel", stop);
  cv.style.cursor = "crosshair";
})();

PP.register(function drawEj4b() {
  const n = PP.val($("ej4-n"));
  PP.out($("ej4-n-o"), String(n));
  const { ctx, w, h } = PP.canvas($("ej4-c2"), 0.66);
  const T = isoFrame(w, h, 0.47, 0.47, 1.35, { l: 34, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "y", xTicks: 5, yTicks: 4 });
  for (let m = 1; m <= 25; m++) {
    if (m === n) continue;
    PP.dot(ctx, T.X(1 / m), T.Y(1 / m), 3, C("--accent"));
  }
  PP.dot(ctx, T.X(0), T.Y(0), 4.5, C("--ink"));
  PP.label(ctx, "(0, 0)", T.X(0) + 6, T.Y(0) - 4, C("--ink"), "left", "bottom", 12);
  PP.dot(ctx, T.X(1 / n), T.Y(1 / n), 6, C("--fail"), C("--ink"));
  PP.label(ctx, "xₙ", T.X(1 / n) + 8, T.Y(1 / n) - 4, C("--fail"), "left", "bottom", 13);
  const dn = Math.sqrt(1 / (n * n) + 1);
  PP.read($("ej4-read2"), [
    ["xₙ", "(1/" + n + ", 1/" + n + ")"],
    ["δ(1/n, 0)", "1 (porque 1/" + n + " ≠ 0)"],
    ["d(xₙ, (0,0))", "√(1/" + (n * n) + " + 1) ≈ " + PP.fmt(dn, 5) + " ≥ 1", "bad"],
  ]);
}, [$("ej4-n")]);

PP.register(function drawEj4c() {
  const mode = PP.radio($("ej4-s"));
  const { ctx, w, h } = PP.canvas($("ej4-c3"), 0.58);
  const N = 30;
  const T = PP.frame(w, h, { x0: 0, x1: N + 1, y0: 0, y1: 1.6 });
  PP.axes(ctx, T, { xLabel: "n", yLabel: "d(xₙ, (0,0))", intX: true, xTicks: 6, yTicks: 4 });
  const bw = Math.max(2, (T.X(1) - T.X(0)) * 0.6);
  let below = 0;
  for (let n = 1; n <= N; n++) {
    const d = mode === "a" ? Math.sqrt(1 / (n * n) + 1) : 1 / n;
    if (d < 1) { below++; }
    PP.rect(ctx, T.X(n) - bw / 2, T.Y(d), bw, T.Y(0) - T.Y(d), null, d < 1 ? C("--ok") : C("--accent"));
  }
  hline(ctx, T.Y(1), T.X(0), T.X(N + 1), C("--fail"), [5, 3]);
  PP.label(ctx, "ε = 1", T.X(N + 0.8), T.Y(1) - 4, C("--fail"), "right", "bottom", 12);
  PP.read($("ej4-read3"), mode === "a" ? [
    ["xₙ", "(1/n, 1/n)"],
    ["d(xₙ, (0,0))", "√(1/n² + 1) ≥ 1"],
    ["términos con d < 1", "ninguno de los 30: no hay n₀", "bad"],
  ] : [
    ["xₙ", "(1/n, 0)"],
    ["d(xₙ, (0,0))", "1/n → 0"],
    ["términos con d < 1", below + " de 30 (desde n = 2)", "good"],
  ]);
}, ['input[name="' + $("ej4-s") + '"]']);

/* ---------------- Ejercicio 5 ---------------- */
const f5 = (t) => 1 + 0.8 * Math.sin(1.7 * t);
const X0 = -0.2, X1 = 4.2;

/* Máximo δ tal que |f(t) − f(x)| < ε para |t − x| < δ (búsqueda en una grilla fina). */
function maxDelta(x, eps) {
  const fx = f5(x), step = 0.0005;
  let d = 0;
  while (d < 6) {
    d += step;
    if (Math.abs(f5(x + d) - fx) >= eps || Math.abs(f5(x - d) - fx) >= eps) return d - step;
  }
  return d;
}
/* Tramos del eje horizontal donde f(t) cae en el intervalo (lo, hi) (abierto o cerrado). */
function preimage(lo, hi, closed) {
  const segs = []; let start = null; const step = 0.002;
  const inB = (v) => (closed ? v >= lo && v <= hi : v > lo && v < hi);
  for (let t = X0; t <= X1 + 1e-9; t += step) {
    const ok = inB(f5(t));
    if (ok && start === null) start = t;
    if (!ok && start !== null) { segs.push([start, t - step]); start = null; }
  }
  if (start !== null) segs.push([start, X1]);
  return segs;
}

function drawEj5(canvasId, x, Blo, Bhi, closed, eps) {
  const { ctx, w, h } = PP.canvas(canvasId, 0.66);
  const T = PP.frame(w, h, { x0: X0, x1: X1, y0: -0.5, y1: 2.05 }, { l: 40, b: 30 });
  /* B en el eje vertical, como banda horizontal */
  PP.rect(ctx, T.X(X0), T.Y(Bhi), T.X(X1) - T.X(X0), T.Y(Blo) - T.Y(Bhi), null, closed ? C("--band") : C("--area"));
  PP.axes(ctx, T, { xLabel: "t", yTicks: 4, xTicks: 5 });
  const yAx = T.Y(-0.14);
  /* preimagen de B */
  preimage(Blo, Bhi, closed).forEach(([a, b]) => PP.path(ctx, [[T.X(a), yAx], [T.X(b), yAx]], C("--seq3"), 6));
  PP.label(ctx, "f⁻¹(B)", T.X(X1) - 2, yAx + 6, C("--seq3"), "right", "top", 11);
  /* gráfico */
  const g = [];
  for (let t = X0; t <= X1 + 1e-9; t += 0.01) g.push([T.X(t), T.Y(f5(t))]);
  PP.path(ctx, g, C("--muted"), 1.6);
  const fx = f5(x);
  let dl = null;
  if (eps !== null) {
    if (closed) {
      PP.rect(ctx, T.X(X0), T.Y(fx + eps), T.X(X1) - T.X(X0), T.Y(fx - eps) - T.Y(fx + eps), null, C("--area"));
    }
    hline(ctx, T.Y(fx + eps), T.X(X0), T.X(X1), C("--accent"), [3, 3]);
    hline(ctx, T.Y(fx - eps), T.X(X0), T.X(X1), C("--accent"), [3, 3]);
    dl = maxDelta(x, eps);
    const a = x - dl, b = x + dl;
    vline(ctx, T.X(a), T.Y(-0.5), T.Y(2.05), C("--accent"), [2, 4]);
    vline(ctx, T.X(b), T.Y(-0.5), T.Y(2.05), C("--accent"), [2, 4]);
    const seg = [];
    for (let t = Math.max(a, X0); t <= Math.min(b, X1); t += 0.005) seg.push([T.X(t), T.Y(f5(t))]);
    PP.path(ctx, seg, C("--accent"), 3);
    const yB = T.Y(-0.36);
    PP.path(ctx, [[T.X(Math.max(a, X0)), yB], [T.X(Math.min(b, X1)), yB]], C("--accent"), 4);
    PP.label(ctx, "B(x, δ)", T.X(Math.min(b, X1)) + 5, yB, C("--accent"), "left", "middle", 11);
  }
  PP.label(ctx, closed ? "B = [0.5, 1.4]" : "B = B(f(x), ε)", T.X(X1) - 4, T.Y(Bhi) - 3, C("--ink"), "right", "bottom", 12);
  PP.dot(ctx, T.X(x), T.Y(fx), 5, C("--ink"));
  PP.dot(ctx, T.X(x), yAx, 4, C("--ink"));
  PP.label(ctx, "x", T.X(x), yAx - 6, C("--ink"), "center", "bottom", 12);
  PP.label(ctx, "f(x)", T.X(x) + 8, T.Y(fx) - 4, C("--ink"), "left", "bottom", 12);
  return { fx, dl };
}

PP.register(function drawEj5a() {
  const x = X0 + 0.2 + PP.val($("ej5-x1")) / 100;
  PP.out($("ej5-x1-o"), PP.fmt(x, 2));
  const lo = 0.5, hi = 1.4;
  const fx = f5(x);
  const inInt = fx > lo && fx < hi;
  const eps = inInt ? Math.min(fx - lo, hi - fx) : null;
  const r = drawEj5($("ej5-c1"), x, lo, hi, true, eps);
  PP.read($("ej5-read1"), inInt ? [
    ["f(x)", PP.fmt(fx, 3) + " ∈ B° = (0.5, 1.4)", "good"],
    ["ε", PP.fmt(eps, 3) + "  (B(f(x), ε) ⊆ B)"],
    ["δ", PP.fmt(r.dl, 3) + "  (f(B(x, δ)) ⊆ B(f(x), ε))"],
    ["B(x, δ) ⊆ f⁻¹(B)", "sí: x ∈ (f⁻¹(B))°", "good"],
  ] : [
    ["f(x)", PP.fmt(fx, 3) + " ∉ B° = (0.5, 1.4)", "bad"],
    ["x ∈ f⁻¹(B°)", "no: este x no entra en la inclusión"],
  ]);
}, [$("ej5-x1")]);

PP.register(function drawEj5b() {
  const x = X0 + 0.2 + PP.val($("ej5-x2")) / 100;
  const eps = PP.val($("ej5-e2")) / 100;
  PP.out($("ej5-x2-o"), PP.fmt(x, 2));
  PP.out($("ej5-e2-o"), PP.fmt(eps, 2));
  const fx = f5(x);
  const r = drawEj5($("ej5-c2"), x, fx - eps, fx + eps, false, eps);
  PP.read($("ej5-read2"), [
    ["B = B(f(x), ε)", "(" + PP.fmt(fx - eps, 3) + ", " + PP.fmt(fx + eps, 3) + ")"],
    ["x ∈ f⁻¹(B)", "sí, porque f(x) ∈ B", "good"],
    ["δ", PP.fmt(r.dl, 3) + "  (B(x, δ) ⊆ f⁻¹(B))"],
    ["d(x, x′) < δ", "⟹ d′(f(x), f(x′)) < ε", "good"],
  ]);
}, [$("ej5-x2"), $("ej5-e2")]);
