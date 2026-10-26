/* Dibujos de la guía de la Práctica 4 (funciones continuas). Usa window.PP. */
const P = "guiap4";
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
(() => {
  const f = (x, y) => (x === 0 && y === 0 ? 0 : (x * x * y) / (0.5 * x * x + (x - 1) * (x - 1) * y * y));
  PP.register(function () {
    const v = PP.val(P + "-ej1-R");
    const R = 0.02 * Math.pow(150, v / 100);
    PP.out(P + "-ej1-R-o", "R = " + PP.fmt(R, R < 0.1 ? 3 : 2));
    const { ctx, w, h } = PP.canvas(P + "-ej1-c", 0.86);
    const T = eqFrame(w, h, -R * (w / h) * 1.0, R * (w / h) * 1.0, 0, { l: 10, r: 10, t: 10, b: 10 });
    const cell = 4;
    let mx = 0;
    const pos = C("--accent"), neg = C("--seq2");
    ctx.save();
    for (let px = T.p.l; px < w - T.p.r; px += cell) {
      for (let py = T.p.t; py < h - T.p.b; py += cell) {
        const x = T.iX(px + cell / 2), y = T.iY(py + cell / 2);
        if (Math.abs(x) > R || Math.abs(y) > R) continue;
        const z = f(x, y);
        if (!isFinite(z)) continue;
        mx = Math.max(mx, Math.abs(z));
        ctx.globalAlpha = Math.pow(Math.min(1, Math.abs(z) / 2), 0.7);
        ctx.fillStyle = z > 0 ? pos : neg;
        ctx.fillRect(px, py, cell, cell);
      }
    }
    ctx.restore();
    // cuadrado de la ventana y ejes
    PP.rect(ctx, T.X(-R), T.Y(R), T.X(R) - T.X(-R), T.Y(-R) - T.Y(R), C("--rule"), null);
    PP.path(ctx, [[T.X(-R), T.Y(0)], [T.X(R), T.Y(0)]], C("--muted"), 1);
    PP.path(ctx, [[T.X(0), T.Y(-R)], [T.X(0), T.Y(R)]], C("--muted"), 1);
    PP.dot(ctx, T.X(0), T.Y(0), 4.5, C("--ink"));
    PP.label(ctx, "x", T.X(R) - 4, T.Y(0) - 4, C("--muted"), "right", "bottom", 12);
    PP.label(ctx, "y", T.X(0) + 5, T.Y(R) + 4, C("--muted"), "left", "top", 12);
    PP.label(ctx, PP.fmt(R, 3), T.X(R) - 4, T.Y(0) + 4, C("--muted"), "right", "top", 11);
    PP.read(P + "-ej1-read", [
      ["ventana", "[−" + PP.fmt(R, 3) + ", " + PP.fmt(R, 3) + "]²"],
      ["máx |f| en la grilla", PP.fmt(mx, 4)],
      ["f(0, 0)", "0 (por definición)"],
    ]);
  }, [P + "-ej1-R"]);
})();

