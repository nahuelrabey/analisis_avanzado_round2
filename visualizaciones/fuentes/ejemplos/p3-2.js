/* Dibujos de los ejemplos de la Práctica 3, segunda parte (Bloques 3 a 6). Usa window.PP. */
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const hyp = (x, y) => Math.hypot(x, y);
const F2 = (x) => PP.fmt(x, 2), F3 = (x) => PP.fmt(x, 3);

/* Marco con la misma escala en x y en y, centrado verticalmente en yc. */
function eqFrame(w, h, x0, x1, yc, pad) {
  const p = Object.assign({ l: 10, r: 10, t: 10, b: 10 }, pad || {});
  const span = (x1 - x0) * (h - p.t - p.b) / (w - p.l - p.r);
  return PP.frame(w, h, { x0, x1, y0: yc - span / 2, y1: yc + span / 2 }, p);
}
const scale = (T) => T.X(1) - T.X(0);

/* Arrastre de puntos: pick(px, py, T) devuelve un id o null; move(id, x, y, T) actualiza el estado. */
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
const near = (T, px, py, x, y, tol) => Math.hypot(px - T.X(x), py - T.Y(y)) < (tol || 22);

/* Ejes finos que pasan por el origen (para dibujos con escala igual). */
function crossAxes(ctx, T, lx, ly) {
  const { w, h } = T;
  PP.path(ctx, [[0, T.Y(0)], [w, T.Y(0)]], C("--muted"), 1);
  PP.path(ctx, [[T.X(0), 0], [T.X(0), h]], C("--muted"), 1);
  if (lx) PP.label(ctx, lx, w - 6, T.Y(0) - 4, C("--muted"), "right", "bottom", 11);
  if (ly) PP.label(ctx, ly, T.X(0) + 5, 4, C("--muted"), "left", "top", 11);
}

/* Recta numérica horizontal a la altura y (en píxeles) con marcas en ticks. */
function numberLine(ctx, T, yPx, ticks) {
  PP.path(ctx, [[T.p.l - 6, yPx], [T.w - T.p.r + 6, yPx]], C("--muted"), 1);
  (ticks || []).forEach(([v, lab]) => {
    PP.path(ctx, [[T.X(v), yPx - 4], [T.X(v), yPx + 4]], C("--muted"), 1);
    PP.label(ctx, lab, T.X(v), yPx + 7, C("--muted"), "center", "top", 11);
  });
}
/* Intervalo (a, b) dibujado como banda con paréntesis a la altura yPx. */
function ballBand(ctx, T, a, b, yPx, color, fill, label) {
  PP.rect(ctx, T.X(a), yPx - 9, T.X(b) - T.X(a), 18, null, fill);
  PP.path(ctx, [[T.X(a), yPx], [T.X(b), yPx]], color, 2);
  PP.label(ctx, "(", T.X(a), yPx, color, "center", "middle", 17);
  PP.label(ctx, ")", T.X(b), yPx, color, "center", "middle", 17);
  if (label) PP.label(ctx, label, (T.X(a) + T.X(b)) / 2, yPx - 12, color, "center", "bottom", 12);
}

/* ===================== 24 · clausura de la bola unitaria ===================== */
(() => {
  const S = { th: Math.PI / 4 }; let TT = null;
  function draw() {
    const r = PP.val("ejp3-24-r") / 100;
    PP.out("ejp3-24-r-o", F2(r));
    const { ctx, w, h } = PP.canvas("ejp3-24-c1", 0.82);
    const T = eqFrame(w, h, -1.75, 1.75, 0); TT = T; const s = scale(T);
    crossAxes(ctx, T, "x", "y");
    PP.circle(ctx, T.X(0), T.Y(0), s, C("--accent"), C("--band"), [6, 4], 1.8);
    PP.label(ctx, "E", T.X(-0.72), T.Y(-0.72), C("--accent"), "center", "middle", 14);
    const px = Math.cos(S.th), py = Math.sin(S.th);
    PP.circle(ctx, T.X(px), T.Y(py), r * s, C("--fail"), C("--failband"), [5, 4], 1.5);
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(px * 1.6), T.Y(py * 1.6)]], C("--muted"), 1, [3, 3]);
    const t = 1 - r / 2;
    PP.dot(ctx, T.X(t * px), T.Y(t * py), 6, C("--seq2"));
    PP.label(ctx, "(tx, ty)", T.X(t * px) - 8, T.Y(t * py) + 4, C("--seq2"), "right", "top", 12);
    PP.dot(ctx, T.X(px), T.Y(py), 6, C("--ink"));
    PP.label(ctx, "x", T.X(px) + 8, T.Y(py) - 4, C("--ink"), "left", "bottom", 13);
    PP.label(ctx, "B(x, r)", T.X(px + r * 0.72) + 4, T.Y(py + r * 0.72) - 2, C("--fail"), "left", "bottom", 12);
    PP.read("ejp3-24-read", [
      ["x", "(" + F3(px) + ", " + F3(py) + ")   x² + y² = 1"],
      ["t = 1 − r/2", F3(t)],
      ["|t| < 1", "sí: (tx, ty) ∈ E", "good"],
      ["|1 − t| = r/2 < r", "sí: (tx, ty) ∈ B(x, r)", "good"],
    ]);
  }
  PP.register(draw, ["ejp3-24-r"]);
  draggable("ejp3-24-c1", () => TT, (px, py, T) => near(T, px, py, Math.cos(S.th), Math.sin(S.th), 26) ? 1 : null,
    (id, x, y) => { S.th = Math.atan2(y, x); }, draw);
})();

/* ===================== 25 · bola cerrada es cerrada ===================== */
(() => {
  const S = { y: [2.25, 0.55], phi: 2.4, rho: 0.6 }; let TT = null;
  function draw() {
    const r = PP.val("ejp3-25-r") / 100;
    PP.out("ejp3-25-r-o", F2(r));
    let [yx, yy] = S.y; let dy = hyp(yx, yy);
    if (dy < r + 0.12) { const k = (r + 0.12) / (dy || 1); yx *= k; yy *= k; dy = r + 0.12; S.y = [yx, yy]; }
    const t = dy - r;
    const zx = yx + S.rho * t * Math.cos(S.phi), zy = yy + S.rho * t * Math.sin(S.phi);
    const { ctx, w, h } = PP.canvas("ejp3-25-c1", 0.7);
    const T = eqFrame(w, h, -1.7, 3.6, 0.2); TT = T; const s = scale(T);
    PP.circle(ctx, T.X(0), T.Y(0), r * s, C("--accent"), C("--area"), null, 2);
    PP.circle(ctx, T.X(yx), T.Y(yy), t * s, C("--fail"), C("--failband"), [5, 4], 1.5);
    const ux = yx / dy, uy = yy / dy;
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(r * ux), T.Y(r * uy)]], C("--accent"), 3);
    PP.path(ctx, [[T.X(r * ux), T.Y(r * uy)], [T.X(yx), T.Y(yy)]], C("--fail"), 3);
    PP.label(ctx, "r", T.X(r * ux / 2) - 4, T.Y(r * uy / 2) - 4, C("--accent"), "right", "bottom", 13);
    PP.label(ctx, "t", T.X((r * ux + yx) / 2) + 2, T.Y((r * uy + yy) / 2) - 6, C("--fail"), "left", "bottom", 13);
    PP.dot(ctx, T.X(0), T.Y(0), 4, C("--ink"));
    PP.label(ctx, "x", T.X(0), T.Y(0) + 6, C("--ink"), "center", "top", 13);
    PP.label(ctx, "B[x, r]", T.X(-r * 0.75), T.Y(r * 0.75) - 4, C("--accent"), "right", "bottom", 12);
    PP.dot(ctx, T.X(yx), T.Y(yy), 6, C("--ink"));
    PP.label(ctx, "y", T.X(yx) + 8, T.Y(yy) + 2, C("--ink"), "left", "top", 13);
    PP.label(ctx, "B(y, t)", T.X(yx + t * 0.7), T.Y(yy + t * 0.7) - 2, C("--fail"), "left", "bottom", 12);
    PP.dot(ctx, T.X(zx), T.Y(zy), 5, C("--seq2"));
    PP.label(ctx, "z", T.X(zx) - 6, T.Y(zy) - 4, C("--seq2"), "right", "bottom", 13);
    const dzx = hyp(zx, zy), dzy = hyp(zx - yx, zy - yy);
    PP.read("ejp3-25-read", [
      ["d(y, x)", F3(dy) + " > r = " + F2(r)],
      ["t = d(y, x) − r", F3(t)],
      ["d(z, y)", F3(dzy) + " < t"],
      ["d(x, y) − d(z, y)", F3(dy - dzy) + " > r"],
      ["d(z, x)", F3(dzx) + (dzx > r ? "  > r: z ∉ B[x, r]" : ""), dzx > r ? "good" : "bad"],
    ]);
  }
  PP.register(draw, ["ejp3-25-r"]);
  draggable("ejp3-25-c1", () => TT, (px, py, T) => {
    const r = PP.val("ejp3-25-r") / 100, [yx, yy] = S.y, t = hyp(yx, yy) - r;
    const zx = yx + S.rho * t * Math.cos(S.phi), zy = yy + S.rho * t * Math.sin(S.phi);
    if (near(T, px, py, zx, zy, 16)) return "z";
    return near(T, px, py, yx, yy, 24) ? "y" : null;
  }, (id, x, y) => {
    if (id === "y") { S.y = [x, y]; return; }
    const r = PP.val("ejp3-25-r") / 100, [yx, yy] = S.y, t = hyp(yx, yy) - r;
    S.phi = Math.atan2(y - yy, x - yx); S.rho = clamp(hyp(x - yx, y - yy) / t, 0, 0.95);
  }, draw);
})();

