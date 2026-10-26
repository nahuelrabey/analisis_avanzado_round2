/* Dibujos de los ejemplos alternativos de la Práctica 4, segunda parte (Bloques 6 a 9). Usa window.PP. */
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const gcd = (a, b) => { a = Math.abs(a); b = Math.abs(b); while (b) { [a, b] = [b, a % b]; } return a; };
const SUB = "₀₁₂₃₄₅₆₇₈₉";
const sub = (n) => String(n).split("").map((d) => SUB[+d]).join("");
const F = (x, d) => PP.fmt(x, d === undefined ? 3 : d);

/* Marco con la misma escala en x y en y, centrado en (cx, cy), que muestra al menos spanX × spanY. */
function fitFrame(w, h, cx, cy, spanX, spanY, pad) {
  const p = Object.assign({ l: 12, r: 12, t: 12, b: 12 }, pad || {});
  const W = w - p.l - p.r, H = h - p.t - p.b;
  const s = Math.min(W / spanX, H / spanY);
  const hx = W / s / 2, hy = H / s / 2;
  return PP.frame(w, h, { x0: cx - hx, x1: cx + hx, y0: cy - hy, y1: cy + hy }, p);
}

/* Arrastre sobre un canvas: pick(px, py, T) devuelve un id o null; move(id, x, y, T) actualiza el estado. */
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
/* Elige el punto arrastrable más cercano (en píxeles) entre pts = [[id, x, y], ...]. */
function nearest(pts, px, py, T, tol) {
  let best = null, bd = tol || 26;
  pts.forEach(([id, x, y]) => { const d = Math.hypot(T.X(x) - px, T.Y(y) - py); if (d < bd) { bd = d; best = id; } });
  return best;
}
/* Banda horizontal [y0, y1] y vertical [x0, x1] recortadas al marco. */
function hband(ctx, T, y0, y1, fill) { const a = T.Y(Math.min(T.box.y1, y1)), b = T.Y(Math.max(T.box.y0, y0)); PP.rect(ctx, T.p.l, a, T.w - T.p.l - T.p.r, b - a, null, fill); }
function vband(ctx, T, x0, x1, fill) { const a = T.X(Math.max(T.box.x0, x0)), b = T.X(Math.min(T.box.x1, x1)); PP.rect(ctx, a, T.p.t, b - a, T.h - T.p.t - T.p.b, null, fill); }
/* Gráfico de una función real sobre [a, b]. */
function plotFn(ctx, T, f, a, b, color, width, dash, n) {
  const pts = []; n = n || 400;
  for (let i = 0; i <= n; i++) { const x = a + (b - a) * i / n, y = f(x); if (isFinite(y)) pts.push([T.X(x), T.Y(y)]); }
  ctx.save(); ctx.beginPath(); ctx.rect(T.p.l, T.p.t, T.w - T.p.l - T.p.r, T.h - T.p.t - T.p.b); ctx.clip();
  PP.path(ctx, pts, color, width || 2, dash); ctx.restore();
}


/* ===================== Bloque 6 ===================== */