/* ===================== Ejercicio 2 ===================== */
PP.register(function () {
  const Q = PP.val(P + "-ej2-q");
  PP.out(P + "-ej2-q-o", String(Q));
  const { ctx, w, h } = PP.canvas(P + "-ej2-c", 0.7);
  const T = PP.frame(w, h, { x0: -2.15, x1: 2.15, y0: -2.2, y1: 2.2 }, { l: 34, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { xTicks: 8, yTicks: 8 });
  PP.path(ctx, [[T.X(-2.15), T.Y(-2.15)], [T.X(2.15), T.Y(2.15)]], C("--muted"), 1, [3, 4]);
  PP.path(ctx, [[T.X(-2.15), T.Y(0)], [T.X(2.15), T.Y(0)]], C("--seq2"), 2.5);
  let cnt = 0;
  const r = Q <= 6 ? 3.6 : Q <= 15 ? 2.6 : 1.8;
  for (let q = 1; q <= Q; q++) {
    for (let p = -2 * q; p <= 2 * q; p++) {
      if (gcd(p, q) !== 1 && !(p === 0 && q === 1)) continue;
      const x = p / q; cnt++;
      PP.dot(ctx, T.X(x), T.Y(x), r, C("--accent"));
    }
  }
  PP.label(ctx, "y = 0 (irracionales)", T.X(2.1), T.Y(0) + 5, C("--seq2"), "right", "top", 11);
  PP.label(ctx, "y = x (racionales)", T.X(-2.05), T.Y(1.9), C("--accent"), "left", "top", 11);
  PP.read(P + "-ej2-read", [
    ["racionales dibujados", String(cnt)],
    ["denominador máximo", String(Q)],
  ]);
}, [P + "-ej2-q"]);

/* ===================== Ejercicio 3 ===================== */
(() => {
  const f = (x) => Math.sin(x) + 0.35;
  PP.register(function () {
    const x0 = PP.val(P + "-ej3-x") / 100;
    PP.out(P + "-ej3-x-o", PP.fmt(x0, 2));
    const { ctx, w, h } = PP.canvas(P + "-ej3-c", 0.62);
    const T = PP.frame(w, h, { x0: -1.5, x1: 7, y0: -1, y1: 1.6 }, { l: 34, r: 12, t: 12, b: 26 });
    const fx = f(x0);
    let r = null;
    if (fx > 0) {
      const step = 0.001, cap = 4;
      let a = 0; while (a < cap && f(x0 - a - step) > 0) a += step;
      let b = 0; while (b < cap && f(x0 + b + step) > 0) b += step;
      r = Math.min(a, b);
      PP.rect(ctx, T.X(x0 - r), T.p.t, T.X(x0 + r) - T.X(x0 - r), h - T.p.t - T.p.b, null, C("--band"));
    }
    PP.axes(ctx, T, { xTicks: 8 });
    clipBox(ctx, T);
    plotFn(ctx, T, f, -1.5, 7, C("--accent"), 2.2);
    if (r !== null) {
      plotFn(ctx, T, f, x0 - r, x0 + r, C("--ok"), 3.2, null, 200);
      PP.path(ctx, [[T.X(x0 - r), T.Y(0)], [T.X(x0 + r), T.Y(0)]], C("--ok"), 4);
      PP.dot(ctx, T.X(x0 - r), T.Y(0), 4.5, C("--bg"), C("--ok"));
      PP.dot(ctx, T.X(x0 + r), T.Y(0), 4.5, C("--bg"), C("--ok"));
    }
    ctx.restore();
    PP.path(ctx, [[T.X(x0), T.Y(0)], [T.X(x0), T.Y(fx)]], C("--ink"), 1, [3, 3]);
    PP.dot(ctx, T.X(x0), T.Y(fx), 5, C("--ink"));
    PP.dot(ctx, T.X(x0), T.Y(0), 3.5, C("--ink"));
    PP.label(ctx, "x₀", T.X(x0) + 4, T.Y(0) + 4, C("--ink"), "left", "top", 12);
    PP.label(ctx, "f(x₀)", T.X(x0) + 7, T.Y(fx) - 4, C("--ink"), "left", "bottom", 12);
    PP.read(P + "-ej3-read", [
      ["f(x₀)", PP.fmt(fx, 3), fx > 0 ? "good" : "bad"],
      ["r (la mayor bola con f > 0)", r === null ? "f(x₀) ≤ 0: no se aplica" : PP.fmt(r, 3)],
    ]);
  }, [P + "-ej3-x"]);
})();

/* ===================== Ejercicio 4 ===================== */
PP.register(function () {
  const c = PP.val(P + "-ej4-c0") / 100;
  PP.out(P + "-ej4-c0-o", PP.fmt(c, 2));
  const L = 4 * Math.PI;
  const { ctx, w, h } = PP.canvas(P + "-ej4-c", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: L, y0: -1.75, y1: 1.4 }, { l: 34, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { xTicks: 6 });
  clipBox(ctx, T);
  plotFn(ctx, T, Math.sin, 0, L, C("--accent"), 2.2);
  PP.path(ctx, [[T.X(0), T.Y(c)], [T.X(L), T.Y(c)]], C("--ok"), 2);
  ctx.restore();
  // puntos donde f = g
  const pts = [];
  if (Math.abs(c) <= 1) {
    const a = Math.asin(c);
    for (let k = -1; k <= 2; k++) {
      [a + 2 * k * Math.PI, Math.PI - a + 2 * k * Math.PI].forEach((x) => { if (x >= -1e-9 && x <= L + 1e-9 && !pts.some((p) => Math.abs(p - x) < 1e-6)) pts.push(x); });
    }
  }
  pts.sort((u, v) => u - v);
  const yb = -1.55;
  PP.path(ctx, [[T.X(0), T.Y(yb)], [T.X(L), T.Y(yb)]], C("--accent"), 5);
  pts.forEach((x) => {
    PP.dot(ctx, T.X(x), T.Y(yb), 6, C("--bg"));
    PP.dot(ctx, T.X(x), T.Y(yb), 4, C("--seq2"));
    PP.path(ctx, [[T.X(x), T.Y(yb)], [T.X(x), T.Y(c)]], C("--seq2"), 1, [2, 3]);
    PP.dot(ctx, T.X(x), T.Y(c), 3.5, C("--seq2"));
  });
  PP.label(ctx, "{f ≠ g}", T.X(L) - 2, T.Y(yb) - 5, C("--accent"), "right", "bottom", 11);
  PP.read(P + "-ej4-read", [
    ["g(x)", "= " + PP.fmt(c, 2) + " (constante)"],
    ["puntos de {f = g} en [0, 4π]", String(pts.length)],
  ]);
}, [P + "-ej4-c0"]);

/* ===================== Ejercicio 5 ===================== */
(() => {
  const s = (x) => Math.sin(Math.exp(x) - 1);
  const yOf = (x) => -(2 + x * x) / s(x);
  const x0 = -3, x1 = 2.5;
  const poles = [];
  for (let k = 0; ; k++) { const x = Math.log(1 + k * Math.PI); if (x > x1) break; poles.push(x); }
  PP.register(function () {
    const H = PP.val(P + "-ej5-y");
    PP.out(P + "-ej5-y-o", "±" + H);
    const { ctx, w, h } = PP.canvas(P + "-ej5-c", 0.72);
    const T = PP.frame(w, h, { x0, x1, y0: -H, y1: H }, { l: 38, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xTicks: 6, yTicks: 6 });
    poles.forEach((x) => PP.path(ctx, [[T.X(x), T.p.t], [T.X(x), h - T.p.b]], C("--muted"), 1, [4, 4]));
    clipBox(ctx, T);
    plotFn(ctx, T, yOf, x0, x1, C("--accent"), 2.2, null, 4000, (a, b) => s(a) * s(b) <= 0);
    ctx.restore();
    PP.label(ctx, "x² + y sen(eˣ − 1) = −2", T.p.l + 6, T.p.t + 4, C("--accent"), "left", "top", 12);
    PP.read(P + "-ej5-read", [
      ["sen(eˣ − 1) = 0 en x =", poles.map((x) => PP.fmt(x, 3)).join(", ") + ", …"],
      ["ventana", "x ∈ [−3, 2,5], y ∈ [−" + H + ", " + H + "]"],
    ]);
  }, [P + "-ej5-y"]);
})();

/* ===================== Ejercicio 6 ===================== */
PP.register(function () {
  const which = PP.radio(P + "-ej6-f") || "f";
  const { ctx, w, h } = PP.canvas(P + "-ej6-c", 0.62);
  const box = which === "f" ? { x0: -4, x1: 4, y0: -1, y1: 10 } : { x0: -4, x1: 4, y0: -0.15, y1: 1.25 };
  const T = PP.frame(w, h, box, { l: 36, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { xTicks: 8 });
  clipBox(ctx, T);
  if (which === "f") {
    plotFn(ctx, T, (x) => x * x, -4, 4, C("--accent"), 2.4);
  } else {
    PP.path(ctx, [[T.X(-4), T.Y(1)], [T.X(4), T.Y(1)]], C("--muted"), 1.2, [5, 4]);
    plotFn(ctx, T, (x) => (x * x) / (1 + x * x), -4, 4, C("--seq3"), 2.4);
  }
  ctx.restore();
  PP.label(ctx, which === "f" ? "f(x) = x²" : "g(x) = x²/(1 + x²)", T.p.l + 8, T.p.t + 4, which === "f" ? C("--accent") : C("--seq3"), "left", "top", 13);
  if (which === "g") PP.label(ctx, "y = 1", T.X(4) - 4, T.Y(1) - 4, C("--muted"), "right", "bottom", 11);
}, ["input[name='" + P + "-ej6-f']"]);

/* ===================== Ejercicio 7 ===================== */
(() => {
  const f = (x) => 0.5 + 0.32 * Math.sin(2 * Math.PI * x) + 0.12 * Math.cos(5 * Math.PI * x);
  PP.register(function () {
    const Q = PP.val(P + "-ej7-q");
    PP.out(P + "-ej7-q-o", String(Q));
    const { ctx, w, h } = PP.canvas(P + "-ej7-c", 0.62);
    const T = PP.frame(w, h, { x0: -0.03, x1: 1.03, y0: 0, y1: 1 }, { l: 34, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xTicks: 5 });
    plotFn(ctx, T, f, 0, 1, C("--muted"), 1.2, [4, 4]);
    let cnt = 0;
    const r = Q <= 8 ? 3.6 : Q <= 20 ? 2.6 : 1.8;
    for (let q = 1; q <= Q; q++) {
      for (let p = 0; p <= q; p++) {
        if (gcd(p, q) !== 1 && !(p === 0 && q === 1)) continue;
        cnt++;
        PP.dot(ctx, T.X(p / q), T.Y(f(p / q)), r, C("--accent"));
      }
    }
    PP.read(P + "-ej7-read", [
      ["racionales de [0, 1] dibujados", String(cnt)],
      ["denominador máximo", String(Q)],
    ]);
  }, [P + "-ej7-q"]);
})();

/* ===================== Ejercicio 9 ===================== */
(() => {
  const xs = [0, 0.2, 0.4, 0.6, 0.8, 1];
  const ys = [0.9, 0.3, -0.4, 0.2, 0.7, 0.5];
  let T = null;
  const cid = P + "-ej9-c";
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.66);
    T = PP.frame(w, h, { x0: -0.04, x1: 1.04, y0: -1.6, y1: 1.6 }, { l: 36, r: 12, t: 12, b: 26 });
    const F = pwl(xs, ys);
    shadeArea(ctx, T, xs, ys, C("--area"), C("--area2"));
    PP.axes(ctx, T, { xTicks: 5 });
    PP.path(ctx, xs.map((x, i) => [T.X(x), T.Y(ys[i])]), C("--accent"), 2.4);
    xs.forEach((x, i) => PP.dot(ctx, T.X(x), T.Y(ys[i]), i === 0 ? 7 : 5, i === 0 ? C("--ink") : C("--accent"), C("--bg")));
    PP.label(ctx, "(0, 𝓔(f))", T.X(0) + 10, T.Y(ys[0]) - 6, C("--ink"), "left", "bottom", 12);
    PP.read(P + "-ej9-read", [
      ["𝓔(f) = f(0)", PP.fmt(ys[0], 3)],
      ["𝓘(f) = ∫ f", PP.fmt(F.I, 3)],
      ["d∞(f, 0) = máx |f|", PP.fmt(F.sup, 3)],
      ["d₁(f, 0) = ∫ |f|", PP.fmt(F.I1, 3)],
    ]);
  }
  PP.register(draw, []);
  draggable(cid, () => T, (px, py, T) => nearest(xs.map((x, i) => [x, ys[i]]), px, py, T),
    (i, x, y) => { ys[i] = clamp(Math.round(y * 50) / 50, -1.5, 1.5); }, draw);
})();

