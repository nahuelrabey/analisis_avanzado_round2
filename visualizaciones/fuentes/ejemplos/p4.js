/* Dibujos de los ejemplos de la Práctica 4 (funciones continuas). Usa window.PP.
   Varios dibujos adaptan los de visualizaciones/ejemplos_p4.html. */
const P = "ejp4-";
const C = {};
const TOKENS = ["ink", "muted", "rule", "accent", "seq2", "seq3", "ok", "okband", "fail", "failband", "panel", "band", "area", "area2", "area3", "bg"];
function readColors() { TOKENS.forEach((k) => { C[k] = PP.css("--" + k); }); }
const UI = '500 12px "IBM Plex Sans", system-ui, sans-serif';
const UIs = '500 11px "IBM Plex Sans", system-ui, sans-serif';
const fmt = (v, d = 3) => { if (Math.abs(v) < 1e-12) return "0"; const s = PP.fmt(v, d); return s === "−0" ? "0" : s; };
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
function mulberry(seed) { return () => { seed |= 0; seed = (seed + 0x6d2b79f5) | 0; let t = Math.imul(seed ^ (seed >>> 15), 1 | seed); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; }

/* ---------- ejes y trazos en una caja (box en píxeles, xr e yr en coordenadas) ---------- */
function plot(ctx, box, xr, yr) {
  const X = (x) => box.x + ((x - xr[0]) / (xr[1] - xr[0])) * box.w;
  const Y = (y) => box.y + box.h - ((y - yr[0]) / (yr[1] - yr[0])) * box.h;
  const iX = (px) => xr[0] + ((px - box.x) / box.w) * (xr[1] - xr[0]);
  const iY = (py) => yr[0] + ((box.y + box.h - py) / box.h) * (yr[1] - yr[0]);
  const o = { X, Y, iX, iY, box, xr, yr };
  o.clip = (fn) => { ctx.save(); ctx.beginPath(); ctx.rect(box.x, box.y, box.w, box.h); ctx.clip(); fn(); ctx.restore(); };
  o.axes = ({ xt = [], yt = [], xl = "", yl = "" } = {}) => {
    const ay = yr[0] <= 0 && yr[1] >= 0 ? Y(0) : box.y + box.h;
    const ax = xr[0] <= 0 && xr[1] >= 0 ? X(0) : box.x;
    ctx.strokeStyle = C.muted; ctx.lineWidth = 1; ctx.setLineDash([]);
    ctx.beginPath(); ctx.moveTo(box.x, ay); ctx.lineTo(box.x + box.w, ay); ctx.moveTo(ax, box.y); ctx.lineTo(ax, box.y + box.h); ctx.stroke();
    ctx.fillStyle = C.muted; ctx.font = UIs;
    ctx.textAlign = "center"; ctx.textBaseline = "top";
    for (const t of xt) { const [v, s] = Array.isArray(t) ? t : [t, fmt(t)]; const px = X(v); ctx.beginPath(); ctx.moveTo(px, ay - 3); ctx.lineTo(px, ay + 3); ctx.stroke(); ctx.fillText(s, px, ay + 5); }
    ctx.textAlign = "right"; ctx.textBaseline = "middle";
    for (const t of yt) { const [v, s] = Array.isArray(t) ? t : [t, fmt(t)]; const py = Y(v); ctx.beginPath(); ctx.moveTo(ax - 3, py); ctx.lineTo(ax + 3, py); ctx.stroke(); ctx.fillText(s, ax - 6, py); }
    if (xl) { ctx.textAlign = "right"; ctx.textBaseline = "bottom"; ctx.fillText(xl, box.x + box.w, ay - 4); }
    if (yl) { ctx.textAlign = "left"; ctx.textBaseline = "top"; ctx.fillText(yl, ax + 5, box.y); }
  };
  o.fn = (f, color, w = 2, a = xr[0], b = xr[1], n = 600, dash) => o.clip(() => {
    ctx.strokeStyle = color; ctx.lineWidth = w; ctx.setLineDash(dash || []); ctx.beginPath();
    let pen = false;
    for (let i = 0; i <= n; i++) {
      const x = a + ((b - a) * i) / n, y = f(x);
      if (!isFinite(y)) { pen = false; continue; }
      const py = Y(y);
      if (py < box.y - 4000 || py > box.y + box.h + 4000) { pen = false; continue; }
      if (pen) ctx.lineTo(X(x), py); else ctx.moveTo(X(x), py);
      pen = true;
    }
    ctx.stroke(); ctx.setLineDash([]);
  });
  o.seg = (x1, y1, x2, y2, color, w = 1.5, dash) => o.clip(() => {
    ctx.strokeStyle = color; ctx.lineWidth = w; ctx.setLineDash(dash || []);
    ctx.beginPath(); ctx.moveTo(X(x1), Y(y1)); ctx.lineTo(X(x2), Y(y2)); ctx.stroke(); ctx.setLineDash([]);
  });
  o.dot = (x, y, color, r = 4, hollow = false) => {
    const px = X(x), py = Y(y);
    if (px < box.x - r || px > box.x + box.w + r || py < box.y - r || py > box.y + box.h + r) return;
    ctx.beginPath(); ctx.arc(px, py, r, 0, Math.PI * 2);
    if (hollow) { ctx.fillStyle = C.bg; ctx.fill(); ctx.strokeStyle = color; ctx.lineWidth = 1.6; ctx.setLineDash([]); ctx.stroke(); }
    else { ctx.fillStyle = color; ctx.fill(); }
  };
  o.text = (s, x, y, color, align = "left", base = "bottom", dx = 0, dy = 0, font = UI) => {
    ctx.fillStyle = color || C.ink; ctx.font = font; ctx.textAlign = align; ctx.textBaseline = base;
    ctx.fillText(s, X(x) + dx, Y(y) + dy);
  };
  o.vband = (a, b, fill) => o.clip(() => { ctx.fillStyle = fill; ctx.fillRect(X(a), box.y, X(b) - X(a), box.h); });
  o.hband = (a, b, fill) => o.clip(() => { ctx.fillStyle = fill; ctx.fillRect(box.x, Y(b), box.w, Y(a) - Y(b)); });
  o.rect = (x1, y1, x2, y2, fill, stroke, dash, lw = 1.4) => o.clip(() => {
    const px = X(Math.min(x1, x2)), py = Y(Math.max(y1, y2)), w = Math.abs(X(x2) - X(x1)), h = Math.abs(Y(y2) - Y(y1));
    if (fill) { ctx.fillStyle = fill; ctx.fillRect(px, py, w, h); }
    if (stroke) { ctx.strokeStyle = stroke; ctx.lineWidth = lw; ctx.setLineDash(dash || []); ctx.strokeRect(px, py, w, h); ctx.setLineDash([]); }
  });
  o.region = (f, g, a, b, fill, n = 300) => o.clip(() => {
    ctx.fillStyle = fill; ctx.beginPath();
    for (let i = 0; i <= n; i++) { const x = a + ((b - a) * i) / n; const py = Y(f(x)); i ? ctx.lineTo(X(x), py) : ctx.moveTo(X(x), py); }
    for (let i = n; i >= 0; i--) { const x = a + ((b - a) * i) / n; ctx.lineTo(X(x), Y(g(x))); }
    ctx.closePath(); ctx.fill();
  });
  o.vbrace = (x, y1, y2, color, label, side = 1) => {
    const px = X(x) + side * 6;
    ctx.strokeStyle = color; ctx.lineWidth = 1.4; ctx.setLineDash([]);
    ctx.beginPath(); ctx.moveTo(px - side * 4, Y(y1)); ctx.lineTo(px, Y(y1)); ctx.lineTo(px, Y(y2)); ctx.lineTo(px - side * 4, Y(y2)); ctx.stroke();
    if (label) { ctx.fillStyle = color; ctx.font = UI; ctx.textAlign = side > 0 ? "left" : "right"; ctx.textBaseline = "middle"; ctx.fillText(label, px + side * 5, (Y(y1) + Y(y2)) / 2); }
  };
  o.hbrace = (x1, x2, y, color, label, side = 1) => {
    const py = Y(y) + side * 8;
    ctx.strokeStyle = color; ctx.lineWidth = 1.4; ctx.setLineDash([]);
    ctx.beginPath(); ctx.moveTo(X(x1), py - side * 4); ctx.lineTo(X(x1), py); ctx.lineTo(X(x2), py); ctx.lineTo(X(x2), py - side * 4); ctx.stroke();
    if (label) { ctx.fillStyle = color; ctx.font = UI; ctx.textAlign = "center"; ctx.textBaseline = side > 0 ? "top" : "bottom"; ctx.fillText(label, (X(x1) + X(x2)) / 2, py + side * 4); }
  };
  return o;
}
function arrow(ctx, x1, y1, x2, y2, color, w = 1.3) {
  ctx.strokeStyle = color; ctx.fillStyle = color; ctx.lineWidth = w; ctx.setLineDash([]);
  ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
  const a = Math.atan2(y2 - y1, x2 - x1), h = 7;
  ctx.beginPath(); ctx.moveTo(x2, y2); ctx.lineTo(x2 - h * Math.cos(a - 0.4), y2 - h * Math.sin(a - 0.4)); ctx.lineTo(x2 - h * Math.cos(a + 0.4), y2 - h * Math.sin(a + 0.4)); ctx.closePath(); ctx.fill();
}
const full = (W, H, p) => ({ x: p.l, y: p.t, w: W - p.l - p.r, h: H - p.t - p.b });

/* ---------- registro: lee los controles, dibuja y llena la lectura ----------
   spec = { c: id del canvas, r: id de la lectura, aspect, range: {nombre: id}, radio: {nombre: name}, check: {nombre: id} } */
const LAST = {};
function viz(spec, draw) {
  const ids = (o) => Object.values(o || {});
  const fn = () => {
    readColors();
    const st = {};
    for (const [k, id] of Object.entries(spec.range || {})) { st[k] = PP.val(P + id); PP.out(P + id + "-o", fmt(st[k], 2)); }
    for (const [k, nm] of Object.entries(spec.radio || {})) st[k] = PP.radio(P + nm);
    for (const [k, id] of Object.entries(spec.check || {})) st[k] = document.getElementById(P + id).checked;
    const { ctx, w, h } = PP.canvas(P + spec.c, 1 / spec.aspect);
    ctx.lineCap = "round"; ctx.lineJoin = "round";
    const rows = draw(ctx, w, h, st) || [];
    if (spec.r) PP.read(P + spec.r, rows);
  };
  PP.register(fn, [...ids(spec.range).map((i) => "#" + P + i), ...ids(spec.radio).map((n) => `input[name="${P + n}"]`), ...ids(spec.check).map((i) => "#" + P + i)]);
  return fn;
}
/* Arrastre: pick(px, py) → true si agarra; move(x, y) en coordenadas del último plot guardado en LAST[key]. */
function draggable(cid, key, pick, move, redraw) {
  const cv = document.getElementById(P + cid);
  if (!cv) return;
  cv.style.cursor = "grab";
  let on = false;
  const pos = (e) => { const r = cv.getBoundingClientRect(); return [e.clientX - r.left, e.clientY - r.top]; };
  cv.addEventListener("pointerdown", (e) => {
    const T = LAST[key]; if (!T) return;
    const [px, py] = pos(e);
    if (pick(px, py, T)) { on = true; cv.setPointerCapture(e.pointerId); cv.style.cursor = "grabbing"; cv.style.touchAction = "none"; e.preventDefault(); }
  });
  cv.addEventListener("pointermove", (e) => {
    if (!on) return;
    const T = LAST[key]; const [px, py] = pos(e);
    move(T.iX(px), T.iY(py)); redraw();
  });
  const end = () => { on = false; cv.style.cursor = "grab"; cv.style.touchAction = ""; };
  cv.addEventListener("pointerup", end);
  cv.addEventListener("pointercancel", end);
}
const near = (T, x, y, px, py, r = 18) => Math.hypot(T.X(x) - px, T.Y(y) - py) <= r;
function setSlider(id, v) { const el = document.getElementById(P + id); el.value = String(clamp(v, +el.min, +el.max)); }

/* ===================== Bloque 1 ===================== */

/* 33: flechas de ℤ a ℕ. */
viz({ c: "33-c", r: "33-r", aspect: 1.9, radio: { m: "33-m" } }, (ctx, W, H, s) => {
  const top = H * 0.24, bot = H * 0.7, L = 30, R = W - 14;
  const zx = (n) => L + ((n + 4) / 8) * (R - L);
  const nx = (k) => L + (k / 16) * (R - L);
  ctx.font = '600 14px "IBM Plex Sans", sans-serif'; ctx.fillStyle = C.muted; ctx.textAlign = "left"; ctx.textBaseline = "middle";
  ctx.fillText("ℤ", 6, top); ctx.fillText("ℕ", 6, bot);
  const A = new Set([1, 3, 4]), B = new Set([1, 3, 4]);
  const img = s.m === "img";
  const hl = (n) => (img ? A.has(n) : B.has(n * n));
  const col = img ? C.accent : C.seq2;
  for (let n = -4; n <= 4; n++) if (!hl(n)) arrow(ctx, zx(n), top + 9, nx(n * n), bot - 10, C.rule, 1.1);
  for (let n = -4; n <= 4; n++) if (hl(n)) arrow(ctx, zx(n), top + 9, nx(n * n), bot - 10, col, 2);
  ctx.font = UI; ctx.textAlign = "center";
  for (let n = -4; n <= 4; n++) {
    ctx.beginPath(); ctx.arc(zx(n), top, hl(n) ? 6 : 4, 0, 7); ctx.fillStyle = hl(n) ? col : C.muted; ctx.fill();
    ctx.textBaseline = "bottom"; ctx.fillText(String(n).replace("-", "−"), zx(n), top - 9);
  }
  const imgSet = new Set([0, 1, 4, 9, 16]);
  for (let k = 0; k <= 16; k++) {
    let c = imgSet.has(k) ? C.muted : C.rule, r = imgSet.has(k) ? 4 : 3;
    if (img && [1, 9, 16].includes(k)) { c = C.accent; r = 6; }
    if (!img && B.has(k)) { c = k === 3 ? C.fail : C.seq2; r = 6; }
    ctx.beginPath(); ctx.arc(nx(k), bot, r, 0, 7); ctx.fillStyle = c; ctx.fill();
    ctx.fillStyle = r > 4 ? c : C.muted; ctx.textBaseline = "top"; ctx.fillText(String(k), nx(k), bot + 9);
  }
  if (!img) { ctx.fillStyle = C.fail; ctx.textBaseline = "top"; ctx.textAlign = "left"; ctx.fillText("3 ∉ img(f)", nx(3) - 6, bot + 26); }
  ctx.fillStyle = C.muted; ctx.font = UIs; ctx.textAlign = "right"; ctx.textBaseline = "top";
  ctx.fillText("gris claro: fuera de la imagen", R, bot + 26);
  return img
    ? [["A", "{1, 3, 4} ⊆ ℤ"], ["f(A)", "{1, 9, 16}"]]
    : [["B", "{1, 3, 4} ⊆ ℕ"], ["f⁻¹(B)", "{−2, −1, 1, 2}"], ["f⁻¹({3})", "∅", "bad"]];
});

/* ===================== Bloque 2 ===================== */

/* 34: ε–δ en ℝ y en un punto aislado. */
viz({ c: "34-c", r: "34-r", aspect: 1.35, range: { e: "34-e" }, radio: { m: "34-m" } }, (ctx, W, H, s) => {
  const e = s.e;
  if (s.m === "r") {
    const d = Math.sqrt(1 + e) - 1;
    const L = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [0, 2], [0, 3.2]);
    L.hband(1 - e, 1 + e, C.band); L.vband(1 - d, 1 + d, C.area2);
    L.axes({ xt: [[1, "x₀ = 1"], 2], yt: [1, 2, 3] });
    L.fn((x) => x * x, C.muted, 1.6);
    L.fn((x) => x * x, C.accent, 3, 1 - d, 1 + d, 80);
    L.dot(1, 1, C.accent, 4.5);
    L.text("f(x) = x²", 1.25, 2.6, C.muted, "right");
    L.text("1 ± ε", 0.04, 1 + e, C.accent, "left", "bottom", 4, -2);
    L.text("δ", 1 + d, 0.05, C.seq2, "left", "bottom", 4);
    return [["ε", fmt(e, 2)], ["δ = √(1+ε) − 1", fmt(d)], ["achicar ε", "obliga a achicar δ"]];
  }
  const f = [0, 1.2, 2.6, 0.9, 2.1, 1.6, 2.8];
  const R = plot(ctx, full(W, H, { l: 30, r: 14, t: 26, b: 26 }), [0.3, 6.7], [0, 3.4]);
  R.hband(f[3] - e, f[3] + e, C.band); R.vband(2.5, 3.5, C.area2);
  R.axes({ xt: [1, 2, 3, 4, 5, 6], yt: [1, 2, 3] });
  for (let n = 1; n <= 6; n++) R.dot(n, f[n], n === 3 ? C.accent : C.muted, n === 3 ? 5 : 4);
  R.text("B(3, 1/2) = {3}", 3, 3.4, C.seq2, "center", "bottom", 0, -4);
  R.text("f : ℕ → ℝ", 6.6, 0.12, C.muted, "right", "bottom");
  return [["ε", fmt(e, 2)], ["δ = 1/2", "sirve para todo ε", "good"], ["f(B(3, 1/2))", "{f(3)} ⊆ B(f(3), ε)"]];
});