/* O3-1: D = ℚ² ∩ [0,1]² (denominador ≤ q) y un abierto U (bola) arrastrable. */
(() => {
  const st = { cx: 0.43, cy: 0.58 };
  let T = null;
  const fracs = (q) => { const s = []; for (let d = 1; d <= q; d++) for (let i = 0; i <= d; i++) if (gcd(i, d) === 1) s.push(i / d); return s; };
  function firstQ(cx, cy, r) {
    for (let d = 1; d <= 400; d++) {
      for (let i = Math.ceil((cx - r) * d); i <= Math.floor((cx + r) * d); i++) {
        if (i < 0 || i > d) continue;
        const dx = i / d - cx, rest = r * r - dx * dx; if (rest <= 0) continue;
        const h = Math.sqrt(rest);
        for (let j = Math.ceil((cy - h) * d); j <= Math.floor((cy + h) * d); j++) {
          if (j < 0 || j > d) continue;
          if (dx * dx + (j / d - cy) ** 2 < r * r) return d;
        }
      }
    }
    return null;
  }
  function draw() {
    const q = PP.val("ejp4alt-o3-1-q"), r = PP.val("ejp4alt-o3-1-r") / 100;
    PP.out("ejp4alt-o3-1-q-o", String(q)); PP.out("ejp4alt-o3-1-r-o", F(r, 2));
    const { ctx, w, h } = PP.canvas("ejp4alt-o3-1-c1", 0.78);
    T = fitFrame(w, h, 0.5, 0.5, 1.08, 1.08);
    PP.rect(ctx, T.X(0), T.Y(1), T.X(1) - T.X(0), T.Y(0) - T.Y(1), C("--rule"), null);
    const xs = fracs(q), sz = q <= 8 ? 3 : q <= 14 ? 2.2 : 1.6;
    let inside = 0;
    ctx.fillStyle = C("--muted");
    xs.forEach((a) => xs.forEach((b) => { if ((a - st.cx) ** 2 + (b - st.cy) ** 2 >= r * r) ctx.fillRect(T.X(a) - sz / 2, T.Y(b) - sz / 2, sz, sz); }));
    PP.circle(ctx, T.X(st.cx), T.Y(st.cy), r * (T.X(1) - T.X(0)), C("--accent"), C("--band"), [5, 4], 2);
    ctx.fillStyle = C("--ok");
    xs.forEach((a) => xs.forEach((b) => { if ((a - st.cx) ** 2 + (b - st.cy) ** 2 < r * r) { inside++; ctx.fillRect(T.X(a) - sz, T.Y(b) - sz, 2 * sz, 2 * sz); } }));
    PP.dot(ctx, T.X(st.cx), T.Y(st.cy), 4, C("--accent"));
    PP.label(ctx, "U", T.X(st.cx + r * 0.72) + 4, T.Y(st.cy + r * 0.72) - 2, C("--accent"), "left", "bottom", 13);
    const fq = firstQ(st.cx, st.cy, r);
    PP.read("ejp4alt-o3-1-read", [
      ["puntos de D (den. ≤ " + q + ") en U", String(inside), inside ? "good" : "bad"],
      ["menor denominador con un punto en U", fq === null ? "> 400" : String(fq)],
      ["D ∩ U", "≠ ∅ (siempre, subiendo q)", "good"],
    ]);
  }
  PP.register(draw, ["ejp4alt-o3-1-q", "ejp4alt-o3-1-r"]);
  draggable("ejp4alt-o3-1-c1", () => T, (px, py, T) => nearest([["c", st.cx, st.cy]], px, py, T, 60),
    (id, x, y) => { st.cx = clamp(x, 0, 1); st.cy = clamp(y, 0, 1); }, draw);
})();

/* O4-10: en ℝ con D = ℚ: B(x, r), un racional y en ella y B(y, r) ∋ x. */
(() => {
  const st = { x: 0.4142 };
  let T = null;
  function bestRat(a, b) { for (let d = 1; d <= 100000; d++) { const i = Math.floor(a * d) + 1; if (i / d < b) return [i, d]; } return null; }
  function draw() {
    const r = PP.val("ejp4alt-o4-10-r") / 200;
    PP.out("ejp4alt-o4-10-r-o", F(r, 3));
    const { ctx, w, h } = PP.canvas("ejp4alt-o4-10-c1", 0.46);
    T = PP.frame(w, h, { x0: -0.05, x1: 1.05, y0: 0, y1: 2 }, { l: 16, r: 16, t: 14, b: 26 });
    const rows = [1.45, 0.55];
    ctx.save(); ctx.font = "11px 'IBM Plex Sans', system-ui, sans-serif"; ctx.fillStyle = C("--muted"); ctx.textAlign = "center"; ctx.textBaseline = "top";
    [0, 0.25, 0.5, 0.75, 1].forEach((v) => ctx.fillText(F(v, 2), T.X(v), h - T.p.b + 6));
    ctx.restore();
    const [i, d] = bestRat(st.x - r, st.x + r), y = i / d;
    const seg = (c, rad, row, col, fill, lab) => {
      PP.path(ctx, [[T.X(-0.05), T.Y(row)], [T.X(1.05), T.Y(row)]], C("--rule"), 1);
      PP.rect(ctx, T.X(c - rad), T.Y(row) - 9, T.X(c + rad) - T.X(c - rad), 18, null, fill);
      PP.path(ctx, [[T.X(c - rad), T.Y(row)], [T.X(c + rad), T.Y(row)]], col, 3);
      PP.circle(ctx, T.X(c - rad), T.Y(row), 4, col, C("--bg"), null, 2);
      PP.circle(ctx, T.X(c + rad), T.Y(row), 4, col, C("--bg"), null, 2);
      PP.label(ctx, lab, T.X(c), T.Y(row) - 13, col, "center", "bottom", 12);
    };
    seg(st.x, r, rows[0], C("--accent"), C("--band"), "B(x, r)");
    seg(y, r, rows[1], C("--seq2"), C("--area2"), "B(y, r)");
    [rows[0], rows[1]].forEach((row) => {
      PP.dot(ctx, T.X(st.x), T.Y(row), 5, C("--accent"));
      PP.dot(ctx, T.X(y), T.Y(row), 5, C("--seq2"));
    });
    PP.label(ctx, "x", T.X(st.x), T.Y(rows[0]) + 8, C("--accent"), "center", "top", 12);
    PP.label(ctx, "y = " + i + "/" + d, T.X(y), T.Y(rows[1]) + 8, C("--seq2"), "center", "top", 12);
    PP.read("ejp4alt-o4-10-read", [
      ["x", F(st.x, 4)],
      ["y ∈ B(x, r) ∩ ℚ", i + "/" + d + " = " + F(y, 4)],
      ["d(x, y) < r", F(Math.abs(st.x - y), 4) + " < " + F(r, 3), "good"],
      ["x ∈ B(y, r)", "sí", "good"],
    ]);
  }
  PP.register(draw, ["ejp4alt-o4-10-r"]);
  draggable("ejp4alt-o4-10-c1", () => T, (px, py, T) => (Math.abs(T.Y(1.45) - py) < 40 ? "x" : null),
    (id, x) => { st.x = clamp(x, 0, 1); }, draw);
})();

