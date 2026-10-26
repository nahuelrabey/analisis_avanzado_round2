/* Dibujos de la guía de la Práctica 6 (espacios normados). Usa window.PP. */
const P = "guiap6";
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));

/* Marco con la misma escala en x y en y, centrado verticalmente en yc. */
function eqFrame(w, h, x0, x1, yc, pad) {
  const p = Object.assign({ l: 10, r: 10, t: 10, b: 10 }, pad || {});
  const span = (x1 - x0) * (h - p.t - p.b) / (w - p.l - p.r);
  return PP.frame(w, h, { x0, x1, y0: yc - span / 2, y1: yc + span / 2 }, p);
}

/* Recorta el dibujo al rectángulo de datos del marco T (hay que llamar a ctx.restore() después). */
function clipBox(ctx, T) {
  ctx.save(); ctx.beginPath();
  ctx.rect(T.p.l, T.p.t, T.w - T.p.l - T.p.r, T.h - T.p.t - T.p.b); ctx.clip();
}

/* Gráfico de f en [a, b]; corta el trazo donde f no es finita, se va muy lejos o donde brk(x1, x2) lo pide. */
function plotFn(ctx, T, f, a, b, color, width, dash, n, brk) {
  n = n || 600;
  const span = T.box.y1 - T.box.y0;
  let seg = [], px = null;
  const flush = () => { if (seg.length > 1) PP.path(ctx, seg, color, width, dash); seg = []; };
  for (let i = 0; i <= n; i++) {
    const x = a + (b - a) * i / n, y = f(x);
    if (!isFinite(y) || y < T.box.y0 - 4 * span || y > T.box.y1 + 4 * span) { flush(); px = null; continue; }
    if (px !== null && brk && brk(px, x)) flush();
    seg.push([T.X(x), T.Y(y)]); px = x;
  }
  flush();
}

/* Arrastre de puntos sobre un canvas: pick(px, py, T) devuelve un índice o null; move(i, x, y, T) actualiza. */
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

/* Índice del punto (de una lista [[x, y], …]) más cercano al píxel, o null si está lejos. */
function nearest(pts, px, py, T, tol) {
  let best = null, bd = tol || 18;
  pts.forEach(([x, y], i) => { const d = Math.hypot(T.X(x) - px, T.Y(y) - py); if (d < bd) { bd = d; best = i; } });
  return best;
}

/* Poligonal por nodos (xs, ys): valor, integral, integral del módulo y máximo del módulo. */
function pwl(xs, ys) {
  const f = (x) => {
    for (let i = 0; i < xs.length - 1; i++) {
      if (x <= xs[i + 1] || i === xs.length - 2) { const t = (x - xs[i]) / (xs[i + 1] - xs[i]); return ys[i] + t * (ys[i + 1] - ys[i]); }
    }
    return ys[ys.length - 1];
  };
  let I = 0, I1 = 0;
  for (let i = 0; i < xs.length - 1; i++) {
    const dx = xs[i + 1] - xs[i], a = ys[i], b = ys[i + 1];
    I += (a + b) / 2 * dx;
    if (a * b >= 0) I1 += Math.abs(a + b) / 2 * dx;
    else I1 += dx / 2 * (a * a + b * b) / (Math.abs(a) + Math.abs(b));
  }
  return { f, I, I1, sup: Math.max(...ys.map(Math.abs)) };
}

/* Sombrea el área entre la poligonal y el eje: arriba con c1, abajo con c2. */
function shadeArea(ctx, T, xs, ys, c1, c2) {
  const poly = [[T.X(xs[0]), T.Y(0)], ...xs.map((x, i) => [T.X(x), T.Y(ys[i])]), [T.X(xs[xs.length - 1]), T.Y(0)]];
  [[T.p.t, T.Y(0) - T.p.t, c1], [T.Y(0), T.h - T.p.b - T.Y(0), c2]].forEach(([y, hh, c]) => {
    if (hh <= 0) return;
    ctx.save(); ctx.beginPath(); ctx.rect(T.p.l, y, T.w - T.p.l - T.p.r, hh); ctx.clip();
    PP.path(ctx, poly, null, 0, null, true, c); ctx.restore();
  });
}