/* ===================== 28 · frontera de (0,1) ∪ {2} ===================== */
function drawE28(ctx, T, yPx) {
  PP.path(ctx, [[T.X(0), yPx], [T.X(1), yPx]], C("--accent"), 4);
  PP.dot(ctx, T.X(0), yPx, 4.5, C("--bg"), C("--accent"));
  PP.dot(ctx, T.X(1), yPx, 4.5, C("--bg"), C("--accent"));
  PP.dot(ctx, T.X(2), yPx, 5, C("--accent"));
  PP.label(ctx, "E", T.X(0.5), yPx + 8, C("--accent"), "center", "top", 13);
}
PP.register(function ej28a() {
  const r = PP.val("ejp3-28-r") / 100;
  PP.out("ejp3-28-r-o", F2(r));
  const { ctx, w, h } = PP.canvas("ejp3-28-c1", 0.42);
  const T = PP.frame(w, h, { x0: -0.6, x1: 2.6, y0: 0, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  const yL = h * 0.66;
  numberLine(ctx, T, yL + 22, [[0, "0"], [1, "1"], [2, "2"]]);
  drawE28(ctx, T, yL);
  const rows = [];
  [[0, -r / 2, r / 2], [1, 1 + r / 2, 1 - r / 2], [2, 2 + r / 2, 2]].forEach(([p, out, inn]) => {
    ballBand(ctx, T, p - r, p + r, yL - 30, C("--fail"), C("--failband"), "B(" + p + ", r)");
    PP.dot(ctx, T.X(out), yL - 30, 4.5, C("--fail"));
    PP.dot(ctx, T.X(inn), yL - 30, 4.5, C("--accent"));
    rows.push(["B(" + p + ", r)", "∋ " + F3(inn) + " ∈ E,  " + F3(out) + " ∈ Eᶜ", "good"]);
  });
  PP.read("ejp3-28-read1", rows);
}, ["ejp3-28-r"]);
(() => {
  const S = { x: 0.35 }; let TT = null;
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp3-28-c2", 0.42);
    const T = PP.frame(w, h, { x0: -0.6, x1: 2.6, y0: 0, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 }); TT = T;
    const yL = h * 0.66;
    numberLine(ctx, T, yL + 22, [[0, "0"], [1, "1"], [2, "2"]]);
    drawE28(ctx, T, yL);
    const x = S.x; let rows;
    const onB = [0, 1, 2].find((p) => Math.abs(x - p) < 1e-9);
    if (onB !== undefined) {
      rows = [["x", F2(x) + " ∈ ∂E"], ["radio", "ninguno sirve: toda bola toca E y Eᶜ", "bad"]];
    } else if (x > 0 && x < 1) {
      const rho = Math.min(x, 1 - x);
      ballBand(ctx, T, x - rho, x + rho, yL - 30, C("--ok"), C("--okband"), "B(x, ρ) ⊆ E");
      rows = [["x ∈ (0, 1)", F3(x)], ["ρ = mín{x, 1 − x}", F3(rho)], ["B(x, ρ) ∩ Eᶜ", "= ∅  ⇒  x ∉ ∂E", "good"]];
    } else {
      const rho = Math.min(Math.abs(x), Math.abs(x - 1), Math.abs(x - 2));
      ballBand(ctx, T, x - rho, x + rho, yL - 30, C("--seq3"), C("--area3"), "B(x, ρ) ⊆ Eᶜ");
      rows = [["x ∉ E", F3(x)], ["ρ = mín{|x|, |x−1|, |x−2|}", F3(rho)], ["B(x, ρ) ∩ E", "= ∅  ⇒  x ∉ ∂E", "good"]];
    }
    PP.dot(ctx, T.X(x), yL - 30, 6, C("--ink"));
    PP.label(ctx, "x", T.X(x), yL - 20, C("--ink"), "center", "top", 13);
    PP.read("ejp3-28-read2", rows);
  }
  PP.register(draw, []);
  draggable("ejp3-28-c2", () => TT, (px, py, T) => Math.abs(px - T.X(S.x)) < 24 ? 1 : null, (id, x) => {
    x = clamp(x, -0.55, 2.55);
    const p = [0, 1, 2].find((q) => Math.abs(x - q) < 0.035);
    S.x = p !== undefined ? p : x;
  }, draw);
})();

/* ===================== 29 · ℤ, (0,1) y ℚ ===================== */
(() => {
  const S = { x: 2.5 }; let TT = null;
  function draw() {
    const set = PP.radio("ejp3-29-set") || "Z";
    const r = PP.val("ejp3-29-r") / 100;
    PP.out("ejp3-29-r-o", F2(r));
    const { ctx, w, h } = PP.canvas("ejp3-29-c1", 0.45);
    const T = PP.frame(w, h, { x0: -1.6, x1: 3.6, y0: 0, y1: 1 }, { l: 12, r: 12, t: 10, b: 10 }); TT = T;
    const yL = h * 0.62;
    numberLine(ctx, T, yL + 22, [[-1, "−1"], [0, "0"], [1, "1"], [2, "2"], [3, "3"]]);
    const x = S.x, a = x - r, b = x + r;
    ballBand(ctx, T, a, b, yL - 32, C("--seq2"), C("--area2"), "B(x, r)");
    let inE, meetE, meetEc, meetEx;
    if (set === "Z") {
      for (let n = -1; n <= 3; n++) PP.dot(ctx, T.X(n), yL, 5, C("--accent"));
      inE = Number.isInteger(x);
      const ints = []; for (let n = Math.ceil(a); n <= Math.floor(b); n++) if (Math.abs(n - x) < r) ints.push(n);
      meetE = ints.length > 0; meetEc = true; meetEx = ints.some((n) => n !== x);
    } else if (set === "I") {
      PP.path(ctx, [[T.X(0), yL], [T.X(1), yL]], C("--accent"), 4);
      PP.dot(ctx, T.X(0), yL, 4.5, C("--bg"), C("--accent")); PP.dot(ctx, T.X(1), yL, 4.5, C("--bg"), C("--accent"));
      inE = x > 0 && x < 1; meetE = b > 0 && a < 1; meetEc = a < 0 || b > 1; meetEx = meetE;
    } else {
      for (let q = 1; q <= 7; q++) for (let p = Math.ceil(-1.6 * q); p <= 3.6 * q; p++) PP.path(ctx, [[T.X(p / q), yL - 6 + q * 0.6], [T.X(p / q), yL + 6 - q * 0.6]], C("--accent"), 1.2);
      inE = null; meetE = meetEc = meetEx = true;
    }
    PP.dot(ctx, T.X(x), yL - 32, 6, C("--ink"));
    PP.label(ctx, "x = " + F2(x), T.X(x), yL - 20, C("--ink"), "center", "top", 12);
    const yn = (v) => (v ? "sí" : "no");
    const rows = [];
    if (inE !== null) rows.push(["x ∈ E", yn(inE)]);
    rows.push(["B(x, r) ∩ E ≠ ∅", yn(meetE), meetE ? "good" : "bad"], ["B(x, r) ∩ Eᶜ ≠ ∅", yn(meetEc), meetEc ? "good" : "bad"], ["B(x, r) ∩ (E ∖ {x}) ≠ ∅", yn(meetEx), meetEx ? "good" : "bad"]);
    PP.read("ejp3-29-read", rows);
  }
  PP.register(draw, ["ejp3-29-r", "input[name=ejp3-29-set]"]);
  draggable("ejp3-29-c1", () => TT, (px, py, T) => Math.abs(px - T.X(S.x)) < 24 ? 1 : null, (id, x) => {
    x = clamp(x, -1.5, 3.5);
    const n = Math.round(x); S.x = Math.abs(x - n) < 0.04 ? n : x;
  }, draw);
})();

/* ===================== 15/09-2 · [a, b) ===================== */
function ab2(cid, sid, mode) {
  return function () {
    const r = PP.val(sid) / 100;
    PP.out(sid + "-o", F2(r));
    const { ctx, w, h } = PP.canvas(cid, 0.36);
    const T = PP.frame(w, h, { x0: -0.7, x1: 1.7, y0: 0, y1: 1 }, { l: 12, r: 12, t: 8, b: 8 });
    const yL = h * 0.62;
    numberLine(ctx, T, yL + 20, [[0, "a"], [1, "b"]]);
    PP.path(ctx, [[T.X(0), yL], [T.X(1), yL]], C("--accent"), 4);
    PP.dot(ctx, T.X(0), yL, 5, C("--accent"));
    PP.dot(ctx, T.X(1), yL, 5, C("--bg"), C("--accent"));
    PP.label(ctx, "E = [a, b)", T.X(0.5), yL + 8, C("--accent"), "center", "top", 12);
    const p = mode === "a" ? 0 : 1;
    ballBand(ctx, T, p - r, p + r, yL - 30, C("--seq2"), C("--area2"), mode === "a" ? "B(a, r)" : "B(b, r)");
    const q = p - r / 2;
    PP.dot(ctx, T.X(q), yL - 30, 5.5, mode === "a" ? C("--fail") : C("--accent"));
    PP.label(ctx, mode === "a" ? "a − r/2 ∉ E" : "b − r/2 ∈ E", T.X(q), yL - 58, mode === "a" ? C("--fail") : C("--accent"), "center", "bottom", 12);
  };
}
PP.register(ab2("ejp3-15-09-2-c1", "ejp3-15-09-2-r1", "a"), ["ejp3-15-09-2-r1"]);
PP.register(ab2("ejp3-15-09-2-c2", "ejp3-15-09-2-r2", "b"), ["ejp3-15-09-2-r2"]);

/* ===================== 15/09-3 · bola cerrada vía r → 0⁺ ===================== */
(() => {
  const S = { P: [1.3, 0.6] }; let TT = null;
  function draw() {
    const r = PP.val("ejp3-15-09-3-r") / 100;
    PP.out("ejp3-15-09-3-r-o", F2(r));
    const { ctx, w, h } = PP.canvas("ejp3-15-09-3-c1", 0.8);
    const T = eqFrame(w, h, -2.3, 2.3, 0); TT = T; const s = scale(T);
    crossAxes(ctx, T);
    PP.circle(ctx, T.X(0), T.Y(0), s, C("--accent"), C("--area"), null, 2);
    PP.label(ctx, "E", T.X(-0.6), T.Y(-0.6), C("--accent"), "center", "middle", 14);
    PP.circle(ctx, T.X(0), T.Y(0), (1 + r) * s, C("--muted"), null, [4, 4], 1.2);
    PP.label(ctx, "radio r + 1", T.X(0), T.Y(-(1 + r)) + 3, C("--muted"), "center", "top", 11);
    const [x, y] = S.P, d = hyp(x, y);
    PP.circle(ctx, T.X(x), T.Y(y), r * s, C("--seq2"), C("--area2"), [5, 3], 1.5);
    const meets = d < 1 + r;
    if (meets) {
      const q = d <= 1 ? [x, y] : [x / d, y / d];
      PP.dot(ctx, T.X(q[0]), T.Y(q[1]), 5, C("--seq2"));
      if (d > 1) PP.label(ctx, "(x̃, ỹ)", T.X(q[0]) - 6, T.Y(q[1]) + 4, C("--seq2"), "right", "top", 12);
    }
    PP.dot(ctx, T.X(x), T.Y(y), 6, C("--ink"));
    PP.label(ctx, "(x, y)", T.X(x) + 8, T.Y(y) - 4, C("--ink"), "left", "bottom", 12);
    PP.read("ejp3-15-09-3-read", [
      ["d₂((x, y), 0)", F3(d)],
      ["B((x, y), r) ∩ E ≠ ∅", meets ? "sí" : "no", meets ? "good" : "bad"],
      ["cota r + 1", F3(1 + r) + (meets ? "  (d₂ < r + 1)" : "")],
      ["¿(x, y) ∈ E?", d <= 1 ? "sí" : "no"],
    ]);
  }
  PP.register(draw, ["ejp3-15-09-3-r"]);
  draggable("ejp3-15-09-3-c1", () => TT, (px, py, T) => near(T, px, py, S.P[0], S.P[1]) ? 1 : null,
    (id, x, y) => { S.P = [clamp(x, -2.2, 2.2), clamp(y, -1.7, 1.7)]; }, draw);
})();

/* ===================== 15/09-4 · supremo e ínfimo en la clausura ===================== */
PP.register(function ej1509_4() {
  const set = PP.radio("ejp3-15-09-4-set") || "ab";
  const r = PP.val("ejp3-15-09-4-r") / 100;
  PP.out("ejp3-15-09-4-r-o", F2(r));
  const { ctx, w, h } = PP.canvas("ejp3-15-09-4-c1", 0.4);
  const T = PP.frame(w, h, { x0: -0.7, x1: 1.7, y0: 0, y1: 1 }, { l: 12, r: 12, t: 8, b: 8 });
  const yL = h * 0.62;
  let rows;
  if (set === "ab") {
    numberLine(ctx, T, yL + 22, [[0, "a"], [1, "b = sup E"]]);
    PP.path(ctx, [[T.X(0), yL], [T.X(1), yL]], C("--accent"), 4);
    PP.dot(ctx, T.X(0), yL, 5, C("--accent")); PP.dot(ctx, T.X(1), yL, 5, C("--bg"), C("--accent"));
    ballBand(ctx, T, 1 - r, 1 + r, yL - 30, C("--seq2"), C("--area2"), "B(sup E, r)");
    const e = Math.max(1 - r / 2, 0.5);
    PP.dot(ctx, T.X(e), yL - 30, 5.5, C("--seq2")); PP.dot(ctx, T.X(e), yL, 5, C("--seq2"));
    rows = [["sup E", "1 = b ∉ E"], ["sup E − r", F3(1 - r) + "  (no es cota superior)"], ["e ∈ E en la bola", F3(e), "good"]];
  } else {
    numberLine(ctx, T, yL + 22, [[0, "0 = ínf E"], [1, "1"]]);
    for (let n = 1; n <= 300; n++) PP.dot(ctx, T.X(1 / n), yL, n < 30 ? 3.2 : 1.6, C("--accent"));
    ballBand(ctx, T, -r, r, yL - 30, C("--seq2"), C("--area2"), "B(ínf E, r)");
    const n0 = Math.floor(1 / r) + 1;
    PP.dot(ctx, T.X(1 / n0), yL - 30, 5.5, C("--seq2")); PP.dot(ctx, T.X(1 / n0), yL, 5, C("--seq2"));
    rows = [["ínf E", "0 ∉ E"], ["primer n con 1/n < r", String(n0)], ["e = 1/" + n0 + " ∈ E en la bola", F3(1 / n0), "good"]];
  }
  PP.read("ejp3-15-09-4-read", rows);
}, ["ejp3-15-09-4-r", "input[name=ejp3-15-09-4-set]"]);

/* ===================== 15/09-5 · la esfera es cerrada ===================== */
function sphere5(cid, rid, y0) {
  const S = { y: y0.slice() }; let TT = null;
  function draw() {
    const { ctx, w, h } = PP.canvas(cid, 0.72);
    const T = eqFrame(w, h, -2.2, 2.2, 0); TT = T; const s = scale(T);
    PP.circle(ctx, T.X(0), T.Y(0), s, C("--accent"), null, null, 3);
    PP.label(ctx, "S(x, r)", T.X(0.75) + 4, T.Y(0.75) - 4, C("--accent"), "left", "bottom", 12);
    PP.dot(ctx, T.X(0), T.Y(0), 4, C("--ink"));
    PP.label(ctx, "x", T.X(0), T.Y(0) + 6, C("--ink"), "center", "top", 13);
    const [yx, yy] = S.y, d = hyp(yx, yy), eps = Math.abs(d - 1);
    let rows;
    if (eps < 0.02) {
      rows = [["d(y, x)", F3(d)], ["caso", "d(y, x) = r: y ∈ S(x, r)", "good"]];
    } else {
      PP.circle(ctx, T.X(yx), T.Y(yy), eps * s, C("--fail"), C("--failband"), [5, 4], 1.5);
      PP.path(ctx, [[T.X(yx), T.Y(yy)], [T.X(yx / d), T.Y(yy / d)]], C("--fail"), 2);
      PP.label(ctx, "ε", T.X((yx + yx / d) / 2) + 4, T.Y((yy + yy / d) / 2) - 4, C("--fail"), "left", "bottom", 13);
      rows = [["d(y, x)", F3(d) + (d > 1 ? " > r = 1" : " < r = 1")], [d > 1 ? "ε = d(y, x) − r" : "ε = r − d(x, y)", F3(eps)],
        ["B(y, ε) ∩ S(x, r)", "= ∅: y no es de adherencia", "bad"]];
    }
    PP.dot(ctx, T.X(yx), T.Y(yy), 6, C("--ink"));
    PP.label(ctx, "y", T.X(yx) + 8, T.Y(yy) - 4, C("--ink"), "left", "bottom", 13);
    PP.read(rid, rows);
  }
  PP.register(draw, []);
  draggable(cid, () => TT, (px, py, T) => near(T, px, py, S.y[0], S.y[1]) ? 1 : null, (id, x, y) => {
    x = clamp(x, -2.1, 2.1); y = clamp(y, -1.5, 1.5);
    const d = hyp(x, y);
    if (Math.abs(d - 1) < 0.03 && d > 0) { x /= d; y /= d; }
    S.y = [x, y];
  }, draw);
}
sphere5("ejp3-15-09-5-c1", "ejp3-15-09-5-read1", [1.55, 0.8]);
sphere5("ejp3-15-09-5-c2", "ejp3-15-09-5-read2", [0.25, 0.3]);

/* ===================== 15/09-6 · racimos m + 1/(n+1) ===================== */
PP.register(function ej1509_6() {
  const r = PP.val("ejp3-15-09-6-r") / 100;
  PP.out("ejp3-15-09-6-r-o", F2(r));
  const { ctx, w, h } = PP.canvas("ejp3-15-09-6-c1", 0.4);
  const T = PP.frame(w, h, { x0: 0.7, x1: 3.7, y0: 0, y1: 1 }, { l: 12, r: 12, t: 8, b: 8 });
  const yL = h * 0.64, m = 2;
  numberLine(ctx, T, yL + 22, [[1, "1"], [2, "2"], [3, "3"]]);
  for (let mm = 1; mm <= 3; mm++) {
    for (let n = 1; n <= 40; n++) PP.dot(ctx, T.X(mm + 1 / (n + 1)), yL, n < 12 ? 3 : 1.6, C("--accent"));
    PP.dot(ctx, T.X(mm), yL, 4.5, C("--bg"), C("--seq3"));
  }
  ballBand(ctx, T, m - r, m + r, yL - 30, C("--seq2"), C("--area2"), "B(m, r), m = 2");
  const k = Math.floor(1 / r) + 1, q = m + 1 / (k + 1);
  PP.dot(ctx, T.X(q), yL - 30, 5.5, C("--seq2")); PP.dot(ctx, T.X(q), yL, 5, C("--seq2"));
  PP.read("ejp3-15-09-6-read", [
    ["k con 1/k < r", k + "   (1/k = " + F3(1 / k) + ")"],
    ["m + 1/(k+1) ∈ A", F3(q) + " ∈ (" + F3(m - r) + ", " + F3(m + r) + ")", "good"],
    ["m = 2 ∈ A", "no (círculo verde hueco); sí en la clausura"],
  ]);
}, ["ejp3-15-09-6-r"]);

/* ===================== guía-2 · derivado de la imagen de una sucesión ===================== */
(() => {
  const S = { b: [1.3, 0.55] }; let TT = null;
  const an = (n) => [Math.cos(2.2 * n) / n, Math.sin(2.2 * n) / n];
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp3-guia-2-c1", 0.78);
    const T = eqFrame(w, h, -1.3, 2.3, 0); TT = T; const s = scale(T);
    const [bx, by] = S.b, lam = hyp(bx, by);
    const N = 80;
    if (lam < 0.03) {
      for (let n = 1; n <= N; n++) { const [x, y] = an(n); PP.dot(ctx, T.X(x), T.Y(y), n < 20 ? 3.5 : 2, C("--accent")); }
      PP.dot(ctx, T.X(0), T.Y(0), 5, C("--ink"));
      PP.label(ctx, "b = a", T.X(0) + 8, T.Y(0) - 4, C("--ink"), "left", "bottom", 13);
      PP.read("ejp3-guia-2-read", [["b", "= a: el único candidato a punto de acumulación", "good"]]);
      return;
    }
    const n0 = Math.floor(2 / lam) + 1;
    let r = lam / 2;
    for (let n = 1; n < n0; n++) { const [x, y] = an(n), d = hyp(x - bx, y - by); if (d > 1e-9) r = Math.min(r, d); }
    PP.circle(ctx, T.X(0), T.Y(0), lam / 2 * s, C("--muted"), null, [4, 4], 1.2);
    PP.label(ctx, "B(a, λ/2)", T.X(0), T.Y(-lam / 2) + 3, C("--muted"), "center", "top", 11);
    PP.circle(ctx, T.X(bx), T.Y(by), r * s, C("--ok"), C("--okband"), null, 1.5);
    let inside = 0;
    for (let n = 1; n <= N; n++) {
      const [x, y] = an(n), d = hyp(x - bx, y - by);
      if (d > 1e-9 && d < r) inside++;
      PP.dot(ctx, T.X(x), T.Y(y), n < 20 ? 3.5 : 2, n < n0 ? C("--seq2") : C("--accent"));
    }
    PP.dot(ctx, T.X(0), T.Y(0), 4, C("--ink"));
    PP.label(ctx, "a", T.X(0) - 6, T.Y(0) - 4, C("--ink"), "right", "bottom", 13);
    PP.dot(ctx, T.X(bx), T.Y(by), 6, C("--ink"));
    PP.label(ctx, "b", T.X(bx) + 8, T.Y(by) - 4, C("--ink"), "left", "bottom", 13);
    PP.read("ejp3-guia-2-read", [
      ["λ = d(b, a)", F3(lam)],
      ["n₀ (1/n < λ/2 desde n₀)", String(n0)],
      ["r", F3(r) + (r < lam / 2 - 1e-9 ? "  (lo fija un aₙ con n < n₀)" : "  (= λ/2)")],
      ["términos ≠ b en B(b, r)", String(inside), inside === 0 ? "good" : "bad"],
    ]);
  }
  PP.register(draw, []);
  draggable("ejp3-guia-2-c1", () => TT, (px, py, T) => near(T, px, py, S.b[0], S.b[1]) ? 1 : null, (id, x, y) => {
    x = clamp(x, -1.2, 2.2); y = clamp(y, -1.2, 1.2);
    S.b = hyp(x, y) < 0.05 ? [0, 0] : [x, y];
  }, draw);
})();