/* ===================== Ejercicio 10 ===================== */
(() => {
  const pts = [[-1, 0.5], [2, 1.5]];
  let T = null;
  const cid = P + "-ej10-c";
  const dist = (m, a, b) => {
    const dx = Math.abs(a[0] - b[0]), dy = Math.abs(a[1] - b[1]);
    return m === "1" ? dx + dy : m === "inf" ? Math.max(dx, dy) : Math.hypot(dx, dy);
  };
  function draw() {
    const m = PP.radio(P + "-ej10-m") || "2";
    const { ctx, w, h } = PP.canvas(cid, 0.75);
    T = eqFrame(w, h, -5, 5, 0);
    PP.path(ctx, [[T.X(-5), T.Y(0)], [T.X(5), T.Y(0)]], C("--rule"), 1);
    PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), h - T.p.b]], C("--rule"), 1);
    const [cx, cy] = pts[0];
    [1, 2, 3].forEach((r, k) => {
      const col = [C("--accent"), C("--seq3"), C("--muted")][k];
      let poly;
      if (m === "2") { PP.circle(ctx, T.X(cx), T.Y(cy), T.X(cx + r) - T.X(cx), col, null, null, 1.6); }
      else {
        poly = m === "1" ? [[cx + r, cy], [cx, cy + r], [cx - r, cy], [cx, cy - r]] : [[cx + r, cy + r], [cx - r, cy + r], [cx - r, cy - r], [cx + r, cy - r]];
        PP.path(ctx, poly.map(([x, y]) => [T.X(x), T.Y(y)]), col, 1.6, null, true);
      }
      PP.label(ctx, String(r), T.X(cx + (m === "inf" ? r : r)) + 3, T.Y(cy) - 2, col, "left", "bottom", 11);
    });
    PP.path(ctx, [[T.X(cx), T.Y(cy)], [T.X(pts[1][0]), T.Y(pts[1][1])]], C("--ink"), 1, [3, 3]);
    PP.dot(ctx, T.X(cx), T.Y(cy), 7, C("--accent"), C("--bg"));
    PP.label(ctx, "x₀", T.X(cx) - 8, T.Y(cy) + 6, C("--accent"), "right", "top", 13);
    PP.dot(ctx, T.X(pts[1][0]), T.Y(pts[1][1]), 7, C("--seq2"), C("--bg"));
    PP.label(ctx, "x", T.X(pts[1][0]) + 9, T.Y(pts[1][1]) - 4, C("--seq2"), "left", "bottom", 13);
    const name = m === "1" ? "d₁" : m === "inf" ? "d∞" : "d₂";
    PP.read(P + "-ej10-read", [
      ["x₀", "(" + PP.fmt(cx, 2) + ", " + PP.fmt(cy, 2) + ")"],
      ["x", "(" + PP.fmt(pts[1][0], 2) + ", " + PP.fmt(pts[1][1], 2) + ")"],
      ["f(x) = " + name + "(x, x₀)", PP.fmt(dist(m, pts[1], pts[0]), 3)],
    ]);
  }
  PP.register(draw, ["input[name='" + P + "-ej10-m']"]);
  draggable(cid, () => T, (px, py, T) => nearest(pts, px, py, T, 22),
    (i, x, y, T) => { pts[i] = [clamp(Math.round(x * 10) / 10, -4.8, 4.8), clamp(Math.round(y * 10) / 10, T.box.y0 + 0.2, T.box.y1 - 0.2)]; }, draw);
})();

