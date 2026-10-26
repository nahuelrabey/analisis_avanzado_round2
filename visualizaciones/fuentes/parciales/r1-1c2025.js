/* Dibujos del primer recuperatorio, 1C 2025 (r1-1c2025). Usa window.PP (ver _shell.html). */
const ID = "r1-1c2025";
const C = (t) => PP.css(t);

/* Marco con la misma escala en los dos ejes, centrado en (cx, cy) y con media altura `half`. */
function eqFrame(w, h, cx, cy, half, pad) {
  const p = pad == null ? 12 : pad;
  const s = (h - 2 * p) / (2 * half);
  const halfX = (w - 2 * p) / (2 * s);
  const T = PP.frame(w, h, { x0: cx - halfX, x1: cx + halfX, y0: cy - half, y1: cy + half }, { l: p, r: p, t: p, b: p });
  T.s = s;
  return T;
}

/* Arrastre de puntos: getT() da el último marco, getPts() los puntos, setPt(i, x, y) mueve uno. */
function draggable(id, getT, getPts, setPt, redraw, grabAny) {
  const cv = document.getElementById(id);
  if (!cv) return;
  let active = -1;
  const pos = (e) => { const r = cv.getBoundingClientRect(); return [e.clientX - r.left, e.clientY - r.top]; };
  cv.style.cursor = "grab";
  cv.addEventListener("pointerdown", (e) => {
    const T = getT(); if (!T) return;
    const [px, py] = pos(e);
    const pts = getPts();
    let best = -1, bd = 26;
    pts.forEach((q, i) => { const dd = Math.hypot(T.X(q[0]) - px, T.Y(q[1]) - py); if (dd < bd) { bd = dd; best = i; } });
    if (best < 0 && grabAny) best = 0;
    if (best < 0) return;
    active = best;
    try { cv.setPointerCapture(e.pointerId); } catch (err) { /* sin captura */ }
    setPt(active, T.iX(px), T.iY(py)); redraw(); e.preventDefault();
  });
  cv.addEventListener("pointermove", (e) => {
    if (active < 0) return;
    const T = getT(); const [px, py] = pos(e);
    setPt(active, T.iX(px), T.iY(py)); redraw();
  });
  const end = () => { active = -1; };
  cv.addEventListener("pointerup", end);
  cv.addEventListener("pointercancel", end);
}

function arrowHead(ctx, x, y, ang, color, size) {
  const s = size || 6;
  ctx.save(); ctx.fillStyle = color; ctx.beginPath();
  ctx.moveTo(x, y);
  ctx.lineTo(x - s * Math.cos(ang - 0.45), y - s * Math.sin(ang - 0.45));
  ctx.lineTo(x - s * Math.cos(ang + 0.45), y - s * Math.sin(ang + 0.45));
  ctx.closePath(); ctx.fill(); ctx.restore();
}

function roundRect(ctx, x, y, w, h, r, stroke, fill, lw) {
  ctx.save(); ctx.beginPath();
  ctx.moveTo(x + r, y); ctx.lineTo(x + w - r, y); ctx.quadraticCurveTo(x + w, y, x + w, y + r);
  ctx.lineTo(x + w, y + h - r); ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
  ctx.lineTo(x + r, y + h); ctx.quadraticCurveTo(x, y + h, x, y + h - r);
  ctx.lineTo(x, y + r); ctx.quadraticCurveTo(x, y, x + r, y); ctx.closePath();
  if (fill) { ctx.fillStyle = fill; ctx.fill(); }
  if (stroke) { ctx.strokeStyle = stroke; ctx.lineWidth = lw || 1.2; ctx.stroke(); }
  ctx.restore();
}

