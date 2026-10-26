/* Dibujos de los ejemplos alternativos de la Práctica 4, primera parte (bloques 1–5). Usa window.PP. */
const P = "ejp4alt";
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const fmt = (x, d) => PP.fmt(x, d === undefined ? 3 : d);

/* ---------- utilidades ---------- */

/* Color de un token (#rrggbb, #rgb o rgb[a](...)) como [r, g, b]. */
function rgbOf(tok) {
  const s = C(tok);
  if (s[0] === "#") {
    const h = s.length === 4 ? s.slice(1).split("").map((c) => c + c).join("") : s.slice(1, 7);
    return [0, 2, 4].map((i) => parseInt(h.slice(i, i + 2), 16));
  }
  const m = s.match(/rgba?\(([^)]+)\)/);
  return m ? m[1].split(",").slice(0, 3).map((v) => +v) : [128, 128, 128];
}
const mix = (a, b, t) => `rgb(${a.map((v, i) => Math.round(v + (b[i] - v) * t)).join(",")})`;

/* Marco con la misma escala en los dos ejes, centrado en (xc, yc), que muestra al menos [xc − half, xc + half] × [yc − half, yc + half]. */
function sqFrame(w, h, xc, yc, half, pad) {
  const p = Object.assign({ l: 34, r: 10, t: 10, b: 26 }, pad || {});
  const aw = w - p.l - p.r, ah = h - p.t - p.b;
  const s = Math.min(aw, ah) / (2 * half);
  const hx = aw / (2 * s), hy = ah / (2 * s);
  return PP.frame(w, h, { x0: xc - hx, x1: xc + hx, y0: yc - hy, y1: yc + hy }, p);
}

/* Recorta el dibujo al área del gráfico. */
function clip(ctx, T) {
  ctx.save();
  ctx.beginPath();
  ctx.rect(T.p.l, T.p.t, T.w - T.p.l - T.p.r, T.h - T.p.t - T.p.b);
  ctx.clip();
}

/* Mapa de colores de fn: azul positivo, naranja negativo, fondo cerca de 0. */
function heat(ctx, T, fn, vmax, cell) {
  const bg = rgbOf("--bg"), pos = rgbOf("--accent"), neg = rgbOf("--seq2");
  const c = cell || 4;
  const xa = T.p.l, xb = T.w - T.p.r, ya = T.p.t, yb = T.h - T.p.b;
  for (let px = xa; px < xb; px += c) {
    for (let py = ya; py < yb; py += c) {
      const v = fn(T.iX(px + c / 2), T.iY(py + c / 2));
      if (!isFinite(v)) continue;
      const t = Math.min(1, Math.abs(v) / vmax) * 0.85;
      ctx.fillStyle = mix(bg, v >= 0 ? pos : neg, t);
      ctx.fillRect(px, py, Math.min(c, xb - px) + 0.4, Math.min(c, yb - py) + 0.4);
    }
  }
}

/* Gráfico de y = fn(x) en [x0, x1], cortando el trazo donde se va del rango o salta. */
function plotFn(ctx, T, fn, x0, x1, color, width, dash, n) {
  const N = n || 600;
  let pts = [];
  const flush = () => { if (pts.length > 1) PP.path(ctx, pts, color, width || 2, dash); pts = []; };
  let prev = null;
  for (let i = 0; i <= N; i++) {
    const x = x0 + (x1 - x0) * i / N;
    const y = fn(x);
    if (!isFinite(y) || y > T.box.y1 + 0.5 * (T.box.y1 - T.box.y0) || y < T.box.y0 - 0.5 * (T.box.y1 - T.box.y0)) { flush(); prev = null; continue; }
    if (prev !== null && Math.abs(y - prev) > 0.6 * (T.box.y1 - T.box.y0)) flush();
    pts.push([T.X(x), T.Y(y)]);
    prev = y;
  }
  flush();
}

/* Intervalos (aproximados por bisección) donde pred(x) es verdadero, dentro de [x0, x1]. */
function runs(pred, val, x0, x1, N) {
  const n = N || 1600, out = [];
  let start = null;
  const edge = (a, b) => { // a cumple, b no (o al revés): bisección sobre el valor
    let lo = a, hi = b; const pa = pred(lo);
    for (let k = 0; k < 40; k++) { const m = (lo + hi) / 2; if (pred(m) === pa) lo = m; else hi = m; }
    return (lo + hi) / 2;
  };
  let prevX = x0, prevIn = pred(x0);
  if (prevIn) start = { x: x0, open: false, border: true };
  for (let i = 1; i <= n; i++) {
    const x = x0 + (x1 - x0) * i / n, inn = pred(x);
    if (inn && !prevIn) start = { x: edge(prevX, x), border: false };
    if (!inn && prevIn) { out.push({ a: start.x, b: edge(prevX, x), ba: start.border, bb: false }); start = null; }
    prevX = x; prevIn = inn;
  }
  if (start) out.push({ a: start.x, b: x1, ba: start.border, bb: true });
  return out;
}

/* Raíces de fn en [x0, x1] por cambio de signo. */
function roots(fn, x0, x1, N) {
  const n = N || 1200, out = [];
  let px = x0, pv = fn(x0);
  for (let i = 1; i <= n; i++) {
    const x = x0 + (x1 - x0) * i / n, v = fn(x);
    if (pv === 0) out.push(px);
    else if (pv * v < 0) {
      let lo = px, hi = x;
      for (let k = 0; k < 50; k++) { const m = (lo + hi) / 2; if (fn(lo) * fn(m) <= 0) hi = m; else lo = m; }
      out.push((lo + hi) / 2);
    }
    px = x; pv = v;
  }
  return out;
}

/* Un intervalo sobre una recta horizontal en la altura py (px): extremos llenos (cerrado) o vacíos (abierto); sin marca en los bordes de la ventana. */
function segment(ctx, T, a, b, py, color, closed, ba, bb) {
  PP.path(ctx, [[T.X(a), py], [T.X(b), py]], color, 4);
  const bgc = C("--bg");
  if (!ba) PP.dot(ctx, T.X(a), py, 4.2, closed ? color : bgc, color);
  if (!bb) PP.dot(ctx, T.X(b), py, 4.2, closed ? color : bgc, color);
}

/* Arrastre de puntos (como en los parciales). */
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
    if (active !== null) { cv.setPointerCapture(e.pointerId); cv.style.cursor = "grabbing"; e.preventDefault(); move(active, T.iX(px), T.iY(py), T); redraw(); }
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