/* ===================== Ejercicio 11 ===================== */
(() => {
  const dInt = (x, a, b) => (x < a ? a - x : x > b ? x - b : 0);
  PP.register(function () {
    const b = PP.val(P + "-ej11-b") / 100;
    PP.out(P + "-ej11-b-o", "b = " + PP.fmt(b, 2));
    const A = [-3, -1.5], B = [b, b + 1.5];
    const dA = (x) => dInt(x, A[0], A[1]), dB = (x) => dInt(x, B[0], B[1]);
    const hh = (x) => dA(x) / (dA(x) + dB(x));
    const { ctx, w, h } = PP.canvas(P + "-ej11-c", 0.66);
    const T = PP.frame(w, h, { x0: -4.5, x1: 4.5, y0: -0.35, y1: 2.6 }, { l: 32, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xTicks: 9, yTicks: 5 });
    PP.path(ctx, [[T.X(-4.5), T.Y(1)], [T.X(4.5), T.Y(1)]], C("--rule"), 1, [4, 4]);
    clipBox(ctx, T);
    plotFn(ctx, T, dA, -4.5, 4.5, C("--seq2"), 2, null, 900);
    plotFn(ctx, T, dB, -4.5, 4.5, C("--seq3"), 2, null, 900);
    plotFn(ctx, T, hh, -4.5, 4.5, C("--accent"), 3, null, 900);
    ctx.restore();
    const ya = -0.2;
    PP.path(ctx, [[T.X(A[0]), T.Y(ya)], [T.X(A[1]), T.Y(ya)]], C("--seq2"), 6);
    PP.path(ctx, [[T.X(B[0]), T.Y(ya)], [T.X(B[1]), T.Y(ya)]], C("--seq3"), 6);
    PP.label(ctx, "A", T.X((A[0] + A[1]) / 2), T.Y(ya) - 6, C("--seq2"), "center", "bottom", 13);
    PP.label(ctx, "B", T.X((B[0] + B[1]) / 2), T.Y(ya) - 6, C("--seq3"), "center", "bottom", 13);
    PP.label(ctx, "h", T.X(4.3), T.Y(hh(4.3)) - 5, C("--accent"), "right", "bottom", 13);
    PP.label(ctx, "d(x, A)", T.X(0.6), T.Y(Math.min(2.4, dA(0.6))) - 4, C("--seq2"), "center", "bottom", 11);
    PP.read(P + "-ej11-read", [
      ["A", "[−3, −1.5]"],
      ["B", "[" + PP.fmt(B[0], 2) + ", " + PP.fmt(B[1], 2) + "]"],
      ["separación entre A y B", PP.fmt(B[0] - A[1], 2)],
    ]);
  }, [P + "-ej11-b"]);
})();

