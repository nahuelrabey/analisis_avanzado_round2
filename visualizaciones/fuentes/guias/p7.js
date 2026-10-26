/* Dibujos de la guía 7 (sucesiones de funciones). Usa window.PP. */
const ID = "guiap7";
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const FONT = "11px 'IBM Plex Sans', system-ui, sans-serif";

/* Recorta el dibujo al rectángulo de datos del marco. */
function clipPlot(ctx, T) {
  ctx.beginPath();
  ctx.rect(T.p.l, T.p.t, T.w - T.p.l - T.p.r, T.h - T.p.t - T.p.b);
  ctx.clip();
}

/* Gráfico de f en [x0, x1], cortado fuera del marco. */
function curve(ctx, T, f, x0, x1, color, width, dash, N) {
  N = N || 600;
  const span = Math.abs(T.box.y1 - T.box.y0);
  const lo = Math.min(T.box.y0, T.box.y1) - span, hi = Math.max(T.box.y0, T.box.y1) + span;
  ctx.save(); clipPlot(ctx, T);
  ctx.beginPath(); ctx.strokeStyle = color; ctx.lineWidth = width || 1.5; ctx.setLineDash(dash || []);
  let pen = false;
  for (let i = 0; i <= N; i++) {
    const x = x0 + (x1 - x0) * i / N, y = f(x);
    if (!isFinite(y) || y < lo || y > hi) { pen = false; continue; }
    if (pen) ctx.lineTo(T.X(x), T.Y(y)); else { ctx.moveTo(T.X(x), T.Y(y)); pen = true; }
  }
  ctx.stroke(); ctx.restore();
}

/* Arrastre sobre un canvas: pick(px, py, T) devuelve un id o null; move(id, x, y, T) actualiza. */
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

/* Marco con la misma escala en x y en y, centrado verticalmente en cy. */
function eqFrame(w, h, x0, x1, cy, pad) {
  const p = Object.assign({ l: 36, r: 12, t: 12, b: 28 }, pad || {});
  const half = (x1 - x0) * (h - p.t - p.b) / (w - p.l - p.r) / 2;
  return PP.frame(w, h, { x0, x1, y0: cy - half, y1: cy + half }, p);
}

/* ===================== Ejercicio 1 ===================== */
(function () {
  const tri = (n) => (x) => Math.max(0, 1 - Math.abs(x - n));
  const draw = function ej1() {
    const k = PP.val(ID + "-ej1-k");
    PP.out(ID + "-ej1-k-o", String(k));
    const { ctx, w, h } = PP.canvas(ID + "-ej1-c", 0.56);
    const T = PP.frame(w, h, { x0: 0, x1: 11.5, y0: -0.12, y1: 1.3 }, { l: 34, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yTicks: 4, xTicks: 6 });
    const alpha = 0.5;
    // f = 0
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(11.5), T.Y(0)]], C("--ok"), 2.5);
    PP.label(ctx, "f = 0", T.X(11.3), T.Y(0) - 4, C("--ok"), "right", "bottom", 11);
    // α
    PP.path(ctx, [[T.X(0), T.Y(alpha)], [T.X(11.5), T.Y(alpha)]], C("--fail"), 1.5, [5, 4]);
    PP.label(ctx, "α = 1/2", T.X(0.15), T.Y(alpha) - 3, C("--fail"), "left", "bottom", 11);
    for (let j = 1; j < k; j++) curve(ctx, T, tri(j), 0, 11.5, C("--muted"), 1, null, 400);
    curve(ctx, T, tri(k), 0, 11.5, C("--accent"), 2.5, null, 800);
    // distancia en a_k
    PP.path(ctx, [[T.X(k), T.Y(0)], [T.X(k), T.Y(1)]], C("--seq2"), 3);
    PP.dot(ctx, T.X(k), T.Y(1), 5, C("--accent"));
    PP.dot(ctx, T.X(k), T.Y(0), 4, C("--ok"));
    PP.label(ctx, "a" + "ₖ = " + k, T.X(k), T.Y(0) + 4, C("--seq2"), "center", "top", 11);
    PP.label(ctx, "f" + "ₙₖ", T.X(k) + 8, T.Y(1.08), C("--accent"), "left", "middle", 12);
    PP.read(ID + "-ej1-read", [
      ["n<sub>k</sub> = a<sub>k</sub>", String(k)],
      ["f<sub>n<sub>k</sub></sub>(a<sub>k</sub>)", "1"],
      ["f(a<sub>k</sub>)", "0"],
      ["d(f<sub>n<sub>k</sub></sub>(a<sub>k</sub>), f(a<sub>k</sub>))", "1 ≥ α = 0.5", "good"],
    ]);
  };
  PP.register(draw, [ID + "-ej1-k"]);
})();