const intStr = (rs, closed) => rs.length === 0 ? "∅" : rs.map((r) => {
  const l = r.ba ? "(…" : (closed ? "[" : "(") + fmt(r.a, 2);
  const u = r.bb ? "…)" : fmt(r.b, 2) + (closed ? "]" : ")");
  return l + ", " + u;
}).join(" ∪ ");

/* ===================== Bloque 1 ===================== */

/* O2-3: f a trozos en R², con un punto arrastrable. */
(function () {
  const id = P + "-o2-3";
  const st = { x: 0.9, y: -0.5 };
  let TT = null;
  const f1 = (x, y) => x * x - 2 * x * y + y * y + 2;
  const f2 = (x, y) => { const u = x - y; return (u * u * u - 3 * u * u + 2 * x * x + 2 * y * y + 2) / (x * x + y * y + 1); };
  const f = (x, y) => (x >= y ? f1(x, y) : f2(x, y));
  function draw() {
    const { ctx, w, h } = PP.canvas(id + "-c", 0.82);
    const T = sqFrame(w, h, 0, 0, 2, { l: 30, r: 10, t: 10, b: 24 });
    TT = T;
    heat(ctx, T, (x, y) => f(x, y) - 2, 3, 4);
    PP.axes(ctx, T, { grid: false, xLabel: "x", yLabel: "y" });
    clip(ctx, T);
    PP.path(ctx, [[T.X(-5), T.Y(-5)], [T.X(5), T.Y(5)]], C("--ink"), 2, [6, 4]);
    ctx.restore();
    PP.label(ctx, "C₁ : x ≥ y", T.X(1.0), T.Y(-1.6), C("--ink"), "left", "middle", 13);
    PP.label(ctx, "C₂ : x ≤ y", T.X(-1.9), T.Y(1.6), C("--ink"), "left", "middle", 13);
    PP.label(ctx, "x = y", T.X(1.55), T.Y(1.75), C("--ink"), "right", "middle", 12);
    PP.dot(ctx, T.X(st.x), T.Y(st.y), 6.5, C("--panel"), C("--ink"));
    const br = st.x >= st.y ? "1.ª (x ≥ y)" : "2.ª (x ≤ y)";
    PP.read(id + "-read", [
      ["punto", `(${fmt(st.x, 2)}, ${fmt(st.y, 2)})`],
      ["fórmula de 1.ª rama", fmt(f1(st.x, st.y), 3)],
      ["fórmula de 2.ª rama", fmt(f2(st.x, st.y), 3)],
      ["rama que vale", br],
      ["en (t, t)", "las dos dan 2"],
    ]);
  }
  PP.register(draw, []);
  draggable(id + "-c", () => TT, () => 0, (k, x, y, T) => {
    st.x = clamp(x, T.box.x0, T.box.x1); st.y = clamp(y, T.box.y0, T.box.y1);
    if (Math.abs(st.x - st.y) < 0.04) st.y = st.x; // imán sobre la recta
  }, draw);
})();

/* O16-5: 1/x en (0, 1], f(0) = 1, con el trozo sobre [1/n, 1]. */
PP.register(function o16_5() {
  const id = P + "-o16-5";
  const n = PP.val(id + "-n");
  PP.out(id + "-n-o", String(n));
  const { ctx, w, h } = PP.canvas(id + "-c", 0.7);
  const T = PP.frame(w, h, { x0: -0.06, x1: 1.06, y0: 0, y1: 13.5 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "f(x)" });
  const a = 1 / n;
  PP.rect(ctx, T.X(a), T.p.t, T.X(1) - T.X(a), T.h - T.p.b - T.p.t, null, C("--band"));
  plotFn(ctx, T, (x) => 1 / x, 1 / 13.5, 1, C("--muted"), 1.5, [4, 4]);
  plotFn(ctx, T, (x) => 1 / x, a, 1, C("--accent"), 3);
  segment(ctx, T, a, 1, T.h - T.p.b - 4, C("--accent"), true);
  PP.dot(ctx, T.X(0), T.Y(1), 5.5, C("--ok"));
  PP.label(ctx, "f(0) = 1", T.X(0) + 9, T.Y(1) - 4, C("--ok"), "left", "bottom", 12);
  if (n <= 13) {
    PP.dot(ctx, T.X(a), T.Y(n), 5, C("--accent"));
    PP.label(ctx, `(1/${n}, ${n})`, T.X(a) + 8, T.Y(n), C("--accent"), "left", "middle", 12);
  }
  PP.read(id + "-read", [
    ["A_n", `[1/${n}, 1] = [${fmt(a, 3)}, 1]`],
    ["f(1/n)", String(n)],
    ["f(0)", "1"],
    ["distancia de 1/n a 0", fmt(a, 3)],
  ]);
}, [P + "-o16-5-n"]);

/* O16-6: max{f, g}, A₁ = {f ≤ g}, A₂ = {g ≤ f}. */
PP.register(function o16_6() {
  const id = P + "-o16-6";
  const c = PP.val(id + "-c0") / 100;
  PP.out(id + "-c0-o", fmt(c, 2));
  const f = (x) => Math.sin(x), g = (x) => 0.35 * (x - 2) + c;
  const m = (x) => Math.max(f(x), g(x));
  const { ctx, w, h } = PP.canvas(id + "-c", 0.72);
  const T = PP.frame(w, h, { x0: -1, x1: 6, y0: -2.6, y1: 2.6 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xLabel: "x" });
  clip(ctx, T);
  plotFn(ctx, T, f, -1, 6, C("--accent"), 1.5);
  plotFn(ctx, T, g, -1, 6, C("--seq2"), 1.5);
  plotFn(ctx, T, m, -1, 6, C("--ink"), 3.5);
  ctx.restore();
  const yA1 = T.Y(-1.95), yA2 = T.Y(-2.3);
  const r1 = runs((x) => f(x) <= g(x), null, -1, 6), r2 = runs((x) => g(x) <= f(x), null, -1, 6);
  r1.forEach((r) => segment(ctx, T, r.a, r.b, yA1, C("--seq2"), true, r.ba, r.bb));
  r2.forEach((r) => segment(ctx, T, r.a, r.b, yA2, C("--accent"), true, r.ba, r.bb));
  PP.label(ctx, "A₁", T.p.l + 4, yA1 - 6, C("--seq2"), "left", "bottom", 12);
  PP.label(ctx, "A₂", T.p.l + 4, yA2 + 6, C("--accent"), "left", "top", 12);
  const zs = roots((x) => f(x) - g(x), -1, 6);
  zs.forEach((z) => {
    PP.path(ctx, [[T.X(z), T.Y(f(z))], [T.X(z), yA2]], C("--muted"), 1, [3, 3]);
    PP.dot(ctx, T.X(z), T.Y(f(z)), 4.5, C("--ink"));
    PP.dot(ctx, T.X(z), yA1, 3.5, C("--ink"));
    PP.dot(ctx, T.X(z), yA2, 3.5, C("--ink"));
  });
  PP.label(ctx, "f", T.X(5.7), T.Y(f(5.7)) - 6, C("--accent"), "center", "bottom", 13);
  PP.label(ctx, "g", T.X(5.7), T.Y(g(5.7)) - 6, C("--seq2"), "center", "bottom", 13);
  PP.read(id + "-read", [
    ["c", fmt(c, 2)],
    ["A₁ ∩ A₂ = {f = g}", zs.length ? zs.map((z) => fmt(z, 2)).join(", ") : "∅ en la ventana"],
  ]);
}, [P + "-o16-6-c0"]);