/* ===================== C4-1 · {1/n + 1/m} ===================== */
PP.register(function c41() {
  const N = PP.val("ejp3-c4-1-N"), nf = PP.val("ejp3-c4-1-n");
  PP.out("ejp3-c4-1-N-o", String(N)); PP.out("ejp3-c4-1-n-o", String(nf));
  const { ctx, w, h } = PP.canvas("ejp3-c4-1-c1", 0.5);
  const T = PP.frame(w, h, { x0: -0.06, x1: 2.08, y0: 0, y1: 1 }, { l: 16, r: 14, t: 10, b: 10 });
  const y1 = h * 0.3, y2 = h * 0.72;
  for (let n = 1; n <= 40; n++) PP.path(ctx, [[T.X(1 / n), y1 - 14], [T.X(1 / n), y2 + 10]], C("--rule"), 1);
  PP.path(ctx, [[T.X(0), y1 - 14], [T.X(0), y2 + 10]], C("--muted"), 1);
  numberLine(ctx, T, y2 + 22, [[0, "0"], [0.5, "1/2"], [1, "1"], [2, "2"]]);
  PP.path(ctx, [[T.p.l, y1], [w - T.p.r, y1]], C("--muted"), 1);
  PP.path(ctx, [[T.p.l, y2], [w - T.p.r, y2]], C("--muted"), 1);
  PP.label(ctx, "A (n, m ≤ " + N + ")", T.p.l, y1 - 16, C("--muted"), "left", "bottom", 11);
  PP.label(ctx, "fila n = " + nf + ":  1/" + nf + " + 1/m", T.p.l, y2 - 16, C("--muted"), "left", "bottom", 11);
  const pts = new Set();
  for (let n = 1; n <= N; n++) for (let m = 1; m <= N; m++) { const v = 1 / n + 1 / m; pts.add(v.toFixed(12)); PP.dot(ctx, T.X(v), y1, N < 20 ? 2.8 : 1.8, C("--accent")); }
  PP.path(ctx, [[T.X(1 / nf), y2 - 12], [T.X(1 / nf), y2 + 12]], C("--seq2"), 2.5);
  for (let m = 1; m <= N; m++) PP.dot(ctx, T.X(1 / nf + 1 / m), y2, 3, C("--accent"));
  PP.read("ejp3-c4-1-read", [
    ["puntos distintos dibujados", String(pts.size)],
    ["fila n = " + nf + ": más cercano a 1/" + nf, "1/" + nf + " + 1/" + N + "  (a distancia 1/" + N + ")"],
  ]);
}, ["ejp3-c4-1-N", "ejp3-c4-1-n"]);

