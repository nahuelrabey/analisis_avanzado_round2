/* Dibujos del primer parcial 2C 2024. El build envuelve este código en un IIFE estricto. */
const ID = "p1-2c2024";
const C = (t) => PP.css(t);
/* Proporción alto/ancho según el ancho disponible (en teléfono, más alto). */
const ratio = (id, wide, narrow) => ((document.getElementById(id) || {}).clientWidth || 600) < 480 ? narrow : wide;

/* ---------- utilidades ---------- */
function equalFrame(w, h, cx, cy, halfW, pad) {
  const p = Object.assign({ l: 36, r: 12, t: 12, b: 26 }, pad || {});
  const halfH = halfW * (h - p.t - p.b) / (w - p.l - p.r);
  return PP.frame(w, h, { x0: cx - halfW, x1: cx + halfW, y0: cy - halfH, y1: cy + halfH }, p);
}
/* Unión de discos: un solo camino con todos los arcos en el mismo sentido; fill con nonzero pinta la unión sin superposiciones. */
function unionFill(ctx, T, centers, r, fill) {
  const rp = Math.abs(T.X(r) - T.X(0));
  ctx.save(); ctx.beginPath();
  centers.forEach(([x, y]) => { ctx.moveTo(T.X(x) + rp, T.Y(y)); ctx.arc(T.X(x), T.Y(y), rp, 0, Math.PI * 2); });
  ctx.fillStyle = fill; ctx.fill("nonzero"); ctx.restore();
}
const listSet = (arr) => arr.length ? "{" + arr.join(", ") + "}" : "∅";
function checked(name) {
  return [...document.querySelectorAll(`input[name="${name}"]:checked`)].map((el) => +el.value).sort((a, b) => a - b);
}

/* =================== Ejercicio 1 =================== */
const A1 = [], B1 = [];
for (let k = 1; k <= 40; k++) { A1.push(1 + 1 / k); B1.push(0.5 + 1 / (2 * k)); }
const S1 = [];
A1.forEach((a) => B1.forEach((b) => S1.push(a + b)));
const INF_A = 1, INF_B = 0.5;

function rowsFrame(id) {
  const { ctx, w, h } = PP.canvas(id, ratio(id, 0.56, 0.8));
  const T = PP.frame(w, h, { x0: 0.3, x1: 3.15, y0: 0.45, y1: 3.55 }, { l: 50, r: 14, t: 14, b: 26 });
  return { ctx, w, h, T };
}
function drawRow(ctx, T, y, name, pts, color, inf, infLabel) {
  const yy = T.Y(y);
  PP.path(ctx, [[T.X(0.3), yy], [T.X(3.15), yy]], C("--rule"), 1);
  for (let t = 0.5; t <= 3.0001; t += 0.5) PP.path(ctx, [[T.X(t), yy - 3], [T.X(t), yy + 3]], C("--muted"), 1);
  PP.label(ctx, name, 6, yy, C("--ink"), "left", "middle", 13);
  pts.forEach((p) => PP.dot(ctx, T.X(p), yy, 2.2, color));
  PP.path(ctx, [[T.X(inf), yy - 16], [T.X(inf), yy + 12]], C("--ink"), 1.2, [3, 3]);
  PP.label(ctx, infLabel, T.X(inf) - 3, yy - 17, C("--muted"), "right", "bottom", 11);
}
function tickLabels(ctx, T, y) {
  for (let t = 0.5; t <= 3.0001; t += 0.5) PP.label(ctx, PP.fmt(t, 1), T.X(t), T.Y(y) + 8, C("--muted"), "center", "top", 11);
}