const gcd = (a, b) => { a = Math.abs(a); b = Math.abs(b); while (b) [a, b] = [b, a % b]; return a; };

const norm = (m, v) => {
  const ax = Math.abs(v[0]), ay = Math.abs(v[1]);
  return m === "1" ? ax + ay : m === "inf" ? Math.max(ax, ay) : Math.hypot(ax, ay);
};
/* Borde de la bola de radio r (centro c) de la norma m, como lista de puntos del plano. */
const ballPts = (m, c, r) => {
  if (m === "1") return [[c[0] + r, c[1]], [c[0], c[1] + r], [c[0] - r, c[1]], [c[0], c[1] - r]];
  if (m === "inf") return [[c[0] + r, c[1] + r], [c[0] - r, c[1] + r], [c[0] - r, c[1] - r], [c[0] + r, c[1] - r]];
  return Array.from({ length: 120 }, (_, k) => [c[0] + r * Math.cos(k * Math.PI / 60), c[1] + r * Math.sin(k * Math.PI / 60)]);
};
const toPx = (T, pts) => pts.map(([x, y]) => [T.X(x), T.Y(y)]);
const SUBS = "₀₁₂₃₄₅₆₇₈₉";
const sub = (n) => String(n).split("").map((d) => SUBS[+d]).join("");

/* Polinomio de grado ≤ 3 por sus valores en t = 0, 1/3, 2/3, 1 (Lagrange). */
const TN = [0, 1 / 3, 2 / 3, 1];
const lag = (v) => (t) => {
  let s = 0;
  for (let i = 0; i < 4; i++) {
    let L = 1;
    for (let j = 0; j < 4; j++) if (j !== i) L *= (t - TN[j]) / (TN[i] - TN[j]);
    s += v[i] * L;
  }
  return s;
};

/* ===================== Ejercicio 1 ===================== */
(() => {
  const pt = [[0.8, 0.5]];
  let T = null;
  const cid = P + "-ej1-c";
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.8);
    T = eqFrame(w, h, -1.9, 1.9, 0);
    PP.path(ctx, [[T.X(-1.9), T.Y(0)], [T.X(1.9), T.Y(0)]], C("--rule"), 1);
    PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), h - T.p.b]], C("--rule"), 1);
    [["1", C("--seq2")], ["2", C("--accent")], ["inf", C("--ok")]].forEach(([m, col]) => PP.path(ctx, toPx(T, ballPts(m, [0, 0], 1)), col, 2, null, true));
    [["‖x‖₁ = 1", C("--seq2")], ["‖x‖₂ = 1", C("--accent")], ["‖x‖∞ = 1", C("--ok")]].forEach(([t, col], k) =>
      PP.label(ctx, t, T.p.l + 4, T.p.t + 4 + 16 * k, col, "left", "top", 12));
    const x = pt[0];
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(x[0]), T.Y(x[1])]], C("--ink"), 1, [3, 3]);
    PP.dot(ctx, T.X(x[0]), T.Y(x[1]), 7, C("--ink"), C("--bg"));
    PP.label(ctx, "x", T.X(x[0]) + 9, T.Y(x[1]) - 4, C("--ink"), "left", "bottom", 13);
    PP.read(P + "-ej1-read", [
      ["x", "(" + PP.fmt(x[0], 2) + ", " + PP.fmt(x[1], 2) + ")"],
      ["‖x‖₁", PP.fmt(norm("1", x), 3)],
      ["‖x‖₂", PP.fmt(norm("2", x), 3)],
      ["‖x‖∞", PP.fmt(norm("inf", x), 3)],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(pt, px, py, T, 24),
    (i, x, y, T) => { pt[0] = [clamp(Math.round(x * 20) / 20, -1.8, 1.8), clamp(Math.round(y * 20) / 20, T.box.y0 + 0.1, T.box.y1 - 0.1)]; }, draw);
})();