/* ===================== Bloque 3 ===================== */

/* 36: corte de M₂(ℝ) con b = c = 1. */
const draw36 = viz({ c: "36-c", r: "36-r", aspect: 1.05, range: { a: "36-a", d: "36-d" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [-3.2, 3.2], [-3.2, 3.2]);
  LAST["36"] = T;
  T.axes({ xt: [-3, -2, -1, 1, 2, 3], yt: [-3, -2, -1, 1, 2, 3], xl: "a", yl: "d" });
  T.fn((t) => 1 / t, C.fail, 2, 0.001, 3.2, 500); T.fn((t) => 1 / t, C.fail, 2, -3.2, -0.001, 500);
  T.text("det = 0", 3.1, 1 / 3.1 + 0.15, C.fail, "right", "bottom");
  const a = s.a, d = s.d, det = a * d - 1;
  let r = Infinity;
  for (let i = 0; i <= 6000; i++) {
    const t = Math.pow(10, -3 + (6 * i) / 6000);
    r = Math.min(r, Math.max(Math.abs(a - t), Math.abs(d - 1 / t)), Math.max(Math.abs(a + t), Math.abs(d + 1 / t)));
  }
  const inGL = Math.abs(det) > 1e-9 && r > 0.004;
  if (inGL) T.rect(a - r, d - r, a + r, d + r, C.band, C.accent, [5, 4]);
  T.dot(a, d, inGL ? C.accent : C.fail, 6);
  T.text("A", a, d, inGL ? C.accent : C.fail, "left", "bottom", 7, -4);
  return [["A", `(${fmt(a, 2)} 1; 1 ${fmt(d, 2)})`], ["det A = ad − 1", fmt(det)], inGL ? ["radio que entra en el corte", "≈ " + fmt(r), "good"] : ["A", "singular: no está en Gl₂", "bad"]];
});
draggable("36-c", "36", (px, py, T) => near(T, PP.val(P + "36-a"), PP.val(P + "36-d"), px, py, 22),
  (x, y) => { setSlider("36-a", Math.round(x * 20) / 20); setSlider("36-d", Math.round(y * 20) / 20); }, draw36);