PP.register(function drawEj1a() {
  const i = PP.val(ID + "-ej1-i"), j = PP.val(ID + "-ej1-j");
  const a = A1[i - 1], b = B1[j - 1], s = a + b;
  PP.out(ID + "-ej1-i-o", PP.fmt(a, 3)); PP.out(ID + "-ej1-j-o", PP.fmt(b, 3));
  const { ctx, T } = rowsFrame(ID + "-ej1-c1");
  drawRow(ctx, T, 3, "A", A1, C("--accent"), INF_A, "ínf A");
  drawRow(ctx, T, 2, "B", B1, C("--seq3"), INF_B, "ínf B");
  drawRow(ctx, T, 1, "A + B", S1, C("--muted"), INF_A + INF_B, "ínf A + ínf B");
  tickLabels(ctx, T, 1);
  PP.dot(ctx, T.X(a), T.Y(3), 5.5, C("--accent"), C("--bg"));
  PP.label(ctx, "a", T.X(a), T.Y(3) + 8, C("--accent"), "center", "top", 12);
  PP.dot(ctx, T.X(b), T.Y(2), 5.5, C("--seq3"), C("--bg"));
  PP.label(ctx, "b", T.X(b), T.Y(2) + 8, C("--seq3"), "center", "top", 12);
  PP.path(ctx, [[T.X(INF_A + INF_B), T.Y(1) - 6], [T.X(s), T.Y(1) - 6]], C("--ok"), 3);
  PP.dot(ctx, T.X(s), T.Y(1), 5.5, C("--seq2"), C("--bg"));
  PP.label(ctx, "a + b", T.X(s), T.Y(1) - 9, C("--seq2"), "center", "bottom", 12);
  PP.read(ID + "-ej1-read", [
    ["a", PP.fmt(a, 4)], ["b", PP.fmt(b, 4)], ["a + b", PP.fmt(s, 4)],
    ["ínf A + ínf B", "1.5"],
    ["a + b ≥ ínf A + ínf B", s >= INF_A + INF_B ? "sí" : "no", s >= INF_A + INF_B ? "good" : "bad"],
  ]);
}, [ID + "-ej1-i", ID + "-ej1-j"]);

PP.register(function drawEj1b() {
  const eps = PP.val(ID + "-ej1-eps") / 100;
  PP.out(ID + "-ej1-eps-o", PP.fmt(eps, 2));
  const ka = Math.floor(2 / eps) + 1, kb = Math.floor(1 / eps) + 1;
  const a = 1 + 1 / ka, b = 0.5 + 1 / (2 * kb), s = a + b;
  const { ctx, T } = rowsFrame(ID + "-ej1-c2");
  const band = (y, x0, x1, fill) => PP.rect(ctx, T.X(x0), T.Y(y) - 11, T.X(x1) - T.X(x0), 22, null, fill);
  band(3, INF_A, INF_A + eps / 2, C("--area"));
  band(2, INF_B, INF_B + eps / 2, C("--area3"));
  band(1, INF_A + INF_B, INF_A + INF_B + eps, C("--okband"));
  drawRow(ctx, T, 3, "A", A1, C("--accent"), INF_A, "ínf A");
  drawRow(ctx, T, 2, "B", B1, C("--seq3"), INF_B, "ínf B");
  drawRow(ctx, T, 1, "A + B", S1, C("--muted"), INF_A + INF_B, "ínf A + ínf B");
  tickLabels(ctx, T, 1);
  PP.dot(ctx, T.X(a), T.Y(3), 5.5, C("--accent"), C("--bg"));
  PP.label(ctx, "a", T.X(a), T.Y(3) + 8, C("--accent"), "center", "top", 12);
  PP.dot(ctx, T.X(b), T.Y(2), 5.5, C("--seq3"), C("--bg"));
  PP.label(ctx, "b", T.X(b), T.Y(2) + 8, C("--seq3"), "center", "top", 12);
  PP.dot(ctx, T.X(s), T.Y(1), 5.5, C("--ok"), C("--bg"));
  PP.label(ctx, "a + b", T.X(s) + 4, T.Y(1) - 9, C("--ok"), "left", "bottom", 12);
  const sm = s - eps;
  PP.path(ctx, [[T.X(sm), T.Y(1) - 9], [T.X(sm), T.Y(1) + 9]], C("--seq2"), 2.5);
  PP.label(ctx, "a + b − ε", T.X(sm), T.Y(1) + 24, C("--seq2"), "center", "top", 11);
  const ok = INF_A + INF_B >= sm;
  PP.read(ID + "-ej1-read2", [
    ["ε/2", PP.fmt(eps / 2, 3)],
    ["a (a < ínf A + ε/2)", PP.fmt(a, 4)],
    ["b (b < ínf B + ε/2)", PP.fmt(b, 4)],
    ["a + b − ε", PP.fmt(sm, 4)],
    ["ínf A + ínf B ≥ a + b − ε", ok ? "sí (1.5 ≥ " + PP.fmt(sm, 4) + ")" : "no", ok ? "good" : "bad"],
  ]);
}, [ID + "-ej1-eps"]);