/* ===================== Ejercicio 13 ===================== */
PP.register(function () {
  const which = PP.radio(P + "-ej13-f") || "inv";
  const eps = PP.val(P + "-ej13-e") / 100;
  PP.out(P + "-ej13-e-o", PP.fmt(eps, 2));
  const { ctx, w, h } = PP.canvas(P + "-ej13-c", 0.62);
  if (which === "inv") {
    const T = PP.frame(w, h, { x0: 0, x1: 3, y0: 0, y1: 10 }, { l: 34, r: 12, t: 12, b: 26 });
    PP.rect(ctx, T.X(eps), T.p.t, T.X(3) - T.X(eps), h - T.p.t - T.p.b, null, C("--band"));
    PP.axes(ctx, T, { xTicks: 6 });
    clipBox(ctx, T);
    plotFn(ctx, T, (x) => 1 / x, 0.05, 3, C("--muted"), 1.6, null, 800);
    plotFn(ctx, T, (x) => 1 / x, eps, 3, C("--accent"), 2.6, null, 800);
    ctx.restore();
    PP.path(ctx, [[T.X(eps), T.Y(0)], [T.X(3), T.Y(0)]], C("--accent"), 5);
    PP.dot(ctx, T.X(eps), T.Y(0), 4.5, C("--accent"));
    PP.label(ctx, "[ε, +∞)", T.X(eps) + 6, T.Y(0) - 6, C("--accent"), "left", "bottom", 12);
    PP.label(ctx, "f(x) = 1/x", T.X(3) - 4, T.p.t + 4, C("--accent"), "right", "top", 13);
  } else {
    const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -1.25, y1: 1.25 }, { l: 34, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xTicks: 5 });
    clipBox(ctx, T);
    // muestreo uniforme en t = 1/x para seguir las oscilaciones
    const pts = [];
    for (let t = 1; t <= 400; t += 0.02) pts.push([T.X(1 / t), T.Y(Math.sin(t))]);
    PP.path(ctx, pts, C("--accent"), 1.4);
    ctx.restore();
    PP.label(ctx, "f(x) = sen(1/x)", T.X(1) - 4, T.p.t + 4, C("--accent"), "right", "top", 13);
  }
}, ["input[name='" + P + "-ej13-f']", P + "-ej13-e"]);
