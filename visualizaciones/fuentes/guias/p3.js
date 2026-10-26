/* Dibujos de la guía de la Práctica 3 (enunciados). Usa window.PP. */
const G = "guiap3";
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const gcd = (a, b) => (b === 0 ? Math.abs(a) : gcd(b, a % b));

/* Marco con la misma escala en x y en y, centrado en (cx, cy) con semiancho hx. */
function eqFrame(w, h, cx, cy, hx, pad) {
  const p = Object.assign({ l: 10, r: 10, t: 10, b: 10 }, pad || {});
  const hy = hx * (h - p.t - p.b) / (w - p.l - p.r);
  return PP.frame(w, h, { x0: cx - hx, x1: cx + hx, y0: cy - hy, y1: cy + hy }, p);
}
function plainAxes(ctx, T) {
  const { box } = T;
  PP.path(ctx, [[T.X(box.x0), T.Y(0)], [T.X(box.x1), T.Y(0)]], C("--rule"), 1);
  PP.path(ctx, [[T.X(0), T.Y(box.y0)], [T.X(0), T.Y(box.y1)]], C("--rule"), 1);
}
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
function numberLine(ctx, T, y0, x0, x1, step) {
  PP.path(ctx, [[T.X(x0), y0], [T.X(x1), y0]], C("--muted"), 1.2);
  for (let k = Math.ceil(x0 / step - 1e-9) * step; k <= x1 + 1e-9; k += step) {
    PP.path(ctx, [[T.X(k), y0 - 4], [T.X(k), y0 + 4]], C("--muted"), 1);
    PP.label(ctx, PP.fmt(k, 2).replace("-", "−"), T.X(k), y0 + 8, C("--muted"), "center", "top", 11);
  }
}

