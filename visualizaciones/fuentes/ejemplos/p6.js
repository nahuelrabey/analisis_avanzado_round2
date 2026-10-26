/* Dibujos de los ejemplos de la Práctica 6 (espacios normados). Usa window.PP. */
const ID = "ejp6";
const C = (t) => PP.css(t);

/* Marco con la misma escala en x y en y, centrado en (0, 0). */
function eqFrame(w, h, half, pad) {
  const p = Object.assign({ l: 10, r: 10, t: 10, b: 10 }, pad || {});
  const span = 2 * half * (h - p.t - p.b) / (w - p.l - p.r);
  return PP.frame(w, h, { x0: -half, x1: half, y0: -span / 2, y1: span / 2 }, p);
}
function norm(v, kind) {
  const [a, b] = v;
  if (kind === "1") return Math.abs(a) + Math.abs(b);
  if (kind === "inf") return Math.max(Math.abs(a), Math.abs(b));
  return Math.hypot(a, b);
}
/* Esfera {‖z − c‖ = r} de la norma elegida, como polígono en coordenadas de pantalla. */
function sphere(T, c, r, kind) {
  const pts = [];
  for (let i = 0; i <= 160; i++) {
    const t = 2 * Math.PI * i / 160, d = [Math.cos(t), Math.sin(t)], s = r / norm(d, kind);
    pts.push([T.X(c[0] + s * d[0]), T.Y(c[1] + s * d[1])]);
  }
  return pts;
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
const nrmName = (k) => (k === "1" ? "‖·‖₁" : k === "inf" ? "‖·‖∞" : "‖·‖₂");

/* ===================== C8-4 ===================== */

/* Paso 2: |‖xₙ‖ − ‖xₘ‖| ≤ ‖xₙ − xₘ‖ con puntos arrastrables. */
const P1 = { n: [1.3, 0.8], m: [0.6, 0.3] };
let T1 = null;
function c84Triang() {
  const kind = PP.radio(ID + "-c8-4-nrm") || "2";
  const { ctx, w, h } = PP.canvas(ID + "-c8-4-cv1", 0.85);
  const T = eqFrame(w, h, 2.3, { l: 10, r: 10, t: 10, b: 10 });
  T1 = T;
  PP.path(ctx, [[T.X(-2.3), T.Y(0)], [T.X(2.3), T.Y(0)]], C("--rule"), 1);
  PP.path(ctx, [[T.X(0), T.Y(T.box.y0)], [T.X(0), T.Y(T.box.y1)]], C("--rule"), 1);
  const nn = norm(P1.n, kind), nm = norm(P1.m, kind);
  const dv = [P1.n[0] - P1.m[0], P1.n[1] - P1.m[1]], dd = norm(dv, kind);
  PP.path(ctx, sphere(T, [0, 0], nn, kind), C("--accent"), 1.2);
  PP.path(ctx, sphere(T, [0, 0], nm, kind), C("--seq2"), 1.2);
  PP.path(ctx, sphere(T, P1.m, dd, kind), C("--ok"), 1.5, [5, 4], true, C("--okband"));
  PP.path(ctx, [[T.X(P1.m[0]), T.Y(P1.m[1])], [T.X(P1.n[0]), T.Y(P1.n[1])]], C("--ok"), 2.5);
  PP.dot(ctx, T.X(0), T.Y(0), 3.5, C("--ink"));
  PP.label(ctx, "0", T.X(0) - 5, T.Y(0) + 4, C("--muted"), "right", "top", 11);
  PP.dot(ctx, T.X(P1.n[0]), T.Y(P1.n[1]), 7, C("--accent"));
  PP.dot(ctx, T.X(P1.m[0]), T.Y(P1.m[1]), 7, C("--seq2"));
  PP.label(ctx, "xₙ", T.X(P1.n[0]) + 9, T.Y(P1.n[1]) - 5, C("--accent"), "left", "bottom", 13);
  PP.label(ctx, "xₘ", T.X(P1.m[0]) + 9, T.Y(P1.m[1]) + 5, C("--seq2"), "left", "top", 13);
  const gap = Math.abs(nn - nm);
  PP.read(ID + "-c8-4-read1", [
    ["norma", nrmName(kind)],
    ["‖xₙ‖, ‖xₘ‖", PP.fmt(nn, 3) + ", " + PP.fmt(nm, 3)],
    ["|‖xₙ‖ − ‖xₘ‖|", PP.fmt(gap, 3)],
    ["‖xₙ − xₘ‖", PP.fmt(dd, 3)],
    ["¿|‖xₙ‖ − ‖xₘ‖| ≤ ‖xₙ − xₘ‖?", gap <= dd + 1e-9 ? "sí" : "no", gap <= dd + 1e-9 ? "good" : "bad"],
  ]);
}
PP.register(c84Triang, ["input[name='" + ID + "-c8-4-nrm']"]);
draggable(ID + "-c8-4-cv1", () => T1, (px, py, T) => {
  const d = (p) => Math.hypot(px - T.X(p[0]), py - T.Y(p[1]));
  const dn = d(P1.n), dm = d(P1.m);
  if (Math.min(dn, dm) > 26) return null;
  return dn <= dm ? "n" : "m";
}, (k, x, y, T) => {
  P1[k] = [Math.max(T.box.x0 + 0.1, Math.min(T.box.x1 - 0.1, x)), Math.max(T.box.y0 + 0.1, Math.min(T.box.y1 - 0.1, y))];
}, c84Triang);

/* Paso 3: la sucesión y su normalizada sobre la esfera unitaria. */
const xs = (n) => { const r = 1.5 + 0.6 / n, t = 0.5 + 1 / n; return [r * Math.cos(t), r * Math.sin(t)]; };
PP.register(function c84Normalizar() {
  const N = PP.val(ID + "-c8-4-N");
  PP.out(ID + "-c8-4-N-o", String(N));
  const kind = PP.radio(ID + "-c8-4-nrm2") || "2";
  const { ctx, w, h } = PP.canvas(ID + "-c8-4-cv2", 0.9);
  const T = eqFrame(w, h, 2.6, { l: 10, r: 10, t: 10, b: 10 });
  PP.path(ctx, [[T.X(-2.6), T.Y(0)], [T.X(2.6), T.Y(0)]], C("--rule"), 1);
  PP.path(ctx, [[T.X(0), T.Y(T.box.y0)], [T.X(0), T.Y(T.box.y1)]], C("--rule"), 1);
  PP.path(ctx, sphere(T, [0, 0], 1, kind), C("--accent"), 1.8, null, true, C("--band"));
  PP.label(ctx, "S", T.X(-0.72), T.Y(-0.72), C("--accent"), "center", "middle", 14);
  const lim = [1.5 * Math.cos(0.5), 1.5 * Math.sin(0.5)], L = norm(lim, kind), yl = [lim[0] / L, lim[1] / L];
  for (let n = 1; n <= N; n++) {
    const x = xs(n), nx = norm(x, kind), y = [x[0] / nx, x[1] / nx], last = n === N;
    if (last) PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(x[0]), T.Y(x[1])]], C("--muted"), 1, [3, 3]);
    PP.dot(ctx, T.X(x[0]), T.Y(x[1]), last ? 6 : 3, C("--seq2"));
    PP.dot(ctx, T.X(y[0]), T.Y(y[1]), last ? 6 : 3, C("--accent"));
  }
  PP.circle(ctx, T.X(lim[0]), T.Y(lim[1]), 8, C("--ok"), null, null, 2);
  PP.label(ctx, "L·y", T.X(lim[0]) + 10, T.Y(lim[1]) - 8, C("--ok"), "left", "bottom", 12);
  const xN = xs(N), nN = norm(xN, kind), yN = [xN[0] / nN, xN[1] / nN];
  const label = (p, t, col) => PP.label(ctx, t, T.X(p[0]) - 8, T.Y(p[1]) + 6, col, "right", "top", 12);
  label(xN, "x" + (N === 1 ? "₁" : "_N"), C("--seq2"));
  label(yN, "y" + (N === 1 ? "₁" : "_N"), C("--accent"));
  PP.read(ID + "-c8-4-read2", [
    ["norma", nrmName(kind)],
    ["‖x_N‖", PP.fmt(nN, 4)],
    ["L = lím ‖xₙ‖", PP.fmt(L, 4)],
    ["‖y_N‖", PP.fmt(norm(yN, kind), 4), "good"],
    ["‖y_N − y‖", PP.fmt(norm([yN[0] - yl[0], yN[1] - yl[1]], kind), 4)],
  ]);
}, [ID + "-c8-4-N", "input[name='" + ID + "-c8-4-nrm2']"]);