/* =================== Ejercicio 2 =================== */
function natFrame(id, r1, r2) {
  const { ctx, w, h } = PP.canvas(id, ratio(id, r1, r2));
  const T = PP.frame(w, h, { x0: -0.2, x1: 6.6, y0: 0.4, y1: 2.6 }, { l: 62, r: 12, t: 12, b: 26 });
  return { ctx, w, h, T };
}
function drawPhiRow(ctx, T, y, name, B, color) {
  const yy = T.Y(y);
  PP.path(ctx, [[T.X(-0.2), yy], [T.X(6.6), yy]], C("--rule"), 1);
  PP.label(ctx, name, 6, yy, C("--ink"), "left", "middle", 13);
  PP.path(ctx, [[T.X(1), yy], [T.X(2), yy]], color, 4);
  for (let n = 1; n <= 40; n++) PP.dot(ctx, T.X(1 + 1 / (n + 1)), yy - 8, 1.8, color);
  for (let n = 1; n <= 6; n++) {
    if (B.includes(n)) PP.dot(ctx, T.X(n), yy, 5, color);
    else PP.dot(ctx, T.X(n), yy, 4, C("--bg"), C("--muted"));
  }
}
function natLabels(ctx, T, y) {
  for (let n = 0; n <= 6; n++) PP.label(ctx, String(n), T.X(n), T.Y(y) + 9, C("--muted"), "center", "top", 11);
}

PP.register(function drawEj2a() {
  const B = checked(ID + "-ej2-b");
  const { ctx, T } = natFrame(ID + "-ej2-c1", 0.38, 0.62);
  drawPhiRow(ctx, T, 2, "Φ(B)", B, C("--accent"));
  // complemento en ℚ: todo salvo (1, 2) y los naturales de B
  const y = T.Y(1), col = C("--seq2");
  PP.path(ctx, [[T.X(-0.2), y], [T.X(6.6), y]], C("--rule"), 1);
  PP.label(ctx, "ℚ ∖ Φ(B)", 6, y, C("--ink"), "left", "middle", 13);
  PP.path(ctx, [[T.X(-0.2), y], [T.X(1), y]], col, 1.5);
  PP.path(ctx, [[T.X(2), y], [T.X(6.6), y]], col, 1.5);
  PP.path(ctx, [[T.X(2), y], [T.X(3), y]], col, 4);
  for (let n = 1; n <= 40; n++) PP.dot(ctx, T.X(2 + 1 / (n + 1)), y - 8, 1.8, col);
  for (let n = 1; n <= 6; n++) {
    if (B.includes(n)) PP.dot(ctx, T.X(n), y, 4, C("--bg"), C("--muted"));
    else PP.dot(ctx, T.X(n), y, 5, col);
  }
  PP.label(ctx, "(1, 2) ∩ ℚ", T.X(1.5), T.Y(2) - 13, C("--accent"), "center", "bottom", 11);
  PP.label(ctx, "(2, 3) ∩ ℚ", T.X(2.5), y - 13, col, "center", "bottom", 11);
  natLabels(ctx, T, 1);
  PP.read(ID + "-ej2-read", [
    ["B ∩ {1, …, 6}", listSet(B)],
    ["(1,2)∩ℚ ⊆ Φ(B) ⊆ ℚ", "sí ⇒ #Φ(B) = ℵ₀", "good"],
    ["(2,3)∩ℚ ⊆ ℚ∖Φ(B) ⊆ ℚ", "sí ⇒ # = ℵ₀", "good"],
    ["naturales en (1,2) o (2,3)", "ninguno"],
  ]);
}, ['input[name="' + ID + '-ej2-b"]']);