/* ===================== Ejercicio 2 ===================== */
(function () {
  const S = { a: 1.2, b: 12, d: 0.55, p: [2, 1.5] };
  const phi = (t) => 0.4 + t + 0.3 * Math.sin(8 * t);
  let lastT = null, lastIt = "a";
  const box = {
    a: { x0: -6.6, x1: 6.6, y0: -1.25, y1: 1.25 },
    b: { x0: -40, x1: 40, y0: -1.25, y1: 1.25 },
    d: { x0: 0, x1: 1, y0: -0.1, y1: 1.9 },
  };
  const fn = {
    a: (n) => (x) => Math.sin(n * x) / n,
    b: (n) => (x) => Math.sin(x / n),
    d: (n) => (t) => n / (n + 1) * phi(t),
  };
  const draw = function ej2() {
    const it = PP.radio(ID + "-ej2-it") || "a";
    const n = PP.val(ID + "-ej2-n");
    PP.out(ID + "-ej2-n-o", String(n));
    lastIt = it;
    const { ctx, w, h } = PP.canvas(ID + "-ej2-c", 0.66);
    if (it === "c") {
      const T = eqFrame(w, h, -4.2, 4.2, 0);
      lastT = T;
      PP.axes(ctx, T, { xLabel: "x", yLabel: "y", xTicks: 8, yTicks: 6 });
      const r = n / (n + 1);
      for (let x = -3; x <= 3; x++) for (let y = -3; y <= 3; y++) {
        if (T.Y(y) < T.p.t + 6 || T.Y(y) > T.h - T.p.b - 8) continue;
        PP.dot(ctx, T.X(x), T.Y(y), 2.5, C("--muted"));
        PP.path(ctx, [[T.X(x), T.Y(y)], [T.X(r * x), T.Y(r * y)]], C("--accent"), 1.5);
        PP.dot(ctx, T.X(r * x), T.Y(r * y), 2.5, C("--accent"));
      }
      const [px, py] = S.p;
      PP.path(ctx, [[T.X(px), T.Y(py)], [T.X(r * px), T.Y(r * py)]], C("--seq2"), 2.5);
      PP.dot(ctx, T.X(px), T.Y(py), 7, C("--panel"), C("--seq2"));
      PP.dot(ctx, T.X(r * px), T.Y(r * py), 5, C("--seq2"));
      const side = px > 1.5 ? ["right", -9] : ["left", 9];
      PP.label(ctx, "(x, y)", T.X(px) + side[1], T.Y(py) - 6, C("--seq2"), side[0], "bottom", 12);
      PP.label(ctx, "fₙ(x, y)", T.X(r * px) + side[1], T.Y(r * py) + 6, C("--seq2"), side[0], "top", 12);
      PP.read(ID + "-ej2-read", [
        ["n/(n+1)", PP.fmt(r, 4)],
        ["(x, y)", "(" + PP.fmt(px, 2) + ", " + PP.fmt(py, 2) + ")"],
        ["f<sub>n</sub>(x, y)", "(" + PP.fmt(r * px, 3) + ", " + PP.fmt(r * py, 3) + ")"],
      ]);
      return;
    }
    const B = box[it];
    const T = PP.frame(w, h, B, { l: 38, r: 12, t: 12, b: 28 });
    lastT = T;
    PP.axes(ctx, T, { xLabel: it === "d" ? "t" : "x", yTicks: 5, xTicks: 6 });
    const x0 = S[it];
    if (it === "d") {
      curve(ctx, T, phi, 0, 1, C("--muted"), 1.8, [5, 4]);
      curve(ctx, T, fn.d(n), 0, 1, C("--accent"), 2.5);
      PP.label(ctx, "φ", T.X(0.98), T.Y(phi(0.98)) - 6, C("--muted"), "right", "bottom", 12);
    } else {
      if (n > 1) curve(ctx, T, fn[it](n - 1), B.x0, B.x1, C("--muted"), 1, null, 1200);
      curve(ctx, T, fn[it](n), B.x0, B.x1, C("--accent"), 2.2, null, 1500);
    }
    const y = fn[it](n)(x0);
    PP.path(ctx, [[T.X(x0), T.p.t], [T.X(x0), T.h - T.p.b]], C("--seq2"), 1.2, [4, 4]);
    PP.dot(ctx, T.X(x0), T.Y(y), 5, C("--seq2"));
    PP.dot(ctx, T.X(x0), T.h - T.p.b, 6, C("--panel"), C("--seq2"));
    const rows = it === "d"
      ? [["n/(n+1)", PP.fmt(n / (n + 1), 4)], ["t", PP.fmt(x0, 3)], ["φ(t)", PP.fmt(phi(x0), 4)], ["f<sub>n</sub>(φ)(t)", PP.fmt(y, 4)]]
      : [["f<sub>n</sub>(x)", it === "a" ? "sen(nx)/n" : "sen(x/n)"], ["x", PP.fmt(x0, 3)], ["f<sub>n</sub>(x)", PP.fmt(y, 4)]];
    PP.read(ID + "-ej2-read", rows);
  };
  PP.register(draw, [ID + "-ej2-n", "input[name=" + ID + "-ej2-it]"]);
  draggable(ID + "-ej2-c", () => lastT,
    (px, py, T) => {
      if (lastIt === "c") {
        const [x, y] = S.p;
        return Math.hypot(px - T.X(x), py - T.Y(y)) < 22 ? "p" : null;
      }
      return Math.abs(px - T.X(S[lastIt])) < 22 ? "x" : null;
    },
    (k, x, y, T) => {
      if (k === "p") S.p = [clamp(x, -3.8, 3.8), clamp(y, Math.min(T.box.y0, T.box.y1) + 0.3, Math.max(T.box.y0, T.box.y1) - 0.3)];
      else S[lastIt] = clamp(x, box[lastIt].x0, box[lastIt].x1);
    }, draw);
})();

