/* Dibujos del primer parcial 1C 2025. Todos los colores salen de los tokens del tema (PP.css). */

const ID = "p1-1c2025";
const C = (t) => PP.css(t);

/* Marco con la misma escala en x y en y (para bolas en R²). */
function eqFrame(w, h, cx, cy, halfW) {
  const p = { l: 8, r: 8, t: 8, b: 8 };
  const sx = (w - p.l - p.r) / (2 * halfW);
  const halfH = (h - p.t - p.b) / (2 * sx);
  const T = PP.frame(w, h, { x0: cx - halfW, x1: cx + halfW, y0: cy - halfH, y1: cy + halfH }, p);
  T.s = sx;
  return T;
}

/* Recta numérica horizontal a la altura y (en coordenadas del marco), con marcas en los valores dados. */
function numberLine(ctx, T, y, ticks, x0, x1) {
  PP.path(ctx, [[T.X(x0), T.Y(y)], [T.X(x1), T.Y(y)]], C("--muted"), 1);
  ticks.forEach((t) => {
    PP.path(ctx, [[T.X(t), T.Y(y) - 4], [T.X(t), T.Y(y) + 4]], C("--muted"), 1);
    PP.label(ctx, PP.fmt(t, 2), T.X(t), T.Y(y) + 7, C("--muted"), "center", "top", 11);
  });
}

/* Segmento grueso [a, b] sobre la recta, con extremos abiertos o cerrados. */
function interval(ctx, T, y, a, b, color, openA, openB) {
  ctx.save(); ctx.lineCap = "butt";
  PP.path(ctx, [[T.X(a), T.Y(y)], [T.X(b), T.Y(y)]], color, 5);
  ctx.restore();
  PP.dot(ctx, T.X(a), T.Y(y), 4.5, openA ? C("--bg") : color, color);
  PP.dot(ctx, T.X(b), T.Y(y), 4.5, openB ? C("--bg") : color, color);
}

function square(ctx, x, y, s, fill, stroke) {
  PP.rect(ctx, x - s, y - s, 2 * s, 2 * s, stroke, fill);
}

/* ---------------- Ej. 1, paso 1: la escalera de una sucesión de A ---------------- */
const ej1Steps = [1, 2, 2, 1, 2, 1, 1, 2, 1];
let ej1T = null;
function drawEj1a() {
  const z = PP.val(ID + "-ej1-z");
  PP.out(ID + "-ej1-z-o", PP.fmt(z, 0));
  const { ctx, w, h } = PP.canvas(ID + "-ej1-c1", 0.66);
  const a = [z];
  ej1Steps.forEach((d) => a.push(a[a.length - 1] + d));
  const T = PP.frame(w, h, { x0: 0.5, x1: 10.5, y0: -4, y1: 22 }, { l: 36, r: 12, t: 14, b: 30 });
  ej1T = T;
  PP.axes(ctx, T, { xLabel: "n", yLabel: "aₙ", intX: true, xTicks: 10 });
  for (let i = 0; i < ej1Steps.length; i++) {
    const d = ej1Steps[i];
    const col = d === 1 ? C("--accent") : C("--seq2");
    const x0 = T.X(i + 1), x1 = T.X(i + 2);
    PP.rect(ctx, x0 + 2, T.p.t, x1 - x0 - 4, h - T.p.t - T.p.b, null, d === 1 ? C("--band") : C("--area2"));
    PP.path(ctx, [[x0, T.Y(a[i])], [x1, T.Y(a[i + 1])]], col, 2.5);
    PP.label(ctx, "+" + d, (x0 + x1) / 2, Math.min(T.Y(a[i]), T.Y(a[i + 1])) - 6, col, "center", "bottom", 12);
  }
  a.forEach((v, i) => PP.dot(ctx, T.X(i + 1), T.Y(v), 4, C("--ink")));
  PP.label(ctx, "a₁", T.X(1) + 6, T.Y(a[0]) + 4, C("--ink"), "left", "top", 12);
  PP.read(ID + "-ej1-read", [
    ["(aₙ)", a.join(", ") + ", …"],
    ["Φ((aₙ))", "(" + z + "; " + ej1Steps.join(", ") + ", …)"],
    ["pasos en {1,2}", "sí", "good"],
  ]);
}
PP.register(drawEj1a, [ID + "-ej1-z"]);
(function () {
  const cv = document.getElementById(ID + "-ej1-c1");
  if (!cv) return;
  cv.style.cursor = "pointer";
  cv.addEventListener("click", (e) => {
    if (!ej1T) return;
    const r = cv.getBoundingClientRect();
    const k = Math.floor(ej1T.iX(e.clientX - r.left));
    if (k >= 1 && k <= ej1Steps.length) {
      ej1Steps[k - 1] = ej1Steps[k - 1] === 1 ? 2 : 1;
      drawEj1a();
    }
  });
})();

