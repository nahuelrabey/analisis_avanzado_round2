/* Dibujos de los ejemplos de la Práctica 5 (compacidad). Usa window.PP. */
const ID = "ejp5";
const C = (t) => PP.css(t);
const SUB = "₀₁₂₃₄₅₆₇₈₉";
const sub = (n) => String(n).split("").map((d) => SUB[+d]).join("");
const FONT = "'IBM Plex Sans', system-ui, sans-serif";

/* Marco con la misma escala en x y en y. */
function eqFrame(w, h, x0, x1, yc, pad) {
  const p = Object.assign({ l: 10, r: 10, t: 10, b: 10 }, pad || {});
  const span = (x1 - x0) * (h - p.t - p.b) / (w - p.l - p.r);
  return PP.frame(w, h, { x0, x1, y0: yc - span / 2, y1: yc + span / 2 }, p);
}
function listar(arr, max) {
  const s = arr.slice(0, max).join(", ");
  return arr.length > max ? s + ", …" : s;
}
function cross(ctx, x, y, r, color) {
  PP.path(ctx, [[x - r, y - r], [x + r, y + r]], color, 2);
  PP.path(ctx, [[x - r, y + r], [x + r, y - r]], color, 2);
}

/* ===================== C7-2 ===================== */

/* y_n con finitos valores: recorre x_1, x_3, x en ciclo. */
const C72_VALS = [{ name: "x₁", v: 1 }, { name: "x₃", v: 1 / 3 }, { name: "x", v: 0 }];
PP.register(function c72Finitos() {
  const sel = +(PP.radio(ID + "-c7-2-val") || 0);
  const N = 24;
  const { ctx, w, h } = PP.canvas(ID + "-c7-2-cv1", 0.62);
  const T = PP.frame(w, h, { x0: -3, x1: N + 0.8, y0: -0.08, y1: 1.12 }, { l: 34, r: 10, t: 16, b: 28 });
  PP.axes(ctx, T, { xLabel: "n", intX: true, xTicks: 6 });
  // el conjunto {x_n} ∪ {x}
  const xs = T.X(-1.6);
  PP.label(ctx, "conjunto", xs, T.p.t - 2, C("--muted"), "center", "top", 10);
  for (let n = 1; n <= 60; n++) PP.dot(ctx, xs, T.Y(1 / n), n <= 6 ? 3 : 1.6, C("--muted"));
  PP.dot(ctx, xs, T.Y(0), 3.5, C("--ok"));
  // los valores que toma la y_n
  C72_VALS.forEach((o, i) => {
    PP.path(ctx, [[T.X(0.5), T.Y(o.v)], [T.X(N + 0.6), T.Y(o.v)]], i === sel ? C("--accent") : C("--rule"), 1, [4, 4]);
  });
  const idx = [];
  for (let n = 1; n <= N; n++) {
    const k = (n - 1) % 3;
    const on = k === sel;
    if (on) idx.push(n);
    PP.dot(ctx, T.X(n), T.Y(C72_VALS[k].v), on ? 6 : 3, on ? C("--accent") : C("--seq2"));
  }
  PP.label(ctx, "y" + "ₙ" + " = " + C72_VALS[sel].name, T.X(N + 0.6), T.Y(C72_VALS[sel].v) - 4, C("--accent"), "right", "bottom", 12);
  PP.read(ID + "-c7-2-read1", [
    ["valores que toma (yₙ)", "x₁ = 1, x₃ = 1/3, x = 0: tres"],
    ["nₖ con yₙₖ = " + C72_VALS[sel].name, listar(idx, 7)],
    ["¿nₖ ≥ k?", "sí (nₖ = 3k − " + (2 - sel) + ")", "good"],
    ["(yₙₖ)ₖ", "constante = " + PP.fmt(C72_VALS[sel].v, 3) + ", converge", "good"],
  ]);
}, ["input[name='" + ID + "-c7-2-val']"]);