PP.register(function drawEj2b() {
  const B = checked(ID + "-ej2-u"), Bp = checked(ID + "-ej2-w");
  const { ctx, T } = natFrame(ID + "-ej2-c2", 0.36, 0.6);
  const diff = [1, 2, 3, 4, 5, 6].filter((n) => B.includes(n) !== Bp.includes(n));
  diff.forEach((n) => {
    PP.rect(ctx, T.X(n) - 9, T.Y(2) - 14, 18, T.Y(1) - T.Y(2) + 28, null, C("--failband"));
    PP.path(ctx, [[T.X(n), T.Y(2) + 8], [T.X(n), T.Y(1) - 8]], C("--fail"), 1.5, [3, 3]);
  });
  drawPhiRow(ctx, T, 2, "Φ(B)", B, C("--accent"));
  drawPhiRow(ctx, T, 1, "Φ(B′)", Bp, C("--seq3"));
  natLabels(ctx, T, 1);
  const same = diff.length === 0;
  PP.read(ID + "-ej2-read2", [
    ["Φ(B) ∩ ℕ", listSet(B) + " = B"],
    ["Φ(B′) ∩ ℕ", listSet(Bp) + " = B′"],
    ["difieren en", same ? "nada" : listSet(diff)],
    ["Φ(B) = Φ(B′)", same ? "sí, y B = B′" : "no, porque B ≠ B′", same ? "good" : "bad"],
  ]);
}, ['input[name="' + ID + '-ej2-u"]', 'input[name="' + ID + '-ej2-w"]']);

/* =================== Ejercicio 3 =================== */
const RHO = 1.6, TH = 2.2, MAXM = 700;
const XS = [null];
for (let m = 1; m <= MAXM; m++) XS.push([RHO / m * Math.cos(TH * m), RHO / m * Math.sin(TH * m)]);
const dist = (p, q) => Math.hypot(p[0] - q[0], p[1] - q[1]);
const WIN = 80;
/* TD[n] = máx d(x_m, x_k) con n ≤ m, k ≤ n + WIN; FAR[n] = el par que lo realiza. Las colas más allá están a menos de ρ/(n+WIN) del origen. */
const TD = [0], FAR = [null];
for (let n = 1; n <= 400; n++) {
  let best = 0, pair = [n, n];
  for (let m = n; m <= n + WIN; m++) for (let k = m + 1; k <= n + WIN; k++) {
    const d = dist(XS[m], XS[k]);
    if (d > best) { best = d; pair = [m, k]; }
  }
  TD.push(best); FAR.push(pair);
}
const centersFrom = (n, upto) => { const c = []; for (let m = n; m <= Math.min(MAXM, upto); m++) c.push(XS[m]); return c; };
const diamA = (n) => TD[n] + 2 / n;
const rot = (u, a) => [u[0] * Math.cos(a) - u[1] * Math.sin(a), u[0] * Math.sin(a) + u[1] * Math.cos(a)];

PP.register(function drawEj3a() {
  const n = PP.val(ID + "-ej3-n");
  PP.out(ID + "-ej3-n-o", String(n));
  const { ctx, w, h } = PP.canvas(ID + "-ej3-c1", 0.78);
  const T = equalFrame(w, h, 0, 0, 2.8);
  PP.axes(ctx, T, { xTicks: 6, yTicks: 5 });
  unionFill(ctx, T, centersFrom(n, n + 400), 1 / n, C("--area"));
  unionFill(ctx, T, centersFrom(n + 1, n + 401), 1 / (n + 1), C("--area2"));
  for (let m = 1; m <= 200; m++) {
    const [x, y] = XS[m];
    if (m < n) PP.dot(ctx, T.X(x), T.Y(y), 2.5, null, C("--muted"));
    else PP.dot(ctx, T.X(x), T.Y(y), 2.2, C("--ink"));
  }
  const xn = XS[n];
  PP.dot(ctx, T.X(xn[0]), T.Y(xn[1]), 4.5, C("--accent"), C("--bg"));
  PP.label(ctx, "xₙ", T.X(xn[0]) + 6, T.Y(xn[1]) - 4, C("--accent"), "left", "bottom", 12);
  PP.label(ctx, "Aₙ", T.X(xn[0] + 1 / n) - 4, T.Y(xn[1]) + 4, C("--accent"), "right", "top", 13);
  PP.read(ID + "-ej3-read", [
    ["radio de Aₙ", "1/" + n + " = " + PP.fmt(1 / n, 3)],
    ["radio de Aₙ₊₁", "1/" + (n + 1) + " = " + PP.fmt(1 / (n + 1), 3)],
    ["centros de Aₙ₊₁", "xₘ con m ≥ " + (n + 1) + " (uno menos)"],
    ["Aₙ₊₁ ⊆ Aₙ", "sí", "good"],
    ["xₙ ∈ Aₙ (no vacío)", "sí", "good"],
  ]);
}, [ID + "-ej3-n"]);