/* C9-1.1: f, g y f + g evaluadas en xₙ → x. */
viz({ c: "c9-1-1-c", r: "c9-1-1-r", aspect: 1.3, range: { n: "c9-1-1-n" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [-0.4, 3], [-1.3, 2.6]);
  T.axes({ xt: [[1.2, "x"], 2, 3], yt: [-1, 1, 2] });
  const f = Math.sin, g = (x) => 0.4 * x, h = (x) => f(x) + g(x);
  const x = 1.2, xn = (k) => x + (1.2 * (k % 2 ? -1 : 1)) / k;
  T.fn(f, C.accent, 2); T.fn(g, C.seq2, 2); T.fn(h, C.ink, 2.2);
  T.text("f", 2.9, f(2.9), C.accent, "right", "top", 0, 4); T.text("g", 2.9, g(2.9), C.seq2, "right", "top", 0, 4); T.text("f + g", 2.9, h(2.9), C.ink, "right", "bottom", 0, -4);
  for (let k = 1; k < s.n; k++) T.dot(xn(k), h(xn(k)), C.rule, 2.5);
  const v = xn(s.n);
  T.seg(v, -1.3, v, 2.6, C.muted, 1, [3, 3]); T.seg(x, -1.3, x, 2.6, C.muted, 1, [1, 3]);
  for (const [fn, c] of [[f, C.accent], [g, C.seq2], [h, C.ink]]) { T.dot(x, fn(x), c, 4.5, true); T.dot(v, fn(v), c, 4); }
  T.text("xₙ", v, -1.3, C.muted, "center", "bottom", 0, -2);
  return [["|xₙ − x|", fmt(Math.abs(v - x))], ["|(f+g)(xₙ) − (f+g)(x)|", fmt(Math.abs(h(v) - h(x)))], ["|(f·g)(xₙ) − (f·g)(x)|", fmt(Math.abs(f(v) * g(v) - f(x) * g(x)))]];
});

/* C9-1.2: |x¹ₖ − x¹| ≤ d∞. */
viz({ c: "c9-1-2-c", r: "c9-1-2-r", aspect: 1.15, range: { k: "c9-1-2-k" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 30 }), [0, 3.1], [0, 2.6]);
  const p = [1.5, 1.2], xk = (k) => [p[0] + (1.1 * Math.cos(2.3 * k)) / k, p[1] + (0.9 * Math.sin(1.7 * k)) / k];
  const q = xk(s.k), dk = Math.max(Math.abs(q[0] - p[0]), Math.abs(q[1] - p[1]));
  T.rect(p[0] - dk, p[1] - dk, p[0] + dk, p[1] + dk, C.band, C.accent, [5, 4]);
  T.axes({ xt: [[p[0], "x¹"]], yt: [[p[1], "x²"]] });
  T.seg(p[0] - dk, p[1] - dk, p[0] - dk, 0, C.accent, 1, [2, 3]); T.seg(p[0] + dk, p[1] - dk, p[0] + dk, 0, C.accent, 1, [2, 3]);
  T.seg(p[0] - dk, 0, p[0] + dk, 0, C.accent, 5);
  T.seg(p[0], 0, q[0], 0, C.seq2, 5);
  T.seg(q[0], q[1], q[0], 0, C.seq2, 1, [3, 3]);
  for (let j = 1; j < s.k; j++) { const r = xk(j); T.dot(r[0], r[1], C.rule, 2.5); }
  T.dot(p[0], p[1], C.ink, 4.5, true); T.dot(q[0], q[1], C.seq2, 5);
  T.text("xₖ", q[0], q[1], C.seq2, "left", "bottom", 6, -3);
  return [["|x¹ₖ − x¹|", fmt(Math.abs(q[0] - p[0]))], ["d∞(xₖ, x)", fmt(dk)], ["|x¹ₖ − x¹| ≤ d∞", "sí", "good"]];
});

/* C9-1.6: árbol de x²y + 3y − 2. */
viz({ c: "c9-1-6-c", r: "c9-1-6-r", aspect: 1.35, range: { st: "c9-1-6-s" } }, (ctx, W, H, s) => {
  const N = {
    r: { p: [0.5, 0.1], t: "+", lv: 3, e: "P" },
    A: { p: [0.27, 0.38], t: "×", lv: 2, e: "x²y", par: "r" },
    B: { p: [0.74, 0.38], t: "+", lv: 2, e: "3y − 2", par: "r" },
    A1: { p: [0.15, 0.64], t: "×", lv: 1, e: "x²", par: "A" },
    A2: { p: [0.4, 0.64], t: "π₂", lv: 0, e: "y", par: "A" },
    a1: { p: [0.06, 0.88], t: "π₁", lv: 0, e: "x", par: "A1" },
    a2: { p: [0.25, 0.88], t: "π₁", lv: 0, e: "x", par: "A1" },
    B1: { p: [0.64, 0.64], t: "×", lv: 1, e: "3y", par: "B" },
    B2: { p: [0.9, 0.64], t: "−2", lv: 0, e: "cte.", par: "B" },
    b1: { p: [0.55, 0.88], t: "3", lv: 0, e: "cte.", par: "B1" },
    b2: { p: [0.74, 0.88], t: "π₂", lv: 0, e: "y", par: "B1" },
  };
  const rad = clamp(W / 26, 11, 17);
  const px = ([u, v]) => [rad + 4 + u * (W - 2 * rad - 8), 16 + v * (H - 46)];
  for (const k in N) if (N[k].par) {
    const [x1, y1] = px(N[k].p), [x2, y2] = px(N[N[k].par].p);
    ctx.strokeStyle = N[k].lv < s.st ? C.ok : C.rule; ctx.lineWidth = 1.6; ctx.setLineDash([]); ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
  }
  for (const k in N) {
    const n = N[k], [x, y] = px(n.p), on = n.lv <= s.st;
    ctx.beginPath(); ctx.arc(x, y, rad, 0, 7); ctx.fillStyle = on ? C.okband : C.bg; ctx.fill();
    ctx.strokeStyle = on ? C.ok : C.rule; ctx.lineWidth = 1.6; ctx.stroke();
    ctx.fillStyle = on ? C.ok : C.muted; ctx.font = '600 13px "IBM Plex Sans", sans-serif'; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(n.t, x, y);
    ctx.font = UIs; ctx.fillStyle = C.muted; ctx.textBaseline = "top"; ctx.fillText(n.e, x, y + rad + 3);
  }
  const msg = [
    "hojas: proyecciones (Lema 1.2) y constantes",
    "x² = π₁·π₁ y 3y = 3·π₂ (Prop. 1.1, producto)",
    "x²y (producto) y 3y − 2 (suma)",
    "P = x²y + 3y − 2 es suma de continuas",
  ][s.st];
  return [["continuas", msg, s.st === 3 ? "good" : ""]];
});

/* C9-2.1, enunciado: el dibujo de la clase, con un punto para arrastrar. */
const phi = (x) => x * x * x - x * x + x;
let q921 = [-0.6, 2.6];
const draw921 = viz({ c: "c9-2-1-c1", r: "c9-2-1-r1", aspect: 1.1 }, (ctx, W, H) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 12, t: 14, b: 26 }), [-1.2, 1.8], [-4.5, 4.5]);
  LAST["921"] = T;
  T.region(phi, () => -10, -1.2, 1.8, C.band);
  T.axes({ xt: [-1, 1], yt: [-4, -2, 2, 4], xl: "x", yl: "y" });
  T.fn(phi, C.accent, 2.4, -1.2, 1.8);
  T.text("y = x³ − x² + x", 1.45, phi(1.45), C.accent, "right", "bottom", -6, 0);
  T.text("A = {f ≥ 0}", 1.1, -2.5, C.accent, "center", "middle", 0, 0, '600 13px "IBM Plex Sans", sans-serif');
  T.text("{f < 0}", -0.6, 3.3, C.fail, "center", "middle", 0, 0, '600 13px "IBM Plex Sans", sans-serif');
  const [x, y] = q921, v = phi(x) - y;
  T.dot(x, y, v >= 0 ? C.accent : C.fail, 6);
  T.text("q", x, y, v >= 0 ? C.accent : C.fail, "left", "bottom", 7, -4);
  return [["q", `(${fmt(x, 2)}, ${fmt(y, 2)})`], ["f(q) = x³ − x² + x − y", fmt(v, 3)], ["q ∈ A", v >= 0 ? "sí" : "no", v >= 0 ? "good" : "bad"]];
});
draggable("c9-2-1-c1", "921", (px, py, T) => near(T, q921[0], q921[1], px, py, 24),
  (x, y) => { q921 = [clamp(x, -1.2, 1.8), clamp(y, -4.5, 4.5)]; }, draw921);

