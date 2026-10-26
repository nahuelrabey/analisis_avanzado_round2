/* Dibujos de la guía 8 (medida de Lebesgue). Usa window.PP. */
const ID = "guiap8";
const C = (t) => PP.css(t);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const FONT = "11px 'IBM Plex Sans', system-ui, sans-serif";
const fx = (x, d) => PP.fmt(x, d === undefined ? 3 : d);

/* Arrastre sobre un canvas: pick(px, py, T) devuelve un id o null; move(id, x, y, T) actualiza. */
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

/* Recta con filas: la fila r (1 = arriba) está en y = r. Devuelve el marco. */
function rows(cid, nrows, x0, x1, ratio, padL) {
  const { ctx, w, h } = PP.canvas(cid, ratio);
  const T = PP.frame(w, h, { x0, x1, y0: nrows + 0.55, y1: 0.45 }, { l: padL || 58, r: 14, t: 6, b: 26 });
  const step = PP.niceStep(x1 - x0, w < 420 ? 4 : 7);
  ctx.save();
  ctx.font = FONT; ctx.fillStyle = C("--muted"); ctx.strokeStyle = C("--rule"); ctx.lineWidth = 1;
  ctx.textAlign = "center"; ctx.textBaseline = "top";
  for (let x = Math.ceil(x0 / step) * step; x <= x1 + 1e-9; x += step) {
    ctx.beginPath(); ctx.moveTo(T.X(x), T.p.t); ctx.lineTo(T.X(x), h - T.p.b); ctx.stroke();
    ctx.fillText(fx(x, 2), T.X(x), h - T.p.b + 6);
  }
  ctx.restore();
  for (let r = 1; r <= nrows; r++) PP.path(ctx, [[T.p.l, T.Y(r)], [w - T.p.r, T.Y(r)]], C("--rule"), 1);
  return { ctx, T, w, h };
}
function rowLabel(ctx, T, text, r, color) { PP.label(ctx, text, T.p.l - 8, T.Y(r), color || C("--ink"), "right", "middle", 12); }

/* Intervalo [a, b] en la fila r; ca / cb: extremo cerrado. b = Infinity dibuja una flecha. */
function seg(ctx, T, a, b, r, color, ca, cb, width) {
  const y = T.Y(r), xa = T.X(a), xb = isFinite(b) ? T.X(b) : T.w - T.p.r;
  const lw = width || 5;
  ctx.save(); ctx.strokeStyle = color; ctx.lineWidth = lw; ctx.lineCap = "butt";
  ctx.beginPath(); ctx.moveTo(xa, y); ctx.lineTo(Math.max(xb, xa + 1.5), y); ctx.stroke(); ctx.restore();
  if (!isFinite(b)) {
    PP.path(ctx, [[xb - 9, y - 6], [xb, y], [xb - 9, y + 6]], color, 2.2);
  }
  if (isFinite(b) && xb - xa < 18) return;  /* intervalos cortos: sin marcas de extremos, que taparían el segmento */
  const end = (x, closed) => PP.dot(ctx, x, y, 4.2, closed ? color : C("--bg"), color);
  if (ca !== undefined && ca !== null) end(xa, ca);
  if (isFinite(b) && cb !== undefined && cb !== null) end(xb, cb);
}

/* Unión de intervalos {a, b, ca, cb}: ordena y junta los que se pisan. */
function union(list) {
  const L = list.filter((I) => I.b > I.a || (I.b === I.a && I.ca && I.cb)).map((I) => Object.assign({}, I)).sort((p, q) => p.a - q.a);
  const out = [];
  L.forEach((I) => {
    const c = out[out.length - 1];
    if (c && (I.a < c.b || (I.a === c.b && (c.cb || I.ca)))) {
      if (I.b > c.b) { c.b = I.b; c.cb = I.cb; } else if (I.b === c.b) c.cb = c.cb || I.cb;
    } else out.push(I);
  });
  return out;
}
const len = (L) => L.reduce((s, I) => s + Math.max(0, I.b - I.a), 0);
/* Diferencia L \ M de uniones de intervalos (sólo longitudes y extremos aproximados para dibujar). */
function minus(L, M) {
  let cur = L.map((I) => Object.assign({}, I));
  M.forEach((J) => {
    const nxt = [];
    cur.forEach((I) => {
      if (J.b <= I.a || J.a >= I.b) { nxt.push(I); return; }
      if (J.a > I.a || (J.a === I.a && I.ca && !J.ca)) nxt.push({ a: I.a, b: J.a, ca: I.ca, cb: !J.ca });
      if (J.b < I.b || (J.b === I.b && I.cb && !J.cb)) nxt.push({ a: J.b, b: I.b, ca: !J.cb, cb: I.cb });
    });
    cur = nxt;
  });
  return cur;
}
const ivText = (L) => L.length ? L.map((I) => (I.ca ? "[" : "(") + fx(I.a) + ", " + fx(I.b) + (I.cb ? "]" : ")")).join(" ∪ ") : "∅";