/* ===================== Ejercicio 1 ===================== */
const e1 = { c: [0.3, 0.2], x1: 0.4, T: null, mode: "b" };
const E8 = [[-1.6, 0.9], [-0.7, -0.8], [0.2, 1.1], [0.9, -0.3], [1.7, 0.8], [-1.9, -0.6], [1.4, -1.1], [0, 0]];
let e1Center = 7;
function drawEj1() {
  const it = PP.radio(G + "-ej1-it"), r = PP.val(G + "-ej1-r") / 100;
  e1.mode = it;
  PP.out(G + "-ej1-r-o", PP.fmt(r, 2));
  if (it === "a") {
    const { ctx, w, h } = PP.canvas(G + "-ej1-c", 0.42);
    const T = PP.frame(w, h, { x0: -3, x1: 3, y0: 0, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
    e1.T = T;
    const y0 = h * 0.55;
    PP.rect(ctx, T.X(e1.x1 - r), y0 - 14, T.X(e1.x1 + r) - T.X(e1.x1 - r), 28, null, C("--area"));
    numberLine(ctx, T, y0 + 20, -3, 3, 1);
    PP.path(ctx, [[T.X(e1.x1 - r), y0], [T.X(e1.x1 + r), y0]], C("--accent"), 4);
    PP.circle(ctx, T.X(e1.x1 - r), y0, 5, C("--accent"), C("--bg"), null, 2);
    PP.circle(ctx, T.X(e1.x1 + r), y0, 5, C("--accent"), C("--bg"), null, 2);
    PP.dot(ctx, T.X(e1.x1), y0, 5, C("--ink"));
    PP.label(ctx, "x", T.X(e1.x1), y0 - 18, C("--ink"), "center", "bottom", 13);
    PP.read(G + "-ej1-read", [["B(x, r)", "(" + PP.fmt(e1.x1 - r, 2) + ", " + PP.fmt(e1.x1 + r, 2) + ")"]]);
    return;
  }
  if (it === "e") {
    const { ctx, w, h } = PP.canvas(G + "-ej1-c", 0.62);
    const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -1.9, y1: 2.9 }, { l: 40, r: 12, t: 14, b: 28 });
    e1.T = null;
    PP.axes(ctx, T, { xLabel: "t", yLabel: "" });
    const f0 = (t) => 0.5 + 0.3 * Math.sin(2 * Math.PI * t);
    const g = (t) => f0(t) + 0.85 * r * Math.cos(7 * t + 0.4);
    const up = [], dn = [], c0 = [], cg = [];
    for (let k = 0; k <= 200; k++) { const t = k / 200; up.push([T.X(t), T.Y(f0(t) + r)]); dn.push([T.X(t), T.Y(f0(t) - r)]); c0.push([T.X(t), T.Y(f0(t))]); cg.push([T.X(t), T.Y(g(t))]); }
    PP.path(ctx, up.concat(dn.slice().reverse()), null, 1, null, true, C("--area"));
    PP.path(ctx, up, C("--accent"), 1.2, [5, 4]); PP.path(ctx, dn, C("--accent"), 1.2, [5, 4]);
    PP.path(ctx, c0, C("--accent"), 2.4);
    PP.path(ctx, cg, C("--seq2"), 2);
    PP.label(ctx, "f₀", T.X(0.25) + 4, T.Y(f0(0.25)) - 4, C("--accent"), "left", "bottom", 13);
    let m = 0; for (let k = 0; k <= 400; k++) m = Math.max(m, Math.abs(g(k / 400) - f0(k / 400)));
    PP.read(G + "-ej1-read", [["d∞(g, f₀)", PP.fmt(m, 3) + " < r = " + PP.fmt(r, 2), "good"]]);
    return;
  }
  const { ctx, w, h } = PP.canvas(G + "-ej1-c", 0.75);
  const T = eqFrame(w, h, 0, 0, 2.6);
  e1.T = T;
  plainAxes(ctx, T);
  if (it === "f") {
    const cx = E8[e1Center];
    E8.forEach((p, i) => {
      const inB = i === e1Center || r > 1;
      PP.dot(ctx, T.X(p[0]), T.Y(p[1]), 6, inB ? C("--accent") : C("--rule"));
    });
    PP.circle(ctx, T.X(cx[0]), T.Y(cx[1]), 11, C("--ink"), null, null, 2);
    PP.label(ctx, "x", T.X(cx[0]) + 13, T.Y(cx[1]) - 6, C("--ink"), "left", "bottom", 13);
    PP.read(G + "-ej1-read", [["r", PP.fmt(r, 2)], ["B(x, r)", r > 1 ? "todo E (8 puntos)" : "{x}"], ["centro", "tocá un punto para moverlo"]]);
    return;
  }
  const [cx, cy] = e1.c;
  const pts = [];
  for (let k = 0; k <= 240; k++) {
    const t = 2 * Math.PI * k / 240, c = Math.cos(t), s = Math.sin(t);
    let rho;
    if (it === "b") rho = 1; else if (it === "c") rho = 1 / (Math.abs(c) + Math.abs(s)); else rho = 1 / Math.max(Math.abs(c), Math.abs(s));
    pts.push([T.X(cx + r * rho * c), T.Y(cy + r * rho * s)]);
  }
  PP.path(ctx, pts, C("--accent"), 1.8, [6, 4], true, C("--area"));
  PP.dot(ctx, T.X(cx), T.Y(cy), 5, C("--ink"));
  PP.label(ctx, "x", T.X(cx) + 7, T.Y(cy) - 4, C("--ink"), "left", "bottom", 13);
  const name = { b: "d₂: disco", c: "d₁: rombo", d: "d∞: cuadrado" }[it];
  PP.read(G + "-ej1-read", [["x", "(" + PP.fmt(cx, 2) + ", " + PP.fmt(cy, 2) + ")"], ["B(x, r)", name + " (borde punteado: no está)"]]);
}
PP.register(drawEj1, ["input[name='" + G + "-ej1-it']", G + "-ej1-r"]);
draggable(G + "-ej1-c", () => e1.T,
  (px, py, T) => {
    if (e1.mode === "a") return Math.abs(px - T.X(e1.x1)) < 24 ? "x1" : null;
    if (e1.mode === "f") {
      let best = null, bd = 22;
      E8.forEach((p, i) => { const d = Math.hypot(px - T.X(p[0]), py - T.Y(p[1])); if (d < bd) { bd = d; best = i; } });
      if (best !== null) { e1Center = best; drawEj1(); }
      return null;
    }
    return Math.hypot(px - T.X(e1.c[0]), py - T.Y(e1.c[1])) < 26 ? "c" : null;
  },
  (id, x, y) => {
    if (id === "x1") e1.x1 = Math.round(clamp(x, -2.5, 2.5) * 100) / 100;
    else e1.c = [Math.round(clamp(x, -2, 2) * 100) / 100, Math.round(clamp(y, -1.5, 1.5) * 100) / 100];
  }, drawEj1);

