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
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: -0.2, y1: 1 }, { l: 34, r: 12, t: 12, b: 28 });
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


/* ===================== Bloque 8 ===================== */
const dist = (p, q) => Math.hypot(p[0] - q[0], p[1] - q[1]);
/* Punto del segmento [p, q] más cercano a z. */
function projSeg(z, p, q) {
  const vx = q[0] - p[0], vy = q[1] - p[1], L = vx * vx + vy * vy;
  const t = L ? clamp(((z[0] - p[0]) * vx + (z[1] - p[1]) * vy) / L, 0, 1) : 0;
  return [p[0] + t * vx, p[1] + t * vy];
}

/* O7-1: |d(x, a) − d(x0, a)| ≤ d(x, x0) en el plano. */
(() => {
  const st = { a: [-1.6, -0.6], x0: [0.9, 0.9], x: [1.9, 0.1] };
  let T = null;
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp4alt-o7-1-c1", 0.66);
    T = fitFrame(w, h, 0.2, 0.1, 6.4, 4.2);
    const { a, x0, x } = st, ra = dist(x0, a), rb = dist(x, a), pxu = T.X(1) - T.X(0);
    PP.circle(ctx, T.X(a[0]), T.Y(a[1]), ra * pxu, C("--accent"), null, [5, 4], 1.3);
    PP.circle(ctx, T.X(a[0]), T.Y(a[1]), rb * pxu, C("--seq2"), null, [5, 4], 1.3);
    PP.path(ctx, [[T.X(a[0]), T.Y(a[1])], [T.X(x0[0]), T.Y(x0[1])]], C("--accent"), 1.5);
    PP.path(ctx, [[T.X(a[0]), T.Y(a[1])], [T.X(x[0]), T.Y(x[1])]], C("--seq2"), 1.5);
    PP.path(ctx, [[T.X(x0[0]), T.Y(x0[1])], [T.X(x[0]), T.Y(x[1])]], C("--fail"), 3);
    [["a", a, C("--ink")], ["x₀", x0, C("--accent")], ["x", x, C("--seq2")]].forEach(([lab, p, col]) => {
      PP.dot(ctx, T.X(p[0]), T.Y(p[1]), 6, col);
      PP.label(ctx, lab, T.X(p[0]) + 8, T.Y(p[1]) - 6, col, "left", "bottom", 13);
    });
    const diff = Math.abs(rb - ra), dxx = dist(x, x0);
    PP.read("ejp4alt-o7-1-read", [
      ["d(x, a), d(x₀, a)", F(rb, 3) + ", " + F(ra, 3)],
      ["|d(x, a) − d(x₀, a)|", F(diff, 3)],
      ["d(x, x₀)", F(dxx, 3)],
      ["|d_a(x) − d_a(x₀)| ≤ d(x, x₀)", diff <= dxx + 1e-12 ? "sí" : "no", diff <= dxx + 1e-12 ? "good" : "bad"],
    ]);
  }
  PP.register(draw, []);
  draggable("ejp4alt-o7-1-c1", () => T, (px, py, T) => nearest([["a", ...st.a], ["x0", ...st.x0], ["x", ...st.x]], px, py, T, 30),
    (id, xx, yy, T) => { st[id] = [clamp(xx, T.box.x0, T.box.x1), clamp(yy, T.box.y0, T.box.y1)]; }, draw);
})();