/* ===================== Bloque 2 ===================== */

const fxy = (x, y) => (x === 0 && y === 0 ? 0 : (x * y) / (x * x + y * y));

/* O6-3 b): secciones y ↦ f(x₀, y). */
PP.register(function o6_3() {
  const id = P + "-o6-3";
  const x0 = PP.val(id + "-x0") / 100;
  PP.out(id + "-x0-o", fmt(x0, 2));
  const { ctx, w, h } = PP.canvas(id + "-c", 0.62);
  const T = PP.frame(w, h, { x0: -2, x1: 2, y0: -0.65, y1: 0.65 }, { l: 40, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xLabel: "y", yLabel: "f(x₀, y)" });
  [0.5, -0.5].forEach((v) => PP.path(ctx, [[T.p.l, T.Y(v)], [T.w - T.p.r, T.Y(v)]], C("--muted"), 1, [4, 4]));
  plotFn(ctx, T, (y) => fxy(x0, y), -2, 2, C("--accent"), 2.5, null, 1200);
  if (x0 !== 0) {
    PP.dot(ctx, T.X(x0), T.Y(0.5), 4.5, C("--seq2"));
    PP.dot(ctx, T.X(-x0), T.Y(-0.5), 4.5, C("--seq2"));
  }
  PP.read(id + "-read", [
    ["x₀", fmt(x0, 2)],
    ["f(x₀, 0)", "0"],
    ["f(x₀, x₀)", x0 === 0 ? "0 (es f(0, 0))" : "1/2"],
  ]);
}, [P + "-o6-3-x0"]);

/* O17-5: mapa de xy/(x² + y²) y la sucesión (1/k, 1/k). */
PP.register(function o17_5() {
  const id = P + "-o17-5";
  const n = PP.val(id + "-n");
  PP.out(id + "-n-o", String(n));
  const { ctx, w, h } = PP.canvas(id + "-c", 0.82);
  const T = sqFrame(w, h, 0, 0, 1.05);
  heat(ctx, T, fxy, 0.5, 4);
  PP.axes(ctx, T, { grid: false, xLabel: "x", yLabel: "y" });
  for (let k = 1; k <= n; k++) PP.dot(ctx, T.X(1 / k), T.Y(1 / k), k === n ? 5 : 3.2, C("--ink"));
  PP.circle(ctx, T.X(0), T.Y(0), 7, C("--ok"), null, null, 2.5);
  PP.read(id + "-read", [
    ["último término", `(1/${n}, 1/${n})`],
    ["f(1/k, 1/k)", "1/2 para todo k"],
    ["f(0, 0)", "0"],
  ]);
}, [P + "-o17-5-n"]);

/* O14-1: f, g, h con un camino al origen. */
PP.register(function o14_1() {
  const id = P + "-o14-1";
  const fn = PP.radio(id + "-fn"), path = PP.radio(id + "-path");
  const lam = PP.val(id + "-lam") / 100;
  PP.out(id + "-lam-o", fmt(lam, 2));
  const F = {
    f: fxy,
    g: (x, y) => (x === 0 && y === 0 ? 0 : (x * x * y) / (x * x + y ** 4)),
    h: (x, y) => (x === 0 && y === 0 ? 0 : (x * y * y) / (x * x + y ** 4)),
  }[fn];
  const { ctx, w, h } = PP.canvas(id + "-c", 0.82);
  const T = sqFrame(w, h, 0, 0, 1.05);
  heat(ctx, T, F, 0.5, 4);
  PP.axes(ctx, T, { grid: false, xLabel: "x", yLabel: "y" });
  clip(ctx, T);
  const ptsOf = path === "recta" ? (t) => [t, lam * t] : (t) => [t * t, t];
  const pts = [];
  for (let i = -300; i <= 300; i++) { const t = i / 200; const [x, y] = ptsOf(t); pts.push([T.X(x), T.Y(y)]); }
  PP.path(ctx, pts, C("--ink"), 2.2, [6, 4]);
  ctx.restore();
  const ts = [0.5, 0.1, 0.01, 0.001];
  ts.forEach((t, i) => { if (i < 2) { const [x, y] = ptsOf(t); PP.dot(ctx, T.X(x), T.Y(y), 4, C("--ink")); } });
  PP.circle(ctx, T.X(0), T.Y(0), 6, C("--ok"), null, null, 2.5);
  const rows = ts.map((t) => { const [x, y] = ptsOf(t); return [`t = ${t}`, fmt(F(x, y), 4)]; });
  if (fn === "f" && path === "recta") rows.push(["λ/(1 + λ²)", fmt(lam / (1 + lam * lam), 4)]);
  rows.push([fn + "(0, 0)", "0"]);
  PP.read(id + "-read", rows);
}, ["input[name='" + P + "-o14-1-fn']", "input[name='" + P + "-o14-1-path']", P + "-o14-1-lam"]);