/* O15-4: f = 0 si x² < 1/2, 1 si no, en los racionales de [0, 1]; p_n, q_n → 2^(-1/2). */
PP.register(function o15_4() {
  const n = PP.val("ejp4alt-o15-4-n");
  PP.out("ejp4alt-o15-4-n-o", String(n));
  const { ctx, w, h } = PP.canvas("ejp4alt-o15-4-c1", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.3, y1: 1.3 }, { l: 34, r: 12, t: 14, b: 28 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 4 });
  const c = Math.SQRT1_2;
  PP.path(ctx, [[T.X(c), T.p.t], [T.X(c), h - T.p.b]], C("--muted"), 1, [4, 4]);
  PP.label(ctx, "1/√2 ∉ ℚ", T.X(c) + 4, T.p.t + 2, C("--muted"), "left", "top", 11);
  ctx.fillStyle = C("--accent");
  for (let d = 1; d <= 40; d++) for (let i = 0; i <= d; i++) {
    if (gcd(i, d) !== 1) continue;
    const x = i / d, v = x * x < 0.5 ? 0 : 1;
    ctx.fillRect(T.X(x) - 1.5, T.Y(v) - 1.5, 3, 3);
  }
  const s = Math.pow(10, n), qn = Math.floor(c * s) / s, pn = (Math.floor(c * s) + 1) / s;
  PP.dot(ctx, T.X(pn), T.Y(1), 6, C("--seq2"));
  PP.dot(ctx, T.X(qn), T.Y(0), 6, C("--seq3"));
  PP.label(ctx, "f(pₙ) = 1", T.X(pn) + 8, T.Y(1) - 6, C("--seq2"), "left", "bottom", 12);
  PP.label(ctx, "f(qₙ) = 0", T.X(qn) - 8, T.Y(0) + 6, C("--seq3"), "right", "top", 12);
  PP.read("ejp4alt-o15-4-read", [
    ["pₙ, pₙ²", pn.toFixed(n) + ", " + (pn * pn).toFixed(Math.min(2 * n, 14)) + " > 1/2"],
    ["qₙ, qₙ²", qn.toFixed(n) + ", " + (qn * qn).toFixed(Math.min(2 * n, 14)) + " < 1/2"],
    ["|f(pₙ) − f(qₙ)|", "1", "bad"],
  ]);
}, ["ejp4alt-o15-4-n"]);

/* O3-2: x_k → x y los y_k diádicos a menos de 1/k de x_k. */
PP.register(function o3_2() {
  const K = PP.val("ejp4alt-o3-2-k");
  PP.out("ejp4alt-o3-2-k-o", String(K));
  const { ctx, w, h } = PP.canvas("ejp4alt-o3-2-c1", 0.62);
  const x = Math.SQRT1_2;
  const T = PP.frame(w, h, { x0: 0, x1: K + 1, y0: x - 0.55, y1: x + 0.55 }, { l: 38, r: 12, t: 14, b: 28 });
  PP.axes(ctx, T, { xTicks: Math.min(K + 1, 8), yTicks: 5, intX: true, zero: false, xLabel: "k" });
  PP.path(ctx, [[T.p.l, T.Y(x)], [w - T.p.r, T.Y(x)]], C("--ok"), 1.5, [6, 4]);
  PP.label(ctx, "x", w - T.p.r - 4, T.Y(x) - 4, C("--ok"), "right", "bottom", 12);
  const bw = Math.min(0.32, 0.4) * (T.X(1) - T.X(0));
  let last = null;
  for (let k = 1; k <= K; k++) {
    const xk = x + (k % 2 ? -1 : 1) * 0.4 / Math.sqrt(k);
    let m = 0, yk = 0;
    for (; m < 40; m++) { const j = Math.round(xk * 2 ** m); if (Math.abs(j / 2 ** m - xk) < 1 / k) { yk = j / 2 ** m; last = { k, xk, yk, j, m }; break; } }
    const top = T.Y(Math.min(T.box.y1, xk + 1 / k)), bot = T.Y(Math.max(T.box.y0, xk - 1 / k));
    PP.rect(ctx, T.X(k) - bw / 2, top, bw, bot - top, null, C("--band"));
    PP.dot(ctx, T.X(k), T.Y(xk), 4, C("--accent"));
    PP.dot(ctx, T.X(k), T.Y(yk), 3.2, C("--bg"), C("--seq2"));
  }
  PP.read("ejp4alt-o3-2-read", [
    ["x" + sub(last.k), F(last.xk, 5)],
    ["y" + sub(last.k) + " = " + last.j + "/2^" + last.m, F(last.yk, 5)],
    ["d(y" + sub(last.k) + ", x" + sub(last.k) + ") < 1/" + last.k, F(Math.abs(last.yk - last.xk), 5) + " < " + F(1 / last.k, 4), "good"],
    ["d(y" + sub(last.k) + ", x)", F(Math.abs(last.yk - x), 5)],
  ]);
}, ["ejp4alt-o3-2-k"]);

