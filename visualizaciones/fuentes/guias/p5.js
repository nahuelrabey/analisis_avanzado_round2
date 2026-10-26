/* Dibujos de la guía de la Práctica 5 (compacidad y punto fijo). Usa window.PP. */
const P = "guiap5";
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

/* ===================== Ejercicio 1 ===================== */
PP.register(function () {
  const N = PP.val(P + "-ej1-N");
  PP.out(P + "-ej1-N-o", String(N));
  const { ctx, w, h } = PP.canvas(P + "-ej1-c", 0.42);
  const pad = { l: 16, r: 16, t: 10, b: 10 };
  const rows = [[-0.05, 1.05, h * 0.3, "K"], [-0.004, 0.104, h * 0.75, "lupa en [0, 0.1]"]];
  rows.forEach(([x0, x1, yy, name], k) => {
    const X = (x) => pad.l + (x - x0) / (x1 - x0) * (w - pad.l - pad.r);
    PP.path(ctx, [[X(x0), yy], [X(x1), yy]], C("--muted"), 1);
    const ticks = k === 0 ? [0, 0.25, 0.5, 0.75, 1] : [0, 0.025, 0.05, 0.075, 0.1];
    ticks.forEach((t) => {
      PP.path(ctx, [[X(t), yy - 4], [X(t), yy + 4]], C("--muted"), 1);
      PP.label(ctx, PP.fmt(t, 3), X(t), yy + 8, C("--muted"), "center", "top", 10);
    });
    for (let n = 1; n <= N; n++) {
      const x = 1 / n; if (x < x0 || x > x1) continue;
      PP.dot(ctx, X(x), yy, n <= 3 ? 4.5 : 3.2, C("--accent"));
    }
    PP.dot(ctx, X(0), yy, 5, C("--ok"), C("--bg"));
    PP.label(ctx, name, pad.l, yy - 12, C("--muted"), "left", "bottom", 11);
  });
}, [P + "-ej1-N"]);

/* ===================== Ejercicio 3 ===================== */
(() => {
  const Ks = {
    int: [[0, 1], [2, 2.5]],
    neg: [[-1, -0.5], [1, 1]],
    seq: [[0, 0]].concat(Array.from({ length: 25 }, (_, i) => [1 / (i + 1), 1 / (i + 1)])),
  };
  const combine = (K, op) => {
    const out = [];
    K.forEach(([a, b]) => K.forEach(([c, d]) => {
      if (op === "+") out.push([a + c, b + d]);
      else { const v = [a * c, a * d, b * c, b * d]; out.push([Math.min(...v), Math.max(...v)]); }
    }));
    return out;
  };
  PP.register(function () {
    const which = PP.radio(P + "-ej3-k") || "int";
    const K = Ks[which], S = combine(K, "+"), Pp = combine(K, "*");
    const all = K.concat(S, Pp).flat();
    let lo = Math.min(...all), hi = Math.max(...all);
    const m = (hi - lo) * 0.06 || 0.5; lo -= m; hi += m;
    const { ctx, w, h } = PP.canvas(P + "-ej3-c", 0.5);
    const T = PP.frame(w, h, { x0: lo, x1: hi, y0: 0, y1: 1 }, { l: 28, r: 14, t: 8, b: 24 });
    const rows = [[K, 0.8, "K", C("--accent")], [S, 0.5, "S", C("--ok")], [Pp, 0.2, "P", C("--seq2")]];
    // eje común abajo
    const step = PP.niceStep(hi - lo, 6);
    for (let t = Math.ceil(lo / step) * step; t <= hi + 1e-9; t += step) {
      PP.path(ctx, [[T.X(t), T.p.t], [T.X(t), h - T.p.b]], C("--rule"), 1);
      PP.label(ctx, PP.fmt(t, 2), T.X(t), h - T.p.b + 5, C("--muted"), "center", "top", 10);
    }
    rows.forEach(([pieces, y, name, col]) => {
      PP.path(ctx, [[T.X(lo), T.Y(y)], [T.X(hi), T.Y(y)]], C("--muted"), 1);
      PP.label(ctx, name, 8, T.Y(y), col, "left", "middle", 13);
      pieces.forEach(([a, b]) => {
        if (b - a > 1e-9) { PP.path(ctx, [[T.X(a), T.Y(y)], [T.X(b), T.Y(y)]], col, 6); PP.dot(ctx, T.X(a), T.Y(y), 3.5, col); PP.dot(ctx, T.X(b), T.Y(y), 3.5, col); }
        else PP.dot(ctx, T.X(a), T.Y(y), which === "seq" ? 2.6 : 4.5, col);
      });
    });
  }, ["input[name='" + P + "-ej3-k']"]);
})();