/* C9-2.1, resolución: una sucesión de A que converge al borde. */
viz({ c: "c9-2-1-c2", r: "c9-2-1-r2", aspect: 1.15, range: { n: "c9-2-1-n" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [-1.2, 1.8], [-4.5, 4.5]);
  T.region(phi, () => -10, -1.2, 1.8, C.band);
  T.axes({ xt: [-1, 1], yt: [-4, -2, 2, 4] });
  T.fn(phi, C.accent, 2.2, -1.2, 1.8);
  T.text("A", -1.0, -3.6, C.accent, "left", "bottom");
  const pn = (k) => { const x = 1 + (0.6 * Math.cos(k)) / k; return [x, phi(x) - 1.2 / k]; };
  for (let j = 1; j < s.n; j++) { const q = pn(j); T.dot(q[0], q[1], C.rule, 2.5); }
  const q = pn(s.n);
  T.dot(1, 1, C.ok, 5, true); T.dot(q[0], q[1], C.seq2, 5);
  T.text("pₙ", q[0], q[1], C.seq2, "right", "top", -6, 3); T.text("(1, 1)", 1, 1, C.ok, "right", "bottom", -8, -4);
  return [["f(pₙ)", fmt(phi(q[0]) - q[1]) + " ≥ 0", "good"], ["f(1, 1)", "0 ≥ 0: el límite está en A", "good"]];
});

/* C9-2.2: determinantes de matrices sorteadas en B∞(A, r). */
const A3 = [[2, 1, 0], [0, 1, 1], [1, 0, 1]];
const det3 = (m) => m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1]) - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
const U3 = (() => { const rnd = mulberry(7); return Array.from({ length: 400 }, () => ({ u: Array.from({ length: 9 }, () => 2 * rnd() - 1), j: rnd() })); })();
viz({ c: "c9-2-2-c", r: "c9-2-2-r", aspect: 1.8, range: { r: "c9-2-2-rr" } }, (ctx, W, H, s) => {
  const dets = U3.map(({ u, j }) => ({ d: det3(A3.map((row, i) => row.map((v, k) => v + s.r * u[3 * i + k]))), j }));
  const lo = Math.min(-1, ...dets.map((o) => o.d)), hi = Math.max(5, ...dets.map((o) => o.d));
  const T = plot(ctx, full(W, H, { l: 16, r: 16, t: 26, b: 28 }), [lo - 0.3, hi + 0.3], [0, 1]);
  const neg = dets.filter((o) => o.d <= 0).length;
  T.vband(lo - 1, 0, C.failband);
  T.seg(0, 0, 0, 1, C.fail, 2); T.seg(3, 0, 3, 1, C.accent, 1.4, [4, 3]);
  for (const o of dets) T.dot(o.d, 0.12 + 0.76 * o.j, o.d <= 0 ? C.fail : C.accent, 2.6);
  T.text("det = 0", 0, 1, C.fail, "center", "bottom", 0, -4); T.text("det A = 3", 3, 1, C.accent, "center", "bottom", 0, -4);
  const ticks = []; for (let t = Math.ceil(lo); t <= hi; t += Math.max(1, Math.round((hi - lo) / 7))) ticks.push(t);
  T.axes({ xt: ticks });
  const mn = Math.min(...dets.map((o) => o.d)), mx = Math.max(...dets.map((o) => o.d));
  return [["det en la muestra", `[${fmt(mn, 2)}, ${fmt(mx, 2)}]`], ["con det ≤ 0", neg ? `${neg} de 400` : "ninguna", neg ? "bad" : "good"]];
});

/* ===================== Bloque 4 ===================== */

/* C6-1, Paso 1: la bola de d∞ y su sombra (el dibujo cetz del apunte). */
let p61 = [2.5, 2.3];
const draw61b = viz({ c: "c6-1-c1", r: "c6-1-r1", aspect: 1.1, range: { r: "c6-1-r" }, check: { disc: "c6-1-disco" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 24, r: 12, t: 12, b: 34 }), [0, 5], [-0.2, 4.6]);
  LAST["61"] = T;
  const p = p61, r = s.r;
  T.rect(p[0] - r, p[1] - r, p[0] + r, p[1] + r, C.band, C.accent, [5, 4]);
  if (s.disc) T.clip(() => { ctx.beginPath(); ctx.arc(T.X(p[0]), T.Y(p[1]), T.X(p[0] + r) - T.X(p[0]), 0, 7); ctx.strokeStyle = C.muted; ctx.setLineDash([2, 3]); ctx.lineWidth = 1.2; ctx.stroke(); ctx.setLineDash([]); });
  T.axes({ xt: [[p[0] - r, "x_p − r"], [p[0], "x_p"], [p[0] + r, "x_p + r"]], xl: "X", yl: "Y" });
  T.seg(p[0] - r, p[1] - r, p[0] - r, 0, C.muted, 1, [2, 3]); T.seg(p[0] + r, p[1] - r, p[0] + r, 0, C.muted, 1, [2, 3]);
  T.seg(p[0] - r, 0, p[0] + r, 0, C.ok, 5);
  T.dot(p[0] - r, 0, C.ok, 4.5, true); T.dot(p[0] + r, 0, C.ok, 4.5, true);
  T.seg(p[0], p[1], p[0] + r, p[1], C.accent, 1.2);
  T.text("r", p[0] + r / 2, p[1], C.accent, "center", "top", 0, 3);
  T.dot(p[0], p[1], C.ink, 5); T.text("p", p[0], p[1], C.ink, "left", "bottom", 5, -4);
  T.text("B(p, r)", p[0] + r, p[1] + r, C.accent, "right", "bottom", 0, -3);
  T.text("π₁(B) = B(x_p, r)", p[0], 0, C.ok, "center", "bottom", 0, -9);
  return [["p", `(${fmt(p[0], 2)}, ${fmt(p[1], 2)})`], ["π₁(B(p, r))", `(${fmt(p[0] - r, 2)}, ${fmt(p[0] + r, 2)})`], ["es una bola de X", "abierta", "good"]];
});
draggable("c6-1-c1", "61", (px, py, T) => near(T, p61[0], p61[1], px, py, 24),
  (x, y) => { p61 = [clamp(Math.round(x * 20) / 20, 0.3, 4.7), clamp(Math.round(y * 20) / 20, 0.4, 4.2)]; }, draw61b);

/* C6-1, Paso 2: un abierto U cubierto por bolas; la unión de las sombras es π₁(U). */
const E61 = { cx: 2.5, cy: 2.3, ax: 1.7, ay: 1.2 };
const inE = (x, y) => ((x - E61.cx) / E61.ax) ** 2 + ((y - E61.cy) / E61.ay) ** 2 < 1;
const PTS61 = (() => {
  const rnd = mulberry(11), out = [];
  while (out.length < 60) {
    const x = E61.cx + E61.ax * (2 * rnd() - 1), y = E61.cy + E61.ay * (2 * rnd() - 1);
    if (!inE(x, y)) continue;
    let lo = 0, hi = 2;
    for (let i = 0; i < 30; i++) { const m = (lo + hi) / 2; if (inE(x - m, y - m) && inE(x + m, y - m) && inE(x - m, y + m) && inE(x + m, y + m)) lo = m; else hi = m; }
    out.push([x, y, lo * 0.98]);
  }
  return out;
})();
viz({ c: "c6-1-c2", r: "c6-1-r2", aspect: 1.1, range: { k: "c6-1-k" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 24, r: 12, t: 12, b: 34 }), [0, 5], [-0.2, 4.6]);
  T.clip(() => { ctx.beginPath(); ctx.ellipse(T.X(E61.cx), T.Y(E61.cy), T.X(E61.cx + E61.ax) - T.X(E61.cx), T.Y(E61.cy) - T.Y(E61.cy + E61.ay), 0, 0, 7); ctx.fillStyle = C.area3; ctx.fill(); ctx.strokeStyle = C.seq3; ctx.setLineDash([5, 4]); ctx.lineWidth = 1.4; ctx.stroke(); ctx.setLineDash([]); });
  T.axes({ xt: [[E61.cx - E61.ax, fmt(E61.cx - E61.ax, 2)], [E61.cx + E61.ax, fmt(E61.cx + E61.ax, 2)]], xl: "X", yl: "Y" });
  T.text("U", E61.cx + E61.ax * 0.75, E61.cy + E61.ay * 0.9, C.seq3, "left", "bottom");
  const pts = PTS61.slice(0, s.k), iv = [];
  for (const [x, y, r] of pts) { T.rect(x - r, y - r, x + r, y + r, null, C.accent, [], 1); T.dot(x, y, C.accent, 2); iv.push([x - r, x + r]); }
  iv.sort((a, b) => a[0] - b[0]);
  const U = [];
  for (const [a, b] of iv) { if (U.length && a <= U[U.length - 1][1]) U[U.length - 1][1] = Math.max(U[U.length - 1][1], b); else U.push([a, b]); }
  for (const [a, b] of U) { T.seg(a, 0, b, 0, C.ok, 5); T.dot(a, 0, C.ok, 3.5, true); T.dot(b, 0, C.ok, 3.5, true); }
  T.text("π₁(U)", E61.cx, 0, C.seq3, "center", "bottom", 0, -10);
  const len = U.reduce((t, [a, b]) => t + b - a, 0);
  return [["bolas dibujadas", String(s.k)], ["unión de las sombras", U.map(([a, b]) => `(${fmt(a, 2)}, ${fmt(b, 2)})`).join(" ∪ ")], ["cubre de π₁(U)", fmt((100 * len) / (2 * E61.ax), 1) + " %"]];
});