/* O14-2: corte y = −a, o la curva φ(t) = (t, −t + t³). */
PP.register(function o14_2() {
  const id = P + "-o14-2";
  const mode = PP.radio(id + "-m");
  let a = PP.val(id + "-a") / 100;
  if (Math.abs(a) < 0.05) a = a < 0 ? -0.05 : 0.05;
  PP.out(id + "-a-o", fmt(a, 2));
  const f = (x, y) => { const s = x + y; return s === 0 ? 0 : ((x * x + y * y) * Math.sin(s)) / (s * s); };
  const { ctx, w, h } = PP.canvas(id + "-c", 0.66);
  const lim = 20;
  if (mode === "corte") {
    const T = PP.frame(w, h, { x0: a - 1, x1: a + 1, y0: -lim, y1: lim }, { l: 40, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yLabel: "f(x, −a)" });
    clip(ctx, T);
    PP.path(ctx, [[T.X(a), T.p.t], [T.X(a), T.h - T.p.b]], C("--muted"), 1.5, [5, 4]);
    plotFn(ctx, T, (x) => (Math.abs(x - a) < 1e-9 ? NaN : f(x, -a)), a - 1, a + 1, C("--accent"), 2.5, null, 1600);
    ctx.restore();
    PP.label(ctx, "x = a", T.X(a) - 4, T.p.t + 2, C("--muted"), "right", "top", 12);
    PP.read(id + "-read", [
      ["a", fmt(a, 2)],
      ["f(a + 0.1, −a)", fmt(f(a + 0.1, -a), 2)],
      ["f(a + 0.01, −a)", fmt(f(a + 0.01, -a), 2)],
      ["f(a − 0.01, −a)", fmt(f(a - 0.01, -a), 2)],
    ]);
  } else {
    const T = PP.frame(w, h, { x0: -1, x1: 1, y0: -lim, y1: lim }, { l: 40, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "t", yLabel: "(f∘φ)(t)" });
    clip(ctx, T);
    plotFn(ctx, T, (t) => (t === 0 ? NaN : f(t, -t + t * t * t)), -1, 1, C("--seq2"), 2.5, null, 1601);
    ctx.restore();
    PP.read(id + "-read", [
      ["(f∘φ)(0.1)", fmt(f(0.1, -0.1 + 0.001), 2)],
      ["(f∘φ)(0.01)", fmt(f(0.01, -0.01 + 1e-6), 2)],
      ["(f∘φ)(−0.01)", fmt(f(-0.01, 0.01 - 1e-6), 2)],
      ["f(0, 0)", "0"],
    ]);
  }
}, ["input[name='" + P + "-o14-2-m']", P + "-o14-2-a"]);

/* O14-3: mapa de f y una circunferencia de radio r. */
PP.register(function o14_3() {
  const id = P + "-o14-3";
  const r = PP.val(id + "-r") / 100;
  PP.out(id + "-r-o", fmt(r, 2));
  const f = (x, y) => (x === 0 && y === 0 ? 0 : (y * Math.log(1 + x * x)) / (x * x + y * y));
  const { ctx, w, h } = PP.canvas(id + "-c", 0.82);
  const T = sqFrame(w, h, 0, 0, 1.05);
  heat(ctx, T, f, 0.3, 4);
  PP.axes(ctx, T, { grid: false, xLabel: "x", yLabel: "y" });
  const s = T.X(1) - T.X(0);
  PP.circle(ctx, T.X(0), T.Y(0), r * s, C("--ink"), null, [5, 4], 2);
  let mx = 0;
  for (let i = 0; i < 720; i++) { const th = (i * Math.PI) / 360; mx = Math.max(mx, Math.abs(f(r * Math.cos(th), r * Math.sin(th)))); }
  PP.read(id + "-read", [
    ["r", fmt(r, 2)],
    ["máx |f| en la circunferencia", fmt(mx, 4)],
    ["f(0, 0)", "0"],
  ]);
}, [P + "-o14-3-r"]);

/* ===================== Bloque 3 ===================== */

/* O2-4: bola de d∞ y su proyección; la hipérbola y su proyección. */
(function () {
  const id = P + "-o2-4";
  const st = { x: 1.2, y: 1.4 };
  let TT = null;
  function draw() {
    const mode = PP.radio(id + "-m");
    const r = PP.val(id + "-r") / 100;
    PP.out(id + "-r-o", fmt(r, 2));
    const { ctx, w, h } = PP.canvas(id + "-c", 0.75);
    const T = sqFrame(w, h, 1.6, 1.4, 1.9, { l: 30, r: 10, t: 10, b: 30 });
    TT = T;
    PP.axes(ctx, T, { xLabel: "x", yLabel: "y" });
    const y0 = T.Y(0);
    if (mode === "abierta") {
      const a = st.x - r, b = st.x + r;
      PP.rect(ctx, T.X(a), T.Y(st.y + r), T.X(b) - T.X(a), T.Y(st.y - r) - T.Y(st.y + r), C("--accent"), C("--area"));
      PP.path(ctx, [[T.X(a), T.Y(st.y - r)], [T.X(a), y0]], C("--muted"), 1, [3, 3]);
      PP.path(ctx, [[T.X(b), T.Y(st.y - r)], [T.X(b), y0]], C("--muted"), 1, [3, 3]);
      segment(ctx, T, a, b, y0, C("--seq2"), false);
      PP.dot(ctx, T.X(st.x), T.Y(st.y), 6, C("--panel"), C("--ink"));
      PP.label(ctx, "proyección: (x − r, x + r)", T.X(st.x), y0 + 16, C("--seq2"), "center", "top", 12);
      PP.read(id + "-read", [
        ["centro (x, y)", `(${fmt(st.x, 2)}, ${fmt(st.y, 2)})`],
        ["B((x, y), r)", `(${fmt(a, 2)}, ${fmt(b, 2)}) × (${fmt(st.y - r, 2)}, ${fmt(st.y + r, 2)})`],
        ["proyección de B", `(${fmt(a, 2)}, ${fmt(b, 2)})`, "good"],
      ]);
    } else {
      clip(ctx, T);
      plotFn(ctx, T, (x) => 1 / x, 0.02, T.box.x1, C("--accent"), 3, null, 1200);
      ctx.restore();
      PP.path(ctx, [[T.X(0), y0], [T.w - T.p.r, y0]], C("--seq2"), 4);
      PP.dot(ctx, T.X(0), y0, 4.5, C("--bg"), C("--seq2"));
      [0.35, 0.6, 1, 1.8, 3].forEach((x) => { if (T.Y(1 / x) > T.p.t) PP.path(ctx, [[T.X(x), T.Y(1 / x)], [T.X(x), y0]], C("--muted"), 1, [3, 3]); });
      PP.label(ctx, "y = 1/x, x > 0 (cerrado)", T.X(1.15), T.Y(2.6), C("--accent"), "left", "middle", 12);
      PP.label(ctx, "proyección (0, ∞)", T.X(1.6), y0 + 16, C("--seq2"), "left", "top", 12);
      PP.read(id + "-read", [
        ["conjunto", "{(x, y) : x > 0, y = 1/x}"],
        ["proyección", "(0, ∞)"],
        ["¿0 ∈ (0, ∞)?", "no", "bad"],
      ]);
    }
  }
  PP.register(draw, ["input[name='" + P + "-o2-4-m']", P + "-o2-4-r"]);
  draggable(id + "-c", () => (PP.radio(id + "-m") === "abierta" ? TT : null), () => 0, (k, x, y, T) => {
    st.x = clamp(x, T.box.x0 + 0.1, T.box.x1 - 0.1); st.y = clamp(y, 0.2, T.box.y1 - 0.1);
  }, draw);
})();

