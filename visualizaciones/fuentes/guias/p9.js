/* Dibujos de la guía 9 (funciones medibles e integración). Usa window.PP. */
const ID = "guiap9";
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const fx = (x, d) => PP.fmt(x, d === undefined ? 3 : d);
const SUB = "₀₁₂₃₄₅₆₇₈₉";
const sub = (n) => String(n).split("").map((d) => SUB[+d]).join("");

function clipPlot(ctx, T) {
  ctx.beginPath();
  ctx.rect(T.p.l, T.p.t, T.w - T.p.l - T.p.r, T.h - T.p.t - T.p.b);
  ctx.clip();
}

/* Gráfico de f en [x0, x1], cortado al marco. */
function curve(ctx, T, f, x0, x1, color, width, dash, N) {
  N = N || 600;
  ctx.save(); clipPlot(ctx, T);
  ctx.beginPath(); ctx.strokeStyle = color; ctx.lineWidth = width || 1.5; ctx.setLineDash(dash || []);
  let pen = false;
  for (let i = 0; i <= N; i++) {
    const x = x0 + (x1 - x0) * i / N, y = f(x);
    if (!isFinite(y)) { pen = false; continue; }
    if (pen) ctx.lineTo(T.X(x), T.Y(y)); else { ctx.moveTo(T.X(x), T.Y(y)); pen = true; }
  }
  ctx.stroke(); ctx.restore();
}

/* Región entre el gráfico de f y g (por defecto, el eje) sobre [a, b]. */
function fillBetween(ctx, T, f, a, b, color, g) {
  if (b <= a) return;
  g = g || (() => 0);
  const N = 200, pts = [];
  for (let i = 0; i <= N; i++) { const x = a + (b - a) * i / N; pts.push([T.X(x), T.Y(f(x))]); }
  for (let i = N; i >= 0; i--) { const x = a + (b - a) * i / N; pts.push([T.X(x), T.Y(g(x))]); }
  ctx.save(); clipPlot(ctx, T); PP.path(ctx, pts, null, 0, null, true, color); ctx.restore();
}

/* Simpson en [a, b]. */
function simpson(f, a, b, n) {
  n = n || 400; if (b <= a) return 0;
  const h = (b - a) / n; let s = f(a) + f(b);
  for (let i = 1; i < n; i++) s += (i % 2 ? 4 : 2) * f(a + i * h);
  return s * h / 3;
}