/* ===================== Ejercicio 3 ===================== */
(function () {
  const Q = [];
  for (let q = 1; Q.length < 40; q++) for (let p = 0; p <= q; p++) {
    const g = (a, b) => (b ? g(b, a % b) : a);
    if (g(p, q) === 1 || (q === 1)) { const v = p / q; if (!Q.some((u) => Math.abs(u - v) < 1e-12)) Q.push(v); }
  }
  const draw = function ej3() {
    const eps = PP.val(ID + "-ej3-eps") / 100, N = PP.val(ID + "-ej3-N");
    PP.out(ID + "-ej3-eps-o", fx(eps, 2)); PP.out(ID + "-ej3-N-o", String(N));
    const nr = N + 1;
    const { ctx, T } = rows(ID + "-ej3-c", nr, -0.15, 1.15, 0.5 + 0.022 * N, 44);
    let total = 0;
    for (let k = 1; k <= N; k++) {
      const q = Q[k - 1], L = eps / Math.pow(2, k);
      total += L;
      const color = k % 2 ? C("--accent") : C("--seq3");
      seg(ctx, T, q - L / 2, q + L / 2, k, color, false, false, N > 14 ? 3 : 5);
      PP.dot(ctx, T.X(q), T.Y(k), 2.2, C("--ink"));
      if (N <= 12 || k === 1 || k % 4 === 0) rowLabel(ctx, T, "I" + String(k).split("").map((d) => "₀₁₂₃₄₅₆₇₈₉"[+d]).join(""), k, color);
    }
    // todos los puntos sobre la recta
    for (let k = 1; k <= N; k++) PP.dot(ctx, T.X(Q[k - 1]), T.Y(nr), 3.2, C("--seq2"));
    rowLabel(ctx, T, "qₖ", nr, C("--seq2"));
    PP.read(ID + "-ej3-read", [
      ["ℓ(I<sub>k</sub>)", "ε/2<sup>k</sup>"],
      ["ℓ(I<sub>1</sub>) + … + ℓ(I<sub>N</sub>)", fx(total, 5), total < eps ? "good" : "bad"],
      ["ε", fx(eps, 2)],
    ]);
  };
  PP.register(draw, [ID + "-ej3-eps", ID + "-ej3-N"]);
})();

/* ===================== Ejercicio 4 ===================== */
(function () {
  const S = { a: -1, b: 2.5 };
  let lastT = null;
  const draw = function ej4() {
    const { ctx, T } = rows(ID + "-ej4-c", 3, -3, 6, 0.42, 72);
    lastT = T;
    seg(ctx, T, S.a, S.b, 1, C("--accent"), true, false);
    seg(ctx, T, S.a, S.b, 2, C("--seq3"), true, true);
    seg(ctx, T, S.a, Infinity, 3, C("--seq2"), true, null);
    rowLabel(ctx, T, "[a, b)", 1, C("--accent"));
    rowLabel(ctx, T, "[a, b]", 2, C("--seq3"));
    rowLabel(ctx, T, "[a, +∞)", 3, C("--seq2"));
    PP.label(ctx, "a", T.X(S.a), T.Y(1) - 8, C("--ink"), "center", "bottom", 12);
    PP.label(ctx, "b", T.X(S.b), T.Y(1) - 8, C("--ink"), "center", "bottom", 12);
    PP.read(ID + "-ej4-read", [["a", fx(S.a, 2)], ["b", fx(S.b, 2)]]);
  };
  PP.register(draw, []);
  draggable(ID + "-ej4-c", () => lastT,
    (px, py, T) => {
      const da = Math.abs(px - T.X(S.a)), db = Math.abs(px - T.X(S.b));
      if (Math.min(da, db) > 22) return null;
      return da <= db ? "a" : "b";
    },
    (k, x) => {
      if (k === "a") S.a = clamp(Math.round(x * 10) / 10, -3, S.b - 0.1);
      else S.b = clamp(Math.round(x * 10) / 10, S.a + 0.1, 6);
    }, draw);
})();