/* C6-1, π₁ no es cerrada: la hipérbola. */
viz({ c: "c6-1-c3", r: "c6-1-r3", aspect: 1.1, range: { n: "c6-1-n" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [-4, 4], [-4, 4.4]);
  T.axes({ xt: [-3, -1, 1, 3], yt: [-3, -1, 1, 3] });
  T.seg(-4, 0, 4, 0, C.ok, 4); T.dot(0, 0, C.ok, 5, true);
  T.fn((t) => 1 / t, C.accent, 2.2, 0.001, 4, 500); T.fn((t) => 1 / t, C.accent, 2.2, -4, -0.001, 500);
  T.text("F: xy = 1", 3.9, 0.35, C.accent, "right", "bottom");
  for (let k = 1; k <= s.n; k++) {
    const on = k === s.n;
    T.dot(1 / k, k, on ? C.seq2 : C.rule, on ? 5 : 3);
    T.dot(1 / k, 0, on ? C.seq2 : C.rule, on ? 4 : 2.5);
    if (on) T.seg(1 / k, Math.min(k, 4.4), 1 / k, 0, C.seq2, 1, [3, 3]);
  }
  if (s.n > 4) T.text(`(1/${s.n}, ${s.n}) ↑ fuera del dibujo`, 0.3, 4.3, C.seq2, "left", "top");
  return [["xₙ = 1/n ∈ π₁(F)", fmt(1 / s.n)], ["segunda coordenada", String(s.n) + " → ∞"], ["lím xₙ = 0", "∉ π₁(F) = ℝ ∖ {0}", "bad"]];
});

/* ===================== Bloque 5 ===================== */

/* C6-2: x³ en (0, 1), secante, tangente paralela y cono ±3. */
viz({ c: "c6-2-c", r: "c6-2-r", aspect: 1.15, range: { x: "c6-2-x", y: "c6-2-y" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 34, r: 14, t: 14, b: 26 }), [0, 1], [-0.15, 1.05]);
  const f = (t) => t * t * t, x = Math.min(s.x, s.y), y = Math.max(s.x, s.y);
  T.region((t) => f(x) + 3 * Math.abs(t - x), (t) => f(x) - 3 * Math.abs(t - x), 0, 1, C.band);
  T.axes({ xt: [0.5, 1], yt: [0.5, 1] });
  T.fn((t) => f(x) + 3 * (t - x), C.accent, 1, 0, 1, 2, [3, 3]); T.fn((t) => f(x) - 3 * (t - x), C.accent, 1, 0, 1, 2, [3, 3]);
  T.fn(f, C.ink, 2.2, 0, 1);
  const out = [];
  if (y - x > 1e-6) {
    const m = (f(y) - f(x)) / (y - x), c = Math.sqrt(m / 3);
    T.fn((t) => f(x) + m * (t - x), C.seq2, 1.8, 0, 1, 2);
    T.fn((t) => f(c) + m * (t - c), C.accent, 1.5, 0, 1, 2, [6, 4]);
    T.dot(c, f(c), C.accent, 4.5); T.text("c", c, f(c), C.accent, "left", "top", 5, 2);
    out.push(["pendiente de la secante", fmt(m) + " = 3c²"], ["c", fmt(c)], ["3c² ≤ 3", "sí", "good"]);
  } else out.push(["x = y", "mové uno de los dos"]);
  T.dot(x, f(x), C.seq2, 5); T.dot(y, f(y), C.seq2, 5);
  T.text("cono ±3", 0.02, 1.0, C.accent, "left", "top");
  return out;
});

/* C6-3 a): |x sin(1/x)| ≤ |x|; con δ = ε el tramo entra en la banda. */
const xs1x = (x) => (x === 0 ? 0 : x * Math.sin(1 / x));
viz({ c: "c6-3-c1", r: "c6-3-r1", aspect: 1.15, range: { e: "c6-3-e" } }, (ctx, W, H, s) => {
  const e = s.e;
  const T = plot(ctx, full(W, H, { l: 34, r: 14, t: 14, b: 26 }), [-0.75, 0.75], [-0.75, 0.75]);
  T.hband(-e, e, C.band); T.vband(-e, e, C.area2);
  T.axes({ xt: [[-e, "−δ"], [e, "δ"]], yt: [[e, "ε"], [-e, "−ε"]] });
  T.fn((x) => x, C.muted, 1, -0.75, 0.75, 2, [3, 3]); T.fn((x) => -x, C.muted, 1, -0.75, 0.75, 2, [3, 3]);
  T.fn(xs1x, C.muted, 1.3, -0.75, 0.75, 4000);
  T.fn(xs1x, C.accent, 2.2, -e, e, 4000);
  T.dot(0, 0, C.accent, 4);
  let mx = 0; for (let i = 1; i <= 4000; i++) { const x = (e * i) / 4000; mx = Math.max(mx, Math.abs(xs1x(x))); }
  return [["δ = ε", fmt(e, 2)], ["máx |f| en (−δ, δ)", fmt(mx) + " < ε", "good"]];
});

/* C6-3 b): crestas y valles hacia el 0. */
viz({ c: "c6-3-c2", r: "c6-3-r2", aspect: 1.15, range: { n: "c6-3-n" } }, (ctx, W, H, s) => {
  const n = s.n, xn = 1 / (Math.PI / 2 + 2 * Math.PI * n), yn = 1 / ((3 * Math.PI) / 2 + 2 * Math.PI * n);
  const T = plot(ctx, full(W, H, { l: 50, r: 14, t: 14, b: 26 }), [-0.25 * xn, 1.6 * xn], [-1.3 * xn, 1.3 * xn]);
  T.axes({ xt: [[xn, "xₙ"], [yn, "yₙ"]], yt: [[xn, fmt(xn, 4)], [-xn, fmt(-xn, 4)]] });
  T.fn((x) => x, C.muted, 1, T.xr[0], T.xr[1], 2, [3, 3]); T.fn((x) => -x, C.muted, 1, T.xr[0], T.xr[1], 2, [3, 3]);
  T.fn(xs1x, C.accent, 1.8, 1e-7, T.xr[1], 2500); T.fn(xs1x, C.accent, 1.8, T.xr[0], -1e-7, 600);
  T.seg(yn, -yn, xn, xn, C.fail, 2);
  T.dot(xn, xn, C.seq2, 5); T.dot(yn, -yn, C.seq2, 5);
  const slope = (xs1x(xn) - xs1x(yn)) / (xn - yn);
  return [["Mₙ = 2 + 4n", String(2 + 4 * n)], ["|f(xₙ) − f(yₙ)| / |xₙ − yₙ|", fmt(slope)], ["|xₙ − yₙ|", fmt(xn - yn, 5)]];
});

/* C6-4: Ψ con un pico. */
viz({ c: "c6-4-c", r: "c6-4-r", aspect: 1.1, range: { p: "c6-4-p" } }, (ctx, W, H, s) => {
  const f = (x) => 0.45 + 0.18 * Math.sin(2 * Math.PI * x + 0.5);
  const b = (x) => 0.5 * Math.max(0, 1 - Math.abs(x - s.p) / 0.08);
  const g = (x) => f(x) + b(x);
  const half = (H - 30) / 2;
  const T = plot(ctx, { x: 34, y: 12, w: W - 48, h: half - 14 }, [0, 1], [0, 1.25]);
  T.axes({ xt: [], yt: [0.5, 1] });
  T.fn(f, C.accent, 2); T.fn(g, C.seq2, 2);
  T.text("f", 0.02, f(0.02), C.accent, "left", "bottom", 0, -4); T.text("g", s.p, g(s.p), C.seq2, s.p > 0.85 ? "right" : "left", "bottom", s.p > 0.85 ? -6 : 6, 0);
  const B = plot(ctx, { x: 34, y: half + 14, w: W - 48, h: half - 4 }, [0, 1], [0, 0.6]);
  B.region(b, () => 0, 0, 1, C.area2, 500);
  B.region((x) => x * b(x), () => 0, 0, 1, C.area, 500);
  B.axes({ xt: [0.5, 1], yt: [[0.5, "d∞"]] });
  B.seg(0, 0.5, 1, 0.5, C.ink, 1.2, [5, 4]);
  B.fn(b, C.seq2, 1.4, 0, 1, 500); B.fn((x) => x * b(x), C.accent, 1.6, 0, 1, 500);
  B.text("|f − g|", 0.99, 0.6, C.seq2, "right", "top"); B.text("x·|f − g|", 0.99, 0.47, C.accent, "right", "top");
  let i1 = 0, i2 = 0; const N = 2000;
  for (let i = 0; i < N; i++) { const x = (i + 0.5) / N; i1 += b(x) / N; i2 += (x * b(x)) / N; }
  return [["d∞(f, g)", "0.5"], ["∫|f − g|", fmt(i1, 4)], ["d₁(Ψf, Ψg) = ∫x|f − g|", fmt(i2, 4) + " ≤ 0.5", "good"]];
});

