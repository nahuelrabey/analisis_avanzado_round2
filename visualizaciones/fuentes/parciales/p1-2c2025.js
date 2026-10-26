/* Dibujos del primer parcial 2C 2025. Usa window.PP (ver _shell.html). */
const ID = "p1-2c2025";
const C = (t) => PP.css(t);
const SUP = "⁰¹²³⁴⁵⁶⁷⁸⁹", SUB = "₀₁₂₃₄₅₆₇₈₉";
const sup = (n) => String(n).split("").map((d) => SUP[+d]).join("");
const sub = (n) => String(n).split("").map((d) => SUB[+d]).join("");
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));

/* Marco con la misma escala en x y en y (para bolas que se vean redondas). */
function eqFrame(w, h, x0, x1, pad) {
  const p = Object.assign({ l: 10, r: 10, t: 10, b: 10 }, pad || {});
  const span = (x1 - x0) * (h - p.t - p.b) / (w - p.l - p.r);
  return PP.frame(w, h, { x0, x1, y0: 0, y1: span }, p);
}

/* Arrastre de puntos sobre un canvas: pick(px, py) devuelve un id o null; move(id, x, y) actualiza. */
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

/* ===================== Ejercicio 1 ===================== */

/* Paso 1: los elementos m/(m+n) con m, n ≤ N, una fila por n. */
PP.register(function ej1Cotas() {
  const N = PP.val(ID + "-ej1-N");
  PP.out(ID + "-ej1-N-o", String(N));
  const { ctx, w, h } = PP.canvas(ID + "-ej1-c1", 0.62);
  const T = PP.frame(w, h, { x0: -0.08, x1: 1.08, y0: N + 0.8, y1: 0.2 }, { l: 40, r: 14, t: 22, b: 30 });
  // inversión de y: fila n = 1 arriba
  const Yr = (n) => T.p.t + (n - 0.2) / (N + 0.6) * (h - T.p.t - T.p.b);
  ctx.save();
  ctx.font = "11px 'IBM Plex Sans', system-ui, sans-serif";
  ctx.fillStyle = C("--muted"); ctx.strokeStyle = C("--rule"); ctx.lineWidth = 1;
  ctx.textAlign = "center"; ctx.textBaseline = "top";
  [0, 0.25, 0.5, 0.75, 1].forEach((v) => {
    ctx.beginPath(); ctx.moveTo(T.X(v), T.p.t); ctx.lineTo(T.X(v), h - T.p.b); ctx.stroke();
    ctx.fillText(PP.fmt(v, 2), T.X(v), h - T.p.b + 6);
  });
  ctx.textAlign = "right"; ctx.textBaseline = "middle";
  const every = N <= 10 ? 1 : N <= 20 ? 2 : 5;
  for (let n = 1; n <= N; n++) if (n === 1 || n % every === 0) ctx.fillText("n=" + n, T.p.l - 4, Yr(n));
  ctx.restore();
  // cotas
  PP.path(ctx, [[T.X(0), T.p.t - 8], [T.X(0), h - T.p.b]], C("--ok"), 2.5);
  PP.path(ctx, [[T.X(1), T.p.t - 8], [T.X(1), h - T.p.b]], C("--ok"), 2.5);
  PP.label(ctx, "cota inferior 0", T.X(0) + 4, T.p.t - 6, C("--ok"), "left", "middle", 11);
  PP.label(ctx, "cota superior 1", T.X(1) - 4, T.p.t - 6, C("--ok"), "right", "middle", 11);
  const r = N <= 10 ? 3.6 : N <= 20 ? 2.6 : 2;
  let lo = 1, hi = 0;
  for (let n = 1; n <= N; n++) {
    for (let m = 1; m <= N; m++) {
      const a = m / (m + n);
      lo = Math.min(lo, a); hi = Math.max(hi, a);
      PP.dot(ctx, T.X(a), Yr(n), r, C("--accent"));
    }
  }
  PP.read(ID + "-ej1-read1", [
    ["puntos dibujados", String(N * N)],
    ["menor dibujado", "1/(1+" + N + ") = " + PP.fmt(lo, 4)],
    ["mayor dibujado", N + "/(" + N + "+1) = " + PP.fmt(hi, 4)],
    ["¿0 ∈ A? ¿1 ∈ A?", "no, no", "good"],
  ]);
}, [ID + "-ej1-N"]);