/* ===================== Ejercicio 8 ===================== */
(function () {
  const S = { A: [1, 5.5], B: [3.5, 8.5] };
  let lastT = null;
  const draw = function ej8() {
    const { ctx, T } = rows(ID + "-ej8-c", 4, 0, 10, 0.5, 62);
    lastT = T;
    const A = { a: S.A[0], b: S.A[1], ca: true, cb: true }, B = { a: S.B[0], b: S.B[1], ca: true, cb: true };
    const U = union([A, B]);
    const lo = Math.max(A.a, B.a), hi = Math.min(A.b, B.b);
    const I = lo <= hi ? [{ a: lo, b: hi, ca: true, cb: true }] : [];
    seg(ctx, T, A.a, A.b, 1, C("--accent"), true, true);
    seg(ctx, T, B.a, B.b, 2, C("--seq2"), true, true);
    U.forEach((J) => seg(ctx, T, J.a, J.b, 3, C("--seq3"), true, true));
    I.forEach((J) => seg(ctx, T, J.a, J.b, 4, C("--ok"), true, true));
    rowLabel(ctx, T, "A", 1, C("--accent"));
    rowLabel(ctx, T, "B", 2, C("--seq2"));
    rowLabel(ctx, T, "A ∪ B", 3, C("--seq3"));
    rowLabel(ctx, T, "A ∩ B", 4, C("--ok"));
    if (!I.length) PP.label(ctx, "∅", T.p.l + 6, T.Y(4), C("--ok"), "left", "middle", 13);
    const mA = A.b - A.a, mB = B.b - B.a, mU = len(U), mI = len(I);
    PP.read(ID + "-ej8-read", [
      ["μ(A) + μ(B)", fx(mA, 2) + " + " + fx(mB, 2) + " = " + fx(mA + mB, 2)],
      ["μ(A ∪ B) + μ(A ∩ B)", fx(mU, 2) + " + " + fx(mI, 2) + " = " + fx(mU + mI, 2), "good"],
    ]);
  };
  PP.register(draw, []);
  draggable(ID + "-ej8-c", () => lastT,
    (px, py, T) => {
      let best = null, bd = 24;
      [["A", 1], ["B", 2]].forEach(([s, r]) => [0, 1].forEach((i) => {
        const d = Math.hypot(px - T.X(S[s][i]), (py - T.Y(r)) * 0.6);
        if (d < bd) { bd = d; best = s + i; }
      }));
      return best;
    },
    (k, x) => {
      const s = k[0], i = +k[1], v = clamp(Math.round(x * 4) / 4, 0, 10);
      if (i === 0) S[s][0] = Math.min(v, S[s][1] - 0.25); else S[s][1] = Math.max(v, S[s][0] + 0.25);
    }, draw);
})();

/* ===================== Ejercicio 11 ===================== */
(function () {
  const A = [{ a: 0.1, b: 0.4, ca: true, cb: false }, { a: 0.55, b: 0.85, ca: false, cb: true }];
  const draw = function ej11() {
    const n = PP.val(ID + "-ej11-n");
    PP.out(ID + "-ej11-n-o", String(n));
    const d = 0.15 / n;
    const F = [{ a: 0.1, b: 0.4 - d, ca: true, cb: true }, { a: 0.55 + d, b: 0.85, ca: true, cb: true }];
    const G = union([{ a: 0.1 - d, b: 0.4 + d, ca: false, cb: false }, { a: 0.55 - d, b: 0.85 + d, ca: false, cb: false }]);
    const { ctx, T } = rows(ID + "-ej11-c", 3, -0.1, 1.1, 0.42, 48);
    G.forEach((I) => seg(ctx, T, I.a, I.b, 3, C("--seq2"), false, false));
    A.forEach((I) => seg(ctx, T, I.a, I.b, 1, C("--accent"), I.ca, I.cb));
    F.forEach((I) => seg(ctx, T, I.a, I.b, 2, C("--seq3"), true, true));
    rowLabel(ctx, T, "A", 1, C("--accent"));
    rowLabel(ctx, T, "Fₙ", 2, C("--seq3"));
    rowLabel(ctx, T, "Gₙ", 3, C("--seq2"));
    PP.read(ID + "-ej11-read", [
      ["A", ivText(A)],
      ["F<sub>n</sub> (cerrado, ⊆ A)", ivText(F)],
      ["G<sub>n</sub> (abierto, ⊇ A)", ivText(G)],
    ]);
  };
  PP.register(draw, [ID + "-ej11-n"]);
})();