/* ===================== C4-2 · semiplano y > x ===================== */
function halfPlane(ctx, T) {
  const L = 50;
  PP.path(ctx, [[T.X(-L), T.Y(-L)], [T.X(L), T.Y(L)], [T.X(-L), T.Y(L)]], null, 1, null, true, C("--band"));
  PP.path(ctx, [[T.X(-L), T.Y(-L)], [T.X(L), T.Y(L)]], C("--accent"), 1.5, [6, 4]);
}
(() => {
  const S = { a: [-0.5, 0.7] }; let TT = null;
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp3-c4-2-c1", 0.78);
    const T = eqFrame(w, h, -2, 2, 0); TT = T; const s = scale(T);
    crossAxes(ctx, T, "x", "y");
    halfPlane(ctx, T);
    PP.label(ctx, "A: y > x", T.X(-1.7), T.Y(1.5), C("--accent"), "left", "middle", 13);
    PP.label(ctx, "y = x", T.X(1.5) + 4, T.Y(1.5), C("--accent"), "left", "middle", 11);
    const [a1, a2] = S.a, r = (a2 - a1) / 2;
    PP.rect(ctx, T.X(a1 - r), T.Y(a2 + r), 2 * r * s, 2 * r * s, C("--seq2"), C("--area2"));
    PP.circle(ctx, T.X(a1), T.Y(a2), r * s, C("--seq3"), null, [4, 3], 1.3);
    PP.dot(ctx, T.X(a1 + r), T.Y(a2 - r), 4, C("--bg"), C("--fail"));
    PP.dot(ctx, T.X(a1), T.Y(a2), 6, C("--ink"));
    PP.label(ctx, "a", T.X(a1) + 8, T.Y(a2) - 4, C("--ink"), "left", "bottom", 13);
    PP.label(ctx, "B∞(a, r)", T.X(a1 - r), T.Y(a2 + r) - 3, C("--seq2"), "left", "bottom", 12);
    PP.read("ejp3-c4-2-read1", [
      ["a", "(" + F2(a1) + ", " + F2(a2) + ")"],
      ["r = (a₂ − a₁)/2", F3(r)],
      ["esquina (a₁ + r, a₂ − r)", "sobre y = x: no está en el cuadrado abierto"],
      ["B∞(a, r) ⊆ A", "sí", "good"],
    ]);
  }
  PP.register(draw, []);
  draggable("ejp3-c4-2-c1", () => TT, (px, py, T) => near(T, px, py, S.a[0], S.a[1]) ? 1 : null, (id, x, y) => {
    x = clamp(x, -1.8, 1.6); y = clamp(y, -1.6, 1.8);
    if (y < x + 0.08) y = x + 0.08;
    S.a = [x, y];
  }, draw);
})();
(() => {
  const S = { x: 0.2 }; let TT = null;
  function draw() {
    const M = PP.val("ejp3-c4-2-m");
    PP.out("ejp3-c4-2-m-o", String(M));
    const { ctx, w, h } = PP.canvas("ejp3-c4-2-c2", 0.7);
    const T = eqFrame(w, h, -1.6, 1.8, 0.4); TT = T;
    crossAxes(ctx, T);
    halfPlane(ctx, T);
    const x = S.x;
    for (let m = 1; m <= M; m++) PP.dot(ctx, T.X(x), T.Y(x + 1 / m), m === M ? 5 : 3.5, C("--seq2"));
    PP.label(ctx, "(x, x + 1/m)", T.X(x) + 8, T.Y(x + 1), C("--seq2"), "left", "middle", 12);
    PP.dot(ctx, T.X(x), T.Y(x), 6, C("--ink"));
    PP.label(ctx, "(x, x)", T.X(x) + 8, T.Y(x) + 4, C("--ink"), "left", "top", 12);
  }
  PP.register(draw, ["ejp3-c4-2-m"]);
  draggable("ejp3-c4-2-c2", () => TT, (px, py, T) => near(T, px, py, S.x, S.x) ? 1 : null, (id, x, y) => { S.x = clamp((x + y) / 2, -1.2, 0.9); }, draw);
})();