/* O2-5: f(x) = sen(2πx) de [0, 1] sobre [−1, 1]; S = racionales con denominador ≤ q y f(S). */
PP.register(function o2_5() {
  const q = PP.val("ejp4alt-o2-5-q");
  PP.out("ejp4alt-o2-5-q-o", String(q));
  const { ctx, w, h } = PP.canvas("ejp4alt-o2-5-c1", 0.72);
  const T = PP.frame(w, h, { x0: -0.14, x1: 1.04, y0: -1.3, y1: 1.15 }, { l: 34, r: 10, t: 12, b: 26 });
  const f = (x) => Math.sin(2 * Math.PI * x);
  PP.path(ctx, [[T.X(0), T.Y(-1.2)], [T.X(1), T.Y(-1.2)]], C("--rule"), 1);
  PP.path(ctx, [[T.X(-0.08), T.Y(-1)], [T.X(-0.08), T.Y(1)]], C("--rule"), 1);
  PP.label(ctx, "X", T.X(1), T.Y(-1.2) - 4, C("--muted"), "right", "bottom", 11);
  PP.label(ctx, "Y", T.X(-0.08) + 4, T.Y(1), C("--muted"), "left", "top", 11);
  plotFn(ctx, T, f, 0, 1, C("--ink"), 1.6);
  const S = [];
  for (let d = 1; d <= q; d++) for (let i = 0; i <= d; i++) if (gcd(i, d) === 1) S.push(i / d);
  if (q <= 8) S.forEach((s) => PP.path(ctx, [[T.X(s), T.Y(-1.2)], [T.X(s), T.Y(f(s))], [T.X(-0.08), T.Y(f(s))]], C("--rule"), 1, [2, 3]));
  S.forEach((s) => { PP.dot(ctx, T.X(s), T.Y(-1.2), 2.6, C("--accent")); PP.dot(ctx, T.X(-0.08), T.Y(f(s)), 2.6, C("--seq2")); });
  const ys = S.map(f).sort((a, b) => a - b);
  let gap = 0; for (let i = 1; i < ys.length; i++) gap = Math.max(gap, ys[i] - ys[i - 1]);
  gap = Math.max(gap, ys[0] + 1, 1 - ys[ys.length - 1]);
  PP.label(ctx, "S", T.X(0.5), T.Y(-1.2) + 4, C("--accent"), "center", "top", 11);
  PP.label(ctx, "f(S)", T.X(-0.08) - 4, T.Y(0.55), C("--seq2"), "right", "middle", 11);
  PP.read("ejp4alt-o2-5-read", [
    ["puntos de S dibujados", String(S.length)],
    ["hueco más grande de f(S) en Y", F(gap, 4)],
  ]);
}, ["ejp4alt-o2-5-q"]);