/* O10-3: B(y, ε) con ε = d(x, y) − r queda fuera de la bola cerrada B[x, r]. */
(() => {
  const st = { y: [2.3, 1.1] };
  let T = null;
  function draw() {
    const r = PP.val("ejp4alt-o10-3-r") / 10;
    PP.out("ejp4alt-o10-3-r-o", F(r, 1));
    const { ctx, w, h } = PP.canvas("ejp4alt-o10-3-c1", 0.66);
    T = fitFrame(w, h, 0.4, 0, 7, 5);
    const x = [0, 0], y = st.y, pxu = T.X(1) - T.X(0), dxy = dist(x, y), eps = dxy - r;
    PP.circle(ctx, T.X(0), T.Y(0), r * pxu, C("--seq2"), C("--area2"), null, 2);
    PP.label(ctx, "B[x, r]", T.X(0), T.Y(-r) + 6, C("--seq2"), "center", "top", 12);
    PP.dot(ctx, T.X(0), T.Y(0), 4, C("--seq2"));
    PP.label(ctx, "x", T.X(0) + 6, T.Y(0) - 4, C("--seq2"), "left", "bottom", 12);
    if (eps > 0) {
      PP.circle(ctx, T.X(y[0]), T.Y(y[1]), eps * pxu, C("--accent"), C("--band"), [5, 4], 2);
      const u = [y[0] / dxy, y[1] / dxy];
      PP.path(ctx, [[T.X(u[0] * r), T.Y(u[1] * r)], [T.X(y[0]), T.Y(y[1])]], C("--accent"), 2);
      PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(u[0] * r), T.Y(u[1] * r)]], C("--seq2"), 1.2, [3, 3]);
      PP.label(ctx, "ε", T.X((u[0] * r + y[0]) / 2) - 4, T.Y((u[1] * r + y[1]) / 2) - 4, C("--accent"), "right", "bottom", 13);
    }
    PP.dot(ctx, T.X(y[0]), T.Y(y[1]), 6, eps > 0 ? C("--accent") : C("--fail"));
    PP.label(ctx, "y", T.X(y[0]) + 8, T.Y(y[1]) - 6, eps > 0 ? C("--accent") : C("--fail"), "left", "bottom", 13);
    PP.read("ejp4alt-o10-3-read", eps > 0 ? [
      ["d(x, y)", F(dxy, 3)],
      ["ε = d(x, y) − r", F(eps, 3), "good"],
      ["B(y, ε) ⊆ A", "sí", "good"],
    ] : [["d(x, y) ≤ r", F(dxy, 3) + " ≤ " + F(r, 1), "bad"], ["y ∈ A", "no: arrastralo afuera", "bad"]]);
  }
  PP.register(draw, ["ejp4alt-o10-3-r"]);
  draggable("ejp4alt-o10-3-c1", () => T, (px, py, T) => nearest([["y", ...st.y]], px, py, T, 40),
    (id, xx, yy, T) => { st.y = [clamp(xx, T.box.x0, T.box.x1), clamp(yy, T.box.y0, T.box.y1)]; }, draw);
})();

/* O2-8, definición: d(x, A) con A = disco abierto ∪ segmento. */
(() => {
  const st = { x: [1.5, 1.4] };
  const c = [-1, 0.4], R = 1.1, p = [0.7, -1.3], q = [2.5, -0.3];
  let T = null;
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp4alt-o2-8-c1", 0.66);
    T = fitFrame(w, h, 0.5, 0, 6, 4);
    const pxu = T.X(1) - T.X(0), x = st.x;
    PP.circle(ctx, T.X(c[0]), T.Y(c[1]), R * pxu, C("--ok"), C("--okband"), [5, 4], 1.8);
    PP.path(ctx, [[T.X(p[0]), T.Y(p[1])], [T.X(q[0]), T.Y(q[1])]], C("--ok"), 4);
    PP.label(ctx, "A", T.X(c[0]), T.Y(c[1]), C("--ok"), "center", "middle", 14);
    const dc = dist(x, c), dDisc = Math.max(0, dc - R), sp = projSeg(x, p, q), dSeg = dist(x, sp);
    const dd = Math.min(dDisc, dSeg);
    let np;
    if (dDisc <= dSeg) np = dc > R ? [c[0] + (x[0] - c[0]) * R / dc, c[1] + (x[1] - c[1]) * R / dc] : x; else np = sp;
    if (dd > 0) {
      PP.path(ctx, [[T.X(x[0]), T.Y(x[1])], [T.X(np[0]), T.Y(np[1])]], C("--accent"), 2, [5, 4]);
      if (dDisc <= dSeg) PP.circle(ctx, T.X(np[0]), T.Y(np[1]), 4, C("--accent"), C("--bg"), null, 2);
      else PP.dot(ctx, T.X(np[0]), T.Y(np[1]), 4, C("--accent"));
    }
    PP.dot(ctx, T.X(x[0]), T.Y(x[1]), 6, C("--accent"));
    PP.label(ctx, "x", T.X(x[0]) + 8, T.Y(x[1]) - 6, C("--accent"), "left", "bottom", 13);
    const att = dd === 0 ? (dc < R ? "x ∈ A" : "sí") : (dDisc <= dSeg ? "no: el punto más cercano está en el borde del disco, fuera de A" : "sí, en el segmento");
    PP.read("ejp4alt-o2-8-read1", [
      ["d(x, A)", F(dd, 3)],
      ["¿el ínfimo se alcanza en A?", att],
    ]);
  }
  PP.register(draw, []);
  draggable("ejp4alt-o2-8-c1", () => T, (px, py, T) => nearest([["x", ...st.x]], px, py, T, 40),
    (id, xx, yy, T) => { st.x = [clamp(xx, T.box.x0, T.box.x1), clamp(yy, T.box.y0, T.box.y1)]; }, draw);
})();