/* 39 a): cos y el cono ±1. */
viz({ c: "39-c1", r: "39-r1", aspect: 1.3, range: { x: "39-x", y: "39-y" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [0, 6.3], [-1.5, 1.5]);
  const x = s.x, y = s.y;
  T.region((t) => Math.cos(x) + Math.abs(t - x), (t) => Math.cos(x) - Math.abs(t - x), 0, 6.3, C.band);
  T.text("cono ±1", 6.25, 1.45, C.accent, "right", "top");
  T.axes({ xt: [1, 2, 3, 4, 5, 6], yt: [-1, 1] });
  T.fn(Math.cos, C.ink, 2.2, 0, 6.3, 600);
  const out = [];
  if (Math.abs(x - y) > 1e-6) {
    const m = (Math.cos(y) - Math.cos(x)) / (y - x);
    T.fn((t) => Math.cos(x) + m * (t - x), C.seq2, 1.8, 0, 6.3, 2);
    out.push(["|pendiente de la secante|", fmt(Math.abs(m))], ["≤ 1", "sí", "good"]);
  } else out.push(["x = y", "mové uno de los dos"]);
  T.dot(x, Math.cos(x), C.seq2, 5); T.dot(y, Math.cos(y), C.seq2, 5);
  return out;
});

/* 39 b): √x, pendientes cerca del 0. */
viz({ c: "39-c2", r: "39-r2", aspect: 1.3, range: { x: "39-u", y: "39-v" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [0, 4.2], [-0.1, 2.3]);
  const x = s.x, y = s.y;
  T.vband(1, 5, C.okband); T.text("[1, ∞): pendientes ≤ 1/2", 4.15, 0.05, C.ok, "right", "bottom");
  T.axes({ xt: [1, 2, 3, 4], yt: [1, 2] });
  T.fn(Math.sqrt, C.ink, 2.2, 0, 4.2, 800);
  const out = [];
  if (Math.abs(x - y) > 1e-6) {
    const m = (Math.sqrt(y) - Math.sqrt(x)) / (y - x);
    T.fn((t) => Math.sqrt(x) + m * (t - x), C.seq2, 1.8, 0, 4.2, 2);
    out.push(["pendiente = 1/(√x + √y)", fmt(m)]);
    out.push(Math.min(x, y) >= 1 ? ["x, y ≥ 1: ≤ 1/2", "sí", "good"] : ["cerca del 0", "sin cota: crece sin límite", "bad"]);
  } else out.push(["x = y", "mové uno de los dos"]);
  T.dot(x, Math.sqrt(x), C.seq2, 5); T.dot(y, Math.sqrt(y), C.seq2, 5);
  return out;
});

/* 39 c): la integral, |F(f)(x) − F(g)(x)| ≤ x·d∞(f, g). */
viz({ c: "39-c3", r: "39-r3", aspect: 1.05, range: { x: "39-t" } }, (ctx, W, H, s) => {
  const f = (t) => 0.55 + 0.35 * Math.sin(6 * t), g = (t) => 0.35 + 0.5 * t * t;
  const N = 400, Ff = [0], Fg = [0];
  let dinf = 0;
  for (let i = 0; i <= N; i++) dinf = Math.max(dinf, Math.abs(f(i / N) - g(i / N)));
  for (let i = 1; i <= N; i++) { const a = (i - 1) / N, b = i / N; Ff.push(Ff[i - 1] + (f(a) + f(b)) / (2 * N)); Fg.push(Fg[i - 1] + (g(a) + g(b)) / (2 * N)); }
  const at = (arr, x) => arr[Math.round(clamp(x, 0, 1) * N)];
  const half = (H - 30) / 2;
  const T = plot(ctx, { x: 34, y: 12, w: W - 48, h: half - 14 }, [0, 1], [0, 1.1]);
  T.axes({ xt: [], yt: [0.5, 1] });
  T.fn(f, C.accent, 2, 0, 1); T.fn(g, C.seq2, 2, 0, 1);
  T.text("f", 0.02, f(0.02), C.accent, "left", "bottom", 0, -4); T.text("g", 0.98, g(0.98), C.seq2, "right", "top", 0, 4);
  const x = s.x;
  T.seg(x, 0, x, 1.1, C.muted, 1, [3, 3]);
  const B = plot(ctx, { x: 34, y: half + 14, w: W - 48, h: half - 4 }, [0, 1], [0, 0.65]);
  B.fn((t) => at(Ff, t), C.accent, 2, 0, 1, 200); B.fn((t) => at(Fg, t), C.seq2, 2, 0, 1, 200);
  B.fn((t) => t * dinf, C.ink, 1.2, 0, 1, 2, [5, 4]);
  B.axes({ xt: [0.5, 1], yt: [[dinf, "d∞"]] });
  B.text("F(f)", 0.99, at(Ff, 0.99), C.accent, "right", "bottom", 0, -3); B.text("F(g)", 0.99, at(Fg, 0.99), C.seq2, "right", "top", 0, 3);
  B.text("punteada: x·d∞(f, g)", 0.02, 0.65, C.ink, "left", "top");
  const gap = Math.abs(at(Ff, x) - at(Fg, x));
  B.seg(x, at(Ff, x), x, at(Fg, x), C.fail, 3);
  B.dot(x, at(Ff, x), C.accent, 4); B.dot(x, at(Fg, x), C.seq2, 4);
  return [["d∞(f, g)", fmt(dinf)], ["|F(f)(x) − F(g)(x)|", fmt(gap)], ["≤ x·d∞(f, g)", fmt(x * dinf), "good"]];
});

/* ===================== Bloque 6 ===================== */

/* C6-5: el par (n, n + 1/n) para x² y para sin. */
viz({ c: "c6-5-c", r: "c6-5-r", aspect: 1.2, range: { n: "c6-5-n" }, radio: { m: "c6-5-m" } }, (ctx, W, H, s) => {
  const n = s.n, xn = n, yn = n + 1 / n, sq = s.m === "sq";
  const f = sq ? (x) => x * x : Math.sin;
  const xr = [n - 1, n + 1.6], yr = sq ? [Math.max(0, (n - 1) ** 2) - 0.5, (n + 1.6) ** 2 + 0.5] : [-1.4, 1.4];
  const T = plot(ctx, full(W, H, { l: 40, r: 64, t: 14, b: 26 }), xr, yr);
  T.axes({ xt: [[xn, "n"], [yn, "n + 1/n"]], yt: sq ? [[f(xn), fmt(f(xn), 1)], [f(yn), fmt(f(yn), 1)]] : [-1, 1] });
  T.fn(f, C.ink, 2.2);
  T.seg(xn, f(xn), xn, yr[0], C.muted, 1, [3, 3]); T.seg(yn, f(yn), yn, yr[0], C.muted, 1, [3, 3]);
  T.seg(xn, f(xn), yn + 0.15, f(xn), C.muted, 1, [3, 3]); T.seg(yn, f(yn), yn + 0.15, f(yn), C.muted, 1, [3, 3]);
  const gap = Math.abs(f(yn) - f(xn));
  T.vbrace(yn + 0.15, f(xn), f(yn), sq ? C.fail : C.ok, fmt(gap, 2));
  T.dot(xn, f(xn), C.seq2, 5); T.dot(yn, f(yn), C.seq2, 5);
  return [["|xₙ − yₙ| = 1/n", fmt(1 / n)], ["|f(xₙ) − f(yₙ)|", sq ? fmt(gap) + " > 2" : fmt(gap) + " ≤ 1/n", sq ? "bad" : "good"]];
});