/* O9-1: x ∈ cl E ∖ E, la banda ε en f(x), el δ y un y ∈ E con f(y) en la banda. */
PP.register(function o9_1() {
  const eps = PP.val("ejp4alt-o9-1-eps") / 100;
  PP.out("ejp4alt-o9-1-eps-o", F(eps, 2));
  const { ctx, w, h } = PP.canvas("ejp4alt-o9-1-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: 0, y1: 1 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 5 });
  const f = (t) => 0.5 + 0.35 * Math.sin(5 * t), x = 0.6, fx = f(x);
  let delta = 1;
  for (const s of [-1, 1]) { for (let t = 0; t <= 1; t += 0.0005) { if (Math.abs(f(x + s * t) - fx) >= eps) { delta = Math.min(delta, t); break; } } }
  const y = Math.max(0.2005, x - delta / 2);
  hband(ctx, T, fx - eps, fx + eps, C("--area3"));
  vband(ctx, T, x - delta, x + delta, C("--band"));
  PP.path(ctx, [[T.X(0.2), T.Y(0) - 1], [T.X(0.6), T.Y(0) - 1]], C("--ok"), 5);
  PP.label(ctx, "E", T.X(0.4), T.Y(0) - 6, C("--ok"), "center", "bottom", 12);
  plotFn(ctx, T, f, 0, 1, C("--ink"), 1.6);
  PP.circle(ctx, T.X(x), T.Y(0) - 1, 4.5, C("--ok"), C("--bg"), null, 2);
  PP.dot(ctx, T.X(x), T.Y(fx), 5, C("--seq3"));
  PP.label(ctx, "f(x)", T.X(x) + 7, T.Y(fx) - 2, C("--seq3"), "left", "bottom", 12);
  PP.path(ctx, [[T.X(y), T.Y(0)], [T.X(y), T.Y(f(y))]], C("--seq2"), 1, [3, 3]);
  PP.dot(ctx, T.X(y), T.Y(0) - 1, 4, C("--seq2"));
  PP.dot(ctx, T.X(y), T.Y(f(y)), 5, C("--seq2"));
  PP.label(ctx, "f(y)", T.X(y) - 7, T.Y(f(y)) + 2, C("--seq2"), "right", "top", 12);
  PP.read("ejp4alt-o9-1-read", [
    ["δ (el mayor que sirve)", F(delta, 4)],
    ["y ∈ E con d(x, y) < δ", F(y, 4)],
    ["d(f(x), f(y)) < ε", F(Math.abs(f(y) - fx), 4) + " < " + F(eps, 2), "good"],
  ]);
}, ["ejp4alt-o9-1-eps"]);

/* O4-6: una f con salto; x_k → x pero f(x_k) queda fuera de B(f(x), ε). */
PP.register(function o4_6() {
  const K = PP.val("ejp4alt-o4-6-k");
  PP.out("ejp4alt-o4-6-k-o", String(K));
  const { ctx, w, h } = PP.canvas("ejp4alt-o4-6-c1", 0.62);
  const T = PP.frame(w, h, { x0: 0.3, x1: 1, y0: 0, y1: 1.05 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 5 });
  const x = 0.5, fx = 0.3, eps = 0.4;
  hband(ctx, T, fx - eps, fx + eps, C("--area3"));
  PP.path(ctx, [[T.p.l, T.Y(fx + eps)], [w - T.p.r, T.Y(fx + eps)]], C("--seq3"), 1, [5, 4]);
  PP.label(ctx, "B(f(x), ε)", T.p.l + 4, T.Y(fx + eps) + 3, C("--seq3"), "left", "top", 11);
  PP.path(ctx, [[T.X(0.3), T.Y(fx)], [T.X(0.5), T.Y(fx)]], C("--ink"), 2);
  PP.path(ctx, [[T.X(0.5), T.Y(0.8)], [T.X(1), T.Y(0.8)]], C("--ink"), 2);
  PP.dot(ctx, T.X(x), T.Y(fx), 5, C("--ink"));
  PP.circle(ctx, T.X(x), T.Y(0.8), 4.5, C("--ink"), C("--bg"), null, 1.5);
  PP.label(ctx, "f(x)", T.X(x) - 6, T.Y(fx) - 4, C("--ink"), "right", "bottom", 12);
  for (let k = 1; k <= K; k++) {
    const xk = x + 0.4 / k;
    PP.dot(ctx, T.X(xk), T.Y(0) - 1, 3.2, C("--accent"));
    PP.dot(ctx, T.X(xk), T.Y(0.8), 3.6, C("--seq2"));
  }
  PP.circle(ctx, T.X(x), T.Y(0) - 1, 4.5, C("--accent"), C("--bg"), null, 2);
  PP.label(ctx, "x", T.X(x), T.Y(0) - 8, C("--accent"), "center", "bottom", 12);
  PP.label(ctx, "f(A)", T.X(1) - 4, T.Y(0.8) - 4, C("--seq2"), "right", "bottom", 12);
  const xk = x + 0.4 / K;
  PP.read("ejp4alt-o4-6-read", [
    ["x" + sub(K) + ", d(x" + sub(K) + ", x) < 1/" + K, F(xk, 4) + ", " + F(0.4 / K, 4)],
    ["d'(f(x), f(x" + sub(K) + ")) ≥ ε", "0.5 ≥ 0.4", "bad"],
    ["B(f(x), ε) ∩ f(A)", "∅", "bad"],
  ]);
}, ["ejp4alt-o4-6-k"]);


/* ===================== Bloque 7 ===================== */

/* O17-1 (a): f_n lineal en [0, 1/n] y 1 después; g = 1. */
PP.register(function o17_1a() {
  const n = PP.val("ejp4alt-o17-1-n");
  PP.out("ejp4alt-o17-1-n-o", String(n));
  const { ctx, w, h } = PP.canvas("ejp4alt-o17-1-c1", 0.62);
  const T = PP.frame(w, h, { x0: -0.03, x1: 1.02, y0: -0.12, y1: 1.3 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 5 });
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(0), T.Y(1)], [T.X(1 / n), T.Y(1)]], null, 0, null, true, C("--area2"));
  PP.path(ctx, [[T.X(0), T.Y(1)], [T.X(1), T.Y(1)]], C("--seq2"), 2, [6, 4]);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1 / n), T.Y(1)], [T.X(1), T.Y(1)]], C("--accent"), 2.5);
  PP.path(ctx, [[T.X(0) + 7, T.Y(0) - 3], [T.X(0) + 7, T.Y(1) + 3]], C("--fail"), 1.5);
  PP.label(ctx, "d∞ = 1", T.X(0) + 12, T.Y(0.5), C("--fail"), "left", "middle", 12);
  PP.label(ctx, "g = 1", T.X(0.98), T.Y(1) - 6, C("--seq2"), "right", "bottom", 12);
  PP.label(ctx, "f" + sub(n), T.X(Math.min(0.9, 1 / n + 0.08)), T.Y(1) + 6, C("--accent"), "left", "top", 12);
  PP.read("ejp4alt-o17-1-read1", [
    ["d₁(f" + sub(n) + ", g) = 1/(2n)", F(1 / (2 * n), 4), "good"],
    ["d∞(f" + sub(n) + ", g)", "1", "bad"],
    ["Ψ(f" + sub(n) + ") = f" + sub(n) + "(0), Ψ(g)", "0, 1"],
  ]);
}, ["ejp4alt-o17-1-n"]);