/* ---------------- Ej. 1, lema: gráficos en N × Z ---------------- */
const ej1A = [0, 1, -1, 2, 1, -2, 0, 3, 1, -1, 2, 0];
const ej1B = ej1A.map((v, i) => (i === 4 ? -3 : v));
function drawEj1b() {
  const n = PP.val(ID + "-ej1-n");
  const showB = document.getElementById(ID + "-ej1-b").checked;
  PP.out(ID + "-ej1-n-o", String(n));
  const { ctx, w, h } = PP.canvas(ID + "-ej1-c2", 0.66);
  const T = PP.frame(w, h, { x0: 0.4, x1: 12.6, y0: -4.6, y1: 4.6 }, { l: 32, r: 10, t: 12, b: 28 });
  PP.rect(ctx, T.X(n - 0.45), T.p.t, T.X(n + 0.45) - T.X(n - 0.45), h - T.p.t - T.p.b, null, C("--band"));
  PP.axes(ctx, T, { xLabel: "n ∈ ℕ", yLabel: "ℤ", intX: true, xTicks: 12, yTicks: 8, grid: false });
  for (let i = 1; i <= 12; i++) for (let z = -4; z <= 4; z++) PP.dot(ctx, T.X(i), T.Y(z), 1.6, C("--rule"));
  ej1A.forEach((v, i) => PP.dot(ctx, T.X(i + 1), T.Y(v), 5.5, null, C("--accent")));
  if (showB) {
    ej1B.forEach((v, i) => {
      const x = T.X(i + 1), y = T.Y(v), s = 4.5;
      PP.path(ctx, [[x - s, y - s], [x + s, y + s]], C("--seq2"), 2);
      PP.path(ctx, [[x - s, y + s], [x + s, y - s]], C("--seq2"), 2);
    });
  }
  const rows = [
    ["(n, aₙ) ∈ G(a)", "(" + n + ", " + PP.fmt(ej1A[n - 1], 0) + ")"],
    ["puntos de G(a) en la columna", "1"],
  ];
  if (showB) {
    const same = ej1A[n - 1] === ej1B[n - 1];
    rows.push(["(n, bₙ) ∈ G(b)", "(" + n + ", " + PP.fmt(ej1B[n - 1], 0) + ")"]);
    rows.push(["en esta columna", same ? "coinciden" : "distintos: aₙ ≠ bₙ", same ? "" : "bad"]);
    rows.push(["G(a) = G(b)", "no (columna 5)", "bad"]);
  }
  PP.read(ID + "-ej1-read2", rows);
}
PP.register(drawEj1b, [ID + "-ej1-n", ID + "-ej1-b"]);