PP.register(function drawEj3b() {
  const eps = PP.val(ID + "-ej3-eps") / 100;
  PP.out(ID + "-ej3-eps-o", PP.fmt(eps, 2));
  let n0 = 1;
  while (n0 < 400 && !(1 / n0 <= eps / 5 && TD[n0] < eps / 5)) n0++;
  const r = 1 / n0;
  const [m, j] = FAR[n0];
  const xm = XS[m], xj = XS[j];
  const dmj = dist(xm, xj) || 1e-9;
  const u = [(xm[0] - xj[0]) / dmj, (xm[1] - xj[1]) / dmj];
  const a = [xm[0] + 0.999 * r * u[0], xm[1] + 0.999 * r * u[1]];
  const ua = rot(u, 0.7), ub = rot(u, -0.7);
  const ap = [xm[0] + 0.5 * r * ua[0], xm[1] + 0.5 * r * ua[1]];
  const b = [xj[0] - 0.999 * r * u[0], xj[1] - 0.999 * r * u[1]];
  const bp = [xj[0] - 0.5 * r * ub[0], xj[1] - 0.5 * r * ub[1]];
  const { ctx, w, h } = PP.canvas(ID + "-ej3-c2", 0.78);
  const half = (RHO / n0 + r) * 1.18;
  const T = equalFrame(w, h, 0, 0, half, { l: 44 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 5 });
  unionFill(ctx, T, centersFrom(n0, n0 + 400), r, C("--area"));
  for (let k = n0; k <= n0 + 200; k++) PP.dot(ctx, T.X(XS[k][0]), T.Y(XS[k][1]), 2, C("--muted"));
  const P = (p) => [T.X(p[0]), T.Y(p[1])];
  PP.path(ctx, [P(a), P(b)], C("--muted"), 1, [4, 4]);
  const chain = [a, ap, xm, xj, bp, b];
  for (let i = 0; i < chain.length - 1; i++) PP.path(ctx, [P(chain[i]), P(chain[i + 1])], i % 2 ? C("--seq3") : C("--seq2"), 2.4);
  const names = ["a", "a′", "xₘ", "xⱼ", "b′", "b"];
  chain.forEach((p, i) => {
    const q = P(p);
    PP.dot(ctx, q[0], q[1], 4, i === 2 || i === 3 ? C("--ink") : C("--seq2"), C("--bg"));
    PP.label(ctx, names[i], q[0] + 6, q[1] + (i % 2 ? 14 : -6), C("--ink"), "left", i % 2 ? "top" : "bottom", 12);
  });
  const d1 = dist(a, ap), d2 = dist(ap, xm), d3 = dmj, d4 = dist(xj, bp), d5 = dist(bp, b);
  const tot = d1 + d2 + d3 + d4 + d5;
  const e5 = eps / 5;
  PP.read(ID + "-ej3-read2", [
    ["n₀ (1/n₀ ≤ ε/5)", n0 + "   (ε/5 = " + PP.fmt(e5, 3) + ")"],
    ["d(a, a′)", PP.fmt(d1, 3) + " < ε/5", d1 < e5 ? "good" : "bad"],
    ["d(a′, xₘ)", PP.fmt(d2, 3) + " < 1/n₀ = " + PP.fmt(r, 3), d2 < r ? "good" : "bad"],
    ["d(xₘ, xⱼ)", PP.fmt(d3, 3) + " < ε/5", d3 < e5 ? "good" : "bad"],
    ["d(xⱼ, b′)", PP.fmt(d4, 3) + " < 1/n₀", d4 < r ? "good" : "bad"],
    ["d(b′, b)", PP.fmt(d5, 3) + " < ε/5", d5 < e5 ? "good" : "bad"],
    ["suma", PP.fmt(tot, 3) + " < ε = " + PP.fmt(eps, 2), tot < eps ? "good" : "bad"],
    ["d(a, b)", PP.fmt(dist(a, b), 3) + " ≤ suma", "good"],
  ]);
}, [ID + "-ej3-eps"]);