/* O7-3 y O17-4: franja V = (a, b) y su preimagen. */
function preimageDraw(id, salto) {
  return function () {
    const a = PP.val(id + "-a") / 100, b = PP.val(id + "-b") / 100;
    PP.out(id + "-a-o", fmt(a, 2)); PP.out(id + "-b-o", fmt(b, 2));
    const showImg = !salto && document.getElementById(id + "-img").checked;
    const { ctx, w, h } = PP.canvas(id + "-c", 0.72);
    const T = PP.frame(w, h, { x0: -2.2, x1: 2.2, y0: -0.7, y1: 3.8 }, { l: 34, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yLabel: "y" });
    const ok = a < b;
    if (ok) {
      const ya = clamp(a, T.box.y0, T.box.y1), yb = clamp(b, T.box.y0, T.box.y1);
      PP.rect(ctx, T.p.l, T.Y(yb), T.w - T.p.l - T.p.r, T.Y(ya) - T.Y(yb), null, C("--band"));
      [a, b].forEach((v) => { if (v > T.box.y0 && v < T.box.y1) PP.path(ctx, [[T.p.l, T.Y(v)], [T.w - T.p.r, T.Y(v)]], C("--accent"), 1.2, [5, 4]); });
      PP.label(ctx, "V", T.w - T.p.r - 6, T.Y(Math.min(b, T.box.y1)) + 4, C("--accent"), "right", "top", 13);
    }
    clip(ctx, T);
    plotFn(ctx, T, (x) => x * x, -2.2, 2.2, C("--ink"), 2.2);
    ctx.restore();
    // la preimagen
    const q = (x) => ok && x * x > a && x * x < b;
    let rs = ok ? runs(q, null, -2.2, 2.2, 2200) : [];
    let pts = [];
    if (salto) {
      // f(0) = 1: se saca el 0 de los intervalos si 1 ∉ V y se agrega si 1 ∈ V
      const inV1 = ok && 1 > a && 1 < b;
      const out = [];
      rs.forEach((r) => {
        if (r.a < 0 && r.b > 0) {
          if (inV1) out.push(r);
          else { out.push({ a: r.a, b: 0, ba: r.ba, bb: false }); out.push({ a: 0, b: r.b, ba: false, bb: r.bb }); }
        } else out.push(r);
      });
      rs = out;
      if (inV1 && !rs.some((r) => r.a < 0 && r.b > 0)) pts.push(0);
      PP.dot(ctx, T.X(0), T.Y(0), 4.5, C("--bg"), C("--ink"));
      PP.dot(ctx, T.X(0), T.Y(1), 4.5, C("--ink"));
      PP.label(ctx, "f(0) = 1", T.X(0) + 8, T.Y(1) - 4, C("--ink"), "left", "bottom", 12);
    }
    const yAx = T.Y(0);
    rs.forEach((r) => {
      [r.a, r.b].forEach((x, i) => { if (!(i === 0 ? r.ba : r.bb)) PP.path(ctx, [[T.X(x), T.Y(x * x)], [T.X(x), yAx]], C("--muted"), 1, [3, 3]); });
      segment(ctx, T, r.a, r.b, yAx, C("--seq2"), false, r.ba, r.bb);
    });
    pts.forEach((x) => { PP.path(ctx, [[T.X(x), T.Y(1)], [T.X(x), yAx]], C("--muted"), 1, [3, 3]); PP.dot(ctx, T.X(x), yAx, 5, C("--seq2")); });
    if (showImg) {
      segment(ctx, T, -1, 1, yAx + 12, C("--ok"), false);
      const xA = T.X(-2.05);
      PP.path(ctx, [[xA, T.Y(0)], [xA, T.Y(1)]], C("--ok"), 4);
      PP.dot(ctx, xA, T.Y(0), 4.2, C("--ok"), C("--ok"));
      PP.dot(ctx, xA, T.Y(1), 4.2, C("--bg"), C("--ok"));
      PP.label(ctx, "g((−1, 1)) = [0, 1)", xA + 8, T.Y(1) - 4, C("--ok"), "left", "bottom", 12);
    }
    const desc = !ok ? "∅ (a ≥ b)" : (rs.length || pts.length)
      ? rs.map((r) => `(${fmt(r.a, 3)}, ${fmt(r.b, 3)})`).concat(pts.map(() => "{0}")).join(" ∪ ")
      : "∅";
    const rows = [["V", ok ? `(${fmt(a, 2)}, ${fmt(b, 2)})` : "∅"], [salto ? "f⁻¹(V)" : "g⁻¹(V)", desc]];
    if (salto) rows.push(["¿abierto?", pts.length ? "no: 0 está aislado" : "sí", pts.length ? "bad" : "good"]);
    PP.read(id + "-read", rows);
  };
}
PP.register(preimageDraw(P + "-o7-3", false), [P + "-o7-3-a", P + "-o7-3-b", P + "-o7-3-img"]);
PP.register(preimageDraw(P + "-o17-4", true), [P + "-o17-4-a", P + "-o17-4-b"]);

/* ===================== Bloque 4 ===================== */