/* ---------------- Ej. 2 (a): A, su clausura y a_n = 1 + 1/n ---------------- */
function drawEj2a() {
  const n = PP.val(ID + "-ej2-n");
  PP.out(ID + "-ej2-n-o", String(n));
  const { ctx, w, h } = PP.canvas(ID + "-ej2-c1", 0.5);
  const T = PP.frame(w, h, { x0: 0.75, x1: 3.25, y0: -0.7, y1: 1.6 }, { l: 16, r: 16, t: 12, b: 10 });
  const yA = 1, yC = 0;
  PP.path(ctx, [[T.X(1), T.p.t], [T.X(1), h - T.p.b]], C("--seq3"), 1.5, [5, 4]);
  PP.label(ctx, "i = ínf A = 1", T.X(1) + 5, T.p.t + 2, C("--seq3"), "left", "top", 12);
  numberLine(ctx, T, yA, [1, 2, 3], 0.8, 3.2);
  numberLine(ctx, T, yC, [1, 2, 3], 0.8, 3.2);
  PP.label(ctx, "A", T.X(0.78), T.Y(yA) - 8, C("--ink"), "left", "bottom", 13);
  PP.label(ctx, "Ā", T.X(0.78), T.Y(yC) - 8, C("--ink"), "left", "bottom", 13);
  interval(ctx, T, yA, 2, 3, C("--accent"), false, true);
  interval(ctx, T, yC, 2, 3, C("--accent"), false, false);
  for (let k = 2; k <= 200; k++) {
    const x = 1 + 1 / k;
    if (T.X(x) - T.X(1) < 1.2) break;
    PP.dot(ctx, T.X(x), T.Y(yA), 2.6, C("--accent"));
    PP.dot(ctx, T.X(x), T.Y(yC), 2.6, C("--accent"));
  }
  PP.dot(ctx, T.X(1), T.Y(yA), 4.5, C("--bg"), C("--accent"));
  PP.dot(ctx, T.X(1), T.Y(yC), 4.5, C("--ok"), C("--ok"));
  PP.label(ctx, "x = 1 ∈ Ā", T.X(1) + 6, T.Y(yC) + 22, C("--ok"), "left", "top", 12);
  const an = 1 + 1 / n;
  PP.dot(ctx, T.X(an), T.Y(yA), 6, null, C("--seq2"));
  PP.label(ctx, "aₙ", T.X(an), T.Y(yA) - 9, C("--seq2"), "center", "bottom", 12);
  PP.read(ID + "-ej2-read1", [
    ["aₙ = 1 + 1/n", PP.fmt(an, 4)],
    ["i ≤ aₙ", "sí", "good"],
    ["|aₙ − x|", PP.fmt(1 / n, 4)],
    ["límite x", "1 ≥ i", "good"],
  ]);
}
PP.register(drawEj2a, [ID + "-ej2-n"]);