/* O2-8, proposición: x ↦ d(x, A) en ℝ y el cono de pendiente 1. */
(() => {
  const st = { p: -0.3 };
  const dA = (x) => Math.min(x < -2 ? -2 - x : x > -1 ? x + 1 : 0, Math.abs(x - 0.5), x <= 1.5 ? 1.5 - x : x >= 2.5 ? x - 2.5 : 0);
  let T = null;
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp4alt-o2-8-c2", 0.62);
    T = PP.frame(w, h, { x0: -3.2, x1: 3.6, y0: -0.35, y1: 1.6 }, { l: 30, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xTicks: 7, yTicks: 4 });
    const p = st.p, dp = dA(p);
    const top = [], bot = [];
    for (let i = 0; i <= 120; i++) { const x = T.box.x0 + (T.box.x1 - T.box.x0) * i / 120; top.push([T.X(x), T.Y(dp + Math.abs(x - p))]); bot.unshift([T.X(x), T.Y(dp - Math.abs(x - p))]); }
    ctx.save(); ctx.beginPath(); ctx.rect(T.p.l, T.p.t, w - T.p.l - T.p.r, h - T.p.t - T.p.b); ctx.clip();
    PP.path(ctx, top.concat(bot), C("--accent"), 1, [4, 4], true, C("--band"));
    ctx.restore();
    PP.path(ctx, [[T.X(-2), T.Y(0)], [T.X(-1), T.Y(0)]], C("--ok"), 5);
    PP.dot(ctx, T.X(0.5), T.Y(0), 4.5, C("--ok"));
    PP.path(ctx, [[T.X(1.5), T.Y(0)], [T.X(2.5), T.Y(0)]], C("--ok"), 5);
    PP.circle(ctx, T.X(1.5), T.Y(0), 4.5, C("--ok"), C("--bg"), null, 2);
    PP.circle(ctx, T.X(2.5), T.Y(0), 4.5, C("--ok"), C("--bg"), null, 2);
    PP.label(ctx, "A", T.X(-1.5), T.Y(0) + 6, C("--ok"), "center", "top", 12);
    plotFn(ctx, T, dA, T.box.x0, T.box.x1, C("--ink"), 2.4, null, 700);
    PP.path(ctx, [[T.X(p), T.Y(0)], [T.X(p), T.Y(dp)]], C("--accent"), 1, [3, 3]);
    PP.dot(ctx, T.X(p), T.Y(dp), 6, C("--accent"));
    let worst = -Infinity; for (let i = 0; i <= 600; i++) { const x = T.box.x0 + (T.box.x1 - T.box.x0) * i / 600; worst = Math.max(worst, Math.abs(dA(x) - dp) - Math.abs(x - p)); }
    PP.read("ejp4alt-o2-8-read2", [
      ["x₀, d(x₀, A)", F(p, 2) + ", " + F(dp, 3)],
      ["máx (|d(x, A) − d(x₀, A)| − |x − x₀|)", F(Math.max(0, worst), 4) + " ≤ 0", "good"],
    ]);
  }
  PP.register(draw, []);
  draggable("ejp4alt-o2-8-c2", () => T, (px, py, T) => (Math.abs(T.X(st.p) - px) < 40 ? "p" : null),
    (id, xx, yy, T) => { st.p = clamp(xx, T.box.x0, T.box.x1); }, draw);
})();