/* O6-2: Dirichlet y una sucesión del otro tipo. */
PP.register(function o6_2() {
  const id = P + "-o6-2";
  const rac = PP.radio(id + "-c0") === "q";
  const n = PP.val(id + "-n");
  PP.out(id + "-n-o", String(n));
  const c = rac ? 0.5 : Math.SQRT2 / 2;
  const xs = [];
  for (let k = 1; k <= n; k++) xs.push(rac ? 0.5 + Math.SQRT2 / (4 * k) : Math.floor(c * 10 ** k) / 10 ** k);
  const { ctx, w, h } = PP.canvas(id + "-c", 0.6);
  const T = PP.frame(w, h, { x0: 0.3, x1: 0.9, y0: -0.25, y1: 1.3 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "f(x)" });
  PP.path(ctx, [[T.p.l, T.Y(1)], [T.w - T.p.r, T.Y(1)]], C("--accent"), 2, [2, 4]);
  PP.path(ctx, [[T.p.l, T.Y(0)], [T.w - T.p.r, T.Y(0)]], C("--seq2"), 2, [2, 4]);
  PP.label(ctx, "1 sobre ℚ", T.w - T.p.r - 4, T.Y(1) - 5, C("--accent"), "right", "bottom", 12);
  PP.label(ctx, "0 sobre ℝ ∖ ℚ", T.w - T.p.r - 4, T.Y(0) - 5, C("--seq2"), "right", "bottom", 12);
  PP.path(ctx, [[T.X(c), T.p.t], [T.X(c), T.h - T.p.b]], C("--muted"), 1, [4, 4]);
  const fc = rac ? 1 : 0, fx = rac ? 0 : 1;
  xs.forEach((x, i) => {
    const big = i === xs.length - 1;
    PP.dot(ctx, T.X(x), T.Y(fx), big ? 5.5 : 3.5, rac ? C("--seq2") : C("--accent"));
  });
  PP.circle(ctx, T.X(c), T.Y(fc), 8, C("--ok"), null, null, 2.5);
  PP.label(ctx, "c", T.X(c) + 4, T.h - T.p.b - 4, C("--muted"), "left", "bottom", 12);
  const xn = xs[xs.length - 1];
  PP.read(id + "-read", [
    ["c", rac ? "1/2" : "√2/2 ≈ " + fmt(c, 6)],
    ["x_n", rac ? `1/2 + √2/${4 * n} ≈ ${fmt(xn, 6)}` : fmt(xn, n)],
    ["|x_n − c|", fmt(Math.abs(xn - c), 7)],
    ["f(x_n)", String(fx)],
    ["f(c)", String(fc)],
  ]);
}, ["input[name='" + P + "-o6-2-c0']", P + "-o6-2-n"]);

/* O16-3: x en ℚ, −x fuera; entornos U y V. */
PP.register(function o16_3() {
  const id = P + "-o16-3";
  const x0 = PP.val(id + "-x") / 100, d = PP.val(id + "-d") / 100;
  PP.out(id + "-x-o", fmt(x0, 2)); PP.out(id + "-d-o", fmt(d, 2));
  const { ctx, w, h } = PP.canvas(id + "-c", 0.72);
  const T = PP.frame(w, h, { x0: -2.6, x1: 2.6, y0: -2.6, y1: 2.6 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "y" });
  const V = x0 === 0 ? [-d, d] : x0 > 0 ? [x0 / 2, (3 * x0) / 2] : [(3 * x0) / 2, x0 / 2];
  PP.rect(ctx, T.p.l, T.Y(V[1]), T.w - T.p.l - T.p.r, T.Y(V[0]) - T.Y(V[1]), null, C("--okband"));
  PP.label(ctx, "V", T.p.l + 4, T.Y(V[1]) + 3, C("--ok"), "left", "top", 13);
  clip(ctx, T);
  PP.path(ctx, [[T.X(-3), T.Y(-3)], [T.X(3), T.Y(3)]], C("--accent"), 1.6, [2, 4]);
  PP.path(ctx, [[T.X(-3), T.Y(3)], [T.X(3), T.Y(-3)]], C("--seq2"), 1.6, [2, 4]);
  const a = x0 - d, b = x0 + d;
  PP.path(ctx, [[T.X(a), T.Y(a)], [T.X(b), T.Y(b)]], C("--accent"), 5);
  PP.path(ctx, [[T.X(a), T.Y(-a)], [T.X(b), T.Y(-b)]], C("--seq2"), 5);
  ctx.restore();
  segment(ctx, T, a, b, T.Y(0), C("--ink"), false);
  PP.label(ctx, "U", T.X(x0), T.Y(0) + 8, C("--ink"), "center", "top", 13);
  PP.dot(ctx, T.X(x0), T.Y(x0), 4.5, C("--ink"));
  const inV = (y) => y > V[0] - 1e-12 && y < V[1] + 1e-12;
  const qOk = inV(a) && inV(b), iOk = inV(-a) && inV(-b);
  PP.read(id + "-read", [
    ["x₀", fmt(x0, 2)],
    ["V", `(${fmt(V[0], 2)}, ${fmt(V[1], 2)})`],
    ["U", `(${fmt(a, 2)}, ${fmt(b, 2)})`],
    ["imagen de U ∩ ℚ ⊆ V", qOk ? "sí" : "no", qOk ? "good" : "bad"],
    ["imagen de U ∖ ℚ ⊆ V", iOk ? "sí" : "no", iOk ? "good" : "bad"],
  ]);
}, [P + "-o16-3-x", P + "-o16-3-d"]);

/* ===================== Bloque 5 ===================== */