/* ===================== Ejercicio 3 ===================== */
(function () {
  const F = {
    1: { f: (n) => (x) => Math.pow(x, n), x0: -1, x1: 1, box: { x0: -1.1, x1: 1.1, y0: -1.15, y1: 1.15 }, A: "(−1, 1]", ext: [[-1, false], [1, true]], strip: [0, 0.5, "(0, 1/2)"], tex: "xⁿ" },
    2: { f: (n) => (x) => Math.exp(x) / Math.pow(x, n), x0: 1, x1: 6, box: { x0: 0.8, x1: 6.1, y0: -0.2, y1: 4 }, A: "(1, +∞)", ext: [[1, false]], strip: [2, 5, "[2, 5]"], tex: "x⁻ⁿ eˣ" },
    3: { f: (n) => (x) => n * n * x * Math.pow(1 - x * x, n), x0: 0, x1: 1, box: null, A: "[0, 1]", ext: [[0, true], [1, true]], tex: "n² x (1 − x²)ⁿ" },
    4: { f: (n) => (x) => x * Math.exp(-n * x * x), x0: -3, x1: 3, box: { x0: -3, x1: 3, y0: -0.5, y1: 0.5 }, A: "ℝ", ext: [], tex: "x e^(−n x²)" },
  };
  const draw = function ej3() {
    const it = PP.radio(ID + "-ej3-it") || "1";
    const n = PP.val(ID + "-ej3-n");
    PP.out(ID + "-ej3-n-o", String(n));
    const c = F[it];
    let box = c.box;
    if (!box) {
      let m = 0;
      for (let k = Math.max(1, n - 3); k <= n; k++) for (let i = 0; i <= 400; i++) m = Math.max(m, c.f(k)(i / 400));
      box = { x0: -0.05, x1: 1.05, y0: -0.06 * m, y1: 1.12 * m };
    }
    const { ctx, w, h } = PP.canvas(ID + "-ej3-c", 0.64);
    const T = PP.frame(w, h, box, { l: 42, r: 12, t: 12, b: 28 });
    if (c.strip) {
      PP.rect(ctx, T.X(c.strip[0]), T.p.t, T.X(c.strip[1]) - T.X(c.strip[0]), T.h - T.p.t - T.p.b, null, C("--band"));
      PP.label(ctx, c.strip[2], (T.X(c.strip[0]) + T.X(c.strip[1])) / 2, T.p.t + 4, C("--accent"), "center", "top", 11);
    }
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 6 });
    for (let k = Math.max(1, n - 3); k < n; k++) curve(ctx, T, c.f(k), c.x0, c.x1, C("--muted"), 1, null, 900);
    curve(ctx, T, c.f(n), c.x0, c.x1, C("--accent"), 2.4, null, 1500);
    c.ext.forEach(([x, closed]) => {
      const y = c.f(n)(x);
      if (!isFinite(y) || y > Math.max(box.y0, box.y1)) return;
      PP.dot(ctx, T.X(x), T.Y(y), 4.5, closed ? C("--accent") : C("--bg"), C("--accent"));
    });
    PP.read(ID + "-ej3-read", [
      ["f<sub>n</sub>(x)", c.tex],
      ["A", c.A],
      ["n", String(n)],
    ]);
  };
  PP.register(draw, [ID + "-ej3-n", "input[name=" + ID + "-ej3-it]"]);
})();