/* Tramos de [x0, x1] donde vale cond(x) (muestreo). */
function runs(cond, x0, x1, N) {
  N = N || 1200;
  const out = []; let start = null;
  for (let i = 0; i <= N; i++) {
    const x = x0 + (x1 - x0) * i / N, ok = cond(x);
    if (ok && start === null) start = x;
    if (!ok && start !== null) { out.push([start, x0 + (x1 - x0) * (i - 1) / N]); start = null; }
  }
  if (start !== null) out.push([start, x1]);
  return out;
}
function runsText(R, x0, x1, strict) {
  if (!R.length) return "∅";
  return "≈ " + R.map(([a, b]) => {
    const l = Math.abs(a - x0) < 1e-9 ? "[" : strict ? "(" : "[";
    const r = Math.abs(b - x1) < 1e-9 ? "]" : strict ? ")" : "]";
    return Math.abs(b - a) < 1e-9 ? "{" + fx(a, 2) + "}" : l + fx(a, 2) + ", " + fx(b, 2) + r;
  }).join(" ∪ ");
}
/* Marca los tramos R sobre el eje y en el gráfico. */
function markRuns(ctx, T, R, f) {
  R.forEach(([a, b]) => {
    PP.rect(ctx, T.X(a), T.p.t, Math.max(2, T.X(b) - T.X(a)), T.h - T.p.t - T.p.b, null, C("--okband"));
  });
}
function markRunsTop(ctx, T, R, f) {
  R.forEach(([a, b]) => {
    if (f) curve(ctx, T, f, a, b, C("--ok"), 3.2, null, Math.max(20, Math.round((b - a) * 600)));
    ctx.save(); ctx.strokeStyle = C("--ok"); ctx.lineWidth = 5;
    ctx.beginPath(); ctx.moveTo(T.X(a), T.Y(0)); ctx.lineTo(Math.max(T.X(b), T.X(a) + 2), T.Y(0)); ctx.stroke(); ctx.restore();
  });
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

/* Recta horizontal y = a, arrastrable. */
function levelLine(ctx, T, a, label) {
  PP.path(ctx, [[T.p.l, T.Y(a)], [T.w - T.p.r, T.Y(a)]], C("--seq2"), 1.8, [6, 4]);
  PP.dot(ctx, T.w - T.p.r - 10, T.Y(a), 6, C("--panel"), C("--seq2"));
  PP.label(ctx, label || "y = a", T.w - T.p.r - 20, T.Y(a) - 5, C("--seq2"), "right", "bottom", 12);
}

/* ===================== Ejercicio 1 ===================== */
(function () {
  const IV = [[0, 0.25], [0.25, 0.5], [0.5, 0.8], [0.8, 1]];
  const S = { v: [0.8, -0.6, 0.3, -1.2] };
  let lastT = null;
  const steps = (ctx, T, vals, color, width) => {
    vals.forEach((v, i) => {
      const [a, b] = IV[i];
      PP.path(ctx, [[T.X(a), T.Y(v)], [T.X(b), T.Y(v)]], color, width);
      PP.dot(ctx, T.X(a), T.Y(v), 4, color);
      if (i < IV.length - 1) PP.dot(ctx, T.X(b), T.Y(v), 4, C("--bg"), color);
      else PP.dot(ctx, T.X(b), T.Y(v), 4, color);
    });
  };
  const draw = function ej1() {
    const showAbs = document.getElementById(ID + "-ej1-abs").checked;
    const { ctx, w, h } = PP.canvas(ID + "-ej1-c", 0.6);
    const T = PP.frame(w, h, { x0: -0.03, x1: 1.03, y0: -1.65, y1: 1.65 }, { l: 36, r: 12, t: 12, b: 28 });
    lastT = T;
    PP.axes(ctx, T, { xLabel: "x", yTicks: 6, xTicks: 5 });
    IV.forEach(([a, b], i) => PP.label(ctx, "A" + sub(i + 1), T.X((a + b) / 2), T.h - T.p.b - 4, C("--muted"), "center", "bottom", 11));
    steps(ctx, T, S.v, C("--accent"), showAbs ? 4.5 : 3);
    if (showAbs) steps(ctx, T, S.v.map(Math.abs), C("--seq2"), 2);
    PP.label(ctx, "f", T.X(0.02), T.Y(S.v[0]) - 6, C("--accent"), "left", "bottom", 13);
    const rows = [["valores de f", S.v.map((v) => fx(v, 2)).join(", ")]];
    if (showAbs) rows.push(["valores de |f|", S.v.map((v) => fx(Math.abs(v), 2)).join(", ")]);
    PP.read(ID + "-ej1-read", rows);
  };
  PP.register(draw, [ID + "-ej1-abs"]);
  draggable(ID + "-ej1-c", () => lastT,
    (px, py, T) => {
      const x = T.iX(px);
      const i = IV.findIndex(([a, b]) => x >= a && x <= b);
      return i >= 0 && Math.abs(py - T.Y(S.v[i])) < 22 ? i : null;
    },
    (i, x, y) => { S.v[i] = clamp(Math.round(y * 20) / 20, -1.5, 1.5); }, draw);
})();

/* ===================== Ejercicio 2 ===================== */
(function () {
  const f = (x) => 0.45 + 0.3 * Math.sin(9 * x) + 0.3 * x;
  const S = { a: 0.62 };
  const OPS = {
    gt: [(v, a) => v > a, "f(x) > a", true],
    le: [(v, a) => v <= a, "f(x) ≤ a", false],
    ge: [(v, a) => v >= a, "f(x) ≥ a", false],
    lt: [(v, a) => v < a, "f(x) < a", true],
  };
  let lastT = null;
  const draw = function ej2() {
    const op = OPS[PP.radio(ID + "-ej2-op") || "gt"];
    const { ctx, w, h } = PP.canvas(ID + "-ej2-c", 0.6);
    const T = PP.frame(w, h, { x0: -0.03, x1: 1.03, y0: -0.08, y1: 1.2 }, { l: 36, r: 12, t: 12, b: 28 });
    lastT = T;
    const R = runs((x) => op[0](f(x), S.a), 0, 1);
    markRuns(ctx, T, R);
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 5 });
    curve(ctx, T, f, 0, 1, C("--accent"), 2);
    markRunsTop(ctx, T, R, f);
    levelLine(ctx, T, S.a);
    PP.read(ID + "-ej2-read", [
      ["a", fx(S.a, 2)],
      ["{x ∈ X : " + op[1] + "}", runsText(R, 0, 1, op[2])],
    ]);
  };
  PP.register(draw, ["input[name=" + ID + "-ej2-op]"]);
  draggable(ID + "-ej2-c", () => lastT,
    (px, py, T) => (Math.abs(py - T.Y(S.a)) < 22 ? "a" : null),
    (k, x, y) => { S.a = clamp(Math.round(y * 100) / 100, 0, 1.15); }, draw);
})();