/* O6-4: {f = 0}, {f ≥ 0}, {f > 0} para f = 1 − x² − y² + x³/2. */
PP.register(function o6_4() {
  const id = P + "-o6-4";
  const mode = PP.radio(id + "-m");
  const f = (x, y) => 1 - x * x - y * y + (x * x * x) / 2;
  const { ctx, w, h } = PP.canvas(id + "-c", 0.82);
  const T = sqFrame(w, h, 0, 0, 2);
  PP.axes(ctx, T, { xLabel: "x", yLabel: "y" });
  const c = 3;
  const xa = T.p.l, xb = T.w - T.p.r, ya = T.p.t, yb = T.h - T.p.b;
  if (mode !== "cero") {
    ctx.fillStyle = C("--area");
    for (let px = xa; px < xb; px += c) for (let py = ya; py < yb; py += c) {
      const v = f(T.iX(px + c / 2), T.iY(py + c / 2));
      if (v > 0) ctx.fillRect(px, py, Math.min(c, xb - px) + 0.4, Math.min(c, yb - py) + 0.4);
    }
  }
  // curva de nivel 0 por marching squares
  const segs = [];
  const g = 4;
  for (let px = xa; px < xb; px += g) for (let py = ya; py < yb; py += g) {
    const P0 = [px, py], P1 = [px + g, py], P2 = [px + g, py + g], P3 = [px, py + g];
    const v = [P0, P1, P2, P3].map((q) => f(T.iX(q[0]), T.iY(q[1])));
    const Q = [P0, P1, P2, P3], cut = [];
    for (let i = 0; i < 4; i++) {
      const j = (i + 1) % 4;
      if ((v[i] > 0) !== (v[j] > 0)) { const t = v[i] / (v[i] - v[j]); cut.push([Q[i][0] + t * (Q[j][0] - Q[i][0]), Q[i][1] + t * (Q[j][1] - Q[i][1])]); }
    }
    if (cut.length >= 2) segs.push([cut[0], cut[1]]);
    if (cut.length === 4) segs.push([cut[2], cut[3]]);
  }
  ctx.save();
  ctx.beginPath();
  segs.forEach(([p, q]) => { ctx.moveTo(p[0], p[1]); ctx.lineTo(q[0], q[1]); });
  ctx.strokeStyle = mode === "gt" ? C("--muted") : C("--accent");
  ctx.lineWidth = mode === "gt" ? 1.6 : 2.6;
  if (mode === "gt") ctx.setLineDash([2, 5]);
  ctx.stroke();
  ctx.restore();
  const lbl = { cero: "{f = 0} = f⁻¹({0})", ge: "{f ≥ 0} = f⁻¹([0, ∞))", gt: "{f > 0} = f⁻¹((0, ∞))" }[mode];
  PP.label(ctx, lbl, T.p.l + 16, T.p.t + 4, C("--ink"), "left", "top", 12);
  PP.read(id + "-read", [
    ["conjunto", lbl],
    ["preimagen de", { cero: "{0}, cerrado de ℝ", ge: "[0, ∞), cerrado de ℝ", gt: "(0, ∞), abierto de ℝ" }[mode]],
    ["el borde {f = 0}", mode === "gt" ? "no pertenece" : "pertenece"],
  ]);
}, ["input[name='" + P + "-o6-4-m']"]);

/* O10-2: A = f⁻¹((−r, r)). */
PP.register(function o10_2() {
  const id = P + "-o10-2";
  const r = PP.val(id + "-r") / 100;
  PP.out(id + "-r-o", fmt(r, 2));
  const f = (x) => 1.5 * Math.sin(1.3 * x) + 0.4 * x;
  const { ctx, w, h } = PP.canvas(id + "-c", 0.66);
  const T = PP.frame(w, h, { x0: -4, x1: 4, y0: -3.1, y1: 3.1 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "f(x)" });
  PP.rect(ctx, T.p.l, T.Y(r), T.w - T.p.l - T.p.r, T.Y(-r) - T.Y(r), null, C("--band"));
  [r, -r].forEach((v) => PP.path(ctx, [[T.p.l, T.Y(v)], [T.w - T.p.r, T.Y(v)]], C("--accent"), 1.2, [5, 4]));
  plotFn(ctx, T, f, -4, 4, C("--ink"), 2.2);
  const rs = runs((x) => Math.abs(f(x)) < r, null, -4, 4, 2400);
  rs.forEach((q) => segment(ctx, T, q.a, q.b, T.Y(0), C("--seq2"), false, q.ba, q.bb));
  PP.read(id + "-read", [
    ["r", fmt(r, 2)],
    ["A en la ventana", intStr(rs, false)],
  ]);
}, [P + "-o10-2-r"]);

/* O4-5: A = {f − g ≥ α} cerrado, B = {f + g < β} abierto. */
PP.register(function o4_5() {
  const id = P + "-o4-5";
  const mode = PP.radio(id + "-m");
  const t = PP.val(id + "-t") / 100;
  PP.out(id + "-t-o", fmt(t, 2));
  const f = (x) => Math.sin(x) + 0.2 * x, g = (x) => 0.5 * Math.cos(1.5 * x);
  const F = mode === "A" ? (x) => f(x) - g(x) : (x) => f(x) + g(x);
  const { ctx, w, h } = PP.canvas(id + "-c", 0.66);
  const T = PP.frame(w, h, { x0: -4, x1: 4, y0: -2.6, y1: 2.6 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xLabel: "x" });
  PP.path(ctx, [[T.p.l, T.Y(t)], [T.w - T.p.r, T.Y(t)]], C("--accent"), 1.4, [5, 4]);
  PP.label(ctx, mode === "A" ? "α" : "β", T.w - T.p.r - 4, T.Y(t) - 4, C("--accent"), "right", "bottom", 13);
  plotFn(ctx, T, F, -4, 4, C("--ink"), 2.2);
  PP.label(ctx, mode === "A" ? "f − g" : "f + g", T.X(-3.9), T.Y(F(-3.9)) - 8, C("--ink"), "left", "bottom", 12);
  const rs = runs(mode === "A" ? (x) => F(x) >= t : (x) => F(x) < t, null, -4, 4, 2400);
  rs.forEach((q) => segment(ctx, T, q.a, q.b, T.Y(0), C("--seq2"), mode === "A", q.ba, q.bb));
  PP.read(id + "-read", [
    [mode === "A" ? "α" : "β", fmt(t, 2)],
    [mode === "A" ? "A en la ventana" : "B en la ventana", intStr(rs, mode === "A")],
    ["extremos", mode === "A" ? "pertenecen (cerrado)" : "no pertenecen (abierto)"],
  ]);
}, ["input[name='" + P + "-o4-5-m']", P + "-o4-5-t"]);