/* O4-4: B(A, 1/k) como unión de bolas B(y, 1/k), y ∈ A. */
PP.register(function o4_4() {
  const k = PP.val("ejp4alt-o4-4-k"), r = 1 / k;
  PP.out("ejp4alt-o4-4-k-o", String(k));
  const { ctx, w, h } = PP.canvas("ejp4alt-o4-4-c1", 0.66);
  const T = fitFrame(w, h, 0.4, 0.1, 5.6, 3.6);
  const pxu = T.X(1) - T.X(0), pts = [];
  const step = Math.min(0.02, r / 4);
  for (let t = 0; t <= 1 + 1e-9; t += step / 2) pts.push([-2 + 2 * t, -1]);
  for (let t = 0; t <= Math.PI + 1e-9; t += step) pts.push([1 + Math.cos(Math.PI - t), 0.2 + Math.sin(Math.PI - t)]);
  pts.push([2.6, -0.9]);
  ctx.save(); ctx.beginPath();
  pts.forEach(([x, y]) => { ctx.moveTo(T.X(x) + r * pxu, T.Y(y)); ctx.arc(T.X(x), T.Y(y), r * pxu, 0, Math.PI * 2); });
  ctx.fillStyle = C("--area"); ctx.fill("nonzero"); ctx.restore();
  PP.path(ctx, [[T.X(-2), T.Y(-1)], [T.X(0), T.Y(-1)]], C("--ok"), 3);
  const arc = []; for (let t = 0; t <= 60; t++) arc.push([T.X(1 + Math.cos(Math.PI - Math.PI * t / 60)), T.Y(0.2 + Math.sin(Math.PI - Math.PI * t / 60))]);
  PP.path(ctx, arc, C("--ok"), 3);
  PP.dot(ctx, T.X(2.6), T.Y(-0.9), 4, C("--ok"));
  PP.label(ctx, "A", T.X(-1), T.Y(-1) + 8, C("--ok"), "center", "top", 13);
  PP.label(ctx, "B(A, 1/" + k + ")", T.X(-1.9), T.Y(-1 + r) - 4, C("--accent"), "left", "bottom", 12);
  PP.read("ejp4alt-o4-4-read", [
    ["r = 1/k", F(r, 4)],
    ["bolas dibujadas", String(pts.length)],
  ]);
}, ["ejp4alt-o4-4-k"]);

/* O2-9: ζ = d(x, C) / (d(x, C) + d(x, D)) en ℝ; U y V. */
PP.register(function o2_9() {
  const hh = -1.5 + PP.val("ejp4alt-o2-9-g") / 10, showUV = document.getElementById("ejp4alt-o2-9-uv").checked;
  PP.out("ejp4alt-o2-9-g-o", F(hh, 1));
  const { ctx, w, h } = PP.canvas("ejp4alt-o2-9-c1", 0.62);
  const T = PP.frame(w, h, { x0: -3.6, x1: 3.6, y0: -0.62, y1: 1.2 }, { l: 30, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 7, yTicks: 4 });
  const dI = (x, a, b) => (x < a ? a - x : x > b ? x - b : 0);
  const dC = (x) => Math.min(dI(x, -3, -1.5), dI(x, 2.5, 3)), dD = (x) => dI(x, hh, 1.5);
  const z = (x) => dC(x) / (dC(x) + dD(x));
  PP.path(ctx, [[T.p.l, T.Y(0.5)], [w - T.p.r, T.Y(0.5)]], C("--muted"), 1, [4, 4]);
  PP.label(ctx, "1/2", w - T.p.r - 2, T.Y(0.5) - 3, C("--muted"), "right", "bottom", 11);
  [[-3, -1.5], [2.5, 3]].forEach(([a, b]) => PP.path(ctx, [[T.X(a), T.Y(0)], [T.X(b), T.Y(0)]], C("--ok"), 5));
  PP.path(ctx, [[T.X(hh), T.Y(0)], [T.X(1.5), T.Y(0)]], C("--seq2"), 5);
  PP.label(ctx, "C", T.X(-2.25), T.Y(0) - 6, C("--ok"), "center", "bottom", 12);
  PP.label(ctx, "C", T.X(2.75), T.Y(0) - 6, C("--ok"), "center", "bottom", 12);
  PP.label(ctx, "D", T.X((hh + 1.5) / 2), T.Y(0) - 6, C("--seq2"), "center", "bottom", 12);
  plotFn(ctx, T, z, T.box.x0, T.box.x1, C("--ink"), 2.4, null, 800);
  PP.label(ctx, "ζ", T.X(0.9), T.Y(1) - 4, C("--ink"), "left", "bottom", 13);
  if (showUV) {
    const N = 400; let prev = null, start = T.box.x0;
    const band = (a, b, isU) => { const yy = isU ? -0.3 : -0.48; PP.path(ctx, [[T.X(a), T.Y(yy)], [T.X(b), T.Y(yy)]], isU ? C("--accent") : C("--seq2"), 6); };
    for (let i = 0; i <= N; i++) {
      const x = T.box.x0 + (T.box.x1 - T.box.x0) * i / N, v = z(x), s = v < 0.5 ? "U" : v > 0.5 ? "V" : "0";
      if (prev !== null && s !== prev) { if (prev !== "0") band(start, x, prev === "U"); start = x; }
      if (prev === null) start = x;
      prev = s;
    }
    if (prev !== "0") band(start, T.box.x1, prev === "U");
    PP.label(ctx, "U", T.p.l + 2, T.Y(-0.3) - 4, C("--accent"), "left", "bottom", 11);
    PP.label(ctx, "V", T.p.l + 2, T.Y(-0.48) - 4, C("--seq2"), "left", "bottom", 11);
  }
  PP.read("ejp4alt-o2-9-read", [
    ["D = [h, 1.5] con h", F(hh, 1)],
    ["ζ en C, ζ en D", "0, 1"],
    ["d(C, D)", F(Math.min(hh + 1.5, 1), 2)],
  ]);
}, ["ejp4alt-o2-9-g", "ejp4alt-o2-9-uv"]);