/* ===================== Ejercicio 3 ===================== */
(function () {
  const f = (x) => 0.5 + 0.35 * Math.sin(7 * x);
  const g = (x) => 0.3 + 0.5 * x;
  const P = [[0.2, 0.15], [0.45, 0.95], [0.7, 0.2], [0.9, 1.0]];
  const S = { a: 0.7 };
  let lastT = null, lastIt = "a";
  const draw = function ej3() {
    const it = PP.radio(ID + "-ej3-it") || "a";
    lastIt = it;
    const { ctx, w, h } = PP.canvas(ID + "-ej3-c", 0.6);
    const T = PP.frame(w, h, { x0: -0.03, x1: 1.03, y0: -0.08, y1: 1.12 }, { l: 36, r: 12, t: 12, b: 28 });
    lastT = T;
    if (it === "b") {
      const R = runs((x) => f(x) <= g(x), 0, 1);
      markRuns(ctx, T, R);
      PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 5 });
      curve(ctx, T, g, 0, 1, C("--seq2"), 2);
      curve(ctx, T, f, 0, 1, C("--accent"), 2);
      markRunsTop(ctx, T, R, null);
      PP.label(ctx, "f", T.X(0.02), T.Y(f(0.02)) - 6, C("--accent"), "left", "bottom", 13);
      PP.label(ctx, "g", T.X(1), T.Y(g(1)) + 6, C("--seq2"), "right", "top", 13);
      PP.read(ID + "-ej3-read", [["{x ∈ E : f(x) ≤ g(x)}", runsText(R, 0, 1, false)]]);
      return;
    }
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 5 });
    if (it === "a") {
      curve(ctx, T, f, 0, 1, C("--accent"), 2);
      levelLine(ctx, T, S.a);
      const roots = [], N = 2000;
      for (let i = 0; i < N; i++) {
        const x0 = i / N, x1 = (i + 1) / N, u = f(x0) - S.a, v = f(x1) - S.a;
        if (u === 0) roots.push(x0);
        else if (u * v < 0) roots.push(x0 + (x1 - x0) * u / (u - v));
      }
      roots.forEach((r) => {
        PP.path(ctx, [[T.X(r), T.Y(S.a)], [T.X(r), T.Y(0)]], C("--ok"), 1, [3, 3]);
        PP.dot(ctx, T.X(r), T.Y(0), 5, C("--ok"));
        PP.dot(ctx, T.X(r), T.Y(S.a), 4, C("--ok"));
      });
      PP.read(ID + "-ej3-read", [["a", fx(S.a, 2)], ["{x ∈ E : f(x) = a}", roots.length ? "≈ {" + roots.map((r) => fx(r, 3)).join(", ") + "}" : "∅"]]);
      return;
    }
    // (c)
    curve(ctx, T, f, 0, 1, C("--accent"), 3.5);
    curve(ctx, T, f, 0, 1, C("--seq2"), 1.5, [5, 4]);
    P.forEach(([x, v]) => {
      PP.dot(ctx, T.X(x), T.Y(f(x)), 4.5, C("--bg"), C("--seq2"));
      PP.path(ctx, [[T.X(x), T.Y(f(x))], [T.X(x), T.Y(v)]], C("--muted"), 1, [2, 3]);
      PP.dot(ctx, T.X(x), T.Y(v), 4.5, C("--seq2"));
    });
    PP.label(ctx, "f", T.X(0.02), T.Y(f(0.02)) - 6, C("--accent"), "left", "bottom", 13);
    PP.read(ID + "-ej3-read", [
      ["{x ∈ E : f(x) ≠ g(x)}", "{" + P.map(([x]) => fx(x, 2)).join(", ") + "}"],
      ["g en esos puntos", P.map(([, v]) => fx(v, 2)).join(", ")],
    ]);
  };
  PP.register(draw, ["input[name=" + ID + "-ej3-it]"]);
  draggable(ID + "-ej3-c", () => lastT,
    (px, py, T) => (lastIt === "a" && Math.abs(py - T.Y(S.a)) < 22 ? "a" : null),
    (k, x, y) => { S.a = clamp(Math.round(y * 100) / 100, 0, 1.08); }, draw);
})();