/* ===================== Ejercicio 2 ===================== */
PP.register(function drawEj2() {
  const it = PP.radio(G + "-ej2-it"), x = PP.val(G + "-ej2-x") / 10;
  PP.out(G + "-ej2-x-o", PP.fmt(x, 1));
  const d = { a: (y) => (x - y) * (x - y), b: (y) => Math.sqrt(Math.abs(x - y)), c: (y) => Math.abs(x * x - y * y) }[it];
  const { ctx, w, h } = PP.canvas(G + "-ej2-c", 0.62);
  const T = PP.frame(w, h, { x0: -3, x1: 3, y0: -0.3, y1: 6 }, { l: 36, r: 12, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "y", yLabel: "d(x, y)" });
  const ref = [], cur = [];
  for (let k = 0; k <= 300; k++) {
    const y = -3 + 6 * k / 300;
    ref.push([T.X(y), T.Y(Math.min(Math.abs(x - y), 7))]);
    cur.push([T.X(y), T.Y(Math.min(d(y), 7))]);
  }
  ctx.save(); ctx.beginPath(); ctx.rect(T.p.l, T.p.t, w - T.p.l - T.p.r, h - T.p.t - T.p.b); ctx.clip();
  PP.path(ctx, ref, C("--muted"), 1.2);
  PP.path(ctx, cur, C("--accent"), 2.4);
  ctx.restore();
  PP.path(ctx, [[T.X(x), T.Y(-0.3)], [T.X(x), T.Y(6)]], C("--seq2"), 1.2, [4, 4]);
  PP.label(ctx, "y = x", T.X(x) + 4, T.Y(5.8), C("--seq2"), "left", "top", 11);
  const txt = { a: "(x − y)²", b: "√|x − y|", c: "|x² − y²|" }[it];
  PP.read(G + "-ej2-read", [["d(x, y)", txt], ["x", PP.fmt(x, 1)], ["d(x, x)", PP.fmt(d(x), 3)]]);
}, ["input[name='" + G + "-ej2-it']", G + "-ej2-x"]);