/* ===================== C8-5 ===================== */

PP.register(function c85() {
  const R = PP.val(ID + "-c8-5-R") / 10;
  PP.out(ID + "-c8-5-R-o", PP.fmt(R, 1));
  const K = 60;
  const { ctx, w, h } = PP.canvas(ID + "-c8-5-cv1", 0.62);
  const ymax = Math.max(1.6, Math.sqrt(K) / R * 1.08);
  const T = PP.frame(w, h, { x0: 0, x1: K + 1, y0: 0, y1: ymax }, { l: 40, r: 12, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "k", intX: true, xTicks: 6, yTicks: 5 });
  const a = [], b = [];
  for (let k = 1; k <= K; k++) { a.push([T.X(k), T.Y(1 / Math.sqrt(k))]); b.push([T.X(k), T.Y(Math.sqrt(k) / R)]); }
  PP.path(ctx, a, C("--accent"), 2.5);
  PP.path(ctx, b, C("--seq2"), 2.5);
  for (let k = 1; k <= K; k += 6) { PP.dot(ctx, T.X(k), T.Y(1 / Math.sqrt(k)), 3, C("--accent")); PP.dot(ctx, T.X(k), T.Y(Math.sqrt(k) / R), 3, C("--seq2")); }
  PP.label(ctx, "‖yₖ‖ = 1/√nₖ", T.X(K) - 2, T.Y(1 / Math.sqrt(K)) - 6, C("--accent"), "right", "bottom", 12);
  PP.label(ctx, "√nₖ / R ≤ ‖T(yₖ)‖", T.X(K) - 2, T.Y(Math.sqrt(K) / R) + 8, C("--seq2"), "right", "top", 12);
  PP.read(ID + "-c8-5-read1", [
    ["R", PP.fmt(R, 1)],
    ["‖y₆₀‖", PP.fmt(1 / Math.sqrt(K), 4)],
    ["cota para ‖T(y₆₀)‖", PP.fmt(Math.sqrt(K) / R, 3)],
    ["k con √k / R > 100", String(Math.round(100 * R) ** 2 + 1) + " (y así para cualquier techo)", "bad"],
  ]);
}, [ID + "-c8-5-R"]);