/* ===================== Ejercicio 6 ===================== */
(function () {
  const fa = (x) => 0.5 + 0.35 * Math.sin(5 * x);
  const draw = function ej6() {
    const it = PP.radio(ID + "-ej6-it") || "b";
    const { ctx, w, h } = PP.canvas(ID + "-ej6-c", 0.6);
    const T = PP.frame(w, h, { x0: -0.03, x1: 1.04, y0: -0.08, y1: 1.12 }, { l: 36, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 5 });
    if (it === "a") {
      curve(ctx, T, fa, 0, 1, C("--accent"), 2.4);
      [0, 1].forEach((x) => PP.dot(ctx, T.X(x), T.Y(fa(x)), 4, C("--accent")));
      PP.read(ID + "-ej6-read", [["f(x)", "0.5 + 0.35 sen(5x)"], ["discontinuidades", "ninguna"]]);
      return;
    }
    for (let k = 2; k <= 60; k++) {
      const x = 1 / k;
      if (T.X(x) - T.p.l < 1) break;
      PP.path(ctx, [[T.X(x), T.Y(0) - 5], [T.X(x), T.Y(0) + 5]], C("--fail"), 1.5);
    }
    for (let k = 1; k <= 200; k++) {
      const a = 1 / (k + 1), b = 1 / k;
      PP.path(ctx, [[T.X(a), T.Y(1 / k)], [T.X(b), T.Y(1 / k)]], C("--accent"), 2.4);
      if (k <= 6) {
        PP.dot(ctx, T.X(b), T.Y(1 / k), 3.6, C("--accent"));
        PP.dot(ctx, T.X(a), T.Y(1 / k), 3.6, C("--bg"), C("--accent"));
      }
    }
    PP.dot(ctx, T.X(0), T.Y(0), 3.6, C("--accent"));
    PP.read(ID + "-ej6-read", [
      ["f(x)", "1/k si 1/(k+1) < x ≤ 1/k; f(0) = 0"],
      ["discontinuidades", "1/2, 1/3, 1/4, …", "bad"],
    ]);
  };
  PP.register(draw, ["input[name=" + ID + "-ej6-it]"]);
})();

/* ===================== Ejercicio 7 ===================== */
(function () {
  const f = (n) => (x) => (0.5 + 1 / (n + 1)) * Math.sin(x + n);
  const draw = function ej7() {
    const N = PP.val(ID + "-ej7-N");
    PP.out(ID + "-ej7-N-o", String(N));
    const { ctx, w, h } = PP.canvas(ID + "-ej7-c", 0.6);
    const T = PP.frame(w, h, { x0: 0, x1: 2 * Math.PI, y0: -1.1, y1: 1.1 }, { l: 36, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 6 });
    for (let n = 1; n <= N; n++) curve(ctx, T, f(n), 0, 2 * Math.PI, C("--muted"), 0.9, null, 300);
    const S = (x) => { let m = -Infinity; for (let n = 1; n <= N; n++) m = Math.max(m, f(n)(x)); return m; };
    const I = (x) => { let m = Infinity; for (let n = 1; n <= N; n++) m = Math.min(m, f(n)(x)); return m; };
    curve(ctx, T, S, 0, 2 * Math.PI, C("--ok"), 2.6, null, 800);
    curve(ctx, T, I, 0, 2 * Math.PI, C("--seq2"), 2.6, null, 800);
    PP.read(ID + "-ej7-read", [
      ["máx<sub>n≤N</sub> f<sub>n</sub>(π)", fx(S(Math.PI), 4)],
      ["mín<sub>n≤N</sub> f<sub>n</sub>(π)", fx(I(Math.PI), 4)],
    ]);
  };
  PP.register(draw, [ID + "-ej7-N"]);
})();