PP.register(function drawEj3c() {
  const eps = PP.val(ID + "-ej3-eps3") / 100;
  PP.out(ID + "-ej3-eps3-o", PP.fmt(eps, 2));
  let n0 = 1;
  while (n0 < 400 && !(diamA(n0) < eps)) n0++;
  const { ctx, w, h } = PP.canvas(ID + "-ej3-c3", 0.78);
  const T = equalFrame(w, h, 0, 0, 2.8);
  PP.axes(ctx, T, { xTicks: 6, yTicks: 5 });
  unionFill(ctx, T, centersFrom(n0, n0 + 400), 1 / n0, C("--area"));
  PP.circle(ctx, T.X(0), T.Y(0), Math.abs(T.X(eps) - T.X(0)), C("--seq3"), null, [5, 4], 1.5);
  for (let m = 1; m <= 200; m++) {
    const [x, y] = XS[m];
    if (m < n0) PP.dot(ctx, T.X(x), T.Y(y), 2.8, null, C("--muted"));
    else PP.dot(ctx, T.X(x), T.Y(y), 2.4, C("--accent"));
  }
  PP.dot(ctx, T.X(0), T.Y(0), 4.5, C("--ok"), C("--bg"));
  PP.label(ctx, "x", T.X(0) + 6, T.Y(0) + 4, C("--ok"), "left", "top", 13);
  const xn = XS[n0];
  PP.label(ctx, "x" + "ₙ₀", T.X(xn[0]) + 6, T.Y(xn[1]) - 4, C("--accent"), "left", "bottom", 12);
  PP.label(ctx, "B(x, ε)", T.X(0), T.Y(eps) - 4, C("--seq3"), "center", "bottom", 12);
  const maxd = Math.hypot(xn[0], xn[1]);
  PP.read(ID + "-ej3-read3", [
    ["n₀", String(n0)],
    ["diam(Aₙ₀)", PP.fmt(diamA(n0), 3) + " < ε = " + PP.fmt(eps, 2), "good"],
    ["máx d(x, xₙ), n ≥ n₀", PP.fmt(maxd, 3) + " < ε", maxd < eps ? "good" : "bad"],
  ]);
}, [ID + "-ej3-eps3"]);

/* =================== Ejercicio 4 =================== */
const f4 = (x) => 0.4 + 0.3 * x;