/* O12-3: U = {d_E − d_F < 0}, V = {d_E − d_F > 0} en el plano. */
(() => {
  const st = { p: [0.9, -1.1], q: [1.7, 1.2] };
  const c = [-1.3, 0.1], R = 0.8;
  let T = null;
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp4alt-o12-3-c1", 0.66);
    T = fitFrame(w, h, 0.2, 0, 6, 4, { l: 0, r: 0, t: 0, b: 0 });
    const cell = 4, colU = C("--area"), colV = C("--area2");
    const dE = (z) => Math.max(0, dist(z, c) - R), dF = (z) => dist(z, projSeg(z, st.p, st.q));
    for (let py = 0; py < h; py += cell) for (let px = 0; px < w; px += cell) {
      const z = [T.iX(px + cell / 2), T.iY(py + cell / 2)], s = dE(z) - dF(z);
      ctx.fillStyle = s < 0 ? colU : colV; ctx.fillRect(px, py, cell, cell);
    }
    PP.circle(ctx, T.X(c[0]), T.Y(c[1]), R * (T.X(1) - T.X(0)), C("--accent"), C("--accent"), null, 2);
    PP.label(ctx, "E", T.X(c[0]), T.Y(c[1]), C("--bg"), "center", "middle", 14);
    PP.path(ctx, [[T.X(st.p[0]), T.Y(st.p[1])], [T.X(st.q[0]), T.Y(st.q[1])]], C("--seq2"), 4);
    PP.dot(ctx, T.X(st.p[0]), T.Y(st.p[1]), 6, C("--seq2"));
    PP.dot(ctx, T.X(st.q[0]), T.Y(st.q[1]), 6, C("--seq2"));
    PP.label(ctx, "F", T.X((st.p[0] + st.q[0]) / 2) + 10, T.Y((st.p[1] + st.q[1]) / 2), C("--seq2"), "left", "middle", 14);
    PP.label(ctx, "U", 10, 10, C("--accent"), "left", "top", 14);
    PP.label(ctx, "V", w - 10, 10, C("--seq2"), "right", "top", 14);
    let meet = false; for (let i = 0; i <= 50; i++) { const t = i / 50; if (dist([st.p[0] + t * (st.q[0] - st.p[0]), st.p[1] + t * (st.q[1] - st.p[1])], c) <= R) meet = true; }
    PP.read("ejp4alt-o12-3-read", meet ? [["E ∩ F", "≠ ∅: separá el segmento del disco", "bad"]] : [
      ["E ⊆ U (ahí d_E = 0 y d_F > 0)", "sí", "good"],
      ["F ⊆ V (ahí d_F = 0 y d_E > 0)", "sí", "good"],
    ]);
  }
  PP.register(draw, []);
  draggable("ejp4alt-o12-3-c1", () => T, (px, py, T) => nearest([["p", ...st.p], ["q", ...st.q]], px, py, T, 30),
    (id, xx, yy, T) => { st[id] = [clamp(xx, T.box.x0 + 0.1, T.box.x1 - 0.1), clamp(yy, T.box.y0 + 0.1, T.box.y1 - 0.1)]; }, draw);
})();