/* O17-1 (b): |Φ(f) − Φ(g)| ≤ d₁(f, g) ≤ d∞(f, g). */
PP.register(function o17_1b() {
  const a = PP.val("ejp4alt-o17-1-a") / 100;
  PP.out("ejp4alt-o17-1-a-o", F(a, 2));
  const { ctx, w, h } = PP.canvas("ejp4alt-o17-1-c2", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.1, y1: 1.3 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 5 });
  const f = (x) => 0.5 + 0.3 * Math.sin(2 * Math.PI * x), g = (x) => f(x) + a * Math.sin(3 * Math.PI * x);
  const N = 400; let signed = 0, d1 = 0, dinf = 0;
  for (let i = 0; i < N; i++) {
    const x0 = i / N, x1 = (i + 1) / N, xm = (x0 + x1) / 2, dm = f(xm) - g(xm);
    signed += dm / N; d1 += Math.abs(dm) / N; dinf = Math.max(dinf, Math.abs(dm));
    PP.path(ctx, [[T.X(x0), T.Y(f(x0))], [T.X(x1), T.Y(f(x1))], [T.X(x1), T.Y(g(x1))], [T.X(x0), T.Y(g(x0))]], null, 0, null, true, dm >= 0 ? C("--area3") : C("--area2"));
  }
  plotFn(ctx, T, f, 0, 1, C("--accent"), 2);
  plotFn(ctx, T, g, 0, 1, C("--seq2"), 2);
  PP.label(ctx, "f", T.X(0.25) + 4, T.Y(f(0.25)) - 4, C("--accent"), "left", "bottom", 12);
  PP.label(ctx, "g", T.X(0.62), T.Y(g(0.62)) + 6, C("--seq2"), "left", "top", 12);
  PP.read("ejp4alt-o17-1-read2", [
    ["|Φ(f) − Φ(g)|", F(Math.abs(signed), 4)],
    ["d₁(f, g)", F(d1, 4)],
    ["d∞(f, g)", F(dinf, 4)],
    ["|Φ(f) − Φ(g)| ≤ d₁ ≤ d∞", "sí", "good"],
  ]);
}, ["ejp4alt-o17-1-a"]);