/* ===================== Ejercicio 2 ===================== */
(() => {
  const pts = [[1.2, 0.8], [-0.9, -1.1]];
  const r = 2;
  let T = null;
  const cid = P + "-ej2-c";
  function draw() {
    const m = PP.radio(P + "-ej2-m") || "2";
    const t = PP.val(P + "-ej2-t") / 100;
    PP.out(P + "-ej2-t-o", PP.fmt(t, 2));
    const { ctx, w, h } = PP.canvas(cid, 0.8);
    T = eqFrame(w, h, -3, 3, 0);
    PP.path(ctx, [[T.X(-3), T.Y(0)], [T.X(3), T.Y(0)]], C("--rule"), 1);
    PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), h - T.p.b]], C("--rule"), 1);
    PP.path(ctx, toPx(T, ballPts(m, [0, 0], r)), C("--accent"), 1.6, [5, 4], true, C("--band"));
    PP.dot(ctx, T.X(0), T.Y(0), 3.5, C("--accent"));
    PP.label(ctx, "x = 0", T.X(0) + 5, T.Y(0) + 4, C("--accent"), "left", "top", 11);
    const [y, z] = pts;
    const p = [t * y[0] + (1 - t) * z[0], t * y[1] + (1 - t) * z[1]];
    PP.path(ctx, [[T.X(y[0]), T.Y(y[1])], [T.X(z[0]), T.Y(z[1])]], C("--muted"), 1.6);
    PP.dot(ctx, T.X(y[0]), T.Y(y[1]), 7, C("--seq2"), C("--bg"));
    PP.dot(ctx, T.X(z[0]), T.Y(z[1]), 7, C("--seq3"), C("--bg"));
    PP.label(ctx, "y", T.X(y[0]) + 9, T.Y(y[1]) - 4, C("--seq2"), "left", "bottom", 13);
    PP.label(ctx, "z", T.X(z[0]) + 9, T.Y(z[1]) - 4, C("--seq3"), "left", "bottom", 13);
    PP.dot(ctx, T.X(p[0]), T.Y(p[1]), 5, C("--ink"));
    const ny = norm(m, y), nz = norm(m, z), np = norm(m, p);
    const cls = (v) => (v < r ? "good" : "bad");
    PP.read(P + "-ej2-read", [
      ["‖y − x‖", PP.fmt(ny, 3), cls(ny)],
      ["‖z − x‖", PP.fmt(nz, 3), cls(nz)],
      ["‖t y + (1 − t) z − x‖", PP.fmt(np, 3), cls(np)],
      ["r", String(r)],
    ]);
  }
  PP.register(draw, ["input[name='" + P + "-ej2-m']", P + "-ej2-t"]);
  draggable(cid, () => T, (px, py, T) => nearest(pts, px, py, T, 22),
    (i, x, y, T) => { pts[i] = [clamp(Math.round(x * 20) / 20, -2.9, 2.9), clamp(Math.round(y * 20) / 20, T.box.y0 + 0.1, T.box.y1 - 0.1)]; }, draw);
})();