/* O2-10: las ramas y = 1/x e y = −1/x, a distancia 2/x en la abscisa x. */
PP.register(function o2_10() {
  const x = PP.val("ejp4alt-o2-10-x") / 10;
  PP.out("ejp4alt-o2-10-x-o", F(x, 1));
  const { ctx, w, h } = PP.canvas("ejp4alt-o2-10-c1", 0.66);
  const T = PP.frame(w, h, { x0: -0.2, x1: 6.3, y0: -3.2, y1: 3.2 }, { l: 30, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 6, yTicks: 6 });
  plotFn(ctx, T, (t) => 1 / t, 0.3, 6.3, C("--accent"), 2.4);
  plotFn(ctx, T, (t) => -1 / t, 0.3, 6.3, C("--seq2"), 2.4);
  PP.label(ctx, "y = 1/x", T.X(0.45), T.Y(2.6), C("--accent"), "left", "middle", 12);
  PP.label(ctx, "y = −1/x", T.X(0.45), T.Y(-2.6), C("--seq2"), "left", "middle", 12);
  PP.path(ctx, [[T.X(x), T.Y(1 / x)], [T.X(x), T.Y(-1 / x)]], C("--fail"), 2.5);
  PP.dot(ctx, T.X(x), T.Y(1 / x), 5, C("--accent"));
  PP.dot(ctx, T.X(x), T.Y(-1 / x), 5, C("--seq2"));
  PP.read("ejp4alt-o2-10-read", [
    ["d((x, 1/x), (x, −1/x)) = 2/x", F(2 / x, 4)],
  ]);
}, ["ejp4alt-o2-10-x"]);


/* ===================== Bloque 9 ===================== */

/* O6-1: f Lipschitz con K = 1.3; caja de ancho 2δ (δ = ε/K) y alto 2ε en un punto arrastrable. */
(() => {
  const st = { y: 1.4 };
  const f = (x) => 0.5 * Math.sin(2 * x) + 0.3 * x, K = 1.3;
  let T = null;
  function draw() {
    const eps = PP.val("ejp4alt-o6-1-eps") / 100, del = eps / K;
    PP.out("ejp4alt-o6-1-eps-o", F(eps, 2));
    const { ctx, w, h } = PP.canvas("ejp4alt-o6-1-c1", 0.66);
    T = PP.frame(w, h, { x0: 0, x1: 4, y0: -0.6, y1: 1.9 }, { l: 32, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xTicks: 4, yTicks: 5 });
    const y = st.y, fy = f(y);
    ctx.save(); ctx.beginPath(); ctx.rect(T.p.l, T.p.t, w - T.p.l - T.p.r, h - T.p.t - T.p.b); ctx.clip();
    [-1, 1].forEach((s) => PP.path(ctx, [[T.X(y - 3), T.Y(fy - s * K * 3)], [T.X(y + 3), T.Y(fy + s * K * 3)]], C("--muted"), 1, [4, 4]));
    PP.rect(ctx, T.X(y - del), T.Y(fy + eps), T.X(y + del) - T.X(y - del), T.Y(fy - eps) - T.Y(fy + eps), C("--accent"), C("--band"));
    ctx.restore();
    plotFn(ctx, T, f, 0, 4, C("--ink"), 2.2);
    PP.dot(ctx, T.X(y), T.Y(fy), 6, C("--accent"));
    PP.label(ctx, "y", T.X(y) + 6, T.Y(fy) + 6, C("--accent"), "left", "top", 12);
    let worst = 0; for (let i = 0; i <= 200; i++) { const x = y - del + 2 * del * i / 200; worst = Math.max(worst, Math.abs(f(x) - fy)); }
    PP.read("ejp4alt-o6-1-read", [
      ["δ = ε/K", F(del, 4)],
      ["máx |f(x) − f(y)| con |x − y| < δ", F(worst, 4) + " < " + F(eps, 2), worst < eps ? "good" : "bad"],
    ]);
  }
  PP.register(draw, ["ejp4alt-o6-1-eps"]);
  draggable("ejp4alt-o6-1-c1", () => T, (px, py, T) => (Math.abs(T.X(st.y) - px) < 40 ? "y" : null),
    (id, xx) => { st.y = clamp(xx, 0, 4); }, draw);
})();