/* ===================== Ejercicio 4 ===================== */
(function () {
  const f = (n) => (x) => Math.sin(x) + Math.cos(n * x) / n;
  const draw = function ej4() {
    const n = PP.val(ID + "-ej4-n");
    PP.out(ID + "-ej4-n-o", String(n));
    const M = 2;
    const { ctx, w, h } = PP.canvas(ID + "-ej4-c", 0.6);
    const T = PP.frame(w, h, { x0: 0, x1: 2 * Math.PI, y0: -2.6, y1: 2.6 }, { l: 34, r: 12, t: 12, b: 28 });
    PP.rect(ctx, T.p.l, T.Y(M), T.w - T.p.l - T.p.r, T.Y(-M) - T.Y(M), null, C("--okband"));
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 6 });
    [M, -M].forEach((m) => PP.path(ctx, [[T.p.l, T.Y(m)], [T.w - T.p.r, T.Y(m)]], C("--ok"), 1.5, [5, 4]));
    PP.label(ctx, "M = 2", T.w - T.p.r - 4, T.Y(M) - 3, C("--ok"), "right", "bottom", 11);
    PP.label(ctx, "−M", T.w - T.p.r - 4, T.Y(-M) + 3, C("--ok"), "right", "top", 11);
    for (let k = 1; k < n; k++) curve(ctx, T, f(k), 0, 2 * Math.PI, C("--muted"), 0.8, null, 700);
    curve(ctx, T, f(n), 0, 2 * Math.PI, C("--accent"), 2.3, null, 1200);
    let m = 0;
    for (let k = 1; k <= n; k++) for (let i = 0; i <= 600; i++) m = Math.max(m, Math.abs(f(k)(2 * Math.PI * i / 600)));
    PP.read(ID + "-ej4-read", [
      ["f<sub>n</sub>(x)", "sen x + cos(nx)/n"],
      ["máx |f<sub>k</sub>(x)|, k ≤ n", "≈ " + PP.fmt(m, 3)],
      ["M", "2", "good"],
    ]);
  };
  PP.register(draw, [ID + "-ej4-n"]);
})();