/* y_n con infinitos valores: impares → x, pares → x_σ(m) con σ = 2,1,4,3,6,5,… */
function c72K(n) { // índice K de y_n = x_K; 0 significa el límite x
  if (n % 2 === 1) return 0;
  const m = n / 2;
  return m % 2 === 1 ? m + 1 : m - 1;
}
PP.register(function c72Infinitos() {
  const N = PP.val(ID + "-c7-2-N");
  PP.out(ID + "-c7-2-N-o", String(N));
  const { ctx, w, h } = PP.canvas(ID + "-c7-2-cv2", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: N + 0.8, y0: -0.08, y1: 1.12 }, { l: 34, r: 10, t: 16, b: 28 });
  PP.axes(ctx, T, { xLabel: "n", yLabel: "yₙ", intX: true, xTicks: 6 });
  PP.path(ctx, [[T.X(0.3), T.Y(0)], [T.X(N + 0.8), T.Y(0)]], C("--ok"), 2);
  PP.label(ctx, "x = 0", T.X(N + 0.6), T.Y(0) - 3, C("--ok"), "right", "bottom", 11);
  // elección inductiva de n_k y K_k
  const chosen = [];
  let pn = 0, pK = 0, k = 1;
  for (let n = 1; n <= N; n++) {
    const K = c72K(n);
    if (n >= k && n > pn && K >= Math.max(k, pK + 1)) { chosen.push([n, K]); pn = n; pK = K; k++; }
  }
  const isChosen = new Set(chosen.map((c) => c[0]));
  for (let n = 1; n <= N; n++) {
    const K = c72K(n), v = K === 0 ? 0 : 1 / K;
    if (!isChosen.has(n)) PP.dot(ctx, T.X(n), T.Y(v), 3, K === 0 ? C("--muted") : C("--seq2"));
  }
  const pts = chosen.map(([n, K]) => [T.X(n), T.Y(1 / K)]);
  PP.path(ctx, pts, C("--accent"), 1.2, [4, 3]);
  chosen.forEach(([n, K], i) => {
    PP.dot(ctx, T.X(n), T.Y(1 / K), 6, C("--accent"));
    if (i < 5) PP.label(ctx, "K" + sub(i + 1) + "=" + K, T.X(n) + 5, T.Y(1 / K) - 5, C("--accent"), "left", "bottom", 11);
  });
  PP.read(ID + "-c7-2-read2", [
    ["nₖ", listar(chosen.map((c) => c[0]), 6)],
    ["Kₖ (yₙₖ = x_Kₖ)", listar(chosen.map((c) => c[1]), 6)],
    ["¿nₖ y Kₖ estrictamente crecientes?", "sí", "good"],
    ["último yₙₖ elegido", chosen.length ? "1/" + chosen[chosen.length - 1][1] + " → x = 0" : "—"],
  ]);
}, [ID + "-c7-2-N"]);

/* ===================== C7-3 ===================== */

PP.register(function c73() {
  const N = PP.val(ID + "-c7-3-N");
  PP.out(ID + "-c7-3-N-o", String(N));
  const { ctx, w, h } = PP.canvas(ID + "-c7-3-cv1", 0.7);
  const T = eqFrame(w, h, -1.45, 1.45, 0, { l: 10, r: 10, t: 10, b: 10 });
  const r = T.X(1) - T.X(0);
  PP.circle(ctx, T.X(0), T.Y(0), r, C("--accent"), C("--area"), [5, 4]);
  PP.label(ctx, "F (disco abierto)", T.X(-0.55), T.Y(-0.1), C("--accent"), "center", "middle", 12);
  const th0 = 0.6;
  const pt = (n) => { const rr = 1 - 1 / (n + 1), th = th0 + 0.9 / n; return [rr * Math.cos(th), rr * Math.sin(th)]; };
  const p = [Math.cos(th0), Math.sin(th0)];
  for (let n = 1; n <= N; n++) {
    const [a, b] = pt(n);
    PP.dot(ctx, T.X(a), T.Y(b), n === N ? 5 : 3.5, C("--seq2"));
    if (n <= 3) PP.label(ctx, "x" + sub(n), T.X(a) - 6, T.Y(b), C("--seq2"), "right", "middle", 12);
  }
  PP.circle(ctx, T.X(p[0]), T.Y(p[1]), 6, C("--fail"), C("--panel"), null, 2);
  PP.label(ctx, "p = lím xₙ ∉ F", T.X(p[0]) + 9, T.Y(p[1]) - 4, C("--fail"), "left", "bottom", 12);
  const [aN, bN] = pt(N);
  PP.read(ID + "-c7-3-read1", [
    ["d(x_N, p)", PP.fmt(Math.hypot(aN - p[0], bN - p[1]), 4)],
    ["¿p ∈ F?", "no", "bad"],
    ["K", "{xₙ} ∪ {p}: compacto (C7-2)"],
    ["K ∩ F", "{xₙ}: le falta el límite", "bad"],
  ]);
}, [ID + "-c7-3-N"]);