/* Pasos 2 y 3: sucesiones dentro de A que entran en la banda ε. */
function ej1Banda(cid, sid, rid, modo) {
  return function () {
    const eps = PP.val(sid) / 100;
    PP.out(sid + "-o", PP.fmt(eps, 2));
    const k = Math.floor(1 / eps) + 1; // primer natural con 1/k < ε
    const M = clamp(Math.max(k + 6, 12), 12, 45);
    const { ctx, w, h } = PP.canvas(cid, 0.62);
    const sup = modo === "sup";
    const box = sup ? { x0: 0, x1: M + 1, y0: 0.4, y1: 1.06 } : { x0: 0, x1: M + 1, y0: -0.04, y1: 0.58 };
    const T = PP.frame(w, h, box);
    // banda
    const b0 = sup ? Math.max(1 - eps, box.y0) : 0, b1 = sup ? 1 : Math.min(eps, box.y1);
    PP.rect(ctx, T.X(box.x0), T.Y(b1), T.X(box.x1) - T.X(box.x0), T.Y(b0) - T.Y(b1), null, C("--band"));
    PP.axes(ctx, T, { xLabel: sup ? "m" : "n", yLabel: sup ? "m/(m+1)" : "1/(1+n)", intX: true });
    const edge = sup ? 1 - eps : eps;
    if (edge > box.y0 && edge < box.y1) {
      PP.path(ctx, [[T.X(box.x0), T.Y(edge)], [T.X(box.x1), T.Y(edge)]], C("--accent"), 1.5, [5, 4]);
      PP.label(ctx, sup ? "1 − ε" : "ε", T.X(box.x1) - 4, T.Y(edge) + (sup ? 3 : -3), C("--accent"), "right", sup ? "top" : "bottom", 12);
    }
    const lim = sup ? 1 : 0;
    PP.path(ctx, [[T.X(box.x0), T.Y(lim)], [T.X(box.x1), T.Y(lim)]], C("--ok"), 2);
    if (sup) PP.label(ctx, "1 = sup A", T.X(box.x1) - 4, T.Y(1) - 3, C("--ok"), "right", "bottom", 12);
    else PP.label(ctx, "0 = ínf A", T.p.l + 6, T.Y(0) - 3, C("--ok"), "left", "bottom", 12);
    for (let j = 1; j <= M; j++) {
      const a = sup ? j / (j + 1) : 1 / (1 + j);
      const inBand = sup ? a > 1 - eps : a < eps;
      PP.dot(ctx, T.X(j), T.Y(a), j === k ? 6 : 3, inBand ? C("--accent") : C("--seq2"));
    }
    const ak = sup ? k / (k + 1) : 1 / (1 + k);
    PP.dot(ctx, T.X(k), T.Y(ak), 9, null, C("--ink"));
    PP.label(ctx, (sup ? "m = " : "n = ") + k, T.X(k), T.Y(ak) + (sup ? 12 : -12), C("--ink"), "center", sup ? "top" : "bottom", 12);
    PP.read(rid, sup ? [
      ["ε", PP.fmt(eps, 3)],
      ["m de Arquímedes", k + "   (1/m = " + PP.fmt(1 / k, 4) + " < ε)"],
      ["a_ε = m/(m+1)", PP.fmt(ak, 4)],
      ["1 − ε", PP.fmt(1 - eps, 4)],
      ["¿1 − ε < a_ε?", "sí", "good"],
    ] : [
      ["ε", PP.fmt(eps, 3)],
      ["n de Arquímedes", k + "   (1/n = " + PP.fmt(1 / k, 4) + " < ε)"],
      ["a_ε = 1/(1+n)", PP.fmt(ak, 4)],
      ["¿a_ε < 0 + ε?", "sí", "good"],
    ]);
  };
}
PP.register(ej1Banda(ID + "-ej1-c2", ID + "-ej1-eps", ID + "-ej1-read2", "sup"), [ID + "-ej1-eps"]);
PP.register(ej1Banda(ID + "-ej1-c3", ID + "-ej1-eps2", ID + "-ej1-read3", "inf"), [ID + "-ej1-eps2"]);

/* ===================== Ejercicio 2 ===================== */

const TUPLA = [[3, 1], [-1, 1], [1, 2], [-2, 3]]; // q1..q4 (valores elegidos)
function fracPow(p, q, e) { return [Math.pow(p, e), Math.pow(q, e)]; }
function fracStr(f) {
  const [p, q] = f;
  const s = (p < 0 ? "−" : "") + Math.abs(p);
  return q === 1 ? s : s + "/" + q;
}
function drawFrac(ctx, f, x, y, color) {
  const [p, q] = f;
  const sgn = p < 0 ? "−" : "";
  if (q === 1) { PP.label(ctx, sgn + Math.abs(p), x, y, color, "center", "middle", 12); return; }
  PP.label(ctx, sgn + Math.abs(p), x, y - 2, color, "center", "bottom", 11);
  ctx.save(); ctx.strokeStyle = color; ctx.lineWidth = 1;
  const wd = Math.max(ctx.measureText(String(q)).width, 14) * 0.75 + 4;
  ctx.beginPath(); ctx.moveTo(x - wd, y); ctx.lineTo(x + wd, y); ctx.stroke(); ctx.restore();
  PP.label(ctx, String(q), x, y + 2, color, "center", "top", 11);
}