/* ===================== Ejercicio 5 ===================== */
(function () {
  const f = (n) => (x) => n * x * x / (1 + n * x * x);
  const df = (n) => (x) => 2 * n * x / Math.pow(1 + n * x * x, 2);
  const draw = function ej5() {
    const q = PP.radio(ID + "-ej5-q") || "f";
    const n = PP.val(ID + "-ej5-n");
    PP.out(ID + "-ej5-n-o", String(n));
    const g = q === "f" ? f : df;
    const top = q === "f" ? 1.08 : Math.max(1.2, 1.12 * 0.6496 * Math.sqrt(n));
    const { ctx, w, h } = PP.canvas(ID + "-ej5-c", 0.62);
    const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.04 * top, y1: top }, { l: 40, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 5 });
    [1, 2, 5, 10, 20, 50, 100].filter((k) => k < n).forEach((k) => curve(ctx, T, g(k), 0, 1, C("--muted"), 1, null, 800));
    curve(ctx, T, g(n), 0, 1, C("--accent"), 2.4, null, 1500);
    PP.label(ctx, q === "f" ? "fₙ" : "fₙ′", T.X(0.97), T.Y(g(n)(0.97)) - 6, C("--accent"), "right", "bottom", 12);
    PP.read(ID + "-ej5-read", [
      [q === "f" ? "f<sub>n</sub>(x)" : "f<sub>n</sub>′(x)", q === "f" ? "nx²/(1 + nx²)" : "2nx/(1 + nx²)²"],
      ["n", String(n)],
      [q === "f" ? "f<sub>n</sub>(1)" : "f<sub>n</sub>′(1)", PP.fmt(g(n)(1), 4)],
    ]);
  };
  PP.register(draw, [ID + "-ej5-n", "input[name=" + ID + "-ej5-q]"]);
})();

/* ===================== Ejercicio 8 ===================== */
(function () {
  const S = { x0: 0.35 };
  let lastT = null;
  const f = (n) => (x) => Math.sqrt(x * x + 1 / n);
  const df = (n) => (x) => x / Math.sqrt(x * x + 1 / n);
  const draw = function ej8() {
    const n = PP.val(ID + "-ej8-n");
    PP.out(ID + "-ej8-n-o", String(n));
    const { ctx, w, h } = PP.canvas(ID + "-ej8-c", 0.62);
    const T = PP.frame(w, h, { x0: -1.08, x1: 1.08, y0: -0.05, y1: 1.55 }, { l: 36, r: 12, t: 12, b: 28 });
    lastT = T;
    PP.axes(ctx, T, { xLabel: "x", yTicks: 4, xTicks: 5 });
    [1, 2].filter((k) => k < n).forEach((k) => curve(ctx, T, f(k), -1, 1, C("--muted"), 1));
    curve(ctx, T, f(n), -1, 1, C("--accent"), 2.4, null, 1200);
    [-1, 1].forEach((x) => PP.dot(ctx, T.X(x), T.Y(f(n)(x)), 4, C("--accent")));
    const x0 = S.x0, y0 = f(n)(x0), m = df(n)(x0), d = 0.32;
    PP.path(ctx, [[T.X(x0 - d), T.Y(y0 - m * d)], [T.X(x0 + d), T.Y(y0 + m * d)]], C("--seq2"), 2.2);
    PP.dot(ctx, T.X(x0), T.Y(y0), 7, C("--panel"), C("--seq2"));
    PP.dot(ctx, T.X(x0), T.Y(y0), 3, C("--seq2"));
    PP.read(ID + "-ej8-read", [
      ["x₀", PP.fmt(x0, 3)],
      ["f<sub>n</sub>′(x₀)", PP.fmt(m, 4)],
      ["|f<sub>n</sub>′(x₀)| ≤ c = 1", Math.abs(m) <= 1 ? "sí" : "no", "good"],
    ]);
  };
  PP.register(draw, [ID + "-ej8-n"]);
  draggable(ID + "-ej8-c", () => lastT,
    (px, py, T) => {
      const n = PP.val(ID + "-ej8-n");
      return Math.hypot(px - T.X(S.x0), py - T.Y(f(n)(S.x0))) < 24 ? "x" : null;
    },
    (k, x) => { S.x0 = clamp(x, -1, 1); }, draw);
})();