/* ===================== C7-1 ===================== */

function c71x(n) { return 0.5 + 0.38 * (n % 2 === 0 ? 1 : -1) * (1 - 0.7 / n); }
function c71y(n) {
  if (n % 2 === 1) return 0.5 + 0.22 / n * (((n - 1) / 2) % 2 === 0 ? 1 : -1);
  return 0.5 + 0.38 * (n % 4 === 0 ? 1 : -1) * (1 - 0.7 / n);
}
PP.register(function c71() {
  const modo = PP.radio(ID + "-c7-1-modo") || "ok";
  const N = PP.val(ID + "-c7-1-N");
  PP.out(ID + "-c7-1-N-o", String(N));
  const { ctx, w, h } = PP.canvas(ID + "-c7-1-cv1", 0.95);
  const stripH = 3 * 20 + 18;
  const s = Math.min(w - 70, h - stripH - 30);
  const ox = (w - s) / 2 + 10, oy = 12;
  const X = (u) => ox + u * s, Y = (v) => oy + (1 - v) * s;
  PP.rect(ctx, ox, oy, s, s, C("--rule"), C("--panel"));
  ctx.save(); ctx.font = "11px " + FONT; ctx.fillStyle = C("--muted");
  ctx.textAlign = "center"; ctx.textBaseline = "top"; ctx.fillText("K₁ = [0, 1]", ox + s / 2, oy + s + 3);
  ctx.save(); ctx.translate(ox - 6, oy + s / 2); ctx.rotate(-Math.PI / 2); ctx.textBaseline = "bottom"; ctx.fillText("K₂ = [0, 1]", 0, 0); ctx.restore();
  ctx.restore();
  for (let n = 1; n <= N; n++) PP.dot(ctx, X(c71x(n)), Y(c71y(n)), 2.6, C("--muted"));
  const rows = modo === "ok"
    ? [["n", () => true, C("--muted")], ["nₖ = 2k", (n) => n % 2 === 0, C("--accent")], ["nₖⱼ = 4j", (n) => n % 4 === 0, C("--ok")]]
    : [["n", () => true, C("--muted")], ["x: pares", (n) => n % 2 === 0, C("--accent")], ["y: impares", (n) => n % 2 === 1, C("--fail")]];
  if (modo === "ok") {
    for (let n = 2; n <= N; n += 2) PP.dot(ctx, X(c71x(n)), Y(c71y(n)), 4, n % 4 === 0 ? C("--ok") : C("--accent"));
    const pts = [];
    for (let n = 4; n <= N; n += 4) pts.push([X(c71x(n)), Y(c71y(n))]);
    PP.path(ctx, pts, C("--ok"), 1.2, [4, 3]);
    PP.circle(ctx, X(0.88), Y(0.88), 9, C("--ok"), null, null, 2);
    PP.label(ctx, "límite (0,88; 0,88)", X(0.88) - 12, Y(0.88) - 10, C("--ok"), "right", "bottom", 11);
  } else {
    for (let n = 2; n <= N; n += 2) PP.dot(ctx, X(c71x(n)), Y(c71y(n)), 3.5, C("--accent"));
    for (let n = 1; n <= N; n += 2) PP.dot(ctx, X(c71x(n)), Y(c71y(n)), 3.5, C("--fail"));
    for (let k = 1; 2 * k + 1 <= N; k++) cross(ctx, X(c71x(2 * k)), Y(c71y(2 * k + 1)), 4, C("--fail"));
    PP.label(ctx, "(x₂ₖ, y₂ₖ₊₁): no son términos", X(0.88), Y(0.5) - 12, C("--fail"), "right", "bottom", 11);
  }
  // tira de índices
  const sy = oy + s + 22, lw = 76, cw = Math.max(4, (w - lw - 14) / N);
  rows.forEach(([lab, f, col], i) => {
    const y = sy + i * 20;
    PP.label(ctx, lab, 6, y + 7, col, "left", "middle", 11);
    for (let n = 1; n <= N; n++) {
      const on = f(n);
      PP.rect(ctx, lw + (n - 1) * cw + 1, y, cw - 2, 14, null, on ? col : C("--rule"));
    }
  });
  PP.read(ID + "-c7-1-read1", modo === "ok" ? [
    ["x a lo largo de nₖ = 2k", "→ 0,88"],
    ["y a lo largo de nₖⱼ = 4j (sobre los nₖ)", "→ 0,88"],
    ["(xₙₖⱼ, yₙₖⱼ)", "subsucesión de (xₙ, yₙ) que converge", "good"],
  ] : [
    ["x a lo largo de los pares", "→ 0,88"],
    ["y a lo largo de los impares", "→ 0,5"],
    ["(x₂ₖ, y₂ₖ₊₁)", "no es una subsucesión de (xₙ, yₙ)", "bad"],
    ["y a lo largo de los pares", "no converge (salta entre 0,12 y 0,88)", "bad"],
  ]);
}, ["input[name='" + ID + "-c7-1-modo']", ID + "-c7-1-N"]);