/* ======================= Ejercicio 1: la codificación Φ ======================= */
const N1 = 10;
const PRESETS = {
  ejemplo: [1, 0, 1, 1, 0, 0, 1, 0, 1, 0],
  ceros: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  unos: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  alterna: [0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
};
let bits = PRESETS.ejemplo.slice();
/* s[i] = s_{i+1}: s[0] = s_1 = 0, s[i+1] = s[i] + b[i]. */
const sSeq = (b) => { const s = [0]; for (let i = 0; i < b.length; i++) s.push(s[i] + b[i]); return s; };
const LAB = 64, PR = 8;
const colW = (w) => (w - LAB - PR) / N1;
const colX = (w, i) => LAB + colW(w) * (i + 0.5);   // centro de la columna i (n = i + 1)
let T13 = null;

function drawE1() {
  const s = sSeq(bits);
  const ink = C("--ink"), mut = C("--muted"), rule = C("--rule"), acc = C("--accent"), s2 = C("--seq2"), ok = C("--ok");

  /* c1: tabla n, b_n, s_n, Φ(b)_n */
  {
    const { ctx, w, h } = PP.canvas(ID + "-ej1-c1", 0.4);
    const cw = colW(w), rh = (h - 12) / 4, top = 6;
    const fs = Math.max(10, Math.min(14, cw * 0.42));
    const rows = ["n", "bₙ", "sₙ", "Φ(b)ₙ"];
    rows.forEach((r, k) => {
      const yc = top + rh * (k + 0.5);
      PP.label(ctx, r, 6, yc, k === 0 ? mut : k === 3 ? s2 : k === 1 ? acc : ink, "left", "middle", 13);
      if (k > 0) PP.path(ctx, [[4, top + rh * k], [w - PR, top + rh * k]], rule, 1);
    });
    for (let i = 0; i < N1; i++) {
      const x = colX(w, i);
      PP.label(ctx, String(i + 1), x, top + rh * 0.5, mut, "center", "middle", fs);
      const bw = Math.min(cw - 4, 30), bh = Math.min(rh - 8, 28);
      roundRect(ctx, x - bw / 2, top + rh * 1.5 - bh / 2, bw, bh, 5, acc, bits[i] ? C("--area") : null, 1.2);
      PP.label(ctx, String(bits[i]), x, top + rh * 1.5, acc, "center", "middle", fs);
      PP.label(ctx, String(s[i]), x, top + rh * 2.5, ink, "center", "middle", fs);
      PP.label(ctx, String(Math.pow(2, s[i])), x, top + rh * 3.5, s2, "center", "middle", fs);
    }
    PP.read(ID + "-ej1-read1", [
      ["b", bits.join(", ") + ", …"],
      ["s₁ … s₁₀", s.slice(0, N1).join(", ")],
      ["Φ(b)₁ … Φ(b)₁₀", s.slice(0, N1).map((v) => Math.pow(2, v)).join(", ")],
    ]);
  }

  /* c2: cadena Φ(b)_n → Φ(b)_{n+1} con el factor k = 2^{b_n} */
  {
    const { ctx, w, h } = PP.canvas(ID + "-ej1-c2", 0.36);
    const cw = colW(w);
    const fs = Math.max(10, Math.min(14, cw * 0.42));
    const yb = h * 0.3, bh = Math.min(30, h * 0.2);
    PP.label(ctx, "Φ(b)ₙ", 6, yb, s2, "left", "middle", 13);
    PP.label(ctx, "k = 2^bₙ", 6, h * 0.72, ok, "left", "middle", 12);
    for (let i = 0; i < N1; i++) {
      const x = colX(w, i), bw = Math.min(cw - 5, 34);
      roundRect(ctx, x - bw / 2, yb - bh / 2, bw, bh, 5, s2, C("--area2"), 1.2);
      PP.label(ctx, String(Math.pow(2, s[i])), x, yb, ink, "center", "middle", fs);
    }
    for (let i = 0; i < N1 - 1; i++) {
      const x0 = colX(w, i), x1 = colX(w, i + 1), ym = yb + bh / 2 + 4;
      const depth = h * 0.2;
      const col = bits[i] ? acc : mut;
      ctx.save(); ctx.strokeStyle = col; ctx.lineWidth = bits[i] ? 1.8 : 1.2; ctx.beginPath();
      ctx.moveTo(x0, ym); ctx.quadraticCurveTo((x0 + x1) / 2, ym + depth, x1 - 2, ym + 2); ctx.stroke(); ctx.restore();
      arrowHead(ctx, x1 - 1, ym + 1, -Math.PI / 3.2, col, 6);
      PP.label(ctx, "·" + (bits[i] ? 2 : 1), (x0 + x1) / 2, h * 0.72, bits[i] ? acc : mut, "center", "middle", fs);
    }
    PP.label(ctx, "k ∈ {1, 2} ⊆ ℤ en cada flecha", w - PR, h - 6, ok, "right", "bottom", 12);
    const allDiv = s.slice(0, N1 - 1).every((v, i) => Math.pow(2, s[i + 1]) % Math.pow(2, v) === 0);
    PP.read(ID + "-ej1-read2", [
      ["Φ(b)ₙ ∣ Φ(b)ₙ₊₁ (n ≤ 9)", allDiv ? "sí, en todos" : "no", allDiv ? "good" : "bad"],
      ["factores k", bits.slice(0, N1 - 1).map((b) => (b ? 2 : 1)).join(", ")],
    ]);
  }

  /* c3: escalera s_n = log₂ Φ(b)_n */
  {
    const { ctx, w, h } = PP.canvas(ID + "-ej1-c3", 0.55);
    const smax = Math.max(3, s[N1]);
    const T = PP.frame(w, h, { x0: 0.5, x1: N1 + 1.5, y0: -0.6, y1: smax + 0.9 }, { l: 40, r: 10, t: 12, b: 30 });
    T13 = T;
    PP.axes(ctx, T, { xLabel: "n", yLabel: "sₙ = log₂ Φ(b)ₙ", intX: true, xTicks: 11, yTicks: Math.min(6, smax + 1) });
    for (let i = 0; i < N1; i++) {
      const n = i + 1;
      PP.path(ctx, [[T.X(n), T.Y(s[i])], [T.X(n + 1), T.Y(s[i])]], mut, 1.5);
      if (bits[i]) PP.path(ctx, [[T.X(n + 1), T.Y(s[i])], [T.X(n + 1), T.Y(s[i + 1])]], acc, 3);
      PP.label(ctx, String(bits[i]), T.X(n + 0.5), T.Y(s[i]) - 4, bits[i] ? acc : mut, "center", "bottom", 12);
    }
    for (let i = 0; i <= N1; i++) PP.dot(ctx, T.X(i + 1), T.Y(s[i]), 4, s2);
    const back = s.slice(1).map((v, i) => v - s[i]);
    const same = back.every((v, i) => v === bits[i]);
    PP.read(ID + "-ej1-read3", [
      ["saltos sₙ₊₁ − sₙ", back.join(", ")],
      ["b original", bits.join(", ")],
      ["¿coinciden?", same ? "sí: b se lee de Φ(b)" : "no", same ? "good" : "bad"],
    ]);
  }
}
PP.register(drawE1, []);

function uncheck(name) { document.querySelectorAll(`input[name="${name}"]`).forEach((r) => { r.checked = false; }); }
document.querySelectorAll(`input[name="${ID}-ej1-modo"]`).forEach((r) => {
  r.addEventListener("change", () => {
    const v = PP.radio(ID + "-ej1-modo");
    if (v === "azar") bits = Array.from({ length: N1 }, () => (Math.random() < 0.5 ? 1 : 0));
    else if (PRESETS[v]) bits = PRESETS[v].slice();
    drawE1();
  });
});
function toggleBit(i) {
  if (i < 0 || i >= N1) return;
  bits[i] = 1 - bits[i]; uncheck(ID + "-ej1-modo"); drawE1();
}
(() => {
  const c1 = document.getElementById(ID + "-ej1-c1"), c2 = document.getElementById(ID + "-ej1-c2"), c3 = document.getElementById(ID + "-ej1-c3");
  const px = (cv, e) => e.clientX - cv.getBoundingClientRect().left;
  if (c1) { c1.style.cursor = "pointer"; c1.addEventListener("click", (e) => toggleBit(Math.floor((px(c1, e) - LAB) / colW(c1.clientWidth)))); }
  if (c2) { c2.style.cursor = "pointer"; c2.addEventListener("click", (e) => { const i = Math.floor((px(c2, e) - LAB) / colW(c2.clientWidth) - 0.5); if (i >= 0 && i < N1 - 1) toggleBit(i); }); }
  if (c3) { c3.style.cursor = "pointer"; c3.addEventListener("click", (e) => { if (T13) toggleBit(Math.floor(T13.iX(px(c3, e))) - 1); }); }
})();

/* ======================= Ejercicio 2 a): A + B ======================= */
const aK = (k) => 1 - 1 / k;          // A = {1 − 1/k}, α = 1
const bK = (k) => 0.5 * (1 - 1 / k);  // B = {(1 − 1/k)/2}, β = 1/2
const ALPHA = 1, BETA = 0.5;

function rowsFrame(w, h) {
  return PP.frame(w, h, { x0: -0.08, x1: 1.62, y0: -0.75, y1: 2.6 }, { l: 50, r: 14, t: 8, b: 26 });
}
function drawRows(ctx, T, w) {
  const mut = C("--muted");
  [["A", 2, C("--accent")], ["B", 1, C("--seq2")], ["A + B", 0, C("--seq3")]].forEach(([name, y, col]) => {
    PP.path(ctx, [[T.X(-0.06), T.Y(y)], [T.X(1.6), T.Y(y)]], mut, 1);
    PP.label(ctx, name, 6, T.Y(y), col, "left", "middle", 13);
  });
  [0, 0.5, 1, 1.5].forEach((v) => {
    PP.path(ctx, [[T.X(v), T.Y(0) - 3], [T.X(v), T.Y(0) + 3]], mut, 1);
    PP.label(ctx, PP.fmt(v, 1), T.X(v), T.Y(0) + 6, mut, "center", "top", 11);
  });
  for (let k = 1; k <= 60; k++) {
    PP.dot(ctx, T.X(aK(k)), T.Y(2), 2.2, C("--accent"));
    PP.dot(ctx, T.X(bK(k)), T.Y(1), 2.2, C("--seq2"));
  }
  for (let i = 1; i <= 14; i++) for (let j = 1; j <= 14; j++) PP.dot(ctx, T.X(aK(i) + bK(j)), T.Y(0), 1.6, C("--seq3"));
}
function supMark(ctx, T, x, y, label, col) {
  PP.path(ctx, [[T.X(x), T.Y(y) - 12], [T.X(x), T.Y(y) + 12]], col, 2.2);
  PP.label(ctx, label, T.X(x) + 4, T.Y(y) - 10, col, "left", "bottom", 12);
}

function drawE2a() {
  const i = PP.val(ID + "-ej2-i"), j = PP.val(ID + "-ej2-j");
  PP.out(ID + "-ej2-i-o", "i = " + i); PP.out(ID + "-ej2-j-o", "j = " + j);
  const { ctx, w, h } = PP.canvas(ID + "-ej2-c1", 0.6);
  const T = rowsFrame(w, h);
  drawRows(ctx, T, w);
  const a = aK(i), b = bK(j), x = a + b;
  supMark(ctx, T, ALPHA, 2, "α", C("--accent"));
  supMark(ctx, T, BETA, 1, "β", C("--seq2"));
  supMark(ctx, T, ALPHA + BETA, 0, "α + β", C("--ink"));
  PP.path(ctx, [[T.X(a), T.Y(2)], [T.X(x), T.Y(0)]], C("--accent"), 1, [4, 3]);
  PP.path(ctx, [[T.X(b), T.Y(1)], [T.X(x), T.Y(0)]], C("--seq2"), 1, [4, 3]);
  PP.dot(ctx, T.X(a), T.Y(2), 6, C("--accent"));
  PP.dot(ctx, T.X(b), T.Y(1), 6, C("--seq2"));
  PP.dot(ctx, T.X(x), T.Y(0), 6, C("--seq3"));
  PP.label(ctx, "x = a + b", T.X(x) - 8, T.Y(0) - 14, C("--seq3"), "right", "bottom", 12);
  PP.read(ID + "-ej2-read1", [
    ["a ∈ A, a ≤ α", PP.fmt(a, 4) + " ≤ 1"],
    ["b ∈ B, b ≤ β", PP.fmt(b, 4) + " ≤ 0.5"],
    ["x = a + b", PP.fmt(x, 4)],
    ["x ≤ α + β = 1.5", x <= ALPHA + BETA ? "sí" : "no", x <= ALPHA + BETA ? "good" : "bad"],
  ]);
}
PP.register(drawE2a, [ID + "-ej2-i", ID + "-ej2-j"]);

function drawE2b() {
  const eps = PP.val(ID + "-ej2-eps") / 100;
  PP.out(ID + "-ej2-eps-o", PP.fmt(eps, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej2-c2", 0.6);
  const T = rowsFrame(w, h);
  const bandH = 9;
  PP.rect(ctx, T.X(ALPHA - eps / 2), T.Y(2) - bandH, T.X(ALPHA) - T.X(ALPHA - eps / 2), 2 * bandH, null, C("--area"));
  PP.rect(ctx, T.X(BETA - eps / 2), T.Y(1) - bandH, T.X(BETA) - T.X(BETA - eps / 2), 2 * bandH, null, C("--area2"));
  PP.rect(ctx, T.X(ALPHA + BETA - eps), T.Y(0) - bandH, T.X(ALPHA + BETA) - T.X(ALPHA + BETA - eps), 2 * bandH, null, C("--area3"));
  drawRows(ctx, T, w);
  supMark(ctx, T, ALPHA, 2, "α", C("--accent"));
  supMark(ctx, T, BETA, 1, "β", C("--seq2"));
  const ka = Math.floor(2 / eps) + 1, kb = Math.floor(1 / eps) + 1;
  const ae = aK(ka), be = bK(kb), se = ae + be;
  PP.dot(ctx, T.X(ae), T.Y(2), 6, C("--accent"));
  PP.dot(ctx, T.X(be), T.Y(1), 6, C("--seq2"));
  PP.dot(ctx, T.X(se), T.Y(0), 6, C("--seq3"));
  PP.label(ctx, "aε", T.X(ae), T.Y(2) + 10, C("--accent"), "center", "top", 12);
  PP.label(ctx, "bε", T.X(be), T.Y(1) + 10, C("--seq2"), "center", "top", 12);
  PP.label(ctx, "aε + bε", T.X(se) - 6, T.Y(0) - 12, C("--seq3"), "right", "bottom", 12);
  PP.path(ctx, [[T.X(ALPHA + BETA), T.Y(0) - 12], [T.X(ALPHA + BETA), T.Y(0) + 12]], C("--fail"), 2.4);
  PP.label(ctx, "σ", T.X(ALPHA + BETA) + 4, T.Y(0) - 10, C("--fail"), "left", "bottom", 13);
  PP.label(ctx, "ε/2", T.X(ALPHA - eps / 4), T.Y(2) - 12, C("--muted"), "center", "bottom", 11);
  PP.label(ctx, "ε/2", T.X(BETA - eps / 4), T.Y(1) - 12, C("--muted"), "center", "bottom", 11);
  const okIneq = ALPHA + BETA - eps < se && se <= ALPHA + BETA;
  PP.read(ID + "-ej2-read2", [
    ["aε (k = " + ka + ")", PP.fmt(ae, 4) + " > α − ε/2 = " + PP.fmt(ALPHA - eps / 2, 4)],
    ["bε (k = " + kb + ")", PP.fmt(be, 4) + " > β − ε/2 = " + PP.fmt(BETA - eps / 2, 4)],
    ["α + β − ε < aε + bε ≤ σ", PP.fmt(ALPHA + BETA - eps, 4) + " < " + PP.fmt(se, 4) + " ≤ 1.5", okIneq ? "good" : "bad"],
  ]);
}
PP.register(drawE2b, [ID + "-ej2-eps"]);

/* ======================= Ejercicio 3: bolas y densidad ======================= */
const E3 = { x: [0.8, 0.6] };
let T31 = null, T32 = null;
function e3State() {
  const r = PP.val(ID + "-ej3-r") / 100;
  const [x1, x2] = E3.x, nx = Math.hypot(x1, x2);
  const d0 = Math.min(0.5 * r, nx);
  const u = nx < 1e-9 ? [0, 0] : [x1 - d0 * x1 / nx, x2 - d0 * x2 / nx];
  const dxu = Math.hypot(u[0] - x1, u[1] - x2);
  const s = 1 - Math.hypot(u[0], u[1]);
  const rho = Math.min(s, r - dxu);
  return { r, x: E3.x, u, dxu, s, rho };
}
function e3Base(ctx, T, st) {
  const sc = T.s;
  PP.circle(ctx, T.X(0), T.Y(0), sc, C("--accent"), C("--band"), [6, 5], 1.6);
  PP.label(ctx, "U", T.X(-0.62), T.Y(0.62), C("--accent"), "center", "middle", 14);
  PP.circle(ctx, T.X(st.x[0]), T.Y(st.x[1]), st.r * sc, C("--seq2"), null, [4, 4], 1.6);
}
function e3Points(ctx, T, st) {
  PP.dot(ctx, T.X(st.x[0]), T.Y(st.x[1]), 5, C("--ink"));
  PP.label(ctx, "x", T.X(st.x[0]) + 7, T.Y(st.x[1]) - 5, C("--ink"), "left", "bottom", 13);
  PP.dot(ctx, T.X(st.u[0]), T.Y(st.u[1]), 4.5, C("--seq3"));
  PP.label(ctx, "u", T.X(st.u[0]) - 7, T.Y(st.u[1]) - 5, C("--seq3"), "right", "bottom", 13);
}
function drawE3() {
  const st = e3State();
  PP.out(ID + "-ej3-r-o", PP.fmt(st.r, 2));
  const m = PP.val(ID + "-ej3-m");
  PP.out(ID + "-ej3-m-o", String(m));

  /* c1: construcción de ρ */
  {
    const { ctx, w, h } = PP.canvas(ID + "-ej3-c1", 0.72);
    const T = eqFrame(w, h, 0.25, 0.15, 1.2);
    T31 = T;
    e3Base(ctx, T, st);
    PP.circle(ctx, T.X(st.u[0]), T.Y(st.u[1]), st.s * T.s, C("--seq3"), C("--area3"), [3, 3], 1.4);
    PP.circle(ctx, T.X(st.u[0]), T.Y(st.u[1]), st.rho * T.s, C("--accent"), C("--area"), null, 2);
    e3Points(ctx, T, st);
    PP.label(ctx, "B(x, r)", T.X(st.x[0] + st.r * 0.72), T.Y(st.x[1] + st.r * 0.72), C("--seq2"), "left", "bottom", 12);
    PP.label(ctx, "B(u, s)", T.X(st.u[0] - st.s * 0.72), T.Y(st.u[1] - st.s * 0.72), C("--seq3"), "right", "top", 12);
    PP.read(ID + "-ej3-read1", [
      ["r", PP.fmt(st.r, 3)],
      ["d(x, u)", PP.fmt(st.dxu, 3) + " < r"],
      ["s (B(u, s) ⊆ U)", PP.fmt(st.s, 3)],
      ["r − d(x, u)", PP.fmt(st.r - st.dxu, 3)],
      ["ρ = mín{s, r − d(x, u)}", PP.fmt(st.rho, 3) + " > 0", st.rho > 0 ? "good" : "bad"],
    ]);
  }

  /* c2: un punto de X = ℚ² (denominador m) en B(u, ρ) */
  {
    const { ctx, w, h } = PP.canvas(ID + "-ej3-c2", 0.72);
    const T = eqFrame(w, h, 0.25, 0.15, 1.2);
    T32 = T;
    e3Base(ctx, T, st);
    PP.circle(ctx, T.X(st.u[0]), T.Y(st.u[1]), st.rho * T.s, C("--accent"), C("--area"), null, 2);
    const { x0, x1, y0, y1 } = T.box;
    const dotR = m > 16 ? 0.9 : 1.4;
    const mutc = C("--muted");
    ctx.save(); ctx.globalAlpha = 0.55;
    for (let i = Math.ceil(x0 * m); i <= Math.floor(x1 * m); i++) {
      for (let j = Math.ceil(y0 * m); j <= Math.floor(y1 * m); j++) PP.dot(ctx, T.X(i / m), T.Y(j / m), dotR, mutc);
    }
    ctx.restore();
    let best = null, bd = Infinity;
    for (let i = Math.floor((st.u[0] - st.rho) * m) - 1; i <= Math.ceil((st.u[0] + st.rho) * m) + 1; i++) {
      for (let j = Math.floor((st.u[1] - st.rho) * m) - 1; j <= Math.ceil((st.u[1] + st.rho) * m) + 1; j++) {
        const dd = Math.hypot(i / m - st.u[0], j / m - st.u[1]);
        if (dd < st.rho - 1e-12 && dd < bd) { bd = dd; best = [i, j]; }
      }
    }
    e3Points(ctx, T, st);
    const rows = [];
    if (best) {
      const y = [best[0] / m, best[1] / m];
      const dxy = Math.hypot(y[0] - st.x[0], y[1] - st.x[1]);
      PP.path(ctx, [[T.X(st.x[0]), T.Y(st.x[1])], [T.X(st.u[0]), T.Y(st.u[1])]], C("--seq3"), 1.6);
      PP.path(ctx, [[T.X(st.u[0]), T.Y(st.u[1])], [T.X(y[0]), T.Y(y[1])]], C("--accent"), 1.6);
      PP.path(ctx, [[T.X(st.x[0]), T.Y(st.x[1])], [T.X(y[0]), T.Y(y[1])]], C("--ok"), 1.6, [4, 3]);
      PP.dot(ctx, T.X(y[0]), T.Y(y[1]), 5.5, C("--ok"));
      PP.label(ctx, "y", T.X(y[0]) + 7, T.Y(y[1]) + 4, C("--ok"), "left", "top", 13);
      rows.push(["y ∈ X", "(" + best[0] + "/" + m + ", " + best[1] + "/" + m + ")", "good"]);
      rows.push(["d(u, y) < ρ ≤ s", PP.fmt(bd, 3) + " < " + PP.fmt(st.rho, 3) + " ⇒ y ∈ U", "good"]);
      rows.push(["d(x, u) + d(u, y)", PP.fmt(st.dxu + bd, 3) + " < r = " + PP.fmt(st.r, 3)]);
      rows.push(["d(x, y)", PP.fmt(dxy, 3) + " < r ⇒ y ∈ B(x, r)", dxy < st.r ? "good" : "bad"]);
    } else {
      rows.push(["y", "ningún punto con denominador " + m + " en B(u, ρ): subí m", "bad"]);
    }
    PP.read(ID + "-ej3-read2", rows);
  }
}
PP.register(drawE3, [ID + "-ej3-r", ID + "-ej3-m"]);
const setX3 = (i, x, y) => { const n = Math.hypot(x, y); E3.x = n > 1 ? [x / n, y / n] : [x, y]; };
draggable(ID + "-ej3-c1", () => T31, () => [E3.x], setX3, drawE3, true);
draggable(ID + "-ej3-c2", () => T32, () => [E3.x], setX3, drawE3, true);

/* ======================= Ejercicio 4: d = máx{4/3 d∞, d₂} ======================= */
const dInf = (p, q) => Math.max(Math.abs(p[0] - q[0]), Math.abs(p[1] - q[1]));
const d2 = (p, q) => Math.hypot(p[0] - q[0], p[1] - q[1]);
const dd = (p, q) => Math.max(4 / 3 * dInf(p, q), d2(p, q));
/* Borde de la bola de una métrica homogénea: radio en la dirección θ para la "norma" f. */
function ballPath(T, f, r) {
  const pts = [];
  for (let k = 0; k <= 720; k++) {
    const t = (k / 720) * 2 * Math.PI, v = [Math.cos(t), Math.sin(t)];
    const rad = r / f(v, [0, 0]);
    pts.push([T.X(rad * v[0]), T.Y(rad * v[1])]);
  }
  return pts;
}

/* 4 a) desigualdad triangular */
const E4 = { P: [[-1.1, -0.55], [0.25, 0.75], [1.25, -0.35]] };
let T41 = null;
function drawE4a() {
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c1", 0.95);
  const hp = Math.round(h * 0.64);
  const T = eqFrame(w, hp, 0.1, 0.05, 1.3);
  T41 = T;
  const [x, y, z] = E4.P;
  const mut = C("--muted"), ink = C("--ink"), acc = C("--accent"), s2 = C("--seq2"), s3 = C("--seq3");
  PP.path(ctx, [[0, T.Y(0)], [w, T.Y(0)]], C("--rule"), 1);
  PP.path(ctx, [[T.X(0), 0], [T.X(0), hp]], C("--rule"), 1);
  PP.path(ctx, [[T.X(x[0]), T.Y(x[1])], [T.X(y[0]), T.Y(y[1])]], acc, 2);
  PP.path(ctx, [[T.X(y[0]), T.Y(y[1])], [T.X(z[0]), T.Y(z[1])]], s3, 2);
  PP.path(ctx, [[T.X(x[0]), T.Y(x[1])], [T.X(z[0]), T.Y(z[1])]], s2, 2, [5, 4]);
  [["x", x], ["y", y], ["z", z]].forEach(([n, p]) => {
    PP.dot(ctx, T.X(p[0]), T.Y(p[1]), 6, ink);
    PP.label(ctx, n, T.X(p[0]) + 8, T.Y(p[1]) - 6, ink, "left", "bottom", 14);
  });
  const dxy = dd(x, y), dyz = dd(y, z), dxz = dd(x, z);
  const i43 = 4 / 3 * dInf(x, z), e2 = d2(x, z);
  /* barras */
  const top = hp + 8, L = 70, R = w - 14, bh = Math.max(14, (h - hp - 30) / 4);
  const scale = (R - L) / Math.max(dxy + dyz, 1e-9);
  PP.path(ctx, [[0, hp], [w, hp]], C("--rule"), 1);
  const y1 = top + bh * 0.6, y2 = top + bh * 2.4;
  PP.label(ctx, "d(x, z)", 6, y1 + bh / 2, s2, "left", "middle", 12);
  PP.rect(ctx, L, y1, dxz * scale, bh, s2, C("--area2"));
  PP.label(ctx, "d(x, y)", 6, y2 + bh / 2 - 7, acc, "left", "middle", 12);
  PP.label(ctx, "+ d(y, z)", 6, y2 + bh / 2 + 7, s3, "left", "middle", 12);
  PP.rect(ctx, L, y2, dxy * scale, bh, acc, C("--area"));
  PP.rect(ctx, L + dxy * scale, y2, dyz * scale, bh, s3, C("--area3"));
  [[i43, "4/3 d∞"], [e2, "d₂"]].forEach(([v, lab], k) => {
    const X = L + v * scale;
    PP.path(ctx, [[X, y1 - 4], [X, y1 + bh + 4]], ink, 2);
    PP.label(ctx, lab, X, k === 0 ? y1 - 5 : y1 + bh + 5, ink, "center", k === 0 ? "bottom" : "top", 11);
  });
  PP.path(ctx, [[R, y1 - 6], [R, y2 + bh + 6]], mut, 1, [3, 3]);
  PP.read(ID + "-ej4-read1", [
    ["4/3 d∞(x, z)", PP.fmt(i43, 3) + " ≤ " + PP.fmt(4 / 3 * dInf(x, y) + 4 / 3 * dInf(y, z), 3) + " ≤ " + PP.fmt(dxy + dyz, 3)],
    ["d₂(x, z)", PP.fmt(e2, 3) + " ≤ " + PP.fmt(d2(x, y) + d2(y, z), 3) + " ≤ " + PP.fmt(dxy + dyz, 3)],
    ["d(x, z) ≤ d(x, y) + d(y, z)", PP.fmt(dxz, 3) + " ≤ " + PP.fmt(dxy, 3) + " + " + PP.fmt(dyz, 3), dxz <= dxy + dyz + 1e-12 ? "good" : "bad"],
  ]);
}
PP.register(drawE4a, []);
draggable(ID + "-ej4-c1", () => T41, () => E4.P, (i, x, y) => {
  const T = T41; if (!T) return;
  E4.P[i] = [Math.max(T.box.x0, Math.min(T.box.x1, x)), Math.max(T.box.y0, Math.min(T.box.y1, y))];
}, drawE4a);

/* 4 b) la bola B_d(0, 1) */
const E4b = { p: [0.55, 0.3] };
let T42 = null;
function drawE4b() {
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c2", 0.82);
  const T = eqFrame(w, h, 0, 0, 1.22);
  T42 = T;
  const mut = C("--muted");
  PP.path(ctx, [[T.X(T.box.x0), T.Y(0)], [T.X(T.box.x1), T.Y(0)]], mut, 1);
  PP.path(ctx, [[T.X(0), T.Y(T.box.y0)], [T.X(0), T.Y(T.box.y1)]], mut, 1);
  PP.path(ctx, ballPath(T, dd, 1), C("--ink"), 2, null, true, C("--area"));
  PP.rect(ctx, T.X(-0.75), T.Y(0.75), 1.5 * T.s, 1.5 * T.s, C("--accent"), null, [5, 4]);
  PP.circle(ctx, T.X(0), T.Y(0), T.s, C("--seq2"), null, [5, 4], 1.5);
  [[0.75, "3/4"], [1, "1"]].forEach(([v, l]) => {
    PP.path(ctx, [[T.X(v), T.Y(0) - 4], [T.X(v), T.Y(0) + 4]], mut, 1);
    PP.label(ctx, l, T.X(v) + (v === 1 ? 4 : -4), T.Y(0) + 6, mut, v === 1 ? "left" : "right", "top", 11);
  });
  const h7 = Math.sqrt(7) / 4;
  PP.dot(ctx, T.X(0.75), T.Y(h7), 3, C("--ink"));
  PP.label(ctx, "(3/4, √7/4)", T.X(0.75) + 5, T.Y(h7) + 2, mut, "left", "top", 11);
  const p = E4b.p, o = [0, 0];
  const a = Math.abs(p[0]) < 0.75, b = Math.abs(p[1]) < 0.75, c = p[0] * p[0] + p[1] * p[1] < 1;
  const inside = a && b && c;
  PP.dot(ctx, T.X(p[0]), T.Y(p[1]), 6.5, inside ? C("--ok") : C("--fail"));
  PP.label(ctx, "p", T.X(p[0]) + 9, T.Y(p[1]) - 6, inside ? C("--ok") : C("--fail"), "left", "bottom", 14);
  PP.read(ID + "-ej4-read2", [
    ["p", "(" + PP.fmt(p[0], 3) + ", " + PP.fmt(p[1], 3) + ")"],
    ["|x| < 3/4 y |y| < 3/4", a && b ? "sí" : "no", a && b ? "good" : "bad"],
    ["x² + y² < 1", PP.fmt(p[0] * p[0] + p[1] * p[1], 4) + (c ? " (sí)" : " (no)"), c ? "good" : "bad"],
    ["d(p, 0) = máx{4/3 d∞, d₂}", "máx{" + PP.fmt(4 / 3 * dInf(p, o), 3) + ", " + PP.fmt(d2(p, o), 3) + "} = " + PP.fmt(dd(p, o), 3)],
    ["p ∈ bola de d, radio 1", inside ? "sí" : "no", inside ? "good" : "bad"],
  ]);
}
PP.register(drawE4b, []);
draggable(ID + "-ej4-c2", () => T42, () => [E4b.p], (i, x, y) => {
  E4b.p = [Math.max(-1.2, Math.min(1.2, x)), Math.max(-1.2, Math.min(1.2, y))];
  uncheck(ID + "-ej4-pto");
}, drawE4b, true);
document.querySelectorAll(`input[name="${ID}-ej4-pto"]`).forEach((r) => {
  r.addEventListener("change", () => {
    const v = PP.radio(ID + "-ej4-pto");
    E4b.p = v === "v" ? [0.75, 0.75] : v === "d" ? [0.9, 0] : [0.7, 0.7];
    drawE4b();
  });
});

/* 4 c) la cadena de desigualdades según la dirección */
function drawE4c1() {
  const th = PP.val(ID + "-ej4-th");
  PP.out(ID + "-ej4-th-o", th + "°");
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c3", 0.66);
  const T = PP.frame(w, h, { x0: 0, x1: 90, y0: 0, y1: 2.85 }, { l: 40, r: 64, t: 12, b: 30 });
  PP.axes(ctx, T, { xLabel: "θ (grados)", xTicks: 6, yTicks: 6 });
  const n = 2;
  const fs = [
    ["d∞", (t) => Math.max(Math.abs(Math.cos(t)), Math.abs(Math.sin(t))), C("--muted"), [4, 3]],
    ["d₂", () => 1, C("--seq3"), null],
    ["d", (t) => Math.max(4 / 3 * Math.max(Math.abs(Math.cos(t)), Math.abs(Math.sin(t))), 1), C("--accent"), null],
    ["4/3 d₂", () => 4 / 3, C("--seq3"), [6, 4]],
    ["4n/3 d∞", (t) => 4 * n / 3 * Math.max(Math.abs(Math.cos(t)), Math.abs(Math.sin(t))), C("--seq2"), null],
  ];
  fs.forEach(([name, f, col, dash]) => {
    const pts = [];
    for (let k = 0; k <= 180; k++) { const deg = k / 2; pts.push([T.X(deg), T.Y(f(deg * Math.PI / 180))]); }
    PP.path(ctx, pts, col, name === "d" ? 3 : 1.8, dash);
    const off = { "d∞": 9, "d₂": -9, "d": -9, "4/3 d₂": 9, "4n/3 d∞": 0 }[name];
    PP.label(ctx, name, T.X(90) + 4, T.Y(f(Math.PI / 2)) + off, col, "left", "middle", 11);
  });
  PP.path(ctx, [[T.X(th), T.Y(0)], [T.X(th), T.Y(2.85)]], C("--ink"), 1, [2, 3]);
  const t = th * Math.PI / 180;
  const vals = fs.map(([, f]) => f(t));
  vals.forEach((v, k) => PP.dot(ctx, T.X(th), T.Y(v), 4, fs[k][2]));
  PP.read(ID + "-ej4-read3", [
    ["x − y", "(" + PP.fmt(Math.cos(t), 3) + ", " + PP.fmt(Math.sin(t), 3) + ")"],
    ["d∞ ≤ d₂ ≤ d", PP.fmt(vals[0], 3) + " ≤ " + PP.fmt(vals[1], 3) + " ≤ " + PP.fmt(vals[2], 3)],
    ["d ≤ 4/3 d₂ ≤ 4n/3 d∞", PP.fmt(vals[2], 3) + " ≤ " + PP.fmt(vals[3], 3) + " ≤ " + PP.fmt(vals[4], 3)],
    ["¿la cadena vale?", vals.every((v, k) => k === 0 || vals[k - 1] <= v + 1e-12) ? "sí" : "no", vals.every((v, k) => k === 0 || vals[k - 1] <= v + 1e-12) ? "good" : "bad"],
  ]);
}
PP.register(drawE4c1, [ID + "-ej4-th"]);

/* 4 c) bolas encajadas */
const E4c = { p: [0.6, 0.45] };
let T44 = null;
function drawE4c2() {
  const which = PP.radio(ID + "-ej4-dp") || "2";
  const dp = which === "2" ? d2 : dInf;
  const c = which === "2" ? 4 / 3 : 8 / 3;
  const name = which === "2" ? "d₂" : "d∞";
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c4", 0.82);
  const T = eqFrame(w, h, 0, 0, 1.15);
  T44 = T;
  const mut = C("--muted");
  PP.path(ctx, [[T.X(T.box.x0), T.Y(0)], [T.X(T.box.x1), T.Y(0)]], C("--rule"), 1);
  PP.path(ctx, [[T.X(0), T.Y(T.box.y0)], [T.X(0), T.Y(T.box.y1)]], C("--rule"), 1);
  PP.path(ctx, ballPath(T, dp, 1), C("--seq2"), 1.6, [5, 4], true);
  PP.path(ctx, ballPath(T, dd, 1), C("--ink"), 2, null, true, C("--area"));
  PP.path(ctx, ballPath(T, dp, 1 / c), C("--seq3"), 2.2, null, true, C("--area3"));
  PP.label(ctx, "bola de " + name + ", radio 1", T.X(T.box.x1) - 4, T.Y(1.08), C("--seq2"), "right", "bottom", 12);
  PP.label(ctx, "bola de d, radio 1", T.X(T.box.x0) + 4, T.Y(-1.08), C("--ink"), "left", "top", 12);
  PP.label(ctx, "radio 1/c", T.X(0), T.Y(-0.04), C("--seq3"), "center", "top", 11);
  const p = E4c.p, o = [0, 0];
  const inSmall = dp(p, o) < 1 / c, inD = dd(p, o) < 1, inBig = dp(p, o) < 1;
  PP.dot(ctx, T.X(p[0]), T.Y(p[1]), 6, C("--ink"));
  PP.label(ctx, "p", T.X(p[0]) + 8, T.Y(p[1]) - 6, C("--ink"), "left", "bottom", 13);
  const yn = (b) => (b ? "sí" : "no");
  PP.read(ID + "-ej4-read4", [
    ["c", which === "2" ? "4/3" : "4n/3 = 8/3"],
    ["p en la bola de " + name + ", radio 1/c", yn(inSmall) + "  (" + name + " = " + PP.fmt(dp(p, o), 3) + ")", inSmall ? "good" : ""],
    ["p en la bola de d, radio 1", yn(inD) + "  (d = " + PP.fmt(dd(p, o), 3) + ")", inD ? "good" : ""],
    ["p en la bola de " + name + ", radio 1", yn(inBig), inBig ? "good" : ""],
    ["¿se respetan las inclusiones?", (!inSmall || inD) && (!inD || inBig) ? "sí" : "no", (!inSmall || inD) && (!inD || inBig) ? "good" : "bad"],
  ]);
}
PP.register(drawE4c2, [`input[name="${ID}-ej4-dp"]`]);
draggable(ID + "-ej4-c4", () => T44, () => [E4c.p], (i, x, y) => {
  E4c.p = [Math.max(-1.3, Math.min(1.3, x)), Math.max(-1.1, Math.min(1.1, y))];
}, drawE4c2, true);

/* 4 c) completitud: d(x_k, x) entre d∞ y (4n/3) d∞ */
function drawE4c3() {
  const eps = PP.val(ID + "-ej4-eps") / 100;
  PP.out(ID + "-ej4-eps-o", PP.fmt(eps, 2));
  const K = 40, n = 2, o = [0, 0];
  const xk = (k) => [Math.cos(k) / k, Math.sin(k) / k];
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c5", 0.62);
  const ymax = 4 * n / 3 * dInf(xk(1), o) * 1.05;
  const T = PP.frame(w, h, { x0: 0, x1: K + 1, y0: 0, y1: ymax }, { l: 40, r: 12, t: 12, b: 30 });
  PP.axes(ctx, T, { xLabel: "k", intX: true, xTicks: 8, yTicks: 5 });
  PP.rect(ctx, T.X(0), T.Y(eps), T.X(K + 1) - T.X(0), T.Y(0) - T.Y(eps), null, C("--okband"));
  PP.path(ctx, [[T.X(0), T.Y(eps)], [T.X(K + 1), T.Y(eps)]], C("--ok"), 1.2, [4, 3]);
  PP.label(ctx, "ε", T.X(K + 1) - 4, T.Y(eps) - 3, C("--ok"), "right", "bottom", 12);
  let k0 = null;
  for (let k = K; k >= 1; k--) { if (4 * n / 3 * dInf(xk(k), o) < eps) k0 = k; else break; }
  for (let k = 1; k <= K; k++) {
    const p = xk(k), di = dInf(p, o), dv = dd(p, o), bound = 4 * n / 3 * di;
    PP.path(ctx, [[T.X(k), T.Y(di)], [T.X(k), T.Y(bound)]], C("--rule"), 1);
    PP.dot(ctx, T.X(k), T.Y(bound), 3, C("--seq2"));
    PP.dot(ctx, T.X(k), T.Y(dv), 3.5, C("--accent"));
    PP.dot(ctx, T.X(k), T.Y(di), 2.5, C("--muted"));
  }
  if (k0) PP.path(ctx, [[T.X(k0), T.Y(0)], [T.X(k0), T.Y(ymax)]], C("--ok"), 1, [2, 3]);
  const lx = T.X(K * 0.55);
  PP.dot(ctx, lx, 22, 3, C("--seq2")); PP.label(ctx, "(4n/3) d∞(xₖ, x)", lx + 7, 22, C("--seq2"), "left", "middle", 11);
  PP.dot(ctx, lx, 38, 3.5, C("--accent")); PP.label(ctx, "d(xₖ, x)", lx + 7, 38, C("--accent"), "left", "middle", 11);
  PP.dot(ctx, lx, 54, 2.5, C("--muted")); PP.label(ctx, "d∞(xₖ, x)", lx + 7, 54, C("--muted"), "left", "middle", 11);
  let okAll = true;
  if (k0) for (let k = k0; k <= K; k++) if (dd(xk(k), o) >= eps) okAll = false;
  PP.read(ID + "-ej4-read5", [
    ["k₀ con (4n/3) d∞(xₖ, x) < ε", k0 ? String(k0) + " (para k ≥ k₀ dibujados)" : "más allá de k = " + K],
    ["d(xₖ, x) < ε para k ≥ k₀", k0 ? (okAll ? "sí" : "no") : "—", k0 ? (okAll ? "good" : "bad") : ""],
  ]);
}
PP.register(drawE4c3, [ID + "-ej4-eps"]);