/* ===================== Ejercicio 8 ===================== */
(function () {
  const fact = (n) => (n <= 1 ? 1 : n * fact(n - 1));
  const s = (k) => (x) => { let t = 0; for (let n = 1; n <= k; n++) t += Math.pow(x, n) / fact(n); return t; };
  const draw = function ej8() {
    const N = PP.val(ID + "-ej8-N");
    PP.out(ID + "-ej8-N-o", String(N));
    const { ctx, w, h } = PP.canvas(ID + "-ej8-c", 0.6);
    const T = PP.frame(w, h, { x0: 0, x1: 1, y0: 0, y1: 1.8 }, { l: 36, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 5 });
    const cols = [C("--area"), C("--area3"), C("--area2")];
    for (let k = 1; k <= N; k++) fillBetween(ctx, T, s(k), 0, 1, cols[(k - 1) % 3], s(k - 1));
    curve(ctx, T, (x) => Math.exp(x) - 1, 0, 1, C("--muted"), 1.6, [5, 4]);
    curve(ctx, T, s(N), 0, 1, C("--accent"), 2.2);
    PP.label(ctx, "f = eˣ − 1", T.X(0.97), T.Y(Math.E - 1) - 4, C("--muted"), "right", "bottom", 11);
    let tot = 0;
    for (let n = 1; n <= N; n++) tot += 1 / fact(n + 1);
    PP.read(ID + "-ej8-read", [
      ["∫f<sub>1</sub> + … + ∫f<sub>N</sub>", fx(tot, 5)],
      ["∫ f dμ = e − 2", fx(Math.E - 2, 5)],
    ]);
  };
  PP.register(draw, [ID + "-ej8-N"]);
})();

/* ===================== Ejercicio 9 ===================== */
(function () {
  const f = (x) => Math.exp(-((x - 1) * (x - 1)) / 3) * (1 + 0.4 * Math.sin(3 * x));
  const A = [[-2, -1], [0, 1]];
  const draw = function ej9() {
    const y = PP.val(ID + "-ej9-y") / 10;
    PP.out(ID + "-ej9-y-o", fx(y, 1));
    const { ctx, w, h } = PP.canvas(ID + "-ej9-c", 0.95);
    const box = { x0: -4.5, x1: 6, y0: -0.12, y1: 1.5 };
    const T1 = PP.frame(w, h, box, { l: 34, r: 12, t: 10, b: h / 2 + 12 });
    const T2 = PP.frame(w, h, box, { l: 34, r: 12, t: h / 2 + 18, b: 26 });
    const g = (x) => f(x + y);
    [T1, T2].forEach((T) => PP.axes(ctx, T, { yTicks: 3, xTicks: 6 }));
    A.forEach(([a, b]) => fillBetween(ctx, T1, g, a, b, C("--area")));
    A.forEach(([a, b]) => fillBetween(ctx, T2, f, a + y, b + y, C("--area2")));
    curve(ctx, T1, g, box.x0, box.x1, C("--accent"), 2);
    curve(ctx, T2, f, box.x0, box.x1, C("--seq2"), 2);
    A.forEach(([a, b]) => {
      PP.path(ctx, [[T1.X(a), T1.Y(0)], [T1.X(b), T1.Y(0)]], C("--accent"), 4);
      PP.path(ctx, [[T2.X(a + y), T2.Y(0)], [T2.X(b + y), T2.Y(0)]], C("--seq2"), 4);
    });
    PP.label(ctx, "x ↦ f(x + y) sobre A", T1.p.l + 6, T1.p.t + 2, C("--accent"), "left", "top", 12);
    PP.label(ctx, "f sobre A + y", T2.p.l + 6, T2.p.t + 2, C("--seq2"), "left", "top", 12);
    const i1 = A.reduce((s, [a, b]) => s + simpson(g, a, b), 0);
    const i2 = A.reduce((s, [a, b]) => s + simpson(f, a + y, b + y), 0);
    PP.read(ID + "-ej9-read", [
      ["A + y", "[" + fx(-2 + y, 2) + ", " + fx(-1 + y, 2) + "] ∪ [" + fx(y, 2) + ", " + fx(1 + y, 2) + "]"],
      ["∫<sub>A</sub> f(x + y) dμ(x)", fx(i1, 4)],
      ["∫<sub>A+y</sub> f(x) dμ(x)", fx(i2, 4)],
    ]);
  };
  PP.register(draw, [ID + "-ej9-y"]);
})();