PP.register(function ej2Cinta() {
  const k = PP.val(ID + "-ej2-k");
  PP.out(ID + "-ej2-k-o", String(k));
  const { ctx, w, h } = PP.canvas(ID + "-ej2-c1", 0.5);
  const NC = 9, padX = 8;
  const cw = (w - 2 * padX) / NC;
  const top = Math.max(44, h * 0.3), ch = Math.min(56, h * 0.34);
  const qk = TUPLA[k - 1];
  const vals = [];
  for (let n = 1; n <= NC; n++) vals.push(n <= k ? TUPLA[n - 1] : fracPow(qk[0], qk[1], n - k));
  // llaves
  const xA = padX, xB = padX + k * cw, xE = padX + NC * cw;
  PP.path(ctx, [[xA + 2, top - 10], [xA + 2, top - 16], [xB - 2, top - 16], [xB - 2, top - 10]], C("--accent"), 1.5);
  PP.label(ctx, k === 1 ? "libre" : "libres", (xA + xB) / 2, top - 20, C("--accent"), "center", "bottom", 11);
  PP.path(ctx, [[xB + 2, top - 10], [xB + 2, top - 16], [xE - 2, top - 16], [xE - 2, top - 10]], C("--seq2"), 1.5);
  PP.label(ctx, "potencias de q" + sub(k), (xB + xE) / 2, top - 20, C("--seq2"), "center", "bottom", 11);
  for (let i = 0; i < NC; i++) {
    const n = i + 1, x = padX + i * cw;
    const free = n <= k;
    PP.rect(ctx, x + 1.5, top, cw - 3, ch, free ? C("--accent") : C("--seq2"), free ? C("--area") : C("--area2"));
    PP.label(ctx, "b" + sub(n), x + cw / 2, top + ch + 4, C("--muted"), "center", "top", 11);
    drawFrac(ctx, vals[i], x + cw / 2, top + ch / 2, C("--ink"));
    if (!free) PP.label(ctx, "q" + sub(k) + sup(n - k), x + cw / 2, top + ch + 20, C("--seq2"), "center", "top", 12);
    else PP.label(ctx, "q" + sub(n), x + cw / 2, top + ch + 20, C("--accent"), "center", "top", 12);
  }
  const t = TUPLA.slice(0, k).map(fracStr).join(", ");
  const bk = fracStr(qk);
  PP.read(ID + "-ej2-read1", [
    ["testigo k", String(k)],
    ["(q₁, …, q" + sub(k) + ")", "(" + t + ")"],
    ["b" + sub(k + 1) + " = (b" + sub(k) + ")¹", fracStr(vals[k]) + " = (" + bk + ")¹", "good"],
    ["b" + sub(k + 2) + " = (b" + sub(k) + ")²", fracStr(vals[k + 1]) + " = (" + bk + ")²", "good"],
    ["b" + sub(k + 3) + " = (b" + sub(k) + ")³", fracStr(vals[k + 2]) + " = (" + bk + ")³", "good"],
  ]);
}, [ID + "-ej2-k"]);

/* ===================== Ejercicio 3 ===================== */

const E3 = { x: [2.6, 3.2], y: [7.2, 2.2], z: null, T1: null, T2: null };
function met3() { return PP.radio(ID + "-ej3-met") || "2"; }
function dist(a, b, m) {
  const dx = Math.abs(a[0] - b[0]), dy = Math.abs(a[1] - b[1]);
  return m === "1" ? dx + dy : m === "inf" ? Math.max(dx, dy) : Math.hypot(dx, dy);
}
function ball(ctx, T, c, r, m, stroke, fill, dash) {
  const s = T.X(1) - T.X(0), cx = T.X(c[0]), cy = T.Y(c[1]), R = r * s;
  if (m === "2") { PP.circle(ctx, cx, cy, R, stroke, fill, dash, 1.6); return; }
  const pts = m === "1"
    ? [[cx + R, cy], [cx, cy - R], [cx - R, cy], [cx, cy + R]]
    : [[cx + R, cy + R], [cx + R, cy - R], [cx - R, cy - R], [cx - R, cy + R]];
  PP.path(ctx, pts, stroke, 1.6, dash, true, fill);
}
const metName = { "2": "d₂ (euclídea)", "1": "d₁", "inf": "d∞" };