PP.register(function drawEj4a() {
  const H = PP.val(ID + "-ej4-hh") / 100, wd = PP.val(ID + "-ej4-ww") / 100, r = PP.val(ID + "-ej4-r") / 100;
  PP.out(ID + "-ej4-hh-o", PP.fmt(H, 2)); PP.out(ID + "-ej4-ww-o", PP.fmt(wd, 2)); PP.out(ID + "-ej4-r-o", PP.fmt(r, 2));
  const tent = (x) => Math.max(0, 1 - Math.abs(x - 0.5) / wd);
  const g = (x) => f4(x) + H * tent(x);
  const N = 400;
  let d1 = 0, dinf = 0;
  for (let i = 0; i < N; i++) { const x = (i + 0.5) / N, v = Math.abs(g(x) - f4(x)); d1 += v / N; }
  for (let i = 0; i <= N; i++) dinf = Math.max(dinf, Math.abs(g(i / N) - f4(i / N)));
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.2, y1: 1.3 });
  PP.axes(ctx, T, { xLabel: "x", xTicks: 5, yTicks: 5 });
  const xs = []; for (let i = 0; i <= N; i++) xs.push(i / N);
  const sg = H >= 0 ? 1 : -1;
  // rectángulo "de altura d∞": entre f y f ± d∞
  PP.path(ctx, xs.map((x) => [T.X(x), T.Y(f4(x))]).concat(xs.slice().reverse().map((x) => [T.X(x), T.Y(f4(x) + sg * dinf)])), null, 0, null, true, C("--band"));
  // área entre f y g: d₁
  PP.path(ctx, xs.map((x) => [T.X(x), T.Y(f4(x))]).concat(xs.slice().reverse().map((x) => [T.X(x), T.Y(g(x))])), null, 0, null, true, C("--area2"));
  PP.path(ctx, xs.map((x) => [T.X(x), T.Y(f4(x) + dinf)]), C("--muted"), 1, [4, 4]);
  PP.path(ctx, xs.map((x) => [T.X(x), T.Y(f4(x) - dinf)]), C("--muted"), 1, [4, 4]);
  PP.path(ctx, xs.map((x) => [T.X(x), T.Y(f4(x))]), C("--accent"), 2.2);
  PP.path(ctx, xs.map((x) => [T.X(x), T.Y(g(x))]), C("--seq2"), 2.2);
  PP.label(ctx, "f", T.X(0.04), T.Y(f4(0.04)) - 4, C("--accent"), "left", "bottom", 13);
  PP.label(ctx, "g", T.X(0.5) + 6, T.Y(g(0.5)) + (H >= 0 ? -2 : 4), C("--seq2"), "left", H >= 0 ? "bottom" : "top", 13);
  PP.label(ctx, "f ± d∞", T.X(0.97), T.Y(f4(0.97) + dinf) - 3, C("--muted"), "right", "bottom", 11);
  const inInf = dinf < r, in1 = d1 < r;
  PP.read(ID + "-ej4-read", [
    ["d₁(f, g)", PP.fmt(d1, 3)],
    ["d∞(f, g)", PP.fmt(dinf, 3)],
    ["d₁ ≤ d∞", d1 <= dinf + 1e-12 ? "sí" : "no", d1 <= dinf + 1e-12 ? "good" : "bad"],
    ["g en la bola de d∞, radio r", inInf ? "sí" : "no", inInf ? "good" : "bad"],
    ["g en la bola de d₁, radio r", in1 ? "sí" : "no", in1 ? "good" : "bad"],
  ]);
}, [ID + "-ej4-hh", ID + "-ej4-ww", ID + "-ej4-r"]);

PP.register(function drawEj4b() {
  const hh = PP.val(ID + "-ej4-h") / 100;
  PP.out(ID + "-ej4-h-o", PP.fmt(hh, 2));
  const gh = (x) => Math.max(0, 1 - x / hh);
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c2", 0.6);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.15, y1: 1.25 });
  PP.axes(ctx, T, { xLabel: "x", xTicks: 5, yTicks: 5 });
  const N = 400, xs = []; for (let i = 0; i <= N; i++) xs.push(i / N);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(0), T.Y(1)], [T.X(hh), T.Y(0)]], null, 0, null, true, C("--area2"));
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(0)]], C("--accent"), 2.2);
  PP.path(ctx, xs.map((x) => [T.X(x), T.Y(gh(x))]), C("--seq2"), 2.2);
  PP.dot(ctx, T.X(0), T.Y(1), 5, C("--seq2"), C("--bg"));
  PP.dot(ctx, T.X(0), T.Y(0), 5, C("--accent"), C("--bg"));
  PP.label(ctx, "𝓔(gₕ) = gₕ(0) = 1", T.X(0) + 10, T.Y(1) - 2, C("--seq2"), "left", "bottom", 12);
  PP.label(ctx, "gₕ", T.X(Math.min(0.95, hh * 0.5)) + 8, T.Y(gh(Math.min(0.95, hh * 0.5))), C("--seq2"), "left", "bottom", 13);
  PP.label(ctx, "0 (la función nula)", T.X(0.98), T.Y(0) - 4, C("--accent"), "right", "bottom", 12);
  PP.read(ID + "-ej4-read2", [
    ["d₁(gₕ, 0)", "h/2 = " + PP.fmt(hh / 2, 3)],
    ["d∞(gₕ, 0)", "1"],
    ["|𝓔(gₕ) − 𝓔(0)|", "1", "bad"],
  ]);
}, [ID + "-ej4-h"]);