/* C6-6: x sin x en xₙ = π + 2πn. */
viz({ c: "c6-6-c", r: "c6-6-r", aspect: 1.2, range: { n: "c6-6-n" } }, (ctx, W, H, s) => {
  const n = s.n, xn = Math.PI + 2 * Math.PI * n, yn = xn + 1 / n, f = (x) => x * Math.sin(x);
  const T = plot(ctx, full(W, H, { l: 40, r: 58, t: 14, b: 26 }), [xn - 3, xn + 3], [-(xn + 4), xn + 4]);
  T.axes({ xt: [[xn, "xₙ"]], yt: [[xn, fmt(xn, 1)], [-xn, fmt(-xn, 1)]] });
  T.fn((x) => x, C.muted, 1, T.xr[0], T.xr[1], 2, [3, 3]); T.fn((x) => -x, C.muted, 1, T.xr[0], T.xr[1], 2, [3, 3]);
  T.fn(f, C.ink, 2.2);
  T.seg(xn, f(xn), xn + 3, f(xn), C.muted, 1, [3, 3]); T.seg(yn, f(yn), xn + 3, f(yn), C.muted, 1, [3, 3]);
  const gap = Math.abs(f(yn) - f(xn));
  T.vbrace(xn + 2.98, f(xn), f(yn), C.fail, fmt(gap, 2));
  T.dot(xn, f(xn), C.seq2, 5); T.dot(yn, f(yn), C.seq2, 5);
  return [["|xₙ − yₙ| = 1/n", fmt(1 / n)], ["|f(xₙ) − f(yₙ)|", fmt(gap) + " → 2π ≈ 6.283", "bad"]];
});

/* C6-7: pegado en a = 1. */
viz({ c: "c6-7-c", r: "c6-7-r", aspect: 1.2, range: { x: "c6-7-x", h: "c6-7-h" } }, (ctx, W, H, s) => {
  const a = 1, f = (t) => (t <= 1 ? 2 * Math.sqrt(t) : 2 + 0.6 * Math.sin(2 * (t - 1)));
  const T = plot(ctx, full(W, H, { l: 30, r: 86, t: 14, b: 26 }), [0, 2], [0, 3]);
  const x = s.x, y = x + s.h;
  T.vband(0, a, C.band); T.vband(a, 2, C.okband);
  T.axes({ xt: [[x, "x"], [a, "a"], [y, "y"]], yt: [1, 2, 3] });
  T.fn(f, C.ink, 2.2, 0, 2, 600);
  T.text("[0, a]", 0.05, 2.95, C.accent, "left", "top"); T.text("[a, ∞)", 1.95, 2.95, C.ok, "right", "top");
  for (const t of [x, a, y]) T.seg(t, 0, t, f(t), C.muted, 1, [3, 3]);
  const cross = y >= a;
  if (cross) {
    for (const t of [x, a, y]) T.seg(t, f(t), 2.05, f(t), C.muted, 1, [2, 3]);
    T.vbrace(2.02, f(x), f(a), C.accent, fmt(Math.abs(f(x) - f(a)), 2));
    T.vbrace(2.2, f(a), f(y), C.ok, fmt(Math.abs(f(a) - f(y)), 2));
  }
  T.dot(x, f(x), C.seq2, 5); T.dot(y, f(y), C.seq2, 5); T.dot(a, f(a), C.ink, 4, true);
  if (!cross) return [["x, y", "en el mismo trozo [0, a]"]];
  return [["|x − a| ≤ |x − y|", fmt(a - x) + " ≤ " + fmt(s.h)], ["|y − a| ≤ |x − y|", fmt(y - a) + " ≤ " + fmt(s.h)], ["|f(x) − f(y)| ≤ suma", fmt(Math.abs(f(x) - f(y))) + " ≤ " + fmt(Math.abs(f(x) - f(a)) + Math.abs(f(a) - f(y))), "good"]];
});

/* C6-8: brecha d(A, B) = 0.8 y la regla δ. */
viz({ c: "c6-8-c", r: "c6-8-r", aspect: 1.5, range: { d: "c6-8-d" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 44 }), [-0.2, 3.7], [-0.85, 3]);
  const fA = (x) => 1 + 0.5 * Math.sin(3 * x), fB = (x) => 2.4 - 0.3 * (x - 2);
  T.rect(0, -0.12, 1.2, 0.12, C.band, C.accent); T.rect(2, -0.12, 3.4, 0.12, C.okband, C.ok);
  T.axes({ xt: [0, [1.2, "1.2"], 2, [3.4, "3.4"]], yt: [1, 2, 3] });
  T.fn(fA, C.accent, 2.2, 0, 1.2); T.fn(fB, C.ok, 2.2, 2, 3.4);
  T.text("A", 0.6, 0.15, C.accent, "center", "bottom"); T.text("B", 2.7, 0.15, C.ok, "center", "bottom");
  T.hbrace(1.2, 2, -0.12, C.muted, "d(A, B) = 0.8");
  const ok = s.d <= 0.8;
  T.seg(1.2, -0.68, 1.2 + s.d, -0.68, ok ? C.ok : C.fail, 4);
  T.text("δ", 1.2 + s.d, -0.68, ok ? C.ok : C.fail, "left", "middle", 6);
  return [["δ ≤ d(A, B)", ok ? "sí: d(x, y) < δ deja a x, y en la misma pieza" : "no: hay x ∈ A, y ∈ B con d(x, y) < δ", ok ? "good" : "bad"]];
});

/* 37: x² y el par x = 1.1/δ, y = x + δ/2. */
viz({ c: "37-c", r: "37-r", aspect: 1.2, range: { d: "37-d" } }, (ctx, W, H, s) => {
  const d = s.d, x = 1.1 / d, y = x + d / 2;
  const T = plot(ctx, full(W, H, { l: 44, r: 58, t: 14, b: 26 }), [0, y * 1.12], [0, y * y * 1.12]);
  T.axes({ xt: [[x, "x"]], yt: [[x * x, fmt(x * x, 1)], [y * y, fmt(y * y, 1)]] });
  T.fn((t) => t * t, C.ink, 2.2);
  T.seg(x, x * x, y * 1.12, x * x, C.muted, 1, [3, 3]); T.seg(y, y * y, y * 1.12, y * y, C.muted, 1, [3, 3]);
  T.vbrace(y * 1.06, x * x, y * y, C.fail, fmt(y * y - x * x, 2));
  T.dot(x, x * x, C.seq2, 5); T.dot(y, y * y, C.seq2, 5);
  return [["x = 1.1/δ", fmt(x, 2)], ["|x − y| = δ/2", fmt(d / 2)], ["|f(x) − f(y)| = δ|x + δ/4|", fmt(y * y - x * x) + " ≥ 1", "bad"]];
});

/* ===================== Bloque 7 ===================== */

/* 38: un racional y un irracional en (x, x + 1/n). */
viz({ c: "38-c", r: "38-r", aspect: 2.2, range: { n: "38-n" } }, (ctx, W, H, s) => {
  const n = s.n, x = Math.SQRT2 - 1, q = Math.ceil(n * x) / n, z = x + 1 / (2 * n);
  const T = plot(ctx, full(W, H, { l: 16, r: 16, t: 24, b: 34 }), [x - 0.6 / n, x + 1.6 / n], [-1, 1]);
  T.vband(x, x + 1 / n, C.band);
  T.axes({ xt: [[x, "x"], [x + 1 / n, "x + 1/n"]] });
  T.seg(x, -1, x, 1, C.accent, 1, [3, 3]); T.seg(x + 1 / n, -1, x + 1 / n, 1, C.accent, 1, [3, 3]);
  T.dot(x, 0, C.ink, 3.5, true);
  T.dot(q, 0.4, C.ok, 5); T.text(`${Math.ceil(n * x)}/${n} ∈ ℚ`, q, 0.4, C.ok, "center", "bottom", 0, -8);
  T.dot(z, -0.4, C.seq2, 5); T.text("zₙ ∈ 𝕀", z, -0.4, C.seq2, "center", "top", 0, 8);
  return [["x = √2 − 1", fmt(x, 6)], ["racional, distancia a x", fmt(q - x, 6)], ["zₙ = x + 1/(2n), distancia", fmt(z - x, 6)]];
});

/* C9-3.1: la preimagen de un abierto atrapa puntos de D. */
viz({ c: "c9-3-1-c", r: "c9-3-1-r", aspect: 1.05, range: { c: "c9-3-1-a", m: "c9-3-1-m" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [-1.6, 1.6], [-1.6, 1.6]);
  const f = (x) => x * x * x - x, w = 0.12, a = s.c - w, b = s.c + w;
  T.hband(a, b, C.area2);
  T.axes({ xt: [-1, 1], yt: [-1, 1], xl: "X", yl: "Y" });
  T.fn(f, C.ink, 2.2);
  const N = 1200; let st = null;
  for (let i = 0; i <= N; i++) {
    const x = -1.6 + (3.2 * i) / N, inn = f(x) > a && f(x) < b;
    if (inn && st === null) st = x;
    if ((!inn || i === N) && st !== null) { T.seg(st, 0, x, 0, C.ok, 5); st = null; }
  }
  const step = 1 / 2 ** s.m; let hits = 0;
  for (let k = Math.ceil(-1.6 / step); k * step <= 1.6; k++) {
    const x = k * step, inn = f(x) > a && f(x) < b;
    T.seg(x, -0.05, x, 0.05, inn ? C.accent : C.muted, inn ? 2 : 1);
    if (inn) { hits++; T.seg(x, 0, x, f(x), C.accent, 1, [2, 3]); T.seg(x, f(x), 0, f(x), C.accent, 1, [2, 3]); T.dot(x, f(x), C.accent, 3.5); T.dot(0, f(x), C.accent, 3.5); }
  }
  T.text("A", 1.55, b, C.seq2, "right", "bottom");
  return [["A", `(${fmt(a, 2)}, ${fmt(b, 2)})`], ["puntos de D en f⁻¹(A)", hits ? String(hits) : "0 (con este m; probá uno más grande)", hits ? "good" : "bad"], ["f(D) ∩ A ≠ ∅", hits ? "sí" : "—", hits ? "good" : ""]];
});