function ej3Uno() {
  const m = met3();
  const { ctx, w, h } = PP.canvas(ID + "-ej3-c1", 0.62);
  const T = eqFrame(w, h, 0, 10); E3.T1 = T;
  const { x, y } = E3;
  const r = dist(x, y, m);
  ball(ctx, T, x, r / 3, m, null, C("--area"));
  ball(ctx, T, y, r / 3, m, null, C("--area3"));
  ball(ctx, T, x, r / 3, m, C("--accent"), null, [5, 4]);
  ball(ctx, T, y, r / 3, m, C("--seq3"), null, [5, 4]);
  PP.path(ctx, [[T.X(x[0]), T.Y(x[1])], [T.X(y[0]), T.Y(y[1])]], C("--muted"), 1, [2, 3]);
  PP.dot(ctx, T.X(x[0]), T.Y(x[1]), 5, C("--accent"));
  PP.dot(ctx, T.X(y[0]), T.Y(y[1]), 5, C("--seq3"));
  PP.label(ctx, "x", T.X(x[0]) + 7, T.Y(x[1]) - 5, C("--accent"), "left", "bottom", 13);
  PP.label(ctx, "y", T.X(y[0]) + 7, T.Y(y[1]) - 5, C("--seq3"), "left", "bottom", 13);
  PP.label(ctx, "U", T.X(x[0]), T.Y(x[1]) + 10, C("--accent"), "center", "top", 12);
  PP.label(ctx, "V", T.X(y[0]), T.Y(y[1]) + 10, C("--seq3"), "center", "top", 12);
  PP.label(ctx, "arrastrá x o y", w - 12, h - 10, C("--muted"), "right", "bottom", 11);
  PP.read(ID + "-ej3-read1", [
    ["métrica", metName[m]],
    ["r = d(x, y)", PP.fmt(r, 3)],
    ["radio r/3", PP.fmt(r / 3, 3)],
    ["x ∈ U, y ∈ V", "sí", "good"],
    ["¿B̄(x, r/3) ∩ B̄(y, r/3) = ∅?", "sí", "good"],
  ]);
}
function ej3Dos() {
  const m = met3();
  const { ctx, w, h } = PP.canvas(ID + "-ej3-c2", 0.62);
  const T = eqFrame(w, h, 0, 10); E3.T2 = T;
  const { x, y } = E3;
  if (!E3.z) E3.z = [(x[0] + y[0]) / 2, (x[1] + y[1]) / 2 + 0.6];
  const z = E3.z;
  const r = dist(x, y, m), dxz = dist(x, z, m), dzy = dist(z, y, m);
  const inX = dxz <= r / 3 + 1e-9, inY = dzy <= r / 3 + 1e-9;
  ball(ctx, T, x, r / 3, m, C("--accent"), C("--band"), [5, 4]);
  ball(ctx, T, y, r / 3, m, C("--seq3"), C("--area3"), [5, 4]);
  PP.path(ctx, [[T.X(x[0]), T.Y(x[1])], [T.X(z[0]), T.Y(z[1])]], C("--accent"), 2);
  PP.path(ctx, [[T.X(z[0]), T.Y(z[1])], [T.X(y[0]), T.Y(y[1])]], C("--seq3"), 2);
  PP.dot(ctx, T.X(x[0]), T.Y(x[1]), 5, C("--accent"));
  PP.dot(ctx, T.X(y[0]), T.Y(y[1]), 5, C("--seq3"));
  PP.dot(ctx, T.X(z[0]), T.Y(z[1]), 6, C("--seq2"));
  PP.label(ctx, "x", T.X(x[0]) - 7, T.Y(x[1]) - 5, C("--accent"), "right", "bottom", 13);
  PP.label(ctx, "y", T.X(y[0]) + 7, T.Y(y[1]) - 5, C("--seq3"), "left", "bottom", 13);
  PP.label(ctx, "z", T.X(z[0]) + 8, T.Y(z[1]) - 6, C("--seq2"), "left", "bottom", 13);
  PP.label(ctx, "arrastrá z", w - 12, h - 10, C("--muted"), "right", "bottom", 11);
  PP.read(ID + "-ej3-read2", [
    ["r = d(x, y)", PP.fmt(r, 3)],
    ["d(x, z)", PP.fmt(dxz, 3) + (inX ? "  ≤ r/3: z ∈ B̄(x, r/3)" : "  > r/3")],
    ["d(z, y)", PP.fmt(dzy, 3) + (inY ? "  ≤ r/3: z ∈ B̄(y, r/3)" : "  > r/3")],
    ["d(x, z) + d(z, y)", PP.fmt(dxz + dzy, 3) + " ≥ r = " + PP.fmt(r, 3), "good"],
    ["¿z en las dos bolas cerradas?", inX && inY ? "sí" : "no", inX && inY ? "bad" : "good"],
  ]);
}
PP.register(ej3Uno, ['input[name="' + ID + '-ej3-met"]']);
PP.register(ej3Dos, ['input[name="' + ID + '-ej3-met"]']);
function clampPt(p, T) { return [clamp(p[0], 0.2, T.box.x1 - 0.2), clamp(p[1], 0.2, T.box.y1 - 0.2)]; }
draggable(ID + "-ej3-c1", () => E3.T1, (px, py, T) => {
  const dx = Math.hypot(px - T.X(E3.x[0]), py - T.Y(E3.x[1])), dy = Math.hypot(px - T.X(E3.y[0]), py - T.Y(E3.y[1]));
  if (Math.min(dx, dy) > 28) return null;
  return dx <= dy ? "x" : "y";
}, (who, X, Y, T) => {
  const p = clampPt([X, Y], T), o = who === "x" ? E3.y : E3.x;
  if (Math.hypot(p[0] - o[0], p[1] - o[1]) < 0.4) return;
  E3[who] = p;
}, () => { ej3Uno(); ej3Dos(); });
draggable(ID + "-ej3-c2", () => E3.T2, (px, py, T) => {
  if (!E3.z) return null;
  return Math.hypot(px - T.X(E3.z[0]), py - T.Y(E3.z[1])) <= 30 ? "z" : null;
}, (who, X, Y, T) => { E3.z = clampPt([X, Y], T); }, ej3Dos);