/* ===================== C4-3 · rectas y = m x ===================== */
(() => {
  const S = { y: 1.1 }; let TT = null;
  function draw() {
    const M = PP.val("ejp3-c4-3-M");
    PP.out("ejp3-c4-3-M-o", String(M));
    const { ctx, w, h } = PP.canvas("ejp3-c4-3-c1", 0.78);
    const T = eqFrame(w, h, -2, 2, 0); TT = T;
    const L = 3;
    for (let m = -M; m <= M; m++) PP.path(ctx, [[T.X(-L), T.Y(-m * L)], [T.X(L), T.Y(m * L)]], C("--accent"), m === 0 ? 1.6 : 1);
    PP.path(ctx, [[T.X(0), 0], [T.X(0), h]], C("--fail"), 1.2, [4, 4]);
    PP.label(ctx, "eje y: en la clausura", T.X(0) + 6, 6, C("--fail"), "left", "top", 11);
    const y = S.y;
    for (let m = 1; m <= M; m++) PP.dot(ctx, T.X(y / m), T.Y(y), 4, C("--seq2"));
    if (Math.abs(y) > 1e-9) PP.dot(ctx, T.X(0), T.Y(y), 6, C("--bg"), C("--fail"));
    else PP.dot(ctx, T.X(0), T.Y(0), 6, C("--ink"));
    PP.label(ctx, "(0, y)", T.X(0) - 8, T.Y(y), C("--fail"), "right", "middle", 12);
    PP.read("ejp3-c4-3-read", [
      ["y", F3(y)],
      ["(y/" + M + ", y) en y = " + M + "x", "a distancia |y|/" + M + " = " + F3(Math.abs(y) / M) + " de (0, y)"],
      ["(0, y) ∈ A", Math.abs(y) > 1e-9 ? "no" : "sí (el origen)"],
    ]);
  }
  PP.register(draw, ["ejp3-c4-3-M"]);
  draggable("ejp3-c4-3-c1", () => TT, (px, py, T) => near(T, px, py, 0, S.y) ? 1 : null, (id, x, y) => { y = clamp(y, -1.4, 1.4); S.y = Math.abs(y) < 0.04 ? 0 : y; }, draw);
})();

/* ===================== C4-4b · A + b ===================== */
(() => {
  const S = { a: [-1.25, 0.35], b: [2.4, 1.0] }; let TT = null;
  const c = [-1, 0];
  function draw() {
    const { ctx, w, h } = PP.canvas("ejp3-c4-4b-c1", 0.72);
    const T = eqFrame(w, h, -2.4, 3.2, 0.5); TT = T; const s = scale(T);
    crossAxes(ctx, T);
    const [bx, by] = S.b, [ax, ay] = S.a;
    PP.circle(ctx, T.X(c[0]), T.Y(c[1]), s, C("--accent"), C("--band"), [6, 4], 1.6);
    PP.circle(ctx, T.X(c[0] + bx), T.Y(c[1] + by), s, C("--seq3"), C("--area3"), [6, 4], 1.6);
    PP.label(ctx, "A", T.X(c[0] - 0.75), T.Y(c[1] - 0.75), C("--accent"), "center", "middle", 14);
    PP.label(ctx, "A + b", T.X(c[0] + bx + 0.8), T.Y(c[1] + by - 0.8), C("--seq3"), "center", "middle", 13);
    PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(bx), T.Y(by)]], C("--ink"), 2);
    PP.dot(ctx, T.X(bx), T.Y(by), 5, C("--ink"));
    PP.label(ctx, "b", T.X(bx) + 8, T.Y(by), C("--ink"), "left", "middle", 13);
    const r = Math.max(0.05, (1 - hyp(ax - c[0], ay - c[1])) * 0.85);
    PP.circle(ctx, T.X(ax), T.Y(ay), r * s, C("--seq2"), C("--area2"), null, 1.5);
    PP.circle(ctx, T.X(ax + bx), T.Y(ay + by), r * s, C("--seq2"), C("--area2"), null, 1.5);
    PP.path(ctx, [[T.X(ax), T.Y(ay)], [T.X(ax + bx), T.Y(ay + by)]], C("--muted"), 1, [4, 4]);
    PP.dot(ctx, T.X(ax), T.Y(ay), 5, C("--ink"));
    PP.label(ctx, "a", T.X(ax) - 6, T.Y(ay) - 4, C("--ink"), "right", "bottom", 13);
    PP.dot(ctx, T.X(ax + bx), T.Y(ay + by), 4, C("--seq2"));
    PP.label(ctx, "x = a + b", T.X(ax + bx) + 6, T.Y(ay + by) - 4, C("--seq2"), "left", "bottom", 12);
    PP.read("ejp3-c4-4b-read", [
      ["r (con B(a, r) ⊆ A)", F3(r)],
      ["y ∈ B(x, r)  ⇒  y − b ∈ B(a, r)", "⇒ y ∈ A + b", "good"],
    ]);
  }
  PP.register(draw, []);
  draggable("ejp3-c4-4b-c1", () => TT, (px, py, T) => near(T, px, py, S.a[0], S.a[1], 16) ? "a" : near(T, px, py, S.b[0], S.b[1]) ? "b" : null, (id, x, y) => {
    if (id === "b") { S.b = [clamp(x, 0.8, 2.8), clamp(y, -1.2, 2.0)]; return; }
    const dx = x - c[0], dy = y - c[1], d = hyp(dx, dy);
    S.a = d < 0.9 ? [x, y] : [c[0] + dx / d * 0.9, c[1] + dy / d * 0.9];
  }, draw);
})();