/* ===================== Ejercicio 12 ===================== */
(function () {
  const draw = function ej12() {
    const n = PP.val(ID + "-ej12-n");
    PP.out(ID + "-ej12-n-o", String(n));
    const { ctx, w, h } = PP.canvas(ID + "-ej12-c", 0.5);
    const T = PP.frame(w, h, { x0: 0, x1: 32, y0: -1.15, y1: 0.25 }, { l: 40, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yTicks: 3, xTicks: 6 });
    const v = -1 / n;
    PP.rect(ctx, T.X(0), T.Y(0), T.X(n) - T.X(0), T.Y(v) - T.Y(0), null, C("--area2"));
    PP.path(ctx, [[T.X(0), T.Y(v)], [T.X(n), T.Y(v)]], C("--accent"), 2.6);
    PP.path(ctx, [[T.X(n), T.Y(0)], [T.X(32), T.Y(0)]], C("--accent"), 2.6);
    PP.dot(ctx, T.X(0), T.Y(v), 4, C("--accent"));
    PP.dot(ctx, T.X(n), T.Y(v), 4, C("--accent"));
    PP.dot(ctx, T.X(n), T.Y(0), 4, C("--bg"), C("--accent"));
    PP.label(ctx, "fₙ", T.X(n / 2), T.Y(v) + 4, C("--accent"), "center", "top", 12);
    PP.read(ID + "-ej12-read", [
      ["altura en [0, n]", "−1/n = " + fx(v, 4)],
      ["largo del soporte", String(n)],
    ]);
  };
  PP.register(draw, [ID + "-ej12-n"]);
})();

/* ===================== Ejercicio 13 ===================== */
(function () {
  const f = (x) => Math.exp(-x / 2) * Math.cos(2 * x);
  const F = (x) => Math.exp(-x / 2) * (-0.5 * Math.cos(2 * x) + 2 * Math.sin(2 * x)) / 4.25;
  const draw = function ej13() {
    const it = PP.radio(ID + "-ej13-it") || "a";
    const n = PP.val(ID + "-ej13-n");
    PP.out(ID + "-ej13-n-o", String(n));
    const { ctx, w, h } = PP.canvas(ID + "-ej13-c", 0.58);
    const T = PP.frame(w, h, { x0: 0, x1: 12.2, y0: -0.65, y1: 1.08 }, { l: 40, r: 12, t: 12, b: 28 });
    PP.axes(ctx, T, { xLabel: "x", yTicks: 5, xTicks: 6 });
    const total = -F(0);
    if (it === "a") {
      for (let k = 1; k <= n; k++) {
        fillBetween(ctx, T, f, k - 1, k, k % 2 ? C("--area") : C("--area3"));
        PP.path(ctx, [[T.X(k - 1), T.Y(0)], [T.X(k), T.Y(0)]], k % 2 ? C("--accent") : C("--seq3"), 4);
      }
      curve(ctx, T, f, 0, 12.2, C("--ink"), 1.6);
      PP.read(ID + "-ej13-read", [
        ["∫<sub>E<sub>1</sub></sub> f + … + ∫<sub>E<sub>n</sub></sub> f", fx(F(n) - F(0), 5)],
        ["∫<sub>E</sub> f dμ", fx(total, 5)],
      ]);
    } else {
      fillBetween(ctx, T, f, 0, n, C("--area"));
      fillBetween(ctx, T, f, n, 12.2, C("--area2"));
      PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(n), T.Y(0)]], C("--accent"), 4);
      PP.path(ctx, [[T.X(n), T.Y(0)], [T.X(12.2), T.Y(0)]], C("--seq2"), 4);
      curve(ctx, T, f, 0, 12.2, C("--ink"), 1.6);
      PP.label(ctx, "Eₙ", T.X(n / 2), T.Y(0) + 6, C("--accent"), "center", "top", 12);
      PP.read(ID + "-ej13-read", [
        ["∫<sub>E<sub>n</sub></sub> f dμ", fx(F(n) - F(0), 5)],
        ["∫<sub>E \\ E<sub>n</sub></sub> f dμ", fx(-F(n), 5)],
        ["∫<sub>E</sub> f dμ", fx(total, 5)],
      ]);
    }
  };
  PP.register(draw, [ID + "-ej13-n", "input[name=" + ID + "-ej13-it]"]);
})();
