/* Dibujos de los ejemplos de la Práctica 1. Usa window.PP (el build envuelve este archivo). */
const P = "ejp1-";
const C = (t) => PP.css(t);
const SUBS = "₀₁₂₃₄₅₆₇₈₉";
const sub = (n) => String(n).split("").map((d) => (/\d/.test(d) ? SUBS[+d] : d)).join("");
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const F = (x, d) => PP.fmt(x, d === undefined ? 3 : d);
const V = (id) => PP.val(P + id);
const R = (name) => PP.radio(P + name);
const font = (s) => (s || 12) + "px 'IBM Plex Sans', system-ui, sans-serif";

/* Lienzo + marco en coordenadas del problema. */
function setup(id, ratio, box, pad) {
  const { ctx, w, h } = PP.canvas(P + id, ratio);
  const T = PP.frame(w, h, box, pad);
  return { ctx, T, w, h };
}
/* Recta horizontal a la altura y (en coordenadas del marco). */
function hline(ctx, T, y, color, dash, width) {
  if (y < T.box.y0 || y > T.box.y1) return;
  PP.path(ctx, [[T.p.l, T.Y(y)], [T.w - T.p.r, T.Y(y)]], color, width || 1.5, dash);
}
function vline(ctx, T, x, color, dash, width) {
  if (x < T.box.x0 || x > T.box.x1) return;
  PP.path(ctx, [[T.X(x), T.p.t], [T.X(x), T.h - T.p.b]], color, width || 1.5, dash);
}
/* Banda horizontal entre y0 e y1 (recortada al marco). */
function hband(ctx, T, y0, y1, fill) {
  const a = Math.max(Math.min(y0, y1), T.box.y0), b = Math.min(Math.max(y0, y1), T.box.y1);
  if (b <= a) return;
  PP.rect(ctx, T.p.l, T.Y(b), T.w - T.p.l - T.p.r, T.Y(a) - T.Y(b), null, fill);
}
/* Recta real dibujada en la altura y = 0 del marco, con marcas. */
function realLine(ctx, T, ticks, arrow) {
  const y = T.Y(0), x0 = T.p.l, x1 = T.w - T.p.r;
  PP.path(ctx, [[x0, y], [x1, y]], C("--muted"), 1.3);
  if (arrow) PP.path(ctx, [[x1 - 8, y - 4], [x1, y], [x1 - 8, y + 4]], C("--muted"), 1.3);
  (ticks || []).forEach((t) => {
    if (t.x < T.box.x0 || t.x > T.box.x1) return;
    const x = T.X(t.x), col = t.color || C("--muted"), up = !!t.up;
    PP.path(ctx, [[x, y - (t.len || 6)], [x, y + (t.len || 6)]], col, t.w || 1.3);
    if (t.label) PP.label(ctx, t.label, x, up ? y - (t.off || 10) : y + (t.off || 10), col, t.align || "center", up ? "bottom" : "top", t.size || 12);
  });
}
/* Ejes de un gráfico de sucesión (n en x, entero). */
function seqAxes(ctx, T, xLabel, yLabel) { PP.axes(ctx, T, { xLabel: xLabel || "n", yLabel: yLabel || "", intX: true }); }
const dotR = (M) => (M <= 20 ? 4 : M <= 45 ? 3 : M <= 90 ? 2.2 : 1.7);
const ring = (ctx, x, y, r, col) => PP.circle(ctx, x, y, r, col, null, null, 2);
/* Triángulo de "fuera de la ventana". */
function arrowOut(ctx, x, y, up, col) {
  const s = up ? -1 : 1;
  PP.path(ctx, [[x - 5, y], [x + 5, y], [x, y + 7 * s]], null, 1, null, true, col);
}
function frac(p, q) {
  if (q === 1) return String(p).replace("-", "−");
  return String(p).replace("-", "−") + "/" + q;
}
function gcd(a, b) { a = Math.abs(a); b = Math.abs(b); while (b) [a, b] = [b, a % b]; return a || 1; }

/* ===================== Bloque 1 ===================== */

/* Ejemplo 1: elementos 0.99…9 según cantidad de nueves. */
PP.register(function ej1() {
  const k = V("1-k");
  PP.out(P + "1-k-o", String(k));
  const K = 8;
  const { ctx, T } = setup("1-c", 0.62, { x0: -0.6, x1: K + 0.6, y0: -0.05, y1: 1.12 }, { l: 40, r: 14, t: 14, b: 30 });
  PP.axes(ctx, T, { xLabel: "nueves", intX: false, xTicks: 8 });
  hline(ctx, T, 1, C("--ok"), null, 2);
  PP.label(ctx, "1", T.w - T.p.r - 4, T.Y(1) + 4, C("--ok"), "right", "top", 12);
  for (let j = 0; j <= K; j++) {
    const v = 1 - Math.pow(10, -j);
    PP.dot(ctx, T.X(j), T.Y(v), 3.5, C("--accent"));
  }
  const vk = 1 - Math.pow(10, -k), vk1 = 1 - Math.pow(10, -(k + 1));
  PP.dot(ctx, T.X(k), T.Y(vk), 6, C("--seq2"));
  PP.dot(ctx, T.X(k + 1), T.Y(vk1), 6, C("--accent"));
  ring(ctx, T.X(k + 1), T.Y(vk1), 9, C("--accent"));
  PP.label(ctx, k + " nueves", T.X(k), T.Y(vk) + 12, C("--seq2"), "center", "top", 11);
  const str = (n) => (n === 0 ? "0" : "0." + "9".repeat(n));
  PP.read(P + "1-read", [
    ["con k nueves", str(k)],
    ["con k+1 nueves", str(k + 1) + "  (está en A)"],
    ["¿es mayor?", "sí: lo supera en 9·10^−" + (k + 1), "good"],
    ["distancia al 1", "10^−" + k + " → 10^−" + (k + 1)],
  ]);
}, [P + "1-k"]);