/* O3-8: para x² con x_n = n, y_n = n + 1/n, las dos sucesiones de distancias. */
PP.register(function o3_8() {
  const N = PP.val("ejp4alt-o3-8-n");
  PP.out("ejp4alt-o3-8-n-o", String(N));
  const { ctx, w, h } = PP.canvas("ejp4alt-o3-8-c1", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: N + 1, y0: 0, y1: 3.4 }, { l: 32, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: Math.min(N + 1, 8), yTicks: 4, intX: true, xLabel: "n" });
  PP.path(ctx, [[T.p.l, T.Y(2)], [w - T.p.r, T.Y(2)]], C("--seq2"), 1, [5, 4]);
  PP.label(ctx, "2", w - T.p.r - 4, T.Y(2) - 3, C("--seq2"), "right", "bottom", 11);
  for (let n = 1; n <= N; n++) {
    const a = 1 / n, b = (n + 1 / n) ** 2 - n * n;
    PP.dot(ctx, T.X(n), T.Y(a), 4, C("--accent"));
    PP.dot(ctx, T.X(n), T.Y(b), 4, C("--seq2"));
  }
  PP.label(ctx, "|xₙ − yₙ| = 1/n", T.X(1) + 8, T.Y(1) + 2, C("--accent"), "left", "top", 12);
  PP.label(ctx, "|f(xₙ) − f(yₙ)| = 2 + 1/n²", T.X(1) + 8, T.Y(3) - 2, C("--seq2"), "left", "bottom", 12);
  PP.read("ejp4alt-o3-8-read", [
    ["|x" + sub(N) + " − y" + sub(N) + "|", F(1 / N, 4), "good"],
    ["|f(x" + sub(N) + ") − f(y" + sub(N) + ")|", F(2 + 1 / (N * N), 4), "bad"],
  ]);
}, ["ejp4alt-o3-8-n"]);

/* O14-6: los pares de la nota para 1/x y para sen(1/x). */
PP.register(function o14_6() {
  const n = PP.val("ejp4alt-o14-6-n"), which = PP.radio("ejp4alt-o14-6-f");
  PP.out("ejp4alt-o14-6-n-o", String(n));
  const { ctx, w, h } = PP.canvas("ejp4alt-o14-6-c1", 0.66);
  let f, xn, yn, box;
  if (which === "inv") { f = (x) => 1 / x; xn = 1 / n; yn = 1 / (n + 1); box = { x0: 0, x1: 1.05, y0: 0, y1: Math.max(4, n + 2) }; }
  else { f = (x) => Math.sin(1 / x); xn = 1 / (2 * n * Math.PI); yn = 1 / (2 * n * Math.PI + Math.PI / 2); box = { x0: 0, x1: Math.min(0.4, 6 * xn), y0: -1.25, y1: 1.35 }; }
  const T = PP.frame(w, h, box, { l: 34, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 4, yTicks: 5 });
  plotFn(ctx, T, f, Math.max(1e-4, box.x1 / 4000), box.x1, C("--ink"), 1.6, null, 4000);
  [xn, yn].forEach((x, i) => {
    const col = i ? C("--seq2") : C("--accent");
    PP.path(ctx, [[T.X(x), T.Y(Math.max(box.y0, 0))], [T.X(x), T.Y(Math.min(box.y1, f(x)))]], col, 1, [3, 3]);
    PP.dot(ctx, T.X(x), T.Y(f(x)), 5, col);
  });
  PP.path(ctx, [[T.X((xn + yn) / 2), T.Y(f(xn))], [T.X((xn + yn) / 2), T.Y(f(yn))]], C("--fail"), 3);
  PP.label(ctx, "xₙ", T.X(xn) + 4, T.Y(f(xn)) - 4, C("--accent"), "left", "bottom", 12);
  PP.label(ctx, "yₙ", T.X(yn) - 4, T.Y(f(yn)) - 4, C("--seq2"), "right", "bottom", 12);
  PP.read("ejp4alt-o14-6-read", [
    ["d(xₙ, yₙ) < 1/n", F(Math.abs(xn - yn), 5) + " < " + F(1 / n, 4), "good"],
    ["d(f(xₙ), f(yₙ))", F(Math.abs(f(xn) - f(yn)), 4), "bad"],
  ]);
}, ["ejp4alt-o14-6-n", "input[name='ejp4alt-o14-6-f']"]);