/* ===================== C4-5 · no abierto ⇒ sucesión desde afuera ===================== */
PP.register(function c45() {
  const n = PP.val("ejp3-c4-5-n");
  PP.out("ejp3-c4-5-n-o", String(n));
  const { ctx, w, h } = PP.canvas("ejp3-c4-5-c1", 0.7);
  const T = eqFrame(w, h, -1.4, 1.4, 0); const s = scale(T);
  PP.rect(ctx, 0, 0, w, T.Y(0), null, C("--band"));
  PP.path(ctx, [[0, T.Y(0)], [w, T.Y(0)]], C("--accent"), 2.5);
  PP.label(ctx, "A = {y ≥ 0}", 8, 8, C("--accent"), "left", "top", 13);
  for (let k = 1; k <= n; k++) {
    PP.circle(ctx, T.X(0), T.Y(0), s / k, k === n ? C("--seq2") : C("--rule"), null, [4, 3], k === n ? 1.6 : 1);
    PP.dot(ctx, T.X(0), T.Y(-1 / (2 * k)), k === n ? 5 : 3.5, C("--fail"));
  }
  PP.label(ctx, "B(a, 1/" + n + ")", T.X(0.72 / n) + 4, T.Y(0.72 / n) - 2, C("--seq2"), "left", "bottom", 12);
  PP.label(ctx, "x" + (n < 10 ? "₀₁₂₃₄₅₆₇₈₉"[n] : "ₙ") + " ∉ A", T.X(0) + 8, T.Y(-1 / (2 * n)), C("--fail"), "left", "middle", 12);
  PP.dot(ctx, T.X(0), T.Y(0), 5, C("--ink"));
  PP.label(ctx, "a", T.X(0) - 6, T.Y(0) - 4, C("--ink"), "right", "bottom", 13);
}, ["ejp3-c4-5-n"]);

/* ===================== C4-8 · métricas equivalentes ===================== */
PP.register(function c48() {
  const eps = PP.val("ejp3-c4-8-eps") / 100;
  PP.out("ejp3-c4-8-eps-o", F2(eps));
  const { ctx, w, h } = PP.canvas("ejp3-c4-8-c1", 0.78);
  const T = eqFrame(w, h, -1.45, 1.45, 0); const s = scale(T);
  const rp = eps / Math.SQRT2;
  PP.circle(ctx, T.X(0), T.Y(0), eps * s, C("--accent"), C("--band"), null, 1.6);
  PP.rect(ctx, T.X(-rp), T.Y(rp), 2 * rp * s, 2 * rp * s, C("--seq3"), C("--area3"));
  const N = 70, pts = [];
  for (let n = 1; n <= N; n++) pts.push([1.2 * Math.cos(n) / n, Math.sin(n) / n]);
  let last = 0;
  pts.forEach(([x, y], i) => { if (Math.max(Math.abs(x), Math.abs(y)) >= rp) last = i + 1; });
  const nt = last + 1;
  let maxd2 = 0;
  pts.forEach(([x, y], i) => { const n = i + 1; if (n >= nt) maxd2 = Math.max(maxd2, hyp(x, y)); PP.dot(ctx, T.X(x), T.Y(y), n < 15 ? 3.5 : 2, n >= nt ? C("--accent") : C("--seq2")); });
  PP.dot(ctx, T.X(0), T.Y(0), 3.5, C("--ink"));
  PP.label(ctx, "B₂(x, ε)", T.X(0), T.Y(eps) - 3, C("--accent"), "center", "bottom", 12);
  PP.label(ctx, "B∞(x, r′)", T.X(rp) + 3, T.Y(-rp) + 3, C("--seq3"), "left", "top", 12);
  PP.read("ejp3-c4-8-read", [
    ["r′ = ε/√2", F3(rp)],
    ["ñ (d∞(xₙ, x) < r′ desde ñ)", String(nt)],
    ["máx d₂(xₙ, x), n ≥ ñ", F3(maxd2) + " < ε", maxd2 < eps ? "good" : "bad"],
  ]);
}, ["ejp3-c4-8-eps"]);

/* ===================== 30 · convergencia uniforme ===================== */
PP.register(function e30() {
  const n = PP.val("ejp3-30-n"), eps = PP.val("ejp3-30-eps") / 100;
  PP.out("ejp3-30-n-o", String(n)); PP.out("ejp3-30-eps-o", F2(eps));
  const { ctx, w, h } = PP.canvas("ejp3-30-c1", 0.66);
  const T = PP.frame(w, h, { x0: 0.6, x1: 5.0, y0: 0, y1: 4.2 }, { l: 30, r: 14, t: 12, b: 28 });
  const f = (t) => 2.0 + 0.3 * Math.sin(t * 1.9 + 0.3) + 0.12 * t;
  const g = (t) => 0.9 * Math.sin(1.9 * (t - 1) - 1.2);
  const fn = (t) => f(t) + g(t) / n;
  const xs = []; for (let i = 0; i <= 120; i++) xs.push(1 + i * 3.5 / 120);
  const up = xs.map((t) => [T.X(t), T.Y(f(t) + eps)]), lo = xs.map((t) => [T.X(t), T.Y(f(t) - eps)]).reverse();
  PP.path(ctx, up.concat(lo), null, 1, null, true, C("--band"));
  PP.path(ctx, up, C("--muted"), 1, [4, 4]); PP.path(ctx, lo, C("--muted"), 1, [4, 4]);
  PP.axes(ctx, T, { grid: false, xTicks: 5, yTicks: 4 });
  PP.path(ctx, xs.map((t) => [T.X(t), T.Y(f(t))]), C("--accent"), 2.5);
  let sup = 0, inside = true;
  xs.forEach((t) => { const d = Math.abs(fn(t) - f(t)); sup = Math.max(sup, d); if (d >= eps) inside = false; });
  PP.path(ctx, xs.map((t) => [T.X(t), T.Y(fn(t))]), inside ? C("--seq2") : C("--fail"), 1.6);
  [[1, "a"], [4.5, "b"]].forEach(([t, l]) => PP.label(ctx, l, T.X(t), T.Y(0) - 4, C("--ink"), "center", "bottom", 13));
  PP.label(ctx, "f", T.X(4.6), T.Y(f(4.6)), C("--accent"), "left", "middle", 13);
  PP.label(ctx, "fₙ", T.X(4.6), T.Y(fn(4.6)) + (fn(4.6) > f(4.6) ? -8 : 8), inside ? C("--seq2") : C("--fail"), "left", "middle", 13);
  PP.label(ctx, "f + ε", T.X(1) - 2, T.Y(f(1) + eps), C("--muted"), "right", "middle", 11);
  PP.label(ctx, "f − ε", T.X(1) - 2, T.Y(f(1) - eps), C("--muted"), "right", "middle", 11);
  PP.read("ejp3-30-read", [
    ["d∞(fₙ, f) = sup |fₙ − f|", F3(sup)],
    ["ε", F2(eps)],
    ["|fₙ(x) − f(x)| < ε para todo x", inside ? "sí" : "no", inside ? "good" : "bad"],
  ]);
}, ["ejp3-30-n", "ejp3-30-eps"]);