/* ===================== Ejercicio 12 ===================== */
(function () {
  const A = [{ a: 0.1, b: 0.3, ca: true, cb: false }, { a: 0.45, b: 0.6, ca: false, cb: false }, { a: 0.7, b: 0.9, ca: true, cb: true }];
  const draw = function ej12() {
    const eps = PP.val(ID + "-ej12-eps") / 100;
    PP.out(ID + "-ej12-eps-o", fx(eps, 2));
    const d = eps / 13;
    const F = A.map((I) => ({ a: I.a + d, b: I.b - d, ca: true, cb: true }));
    const G = union(A.map((I) => ({ a: I.a - d, b: I.b + d, ca: false, cb: false })));
    const D = minus(G, F);
    const { ctx, T } = rows(ID + "-ej12-c", 4, -0.05, 1.05, 0.48, 58);
    A.forEach((I) => seg(ctx, T, I.a, I.b, 1, C("--accent"), I.ca, I.cb));
    F.forEach((I) => seg(ctx, T, I.a, I.b, 2, C("--seq3"), true, true));
    G.forEach((I) => seg(ctx, T, I.a, I.b, 3, C("--seq2"), false, false));
    D.forEach((I) => seg(ctx, T, I.a, I.b, 4, C("--fail"), I.ca, I.cb, 6));
    rowLabel(ctx, T, "A", 1, C("--accent"));
    rowLabel(ctx, T, "F", 2, C("--seq3"));
    rowLabel(ctx, T, "G", 3, C("--seq2"));
    rowLabel(ctx, T, "G \\ F", 4, C("--fail"));
    const m = len(G) - len(F);
    PP.read(ID + "-ej12-read", [
      ["δ = ε/13", fx(d, 4)],
      ["μ(G \\ F) = 12δ", fx(m, 4), m < eps ? "good" : "bad"],
      ["ε", fx(eps, 2)],
    ]);
  };
  PP.register(draw, [ID + "-ej12-eps"]);
})();

/* ===================== Ejercicio 13 ===================== */
(function () {
  const B = { a: 0.2, b: 0.7, ca: true, cb: true };
  const draw = function ej13() {
    const n = PP.val(ID + "-ej13-n");
    PP.out(ID + "-ej13-n-o", String(n));
    const An = { a: 0.2 + 0.3 / n, b: 0.7 + 0.25 / n, ca: true, cb: true };
    const D = minus([B], [An]).concat(minus([An], [B]));
    const { ctx, T } = rows(ID + "-ej13-c", 3, 0, 1, 0.42, 58);
    seg(ctx, T, B.a, B.b, 1, C("--accent"), true, true);
    seg(ctx, T, An.a, An.b, 2, C("--seq2"), true, true);
    D.forEach((I) => seg(ctx, T, I.a, I.b, 3, C("--fail"), I.ca, I.cb, 6));
    rowLabel(ctx, T, "B", 1, C("--accent"));
    rowLabel(ctx, T, "Aₙ", 2, C("--seq2"));
    rowLabel(ctx, T, "Aₙ Δ B", 3, C("--fail"));
    PP.read(ID + "-ej13-read", [
      ["μ(A<sub>n</sub> Δ B)", fx(len(D), 4)],
      ["μ(A<sub>n</sub>)", fx(An.b - An.a, 4)],
      ["μ(B)", fx(B.b - B.a, 4)],
    ]);
  };
  PP.register(draw, [ID + "-ej13-n"]);
})();

/* ===================== Ejercicio 14 ===================== */
(function () {
  const A = [[0.5, 1], [1.5, 2.5]];
  const draw = function ej14() {
    const c = PP.val(ID + "-ej14-c-s") / 10;
    PP.out(ID + "-ej14-c-s-o", fx(c, 1));
    const { ctx, T } = rows(ID + "-ej14-c", 2, -5.5, 5.5, 0.34, 40);
    PP.path(ctx, [[T.X(0), T.p.t], [T.X(0), T.h - T.p.b]], C("--muted"), 1);
    A.forEach(([a, b]) => seg(ctx, T, a, b, 1, C("--accent"), true, true));
    const cA = A.map(([a, b]) => [Math.min(c * a, c * b), Math.max(c * a, c * b)]).sort((p, q) => p[0] - q[0]);
    cA.forEach(([a, b]) => seg(ctx, T, a, b, 2, C("--seq2"), true, true));
    rowLabel(ctx, T, "A", 1, C("--accent"));
    rowLabel(ctx, T, "cA", 2, C("--seq2"));
    PP.read(ID + "-ej14-read", [
      ["A", "[0.5, 1] ∪ [1.5, 2.5]"],
      ["cA", c === 0 ? "{0}" : cA.map(([a, b]) => "[" + fx(a, 2) + ", " + fx(b, 2) + "]").join(" ∪ ")],
    ]);
  };
  PP.register(draw, [ID + "-ej14-c-s"]);
})();