/* O5-1: ω_f(η) para f = √x en [0, 4], calculado numéricamente. */
PP.register(function o5_1() {
  const eta = PP.val("ejp4alt-o5-1-eta") / 50;
  PP.out("ejp4alt-o5-1-eta-o", F(eta, 2));
  const { ctx, w, h } = PP.canvas("ejp4alt-o5-1-c1", 0.66);
  const T = PP.frame(w, h, { x0: -0.1, x1: 4.1, y0: -0.15, y1: 2.3 }, { l: 32, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 4, yTicks: 4 });
  const f = (x) => Math.sqrt(Math.max(0, x));
  let best = -1, ba = 0, bb = 0; const M = 400;
  for (let i = 0; i <= M; i++) { const a = 4 * i / M, b = Math.min(4, a + eta), v = Math.abs(f(b) - f(a)); if (v > best + 1e-12) { best = v; ba = a; bb = b; } }
  vband(ctx, T, ba, bb, C("--band"));
  hband(ctx, T, f(ba), f(bb), C("--area2"));
  plotFn(ctx, T, f, 0, 4, C("--ink"), 2.2);
  PP.dot(ctx, T.X(ba), T.Y(f(ba)), 5, C("--accent"));
  PP.dot(ctx, T.X(bb), T.Y(f(bb)), 5, C("--accent"));
  PP.path(ctx, [[T.X(ba), T.Y(0)], [T.X(bb), T.Y(0)]], C("--accent"), 3);
  PP.label(ctx, "η", T.X((ba + bb) / 2), T.Y(0) - 4, C("--accent"), "center", "bottom", 12);
  PP.path(ctx, [[T.X(bb) + 6, T.Y(f(ba))], [T.X(bb) + 6, T.Y(f(bb))]], C("--seq2"), 3);
  PP.label(ctx, "ω(η)", T.X(bb) + 10, T.Y((f(ba) + f(bb)) / 2), C("--seq2"), "left", "middle", 12);
  PP.read("ejp4alt-o5-1-read", [
    ["par que da el supremo (a, b)", "(" + F(ba, 2) + ", " + F(bb, 2) + ")"],
    ["ω_f(η) (numérico)", F(best, 4)],
  ]);
}, ["ejp4alt-o5-1-eta"]);

/* O14-8: e^x cerca de n; |x_n − y_n| = 1/n y ρ(x_n, y_n) = e^{n+1/n} − e^n. */
PP.register(function o14_8() {
  const n = PP.val("ejp4alt-o14-8-n");
  PP.out("ejp4alt-o14-8-n-o", String(n));
  const { ctx, w, h } = PP.canvas("ejp4alt-o14-8-c1", 0.66);
  const top = Math.exp(n + 1.2);
  const T = PP.frame(w, h, { x0: n - 1, x1: n + 1.2, y0: 0, y1: top }, { l: 48, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xTicks: 4, yTicks: 4, zero: false });
  plotFn(ctx, T, Math.exp, n - 1, n + 1.2, C("--ink"), 2.2);
  const xn = n, yn = n + 1 / n, ex = Math.exp(xn), ey = Math.exp(yn);
  PP.path(ctx, [[T.X(xn), T.Y(0) - 2], [T.X(yn), T.Y(0) - 2]], C("--accent"), 5);
  PP.path(ctx, [[T.X(xn), T.Y(0)], [T.X(xn), T.Y(ex)]], C("--accent"), 1, [3, 3]);
  PP.path(ctx, [[T.X(yn), T.Y(0)], [T.X(yn), T.Y(ey)]], C("--accent"), 1, [3, 3]);
  PP.path(ctx, [[T.X(yn) + 8, T.Y(ex)], [T.X(yn) + 8, T.Y(ey)]], C("--fail"), 3);
  PP.path(ctx, [[T.X(xn), T.Y(ex)], [T.X(yn) + 8, T.Y(ex)]], C("--fail"), 1, [3, 3]);
  PP.dot(ctx, T.X(xn), T.Y(ex), 5, C("--accent"));
  PP.dot(ctx, T.X(yn), T.Y(ey), 5, C("--accent"));
  PP.label(ctx, "ρ", T.X(yn) + 12, T.Y((ex + ey) / 2), C("--fail"), "left", "middle", 13);
  PP.label(ctx, "1/n", T.X((xn + yn) / 2), T.Y(0) - 8, C("--accent"), "center", "bottom", 12);
  PP.read("ejp4alt-o14-8-read", [
    ["|xₙ − yₙ| = 1/n", F(1 / n, 4), "good"],
    ["ρ(xₙ, yₙ) = eⁿ(e^(1/n) − 1)", F(ey - ex, 2), "bad"],
    ["eⁿ/n", F(ex / n, 2)],
  ]);
}, ["ejp4alt-o14-8-n"]);