/* ===================== Ejercicio 3 ===================== */
(() => {
  const x0 = [1, 0.5];
  const xn = (n) => [x0[0] + 3 / Math.sqrt(n) * Math.cos(2 * n), x0[1] + 3 / Math.sqrt(n) * Math.sin(2 * n)];
  PP.register(function () {
    const N = PP.val(P + "-ej3-N");
    PP.out(P + "-ej3-N-o", String(N));
    const { ctx, w, h } = PP.canvas(P + "-ej3-c", 0.8);
    const T = eqFrame(w, h, -2.6, 4.6, 0.5);
    PP.path(ctx, [[T.X(-2.6), T.Y(0)], [T.X(4.6), T.Y(0)]], C("--rule"), 1);
    PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), h - T.p.b]], C("--rule"), 1);
    const xs = [], ys = [];
    let sx = 0, sy = 0;
    for (let n = 1; n <= N; n++) { const p = xn(n); xs.push(p); sx += p[0]; sy += p[1]; ys.push([sx / n, sy / n]); }
    xs.forEach((p, k) => PP.dot(ctx, T.X(p[0]), T.Y(p[1]), k === N - 1 ? 5.5 : 2.6, C("--seq2")));
    PP.path(ctx, toPx(T, ys), C("--accent"), 1.2);
    ys.forEach((p, k) => PP.dot(ctx, T.X(p[0]), T.Y(p[1]), k === N - 1 ? 5.5 : 2.6, C("--accent")));
    const X0 = T.X(x0[0]), Y0 = T.Y(x0[1]);
    PP.path(ctx, [[X0 - 7, Y0], [X0 + 7, Y0]], C("--ink"), 2);
    PP.path(ctx, [[X0, Y0 - 7], [X0, Y0 + 7]], C("--ink"), 2);
    PP.label(ctx, "x₀", X0 + 8, Y0 + 4, C("--ink"), "left", "top", 13);
    const d = (p) => Math.hypot(p[0] - x0[0], p[1] - x0[1]);
    PP.read(P + "-ej3-read", [
      ["n", String(N)],
      ["‖xₙ − x₀‖", PP.fmt(d(xs[N - 1]), 3)],
      ["‖yₙ − x₀‖", PP.fmt(d(ys[N - 1]), 3)],
    ]);
  }, [P + "-ej3-N"]);
})();