/* ===================== C8-3 ===================== */

const PRIMOS = new Set([2, 3, 5, 7, 11, 13]);
const C83_PARES = [
  { s: (n) => n % 2 === 0, sp: (n) => n % 3 === 0, ls: "pares", lsp: "múltiplos de 3" },
  { s: (n) => n === 3, sp: (n) => n === 6, ls: "{3}", lsp: "{6}" },
  { s: () => false, sp: (n) => PRIMOS.has(n), ls: "∅", lsp: "primos" },
];
function fS(inS, t) {
  if (t <= 1) return inS(1) ? 0 : 1;
  const a = Math.floor(t), fa = inS(a) ? 0 : 1, fb = inS(a + 1) ? 0 : 1;
  return fa + (fb - fa) * (t - a);
}
PP.register(function c83() {
  const P = C83_PARES[+(PP.radio(ID + "-c8-3-par") || 0)];
  const M = 12;
  const { ctx, w, h } = PP.canvas(ID + "-c8-3-cv1", 0.58);
  const T = PP.frame(w, h, { x0: 0, x1: M + 0.6, y0: -0.18, y1: 1.3 }, { l: 30, r: 10, t: 12, b: 28 });
  PP.axes(ctx, T, { intX: true, xTicks: 12, yTicks: 2, xLabel: "t" });
  const curve = (inS) => { const pts = []; for (let i = 0; i <= 400; i++) { const t = T.box.x0 + (M + 0.6) * i / 400; pts.push([T.X(t), T.Y(fS(inS, t))]); } return pts; };
  PP.path(ctx, curve(P.s), C("--accent"), 4);
  PP.path(ctx, curve(P.sp), C("--seq2"), 2, [6, 4]);
  let x = null;
  for (let n = 1; n <= M; n++) if (P.s(n) !== P.sp(n)) { x = n; break; }
  if (x !== null) {
    PP.rect(ctx, T.X(x) - 7, T.Y(1.08), 14, T.Y(-0.04) - T.Y(1.08), null, C("--okband"));
    PP.path(ctx, [[T.X(x), T.Y(0)], [T.X(x), T.Y(1)]], C("--ok"), 2.5);
    PP.label(ctx, "|f_S(x) − f_S′(x)| = 1", T.X(x) + 9, T.Y(1.2), C("--ok"), "left", "middle", 11);
  }
  for (let n = 1; n <= M; n++) {
    PP.dot(ctx, T.X(n), T.Y(P.s(n) ? 0 : 1), 4, C("--accent"));
    PP.dot(ctx, T.X(n), T.Y(P.sp(n) ? 0 : 1), 2.5, C("--seq2"));
  }
  PP.label(ctx, "— f_S", T.X(0.1), T.Y(0.78), C("--accent"), "left", "middle", 12);
  PP.label(ctx, "-- f_S′", T.X(0.1), T.Y(0.62), C("--seq2"), "left", "middle", 12);
  const lst = (f) => { const a = []; for (let n = 1; n <= M; n++) if (f(n)) a.push(n); return a.length ? "{" + a.join(", ") + "}" : "∅"; };
  PP.read(ID + "-c8-3-read1", [
    ["S = " + P.ls + " (hasta 12)", lst(P.s)],
    ["S′ = " + P.lsp + " (hasta 12)", lst(P.sp)],
    ["primer x en S Δ S′", x === null ? "—" : String(x) + (P.s(x) ? " ∈ S ∖ S′" : " ∈ S′ ∖ S")],
    ["‖f_S − f_S′‖∞", "≥ 1", "good"],
  ]);
}, ["input[name='" + ID + "-c8-3-par']"]);