/* C9-3.2: f = g en los diádicos. */
viz({ c: "c9-3-2-c", r: "c9-3-2-r", aspect: 1.2, range: { n: "c9-3-2-n" }, radio: { g: "c9-3-2-g" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [0, 1.2], [0, 2.4]);
  const f = (x) => 1 + 0.6 * Math.sin(2 * x), xs = Math.SQRT2 / 2;
  T.axes({ xt: [[xs, "x*"], 1], yt: [1, 2] });
  for (let k = 0; k <= 76; k++) T.seg(k / 64, 0, k / 64, 0.06, C.muted, 1);
  T.fn(f, C.accent, 2.2);
  const xn = (k) => Math.floor(xs * 2 ** k) / 2 ** k;
  for (let k = 1; k <= s.n; k++) T.dot(xn(k), f(xn(k)), k === s.n ? C.seq2 : C.rule, k === s.n ? 5 : 3);
  T.seg(xn(s.n), 0, xn(s.n), f(xn(s.n)), C.seq2, 1, [3, 3]);
  T.dot(xs, f(xs), C.accent, 5, true);
  const disc = s.g === "d";
  if (disc) { T.dot(xs, f(xs) + 0.7, C.fail, 5); T.text("g(x*)", xs, f(xs) + 0.7, C.fail, "left", "bottom", 7, -2); }
  T.text("f = g en D", 0.02, 2.3, C.accent, "left", "top");
  return [["xₙ = ⌊2ⁿx*⌋/2ⁿ", fmt(xn(s.n), 5)], ["f(xₙ) = g(xₙ)", fmt(f(xn(s.n)), 5)], ["f(x*)", fmt(f(xs), 5)], disc ? ["g(x*)", fmt(f(xs) + 0.7, 5) + " ≠ lím g(xₙ)", "bad"] : ["g(x*)", fmt(f(xs), 5), "good"]];
});

/* C9-3.1b: los valores 2^(p/q) fijados por la ecuación. */
viz({ c: "c9-3-1b-c", r: "c9-3-1b-r", aspect: 1.2, range: { Q: "c9-3-1b-q" } }, (ctx, W, H, s) => {
  const T = plot(ctx, full(W, H, { l: 30, r: 14, t: 14, b: 26 }), [-2, 2.4], [0, 5.5]);
  T.axes({ xt: [-2, -1, 1, 2], yt: [1, 2, 4] });
  T.fn((x) => 2 ** x, C.muted, 1.2, -2, 2.4, 300, [4, 4]);
  const seen = new Set(); let cnt = 0;
  for (let q = 1; q <= s.Q; q++) for (let p = Math.ceil(-2 * q); p <= 2.4 * q; p++) {
    const v = p / q, key = v.toFixed(9); if (seen.has(key)) continue; seen.add(key); cnt++;
    T.dot(v, 2 ** v, q === 1 ? C.ok : C.accent, q === 1 ? 5 : 2.8);
  }
  T.text("f(1) = 2", 1, 2, C.ok, "left", "top", 7, 2);
  return [["racionales p/q con q ≤ Q", String(cnt)], ["valores fijados", "f(p/q) = 2^(p/q)"]];
});

/* ===================== Bloque 8 ===================== */

/* 40 a): h(x) = x/(1 + |x|). */
viz({ c: "40-c1", r: "40-r1", aspect: 1.3, range: { x: "40-x" } }, (ctx, W, H, s) => {
  const h = (x) => x / (1 + Math.abs(x)), hi = (y) => y / (1 - Math.abs(y));
  const T = plot(ctx, full(W, H, { l: 34, r: 14, t: 14, b: 26 }), [-10, 10], [-1.35, 1.35]);
  T.hband(-1, 1, C.band);
  T.axes({ xt: [-8, -4, 4, 8], yt: [-1, 1] });
  T.seg(-10, 1, 10, 1, C.accent, 1, [5, 4]); T.seg(-10, -1, 10, -1, C.accent, 1, [5, 4]);
  T.fn(h, C.ink, 2.2, -10, 10, 400);
  const x = s.x, y = h(x);
  T.seg(x, 0, x, y, C.seq2, 1.2, [3, 3]); T.seg(x, y, 0, y, C.seq2, 1.2, [3, 3]);
  T.dot(x, 0, C.seq2, 4.5); T.dot(x, y, C.seq2, 5); T.dot(0, y, C.ok, 4.5);
  T.text("h(x)", 0, y, C.ok, x >= 0 ? "right" : "left", "bottom", x >= 0 ? -6 : 6, -3);
  T.text("(−1, 1)", -9.8, 1, C.accent, "left", "top", 0, 3);
  return [["x", fmt(x, 2)], ["h(x)", fmt(y, 4)], ["h⁻¹(h(x)) = h(x)/(1 − |h(x)|)", fmt(hi(y), 2), "good"]];
});

/* 40 b): xₙ = x + 1/n en la usual y en la discreta. */
viz({ c: "40-c2", r: "40-r2", aspect: 1.25, range: { n: "40-n" } }, (ctx, W, H, s) => {
  const n = s.n, top = 0.36 * (H - 20);
  const T = plot(ctx, { x: 20, y: 12, w: W - 40, h: top - 12 }, [-0.12, 1.08], [-1, 1]);
  T.seg(-0.12, 0, 1.08, 0, C.muted, 1.2);
  T.text("x", 0, 0, C.ink, "center", "top", 0, 8, UIs); T.text("x + 1", 1, 0, C.muted, "center", "top", 0, 8, UIs);
  T.text("(ℝ, |·|)", -0.1, 1, C.muted, "left", "top");
  for (let k = 1; k <= n; k++) T.dot(1 / k, 0, k === n ? C.seq2 : C.rule, k === n ? 5 : 3);
  T.dot(0, 0, C.ink, 5, true);
  T.text("xₙ", 1 / n, 0, C.seq2, "center", "bottom", 0, -8);
  const B = plot(ctx, { x: 34, y: top + 22, w: W - 48, h: H - top - 50 }, [0, 31], [0, 1.25]);
  B.axes({ xt: [1, 10, 20, 30], yt: [[1, "1"]], xl: "n" });
  for (let k = 1; k <= n; k++) {
    B.seg(k - 0.2, 0, k - 0.2, 1 / k, C.accent, 3);
    B.seg(k + 0.2, 0, k + 0.2, 1, C.fail, 3);
  }
  B.text("δ(xₙ, x) = 1", 30.5, 1, C.fail, "right", "bottom", 0, -4);
  B.text("|xₙ − x| = 1/n", 30.5, 0.35, C.accent, "right", "bottom");
  return [["|xₙ − x|", fmt(1 / n, 4) + " → 0", "good"], ["δ(f⁻¹(xₙ), f⁻¹(x))", "1 para todo n", "bad"]];
});

/* 41: la isometría x ↦ x + 1. */
viz({ c: "41-c", r: "41-r", aspect: 1.35, range: { x: "41-x", y: "41-y" } }, (ctx, W, H, s) => {
  const x = s.x, y = s.y, fx = x + 1, fy = y + 1;
  const T = plot(ctx, full(W, H, { l: 18, r: 18, t: 18, b: 18 }), [-0.3, 6.6], [0, 1]);
  const yt = 0.74, yb = 0.2;
  T.seg(0, yt, 6.6, yt, C.muted, 1.4); T.seg(0, yb, 6.6, yb, C.muted, 1.4);
  T.seg(1, yb, 6.6, yb, C.ok, 6);
  for (const t of [0, 1, 2, 3, 4, 5, 6]) { T.seg(t, yt - 0.025, t, yt + 0.025, C.muted, 1); T.seg(t, yb - 0.025, t, yb + 0.025, C.muted, 1); T.text(String(t), t, yb, C.muted, "center", "top", 0, 8, UIs); }
  T.dot(0, yt, C.muted, 3.5); T.dot(0, yb, C.muted, 3.5); T.dot(1, yb, C.ok, 4.5);
  T.text("dominio ℝ≥0", -0.25, yt, C.muted, "left", "bottom", 0, -28);
  T.text("llegada ℝ≥0;  Im(f) = [1, ∞)", -0.25, yb, C.ok, "left", "bottom", 0, -28);
  for (const [a, b, lab] of [[x, fx, "x"], [y, fy, "y"]]) {
    arrow(ctx, T.X(a), T.Y(yt) + 6, T.X(b), T.Y(yb) - 7, C.seq2, 1.2);
    T.dot(a, yt, C.accent, 5); T.text(lab, a, yt, C.accent, "center", "bottom", 0, -7);
    T.dot(b, yb, C.seq2, 5); T.text("f(" + lab + ")", b, yb, C.seq2, "center", "top", 0, 22);
  }
  return [["|x − y|", fmt(Math.abs(x - y), 2)], ["|f(x) − f(y)|", fmt(Math.abs(fx - fy), 2), "good"], ["[0, 1) ∩ Im(f)", "∅: f no es sobreyectiva", "bad"]];
});