/* ===================== Ejercicio 5 ===================== */
(() => {
  const v = [0.6, -0.9, 0.5, 1.2];
  let T = null;
  const cid = P + "-ej5-c";
  function draw() {
    const p = lag(v);
    const n = 1000;
    let sup = 0, I1 = 0;
    const pts = [];
    for (let i = 0; i <= n; i++) { const t = i / n, y = p(t); pts.push([t, y]); sup = Math.max(sup, Math.abs(y)); if (i) I1 += (Math.abs(y) + Math.abs(pts[i - 1][1])) / 2 / n; }
    const { ctx, w, h } = PP.canvas(cid, 0.66);
    T = PP.frame(w, h, { x0: -0.04, x1: 1.04, y0: -2.2, y1: 2.2 }, { l: 36, r: 12, t: 12, b: 26 });
    shadeArea(ctx, T, pts.map((q) => q[0]), pts.map((q) => q[1]), C("--area"), C("--area"));
    PP.axes(ctx, T, { xTicks: 5 });
    [sup, -sup].forEach((s) => PP.path(ctx, [[T.X(0), T.Y(s)], [T.X(1), T.Y(s)]], C("--seq2"), 1.4, [5, 4]));
    PP.label(ctx, "±‖p‖∞", T.X(1) - 2, T.Y(sup) - 3, C("--seq2"), "right", "bottom", 11);
    clipBox(ctx, T);
    PP.path(ctx, toPx(T, pts), C("--accent"), 2.4);
    ctx.restore();
    TN.forEach((t, i) => PP.dot(ctx, T.X(t), T.Y(v[i]), 6, C("--accent"), C("--bg")));
    PP.read(P + "-ej5-read", [
      ["‖p‖∞", PP.fmt(sup, 3)],
      ["‖p‖₁", PP.fmt(I1, 3)],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(TN.map((t, i) => [t, v[i]]), px, py, T),
    (i, x, y) => { v[i] = clamp(Math.round(y * 50) / 50, -2, 2); }, draw);
})();

/* ===================== Ejercicio 6 ===================== */
(() => {
  const seqs = {
    alt: { f: (n) => (n % 2 ? -1 : 1) * (1 - 1 / n), sup: 1, txt: "1 (no se alcanza)" },
    sin: { f: (n) => Math.sin(n), sup: 1, txt: "1 (no se alcanza)" },
    dec: { f: (n) => 2 / n, sup: 2, txt: "2 (en n = 1)" },
  };
  PP.register(function () {
    const s = seqs[PP.radio(P + "-ej6-a") || "alt"];
    const N = 60;
    const { ctx, w, h } = PP.canvas(P + "-ej6-c", 0.6);
    const T = PP.frame(w, h, { x0: 0, x1: N + 1, y0: -2.3, y1: 2.3 }, { l: 34, r: 12, t: 12, b: 26 });
    PP.rect(ctx, T.X(0), T.Y(s.sup), T.X(N + 1) - T.X(0), T.Y(-s.sup) - T.Y(s.sup), null, C("--band"));
    PP.axes(ctx, T, { xTicks: 6, intX: true });
    [s.sup, -s.sup].forEach((y) => PP.path(ctx, [[T.X(0), T.Y(y)], [T.X(N + 1), T.Y(y)]], C("--ok"), 1.4, [5, 4]));
    PP.label(ctx, "±‖a‖∞", T.X(N + 1) - 2, T.Y(s.sup) - 3, C("--ok"), "right", "bottom", 11);
    let mx = 0;
    for (let n = 1; n <= N; n++) {
      const a = s.f(n); mx = Math.max(mx, Math.abs(a));
      PP.path(ctx, [[T.X(n), T.Y(0)], [T.X(n), T.Y(a)]], C("--accent"), 1);
      PP.dot(ctx, T.X(n), T.Y(a), 3, C("--accent"));
    }
    PP.read(P + "-ej6-read", [
      ["‖a‖∞ = sup |aₙ|", s.txt],
      ["máx |aₙ| con n ≤ 60", PP.fmt(mx, 4)],
    ]);
  }, ["input[name='" + P + "-ej6-a']"]);
})();

/* ===================== Ejercicio 7 ===================== */
(() => {
  const a = [0.6, -0.3, 0.8, -0.5, 0.2, -0.4, 0.3, 0.1];
  const N = 12;
  let T = null;
  const cid = P + "-ej7-c";
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.6);
    T = PP.frame(w, h, { x0: 0.3, x1: N + 0.7, y0: -1.2, y1: 1.2 }, { l: 34, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xTicks: 12, intX: true });
    PP.rect(ctx, T.X(8.6), T.p.t, T.X(N + 0.7) - T.X(8.6), h - T.p.t - T.p.b, null, C("--band"));
    PP.label(ctx, "aₙ = 0 (n ≥ 9)", T.X(N + 0.6), T.p.t + 4, C("--muted"), "right", "top", 11);
    const bw = Math.max(6, (T.X(2) - T.X(1)) * 0.55);
    for (let n = 1; n <= N; n++) {
      const v = n <= 8 ? a[n - 1] : 0;
      if (n <= 8) {
        PP.rect(ctx, T.X(n) - bw / 2, Math.min(T.Y(v), T.Y(0)), bw, Math.abs(T.Y(v) - T.Y(0)), null, v >= 0 ? C("--area") : C("--area2"));
        PP.path(ctx, [[T.X(n) - bw / 2, T.Y(v)], [T.X(n) + bw / 2, T.Y(v)]], v >= 0 ? C("--accent") : C("--seq2"), 3);
        PP.dot(ctx, T.X(n), T.Y(v), 4, v >= 0 ? C("--accent") : C("--seq2"));
      } else PP.dot(ctx, T.X(n), T.Y(0), 3, C("--muted"));
    }
    const sum = a.reduce((s, x) => s + x, 0);
    const inS = Math.abs(sum) < 1e-9;
    PP.read(P + "-ej7-read", [
      ["Σ aₙ", PP.fmt(inS ? 0 : sum, 3), inS ? "good" : ""],
      ["¿a ∈ S?", inS ? "sí" : "no"],
      ["‖a‖∞", PP.fmt(Math.max(...a.map(Math.abs)), 3)],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(a.map((v, i) => [i + 1, v]), px, py, T, 20),
    (i, x, y) => { a[i] = clamp(Math.round(y * 20) / 20, -1.1, 1.1); }, draw);
})();

/* ===================== Ejercicio 9 ===================== */
PP.register(function () {
  const a = PP.val(P + "-ej9-a") / 100, b = PP.val(P + "-ej9-b") / 100;
  PP.out(P + "-ej9-a-o", PP.fmt(a, 2));
  PP.out(P + "-ej9-b-o", PP.fmt(b, 2));
  const Tm = (v) => [a * v[0] + b * v[1], 0.6 * v[1]];
  const { ctx, w, h } = PP.canvas(P + "-ej9-c", 0.8);
  const T = eqFrame(w, h, -3.6, 3.6, 0);
  PP.path(ctx, [[T.X(-3.6), T.Y(0)], [T.X(3.6), T.Y(0)]], C("--rule"), 1);
  PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), h - T.p.b]], C("--rule"), 1);
  const circ = ballPts("2", [0, 0], 1);
  PP.path(ctx, toPx(T, circ), C("--muted"), 1.6, null, true, C("--band"));
  PP.path(ctx, toPx(T, circ.map(Tm)), C("--accent"), 2, null, true, C("--area"));
  let s1 = 0, arg = [1, 0], sBall = 0, sRatio = 0;
  for (let k = 0; k < 1440; k++) {
    const th = k * Math.PI / 720, u = [Math.cos(th), Math.sin(th)];
    const nv = norm("2", Tm(u));
    if (nv > s1) { s1 = nv; arg = u; }
    for (const r of [0.25, 0.5, 0.75, 1]) sBall = Math.max(sBall, norm("2", Tm([r * u[0], r * u[1]])));
    for (const r of [0.3, 1.7, 4]) sRatio = Math.max(sRatio, norm("2", Tm([r * u[0], r * u[1]])) / r);
  }
  const Ta = Tm(arg);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(Ta[0]), T.Y(Ta[1])]], C("--seq2"), 1.4, [4, 3]);
  PP.dot(ctx, T.X(arg[0]), T.Y(arg[1]), 5, C("--ink"));
  PP.dot(ctx, T.X(Ta[0]), T.Y(Ta[1]), 5, C("--seq2"));
  PP.label(ctx, "x", T.X(arg[0]) + 6, T.Y(arg[1]) - 4, C("--ink"), "left", "bottom", 12);
  PP.label(ctx, "Tx", T.X(Ta[0]) + 6, T.Y(Ta[1]) - 4, C("--seq2"), "left", "bottom", 12);
  PP.label(ctx, "T(B)", T.p.l + 4, T.p.t + 4, C("--accent"), "left", "top", 12);
  PP.read(P + "-ej9-read", [
    ["sup ‖Tx‖ con ‖x‖ ≤ 1", PP.fmt(sBall, 4)],
    ["sup ‖Tx‖ con ‖x‖ = 1", PP.fmt(s1, 4)],
    ["sup ‖Tx‖/‖x‖ con x ≠ 0", PP.fmt(sRatio, 4)],
  ]);
}, [P + "-ej9-a", P + "-ej9-b"]);