/* O16-1: el pico de altura 1 + r y área r/2. */
PP.register(function o16_1() {
  const r = PP.val("ejp4alt-o16-1-r") / 100;
  PP.out("ejp4alt-o16-1-r-o", F(r, 2));
  const { ctx, w, h } = PP.canvas("ejp4alt-o16-1-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -1.25, y1: 1.75 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 6 });
  hband(ctx, T, -1, 1, C("--band"));
  PP.path(ctx, [[T.p.l, T.Y(1)], [w - T.p.r, T.Y(1)]], C("--accent"), 1, [5, 4]);
  PP.path(ctx, [[T.p.l, T.Y(-1)], [w - T.p.r, T.Y(-1)]], C("--accent"), 1, [5, 4]);
  PP.label(ctx, "bola d∞-unidad de 0", w - T.p.r - 4, T.Y(-1) - 4, C("--accent"), "right", "bottom", 11);
  const wd = r / (1 + r);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(0), T.Y(1 + r)], [T.X(wd), T.Y(0)]], null, 0, null, true, C("--area2"));
  PP.path(ctx, [[T.X(0), T.Y(1 + r)], [T.X(wd), T.Y(0)], [T.X(1), T.Y(0)]], C("--seq2"), 2.5);
  PP.dot(ctx, T.X(0), T.Y(1 + r), 4, C("--seq2"));
  PP.label(ctx, "h(0) = 1 + r", T.X(0) + 8, T.Y(1 + r), C("--seq2"), "left", "middle", 12);
  PP.read("ejp4alt-o16-1-read", [
    ["d∞(h, 0) = 1 + r", F(1 + r, 3) + " > 1", "bad"],
    ["d₁(h, 0) = r/2", F(r / 2, 3) + " < " + F(r, 2), "good"],
  ]);
}, ["ejp4alt-o16-1-r"]);

/* O16-2: |f(t0) − g(t0)| ≤ d∞(f, g). */
PP.register(function o16_2() {
  const t0 = PP.val("ejp4alt-o16-2-t") / 100;
  PP.out("ejp4alt-o16-2-t-o", F(t0, 2));
  const { ctx, w, h } = PP.canvas("ejp4alt-o16-2-c1", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.1, y1: 1.1 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 5 });
  const f = (t) => 0.4 + 0.3 * Math.sin(2 * Math.PI * t), g = (t) => f(t) + 0.15 * Math.cos(3 * Math.PI * t) + 0.05;
  let D = 0; for (let i = 0; i <= 1000; i++) D = Math.max(D, Math.abs(f(i / 1000) - g(i / 1000)));
  const up = [], dn = [];
  for (let i = 0; i <= 200; i++) { const t = i / 200; up.push([T.X(t), T.Y(f(t) + D)]); dn.unshift([T.X(t), T.Y(f(t) - D)]); }
  PP.path(ctx, up.concat(dn), null, 0, null, true, C("--band"));
  plotFn(ctx, T, f, 0, 1, C("--accent"), 2);
  plotFn(ctx, T, g, 0, 1, C("--seq2"), 2);
  PP.path(ctx, [[T.X(t0), T.p.t], [T.X(t0), h - T.p.b]], C("--muted"), 1, [3, 4]);
  PP.path(ctx, [[T.X(t0), T.Y(f(t0))], [T.X(t0), T.Y(g(t0))]], C("--fail"), 3);
  PP.dot(ctx, T.X(t0), T.Y(f(t0)), 4, C("--accent"));
  PP.dot(ctx, T.X(t0), T.Y(g(t0)), 4, C("--seq2"));
  PP.label(ctx, "t₀", T.X(t0) + 4, h - T.p.b - 4, C("--muted"), "left", "bottom", 11);
  PP.read("ejp4alt-o16-2-read", [
    ["|f(t₀) − g(t₀)|", F(Math.abs(f(t0) - g(t0)), 4)],
    ["d∞(f, g)", F(D, 4)],
    ["|E(f) − E(g)| ≤ d∞(f, g)", "sí", "good"],
  ]);
}, ["ejp4alt-o16-2-t"]);