/* ===================== Ejercicio 3 ===================== */
PP.register(function drawEj3() {
  const it = PP.radio(G + "-ej3-it");
  const { ctx, w, h } = PP.canvas(G + "-ej3-c", 0.42);
  const T = PP.frame(w, h, { x0: -1.5, x1: 2.5, y0: 0, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  const y0 = h * 0.5;
  numberLine(ctx, T, y0 + 22, -1, 2, 0.5);
  const A = C("--accent");
  const seg = (a, b, oa, ob) => {
    PP.path(ctx, [[T.X(a), y0], [T.X(b), y0]], A, 5);
    if (oa !== null) oa ? PP.circle(ctx, T.X(a), y0, 5, A, C("--bg"), null, 2) : PP.dot(ctx, T.X(a), y0, 5, A);
    if (ob !== null) ob ? PP.circle(ctx, T.X(b), y0, 5, A, C("--bg"), null, 2) : PP.dot(ctx, T.X(b), y0, 5, A);
  };
  const rats = (lo, hi) => { for (let q = 1; q <= 12; q++) for (let p = Math.ceil(lo * q); p <= hi * q; p++) if (gcd(p, q) === 1 || p === 0) PP.dot(ctx, T.X(p / q), y0, q <= 2 ? 2.6 : 1.6, A); };
  let desc = "";
  switch (it) {
    case "a": seg(0, 1, false, false); desc = "[0, 1]"; break;
    case "b": seg(0, 1, true, true); desc = "(0, 1)"; break;
    case "c": rats(-1.5, 2.5); desc = "ℚ (denominador ≤ 12)"; break;
    case "d": rats(0, 1); desc = "ℚ ∩ [0, 1] (denominador ≤ 12)"; break;
    case "e": for (let z = -1; z <= 2; z++) PP.dot(ctx, T.X(z), y0, 5, A); PP.label(ctx, "…", T.X(-1.45), y0 - 4, A, "left", "bottom", 14); PP.label(ctx, "…", T.X(2.45), y0 - 4, A, "right", "bottom", 14); desc = "ℤ"; break;
    case "f": seg(0, 1, false, true); PP.dot(ctx, T.X(2), y0, 5, A); desc = "[0, 1) ∪ {2}"; break;
    case "g": case "h":
      for (let n = 1; n <= 40; n++) PP.dot(ctx, T.X(1 / n), y0, n <= 6 ? 4 : 2.2, A);
      if (it === "h") PP.dot(ctx, T.X(0), y0, 5, C("--seq2"));
      desc = it === "g" ? "{1/n : n ∈ ℕ}" : "{1/n : n ∈ ℕ} ∪ {0}";
      break;
  }
  PP.read(G + "-ej3-read", [["conjunto", desc]]);
}, ["input[name='" + G + "-ej3-it']"]);

/* ===================== Ejercicio 4 ===================== */
PP.register(function drawEj4() {
  const it = PP.radio(G + "-ej4-it"), rp = PP.val(G + "-ej4-rp") / 100;
  PP.out(G + "-ej4-rp-o", it === "c" ? PP.fmt(rp, 2) : "—");
  document.getElementById(G + "-ej4-rp").disabled = it !== "c";
  const { ctx, w, h } = PP.canvas(G + "-ej4-c", 0.75);
  const T = eqFrame(w, h, 0, 0, 3.4);
  plainAxes(ctx, T);
  const ring = (rad, stroke, dash, fill) => PP.circle(ctx, T.X(0), T.Y(0), T.X(rad) - T.X(0), stroke, fill, dash, 1.8);
  if (it === "c") {
    ring(rp, C("--accent"), [5, 4], C("--area"));
    ring(2, C("--seq2"), [6, 4], null);
    PP.label(ctx, "B(x, r′)", T.X(0) + 4, T.Y(rp * 0.5), C("--accent"), "left", "middle", 12);
    PP.label(ctx, "r = 2", T.X(2 * 0.72) + 4, T.Y(2 * 0.72) - 4, C("--seq2"), "left", "bottom", 12);
    PP.read(G + "-ej4-read", [["r′", PP.fmt(rp, 2)], ["r", "2"], ["¿r > r′ > 0?", rp < 2 ? "sí" : "no", rp < 2 ? "good" : "bad"]]);
  } else {
    // anillo 2 < d < 3: sombrear con regla par-impar
    ctx.save(); ctx.beginPath();
    ctx.arc(T.X(0), T.Y(0), T.X(3) - T.X(0), 0, 2 * Math.PI);
    ctx.arc(T.X(0), T.Y(0), T.X(2) - T.X(0), 0, 2 * Math.PI, true);
    ctx.fillStyle = C("--area"); ctx.fill(); ctx.restore();
    ring(3, C("--accent"), [5, 4], null); ring(2, C("--accent"), [5, 4], null);
    PP.label(ctx, "2 < d(y, x) < 3", T.X(0), T.Y(2.5), C("--accent"), "center", "middle", 12);
    PP.read(G + "-ej4-read", [["conjunto", "{y : 2 < d(y, x) < 3}"], ["bordes", "no están (punteados)"]]);
  }
  PP.dot(ctx, T.X(0), T.Y(0), 4.5, C("--ink"));
  PP.label(ctx, "x", T.X(0) + 6, T.Y(0) + 4, C("--ink"), "left", "top", 13);
}, ["input[name='" + G + "-ej4-it']", G + "-ej4-rp"]);

/* ===================== Ejercicio 7 ===================== */
const e7 = { P: [[-1.6, 0.4], [-0.5, 1.1], [0.7, 0.8], [1.3, -0.6], [-0.4, -0.9]], T: null };
function drawEj7() {
  const { ctx, w, h } = PP.canvas(G + "-ej7-c", 0.7);
  const T = eqFrame(w, h, 0, 0, 2.4);
  e7.T = T;
  plainAxes(ctx, T);
  let best = [0, 1], bd = -1;
  for (let i = 0; i < e7.P.length; i++) for (let j = i + 1; j < e7.P.length; j++) {
    const d = Math.hypot(e7.P[i][0] - e7.P[j][0], e7.P[i][1] - e7.P[j][1]);
    if (d > bd) { bd = d; best = [i, j]; }
  }
  const [a, b] = best.map((i) => e7.P[i]);
  PP.path(ctx, [[T.X(a[0]), T.Y(a[1])], [T.X(b[0]), T.Y(b[1])]], C("--seq2"), 2.2);
  PP.label(ctx, "diam", T.X((a[0] + b[0]) / 2) + 4, T.Y((a[1] + b[1]) / 2) - 4, C("--seq2"), "left", "bottom", 12);
  e7.P.forEach((p, i) => { PP.dot(ctx, T.X(p[0]), T.Y(p[1]), 7, C("--accent")); PP.label(ctx, "a" + "₁₂₃₄₅"[i], T.X(p[0]) + 9, T.Y(p[1]) - 4, C("--accent"), "left", "bottom", 12); });
  PP.read(G + "-ej7-read", [["par más alejado", "a" + "₁₂₃₄₅"[best[0]] + ", a" + "₁₂₃₄₅"[best[1]]], ["diam(A)", PP.fmt(bd, 3)]]);
}
PP.register(drawEj7, []);
draggable(G + "-ej7-c", () => e7.T,
  (px, py, T) => { let best = null, bd = 24; e7.P.forEach((p, i) => { const d = Math.hypot(px - T.X(p[0]), py - T.Y(p[1])); if (d < bd) { bd = d; best = i; } }); return best; },
  (i, x, y, T) => { e7.P[i] = [clamp(x, T.box.x0 + 0.1, T.box.x1 - 0.1), clamp(y, T.box.y0 + 0.1, T.box.y1 - 0.1)]; }, drawEj7);

/* ===================== Ejercicio 10 ===================== */
const e10 = { x: [1.2, 1.1], T: null };
const SEG = [[-1.8, -0.6], [0.6, 0.3]], LONE = [1.6, -0.9];
function nearest(px, py) {
  const [[ax, ay], [bx, by]] = SEG;
  const vx = bx - ax, vy = by - ay;
  const t = clamp(((px - ax) * vx + (py - ay) * vy) / (vx * vx + vy * vy), 0, 1);
  const q = [ax + t * vx, ay + t * vy];
  const d1 = Math.hypot(px - q[0], py - q[1]), d2 = Math.hypot(px - LONE[0], py - LONE[1]);
  return d1 <= d2 ? [d1, q] : [d2, LONE];
}
function drawEj10() {
  const r = PP.val(G + "-ej10-r") / 100;
  PP.out(G + "-ej10-r-o", PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas(G + "-ej10-c", 0.7);
  const T = eqFrame(w, h, 0, 0, 2.4);
  e10.T = T;
  // región B_A(r)
  const cell = 4;
  ctx.save(); ctx.fillStyle = C("--area");
  for (let py = 0; py < h; py += cell) for (let px = 0; px < w; px += cell) {
    if (nearest(T.iX(px + cell / 2), T.iY(py + cell / 2))[0] < r) ctx.fillRect(px, py, cell, cell);
  }
  ctx.restore();
  plainAxes(ctx, T);
  PP.path(ctx, SEG.map(([a, b]) => [T.X(a), T.Y(b)]), C("--seq2"), 3);
  PP.dot(ctx, T.X(LONE[0]), T.Y(LONE[1]), 4.5, C("--seq2"));
  PP.label(ctx, "A", T.X(-0.6) - 4, T.Y(-0.15) - 6, C("--seq2"), "right", "bottom", 13);
  const [d, q] = nearest(e10.x[0], e10.x[1]);
  PP.path(ctx, [[T.X(e10.x[0]), T.Y(e10.x[1])], [T.X(q[0]), T.Y(q[1])]], C("--ink"), 1.4, [4, 3]);
  PP.dot(ctx, T.X(e10.x[0]), T.Y(e10.x[1]), 6.5, C("--ink"));
  PP.label(ctx, "x", T.X(e10.x[0]) + 8, T.Y(e10.x[1]) - 4, C("--ink"), "left", "bottom", 13);
  PP.read(G + "-ej10-read", [["d(x, A)", PP.fmt(d, 3)], ["r", PP.fmt(r, 2)], ["¿x ∈ B_A(r)?", d < r ? "sí" : "no", d < r ? "good" : "bad"]]);
}
PP.register(drawEj10, [G + "-ej10-r"]);
draggable(G + "-ej10-c", () => e10.T,
  (px, py, T) => (Math.hypot(px - T.X(e10.x[0]), py - T.Y(e10.x[1])) < 26 ? "x" : null),
  (id, x, y, T) => { e10.x = [clamp(x, T.box.x0 + 0.05, T.box.x1 - 0.05), clamp(y, T.box.y0 + 0.05, T.box.y1 - 0.05)]; }, drawEj10);

/* ===================== Ejercicio 12 ===================== */
PP.register(function drawEj12() {
  const r = PP.val(G + "-ej12-r") / 100;
  PP.out(G + "-ej12-r-o", PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas(G + "-ej12-c", 0.75);
  const T = eqFrame(w, h, 0, 0, 2.3);
  plainAxes(ctx, T);
  const dia = (s) => [[T.X(s), T.Y(0)], [T.X(0), T.Y(s)], [T.X(-s), T.Y(0)], [T.X(0), T.Y(-s)]];
  PP.path(ctx, dia(2 * r), C("--muted"), 1.4, [5, 4], true);
  PP.rect(ctx, T.X(-r), T.Y(r), T.X(r) - T.X(-r), T.Y(-r) - T.Y(r), C("--seq2"), C("--area2"));
  PP.circle(ctx, T.X(0), T.Y(0), T.X(r) - T.X(0), C("--seq3"), C("--area3"), null, 2);
  PP.path(ctx, dia(r), C("--accent"), 2, null, true, C("--area"));
  PP.label(ctx, "B₁(x, 2r)", T.X(0) + 6, T.Y(2 * r) + 2, C("--muted"), "left", "top", 11);
  PP.label(ctx, "B∞", T.X(r) - 3, T.Y(r) + 3, C("--seq2"), "right", "top", 11);
  PP.read(G + "-ej12-read", [["n", "2"], ["r", PP.fmt(r, 2)], ["radio de la última", "n r = " + PP.fmt(2 * r, 2)]]);
}, [G + "-ej12-r"]);

/* ===================== Ejercicio 13 ===================== */
PP.register(function drawEj13() {
  const n = PP.val(G + "-ej13-n");
  PP.out(G + "-ej13-n-o", String(n));
  const X = [-1.2, 0.2], Y = [1.3, -0.4];
  const xs = (k) => [X[0] + (1.6 / k) * Math.cos(1.3 * k), X[1] + (1.6 / k) * Math.sin(1.3 * k)];
  const ys = (k) => [Y[0] + (k % 2 ? 1 : -1) * 0.9 / k, Y[1] + 1.4 / k];
  const { ctx, w, h } = PP.canvas(G + "-ej13-c", 0.7);
  const T = eqFrame(w, h, 0, 0.1, 2.6);
  plainAxes(ctx, T);
  for (let k = 1; k <= n; k++) {
    const a = xs(k), b = ys(k), last = k === n;
    if (last) { PP.dot(ctx, T.X(a[0]), T.Y(a[1]), 5.5, C("--accent")); PP.dot(ctx, T.X(b[0]), T.Y(b[1]), 5.5, C("--seq3")); }
    else { PP.circle(ctx, T.X(a[0]), T.Y(a[1]), 3.2, C("--accent"), null, null, 1.3); PP.circle(ctx, T.X(b[0]), T.Y(b[1]), 3.2, C("--seq3"), null, null, 1.3); }
  }
  PP.path(ctx, [[T.X(X[0]), T.Y(X[1])], [T.X(Y[0]), T.Y(Y[1])]], C("--muted"), 1.3, [5, 4]);
  const a = xs(n), b = ys(n);
  PP.path(ctx, [[T.X(a[0]), T.Y(a[1])], [T.X(b[0]), T.Y(b[1])]], C("--seq2"), 2);
  PP.dot(ctx, T.X(X[0]), T.Y(X[1]), 5, C("--ink")); PP.label(ctx, "x", T.X(X[0]) - 7, T.Y(X[1]) + 4, C("--ink"), "right", "top", 13);
  PP.dot(ctx, T.X(Y[0]), T.Y(Y[1]), 5, C("--ink")); PP.label(ctx, "y", T.X(Y[0]) + 7, T.Y(Y[1]) + 4, C("--ink"), "left", "top", 13);
  PP.label(ctx, "xₙ", T.X(a[0]) + 7, T.Y(a[1]) - 4, C("--accent"), "left", "bottom", 12);
  PP.label(ctx, "yₙ", T.X(b[0]) + 7, T.Y(b[1]) - 4, C("--seq3"), "left", "bottom", 12);
  PP.read(G + "-ej13-read", [["d(xₙ, yₙ)", PP.fmt(Math.hypot(a[0] - b[0], a[1] - b[1]), 4)], ["d(x, y)", PP.fmt(Math.hypot(X[0] - Y[0], X[1] - Y[1]), 4)]]);
}, [G + "-ej13-n"]);

/* ===================== Ejercicio 16 ===================== */
PP.register(function drawEj16() {
  const n = PP.val(G + "-ej16-n");
  PP.out(G + "-ej16-n-o", String(n));
  const discs = [];
  let c = [0, 0], r = 1.6;
  for (let k = 1; k <= 8; k++) {
    discs.push([c, r]);
    const ang = 0.9 * k;
    c = [c[0] + (r / 2) * Math.cos(ang), c[1] + (r / 2) * Math.sin(ang)];
    r = r / 2;
  }
  const { ctx, w, h } = PP.canvas(G + "-ej16-c", 0.75);
  const T = eqFrame(w, h, 0, 0, 2.1);
  plainAxes(ctx, T);
  for (let k = 1; k <= n; k++) {
    const [cc, rr] = discs[k - 1], last = k === n;
    PP.circle(ctx, T.X(cc[0]), T.Y(cc[1]), T.X(rr) - T.X(0), last ? C("--accent") : C("--muted"), last ? C("--area") : C("--band"), null, last ? 2.2 : 1.2);
    if (k <= 3) PP.label(ctx, "A" + "₁₂₃"[k - 1], T.X(cc[0] - rr * 0.7), T.Y(cc[1] + rr * 0.7), C("--muted"), "right", "bottom", 12);
  }
  PP.read(G + "-ej16-read", [["diam(Aₙ)", PP.fmt(2 * discs[n - 1][1], 4)], ["Aₙ₊₁ ⊆ Aₙ", "sí", "good"]]);
}, [G + "-ej16-n"]);