/* ===================== C8-2 ===================== */

/* (a) colas de la subsucesión dentro de A_{j+1}. */
PP.register(function c82Colas() {
  const j = PP.val(ID + "-c8-2-j");
  PP.out(ID + "-c8-2-j-o", String(j));
  const R = 14;
  const { ctx, w, h } = PP.canvas(ID + "-c8-2-cv1", 0.78);
  const T = PP.frame(w, h, { x0: -1.2, x1: 2.25, y0: R + 0.8, y1: 0.2 }, { l: 40, r: 10, t: 10, b: 26 });
  // ojo: y0 > y1 para que A_1 quede arriba
  const lo = -1 / (j + 1), hi = 1 + 1 / (j + 1);
  PP.rect(ctx, T.X(lo), T.p.t, T.X(hi) - T.X(lo), h - T.p.t - T.p.b, null, C("--okband"));
  ctx.save(); ctx.font = "11px " + FONT; ctx.fillStyle = C("--muted"); ctx.textAlign = "center"; ctx.textBaseline = "top";
  [-1, 0, 1, 2].forEach((v) => ctx.fillText(String(v).replace("-", "−"), T.X(v), h - T.p.b + 6));
  ctx.restore();
  for (let n = 1; n <= R; n++) {
    const y = T.Y(n);
    PP.path(ctx, [[T.X(-1 / n), y], [T.X(1 + 1 / n), y]], n === j + 1 ? C("--ok") : C("--accent"), n === j + 1 ? 4 : 2.2);
    PP.label(ctx, "A" + sub(n), T.p.l - 5, y, n === j + 1 ? C("--ok") : C("--muted"), "right", "middle", 10.5);
  }
  PP.path(ctx, [[T.X(1), T.p.t], [T.X(1), h - T.p.b]], C("--ok"), 1.5, [4, 3]);
  PP.label(ctx, "x = 1", T.X(1) + 4, h - T.p.b - 2, C("--ok"), "left", "bottom", 11);
  for (let k = 1; 2 * k <= R; k++) {
    const n = 2 * k, tail = k >= j + 1;
    PP.dot(ctx, T.X(1 + 1 / n), T.Y(n), tail ? 6 : 3.5, tail ? C("--seq2") : C("--muted"));
  }
  PP.read(ID + "-c8-2-read1", [
    ["A" + sub(j + 1), "[" + PP.fmt(lo, 3) + ", " + PP.fmt(hi, 3) + "]"],
    ["cola (xₙₖ₊ⱼ)ₖ", "nₖ₊ⱼ = 2(k + " + j + ") ≥ " + (j + 1)],
    ["¿la cola está en A" + sub(j + 1) + "?", "sí", "good"],
    ["límite x = 1 ∈ A" + sub(j + 1), "sí (A" + sub(j + 1) + " cerrado)", "good"],
  ]);
}, [ID + "-c8-2-j"]);