/* ===================== 31 · Cauchy en (C([0,1]), d1) ===================== */
const ramp = (n) => (n < 3 ? [[0, 0], [1, 0]] : [[0, 0], [0.5 - 1 / n, 0], [0.5, 1], [1, 1]]);
function frame31(cid, ratio) {
  const { ctx, w, h } = PP.canvas(cid, ratio || 0.6);
  const T = PP.frame(w, h, { x0: -0.04, x1: 1.06, y0: -0.08, y1: 1.18 }, { l: 30, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { grid: false, xTicks: 4, yTicks: 2 });
  PP.path(ctx, [[T.X(0), T.Y(1)], [T.X(0.5), T.Y(1)]], C("--rule"), 1, [4, 4]);
  PP.path(ctx, [[T.X(0.5), T.Y(0)], [T.X(0.5), T.Y(1)]], C("--rule"), 1, [4, 4]);
  return { ctx, T };
}
const P31 = (T, pts) => pts.map(([x, y]) => [T.X(x), T.Y(y)]);
PP.register(function e31a() {
  const n = PP.val("ejp3-31-n");
  PP.out("ejp3-31-n-o", String(n));
  const { ctx, T } = frame31("ejp3-31-c1");
  [4, 10, 25].forEach((k) => PP.path(ctx, P31(T, ramp(k)), C("--muted"), 1, [3, 3]));
  PP.path(ctx, P31(T, ramp(n)), C("--seq2"), 2.5);
  PP.dot(ctx, T.X(0.5), T.Y(1), 4, C("--ink"));
  PP.label(ctx, "f" + n, T.X(0.5 - 1 / n) - 4, T.Y(0.5), C("--seq2"), "right", "middle", 13);
}, ["ejp3-31-n"]);
PP.register(function e31b() {
  let n = PP.val("ejp3-31-n2"), m = PP.val("ejp3-31-m2");
  PP.out("ejp3-31-n2-o", String(n)); PP.out("ejp3-31-m2-o", String(m));
  const { ctx, T } = frame31("ejp3-31-c2");
  PP.path(ctx, P31(T, [[0.5 - 1 / n, 0], [0.5, 1], [0.5 - 1 / m, 0]]), null, 1, null, true, C("--area2"));
  PP.path(ctx, P31(T, ramp(n)), C("--accent"), 2);
  PP.path(ctx, P31(T, ramp(m)), C("--seq2"), 2, [6, 3]);
  PP.label(ctx, "fₙ", T.X(0.5 - 1 / n) - 4, T.Y(0.35), C("--accent"), "right", "middle", 13);
  PP.label(ctx, "fₘ", T.X(0.5 - 0.5 / m) + 6, T.Y(0.55), C("--seq2"), "left", "middle", 13);
  PP.read("ejp3-31-read2", [
    ["base |1/n − 1/m|", F3(Math.abs(1 / n - 1 / m))],
    ["d₁(fₙ, fₘ) = área", F3(0.5 * Math.abs(1 / n - 1 / m))],
  ]);
}, ["ejp3-31-n2", "ejp3-31-m2"]);
PP.register(function e31c() {
  const n = PP.val("ejp3-31-n3");
  PP.out("ejp3-31-n3-o", String(n));
  const { ctx, T } = frame31("ejp3-31-c3");
  PP.path(ctx, P31(T, [[0.5 - 1 / n, 0], [0.5, 1], [0.5, 0]]), null, 1, null, true, C("--area3"));
  PP.path(ctx, P31(T, ramp(n)), C("--seq2"), 2.2);
  PP.path(ctx, P31(T, [[0, 0], [0.5, 0]]), C("--ink"), 3);
  PP.path(ctx, P31(T, [[0.5, 1], [1, 1]]), C("--ink"), 3);
  PP.dot(ctx, T.X(0.5), T.Y(0), 4.5, C("--ink"));
  PP.dot(ctx, T.X(0.5), T.Y(1), 4.5, C("--bg"), C("--ink"));
  PP.label(ctx, "f", T.X(0.92), T.Y(1) - 6, C("--ink"), "center", "bottom", 13);
  PP.label(ctx, "fₙ", T.X(0.5 - 1 / n) - 4, T.Y(0.4), C("--seq2"), "right", "middle", 13);
  PP.read("ejp3-31-read3", [["d₁(fₙ, f) = 1/(2n)", F3(1 / (2 * n))]]);
}, ["ejp3-31-n3"]);

/* ===================== 32 · truncamientos de π ===================== */
PP.register(function e32() {
  const n = PP.val("ejp3-32-n");
  PP.out("ejp3-32-n-o", String(n));
  const xs = []; for (let k = 1; k <= n; k++) { const p = Math.pow(10, k - 1); xs.push(Math.floor(Math.PI * p) / p); }
  const hw = Math.min(1.5, 1.2 * Math.pow(10, -(n - 2)));
  const { ctx, w, h } = PP.canvas("ejp3-32-c1", 0.36);
  const T = PP.frame(w, h, { x0: Math.PI - hw, x1: Math.PI + hw, y0: 0, y1: 1 }, { l: 14, r: 14, t: 8, b: 8 });
  const yL = h * 0.5;
  PP.path(ctx, [[T.p.l, yL], [w - T.p.r, yL]], C("--muted"), 1);
  xs.forEach((x, i) => { if (x >= T.box.x0) { PP.dot(ctx, T.X(x), yL, i === n - 1 ? 5.5 : 3.5, C("--accent")); } });
  const xn = xs[n - 1];
  if (n > 1) PP.label(ctx, "x" + "₀₁₂₃₄₅₆₇₈₉"[n - 1], T.X(xs[n - 2]), yL - 10, C("--muted"), "center", "bottom", 11);
  PP.label(ctx, "x" + "₀₁₂₃₄₅₆₇₈₉"[n], T.X(xn), yL - 10, C("--accent"), "center", "bottom", 12);
  PP.dot(ctx, T.X(Math.PI), yL, 5, C("--bg"), C("--fail"));
  PP.label(ctx, "π ∉ ℚ", T.X(Math.PI), yL + 10, C("--fail"), "center", "top", 12);
  PP.read("ejp3-32-read", [
    ["xₙ", xn.toFixed(n - 1).replace(".", ",")],
    ["|π − xₙ|", (Math.PI - xn).toExponential(2).replace(".", ",") + " < 10^−" + (n - 1)],
    ["ventana", "π ± " + PP.fmt(hw, 9).replace(".", ",")],
  ]);
}, ["ejp3-32-n"]);

/* ===================== C5-1 · ℓ∞ es completo ===================== */
PP.register(function c51() {
  const n = PP.val("ejp3-c5-1-n"), eps = PP.val("ejp3-c5-1-eps") / 100;
  PP.out("ejp3-c5-1-n-o", String(n)); PP.out("ejp3-c5-1-eps-o", F2(eps));
  const { ctx, w, h } = PP.canvas("ejp3-c5-1-c1", 0.6);
  const T = PP.frame(w, h, { x0: 0, x1: 41, y0: -2.6, y1: 2.6 }, { l: 32, r: 10, t: 12, b: 26 });
  PP.axes(ctx, T, { xLabel: "k", grid: false, xTicks: 8, yTicks: 4, intX: true });
  const at = (k) => 1.2 * Math.sin(0.7 * k) + 0.5 * Math.cos(0.23 * k);
  let sup = 0, ok = true;
  for (let k = 1; k <= 40; k++) {
    const c = at(k), v = c + Math.cos(k) / n, d = Math.abs(v - c);
    sup = Math.max(sup, d); if (d >= eps) ok = false;
    PP.rect(ctx, T.X(k) - 3, T.Y(c + eps), 6, T.Y(c - eps) - T.Y(c + eps), null, C("--band"));
    PP.dot(ctx, T.X(k), T.Y(c), 2.5, C("--muted"));
    PP.dot(ctx, T.X(k), T.Y(v), 3.2, d < eps ? C("--seq2") : C("--fail"));
  }
  PP.read("ejp3-c5-1-read", [
    ["d∞(aₙ, ã) = supₖ |cos k|/n", F3(sup) + "  (k ≤ 40)"],
    ["ε", F2(eps)],
    ["todas las coordenadas en la banda", ok ? "sí" : "no", ok ? "good" : "bad"],
  ]);
}, ["ejp3-c5-1-n", "ejp3-c5-1-eps"]);

/* ===================== C5-2 · A = ⋃ gráficos de xⁿ, B = circunferencia ===================== */
PP.register(function c52() {
  const N = PP.val("ejp3-c5-2-N");
  PP.out("ejp3-c5-2-N-o", String(N));
  const { ctx, w, h } = PP.canvas("ejp3-c5-2-c1", 0.75);
  const T = eqFrame(w, h, -1.35, 1.45, 0.05); const s = scale(T);
  crossAxes(ctx, T, "x", "y");
  PP.circle(ctx, T.X(0), T.Y(0), s, C("--seq3"), null, [5, 4], 1.4);
  PP.label(ctx, "B", T.X(-0.75), T.Y(0.75) - 4, C("--seq3"), "right", "bottom", 13);
  ctx.save(); ctx.beginPath(); ctx.rect(0, 0, w, h); ctx.clip();
  for (let k = 1; k <= N; k++) {
    const pts = []; for (let i = 0; i <= 160; i++) { const x = -1.3 + i * 2.6 / 160, y = Math.pow(x, k); if (Math.abs(y) < 3) pts.push([T.X(x), T.Y(y)]); }
    PP.path(ctx, pts, C("--accent"), 1.1);
  }
  ctx.restore();
  for (let k = 1; k <= N; k++) PP.dot(ctx, T.X(0.5), T.Y(Math.pow(0.5, k)), 3.5, C("--seq2"));
  PP.dot(ctx, T.X(0.5), T.Y(0), 5, C("--bg"), C("--fail"));
  PP.label(ctx, "(1/2, 0) ∉ A", T.X(0.5) + 6, T.Y(0) + 6, C("--fail"), "left", "top", 12);
  PP.read("ejp3-c5-2-read", [
    ["(1/2, 1/2ⁿ), n = " + N, "(0,5; " + PP.fmt(Math.pow(0.5, N), 5).replace(".", ",") + ")"],
    ["distancia a (1/2, 0)", "1/2" + (N < 10 ? "⁰¹²³⁴⁵⁶⁷⁸⁹"[N] : "ⁿ") + " → 0"],
  ]);
}, ["ejp3-c5-2-N"]);

/* ===================== C5-3 · bolas de d(x, y) = |x| + |y| ===================== */
(() => {
  const S = { x: 1 }; let TT = null;
  function draw() {
    const r = PP.val("ejp3-c5-3-r") / 100;
    PP.out("ejp3-c5-3-r-o", F2(r));
    const { ctx, w, h } = PP.canvas("ejp3-c5-3-c1", 0.4);
    const T = PP.frame(w, h, { x0: -3, x1: 3, y0: 0, y1: 1 }, { l: 12, r: 12, t: 8, b: 8 }); TT = T;
    const yL = h * 0.55;
    numberLine(ctx, T, yL + 22, [[-2, "−2"], [-1, "−1"], [0, "0"], [1, "1"], [2, "2"]]);
    const x = S.x, rest = r - Math.abs(x);
    if (rest > 0) ballBand(ctx, T, -rest, rest, yL, C("--seq2"), C("--area2"), "");
    PP.dot(ctx, T.X(x), yL, 6, C("--seq2"));
    PP.label(ctx, "x", T.X(x), yL - 14, C("--ink"), "center", "bottom", 13);
    PP.read("ejp3-c5-3-read", [
      ["x, |x|", F2(x) + ", " + F2(Math.abs(x))],
      ["r − |x|", F2(rest)],
      ["B_d(x, r)", rest > 0 ? "{x} ∪ (−" + F2(rest) + ", " + F2(rest) + ")" : "{x}", rest > 0 ? "" : "good"],
    ]);
  }
  PP.register(draw, ["ejp3-c5-3-r"]);
  draggable("ejp3-c5-3-c1", () => TT, (px, py, T) => Math.abs(px - T.X(S.x)) < 24 ? 1 : null, (id, x) => {
    x = clamp(x, -2.9, 2.9); const k = Math.round(x); S.x = Math.abs(x - k) < 0.05 ? k : x;
  }, draw);
})();

/* ===================== C5-4 · F = ⋂ {d(x, F) < 1/n} ===================== */
(() => {
  const S = { x: [1.05, -0.85] }; let TT = null;
  const sq = [-1.5, -0.5, -0.5, 0.5]; // x0, x1, y0, y1
  const seg = [[-0.5, 0], [1.3, 0.75]];
  function proj(px, py) {
    const qx = clamp(px, sq[0], sq[1]), qy = clamp(py, sq[2], sq[3]);
    const [[ax, ay], [bx, by]] = seg, vx = bx - ax, vy = by - ay;
    const t = clamp(((px - ax) * vx + (py - ay) * vy) / (vx * vx + vy * vy), 0, 1);
    const sx = ax + t * vx, sy = ay + t * vy;
    return hyp(px - qx, py - qy) <= hyp(px - sx, py - sy) ? [qx, qy] : [sx, sy];
  }
  function draw() {
    const n = PP.val("ejp3-c5-4-n");
    PP.out("ejp3-c5-4-n-o", String(n));
    const { ctx, w, h } = PP.canvas("ejp3-c5-4-c1", 0.72);
    const T = eqFrame(w, h, -2.7, 2.3, 0); TT = T; const s = scale(T);
    // entorno {d(x, F) < 1/n}: se dibuja opaco en un canvas aparte y se pega con transparencia
    const off = document.createElement("canvas"); off.width = ctx.canvas.width; off.height = ctx.canvas.height;
    const o = off.getContext("2d"); const dpr = ctx.canvas.width / w; o.setTransform(dpr, 0, 0, dpr, 0, 0);
    o.strokeStyle = o.fillStyle = C("--accent"); o.lineJoin = o.lineCap = "round"; o.lineWidth = 2 * s / n;
    o.beginPath(); o.rect(T.X(sq[0]), T.Y(sq[3]), (sq[1] - sq[0]) * s, (sq[3] - sq[2]) * s);
    o.moveTo(T.X(seg[0][0]), T.Y(seg[0][1])); o.lineTo(T.X(seg[1][0]), T.Y(seg[1][1]));
    o.stroke(); o.fillRect(T.X(sq[0]), T.Y(sq[3]), (sq[1] - sq[0]) * s, (sq[3] - sq[2]) * s);
    ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.globalAlpha = 0.16; ctx.drawImage(off, 0, 0); ctx.restore();
    PP.rect(ctx, T.X(sq[0]), T.Y(sq[3]), (sq[1] - sq[0]) * s, (sq[3] - sq[2]) * s, C("--accent"), C("--area"));
    PP.path(ctx, [[T.X(seg[0][0]), T.Y(seg[0][1])], [T.X(seg[1][0]), T.Y(seg[1][1])]], C("--accent"), 3);
    PP.label(ctx, "F", T.X(-1), T.Y(0), C("--accent"), "center", "middle", 15);
    PP.label(ctx, "{d(x, F) < 1/" + n + "}", T.X(sq[0]) - 4, T.Y(sq[3] + 1 / n) - 4, C("--accent"), "left", "bottom", 12);
    const [x, y] = S.x, [qx, qy] = proj(x, y), d = hyp(x - qx, y - qy);
    PP.path(ctx, [[T.X(x), T.Y(y)], [T.X(qx), T.Y(qy)]], C("--seq2"), 1.5, [4, 3]);
    PP.dot(ctx, T.X(qx), T.Y(qy), 4.5, C("--seq2"));
    PP.dot(ctx, T.X(x), T.Y(y), 6, C("--ink"));
    PP.label(ctx, "x", T.X(x) + 8, T.Y(y) + 2, C("--ink"), "left", "top", 13);
    const inN = d < 1 / n;
    PP.read("ejp3-c5-4-read", [
      ["d(x, F)", F3(d)],
      ["1/n", F3(1 / n)],
      ["x ∈ {d(x, F) < 1/n}", inN ? "sí" : "no", inN ? "good" : "bad"],
      ["primer n que lo deja afuera", d > 0 ? String(Math.ceil(1 / d - 1e-12) + (Number.isInteger(1 / d) ? 0 : 0)) : "ninguno: x ∈ F"],
    ]);
  }
  PP.register(draw, ["ejp3-c5-4-n"]);
  draggable("ejp3-c5-4-c1", () => TT, (px, py, T) => near(T, px, py, S.x[0], S.x[1]) ? 1 : null, (id, x, y) => { S.x = [clamp(x, -2.6, 2.2), clamp(y, -1.6, 1.6)]; }, draw);
})();

/* ===================== C5-5 · colas encajadas ===================== */
PP.register(function c55() {
  const k = PP.val("ejp3-c5-5-k");
  PP.out("ejp3-c5-5-k-o", String(k));
  const { ctx, w, h } = PP.canvas("ejp3-c5-5-c1", 0.75);
  const T = eqFrame(w, h, -0.62, 0.62, 0); const s = scale(T);
  const a = (n) => [0.4 * Math.cos(n) / n, 0.4 * Math.sin(n) / n];
  const nk = k;
  for (let j = 1; j < k; j++) PP.circle(ctx, T.X(0), T.Y(0), 0.5 / j * s, C("--rule"), null, [3, 3], 1);
  PP.circle(ctx, T.X(0), T.Y(0), 0.5 / k * s, C("--seq2"), C("--area2"), [5, 3], 1.6);
  let diam = 0; const tail = [];
  for (let n = 1; n <= 120; n++) { const p = a(n); if (n >= nk) tail.push(p); PP.dot(ctx, T.X(p[0]), T.Y(p[1]), n < 25 ? 3.4 : 1.8, n >= nk ? C("--accent") : C("--muted")); }
  for (let i = 0; i < Math.min(tail.length, 60); i++) for (let j = i + 1; j < tail.length; j++) diam = Math.max(diam, hyp(tail[i][0] - tail[j][0], tail[i][1] - tail[j][1]));
  PP.dot(ctx, T.X(0), T.Y(0), 3, C("--ink"));
  PP.read("ejp3-c5-5-read", [
    ["nₖ", String(nk)],
    ["diam {aₙ : n ≥ nₖ}", F3(diam) + " ≤ 1/k = " + F3(1 / k), diam <= 1 / k ? "good" : "bad"],
  ]);
}, ["ejp3-c5-5-k"]);

/* ===================== C5-6 · una Cauchy en una bola cerrada ===================== */
PP.register(function c56() {
  const { ctx, w, h } = PP.canvas("ejp3-c5-6-c1", 0.9);
  const L = [0.35, -0.15];
  const a = (n) => [L[0] + 1.25 * Math.pow(0.86, n) * Math.cos(1.1 * n), L[1] + 1.25 * Math.pow(0.86, n) * Math.sin(1.1 * n)];
  const a1 = a(1); let M = 0; const pts = [];
  for (let n = 1; n <= 60; n++) { const p = a(n); pts.push(p); M = Math.max(M, hyp(p[0] - a1[0], p[1] - a1[1])); }
  const T = eqFrame(w, h, a1[0] - 1.35 * M, a1[0] + 1.35 * M, a1[1]); const s = scale(T);
  PP.circle(ctx, T.X(a1[0]), T.Y(a1[1]), M * s, C("--accent"), C("--band"), null, 2);
  PP.path(ctx, pts.map(([x, y]) => [T.X(x), T.Y(y)]), C("--rule"), 1);
  pts.forEach(([x, y], i) => PP.dot(ctx, T.X(x), T.Y(y), i < 20 ? 3.4 : 1.8, C("--seq2")));
  PP.dot(ctx, T.X(a1[0]), T.Y(a1[1]), 5, C("--ink"));
  PP.label(ctx, "a₁", T.X(a1[0]) + 7, T.Y(a1[1]) - 3, C("--ink"), "left", "bottom", 13);
  PP.dot(ctx, T.X(L[0]), T.Y(L[1]), 4, C("--bg"), C("--ink"));
  PP.label(ctx, "B̄(a₁, M)", T.X(a1[0]), T.Y(a1[1] + M) - 4, C("--accent"), "center", "bottom", 12);
  PP.read("ejp3-c5-6-read", [["M = máx d(a₁, aₙ)", F3(M)], ["límite", "dentro de la bola cerrada", "good"]]);
}, []);