/* ===================== Ejercicio 4 ===================== */

const DISCOS = [
  { c: [1.5, 2.5], R: 1.0 },
  { c: [4.9, 2.3], R: 0.9 },
  { c: [8.0, 3.0], R: 0.8 },
  { c: [5.0, 5.2], R: 0.5 },
]; // separados por más de ε = 1 (valores elegidos)
const EPS4 = 1;
const ang = (150 * Math.PI) / 180;
const XBORDE = [DISCOS[1].c[0] + DISCOS[1].R * Math.cos(ang), DISCOS[1].c[1] + DISCOS[1].R * Math.sin(ang)];
const E4 = { x: XBORDE.slice(), T1: null, T2: null };

function drawDiscos(ctx, T, hi) {
  const s = T.X(1) - T.X(0);
  DISCOS.forEach((D, i) => {
    const on = i === hi;
    PP.circle(ctx, T.X(D.c[0]), T.Y(D.c[1]), D.R * s, on ? C("--accent") : C("--seq3"), on ? C("--area") : C("--area3"), [4, 3], 1.4);
    PP.label(ctx, "M" + sub(i + 1), T.X(D.c[0]), T.Y(D.c[1]), on ? C("--accent") : C("--seq3"), "center", "middle", 13);
  });
}
function toward(p, c, t) {
  const dx = c[0] - p[0], dy = c[1] - p[1], L = Math.hypot(dx, dy);
  if (L < 1e-9) return [p[0] + t, p[1]];
  return [p[0] + dx / L * t, p[1] + dy / L * t];
}