/* ===================== Ejercicio 10 ===================== */
(() => {
  const xs = [0, 0.2, 0.4, 0.6, 0.8, 1];
  const ys = [0.9, 0.3, -0.4, 0.2, 0.7, 0.5];
  let T = null;
  const cid = P + "-ej10-c";
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.66);
    T = PP.frame(w, h, { x0: -0.04, x1: 1.04, y0: -1.6, y1: 1.6 }, { l: 36, r: 12, t: 12, b: 26 });
    const F = pwl(xs, ys);
    shadeArea(ctx, T, xs, ys, C("--area"), C("--area2"));
    PP.axes(ctx, T, { xTicks: 5 });
    PP.path(ctx, xs.map((x, i) => [T.X(x), T.Y(ys[i])]), C("--accent"), 2.4);
    xs.forEach((x, i) => PP.dot(ctx, T.X(x), T.Y(ys[i]), i === 0 ? 7 : 5, i === 0 ? C("--ink") : C("--accent"), C("--bg")));
    PP.label(ctx, "(0, 𝓔f)", T.X(0) + 10, T.Y(ys[0]) - 6, C("--ink"), "left", "bottom", 12);
    PP.read(P + "-ej10-read", [
      ["𝓔f = f(0)", PP.fmt(ys[0], 3)],
      ["𝓘f = ∫ f", PP.fmt(F.I, 3)],
      ["‖f‖∞", PP.fmt(F.sup, 3)],
      ["‖f‖₁", PP.fmt(F.I1, 3)],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(xs.map((x, i) => [x, ys[i]]), px, py, T),
    (i, x, y) => { ys[i] = clamp(Math.round(y * 50) / 50, -1.5, 1.5); }, draw);
})();