/* Ejemplo 3: B = (0,1), punto medio entre t y 1. */
PP.register(function ej3() {
  const t = V("3-t") / 100;
  PP.out(P + "3-t-o", F(t, 2));
  const { ctx, T } = setup("3-c", 0.42, { x0: -0.2, x1: 1.2, y0: -1, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  const y = T.Y(0);
  PP.rect(ctx, T.X(0), y - 7, T.X(1) - T.X(0), 14, null, C("--area"));
  realLine(ctx, T, [{ x: 0, label: "0" }, { x: 1, label: "1 = s", color: C("--ok"), w: 2.5 }]);
  PP.circle(ctx, T.X(0), y, 4.5, C("--accent"), C("--bg"));
  PP.circle(ctx, T.X(1), y, 4.5, C("--accent"), C("--bg"));
  PP.label(ctx, "B = (0, 1)", T.X(0.08), y - 12, C("--accent"), "left", "bottom", 12);
  const x = (t + 1) / 2;
  // arco que muestra el punto medio
  const yA = y - 34;
  PP.path(ctx, [[T.X(t), y - 8], [T.X(t), yA], [T.X(1), yA], [T.X(1), y - 8]], C("--muted"), 1, [3, 3]);
  PP.path(ctx, [[T.X(x), yA - 5], [T.X(x), yA + 5]], C("--muted"), 1);
  PP.label(ctx, "punto medio", T.X(x), yA - 6, C("--muted"), "center", "bottom", 11);
  PP.path(ctx, [[T.X(t), y - 10], [T.X(t), y + 10]], C("--fail"), 2.5);
  PP.label(ctx, "t", T.X(t), y + 12, C("--fail"), "center", "top", 13);
  PP.dot(ctx, T.X(x), y, 6, C("--accent"));
  PP.label(ctx, "x", T.X(x), y + 12, C("--accent"), "center", "top", 13);
  PP.read(P + "3-read", [
    ["t (supuesta cota)", F(t, 3)],
    ["x = (t + 1)/2", F(x, 3)],
    ["¿x ∈ B?", "sí (0 < x < 1)", "good"],
    ["¿x > t?", "sí ⇒ t no es cota", "bad"],
  ]);
}, [P + "3-t"]);

/* Ejemplo 6: ínf {1/n} = 0. */
PP.register(function ej6() {
  const t = V("6-t") / 100;
  PP.out(P + "6-t-o", F(t, 2));
  const { ctx, T } = setup("6-c", 0.42, { x0: -0.07, x1: 1.07, y0: -1, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  const y = T.Y(0);
  realLine(ctx, T, [{ x: 0, label: "0", color: C("--ok"), w: 2.5 }, { x: 1, label: "1" }, { x: 0.5, label: "1/2" }]);
  for (let n = 1; n <= 80; n++) PP.dot(ctx, T.X(1 / n), y, n <= 10 ? 3.6 : 2.2, C("--accent"));
  const n = Math.floor(1 / t) + 1;
  PP.rect(ctx, T.X(0), y - 16, T.X(t) - T.X(0), 32, null, C("--failband"));
  PP.path(ctx, [[T.X(t), y - 18], [T.X(t), y + 18]], C("--fail"), 2.5);
  PP.label(ctx, "t", T.X(t), y - 20, C("--fail"), "center", "bottom", 13);
  ring(ctx, T.X(1 / n), y, 8, C("--ink"));
  PP.label(ctx, "1/" + n, T.X(1 / n), y + 20, C("--ink"), T.X(1 / n) - T.X(0) < 24 ? "left" : "center", "top", 12);
  PP.read(P + "6-read", [
    ["t > 0", F(t, 3)],
    ["n de Arquímedes", String(n) + "  (primer n con 1/n < t)"],
    ["1/n", F(1 / n, 4)],
    ["¿1/n ∈ A y 1/n < t?", "sí ⇒ t no es cota inferior", "bad"],
  ]);
}, [P + "6-t"]);

/* Ejemplo 3 (c): C = {2 − 1/n}. */
PP.register(function ej3c() {
  const N = V("3-2-N");
  PP.out(P + "3-2-N-o", String(N));
  const { ctx, T } = setup("3-2-c", 0.42, { x0: 0.85, x1: 2.12, y0: -1, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  const y = T.Y(0);
  realLine(ctx, T, [{ x: 1, label: "1" }, { x: 1.5, label: "3/2" }, { x: 2, label: "2", color: C("--ok"), w: 2.5 }]);
  PP.label(ctx, "cota superior", T.X(2), y - 14, C("--ok"), "center", "bottom", 11);
  for (let n = 1; n <= N; n++) PP.dot(ctx, T.X(2 - 1 / n), y, n <= 12 ? 4 : 2.6, C("--accent"));
  PP.read(P + "3-2-read", [
    ["elementos dibujados", String(N)],
    ["el más grande dibujado", "2 − 1/" + N + " = " + F(2 - 1 / N, 4)],
    ["distancia a 2", "1/" + N + " = " + F(1 / N, 4)],
  ]);
}, [P + "3-2-N"]);

/* Ejemplo 3 (d): D = {1/x² > 1/4}. */
PP.register(function ej3d() {
  const x = V("3-3-x") / 10;
  PP.out(P + "3-3-x-o", F(x, 1));
  const { ctx, T } = setup("3-3-c", 0.62, { x0: -4.2, x1: 4.2, y0: -0.25, y1: 1.5 }, { l: 34, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "1/x²" });
  hline(ctx, T, 0.25, C("--seq2"), [6, 4], 1.8);
  PP.label(ctx, "1/4", T.w - T.p.r - 4, T.Y(0.25) - 3, C("--seq2"), "right", "bottom", 12);
  [[-4.2, -0.05], [0.05, 4.2]].forEach(([a, b]) => {
    const pts = [];
    for (let i = 0; i <= 200; i++) {
      const u = a + (b - a) * i / 200, v = 1 / (u * u);
      if (v <= T.box.y1 + 0.2) pts.push([T.X(u), T.Y(Math.min(v, T.box.y1 + 0.2))]);
    }
    ctx.save(); ctx.beginPath(); ctx.rect(T.p.l, T.p.t, T.w - T.p.l - T.p.r, T.h - T.p.t - T.p.b); ctx.clip();
    PP.path(ctx, pts, C("--accent"), 2);
    ctx.restore();
  });
  // D sobre el eje
  const y0 = T.Y(0);
  [[-2, 0], [0, 2]].forEach(([a, b]) => PP.path(ctx, [[T.X(a), y0], [T.X(b), y0]], C("--ok"), 5));
  [-2, 0, 2].forEach((u) => PP.circle(ctx, T.X(u), y0, 4.5, C("--ok"), C("--bg"), null, 2));
  PP.label(ctx, "D", T.X(1), y0 + 6, C("--ok"), "center", "top", 13);
  if (x === 0) {
    PP.read(P + "3-3-read", [["x", "0"], ["1/x²", "no está definido"], ["¿x ∈ D?", "no (x ≠ 0)", "bad"]]);
    return;
  }
  const v = 1 / (x * x), inD = v > 0.25;
  const vy = Math.min(v, T.box.y1);
  PP.path(ctx, [[T.X(x), T.Y(0)], [T.X(x), T.Y(vy)]], C("--muted"), 1, [3, 3]);
  if (v <= T.box.y1) PP.dot(ctx, T.X(x), T.Y(v), 6, inD ? C("--ok") : C("--fail"));
  else arrowOut(ctx, T.X(x), T.p.t + 7, true, C("--ok"));
  PP.dot(ctx, T.X(x), y0, 4, inD ? C("--ok") : C("--fail"));
  PP.read(P + "3-3-read", [
    ["x", F(x, 2)],
    ["1/x²", F(v, 4)],
    ["¿1/x² > 1/4?", inD ? "sí" : "no", inD ? "good" : "bad"],
    ["¿2 > |x| y x ≠ 0?", Math.abs(x) < 2 ? "sí ⇒ x ∈ D" : "no ⇒ x ∉ D", inD ? "good" : "bad"],
  ]);
}, [P + "3-3-x"]);

/* ===================== Bloque 2 ===================== */

/* Ejemplo 5: s racional, √2 y un racional q entre ambos. */
function ratBetween(a, b) {
  const lo = Math.min(a, b), hi = Math.max(a, b);
  for (let d = 1; d <= 2000; d++) {
    const m = Math.floor(lo * d) + 1;
    if (m / d < hi) return [m, d];
  }
  return [Math.round((lo + hi) * 500), 1000];
}
PP.register(function ej5() {
  const sv = V("5-s"), s = sv / 100, r2 = Math.SQRT2;
  const g = gcd(sv, 100);
  PP.out(P + "5-s-o", F(s, 2));
  const { ctx, T } = setup("5-c", 0.46, { x0: 0.92, x1: 2.08, y0: -1, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  const y = T.Y(0);
  // A ∩ [0.92, √2): racionales con r² < 2
  PP.rect(ctx, T.p.l, y - 6, T.X(r2) - T.p.l, 12, null, C("--area"));
  PP.label(ctx, "A (r² < 2) →", T.p.l + 2, y - 10, C("--accent"), "left", "bottom", 11);
  realLine(ctx, T, [{ x: 1, label: "1" }, { x: 2, label: "2" }]);
  PP.path(ctx, [[T.X(r2), y - 22], [T.X(r2), y + 22]], C("--muted"), 1.5, [4, 3]);
  PP.label(ctx, "√2 ∉ ℚ", T.X(r2), y + 24, C("--muted"), "center", "top", 12);
  const above = s * s > 2;
  const [m, d] = ratBetween(s, r2);
  const q = m / d;
  PP.path(ctx, [[T.X(s), y - 14], [T.X(s), y + 14]], C("--seq2"), 3);
  PP.label(ctx, "s", T.X(s), y - 16, C("--seq2"), "center", "bottom", 14);
  PP.dot(ctx, T.X(q), y, 6, C("--accent"));
  PP.label(ctx, "q = " + frac(m, d), T.X(q), y - 30, C("--accent"), "center", "bottom", 12);
  PP.path(ctx, [[T.X(q), y - 8], [T.X(q), y - 28]], C("--accent"), 1);
  PP.read(P + "5-read", [
    ["s", frac(sv / g, 100 / g) + " = " + F(s, 2)],
    ["s²", F(s * s, 4) + (above ? " > 2" : " < 2")],
    ["q entre s y √2", frac(m, d) + "   (q² = " + F(q * q, 4) + ")"],
    ["contradicción", above ? "q es cota superior y q < s" : "q ∈ A y q > s: s no es cota", "bad"],
  ]);
}, [P + "5-s"]);

/* Ejemplo C1-5: A = {n ∈ ℤ : n ≤ x} y su supremo. */
PP.register(function c15() {
  const x = V("c1-5-x") / 10;
  PP.out(P + "c1-5-x-o", F(x, 1));
  const { ctx, T } = setup("c1-5-c", 0.42, { x0: -4.6, x1: 4.6, y0: -1, y1: 1 }, { l: 14, r: 14, t: 10, b: 10 });
  const y = T.Y(0);
  const n = Math.floor(x);
  const ticks = [];
  for (let k = -4; k <= 4; k++) ticks.push({ x: k, label: String(k).replace("-", "−"), len: 4 });
  realLine(ctx, T, ticks, true);
  PP.path(ctx, [[T.p.l + 8, y - 4], [T.p.l, y], [T.p.l + 8, y + 4]], C("--muted"), 1.3);
  for (let k = -4; k <= n && k <= 4; k++) PP.dot(ctx, T.X(k), y, 5, C("--accent"));
  if (n >= -4 && n <= 4) {
    ring(ctx, T.X(n), y, 10, C("--accent"));
    PP.label(ctx, "n = sup A", T.X(n), y + 26, C("--accent"), "center", "top", 12);
  }
  if (n + 1 <= 4) PP.circle(ctx, T.X(n + 1), y, 5, C("--fail"), C("--bg"), null, 2);
  PP.path(ctx, [[T.X(x), y - 26], [T.X(x), y + 6]], C("--seq2"), 2.5);
  PP.label(ctx, "x", T.X(x), y - 28, C("--seq2"), "center", "bottom", 14);
  PP.read(P + "c1-5-read", [
    ["x", F(x, 2)],
    ["A", "{…, " + String(n - 2).replace("-", "−") + ", " + String(n - 1).replace("-", "−") + ", " + String(n).replace("-", "−") + "}"],
    ["n = sup A", String(n).replace("-", "−")],
    ["n ≤ x < n + 1", String(n).replace("-", "−") + " ≤ " + F(x, 2) + " < " + String(n + 1).replace("-", "−"), "good"],
  ]);
}, [P + "c1-5-x"]);

/* ===================== Bloque 3 ===================== */

/* Ejemplo 7: las dos sucesiones, en el plano o sobre la recta. */
PP.register(function ej7() {
  const N = V("7-N"), s = R("7-s"), v = R("7-v");
  PP.out(P + "7-N-o", String(N));
  const a = (n) => (s === "inv" ? 1 / n : (n % 2 ? -1 : 1));
  if (v === "plano") {
    const box = s === "inv" ? { x0: 0, x1: N + 0.8, y0: 0, y1: 1.15 } : { x0: 0, x1: N + 0.8, y0: -1.3, y1: 1.3 };
    const { ctx, T } = setup("7-c", 0.62, box, { l: 34, r: 12, t: 12, b: 26 });
    ctx.save(); ctx.strokeStyle = C("--rule"); ctx.setLineDash([3, 3]); ctx.lineWidth = 1;
    const yt = s === "inv" ? [[1, "1"], [0.5, "1/2"]] : [[-1, "−1"], [1, "1"]];
    yt.forEach(([yy]) => { ctx.beginPath(); ctx.moveTo(T.p.l, T.Y(yy)); ctx.lineTo(T.w - T.p.r, T.Y(yy)); ctx.stroke(); });
    ctx.restore();
    PP.path(ctx, [[T.p.l, T.Y(0)], [T.w - T.p.r, T.Y(0)]], C("--muted"), 1);
    PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), T.h - T.p.b]], C("--muted"), 1);
    yt.forEach(([yy, lab]) => PP.label(ctx, lab, T.p.l - 6, T.Y(yy), C("--muted"), "right", "middle", 11));
    const step = N <= 12 ? 1 : N <= 20 ? 2 : 5;
    for (let n = 1; n <= N; n++) if (n % step === 0 || n === 1) PP.label(ctx, String(n), T.X(n), T.Y(0) + (s === "inv" ? 6 : 4), C("--muted"), "center", "top", 11);
    PP.label(ctx, "n", T.w - T.p.r, T.Y(0) - 3, C("--muted"), "right", "bottom", 11);
    PP.label(ctx, "aₙ", T.X(0) + 5, T.p.t, C("--muted"), "left", "top", 11);
    for (let n = 1; n <= N; n++) PP.dot(ctx, T.X(n), T.Y(a(n)), dotR(N), C("--accent"));
  } else {
    const box = s === "inv" ? { x0: -0.1, x1: 1.12, y0: -1, y1: 1 } : { x0: -1.5, x1: 1.5, y0: -1, y1: 1 };
    const { ctx, T } = setup("7-c", 0.42, box, { l: 14, r: 14, t: 10, b: 10 });
    realLine(ctx, T, [{ x: 0, label: "0", up: true }], true);
    const y = T.Y(0);
    for (let n = 1; n <= N; n++) PP.dot(ctx, T.X(a(n)), y, 4, C("--accent"));
    if (s === "inv") {
      for (let n = 1; n <= Math.min(4, N); n++) PP.label(ctx, "a" + sub(n), T.X(1 / n), y + 10, C("--accent"), "center", "top", 12);
    } else {
      PP.label(ctx, "a₁, a₃, …", T.X(-1), y + 10, C("--accent"), "center", "top", 12);
      PP.label(ctx, "a₂, a₄, …", T.X(1), y + 10, C("--accent"), "center", "top", 12);
      PP.label(ctx, "−1", T.X(-1), y - 10, C("--muted"), "center", "bottom", 11);
      PP.label(ctx, "1", T.X(1), y - 10, C("--muted"), "center", "bottom", 11);
    }
  }
  const first = [];
  for (let n = 1; n <= 6; n++) first.push(s === "inv" ? (n === 1 ? "1" : "1/" + n) : (n % 2 ? "−1" : "1"));
  PP.read(P + "7-read", [
    ["sucesión", s === "inv" ? "aₙ = 1/n" : "aₙ = (−1)ⁿ"],
    ["primeros términos", "(" + first.join(", ") + ", …)"],
    ["gráfico", v === "plano" ? "puntos (n, aₙ)" : "sólo los valores aₙ"],
  ]);
}, [P + "7-N", 'input[name="' + P + '7-s"]', 'input[name="' + P + '7-v"]']);

/* Sucesión con banda ε alrededor de 0 y n₀ marcado (Ejemplos 8 y C1-1.1). */
PP.register(function ej8() {
  const eps = V("8-e") / 100;
  PP.out(P + "8-e-o", F(eps, 2));
  const n0 = Math.floor(1 / eps) + 1;
  const M = clamp(n0 + 10, 14, 45);
  const { ctx, T } = setup("8-c", 0.62, { x0: 0, x1: M + 1, y0: -0.12, y1: 1.06 }, { l: 38, r: 12, t: 12, b: 26 });
  hband(ctx, T, -eps, eps, C("--band"));
  seqAxes(ctx, T, "n", "1/n");
  hline(ctx, T, eps, C("--accent"), [5, 4], 1.2);
  PP.label(ctx, "ε", T.w - T.p.r - 4, T.Y(eps) - 3, C("--accent"), "right", "bottom", 13);
  vline(ctx, T, n0, C("--ink"), [4, 3], 1.2);
  PP.label(ctx, "n₀ = " + n0, T.X(n0) + 4, T.p.t + 2, C("--ink"), "left", "top", 12);
  for (let n = 1; n <= M; n++) PP.dot(ctx, T.X(n), T.Y(1 / n), dotR(M), n >= n0 ? C("--accent") : C("--seq2"));
  PP.read(P + "8-read", [
    ["ε", F(eps, 3)],
    ["1/ε", F(1 / eps, 3)],
    ["n₀ (primer natural > 1/ε)", String(n0)],
    ["1/n₀", F(1 / n0, 4) + " < ε", "good"],
  ]);
}, [P + "8-e"]);

PP.register(function c111() {
  const eps = V("c1-1-1-e") / 100;
  PP.out(P + "c1-1-1-e-o", F(eps, 2));
  const m = Math.floor(1 / eps) + 1;
  const M = clamp(m + 8, 12, 45);
  const { ctx, T } = setup("c1-1-1-c", 0.62, { x0: 0, x1: M + 1, y0: -0.1, y1: 1.06 }, { l: 38, r: 12, t: 12, b: 26 });
  hband(ctx, T, -eps, eps, C("--band"));
  seqAxes(ctx, T, "n");
  hline(ctx, T, eps, C("--accent"), [5, 4], 1.2);
  PP.label(ctx, "ε", T.w - T.p.r - 4, T.Y(eps) - 3, C("--accent"), "right", "bottom", 13);
  vline(ctx, T, m, C("--ink"), [4, 3], 1.2);
  PP.label(ctx, "m = n₀ = " + m, T.X(m) + 4, T.p.t + 2, C("--ink"), "left", "top", 12);
  const r = dotR(M);
  for (let n = 1; n <= M; n++) {
    PP.circle(ctx, T.X(n), T.Y(1 / n), r + 0.5, C("--seq2"), null, null, 1.4);
    PP.dot(ctx, T.X(n), T.Y(1 / Math.pow(2, n)), r, C("--accent"));
  }
  PP.label(ctx, "1/n", T.X(1) + 9, T.Y(1), C("--seq2"), "left", "middle", 12);
  PP.label(ctx, "1/2ⁿ", T.X(2) + 9, T.Y(0.25), C("--accent"), "left", "middle", 12);
  PP.read(P + "c1-1-1-read", [
    ["ε", F(eps, 3)],
    ["m (primero con 1/m < ε)", String(m)],
    ["1/2ᵐ ≤ 1/m < ε", F(1 / Math.pow(2, m), 6) + " ≤ " + F(1 / m, 4) + " < " + F(eps, 3), "good"],
  ]);
}, [P + "c1-1-1-e"]);

/* C1-1.2: ((−1)ⁿ + 2)/√(n+3). */
PP.register(function c112() {
  const eps = V("c1-1-2-e") / 100;
  PP.out(P + "c1-1-2-e-o", F(eps, 2));
  const m = Math.floor(9 / (eps * eps)) + 1; // primer m con 1/m < (ε/3)²
  const n0 = Math.max(m - 3, 1);
  const M = clamp(n0 + 14, 16, 130);
  const { ctx, T } = setup("c1-1-2-c", 0.62, { x0: 0, x1: M + 1, y0: -0.06, y1: 1.5 }, { l: 38, r: 12, t: 12, b: 26 });
  hband(ctx, T, 0, eps, C("--band"));
  seqAxes(ctx, T, "n");
  hline(ctx, T, eps, C("--accent"), [5, 4], 1.2);
  PP.label(ctx, "ε", T.w - T.p.r - 4, T.Y(eps) - 3, C("--accent"), "right", "bottom", 13);
  const env = [];
  for (let i = 0; i <= 300; i++) { const n = 1 + (M - 1) * i / 300; env.push([T.X(n), T.Y(3 / Math.sqrt(n + 3))]); }
  PP.path(ctx, env, C("--seq3"), 1.6, [5, 3]);
  PP.label(ctx, "3/√(n+3)", T.X(M) - 2, T.Y(3 / Math.sqrt(M + 3)) - 4, C("--seq3"), "right", "bottom", 11);
  vline(ctx, T, n0, C("--ink"), [4, 3], 1.2);
  PP.label(ctx, "n₀ = " + n0, T.X(n0) + (T.X(n0) > T.w * 0.7 ? -4 : 4), T.p.t + 2, C("--ink"), T.X(n0) > T.w * 0.7 ? "right" : "left", "top", 12);
  const r = dotR(M);
  let worst = 0;
  for (let n = 1; n <= M; n++) {
    const a = ((n % 2 ? -1 : 1) + 2) / Math.sqrt(n + 3);
    if (n >= n0) worst = Math.max(worst, a);
    PP.dot(ctx, T.X(n), T.Y(a), r, n >= n0 ? C("--accent") : C("--seq2"));
  }
  PP.read(P + "c1-1-2-read", [
    ["ε", F(eps, 3)],
    ["(ε/3)²", F((eps / 3) ** 2, 5)],
    ["m", String(m) + "   (1/m = " + F(1 / m, 5) + ")"],
    ["n₀ = máx{m − 3, 1}", String(n0)],
    ["3/√m < ε", F(3 / Math.sqrt(m), 4) + " < " + F(eps, 3), "good"],
    ["máx aₙ dibujado, n ≥ n₀", F(worst, 4), worst < eps ? "good" : "bad"],
  ]);
}, [P + "c1-1-2-e"]);

/* C1-3: sucesión que desde n₀ + 1 es entera; banda de radio 2ε alrededor de a_{n₁}. */
PP.register(function c13() {
  const eps = V("c1-3-e") / 100;
  PP.out(P + "c1-3-e-o", F(eps, 2));
  const head = [0.4, 3.5, 1.4, 2.6], L = 2, n0 = 4, M = 14;
  const a = (n) => (n <= n0 ? head[n - 1] : L);
  // ñ: menor índice tal que |a_n − L| < ε para todo n > ñ
  let nt = 0;
  for (let n = 1; n <= M; n++) if (Math.abs(a(n) - L) >= eps) nt = n;
  const n1 = Math.max(nt, n0) + 1;
  const { ctx, T } = setup("c1-3-c", 0.62, { x0: 0, x1: M + 1, y0: -0.6, y1: 4.4 }, { l: 34, r: 12, t: 12, b: 26 });
  const an1 = a(n1);
  hband(ctx, T, an1 - 2 * eps, an1 + 2 * eps, C("--area2"));
  hband(ctx, T, L - eps, L + eps, C("--band"));
  PP.axes(ctx, T, { xLabel: "n", intX: true, grid: false });
  for (let k = 0; k <= 4; k++) hline(ctx, T, k, C("--rule"), null, 1);
  hline(ctx, T, an1 - 2 * eps, C("--seq2"), [5, 4], 1.3);
  hline(ctx, T, an1 + 2 * eps, C("--seq2"), [5, 4], 1.3);
  PP.label(ctx, "a(n₁) ± 2ε", T.w - T.p.r - 4, T.Y(Math.min(an1 + 2 * eps, T.box.y1)) + 3, C("--seq2"), "right", "top", 11);
  vline(ctx, T, n0 + 0.5, C("--muted"), [3, 3], 1);
  PP.label(ctx, "enteros desde aquí", T.X(n0 + 0.5) + 4, T.h - T.p.b - 4, C("--muted"), "left", "bottom", 11);
  for (let n = 1; n <= M; n++) PP.dot(ctx, T.X(n), T.Y(a(n)), 4, n > n0 ? C("--accent") : C("--seq2"));
  ring(ctx, T.X(n1), T.Y(an1), 8, C("--ink"));
  PP.label(ctx, "n₁", T.X(n1), T.Y(an1) + 10, C("--ink"), "center", "top", 12);
  const ints = [];
  for (let k = -5; k <= 10; k++) if (Math.abs(k - an1) < 2 * eps) ints.push(k);
  PP.read(P + "c1-3-read", [
    ["ε", F(eps, 2) + "   (2ε = " + F(2 * eps, 2) + ")"],
    ["ñ, n₀, n₁", nt + ", " + n0 + ", " + n1],
    ["enteros a distancia < 2ε de a(n₁)", "{" + ints.join(", ") + "}", ints.length === 1 ? "good" : "bad"],
    ["conclusión", ints.length === 1 ? "sólo cabe a(n₁): aₙ = a(n₁) para n ≥ n₁" : "con ε > 1/2 entran otros enteros", ints.length === 1 ? "good" : "bad"],
  ]);
}, [P + "c1-3-e"]);

/* Prop raíz: aₙ y √aₙ con sus bandas. */
PP.register(function propSqrt() {
  const caso = R("prop-caso"), eps = V("prop-e") / 100;
  const l = caso === "pos" ? V("prop-l") / 100 : 0;
  PP.out(P + "prop-e-o", F(eps, 2));
  PP.out(P + "prop-l-o", caso === "pos" ? F(l, 2) : "0");
  document.getElementById(P + "prop-l").disabled = caso !== "pos";
  const a = (n) => (caso === "pos" ? l * (1 + (n % 2 ? -1 : 1) / (n + 1)) : 1 / n);
  const rad = caso === "pos" ? eps * Math.sqrt(l) : eps * eps;
  let n0 = 1;
  while (Math.abs(a(n0) - l) >= rad) n0++; // |aₙ − l| decrece en los dos casos: vale para todo n ≥ n₀
  const M = clamp(n0 + 10, 16, 80);
  const top = caso === "pos" ? Math.max(1.4 * l, Math.sqrt(l) + eps) + 0.15 : 1.08;
  const { ctx, T } = setup("prop-c", 0.62, { x0: 0, x1: M + 1, y0: -0.05 * top, y1: top }, { l: 38, r: 12, t: 12, b: 26 });
  hband(ctx, T, l - rad, l + rad, C("--area2"));
  hband(ctx, T, Math.sqrt(l) - eps, Math.sqrt(l) + eps, C("--area"));
  seqAxes(ctx, T, "n");
  hline(ctx, T, l, C("--seq2"), [5, 4], 1.2);
  hline(ctx, T, Math.sqrt(l), C("--accent"), [5, 4], 1.2);
  if (caso === "pos") {
    PP.label(ctx, "l", T.w - T.p.r - 4, T.Y(l) - 3, C("--seq2"), "right", "bottom", 12);
    PP.label(ctx, "√l", T.w - T.p.r - 4, T.Y(Math.sqrt(l)) - 3, C("--accent"), "right", "bottom", 12);
  }
  vline(ctx, T, n0, C("--ink"), [4, 3], 1.2);
  PP.label(ctx, "n₀ = " + n0, T.X(n0) + 4, T.p.t + 2, C("--ink"), "left", "top", 12);
  const r = dotR(M);
  let worst = 0;
  for (let n = 1; n <= M; n++) {
    PP.dot(ctx, T.X(n), T.Y(a(n)), r, C("--seq2"));
    PP.dot(ctx, T.X(n), T.Y(Math.sqrt(a(n))), r, C("--accent"));
    if (n >= n0) worst = Math.max(worst, Math.abs(Math.sqrt(a(n)) - Math.sqrt(l)));
  }
  PP.read(P + "prop-read", [
    ["caso", caso === "pos" ? "l = " + F(l, 2) + " > 0" : "l = 0"],
    ["radio pedido a aₙ", caso === "pos" ? "ε√l = " + F(rad, 4) : "ε² = " + F(rad, 4)],
    ["n₀", String(n0)],
    ["máx |√aₙ − √l|, n₀ ≤ n ≤ " + M, F(worst, 4) + " < ε = " + F(eps, 2), worst < eps ? "good" : "bad"],
  ]);
}, [P + "prop-e", P + "prop-l", 'input[name="' + P + 'prop-caso"]']);

/* Prop Cesàro: aₙ = 3(−1)ⁿ/n y sus medias. */
PP.register(function cesaro() {
  const eps = V("prop-2-e") / 100;
  PP.out(P + "prop-2-e-o", F(eps, 2));
  const a = (n) => 3 * (n % 2 ? -1 : 1) / n;
  const n1 = Math.floor(6 / eps) + 1; // |aᵢ| = 3/i < ε/2 ⇔ i > 6/ε
  let K = 0;
  for (let i = 1; i <= n1; i++) K += Math.abs(a(i));
  const n2 = Math.floor(2 * K / eps) + 1; // K/n₂ < ε/2
  const n0 = Math.max(n1, n2);
  const M = clamp(n0 + 12, 20, 160);
  const { ctx, T } = setup("prop-2-c", 0.62, { x0: 0, x1: M + 1, y0: -1.7, y1: 1.7 }, { l: 38, r: 12, t: 12, b: 26 });
  hband(ctx, T, -eps / 2, eps / 2, C("--area2"));
  hband(ctx, T, -eps, eps, C("--band"));
  seqAxes(ctx, T, "n");
  vline(ctx, T, n1, C("--seq2"), [4, 3], 1.2);
  vline(ctx, T, n2, C("--accent"), [4, 3], 1.2);
  vline(ctx, T, n0, C("--ink"), null, 1.4);
  const lab = (x, txt, col, row) => PP.label(ctx, txt, T.X(x) + 3, T.p.t + 2 + 14 * row, col, "left", "top", 11);
  lab(n1, "n₁", C("--seq2"), 0); lab(n2, "n₂", C("--accent"), 1); lab(n0, "n₀", C("--ink"), 2);
  const r = dotR(M);
  let S = 0; const pts = [];
  for (let n = 1; n <= M; n++) {
    S += a(n);
    pts.push([T.X(n), T.Y(S / n)]);
    const an = a(n);
    if (an >= T.box.y0 && an <= T.box.y1) PP.dot(ctx, T.X(n), T.Y(an), r, C("--seq2"));
    else arrowOut(ctx, T.X(n), an > 0 ? T.p.t + 7 : T.h - T.p.b - 7, an > 0, C("--seq2"));
  }
  PP.path(ctx, pts, C("--accent"), 2);
  let Sn0 = 0;
  for (let i = 1; i <= n0; i++) Sn0 += a(i);
  PP.read(P + "prop-2-read", [
    ["n₁ (|aᵢ| < ε/2 desde ahí)", String(n1)],
    ["K = Σ_{i≤n₁} |aᵢ|", F(K, 3)],
    ["n₂ (K/n₂ < ε/2)", String(n2)],
    ["n₀ = máx{n₁, n₂}", String(n0)],
    ["|S(n₀)|", F(Math.abs(Sn0 / n0), 4) + " < ε", "good"],
  ]);
}, [P + "prop-2-e"]);

/* ===================== Bloque 4 ===================== */

/* Ejemplo 10: x/(x+1). */
PP.register(function ej10() {
  const N = V("10-N");
  PP.out(P + "10-N-o", String(N));
  const X1 = Math.max(10, N + 2);
  const { ctx, T } = setup("10-c", 0.62, { x0: 0, x1: X1, y0: 0, y1: 1.12 }, { l: 38, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "x/(x+1)" });
  hline(ctx, T, 1, C("--ok"), null, 2);
  PP.label(ctx, "1 (cota superior)", T.w - T.p.r - 4, T.Y(1) - 3, C("--ok"), "right", "bottom", 12);
  const pts = [];
  for (let i = 1; i <= 300; i++) { const x = X1 * i / 300; pts.push([T.X(x), T.Y(x / (x + 1))]); }
  PP.path(ctx, pts, C("--muted"), 1.6);
  PP.circle(ctx, T.X(0), T.Y(0), 4, C("--muted"), C("--bg"));
  for (let n = 1; n <= N; n++) PP.dot(ctx, T.X(n), T.Y(n / (n + 1)), 4.5, C("--accent"));
  PP.read(P + "10-read", [
    ["a_N = N/(N+1)", N + "/" + (N + 1) + " = " + F(N / (N + 1), 4)],
    ["1 − a_N", "1/" + (N + 1) + " = " + F(1 / (N + 1), 4)],
    ["¿1 ∈ A?", "no: x/(x+1) < 1 para todo x > 0"],
  ]);
}, [P + "10-N"]);

/* C1-4: A = {1/n + m}. */
PP.register(function c14() {
  const N = V("c1-4-N"), s = R("c1-4-s");
  PP.out(P + "c1-4-N-o", String(N));
  const arriba = s === "arriba";
  const box = arriba ? { x0: 0.6, x1: N + 1.6, y0: -1, y1: 1 } : { x0: 0.94, x1: 2.08, y0: -1, y1: 1 };
  const { ctx, T } = setup("c1-4-c", 0.42, box, { l: 14, r: 14, t: 10, b: 10 });
  const y = T.Y(0);
  const ticks = [];
  if (arriba) { const st = N <= 10 ? 1 : 2; for (let k = 1; k <= N + 1; k++) if (k % st === 0 || k === 1) ticks.push({ x: k, label: String(k), len: 4 }); }
  else { ticks.push({ x: 1, label: "1 = ínf A", color: C("--ok"), w: 2.5 }); ticks.push({ x: 1.5, label: "3/2", len: 4 }); ticks.push({ x: 2, label: "2", len: 4 }); }
  realLine(ctx, T, ticks, true);
  for (let m = 1; m <= N; m++) for (let n = 1; n <= N; n++) {
    const v = 1 / n + m;
    if (v >= T.box.x0 && v <= T.box.x1) PP.dot(ctx, T.X(v), y, 2, C("--muted"));
  }
  if (arriba) {
    for (let m = 1; m <= N; m++) PP.dot(ctx, T.X(1 + m), y, 5, C("--seq2"));
    PP.label(ctx, "1 + m →", T.X(N + 1), y - 22, C("--seq2"), "right", "bottom", 12);
  } else {
    for (let n = 1; n <= N; n++) PP.dot(ctx, T.X(1 + 1 / n), y, 5, C("--accent"));
    PP.circle(ctx, T.X(1), y, 5, C("--ok"), C("--bg"), null, 2);
    PP.label(ctx, "← 1/n + 1", T.X(1 + 1 / N), y - 22, C("--accent"), "left", "bottom", 12);
  }
  PP.read(P + "c1-4-read", arriba ? [
    ["sucesión (n = 1)", "aₘ = 1 + m"],
    ["último dibujado", "a" + sub(N) + " = " + (N + 1)],
    ["comportamiento", "aₘ → +∞: A no está acotado superiormente", "bad"],
  ] : [
    ["sucesión (m = 1)", "aₙ = 1/n + 1"],
    ["último dibujado", "a" + sub(N) + " = " + F(1 + 1 / N, 4)],
    ["distancia a 1", "1/" + N + " = " + F(1 / N, 4)],
    ["¿1 ∈ A?", "no: 1/n + m > 1", "good"],
  ]);
}, [P + "c1-4-N", 'input[name="' + P + 'c1-4-s"]']);

/* ===================== Bloque 5 ===================== */

/* Ejemplo 9: (−1)ⁿ no converge. */
PP.register(function ej9() {
  const l = V("9-l") / 100, n0 = V("9-n0");
  PP.out(P + "9-l-o", F(l, 2));
  PP.out(P + "9-n0-o", String(n0));
  const M = 16, eps = 0.5;
  const { ctx, T } = setup("9-c", 0.62, { x0: 0, x1: M + 1, y0: -2.6, y1: 2.6 }, { l: 34, r: 12, t: 12, b: 26 });
  hband(ctx, T, l - eps, l + eps, C("--band"));
  seqAxes(ctx, T, "n");
  hline(ctx, T, l, C("--accent"), [5, 4], 1.4);
  PP.label(ctx, "ℓ", T.w - T.p.r - 4, T.Y(l) - 3, C("--accent"), "right", "bottom", 13);
  vline(ctx, T, n0, C("--ink"), [4, 3], 1.2);
  PP.label(ctx, "n₀", T.X(n0) + 4, T.p.t + 2, C("--ink"), "left", "top", 12);
  const wantOdd = l >= 0;
  const n = (n0 % 2 === 1) === wantOdd ? n0 : n0 + 1;
  for (let k = 1; k <= M; k++) PP.dot(ctx, T.X(k), T.Y(k % 2 ? -1 : 1), 4, C("--seq2"));
  const an = n % 2 ? -1 : 1;
  ring(ctx, T.X(n), T.Y(an), 9, C("--fail"));
  PP.path(ctx, [[T.X(n) + 12, T.Y(an)], [T.X(n) + 12, T.Y(l)]], C("--fail"), 1.5);
  PP.label(ctx, "≥ 1/2", T.X(n) + 16, T.Y((an + l) / 2), C("--fail"), "left", "middle", 12);
  PP.read(P + "9-read", [
    ["ℓ, ε", F(l, 2) + ", 1/2"],
    ["n elegido (≥ n₀)", n + (n % 2 ? " (impar)" : " (par)") + (wantOdd ? "" : " — caso ℓ < 0")],
    ["aₙ", String(an).replace("-", "−")],
    ["|aₙ − ℓ|", F(Math.abs(an - l), 3) + " ≥ 1/2", "bad"],
  ]);
}, [P + "9-l", P + "9-n0"]);

/* ===================== Bloque 6 ===================== */

/* Ejemplo 11: qué es una subsucesión. */
PP.register(function ej11() {
  const s = R("11-s");
  const cands = {
    a2k: { idx: [2, 4, 6, 8], name: "(a₂ₖ)" },
    b: { idx: [2, 4, 1, 5, 6], name: "(bₙ)" },
    c: { idx: [1, 1, 2, 3], name: "(cₙ)" },
  };
  const cand = cands[s];
  const { ctx, w, h } = PP.canvas(P + "11-c", 0.55);
  const lab = (n) => (n === 1 ? "1" : "1/" + n);
  const cellW = Math.min(52, (w - 24) / 8 - 4), gap = ((w - 24) - 8 * cellW) / 7;
  const xTop = (i) => 12 + (i - 1) * (cellW + gap) + cellW / 2;
  const yTop = h * 0.26, yBot = h * 0.74, ch = 28;
  PP.label(ctx, "(aₙ)", 12, yTop - ch / 2 - 18, C("--muted"), "left", "bottom", 11);
  PP.label(ctx, cand.name, 12, yBot + ch / 2 + 6, C("--muted"), "left", "top", 11);
  // reglas: índice repetido o no creciente
  const bad = cand.idx.map((n, k) => k > 0 && n <= cand.idx[k - 1]);
  cand.idx.forEach((n, k) => {
    const xb = xTop(k + 1);
    PP.path(ctx, [[xTop(n), yTop + ch / 2], [xb, yBot - ch / 2]], bad[k] ? C("--fail") : C("--accent"), bad[k] ? 2.4 : 1.6);
  });
  for (let i = 1; i <= 8; i++) {
    const used = cand.idx.includes(i);
    PP.rect(ctx, xTop(i) - cellW / 2, yTop - ch / 2, cellW, ch, used ? C("--accent") : C("--rule"), C("--panel"));
    PP.label(ctx, lab(i), xTop(i), yTop, C("--ink"), "center", "middle", 12);
    PP.label(ctx, "a" + sub(i), xTop(i), yTop - ch / 2 - 3, C("--muted"), "center", "bottom", 10);
  }
  cand.idx.forEach((n, k) => {
    const xb = xTop(k + 1);
    PP.rect(ctx, xb - cellW / 2, yBot - ch / 2, cellW, ch, bad[k] ? C("--fail") : C("--accent"), C("--panel"));
    PP.label(ctx, lab(n), xb, yBot, C("--ink"), "center", "middle", 12);
  });
  PP.label(ctx, "…", xTop(cand.idx.length + 1) - cellW / 2, yBot, C("--muted"), "left", "middle", 14);
  const ok = !bad.some(Boolean);
  const why = s === "b" ? "n₃ = 1 < n₂ = 4: no respeta el orden" : s === "c" ? "n₂ = n₁ = 1: repite el primer término" : "2 < 4 < 6 < 8 < …";
  PP.read(P + "11-read", [
    ["índices nₖ", cand.idx.join(", ") + ", …"],
    ["¿estrictamente crecientes?", ok ? "sí" : "no", ok ? "good" : "bad"],
    ["motivo", why, ok ? "good" : "bad"],
  ]);
}, ['input[name="' + P + '11-s"]']);

/* Prop cos(nπ/2). */
PP.register(function propCos() {
  const N = V("prop-3-N");
  PP.out(P + "prop-3-N-o", String(N));
  const { ctx, T } = setup("prop-3-c", 0.55, { x0: 0, x1: N + 1, y0: -1.4, y1: 1.4 }, { l: 34, r: 12, t: 12, b: 26 });
  seqAxes(ctx, T, "n");
  hline(ctx, T, 0, C("--accent"), [5, 4], 1);
  hline(ctx, T, 1, C("--seq2"), [5, 4], 1);
  const r = dotR(N) + 0.5;
  for (let n = 1; n <= N; n++) {
    const v = Math.round(Math.cos(n * Math.PI / 2));
    const col = n % 4 === 1 ? C("--accent") : n % 4 === 0 ? C("--seq2") : C("--muted");
    PP.dot(ctx, T.X(n), T.Y(v), n % 4 === 1 || n % 4 === 0 ? r + 1 : r - 0.5, col);
  }
  PP.label(ctx, "a₄ₖ₊₁ = 0", T.w - T.p.r - 4, T.Y(-0.3), C("--accent"), "right", "middle", 12);
  PP.label(ctx, "a₄ₖ = 1", T.w - T.p.r - 4, T.Y(0.7), C("--seq2"), "right", "middle", 12);
  const i1 = [], i0 = [];
  for (let n = 1; n <= N; n++) { if (n % 4 === 1) i1.push(n); if (n % 4 === 0) i0.push(n); }
  PP.read(P + "prop-3-read", [
    ["índices 4k + 1", i1.slice(0, 6).join(", ") + (i1.length > 6 ? ", …" : "") + "  → 0"],
    ["índices 4k", i0.slice(0, 6).join(", ") + (i0.length > 6 ? ", …" : "") + "  → 1"],
    ["límites", "0 ≠ 1 ⇒ (aₙ) no converge", "bad"],
  ]);
}, [P + "prop-3-N"]);

/* Ejemplo 12: rⁿ. */
PP.register(function ej12() {
  const r = V("12-r") / 100;
  PP.out(P + "12-r-o", F(r, 2));
  const M = 30;
  const { ctx, T } = setup("12-c", 0.62, { x0: 0, x1: M + 1, y0: -0.04, y1: 1.12 }, { l: 38, r: 12, t: 12, b: 26 });
  hband(ctx, T, r, 1, C("--failband"));
  seqAxes(ctx, T, "n", "rⁿ");
  hline(ctx, T, 1, C("--fail"), null, 1.6);
  PP.label(ctx, "1", T.w - T.p.r - 4, T.Y(1) - 3, C("--fail"), "right", "bottom", 12);
  PP.label(ctx, "1 − r", T.w - T.p.r - 4, T.Y((1 + r) / 2), C("--fail"), "right", "middle", 12);
  for (let n = 1; n <= M; n++) {
    PP.dot(ctx, T.X(n), T.Y(Math.pow(r, n)), 3, C("--accent"));
    if (n % 2 === 0) ring(ctx, T.X(n), T.Y(Math.pow(r, n)), 6, C("--seq2"));
  }
  PP.read(P + "12-read", [
    ["a₁ = r", F(r, 3)],
    ["|aₙ − 1| ≥ 1 − r", F(1 - r, 3)],
    ["a₃₀ = r³⁰", F(Math.pow(r, 30), 6)],
  ]);
}, [P + "12-r"]);

/* C1-2: xⁿ para el x elegido. */
PP.register(function c12() {
  const x = V("c1-2-x") / 100;
  PP.out(P + "c1-2-x-o", F(x, 2));
  const M = 25, Y = 3;
  const { ctx, T } = setup("c1-2-c", 0.62, { x0: 0, x1: M + 1, y0: -Y, y1: Y }, { l: 34, r: 12, t: 12, b: 26 });
  seqAxes(ctx, T, "n", "xⁿ");
  for (let n = 1; n <= M; n++) {
    const v = Math.pow(x, n);
    if (Math.abs(v) <= Y) PP.dot(ctx, T.X(n), T.Y(v), 3.5, C("--accent"));
    else arrowOut(ctx, T.X(n), v > 0 ? T.p.t + 7 : T.h - T.p.b - 7, v > 0, C("--seq2"));
  }
  const ax = Math.abs(x);
  let caso, concl, cls;
  if (x === 1) { caso = "x = 1"; concl = "convergente a 1"; cls = "good"; }
  else if (x === -1) { caso = "x = −1 (Ejemplo 9)"; concl = "no converge"; cls = "bad"; }
  else if (x >= 0 && x < 1) { caso = "0 ≤ x < 1 (monótona acotada, L = Lx)"; concl = "convergente a 0"; cls = "good"; }
  else if (ax < 1) { caso = "|x| < 1 (lema del valor absoluto)"; concl = "convergente a 0"; cls = "good"; }
  else if (x > 1) { caso = "x > 1 (creciente; L = 0 es absurdo)"; concl = "divergente"; cls = "bad"; }
  else { caso = "x < −1 (|x|ⁿ no converge)"; concl = "divergente"; cls = "bad"; }
  PP.read(P + "c1-2-read", [
    ["x", F(x, 2)],
    ["caso", caso],
    ["x²⁵", F(Math.pow(x, 25), 4)],
    ["resumen", concl, cls],
  ]);
}, [P + "c1-2-x"]);

/* C2-1: telaraña de a_{n+1} = √(2 + aₙ). */
PP.register(function c21() {
  const k = V("c2-1-k"), v = R("c2-1-v");
  PP.out(P + "c2-1-k-o", String(k));
  const seq = [Math.SQRT2];
  for (let i = 0; i < k; i++) seq.push(Math.sqrt(2 + seq[i]));
  if (v === "tela") {
    const { ctx, T } = setup("c2-1-c", 0.7, { x0: -1.3, x1: 2.5, y0: -0.25, y1: 2.45 }, { l: 34, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xLabel: "x", yLabel: "y" });
    hline(ctx, T, 2, C("--ok"), [5, 4], 1.4);
    PP.label(ctx, "cota 2", T.p.l + 4, T.Y(2) - 3, C("--ok"), "left", "bottom", 11);
    PP.path(ctx, [[T.X(-0.25), T.Y(-0.25)], [T.X(2.45), T.Y(2.45)]], C("--muted"), 1.4);
    PP.label(ctx, "y = x", T.X(2.38), T.Y(2.38) + 4, C("--muted"), "right", "top", 11);
    const curve = [];
    for (let i = 0; i <= 200; i++) { const u = -1.3 + 3.8 * i / 200; curve.push([T.X(u), T.Y(Math.sqrt(2 + u))]); }
    PP.path(ctx, curve, C("--accent"), 2);
    PP.label(ctx, "y = √(2 + x)", T.X(-1.2), T.Y(Math.sqrt(0.8)) - 6, C("--accent"), "left", "bottom", 11);
    // telaraña
    const web = [[T.X(seq[0]), T.Y(0)]];
    for (let i = 0; i < k; i++) {
      web.push([T.X(seq[i]), T.Y(seq[i + 1])]);
      web.push([T.X(seq[i + 1]), T.Y(seq[i + 1])]);
    }
    PP.path(ctx, web, C("--seq2"), 1.6);
    PP.dot(ctx, T.X(seq[0]), T.Y(0), 4.5, C("--seq2"));
    PP.label(ctx, "a₁ = √2", T.X(seq[0]), T.Y(0) + 4, C("--seq2"), "center", "top", 11);
    PP.dot(ctx, T.X(2), T.Y(2), 5, C("--ok"));
    PP.label(ctx, "L = 2", T.X(2) + 6, T.Y(2) + 4, C("--ok"), "left", "top", 11);
    PP.dot(ctx, T.X(-1), T.Y(0), 4.5, C("--fail"));
    PP.label(ctx, "−1", T.X(-1), T.Y(0) + 4, C("--fail"), "center", "top", 11);
  } else {
    const M = k + 1;
    const { ctx, T } = setup("c2-1-c", 0.7, { x0: 0, x1: Math.max(M, 6) + 1, y0: 1.2, y1: 2.12 }, { l: 38, r: 12, t: 12, b: 26 });
    seqAxes(ctx, T, "n", "aₙ");
    hline(ctx, T, 2, C("--ok"), [5, 4], 1.4);
    PP.label(ctx, "cota 2", T.w - T.p.r - 4, T.Y(2) - 3, C("--ok"), "right", "bottom", 11);
    for (let n = 1; n <= M; n++) PP.dot(ctx, T.X(n), T.Y(seq[n - 1]), 4.5, C("--accent"));
  }
  PP.read(P + "c2-1-read", [
    ["a₁, a₂, a₃", seq.slice(0, 3).map((u) => F(u, 4)).join(", ")],
    ["a" + sub(k + 1), F(seq[k], 6)],
    ["2 − a" + sub(k + 1), F(2 - seq[k], 6)],
    ["¿creciente y ≤ 2?", "sí", "good"],
  ]);
}, [P + "c2-1-k", 'input[name="' + P + 'c2-1-v"]']);

/* C2-2: tres clases de restos. */
PP.register(function c22() {
  const eps = V("c2-2-e") / 100;
  PP.out(P + "c2-2-e-o", F(eps, 2));
  const a = (n) => {
    const r = n % 3, k = (n - r) / 3;
    if (r === 0) return 1.2 * (k % 2 ? -1 : 1) / k;
    if (r === 1) return 2 / (k + 1);
    return -0.8 / (k + 1);
  };
  const first = (cond, start) => { let k = start; while (!cond(k)) k++; return k; };
  const k0 = first((k) => 1.2 / k < eps, 1);
  const k1 = first((k) => 2 / (k + 1) < eps, 1);
  const k2 = first((k) => 0.8 / (k + 1) < eps, 1);
  const t0 = 3 * k0, t1 = 3 * k1 + 1, t2 = 3 * k2 + 2, n0 = Math.max(t0, t1, t2);
  const M = clamp(n0 + 9, 18, 120);
  const { ctx, T } = setup("c2-2-c", 0.62, { x0: 0, x1: M + 1, y0: -1.3, y1: 1.3 }, { l: 34, r: 12, t: 12, b: 26 });
  hband(ctx, T, -eps, eps, C("--band"));
  seqAxes(ctx, T, "n");
  const cols = [C("--accent"), C("--seq2"), C("--seq3")];
  [t0, t1, t2].forEach((t, i) => vline(ctx, T, t, cols[i], [4, 3], 1.3));
  vline(ctx, T, n0, C("--ink"), null, 1.5);
  PP.label(ctx, "n₀ = " + n0, T.X(n0) + (T.X(n0) > T.w * 0.7 ? -4 : 4), T.p.t + 2, C("--ink"), T.X(n0) > T.w * 0.7 ? "right" : "left", "top", 12);
  const r = dotR(M);
  for (let n = 1; n <= M; n++) {
    const v = a(n);
    if (Math.abs(v) <= 1.3) PP.dot(ctx, T.X(n), T.Y(v), r, cols[n % 3]);
    else arrowOut(ctx, T.X(n), v > 0 ? T.p.t + 7 : T.h - T.p.b - 7, v > 0, cols[n % 3]);
  }
  PP.read(P + "c2-2-read", [
    ["k₀ → 3k₀", k0 + " → " + t0],
    ["k₁ → 3k₁ + 1", k1 + " → " + t1],
    ["k₂ → 3k₂ + 2", k2 + " → " + t2],
    ["n₀ = máx", String(n0), "good"],
  ]);
}, [P + "c2-2-e"]);

/* Prop producto: aₙ, bₙ y cₙ = aₙbₙ. */
PP.register(function propProd() {
  const eps = V("prop-4-e") / 100, v = R("prop-4-v");
  PP.out(P + "prop-4-e-o", F(eps, 2));
  const a = (n) => (n % 2 ? 1.5 : 3 / n);
  const b = (n) => (n % 2 ? 4 / (n + 1) : -1.2);
  const M1 = 1.5, M2 = 2;
  const k1 = Math.floor(3 * M2 / (2 * eps)) + 1; // |a₂ₖ| = 3/(2k) < ε/M₂
  const k2 = Math.floor(2 * M1 / eps) + 1; // |b₂ₖ₋₁| = 2/k < ε/M₁
  const n0 = Math.max(2 * k1, 2 * k2 - 1);
  const M = clamp(n0 + 10, 20, 140);
  const r = dotR(M);
  if (v === "ab") {
    const { ctx, T } = setup("prop-4-c", 0.62, { x0: 0, x1: M + 1, y0: -1.6, y1: 2.2 }, { l: 34, r: 12, t: 12, b: 26 });
    seqAxes(ctx, T, "n");
    for (let n = 1; n <= M; n++) {
      PP.dot(ctx, T.X(n), T.Y(a(n)), r, C("--accent"));
      PP.dot(ctx, T.X(n), T.Y(b(n)), r, C("--seq2"));
    }
    PP.label(ctx, "aₙ", T.w - T.p.r - 4, T.Y(1.5) - 4, C("--accent"), "right", "bottom", 12);
    PP.label(ctx, "bₙ", T.w - T.p.r - 4, T.Y(-1.2) + 4, C("--seq2"), "right", "top", 12);
  } else {
    const { ctx, T } = setup("prop-4-c", 0.62, { x0: 0, x1: M + 1, y0: -1.2, y1: 1.6 }, { l: 34, r: 12, t: 12, b: 26 });
    hband(ctx, T, -eps, eps, C("--band"));
    seqAxes(ctx, T, "n", "cₙ");
    vline(ctx, T, n0, C("--ink"), [4, 3], 1.3);
    PP.label(ctx, "n₀ = " + n0, T.X(n0) + (T.X(n0) > T.w * 0.7 ? -4 : 4), T.p.t + 2, C("--ink"), T.X(n0) > T.w * 0.7 ? "right" : "left", "top", 12);
    for (let n = 1; n <= M; n++) PP.dot(ctx, T.X(n), T.Y(a(n) * b(n)), r, n % 2 ? C("--seq2") : C("--accent"));
  }
  let worst = 0;
  for (let n = n0; n <= M; n++) worst = Math.max(worst, Math.abs(a(n) * b(n)));
  PP.read(P + "prop-4-read", [
    ["M₁, M₂", "1,5 y 2"],
    ["k₁ (|a₂ₖ| < ε/M₂)", String(k1)],
    ["k₂ (|b₂ₖ₋₁| < ε/M₁)", String(k2)],
    ["n₀ = máx{2k₁, 2k₂ − 1}", String(n0)],
    ["máx |cₙ| dibujado, n ≥ n₀", F(worst, 4) + " < ε", worst < eps ? "good" : "bad"],
  ]);
}, [P + "prop-4-e", 'input[name="' + P + 'prop-4-v"]']);

/* C2-3: fracciones de naturales que tienden a √2. */
PP.register(function c23() {
  const N = V("c2-3-N"), v = R("c2-3-v");
  PP.out(P + "c2-3-N-o", String(N));
  const pairs = [[1, 1], [3, 2], [7, 5], [17, 12], [41, 29], [99, 70], [239, 169], [577, 408], [1393, 985], [3363, 2378]];
  const r2 = Math.SQRT2;
  if (v === "cociente") {
    const { ctx, T } = setup("c2-3-c", 0.62, { x0: 0, x1: 11, y0: 0.9, y1: 1.6 }, { l: 38, r: 12, t: 12, b: 26 });
    seqAxes(ctx, T, "n", "aₙ/bₙ");
    hline(ctx, T, r2, C("--ok"), [5, 4], 1.6);
    PP.label(ctx, "r = √2", T.w - T.p.r - 4, T.Y(r2) - 3, C("--ok"), "right", "bottom", 12);
    for (let n = 1; n <= N; n++) {
      const [p, q] = pairs[n - 1];
      PP.dot(ctx, T.X(n), T.Y(p / q), 4.5, C("--accent"));
      if (n <= 4) PP.label(ctx, p + "/" + q, T.X(n), T.Y(p / q) + (n % 2 ? 8 : -8), C("--accent"), "center", n % 2 ? "top" : "bottom", 11);
    }
  } else {
    const { ctx, T } = setup("c2-3-c", 0.62, { x0: 0, x1: 11, y0: 0, y1: 3.7 }, { l: 44, r: 12, t: 12, b: 26 });
    ctx.save(); ctx.font = font(11); ctx.fillStyle = C("--muted"); ctx.strokeStyle = C("--rule"); ctx.textAlign = "right"; ctx.textBaseline = "middle";
    [1, 10, 100, 1000].forEach((u) => { const yy = T.Y(Math.log10(u)); ctx.beginPath(); ctx.moveTo(T.p.l, yy); ctx.lineTo(T.w - T.p.r, yy); ctx.stroke(); ctx.fillText(String(u), T.p.l - 6, yy); });
    ctx.textAlign = "center"; ctx.textBaseline = "top";
    for (let n = 1; n <= 10; n++) ctx.fillText(String(n), T.X(n), T.h - T.p.b + 6);
    ctx.restore();
    for (let n = 1; n <= N; n++) {
      const [p, q] = pairs[n - 1];
      PP.dot(ctx, T.X(n) - 3, T.Y(Math.log10(p)), 4.5, C("--accent"));
      PP.dot(ctx, T.X(n) + 3, T.Y(Math.log10(q)), 4.5, C("--seq2"));
    }
    PP.label(ctx, "aₙ", T.X(1) + 8, T.Y(0) - 6, C("--accent"), "left", "bottom", 12);
    PP.label(ctx, "bₙ", T.X(1) + 8, T.Y(0) + 4, C("--seq2"), "left", "bottom", 12);
  }
  const [p, q] = pairs[N - 1];
  PP.read(P + "c2-3-read", [
    ["a" + sub(N) + ", b" + sub(N), p + ", " + q],
    ["a" + sub(N) + "/b" + sub(N), F(p / q, 7)],
    ["|a/b − √2|", F(Math.abs(p / q - r2), 7)],
  ]);
}, [P + "c2-3-N", 'input[name="' + P + 'c2-3-v"]']);

/* C1-6: racionales diádicos decrecientes hacia x. */
PP.register(function c16() {
  const x = V("c1-6-x") / 10, K = V("c1-6-k");
  PP.out(P + "c1-6-x-o", F(x, 1));
  PP.out(P + "c1-6-k-o", String(K));
  const q = [[x < 1 ? 1 : Math.floor(x) + 1, 0]]; // [m, j] representa m/2^j
  const val = (t) => t[0] / Math.pow(2, t[1]);
  for (let n = 1; n < K; n++) {
    const mid = (x + val(q[n - 1])) / 2;
    let j = 0, m;
    for (;;) {
      const d = Math.pow(2, j);
      m = Math.ceil(mid * d - 1e-12) - 1;
      if (m / d > x + 1e-12) break;
      j++;
    }
    let mm = m, jj = j;
    while (mm % 2 === 0 && jj > 0) { mm /= 2; jj--; }
    q.push([mm, jj]);
  }
  const top = val(q[0]);
  const span = top - x;
  const { ctx, T } = setup("c1-6-c", 0.62, { x0: 0, x1: K + 1, y0: x - 0.12 * span, y1: top + 0.1 * span }, { l: 44, r: 12, t: 12, b: 26 });
  PP.axes(ctx, T, { xLabel: "n", intX: true });
  hline(ctx, T, x, C("--ok"), null, 2);
  PP.label(ctx, "x", T.w - T.p.r - 4, T.Y(x) + 3, C("--ok"), "right", "top", 13);
  for (let n = 1; n < K; n++) {
    const mid = (x + val(q[n - 1])) / 2;
    PP.rect(ctx, T.X(n + 1) - 5, T.Y(mid), 10, T.Y(x) - T.Y(mid), null, C("--area2"));
    PP.path(ctx, [[T.X(n + 1) - 7, T.Y(mid)], [T.X(n + 1) + 7, T.Y(mid)]], C("--muted"), 1.2);
  }
  const pts = q.map((t, i) => [T.X(i + 1), T.Y(val(t))]);
  PP.path(ctx, pts, C("--accent"), 1, [3, 3]);
  q.forEach((t, i) => PP.dot(ctx, T.X(i + 1), T.Y(val(t)), 4.5, C("--accent")));
  const fr = (t) => (t[1] === 0 ? String(t[0]) : t[0] + "/" + Math.pow(2, t[1]));
  PP.read(P + "c1-6-read", [
    ["x", F(x, 2)],
    ["q₁ (natural > x)", fr(q[0])],
    ["q₂, q₃, …", q.slice(1).map(fr).join(", ")],
    ["q" + sub(K) + " − x", F(val(q[K - 1]) - x, 5) + " > 0", "good"],
  ]);
}, [P + "c1-6-x", P + "c1-6-k"]);

/* Serie de (−1)ᵏ. */
PP.register(function serie1() {
  const N = V("serie-N");
  PP.out(P + "serie-N-o", String(N));
  const { ctx, T } = setup("serie-c", 0.5, { x0: 0, x1: N + 1, y0: -1.5, y1: 0.7 }, { l: 34, r: 12, t: 12, b: 26 });
  seqAxes(ctx, T, "n", "Sₙ");
  const S = (n) => (n % 2 ? -1 : 0);
  const pts = [];
  for (let n = 1; n <= N; n++) pts.push([T.X(n), T.Y(S(n))]);
  PP.path(ctx, pts, C("--muted"), 1);
  for (let n = 1; n <= N; n++) PP.dot(ctx, T.X(n), T.Y(S(n)), dotR(N) + 0.5, n % 2 ? C("--seq2") : C("--accent"));
  PP.label(ctx, "S₂ₙ = 0", T.w - T.p.r - 4, T.Y(0) - 6, C("--accent"), "right", "bottom", 12);
  PP.label(ctx, "S₂ₙ₊₁ = −1", T.w - T.p.r - 4, T.Y(-1) + 6, C("--seq2"), "right", "top", 12);
  PP.read(P + "serie-read", [
    ["S₁, …, S₆", "−1, 0, −1, 0, −1, 0"],
    ["S" + sub(N), String(S(N)).replace("-", "−")],
    ["¿lím Sₙ?", "no existe: dos subsucesiones con límites 0 y −1", "bad"],
  ]);
}, [P + "serie-N"]);

/* Serie geométrica. */
PP.register(function serie2() {
  const r = V("serie-2-r") / 100;
  PP.out(P + "serie-2-r-o", F(r, 2));
  const N = 30, lim = 1 / (1 - r);
  const { ctx, T } = setup("serie-2-c", 0.62, { x0: 0, x1: N + 1, y0: 0, y1: lim * 1.12 }, { l: 38, r: 12, t: 12, b: 26 });
  seqAxes(ctx, T, "n", "Sₙ");
  hline(ctx, T, lim, C("--ok"), null, 2);
  PP.label(ctx, "1/(1 − r) = " + F(lim, 3), T.w - T.p.r - 4, T.Y(lim) - 3, C("--ok"), "right", "bottom", 12);
  let sum = 0;
  for (let n = 1; n <= N; n++) {
    sum += Math.pow(r, n - 1);
    PP.dot(ctx, T.X(n), T.Y((Math.pow(r, n) - 1) / (r - 1)), 3.5, C("--accent"));
  }
  PP.read(P + "serie-2-read", [
    ["S₃₀ por la fórmula", F((Math.pow(r, N) - 1) / (r - 1), 6)],
    ["S₃₀ sumando 1 + r + … + r²⁹", F(sum, 6)],
    ["1/(1 − r)", F(lim, 6)],
    ["r³⁰", F(Math.pow(r, N), 6)],
  ]);
}, [P + "serie-2-r"]);