/* ===================== Ejercicio 5 ===================== */
PP.register(function () {
  const N = PP.val(P + "-ej5-N");
  PP.out(P + "-ej5-N-o", String(N));
  const { ctx, w, h } = PP.canvas(P + "-ej5-c", 0.62);
  const T = PP.frame(w, h, { x0: -0.02, x1: 1.02, y0: N + 0.7, y1: 0.3 }, { l: 40, r: 14, t: 10, b: 24 });
  // y invertido: fila n = 1 arriba
  const Yr = (n) => T.p.t + (n - 0.3) / (N + 0.4) * (h - T.p.t - T.p.b);
  [0, 0.25, 0.5, 0.75, 1].forEach((t) => {
    PP.path(ctx, [[T.X(t), T.p.t], [T.X(t), h - T.p.b]], C("--rule"), 1);
    PP.label(ctx, PP.fmt(t, 2), T.X(t), h - T.p.b + 5, C("--muted"), "center", "top", 10);
  });
  const lw = Math.max(3, Math.min(10, (h - T.p.t - T.p.b) / (N + 1) * 0.45));
  for (let n = 1; n <= N; n++) {
    const y = Yr(n);
    PP.label(ctx, "F" + String(n).split("").map((d) => "₀₁₂₃₄₅₆₇₈₉"[+d]).join(""), T.p.l - 6, y, C("--muted"), "right", "middle", 11);
    const a = 1 / n, b = 1 - 1 / (2 * n);
    if (a >= b) PP.path(ctx, [[T.X(0), y], [T.X(1), y]], C("--accent"), lw);
    else { PP.path(ctx, [[T.X(0), y], [T.X(a), y]], C("--accent"), lw); PP.path(ctx, [[T.X(b), y], [T.X(1), y]], C("--accent"), lw); }
  }
}, [P + "-ej5-N"]);