/* O16-4: la indicación con x₀ arrastrable. */
(function () {
  const id = P + "-o16-4";
  const st = { x0: 1.0 };
  let TT = null;
  const f = (x) => 1 + 0.8 * Math.sin(1.4 * x), g = (x) => 0.15 * x + 0.3;
  function draw() {
    const s = PP.val(id + "-s") / 100;
    PP.out(id + "-s-o", fmt(s, 2));
    const { ctx, w, h } = PP.canvas(id + "-c", 0.78);
    const T = PP.frame(w, h, { x0: 0, x1: 6, y0: -1.25, y1: 2.1 }, { l: 34, r: 12, t: 12, b: 28 });
    TT = T;
    PP.axes(ctx, T, { xLabel: "x", yTicks: 4 });
    const U = runs((x) => f(x) > g(x), null, 0, 6, 2400);
    U.forEach((q) => PP.rect(ctx, T.X(q.a), T.Y(2.1), T.X(q.b) - T.X(q.a), T.Y(0) - T.Y(2.1), null, C("--band")));
    plotFn(ctx, T, f, 0, 6, C("--accent"), 2.2);
    plotFn(ctx, T, g, 0, 6, C("--seq2"), 2.2);
    PP.label(ctx, "U = {f > g}", T.X(0.05), T.Y(2.05), C("--muted"), "left", "top", 12);
    const x0 = st.x0, inU = f(x0) > g(x0);
    PP.path(ctx, [[T.X(x0), T.Y(-1.25)], [T.X(x0), T.Y(Math.max(f(x0), g(x0)))]], C("--ink"), 1, [3, 3]);
    PP.dot(ctx, T.X(x0), T.Y(f(x0)), 4, C("--accent"));
    PP.dot(ctx, T.X(x0), T.Y(g(x0)), 4, C("--seq2"));
    const rows = [["x₀", fmt(x0, 2)], ["f(x₀), g(x₀)", `${fmt(f(x0), 2)}, ${fmt(g(x0), 2)}`]];
    const yS = [T.Y(-0.35), T.Y(-0.68), T.Y(-1.01)];
    PP.label(ctx, "g⁻¹((−∞, y))", T.p.l + 4, yS[0] - 5, C("--seq2"), "left", "bottom", 11);
    PP.label(ctx, "f⁻¹((y, +∞))", T.p.l + 4, yS[1] - 5, C("--accent"), "left", "bottom", 11);
    PP.label(ctx, "intersección", T.p.l + 4, yS[2] - 5, C("--ok"), "left", "bottom", 11);
    if (inU) {
      const y = g(x0) + s * (f(x0) - g(x0));
      PP.path(ctx, [[T.p.l, T.Y(y)], [T.w - T.p.r, T.Y(y)]], C("--ink"), 1.3, [6, 4]);
      PP.label(ctx, "y", T.w - T.p.r - 4, T.Y(y) - 3, C("--ink"), "right", "bottom", 13);
      const G = runs((x) => g(x) < y, null, 0, 6, 2400), Fr = runs((x) => f(x) > y, null, 0, 6, 2400);
      const I = runs((x) => g(x) < y && f(x) > y, null, 0, 6, 2400);
      G.forEach((q) => segment(ctx, T, q.a, q.b, yS[0], C("--seq2"), false, q.ba, q.bb));
      Fr.forEach((q) => segment(ctx, T, q.a, q.b, yS[1], C("--accent"), false, q.ba, q.bb));
      I.forEach((q) => segment(ctx, T, q.a, q.b, yS[2], C("--ok"), false, q.ba, q.bb));
      const mine = I.find((q) => q.a <= x0 && x0 <= q.b);
      rows.push(["y", fmt(y, 3)]);
      rows.push(["entorno de x₀", mine ? `(${fmt(mine.a, 2)}, ${fmt(mine.b, 2)})` : "—", "good"]);
      const inside = mine ? (f((mine.a + mine.b) / 2) > g((mine.a + mine.b) / 2)) : false;
      rows.push(["¿contenido en U?", inside ? "sí" : "—", inside ? "good" : ""]);
    } else {
      rows.push(["¿x₀ ∈ U?", "no: elegí otro x₀", "bad"]);
    }
    PP.dot(ctx, T.X(x0), T.Y(-1.25) - 1, 6, C("--panel"), C("--ink"));
    PP.read(id + "-read", rows);
  }
  PP.register(draw, [P + "-o16-4-s"]);
  draggable(id + "-c", () => TT, () => 0, (k, x) => { st.x0 = clamp(x, 0.02, 5.98); }, draw);
})();

/* O11-3: f, g y h = |f − g|; B = h⁻¹({0}). */
PP.register(function o11_3() {
  const id = P + "-o11-3";
  const c = PP.val(id + "-c0") / 100;
  PP.out(id + "-c0-o", fmt(c, 2));
  const f = (x) => 0.6 * Math.sin(1.7 * x), g = (x) => 0.25 * x - 0.75 + c, hh = (x) => Math.abs(f(x) - g(x));
  const { ctx, w, h } = PP.canvas(id + "-c", 0.82);
  const mid = Math.round(h * 0.56);
  const T1 = PP.frame(w, mid, { x0: 0, x1: 6, y0: -1.6, y1: 1.6 }, { l: 34, r: 12, t: 12, b: 20 });
  const T2 = PP.frame(w, h, { x0: 0, x1: 6, y0: -0.15, y1: 2 }, { l: 34, r: 12, t: mid + 8, b: 28 });
  PP.axes(ctx, T1, { yTicks: 4 });
  PP.axes(ctx, T2, { xLabel: "x", yTicks: 3 });
  plotFn(ctx, T1, f, 0, 6, C("--accent"), 2.2);
  plotFn(ctx, T1, g, 0, 6, C("--seq2"), 2.2);
  plotFn(ctx, T2, hh, 0, 6, C("--ink"), 2.2);
  PP.label(ctx, "f", T1.X(0.15), T1.Y(f(0.15)) - 6, C("--accent"), "left", "bottom", 13);
  PP.label(ctx, "g", T1.X(5.85), T1.Y(g(5.85)) - 6, C("--seq2"), "right", "bottom", 13);
  PP.label(ctx, "h = d′(f, g)", T2.X(0.1), T2.p.t + 2, C("--ink"), "left", "top", 12);
  const zs = roots((x) => f(x) - g(x), 0, 6);
  zs.forEach((z) => {
    PP.path(ctx, [[T1.X(z), T1.Y(f(z))], [T2.X(z), T2.Y(0)]], C("--muted"), 1, [3, 3]);
    PP.dot(ctx, T1.X(z), T1.Y(f(z)), 4, C("--ink"));
    PP.dot(ctx, T2.X(z), T2.Y(0), 5, C("--ok"));
  });
  PP.read(id + "-read", [
    ["c", fmt(c, 2)],
    ["B en la ventana", zs.length ? "{" + zs.map((z) => fmt(z, 2)).join(", ") + "}" : "∅"],
  ]);
}, [P + "-o11-3-c0"]);