/* ===================== Ejercicio 11 ===================== */
(() => {
  const xs = [0, 0.2, 0.4, 0.6, 0.8, 1];
  const ys = [1, 0.4, -0.6, -0.2, 0.8, 0.3];
  const ks = {
    xy: (x, y) => x * y,
    min: (x, y) => Math.min(x, y),
    cos: (x, y) => Math.cos(Math.PI * (x - y)),
  };
  let T = null;
  const cid = P + "-ej11-c";
  function draw() {
    const k = ks[PP.radio(P + "-ej11-k") || "xy"];
    const F = pwl(xs, ys);
    const M = 300, Kf = [];
    for (let i = 0; i <= 150; i++) {
      const x = i / 150;
      let s = 0;
      for (let j = 0; j <= M; j++) { const y = j / M, wgt = j === 0 || j === M ? 0.5 : 1; s += wgt * k(x, y) * F.f(y); }
      Kf.push([x, s / M]);
    }
    const { ctx, w, h } = PP.canvas(cid, 0.66);
    T = PP.frame(w, h, { x0: -0.04, x1: 1.04, y0: -1.6, y1: 1.6 }, { l: 36, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xTicks: 5 });
    PP.path(ctx, xs.map((x, i) => [T.X(x), T.Y(ys[i])]), C("--accent"), 2.2);
    xs.forEach((x, i) => PP.dot(ctx, T.X(x), T.Y(ys[i]), 5, C("--accent"), C("--bg")));
    PP.path(ctx, toPx(T, Kf), C("--ok"), 2.6);
    PP.label(ctx, "f", T.X(xs[0]) + 8, T.Y(ys[0]) - 4, C("--accent"), "left", "bottom", 13);
    PP.label(ctx, "Kf", T.X(1) - 2, T.Y(Kf[Kf.length - 1][1]) - 6, C("--ok"), "right", "bottom", 13);
    PP.read(P + "-ej11-read", [
      ["‖f‖∞", PP.fmt(F.sup, 3)],
      ["‖Kf‖∞", PP.fmt(Math.max(...Kf.map((q) => Math.abs(q[1]))), 3)],
    ]);
  }
  PP.register(draw, ["input[name='" + P + "-ej11-k']"]);
  draggable(cid, () => T, (px, py, T) => nearest(xs.map((x, i) => [x, ys[i]]), px, py, T),
    (i, x, y) => { ys[i] = clamp(Math.round(y * 50) / 50, -1.5, 1.5); }, draw);
})();