/* ===================== Ejercicio 8 ===================== */
(() => {
  const c = [-1.2, 0.4], R = 1.2, s0 = [-1.2, 0.4], s1 = [2.8, -1.6];
  const pt = [[2.2, 1.9]];
  let T = null;
  const cid = P + "-ej8-c";
  function nearestK(x) {
    const dx = x[0] - c[0], dy = x[1] - c[1], r = Math.hypot(dx, dy);
    const dDisk = Math.max(0, r - R);
    const yDisk = r <= R ? x.slice() : [c[0] + R * dx / r, c[1] + R * dy / r];
    const vx = s1[0] - s0[0], vy = s1[1] - s0[1];
    const t = clamp(((x[0] - s0[0]) * vx + (x[1] - s0[1]) * vy) / (vx * vx + vy * vy), 0, 1);
    const ySeg = [s0[0] + t * vx, s0[1] + t * vy];
    const dSeg = Math.hypot(x[0] - ySeg[0], x[1] - ySeg[1]);
    return dDisk <= dSeg ? [dDisk, yDisk] : [dSeg, ySeg];
  }
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.72);
    T = eqFrame(w, h, -4, 4, 0);
    PP.path(ctx, [[T.X(-4), T.Y(0)], [T.X(4), T.Y(0)]], C("--rule"), 1);
    PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), h - T.p.b]], C("--rule"), 1);
    PP.circle(ctx, T.X(c[0]), T.Y(c[1]), T.X(c[0] + R) - T.X(c[0]), C("--accent"), C("--area"), null, 2);
    PP.path(ctx, [[T.X(s0[0]), T.Y(s0[1])], [T.X(s1[0]), T.Y(s1[1])]], C("--accent"), 3.5);
    PP.dot(ctx, T.X(s1[0]), T.Y(s1[1]), 3.5, C("--accent"));
    PP.label(ctx, "K", T.X(c[0]), T.Y(c[1] + R) - 4, C("--accent"), "center", "bottom", 14);
    const x = pt[0], [d, y] = nearestK(x);
    if (d > 0) PP.path(ctx, [[T.X(x[0]), T.Y(x[1])], [T.X(y[0]), T.Y(y[1])]], C("--ink"), 1.4, [4, 3]);
    PP.dot(ctx, T.X(y[0]), T.Y(y[1]), 5, C("--ok"), C("--bg"));
    PP.dot(ctx, T.X(x[0]), T.Y(x[1]), 7, C("--seq2"), C("--bg"));
    PP.label(ctx, "x", T.X(x[0]) + 9, T.Y(x[1]) - 4, C("--seq2"), "left", "bottom", 13);
    PP.label(ctx, "y", T.X(y[0]) - 8, T.Y(y[1]) + 4, C("--ok"), "right", "top", 13);
    PP.read(P + "-ej8-read", [
      ["x", "(" + PP.fmt(x[0], 2) + ", " + PP.fmt(x[1], 2) + ")"],
      ["y ∈ K más cercano", "(" + PP.fmt(y[0], 2) + ", " + PP.fmt(y[1], 2) + ")"],
      ["d(x, y) = d(x, K)", PP.fmt(d, 3)],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(pt, px, py, T, 24),
    (i, x, y, T) => { pt[0] = [clamp(x, -3.9, 3.9), clamp(y, T.box.y0 + 0.1, T.box.y1 - 0.1)]; }, draw);
})();

/* ===================== Ejercicio 9 ===================== */
(() => {
  const ctr = [[2.6, -1.2]];
  const par = (x) => x * x / 4 + 1;
  let T = null;
  const cid = P + "-ej9-c";
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.72);
    T = eqFrame(w, h, -5, 5, 0.8);
    PP.path(ctx, [[T.X(-5), T.Y(0)], [T.X(5), T.Y(0)]], C("--rule"), 1);
    PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), h - T.p.b]], C("--rule"), 1);
    // B: región sobre la parábola
    const pts = [];
    for (let x = -6; x <= 6.001; x += 0.05) pts.push([T.X(x), T.Y(par(x))]);
    clipBox(ctx, T);
    PP.path(ctx, pts.concat([[T.X(6), T.Y(T.box.y1 + 5)], [T.X(-6), T.Y(T.box.y1 + 5)]]), null, 0, null, true, C("--area3"));
    PP.path(ctx, pts, C("--seq3"), 2);
    ctx.restore();
    PP.label(ctx, "B", T.X(0), T.Y(par(0)) - 26, C("--seq3"), "center", "bottom", 14);
    // A: disco de radio 1
    const [cx, cy] = ctr[0];
    PP.circle(ctx, T.X(cx), T.Y(cy), T.X(cx + 1) - T.X(cx), C("--accent"), C("--area"), null, 2);
    PP.dot(ctx, T.X(cx), T.Y(cy), 5, C("--accent"), C("--bg"));
    PP.label(ctx, "A", T.X(cx), T.Y(cy - 1) + 4, C("--accent"), "center", "top", 14);
    // distancia del centro a B
    const inside = cy >= par(cx);
    let best = Infinity, q = null;
    for (let x = -10; x <= 10; x += 0.002) { const d = Math.hypot(x - cx, par(x) - cy); if (d < best) { best = d; q = [x, par(x)]; } }
    const dc = inside ? 0 : best;
    const dhat = Math.max(0, dc - 1);
    if (dhat > 0) {
      const u = [(q[0] - cx) / best, (q[1] - cy) / best];
      const p0 = [cx + u[0], cy + u[1]];
      PP.path(ctx, [[T.X(p0[0]), T.Y(p0[1])], [T.X(q[0]), T.Y(q[1])]], C("--ink"), 1.4, [4, 3]);
      PP.dot(ctx, T.X(p0[0]), T.Y(p0[1]), 4, C("--ink"));
      PP.dot(ctx, T.X(q[0]), T.Y(q[1]), 4, C("--ink"));
    }
    PP.read(P + "-ej9-read", [
      ["centro de A", "(" + PP.fmt(cx, 2) + ", " + PP.fmt(cy, 2) + ")"],
      ["A ∩ B", dhat > 0 ? "vacía" : "no vacía"],
      ["d̂(A, B)", PP.fmt(dhat, 3), dhat > 0 ? "good" : ""],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => {
    const [cx, cy] = ctr[0];
    return Math.hypot(T.X(cx) - px, T.Y(cy) - py) < T.X(cx + 1) - T.X(cx) + 6 ? 0 : null;
  }, (i, x, y, T) => { ctr[0] = [clamp(x, -4, 4), clamp(y, T.box.y0 + 1, T.box.y1 - 1)]; }, draw);
})();