PP.register(function ej4a() {
  const r = PP.val(ID + "-ej4-r1") / 100;
  PP.out(ID + "-ej4-r1-o", PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c1", 0.66);
  const T = eqFrame(w, h, 0, 10); E4.T1 = T;
  const s = T.X(1) - T.X(0);
  drawDiscos(ctx, T, 1);
  const x = XBORDE, D = DISCOS[1];
  const y = toward(x, D.c, Math.min(r / 2, D.R));
  PP.circle(ctx, T.X(x[0]), T.Y(x[1]), r * s, C("--seq2"), C("--area2"), [5, 4], 1.6);
  PP.dot(ctx, T.X(x[0]), T.Y(x[1]), 5, C("--ink"));
  PP.label(ctx, "x", T.X(x[0]) - 7, T.Y(x[1]) - 4, C("--ink"), "right", "bottom", 13);
  PP.dot(ctx, T.X(y[0]), T.Y(y[1]), 4.5, C("--seq2"));
  PP.label(ctx, "y", T.X(y[0]) + 6, T.Y(y[1]) + 4, C("--seq2"), "left", "top", 13);
  PP.label(ctx, "B(x, r)", T.X(x[0]) - r * s * 0.72, T.Y(x[1]) + r * s * 0.72 + 2, C("--seq2"), "right", "top", 12);
  PP.read(ID + "-ej4-read1", [
    ["x ∈ M₂", "no (está en el borde)", "bad"],
    ["x ∈ cl(M₂)", "sí", "good"],
    ["d(x, y)", PP.fmt(Math.hypot(x[0] - y[0], x[1] - y[1]), 3) + " < r = " + PP.fmt(r, 2)],
    ["y ∈ B(x, r) ∩ M₂ ⊆ B(x, r) ∩ ⋃ Mₘ", "sí", "good"],
  ]);
}, [ID + "-ej4-r1"]);

function ej4b() {
  const r = PP.val(ID + "-ej4-r2") / 100;
  PP.out(ID + "-ej4-r2-o", PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c2", 0.66);
  const T = eqFrame(w, h, 0, 10); E4.T2 = T;
  const s = T.X(1) - T.X(0);
  const x = E4.x;
  const info = DISCOS.map((D) => Math.hypot(x[0] - D.c[0], x[1] - D.c[1]));
  const toca = DISCOS.map((D, i) => info[i] < D.R + EPS4 / 2).map((b, i) => (b ? i : -1)).filter((i) => i >= 0);
  const n0 = toca.length ? toca[0] : -1;
  drawDiscos(ctx, T, n0);
  // escala ε
  PP.path(ctx, [[12, h - 14], [12 + EPS4 * s, h - 14]], C("--ink"), 2);
  PP.label(ctx, "ε = 1", 12 + EPS4 * s + 6, h - 14, C("--ink"), "left", "middle", 11);
  PP.circle(ctx, T.X(x[0]), T.Y(x[1]), (EPS4 / 2) * s, C("--ink"), null, [3, 3], 1.3);
  const rho = Math.min(r, EPS4 / 2);
  PP.circle(ctx, T.X(x[0]), T.Y(x[1]), rho * s, C("--seq2"), C("--area2"), null, 1.6);
  const rows = [["B(x, ε/2) toca a", toca.length ? toca.map((i) => "M" + sub(i + 1)).join(", ") : "ningún Mₙ"]];
  let inClos = false;
  if (n0 >= 0) {
    const D = DISCOS[n0], dist0 = info[n0], lo = Math.max(dist0 - D.R, 0);
    inClos = dist0 <= D.R + 1e-9;
    const y0 = toward(x, D.c, (lo + EPS4 / 2) / 2);
    PP.dot(ctx, T.X(y0[0]), T.Y(y0[1]), 4.5, C("--accent"));
    PP.label(ctx, "y₀", T.X(y0[0]) + 6, T.Y(y0[1]) - 3, C("--accent"), "left", "bottom", 12);
    rows.push(["n₀", String(n0 + 1)]);
    rows.push(["d(x, y₀)", PP.fmt(Math.hypot(x[0] - y0[0], x[1] - y0[1]), 3) + " < ε/2 = 0.5", "good"]);
    rows.push(["ρ = mín{r, ε/2}", PP.fmt(rho, 3)]);
    if (rho > lo) {
      const y = toward(x, D.c, (lo + rho) / 2);
      PP.dot(ctx, T.X(y[0]), T.Y(y[1]), 4.5, C("--seq2"));
      PP.label(ctx, "y", T.X(y[0]) + 6, T.Y(y[1]) + 3, C("--seq2"), "left", "top", 12);
      rows.push(["y ∈ B(x, ρ) ∩ ⋃ Mₙ", "y ∈ M" + sub(n0 + 1) + " (m = n₀)", "good"]);
    } else {
      rows.push(["B(x, ρ) ∩ ⋃ Mₙ", "vacío", "bad"]);
    }
  }
  rows.push(["¿x ∈ cl(⋃ Mₙ)?", inClos ? "sí: x ∈ cl(M" + sub(n0 + 1) + ")" : "no (el paso arranca con x en la clausura)", inClos ? "good" : "bad"]);
  PP.dot(ctx, T.X(x[0]), T.Y(x[1]), 5, C("--ink"));
  PP.label(ctx, "x", T.X(x[0]) - 7, T.Y(x[1]) - 4, C("--ink"), "right", "bottom", 13);
  PP.label(ctx, "arrastrá x", w - 12, h - 10, C("--muted"), "right", "bottom", 11);
  PP.read(ID + "-ej4-read2", rows);
}
PP.register(ej4b, [ID + "-ej4-r2"]);
draggable(ID + "-ej4-c2", () => E4.T2, (px, py, T) => (Math.hypot(px - T.X(E4.x[0]), py - T.Y(E4.x[1])) <= 30 ? "x" : null),
  (who, X, Y, T) => { E4.x = [clamp(X, 0.1, T.box.x1 - 0.1), clamp(Y, 0.1, T.box.y1 - 0.1)]; }, ej4b);

/* ===================== Ejercicio 5 ===================== */

const g5 = (t) => 0.55 + 0.3 * Math.sin(6.2 * t - 0.5) + 0.07 * Math.sin(21 * t);
const phi5 = (t) => 0.97 * Math.sin(17 * t + 0.8) * Math.cos(2.3 * t);
function delta1(y, half) {
  const gy = g5(y), st = 0.0005;
  let best = 2;
  for (const dir of [-1, 1]) {
    for (let d = st; d <= 1.0001; d += st) {
      const t = y + dir * d;
      if (t < 0 || t > 1) break;
      if (Math.abs(g5(t) - gy) >= half) { best = Math.min(best, d); break; }
    }
  }
  return Math.min(best, 1) * 0.999;
}
function state5() {
  const y = PP.val(ID + "-ej5-y") / 100, eps = PP.val(ID + "-ej5-eps") / 100;
  const d1 = delta1(y, eps / 2);
  return { y, eps, d1, delta: Math.min(d1, eps / 2), gy: g5(y) };
}
function curve(T, f, a, b) {
  const pts = [], n = 240;
  for (let i = 0; i <= n; i++) { const t = a + (b - a) * i / n; pts.push([T.X(t), T.Y(f(t))]); }
  return pts;
}

function ej5Uno() {
  const S = state5();
  PP.out(ID + "-ej5-y-o", PP.fmt(S.y, 2));
  PP.out(ID + "-ej5-eps-o", PP.fmt(S.eps, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej5-c1", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: Math.min(0, S.gy - S.eps / 2 - 0.05), y1: Math.max(1.05, S.gy + S.eps / 2 + 0.05) });
  const a = Math.max(0, S.y - S.d1), b = Math.min(1, S.y + S.d1);
  PP.rect(ctx, T.X(a), T.p.t, T.X(b) - T.X(a), h - T.p.t - T.p.b, null, C("--area3"));
  PP.rect(ctx, T.X(0), T.Y(S.gy + S.eps / 2), T.X(1) - T.X(0), T.Y(S.gy - S.eps / 2) - T.Y(S.gy + S.eps / 2), null, C("--band"));
  PP.axes(ctx, T, { xLabel: "t", yLabel: "g(t)" });
  [S.gy + S.eps / 2, S.gy - S.eps / 2].forEach((v) => PP.path(ctx, [[T.X(0), T.Y(v)], [T.X(1), T.Y(v)]], C("--accent"), 1.2, [5, 4]));
  PP.label(ctx, "g(y) ± ε/2", T.X(1) - 4, T.Y(S.gy + S.eps / 2) - 2, C("--accent"), "right", "bottom", 11);
  PP.path(ctx, curve(T, g5, 0, 1), C("--ink"), 1.6);
  PP.path(ctx, curve(T, g5, a, b), C("--seq3"), 3);
  // δ sobre el eje
  const da = Math.max(0, S.y - S.delta), db = Math.min(1, S.y + S.delta), yb = h - T.p.b - 4;
  PP.path(ctx, [[T.X(da), yb], [T.X(db), yb]], C("--seq2"), 4);
  PP.label(ctx, "δ", T.X(db) + 4, yb, C("--seq2"), "left", "middle", 12);
  PP.label(ctx, "|t − y| < δ₁", (T.X(a) + T.X(b)) / 2, T.p.t + 2, C("--seq3"), "center", "top", 11);
  PP.dot(ctx, T.X(S.y), T.Y(S.gy), 5, C("--accent"));
  PP.label(ctx, "(y, g(y))", T.X(S.y) + 7, T.Y(S.gy) + 4, C("--accent"), "left", "top", 12);
  PP.read(ID + "-ej5-read1", [
    ["g(y)", PP.fmt(S.gy, 3)],
    ["ε/2", PP.fmt(S.eps / 2, 3)],
    ["δ₁ (numérico)", PP.fmt(S.d1, 3)],
    ["δ = mín{δ₁, ε/2}", PP.fmt(S.delta, 3) + (S.delta < S.d1 ? "  (manda ε/2)" : "  (manda δ₁)")],
  ]);
}

function ej5Dos() {
  const S = state5();
  const s = PP.val(ID + "-ej5-s") / 100, u = PP.val(ID + "-ej5-u") / 100;
  PP.out(ID + "-ej5-s-o", PP.fmt(s, 2));
  PP.out(ID + "-ej5-u-o", PP.fmt(u, 2));
  const f = (t) => g5(t) + s * S.delta * phi5(t);
  const x = clamp(S.y + u * S.delta, 0, 1);
  let dinf = 0;
  for (let i = 0; i <= 2000; i++) { const t = i / 2000; dinf = Math.max(dinf, Math.abs(f(t) - g5(t))); }
  const { ctx, w, h } = PP.canvas(ID + "-ej5-c2", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: Math.min(0, S.gy - S.eps - 0.05), y1: Math.max(1.05, S.gy + S.eps + 0.05) });
  PP.rect(ctx, T.X(0), T.Y(S.gy + S.eps), T.X(1) - T.X(0), T.Y(S.gy - S.eps) - T.Y(S.gy + S.eps), null, C("--band"));
  PP.axes(ctx, T, { xLabel: "t" });
  [S.gy + S.eps, S.gy - S.eps].forEach((v) => PP.path(ctx, [[T.X(0), T.Y(v)], [T.X(1), T.Y(v)]], C("--accent"), 1.2, [5, 4]));
  PP.label(ctx, "g(y) ± ε", T.X(1) - 4, T.Y(S.gy + S.eps) - 2, C("--accent"), "right", "bottom", 11);
  const up = curve(T, (t) => g5(t) + S.delta, 0, 1), dn = curve(T, (t) => g5(t) - S.delta, 0, 1).reverse();
  PP.path(ctx, up.concat(dn), null, 1, null, true, C("--area"));
  PP.path(ctx, curve(T, g5, 0, 1), C("--ink"), 1.6);
  PP.path(ctx, curve(T, f, 0, 1), C("--seq2"), 1.6);
  const gx = g5(x), fx = f(x);
  PP.path(ctx, [[T.X(S.y), T.Y(S.gy)], [T.X(x), T.Y(S.gy)]], C("--muted"), 1, [3, 3]);
  PP.path(ctx, [[T.X(x) + 3, T.Y(S.gy)], [T.X(x) + 3, T.Y(gx)]], C("--seq3"), 3.5);
  PP.path(ctx, [[T.X(x) - 3, T.Y(gx)], [T.X(x) - 3, T.Y(fx)]], C("--seq2"), 3.5);
  PP.dot(ctx, T.X(S.y), T.Y(S.gy), 5, C("--accent"));
  PP.label(ctx, "g(y)", T.X(S.y) - 6, T.Y(S.gy) + 4, C("--accent"), "right", "top", 12);
  PP.dot(ctx, T.X(x), T.Y(gx), 3.5, C("--ink"));
  PP.dot(ctx, T.X(x), T.Y(fx), 5, C("--seq2"));
  PP.label(ctx, "f(x)", T.X(x) + 7, T.Y(fx) - 3, C("--seq2"), "left", "bottom", 12);
  PP.label(ctx, "g", T.X(0.02), T.Y(g5(0.02)) - 4, C("--ink"), "left", "bottom", 12);
  const a = Math.abs(fx - gx), b = Math.abs(gx - S.gy), tot = Math.abs(fx - S.gy);
  PP.read(ID + "-ej5-read2", [
    ["δ", PP.fmt(S.delta, 3)],
    ["d∞(f, g)", PP.fmt(dinf, 3) + " < δ ≤ ε/2", "good"],
    ["|x − y|", PP.fmt(Math.abs(x - S.y), 3) + " < δ ≤ δ₁", "good"],
    ["|f(x) − g(x)|", PP.fmt(a, 3) + " ≤ d∞(f, g)", a < S.eps / 2 ? "good" : "bad"],
    ["|g(x) − g(y)|", PP.fmt(b, 3) + " < ε/2 = " + PP.fmt(S.eps / 2, 3), b < S.eps / 2 ? "good" : "bad"],
    ["|F(f, x) − F(g, y)|", PP.fmt(tot, 3) + " < ε = " + PP.fmt(S.eps, 3), tot < S.eps ? "good" : "bad"],
  ]);
}
PP.register(ej5Uno, [ID + "-ej5-y", ID + "-ej5-eps"]);
PP.register(ej5Dos, [ID + "-ej5-y", ID + "-ej5-eps", ID + "-ej5-s", ID + "-ej5-u"]);