/* O6-6: sen(nx) y su derivada n cos(nx) en [0, π]. */
PP.register(function o6_6() {
  const n = PP.val("ejp4alt-o6-6-n");
  PP.out("ejp4alt-o6-6-n-o", String(n));
  const { ctx, w, h } = PP.canvas("ejp4alt-o6-6-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: Math.PI, y0: -12.8, y1: 12.8 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 4, yTicks: 5 });
  plotFn(ctx, T, (x) => n * Math.cos(n * x), 0, Math.PI, C("--seq2"), 1.8, null, 600);
  plotFn(ctx, T, (x) => Math.sin(n * x), 0, Math.PI, C("--accent"), 2.5, null, 600);
  PP.label(ctx, "sen(nx)", T.X(Math.PI) - 4, T.Y(1.4), C("--accent"), "right", "bottom", 12);
  PP.label(ctx, "n·cos(nx)", T.X(Math.PI) - 4, T.p.t + 2, C("--seq2"), "right", "top", 12);
  PP.read("ejp4alt-o6-6-read", [
    ["sup |sen(nx)|", "1"],
    ["sup |(sen(nx))′| = sup |n·cos(nx)|", String(n)],
  ]);
}, ["ejp4alt-o6-6-n"]);

/* O8-1: T(f)(x) = g(x) + λ ∫ k(x, y) f(y) dy con k = cos(3(x − y)), g = 0.5. */
PP.register(function o8_1() {
  const lam = PP.val("ejp4alt-o8-1-l") / 100;
  PP.out("ejp4alt-o8-1-l-o", F(lam, 2));
  const { ctx, w, h } = PP.canvas("ejp4alt-o8-1-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.6, y1: 1.6 }, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 5, yTicks: 5 });
  const f1 = (y) => 0.3 * Math.sin(2 * Math.PI * y) + 0.2, f2 = () => 0, k = (x, y) => Math.cos(3 * (x - y)), g = () => 0.5;
  const M = 300;
  const Tf = (f) => (x) => { let s = 0; for (let j = 0; j < M; j++) { const y = (j + 0.5) / M; s += k(x, y) * f(y) / M; } return g(x) + lam * s; };
  const T1 = Tf(f1), T2 = Tf(f2);
  let dTT = 0, dff = 0;
  for (let i = 0; i <= 200; i++) { const x = i / 200; dTT = Math.max(dTT, Math.abs(T1(x) - T2(x))); dff = Math.max(dff, Math.abs(f1(x) - f2(x))); }
  plotFn(ctx, T, f1, 0, 1, C("--accent"), 1.2, [4, 3], 200);
  plotFn(ctx, T, f2, 0, 1, C("--seq2"), 1.2, [4, 3], 200);
  plotFn(ctx, T, T1, 0, 1, C("--accent"), 3, null, 120);
  plotFn(ctx, T, T2, 0, 1, C("--seq2"), 3, null, 120);
  PP.label(ctx, "T(f₁)", T.X(0.02), T.Y(T1(0.02)) - 6, C("--accent"), "left", "bottom", 12);
  PP.label(ctx, "T(f₂) = g", T.X(0.98), T.Y(0.5) + 6, C("--seq2"), "right", "top", 12);
  PP.label(ctx, "f₁", T.X(0.25), T.Y(f1(0.25)) - 4, C("--accent"), "center", "bottom", 11);
  PP.label(ctx, "f₂ = 0", T.X(0.98), T.Y(0) - 4, C("--seq2"), "right", "bottom", 11);
  const bound = Math.abs(lam) * dff;
  PP.read("ejp4alt-o8-1-read", [
    ["d∞(f₁, f₂)", F(dff, 4)],
    ["d∞(T(f₁), T(f₂))", F(dTT, 4)],
    ["c|λ|(b − a)·d∞(f₁, f₂)", F(bound, 4), dTT <= bound + 1e-9 ? "good" : "bad"],
    ["c|λ|(b − a) < 1 (contracción)", Math.abs(lam) < 1 ? "sí" : "no", Math.abs(lam) < 1 ? "good" : "bad"],
  ]);
}, ["ejp4alt-o8-1-l"]);

/* O7-7 a): h(x) = mín{|x − a|, |x − b|} en ℝ, con a y b arrastrables. */
(() => {
  const st = { a: 0.6, b: 3.2 };
  let T = null;
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp4alt-o7-7-c1", 0.62);
    T = PP.frame(w, h, { x0: -1, x1: 5, y0: -0.5, y1: 3.2 }, { l: 30, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xTicks: 6, yTicks: 4 });
    plotFn(ctx, T, (x) => Math.abs(x - st.a), -1, 5, C("--accent"), 1.2, [4, 3], 50);
    plotFn(ctx, T, (x) => Math.abs(x - st.b), -1, 5, C("--seq2"), 1.2, [4, 3], 50);
    plotFn(ctx, T, (x) => Math.min(Math.abs(x - st.a), Math.abs(x - st.b)), -1, 5, C("--ink"), 3, null, 600);
    PP.dot(ctx, T.X(st.a), T.Y(0), 6, C("--accent"));
    PP.dot(ctx, T.X(st.b), T.Y(0), 6, C("--seq2"));
    PP.label(ctx, "a", T.X(st.a), T.Y(0) + 8, C("--accent"), "center", "top", 12);
    PP.label(ctx, "b", T.X(st.b), T.Y(0) + 8, C("--seq2"), "center", "top", 12);
    PP.label(ctx, "h", T.X((st.a + st.b) / 2) + 6, T.Y(Math.abs(st.b - st.a) / 2) - 4, C("--ink"), "left", "bottom", 13);
    PP.read("ejp4alt-o7-7-read", [
      ["a, b", F(st.a, 2) + ", " + F(st.b, 2)],
      ["h en el punto medio = d(a, b)/2", F(Math.abs(st.b - st.a) / 2, 3)],
    ]);
  }
  PP.register(draw, []);
  draggable("ejp4alt-o7-7-c1", () => T, (px, py, T) => nearest([["a", st.a, 0], ["b", st.b, 0]], px, py, T, 34),
    (id, x) => { st[id] = clamp(x, -0.8, 4.8); }, draw);
})();