/* ===================== Ejercicio 10 ===================== */
(() => {
  const xs = [0, 1 / 6, 2 / 6, 3 / 6, 4 / 6, 5 / 6, 1];
  const ys = [0.5, 0.9, -0.3, -0.8, 0.2, 0.95, 0.4];
  let T = null;
  const cid = P + "-ej10-c";
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.66);
    T = PP.frame(w, h, { x0: -0.04, x1: 1.04, y0: -1.8, y1: 1.8 }, { l: 36, r: 12, t: 12, b: 26 });
    PP.rect(ctx, T.X(0), T.Y(1), T.X(1) - T.X(0), T.Y(-1) - T.Y(1), null, C("--band"));
    PP.axes(ctx, T, { xTicks: 5 });
    [1, -1].forEach((v) => PP.path(ctx, [[T.X(0), T.Y(v)], [T.X(1), T.Y(v)]], C("--ok"), 1.5, [5, 4]));
    PP.label(ctx, "‖f − f₀‖∞ ≤ 1", T.X(1) - 2, T.Y(1) - 3, C("--ok"), "right", "bottom", 11);
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(0)]], C("--muted"), 2);
    PP.label(ctx, "f₀", T.X(0.02), T.Y(0) + 3, C("--muted"), "left", "top", 11);
    const F = pwl(xs, ys);
    PP.path(ctx, xs.map((x, i) => [T.X(x), T.Y(ys[i])]), C("--accent"), 2.4);
    xs.forEach((x, i) => PP.dot(ctx, T.X(x), T.Y(ys[i]), 5, C("--accent"), C("--bg")));
    const inBall = F.sup <= 1 + 1e-9;
    PP.read(P + "-ej10-read", [
      ["d∞(f, f₀)", PP.fmt(F.sup, 3)],
      ["d₁(f, f₀)", PP.fmt(F.I1, 3)],
      ["¿f en la bola cerrada de d∞?", inBall ? "sí" : "no", inBall ? "good" : "bad"],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(xs.map((x, i) => [x, ys[i]]), px, py, T),
    (i, x, y) => { ys[i] = clamp(Math.round(y * 50) / 50, -1.7, 1.7); }, draw);
})();