/* ---------------- Ej. 2 (b): bolas en {0} ∪ [1, 2] ---------------- */
function inA2b(t) { return t === 0 || (t >= 1 && t <= 2); }
function drawEj2b() {
  const r = PP.val(ID + "-ej2-r") / 100;
  const x = +PP.radio(ID + "-ej2-x");
  PP.out(ID + "-ej2-r-o", PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej2-c2", 0.42);
  const T = PP.frame(w, h, { x0: -1.7, x1: 3.7, y0: -0.8, y1: 0.9 }, { l: 12, r: 12, t: 10, b: 10 });
  const y = 0;
  const lo = x - r, hi = x + r;
  PP.rect(ctx, T.X(lo), T.Y(y) - 16, T.X(hi) - T.X(lo), 32, C("--seq2"), C("--area2"), [4, 3]);
  numberLine(ctx, T, y, [-1, 0, 1, 2, 3], -1.6, 3.6);
  interval(ctx, T, y, 1, 2, C("--accent"), false, false);
  PP.dot(ctx, T.X(0), T.Y(y), 4.5, C("--accent"), C("--accent"));
  PP.label(ctx, "A", T.X(1.5), T.Y(y) - 20, C("--accent"), "center", "bottom", 13);
  PP.dot(ctx, T.X(x), T.Y(y), 3.5, C("--ink"));
  PP.label(ctx, "x", T.X(x), T.Y(y) + 20, C("--ink"), "center", "top", 12);
  let wit = null;
  if (x === 0) wit = -r / 2;
  else if (x === 1) wit = 1 - Math.min(r, 1) / 2;
  else if (x === 2) wit = 2 + r / 2;
  const rows = [["B(x, r)", "(" + PP.fmt(lo, 3) + ", " + PP.fmt(hi, 3) + ")"]];
  if (wit !== null) {
    PP.dot(ctx, T.X(wit), T.Y(y), 5.5, C("--fail"), C("--fail"));
    PP.label(ctx, "testigo", T.X(wit), T.Y(y) - 20, C("--fail"), "center", "bottom", 12);
    rows.push(["testigo", PP.fmt(wit, 3)]);
    rows.push(["¿testigo ∈ A?", inA2b(wit) ? "sí" : "no", inA2b(wit) ? "good" : "bad"]);
    rows.push(["¿B(x, r) ⊆ A?", "no, para todo r", "bad"]);
  } else {
    const fits = lo >= 1 && hi <= 2;
    rows.push(["¿B(x, r) ⊆ A?", fits ? "sí" : "no (achicá r)", fits ? "good" : "bad"]);
    rows.push(["x ∈ (1, 2)", "es interior", "good"]);
  }
  PP.read(ID + "-ej2-read2", rows);
}
PP.register(drawEj2b, [ID + "-ej2-r", 'input[name="' + ID + '-ej2-x"]']);

/* ---------------- Ej. 2 (b): ínf A = 0 contra ínf A° = 1 ---------------- */
function drawEj2c() {
  const eps = PP.val(ID + "-ej2-eps") / 100;
  PP.out(ID + "-ej2-eps-o", PP.fmt(eps, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej2-c3", 0.5);
  const T = PP.frame(w, h, { x0: -0.5, x1: 2.9, y0: -0.75, y1: 1.65 }, { l: 12, r: 12, t: 10, b: 10 });
  const yA = 1, yI = 0;
  const p = 1 + Math.min(eps, 1) / 2;
  PP.rect(ctx, T.X(1), T.Y(yI) - 15, T.X(1 + eps) - T.X(1), 30, null, C("--okband"));
  PP.path(ctx, [[T.X(1 + eps), T.Y(yI) - 15], [T.X(1 + eps), T.Y(yI) + 15]], C("--ok"), 1.5, [4, 3]);
  numberLine(ctx, T, yA, [0, 1, 2], -0.4, 2.8);
  numberLine(ctx, T, yI, [0, 1, 2], -0.4, 2.8);
  PP.label(ctx, "A", T.X(-0.42), T.Y(yA) - 8, C("--ink"), "left", "bottom", 13);
  PP.label(ctx, "A°", T.X(-0.42), T.Y(yI) - 8, C("--ink"), "left", "bottom", 13);
  interval(ctx, T, yA, 1, 2, C("--accent"), false, false);
  PP.dot(ctx, T.X(0), T.Y(yA), 4.5, C("--accent"), C("--accent"));
  PP.label(ctx, "ínf A = 0", T.X(0), T.Y(yA) - 10, C("--seq3"), "center", "bottom", 12);
  interval(ctx, T, yI, 1, 2, C("--accent"), true, true);
  PP.label(ctx, "ínf A° = 1", T.X(1), T.Y(yI) - 17, C("--seq3"), "center", "bottom", 12);
  PP.dot(ctx, T.X(p), T.Y(yI), 5, C("--seq2"), C("--seq2"));
  PP.label(ctx, "1 + mín(ε,1)/2", T.X(p), T.Y(yI) + 20, C("--seq2"), "center", "top", 11);
  PP.read(ID + "-ej2-read3", [
    ["1 + ε", PP.fmt(1 + eps, 3)],
    ["punto", PP.fmt(p, 3)],
    ["¿en (1,2) y &lt; 1 + ε?", "sí", "good"],
  ]);
}
PP.register(drawEj2c, [ID + "-ej2-eps"]);

/* ---------------- Ej. 3, ida: achicar la bola ---------------- */
const ej3 = { R: 1.2, ty: 0.3, x: -0.25 };
let ej3T = null, ej3Drag = false;
function drawEj3a() {
  const r = PP.val(ID + "-ej3-r") / 100;
  PP.out(ID + "-ej3-r-o", PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej3-c1", 0.8);
  const T = eqFrame(w, h, 0, 0.1, 1.75);
  ej3T = T;
  const xm = Math.sqrt(ej3.R * ej3.R - ej3.ty * ej3.ty) - 0.05;
  ej3.x = Math.max(-xm, Math.min(xm, ej3.x));
  const X = [ej3.x, ej3.ty];
  const s = ej3.R - Math.hypot(X[0], X[1]);
  const rho = Math.min(r, s);
  const Y = [X[0], X[1] + rho / 2];
  /* T: semiplano abierto y > ty */
  PP.rect(ctx, 0, T.p.t, w, T.Y(ej3.ty) - T.p.t, null, C("--area3"));
  PP.path(ctx, [[0, T.Y(ej3.ty)], [w, T.Y(ej3.ty)]], C("--seq3"), 1.5, [5, 4]);
  PP.label(ctx, "T", T.X(-1.65), T.Y(ej3.ty) - 8, C("--seq3"), "left", "bottom", 13);
  /* U: disco abierto */
  PP.circle(ctx, T.X(0), T.Y(0), ej3.R * T.s, C("--accent"), C("--band"), [5, 4]);
  PP.label(ctx, "U", T.X(0), T.Y(-ej3.R) - 8, C("--accent"), "center", "bottom", 13);
  /* bolas */
  PP.circle(ctx, T.X(X[0]), T.Y(X[1]), r * T.s, C("--seq2"), null, [4, 3], 1.5);
  PP.circle(ctx, T.X(X[0]), T.Y(X[1]), s * T.s, C("--seq3"), null, null, 1.5);
  PP.circle(ctx, T.X(X[0]), T.Y(X[1]), rho * T.s, C("--ok"), C("--okband"), null, 2);
  PP.label(ctx, "B(x, r)", T.X(X[0] + r * 0.72), T.Y(X[1] - r * 0.72) + 2, C("--seq2"), "left", "top", 11);
  PP.dot(ctx, T.X(X[0]), T.Y(X[1]), 4, C("--ink"));
  PP.label(ctx, "x", T.X(X[0]) - 6, T.Y(X[1]) + 4, C("--ink"), "right", "top", 12);
  PP.dot(ctx, T.X(Y[0]), T.Y(Y[1]), 4, C("--ok"));
  PP.label(ctx, "y", T.X(Y[0]) + 6, T.Y(Y[1]), C("--ok"), "left", "middle", 12);
  PP.read(ID + "-ej3-read1", [
    ["r", PP.fmt(r, 3)],
    ["s (B(x,s) ⊆ U)", PP.fmt(s, 3)],
    ["ρ = mín{r, s}", PP.fmt(rho, 3)],
    ["y ∈ B(x,r) ∩ U ∩ T", "sí", "good"],
  ]);
}
PP.register(drawEj3a, [ID + "-ej3-r"]);
(function () {
  const cv = document.getElementById(ID + "-ej3-c1");
  if (!cv) return;
  cv.style.cursor = "grab";
  const pos = (e) => { const r = cv.getBoundingClientRect(); return [e.clientX - r.left, e.clientY - r.top]; };
  cv.addEventListener("pointerdown", (e) => {
    if (!ej3T) return;
    const [px, py] = pos(e);
    if (Math.abs(py - ej3T.Y(ej3.ty)) < 28) { ej3Drag = true; cv.setPointerCapture(e.pointerId); ej3.x = ej3T.iX(px); drawEj3a(); }
  });
  cv.addEventListener("pointermove", (e) => {
    if (!ej3Drag || !ej3T) return;
    ej3.x = ej3T.iX(pos(e)[0]); drawEj3a();
  });
  const end = () => { ej3Drag = false; };
  cv.addEventListener("pointerup", end);
  cv.addEventListener("pointercancel", end);
})();

/* ---------------- Ej. 3, vuelta: un U no abierto ---------------- */
function drawEj3b() {
  const r = PP.val(ID + "-ej3-r2") / 100;
  PP.out(ID + "-ej3-r2-o", PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej3-c2", 0.7);
  const T = eqFrame(w, h, 0.3, 0.1, 1.6);
  const ang = Math.PI / 6;
  const u = [Math.cos(ang), Math.sin(ang)];
  const X = u;
  const Z = [X[0] + u[0] * r / 2, X[1] + u[1] * r / 2];
  PP.rect(ctx, 0, 0, w, h, null, C("--failband"));
  PP.circle(ctx, T.X(0), T.Y(0), T.s, C("--accent"), C("--panel"), null, 2);
  PP.circle(ctx, T.X(0), T.Y(0), T.s, null, C("--area"));
  PP.label(ctx, "U (cerrado)", T.X(0), T.Y(0), C("--accent"), "center", "middle", 13);
  PP.label(ctx, "E ∖ U", T.X(-1.2), T.Y(1.05), C("--fail"), "left", "top", 13);
  PP.circle(ctx, T.X(X[0]), T.Y(X[1]), r * T.s, C("--seq2"), C("--area2"), [4, 3], 1.5);
  PP.dot(ctx, T.X(X[0]), T.Y(X[1]), 4, C("--ink"));
  PP.label(ctx, "x", T.X(X[0]) - 6, T.Y(X[1]) - 4, C("--ink"), "right", "bottom", 12);
  PP.dot(ctx, T.X(Z[0]), T.Y(Z[1]), 4, C("--fail"));
  PP.label(ctx, "z", T.X(Z[0]) + 6, T.Y(Z[1]), C("--fail"), "left", "middle", 12);
  PP.read(ID + "-ej3-read2", [
    ["r", PP.fmt(r, 3)],
    ["z ∈ B(x, r)", "d(x, z) = " + PP.fmt(r / 2, 3)],
    ["|z| = 1 + r/2", PP.fmt(1 + r / 2, 3) + " > 1: z ∈ E ∖ U", "bad"],
    ["x ∈ U ∩ cl(E ∖ U)", "sí", "bad"],
  ]);
}
PP.register(drawEj3b, [ID + "-ej3-r2"]);

/* ---------------- Ej. 4: utilidades para sucesiones como tallos ---------------- */
function stems(ctx, T, vals, color, shape, dx) {
  vals.forEach((v, i) => {
    const x = T.X(i + 1 + (dx || 0));
    PP.path(ctx, [[x, T.Y(0)], [x, T.Y(v)]], color, 1.5);
    if (shape === "sq") square(ctx, x, T.Y(v), 4, C("--bg"), color);
    else PP.dot(ctx, x, T.Y(v), 4.2, color, color);
  });
}

/* Ej. 4 (a), lema: |a_n − b_n| ≤ d∞(a, b) */
const ej4a = [0.8, -0.5, 1.1, 0.3, -0.7, 0.4, 0, 0, 0, 0];
const ej4b = [0.2, 0.4, 0.9, 0.9, -0.2, 0.0, 0, 0, 0, 0];
function drawEj4a() {
  const n = PP.val(ID + "-ej4-n");
  PP.out(ID + "-ej4-n-o", String(n));
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c1", 0.78);
  const h1 = Math.round(h * 0.56);
  const T1 = PP.frame(w, h1, { x0: 0.4, x1: 10.6, y0: -1, y1: 1.3 }, { l: 36, r: 10, t: 10, b: 24 });
  const diffs = ej4a.map((v, i) => Math.abs(v - ej4b[i]));
  const dinf = Math.max(...diffs);
  PP.rect(ctx, T1.X(n - 0.42), T1.p.t, T1.X(n + 0.42) - T1.X(n - 0.42), h - T1.p.t - 24, null, C("--band"));
  PP.axes(ctx, T1, { xLabel: "n", intX: true, xTicks: 10, yTicks: 4 });
  stems(ctx, T1, ej4a, C("--accent"), "dot", -0.12);
  stems(ctx, T1, ej4b, C("--seq2"), "sq", 0.12);
  PP.path(ctx, [[T1.X(n), T1.Y(ej4a[n - 1])], [T1.X(n), T1.Y(ej4b[n - 1])]], C("--seq3"), 3);
  /* panel inferior: |a_n − b_n| */
  ctx.save(); ctx.translate(0, h1);
  const T2 = PP.frame(w, h - h1, { x0: 0.4, x1: 10.6, y0: 0, y1: 1.1 }, { l: 36, r: 10, t: 8, b: 24 });
  PP.axes(ctx, T2, { xLabel: "", yLabel: "|aₙ − bₙ|", intX: true, xTicks: 10, yTicks: 2 });
  diffs.forEach((d, i) => {
    const x = T2.X(i + 1);
    PP.rect(ctx, x - 7, T2.Y(d), 14, T2.Y(0) - T2.Y(d), null, i + 1 === n ? C("--seq3") : C("--area3"));
  });
  PP.path(ctx, [[T2.X(0.4), T2.Y(dinf)], [T2.X(10.6), T2.Y(dinf)]], C("--ink"), 1.2, [5, 4]);
  PP.label(ctx, "d∞(a, b)", T2.X(10.6) - 2, T2.Y(dinf) - 3, C("--ink"), "right", "bottom", 11);
  ctx.restore();
  PP.read(ID + "-ej4-read1", [
    ["|aₙ − bₙ|", PP.fmt(diffs[n - 1], 3)],
    ["d∞(a, b) = sup", PP.fmt(dinf, 3)],
    ["|aₙ − bₙ| ≤ d∞(a, b)", "sí", "good"],
  ]);
}
PP.register(drawEj4a, [ID + "-ej4-n"]);

/* Ej. 4 (a): A° = ∅, la perturbación de la cuarta coordenada */
const ej4base = [0.6, -0.4, 0.9, 0, 0, 0, 0, 0, 0, 0];
function drawEj4b() {
  const r = PP.val(ID + "-ej4-r") / 100;
  PP.out(ID + "-ej4-r-o", PP.fmt(r, 2));
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c2", 0.62);
  const T = PP.frame(w, h, { x0: 0.4, x1: 10.6, y0: -1.5, y1: 2.0 }, { l: 36, r: 10, t: 12, b: 26 });
  PP.axes(ctx, T, { xLabel: "n", intX: true, xTicks: 10, yTicks: 6 });
  ej4base.forEach((v, i) => {
    const x = T.X(i + 1);
    PP.rect(ctx, x - 9, T.Y(v + r), 18, T.Y(v - r) - T.Y(v + r), null, C("--area"));
  });
  PP.rect(ctx, T.X(3.5), T.p.t, T.X(10.6) - T.X(3.5), h - T.p.t - T.p.b, null, C("--band"));
  PP.label(ctx, "n ≥ 4: en A valen 0", T.X(10.5), T.p.t + 2, C("--muted"), "right", "top", 11);
  stems(ctx, T, ej4base, C("--accent"), "dot", 0);
  const b4 = r / 2;
  const x4 = T.X(4);
  PP.path(ctx, [[x4 + 0.5, T.Y(0)], [x4 + 0.5, T.Y(b4)]], C("--seq2"), 2);
  square(ctx, x4, T.Y(b4), 4.5, C("--seq2"), C("--seq2"));
  PP.label(ctx, "b₄ = r/2", x4 + 9, T.Y(b4), C("--seq2"), "left", "middle", 12);
  PP.read(ID + "-ej4-read2", [
    ["d∞(a, b)", PP.fmt(b4, 3) + " &lt; r = " + PP.fmt(r, 2), "good"],
    ["b ∈ X", "nula desde n = 5", "good"],
    ["b₄", PP.fmt(b4, 3) + " ≠ 0: b ∉ A", "bad"],
  ]);
}
PP.register(drawEj4b, [ID + "-ej4-r"]);

/* Ej. 4 (a): clausura, a^(k) → x coordenada a coordenada */
const ej4x = [0.7, -0.5, 0.3, 0, 0, 0, 0, 0, 0, 0];
const ej4sg = [1, -1, 1];
function drawEj4c() {
  const k = PP.val(ID + "-ej4-k");
  PP.out(ID + "-ej4-k-o", String(k));
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c3", 0.62);
  const T = PP.frame(w, h, { x0: 0.4, x1: 10.6, y0: -1.6, y1: 1.8 }, { l: 36, r: 10, t: 12, b: 26 });
  PP.rect(ctx, T.X(3.5), T.p.t, T.X(10.6) - T.X(3.5), h - T.p.t - T.p.b, null, C("--band"));
  PP.axes(ctx, T, { xLabel: "n", intX: true, xTicks: 10, yTicks: 6 });
  PP.label(ctx, "n ≥ 4: aₙ⁽ᵏ⁾ = 0 para todo k", T.X(10.5), T.p.t + 2, C("--muted"), "right", "top", 11);
  const ak = ej4x.map((v, i) => (i < 3 ? v + ej4sg[i] / k : 0));
  stems(ctx, T, ej4x, C("--accent"), "dot", -0.12);
  stems(ctx, T, ak, C("--seq2"), "sq", 0.12);
  PP.read(ID + "-ej4-read3", [
    ["d∞(a⁽ᵏ⁾, x)", PP.fmt(1 / k, 4)],
    ["a⁽ᵏ⁾₁ → x₁", PP.fmt(ak[0], 4) + " → " + PP.fmt(ej4x[0], 2)],
    ["a⁽ᵏ⁾₅ = 0 ⇒ x₅", "0", "good"],
  ]);
}
PP.register(drawEj4c, [ID + "-ej4-k"]);

/* Ej. 4 (b): truncadas de 1/n */
function trunc(N, n) { return n <= N ? 1 / n : 0; }
function drawEj4d() {
  const N = PP.val(ID + "-ej4-N"), M = PP.val(ID + "-ej4-M");
  PP.out(ID + "-ej4-N-o", String(N));
  PP.out(ID + "-ej4-M-o", String(M));
  const nMax = 20;
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c4", 0.62);
  const T = PP.frame(w, h, { x0: 0.4, x1: nMax + 0.6, y0: -0.05, y1: 1.1 }, { l: 36, r: 10, t: 12, b: 26 });
  const lo = Math.min(N, M), hi = Math.max(N, M);
  if (hi > lo) PP.rect(ctx, T.X(lo + 0.5), T.p.t, T.X(hi + 0.5) - T.X(lo + 0.5), h - T.p.t - T.p.b, null, C("--area3"));
  PP.axes(ctx, T, { xLabel: "n", intX: true, xTicks: 10, yTicks: 5 });
  const curve = [];
  for (let n = 1; n <= nMax; n++) curve.push([T.X(n), T.Y(1 / n)]);
  PP.path(ctx, curve, C("--muted"), 1, [3, 4]);
  for (let n = 1; n <= nMax; n++) {
    const xa = T.X(n - 0.14), xb = T.X(n + 0.14);
    PP.dot(ctx, xa, T.Y(trunc(N, n)), 3.6, C("--accent"), C("--accent"));
    square(ctx, xb, T.Y(trunc(M, n)), 3.4, C("--bg"), C("--seq2"));
  }
  const d = hi > lo ? 1 / (lo + 1) : 0;
  if (hi > lo) {
    const xd = T.X(lo + 1);
    PP.path(ctx, [[xd, T.Y(0)], [xd, T.Y(d)]], C("--seq3"), 3);
    PP.label(ctx, "1/" + (lo + 1), xd + 6, T.Y(d) - 2, C("--seq3"), "left", "bottom", 12);
  }
  PP.read(ID + "-ej4-read4", [
    ["d∞(a⁽ᴺ⁾, a⁽ᴹ⁾)", hi > lo ? "1/" + (lo + 1) + " = " + PP.fmt(d, 4) : "0"],
    ["cota 1/mín{N, M}", "1/" + lo + " = " + PP.fmt(1 / lo, 4)],
    ["d &lt; 1/mín{N, M}", hi > lo ? "sí" : "sí (d = 0)", "good"],
  ]);
}
PP.register(drawEj4d, [ID + "-ej4-N", ID + "-ej4-M"]);

/* Ej. 4 (b): la coordenada n fija, en función de N */
function drawEj4e() {
  const n = PP.val(ID + "-ej4-nn");
  PP.out(ID + "-ej4-nn-o", String(n));
  const Nmax = 20;
  const { ctx, w, h } = PP.canvas(ID + "-ej4-c5", 0.55);
  const T = PP.frame(w, h, { x0: 0.4, x1: Nmax + 0.6, y0: -0.05, y1: 1.1 }, { l: 36, r: 10, t: 12, b: 26 });
  PP.axes(ctx, T, { xLabel: "N", intX: true, xTicks: 10, yTicks: 5 });
  PP.path(ctx, [[T.X(0.4), T.Y(1 / n)], [T.X(Nmax + 0.6), T.Y(1 / n)]], C("--seq3"), 1.2, [5, 4]);
  PP.label(ctx, "1/n = " + PP.fmt(1 / n, 3), T.X(Nmax + 0.5), T.Y(1 / n) - 4, C("--seq3"), "right", "bottom", 12);
  PP.path(ctx, [[T.X(n), T.p.t], [T.X(n), h - T.p.b]], C("--muted"), 1, [2, 3]);
  PP.label(ctx, "N = n", T.X(n) + 4, T.p.t + 2, C("--muted"), "left", "top", 11);
  for (let N = 1; N <= Nmax; N++) {
    const v = trunc(N, n);
    PP.dot(ctx, T.X(N), T.Y(v), 4, N >= n ? C("--accent") : C("--bg"), C("--accent"));
  }
  PP.read(ID + "-ej4-read5", [
    ["a⁽ᴺ⁾ₙ para N < n", "0"],
    ["a⁽ᴺ⁾ₙ para N ≥ n", PP.fmt(1 / n, 4)],
    ["bₙ (límite)", PP.fmt(1 / n, 4) + " ≠ 0", "bad"],
  ]);
}
PP.register(drawEj4e, [ID + "-ej4-nn"]);