/* (b) imágenes iteradas f^n(X) con X = [0, 1]. */
const c82f = (t) => 0.19 + 0.62 * t - 0.08 * Math.sin(2 * Math.PI * t);
PP.register(function c82Iteradas() {
  const n = PP.val(ID + "-c8-2-n");
  PP.out(ID + "-c8-2-n-o", String(n));
  const { ctx, w, h } = PP.canvas(ID + "-c8-2-cv2", 0.8);
  const bandsH = 11 * 8 + 14;
  const s = w - 60, sh = h - bandsH - 20;
  const ox = 44, oy = 10;
  const X = (u) => ox + u * s, Y = (v) => oy + (1 - v) * sh;
  PP.rect(ctx, ox, oy, s, sh, C("--rule"), C("--panel"));
  ctx.save(); ctx.font = "11px " + FONT; ctx.fillStyle = C("--muted"); ctx.textAlign = "right"; ctx.textBaseline = "middle";
  [0, 0.5, 1].forEach((v) => ctx.fillText(PP.fmt(v, 1).replace(".", ","), ox - 5, Y(v)));
  ctx.restore();
  PP.path(ctx, [[X(0), Y(0)], [X(1), Y(1)]], C("--muted"), 1, [4, 4]);
  const g = []; for (let i = 0; i <= 200; i++) { const t = i / 200; g.push([X(t), Y(c82f(t))]); }
  PP.path(ctx, g, C("--seq3"), 2.5);
  PP.label(ctx, "f", X(0.06), Y(c82f(0.06)) - 6, C("--seq3"), "left", "bottom", 13);
  // escalones desde 0 y desde 1
  [0, 1].forEach((t0) => {
    let t = t0; const st = [[X(t), Y(t)]];
    for (let m = 0; m < n; m++) { const v = c82f(t); st.push([X(t), Y(v)]); st.push([X(v), Y(v)]); t = v; }
    PP.path(ctx, st, C("--accent"), 1.3);
  });
  // bandas A_0 ... A_n debajo
  const by = oy + sh + 12;
  let a = 0, b = 1;
  for (let m = 0; m <= n; m++) {
    const y = by + m * 8;
    PP.rect(ctx, X(a), y, X(b) - X(a), 6, null, m === n ? C("--accent") : C("--area"));
    if (m < n) { a = c82f(a); b = c82f(b); }
  }
  PP.label(ctx, "A" + sub(n), X(b) + 5, by + n * 8 + 3, C("--accent"), "left", "middle", 11);
  PP.read(ID + "-c8-2-read2", [
    ["A" + sub(n) + " = f" + (n === 0 ? "⁰" : "ⁿ") + "(X)", "[" + PP.fmt(a, 4) + ", " + PP.fmt(b, 4) + "]"],
    ["longitud", PP.fmt(b - a, 4)],
    ["¿A" + sub(n + 1) + " ⊆ A" + sub(n) + "?", "sí", "good"],
  ]);
}, [ID + "-c8-2-n"]);

/* ===================== C8-1 ===================== */

PP.register(function c81() {
  const n = PP.val(ID + "-c8-1-n");
  PP.out(ID + "-c8-1-n-o", String(n));
  const { ctx, w, h } = PP.canvas(ID + "-c8-1-cv1", 0.68);
  const T = PP.frame(w, h, { x0: -0.04, x1: 1.06, y0: -0.06, y1: 1.02 }, { l: 38, r: 12, t: 12, b: 28 });
  PP.axes(ctx, T, { xLabel: "t", xTicks: 5, yTicks: 5 });
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1.0), T.Y(1.0)]], C("--muted"), 1, [3, 4]);
  PP.label(ctx, "pendiente 1", T.X(0.86), T.Y(0.86) - 6, C("--muted"), "right", "bottom", 11);
  const g = []; for (let i = 0; i <= 200; i++) { const t = i / 200; g.push([T.X(t), T.Y(Math.sin(t))]); }
  PP.path(ctx, g, C("--seq3"), 2.5);
  PP.label(ctx, "sen", T.X(1) - 2, T.Y(Math.sin(1)) + 6, C("--seq3"), "right", "top", 12);
  const xn = 1 / Math.sqrt(n), q = 1 - 1 / n;
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(1.0), T.Y(q)]], C("--seq2"), 1.5, [6, 4]);
  PP.path(ctx, [[T.X(0), T.Y(0)], [T.X(xn), T.Y(Math.sin(xn))]], C("--accent"), 2.5);
  PP.dot(ctx, T.X(xn), T.Y(Math.sin(xn)), 4.5, C("--accent"));
  PP.dot(ctx, T.X(xn), T.Y(0), 5, C("--accent"));
  PP.dot(ctx, T.X(0), T.Y(0), 5, null, C("--seq2"));
  PP.label(ctx, "xₙ", T.X(xn), T.Y(0) - 7, C("--accent"), "center", "bottom", 12);
  PP.label(ctx, "yₙ", T.X(0) - 6, T.Y(0) - 6, C("--seq2"), "right", "bottom", 12);
  const ratio = Math.sin(xn) / xn;
  PP.read(ID + "-c8-1-read1", [
    ["xₙ = 1/√n, yₙ = 0", PP.fmt(xn, 4) + ", 0"],
    ["d(f(xₙ), f(yₙ)) / d(xₙ, yₙ)", PP.fmt(ratio, 5)],
    ["1 − 1/n", PP.fmt(q, 5)],
    ["¿vale (1)?", ratio >= q ? "sí" : "no", ratio >= q ? "good" : "bad"],
    ["límites x, y", "0 y 0: x = y", "bad"],
  ]);
}, [ID + "-c8-1-n"]);