/* ===================== Ejercicio 12 ===================== */
(() => {
  const f = (x) => 1.6 * Math.sin(2 * x) / (1 + 0.2 * x * x);
  const L = 15;
  PP.register(function () {
    const eps = PP.val(P + "-ej12-e") / 100;
    PP.out(P + "-ej12-e-o", PP.fmt(eps, 2));
    let M = 0;
    for (let x = L; x >= 0; x -= 0.002) { if (Math.abs(f(x)) >= eps || Math.abs(f(-x)) >= eps) { M = x; break; } }
    const { ctx, w, h } = PP.canvas(P + "-ej12-c", 0.6);
    const T = PP.frame(w, h, { x0: -L, x1: L, y0: -1.7, y1: 1.7 }, { l: 34, r: 12, t: 12, b: 26 });
    PP.rect(ctx, T.X(-L), T.Y(eps), T.X(L) - T.X(-L), T.Y(-eps) - T.Y(eps), null, C("--band"));
    PP.axes(ctx, T, { xTicks: 6 });
    clipBox(ctx, T);
    plotFn(ctx, T, f, -L, L, C("--muted"), 1.4, null, 2000);
    if (M < L) {
      plotFn(ctx, T, f, M, L, C("--accent"), 2.6, null, 800);
      plotFn(ctx, T, f, -L, -M, C("--accent"), 2.6, null, 800);
      [M, -M].forEach((x) => PP.path(ctx, [[T.X(x), T.p.t], [T.X(x), h - T.p.b]], C("--ok"), 1.5, [5, 4]));
    }
    ctx.restore();
    if (M < L) {
      PP.label(ctx, "M", T.X(M) + 4, T.p.t + 2, C("--ok"), "left", "top", 12);
      PP.label(ctx, "−M", T.X(-M) - 4, T.p.t + 2, C("--ok"), "right", "top", 12);
    }
    PP.read(P + "-ej12-read", [
      ["ε", PP.fmt(eps, 2)],
      ["M (|f(x)| < ε si |x| ≥ M)", M < L ? PP.fmt(M, 2) : "fuera de la ventana"],
    ]);
  }, [P + "-ej12-e"]);
})();

/* ===================== Ejercicio 14 ===================== */
PP.register(function () {
  const a = PP.val(P + "-ej14-a") / 100;
  PP.out(P + "-ej14-a-o", PP.fmt(a, 2));
  const f = (x) => x / 2 + a * Math.cos(2 * x);
  const g = (x) => f(x) - x;
  const fix = [];
  const n = 4000;
  for (let i = 0; i < n; i++) {
    let u = -5 + 10 * i / n, v = -5 + 10 * (i + 1) / n;
    if (g(u) === 0) { fix.push(u); continue; }
    if (g(u) * g(v) < 0) { for (let k = 0; k < 50; k++) { const m = (u + v) / 2; if (g(u) * g(m) <= 0) v = m; else u = m; } fix.push((u + v) / 2); }
  }
  const { ctx, w, h } = PP.canvas(P + "-ej14-c", 0.72);
  const T = eqFrame(w, h, -5.3, 5.3, 0, { l: 26, r: 10, t: 10, b: 22 });
  PP.axes(ctx, T, { xTicks: 6, yTicks: 6, grid: false });
  clipBox(ctx, T);
  PP.path(ctx, [[T.X(-5), T.Y(-5)], [T.X(5), T.Y(5)]], C("--muted"), 1.2, [5, 4]);
  plotFn(ctx, T, f, -5, 5, C("--accent"), 2.4, null, 800);
  ctx.restore();
  fix.forEach((x) => {
    PP.path(ctx, [[T.X(x), T.Y(x)], [T.X(x), T.Y(0)]], C("--seq2"), 1, [2, 3]);
    PP.dot(ctx, T.X(x), T.Y(x), 4.5, C("--seq2"));
    PP.dot(ctx, T.X(x), T.Y(0), 4.5, C("--seq2"), C("--bg"));
  });
  PP.label(ctx, "y = x", T.X(4.6), T.Y(4.6) + 4, C("--muted"), "right", "top", 11);
  PP.read(P + "-ej14-read", [
    ["a", PP.fmt(a, 2)],
    ["puntos fijos hallados", fix.length ? fix.map((x) => PP.fmt(x, 3)).join(", ") : "ninguno"],
  ]);
}, [P + "-ej14-a"]);