/* ===================== Ejercicio 12 ===================== */
(() => {
  const v = [0.2, 0.9, -0.5, 0.4];
  let T = null;
  const cid = P + "-ej12-c";
  function draw() {
    const p = lag(v), hh = 1e-4;
    const dp = (t) => (p(Math.min(1, t + hh)) - p(Math.max(0, t - hh))) / (Math.min(1, t + hh) - Math.max(0, t - hh));
    let sp = 0, sd = 0;
    for (let i = 0; i <= 400; i++) { const t = i / 400; sp = Math.max(sp, Math.abs(p(t))); sd = Math.max(sd, Math.abs(dp(t))); }
    const Y = Math.max(1.6, sd * 1.12, sp * 1.12);
    const { ctx, w, h } = PP.canvas(cid, 0.66);
    T = PP.frame(w, h, { x0: -0.04, x1: 1.04, y0: -Y, y1: Y }, { l: 36, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xTicks: 5 });
    clipBox(ctx, T);
    plotFn(ctx, T, dp, 0, 1, C("--seq2"), 2.2, null, 400);
    plotFn(ctx, T, p, 0, 1, C("--accent"), 2.6, null, 400);
    ctx.restore();
    TN.forEach((t, i) => PP.dot(ctx, T.X(t), T.Y(v[i]), 6, C("--accent"), C("--bg")));
    PP.label(ctx, "p", T.X(0) + 8, T.Y(v[0]) - 6, C("--accent"), "left", "bottom", 13);
    PP.label(ctx, "δp = p′", T.X(1) - 2, T.Y(dp(1)) - 6, C("--seq2"), "right", "bottom", 12);
    PP.read(P + "-ej12-read", [
      ["‖p‖∞", PP.fmt(sp, 3)],
      ["‖δp‖∞", PP.fmt(sd, 3)],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(TN.map((t, i) => [t, v[i]]), px, py, T),
    (i, x, y) => { v[i] = clamp(Math.round(y * 50) / 50, -1.5, 1.5); }, draw);
})();

/* ===================== Ejercicio 13 ===================== */
(() => {
  const seqs = {
    inv: (n) => 1 / n,
    alt: (n) => (n % 2 ? -1 : 1) / Math.pow(n, 0.75),
    geo: (n) => Math.pow(2, -n),
  };
  PP.register(function () {
    const f = seqs[PP.radio(P + "-ej13-a") || "inv"];
    const N = 30;
    let n2 = 0, g = 0;
    const partial = [];
    for (let n = 1; n <= 20000; n++) { const a = f(n); n2 += a * a; g += a / n; if (n <= N) partial.push([n, g]); }
    const vals = [];
    for (let n = 1; n <= N; n++) vals.push(f(n));
    const lo = Math.min(0, ...vals, ...partial.map((q) => q[1])), hi = Math.max(0, ...vals, ...partial.map((q) => q[1]));
    const m = (hi - lo) * 0.1;
    const { ctx, w, h } = PP.canvas(P + "-ej13-c", 0.6);
    const T = PP.frame(w, h, { x0: 0, x1: N + 1, y0: lo - m, y1: hi + m }, { l: 38, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xTicks: 6, intX: true });
    const bw = Math.max(3, (T.X(2) - T.X(1)) * 0.55);
    vals.forEach((a, k) => PP.rect(ctx, T.X(k + 1) - bw / 2, Math.min(T.Y(a), T.Y(0)), bw, Math.abs(T.Y(a) - T.Y(0)), null, C("--area")));
    PP.path(ctx, toPx(T, partial), C("--ok"), 2.2);
    partial.forEach(([n, s]) => PP.dot(ctx, T.X(n), T.Y(s), 2.4, C("--ok")));
    PP.label(ctx, "Σ aₖ/k", T.X(N) - 2, T.Y(partial[N - 1][1]) - 6, C("--ok"), "right", "bottom", 12);
    PP.label(ctx, "aₙ", T.X(1) + 8, T.Y(vals[0]) + (vals[0] >= 0 ? 4 : -4), C("--accent"), "left", vals[0] >= 0 ? "top" : "bottom", 12);
    PP.read(P + "-ej13-read", [
      ["‖a‖₂", PP.fmt(Math.sqrt(n2), 4)],
      ["γ(a) = Σ aₙ/n", PP.fmt(g, 4)],
    ]);
  }, ["input[name='" + P + "-ej13-a']"]);
})();