/* ===================== Ejercicio 15 ===================== */
(() => {
  const f = (x) => 0.5 * Math.atan(x) + 3;
  PP.register(function () {
    const x0 = PP.val(P + "-ej15-x") / 10;
    PP.out(P + "-ej15-x-o", PP.fmt(x0, 1));
    const { ctx, w, h } = PP.canvas(P + "-ej15-c", 0.72);
    const T = eqFrame(w, h, -4.5, 8.5, 2.2, { l: 26, r: 10, t: 10, b: 22 });
    PP.axes(ctx, T, { xTicks: 7, yTicks: 6, grid: false });
    clipBox(ctx, T);
    PP.path(ctx, [[T.X(-5), T.Y(-5)], [T.X(9), T.Y(9)]], C("--muted"), 1.2, [5, 4]);
    plotFn(ctx, T, f, -4.5, 8.5, C("--accent"), 2.4, null, 600);
    // telaraña
    const it = [x0];
    for (let k = 0; k < 12; k++) it.push(f(it[it.length - 1]));
    const web = [[T.X(x0), T.Y(0)], [T.X(x0), T.Y(it[1])]];
    for (let k = 1; k < it.length - 1; k++) { web.push([T.X(it[k]), T.Y(it[k])]); web.push([T.X(it[k]), T.Y(it[k + 1])]); }
    PP.path(ctx, web, C("--seq2"), 1.4);
    ctx.restore();
    PP.dot(ctx, T.X(x0), T.Y(0), 5, C("--seq2"), C("--bg"));
    PP.label(ctx, "x₀", T.X(x0), T.Y(0) + 7, C("--seq2"), "center", "top", 12);
    PP.label(ctx, "y = x", T.X(8), T.Y(8) + 4, C("--muted"), "left", "top", 11);
    PP.read(P + "-ej15-read", [
      ["x₀ … x₃", it.slice(0, 4).map((v) => PP.fmt(v, 2)).join("; ")],
      ["pasos |xₖ₊₁ − xₖ|", [1, 2, 3].map((k) => PP.fmt(Math.abs(it[k] - it[k - 1]), 2)).join("; ")],
    ]);
  }, [P + "-ej15-x"]);
})();

/* ===================== Ejercicio 16 ===================== */
PP.register(function () {
  const { ctx, w, h } = PP.canvas(P + "-ej16-c", 0.62);
  const T = eqFrame(w, h, -3.2, 3.2, 0, { l: 26, r: 10, t: 10, b: 22 });
  PP.axes(ctx, T, { xTicks: 6, yTicks: 4, grid: false, zero: false });
  // eje x con el hueco en 0
  PP.path(ctx, [[T.X(-3.2), T.Y(0)], [T.X(3.2), T.Y(0)]], C("--muted"), 1.2);
  PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), h - T.p.b]], C("--rule"), 1);
  clipBox(ctx, T);
  PP.path(ctx, [[T.X(-3.2), T.Y(-3.2)], [T.X(3.2), T.Y(3.2)]], C("--muted"), 1.2, [5, 4]);
  PP.path(ctx, [[T.X(-3.2), T.Y(-3.2 / 3)], [T.X(-0.04), T.Y(-0.04 / 3)]], C("--accent"), 2.6);
  PP.path(ctx, [[T.X(0.04), T.Y(0.04 / 3)], [T.X(3.2), T.Y(3.2 / 3)]], C("--accent"), 2.6);
  ctx.restore();
  PP.dot(ctx, T.X(0), T.Y(0), 6, C("--bg"), C("--seq2"));
  PP.label(ctx, "0 ∉ E", T.X(0) + 9, T.Y(0) + 6, C("--seq2"), "left", "top", 12);
  PP.label(ctx, "f(x) = x/3", T.X(3.1), T.Y(3.2 / 3) - 6, C("--accent"), "right", "bottom", 12);
  PP.label(ctx, "y = x", T.X(2.2), T.Y(2.2) - 4, C("--muted"), "right", "bottom", 11);
}, []);

/* ===================== Ejercicio 17 ===================== */
PP.register(function () {
  const n = PP.val(P + "-ej17-n");
  PP.out(P + "-ej17-n-o", String(n));
  const cosn = (x) => { for (let k = 0; k < n; k++) x = Math.cos(x); return x; };
  const { ctx, w, h } = PP.canvas(P + "-ej17-c", 0.62);
  const T = PP.frame(w, h, { x0: -4, x1: 4, y0: -1.4, y1: 1.4 }, { l: 34, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { xTicks: 8 });
  clipBox(ctx, T);
  PP.path(ctx, [[T.X(-4), T.Y(-4)], [T.X(4), T.Y(4)]], C("--muted"), 1.2, [5, 4]);
  plotFn(ctx, T, Math.cos, -4, 4, C("--seq2"), 1.4, [3, 3], 600);
  plotFn(ctx, T, cosn, -4, 4, C("--accent"), 2.6, null, 800);
  ctx.restore();
  PP.label(ctx, n === 1 ? "cos" : "cos" + String(n).split("").map((d) => "⁰¹²³⁴⁵⁶⁷⁸⁹"[+d]).join(""), T.X(-3.9), T.p.t + 4, C("--accent"), "left", "top", 13);
  PP.label(ctx, "y = x", T.X(1.3), T.Y(1.3) - 2, C("--muted"), "right", "bottom", 11);
}, [P + "-ej17-n"]);

/* ===================== Ejercicio 19 ===================== */
(() => {
  const xs = [0, 0.2, 0.4, 0.6, 0.8, 1];
  const ys = [0.8, 0.95, 0.55, 0.25, 0.45, 0.1];
  let T = null;
  const cid = P + "-ej19-c";
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.8);
    T = eqFrame(w, h, -0.12, 1.12, 0.5, { l: 26, r: 10, t: 12, b: 24 });
    PP.rect(ctx, T.X(0), T.Y(1), T.X(1) - T.X(0), T.Y(0) - T.Y(1), C("--muted"), C("--band"));
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1), T.Y(1)]], C("--muted"), 1.2, [5, 4]);
    PP.label(ctx, "a", T.X(0), T.Y(0) + 5, C("--muted"), "center", "top", 12);
    PP.label(ctx, "b", T.X(1), T.Y(0) + 5, C("--muted"), "center", "top", 12);
    PP.label(ctx, "a", T.X(0) - 6, T.Y(0), C("--muted"), "right", "middle", 12);
    PP.label(ctx, "b", T.X(0) - 6, T.Y(1), C("--muted"), "right", "middle", 12);
    PP.label(ctx, "y = x", T.X(0.95), T.Y(0.95) + 4, C("--muted"), "right", "top", 11);
    PP.path(ctx, xs.map((x, i) => [T.X(x), T.Y(ys[i])]), C("--accent"), 2.6);
    xs.forEach((x, i) => PP.dot(ctx, T.X(x), T.Y(ys[i]), 5, C("--accent"), C("--bg")));
    PP.label(ctx, "f", T.X(xs[1]) + 6, T.Y(ys[1]) - 4, C("--accent"), "left", "bottom", 13);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(xs.map((x, i) => [x, ys[i]]), px, py, T),
    (i, x, y) => { ys[i] = clamp(Math.round(y * 50) / 50, 0, 1); }, draw);
})();
