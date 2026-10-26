/* Dibujos de los ejemplos de la Práctica 2 (cardinalidad). Usa window.PP. */
const C = (t) => PP.css(t);
const FONT = (s, w) => (w ? w + " " : "") + s + "px 'IBM Plex Sans', system-ui, sans-serif";
const gcd = (a, b) => { a = Math.abs(a); b = Math.abs(b); while (b) { [a, b] = [b, a % b]; } return a; };
const neg = (s) => String(s).replace("-", "−");
const frac = (p, q) => { const g = gcd(p, q) || 1; p /= g; q /= g; if (q < 0) { p = -p; q = -q; } return q === 1 ? neg(p) : neg(p) + "/" + q; };
const SUP = "⁰¹²³⁴⁵⁶⁷⁸⁹", SUB = "₀₁₂₃₄₅₆₇₈₉";
const sup = (n) => String(n).split("").map((d) => (d === "-" ? "⁻" : SUP[+d])).join("");
const sub = (n) => String(n).split("").map((d) => SUB[+d]).join("");
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));

/* Flecha recta con punta. */
function arrow(ctx, x0, y0, x1, y1, color, width, dash, head) {
  PP.path(ctx, [[x0, y0], [x1, y1]], color, width || 1.5, dash);
  const a = Math.atan2(y1 - y0, x1 - x0), L = head || 7;
  PP.path(ctx, [[x1 - L * Math.cos(a - 0.4), y1 - L * Math.sin(a - 0.4)], [x1, y1], [x1 - L * Math.cos(a + 0.4), y1 - L * Math.sin(a + 0.4)]], color, width || 1.5);
}

/* Toque o arrastre sobre un canvas: handler(px, py, tipo) con coordenadas en píxeles CSS. */
function pointer(id, handler, drag) {
  const cv = document.getElementById(id);
  if (!cv) return;
  cv.style.cursor = drag ? "grab" : "pointer";
  if (drag) cv.style.touchAction = "none";
  let active = false;
  const pos = (e) => { const r = cv.getBoundingClientRect(); return [e.clientX - r.left, e.clientY - r.top]; };
  cv.addEventListener("pointerdown", (e) => {
    const [px, py] = pos(e);
    const took = handler(px, py, "down");
    if (drag && took) { active = true; cv.setPointerCapture(e.pointerId); cv.style.cursor = "grabbing"; e.preventDefault(); }
  });
  if (drag) {
    cv.addEventListener("pointermove", (e) => { if (!active) return; const [px, py] = pos(e); handler(px, py, "move"); });
    const end = () => { active = false; cv.style.cursor = "grab"; };
    cv.addEventListener("pointerup", end);
    cv.addEventListener("pointercancel", end);
  }
}

/* ===================== 13 · ℕ ∼ ℤ y ℕ ∼ ℚ⁺ ===================== */

/* Recorrido en zigzag de la grilla m/n (columna m, fila n), diagonales d = m + n. */
const ZZ_SIZE = 6;
const ZZ_ORDER = (() => {
  const out = [];
  for (let d = 2; d <= ZZ_SIZE + 1; d++) {
    const ms = [];
    for (let m = 1; m <= d - 1; m++) ms.push(m);
    if (d % 2 === 1) ms.reverse();
    ms.forEach((m) => out.push({ m, n: d - m, rep: gcd(m, d - m) > 1 }));
  }
  return out;
})();

PP.register(function zigzag() {
  const k = PP.val("ejp2-13-k");
  PP.out("ejp2-13-k-o", String(k));
  const { ctx, w, h } = PP.canvas("ejp2-13-c1", 0.92);
  const L = 44, Tp = 34, s = Math.min((w - L - 14) / ZZ_SIZE, (h - Tp - 14) / ZZ_SIZE);
  const X = (m) => L + (m - 0.5) * s, Y = (n) => Tp + (n - 0.5) * s;
  PP.label(ctx, "numeradores (m)", L + ZZ_SIZE * s / 2, 12, C("--muted"), "center", "middle", 11);
  for (let m = 1; m <= ZZ_SIZE; m++) PP.label(ctx, "m=" + m, X(m), Tp - 6, C("--muted"), "center", "bottom", 10);
  for (let n = 1; n <= ZZ_SIZE; n++) PP.label(ctx, "n=" + n, L - 6, Y(n), C("--muted"), "right", "middle", 10);
  // camino hasta el k-ésimo valor no repetido
  let cnt = 0, last = 0;
  const vis = [];
  for (let i = 0; i < ZZ_ORDER.length; i++) {
    const c = ZZ_ORDER[i];
    if (!c.rep) { cnt++; vis.push({ c, idx: cnt }); }
    last = i;
    if (cnt === k) break;
  }
  const pts = ZZ_ORDER.slice(0, last + 1).map((c) => [X(c.m), Y(c.n)]);
  if (pts.length > 1) {
    PP.path(ctx, pts, C("--accent"), 2);
    const a = pts[pts.length - 2], b = pts[pts.length - 1];
    const t = 1 - 9 / Math.hypot(b[0] - a[0], b[1] - a[1]);
    arrow(ctx, a[0], a[1], a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, C("--accent"), 2, null, 8);
  }
  // puntos, fracciones y repetidos
  const fs = Math.max(9, Math.min(11, s / 4.6));
  for (let n = 1; n <= ZZ_SIZE; n++) for (let m = 1; m <= ZZ_SIZE; m++) {
    const rep = gcd(m, n) > 1;
    PP.dot(ctx, X(m), Y(n), 3, C(rep ? "--muted" : "--ink"));
    PP.label(ctx, m + "/" + n, X(m), Y(n) - 6, C("--muted"), "center", "bottom", fs);
    if (rep) {
      const r = 6;
      PP.path(ctx, [[X(m) - r, Y(n) - r], [X(m) + r, Y(n) + r]], C("--fail"), 2);
      PP.path(ctx, [[X(m) - r, Y(n) + r], [X(m) + r, Y(n) - r]], C("--fail"), 2);
    }
  }
  vis.forEach(({ c, idx }) => {
    PP.dot(ctx, X(c.m), Y(c.n), 5.5, C("--accent"));
    PP.label(ctx, String(idx), X(c.m) + 6, Y(c.n) + 4, C("--accent"), "left", "top", 10);
  });
  const vals = vis.map(({ c, idx }) => "f(" + idx + ") = " + frac(c.m, c.n));
  const skipped = ZZ_ORDER.slice(0, last + 1).filter((c) => c.rep).map((c) => c.m + "/" + c.n);
  PP.read("ejp2-13-read1", [
    ["últimos valores", vals.slice(-3).join(", ")],
    ["salteados", skipped.length ? skipped.join(", ") : "ninguno todavía"],
    ["¿repetidos?", "no (sólo irreducibles)", "good"],
  ]);
}, ["ejp2-13-k"]);

const f13 = (n) => (n % 2 === 0 ? n / 2 : -(n - 1) / 2);

/* Dos filas, ℕ arriba y ℤ abajo, con las flechas de f. */
function drawNZ(cid, Nmax, zMin, zMax, hi) {
  const { ctx, w, h } = PP.canvas(cid, 0.5);
  const yT = 34, yB = h - 34, l = 26, r = 14;
  const XN = (n) => l + (n - 1) / Math.max(1, Nmax - 1) * (w - l - r);
  const XZ = (z) => l + (z - zMin) / Math.max(1, zMax - zMin) * (w - l - r);
  PP.label(ctx, "ℕ", 4, yT, C("--ink"), "left", "middle", 13);
  PP.label(ctx, "ℤ", 4, yB, C("--ink"), "left", "middle", 13);
  for (let n = 1; n <= Nmax; n++) {
    const z = f13(n);
    if (z < zMin || z > zMax) continue;
    const even = n % 2 === 0;
    const on = hi === null || hi === n;
    const col = on ? C(even ? "--accent" : "--seq2") : C("--rule");
    arrow(ctx, XN(n), yT + 7, XZ(z), yB - 8, col, on && hi !== null ? 2.5 : 1.3, null, 6);
  }
  const fs = Nmax > 14 ? 9 : 11;
  for (let n = 1; n <= Nmax; n++) {
    const on = hi === null || hi === n;
    PP.dot(ctx, XN(n), yT, on ? 3.5 : 2.5, on ? C(n % 2 === 0 ? "--accent" : "--seq2") : C("--muted"));
    PP.label(ctx, String(n), XN(n), yT - 6, on ? C("--ink") : C("--muted"), "center", "bottom", fs);
  }
  for (let z = zMin; z <= zMax; z++) {
    const on = hi === null || f13(hi) === z;
    PP.dot(ctx, XZ(z), yB, on ? 3.5 : 2.5, on ? C(z > 0 ? "--accent" : "--seq2") : C("--muted"));
    PP.label(ctx, neg(z), XZ(z), yB + 7, on ? C("--ink") : C("--muted"), "center", "top", fs);
  }
}

PP.register(function nz1() {
  const N = PP.val("ejp2-13-N");
  PP.out("ejp2-13-N-o", String(N));
  const zMin = -Math.ceil(N / 2) + 1, zMax = Math.floor(N / 2);
  drawNZ("ejp2-13-c2", N, zMin, zMax, null);
  const imgs = [];
  for (let n = 1; n <= N; n++) imgs.push(f13(n));
  PP.read("ejp2-13-read2", [
    ["pares ↦", "1, 2, …, " + zMax + " (positivos)"],
    ["impares ↦", "0, −1, …, " + neg(zMin) + " (cero y negativos)"],
    ["imágenes distintas", imgs.length + " de " + N + (new Set(imgs).size === N ? " ✓" : ""), "good"],
  ]);
}, ["ejp2-13-N"]);

PP.register(function nz2() {
  const a = PP.val("ejp2-13-a");
  PP.out("ejp2-13-a-o", neg(a));
  const n = a > 0 ? 2 * a : -2 * a + 1;
  drawNZ("ejp2-13-c3", 17, -8, 8, n);
  PP.read("ejp2-13-read3", [
    ["a", neg(a) + (a > 0 ? "  (positivo)" : "  (≤ 0)")],
    ["preimagen", a > 0 ? "2a = " + n + " (par)" : "−2a + 1 = " + n + " (impar)"],
    ["f(" + n + ")", neg(f13(n)) + " = a ✓", "good"],
  ]);
}, ["ejp2-13-a"]);

/* ===================== A1.5.6a · ℚ por bloques ===================== */

function blockElems(n) {
  if (n === 1) return [{ s: "0", ok: true }];
  const out = [];
  for (let p = 1; p <= n - 1; p++) out.push({ s: p + "/" + (n - p), ok: gcd(p, n - p) === 1 });
  return out;
}
const blockSize = (n) => (n === 1 ? 1 : 2 * blockElems(n).filter((e) => e.ok).length);

PP.register(function bloques() {
  const K = PP.val("ejp2-a156a-K");
  PP.out("ejp2-a156a-K-o", "A" + sub(K));
  const rowH = 30;
  const el = document.getElementById("ejp2-a156a-c1");
  const W = el.clientWidth || 480;
  const { ctx, w, h } = PP.canvas(el, (K * rowH + 26) / W);
  const L = 34, R = 34;
  const cw = (w - L - R) / Math.max(1, K - 1);
  const fs = Math.max(8.5, Math.min(12, cw / 3.6));
  let total = 0;
  for (let n = 1; n <= K; n++) {
    const y = 16 + (n - 0.5) * rowH;
    if (n % 2 === 0) PP.rect(ctx, 2, y - rowH / 2 + 2, w - 4, rowH - 4, null, C("--band"));
    PP.label(ctx, "A" + sub(n), 6, y, C("--ink"), "left", "middle", 12);
    const els = blockElems(n);
    els.forEach((e, i) => {
      const x = L + (i + 0.5) * cw;
      const txt = n === 1 ? "0" : "±" + e.s;
      PP.label(ctx, txt, x, y, e.ok ? C("--accent") : C("--muted"), "center", "middle", fs);
      if (!e.ok) {
        ctx.save(); ctx.font = FONT(fs); const tw = ctx.measureText(txt).width; ctx.restore();
        PP.path(ctx, [[x - tw / 2, y], [x + tw / 2, y]], C("--fail"), 1.5);
      }
    });
    const sz = blockSize(n);
    total += sz;
    PP.label(ctx, String(sz), w - 6, y, C("--muted"), "right", "middle", 11);
  }
  PP.label(ctx, "tamaño", w - 6, 8, C("--muted"), "right", "middle", 10);
  PP.read("ejp2-a156a-read1", [
    ["|A₁|, …, |A" + sub(K) + "|", Array.from({ length: K }, (_, i) => blockSize(i + 1)).join(", ")],
    ["elementos hasta A" + sub(K), String(total) + " (finitos)"],
    ["cota del texto", "|Aₙ| ≤ 2(n − 1)", "good"],
  ]);
}, ["ejp2-a156a-K"]);

PP.register(function cinta() {
  const p0 = PP.val("ejp2-a156a-p"), q0 = PP.val("ejp2-a156a-q");
  PP.out("ejp2-a156a-p-o", String(p0)); PP.out("ejp2-a156a-q-o", String(q0));
  const g = gcd(p0, q0), p = p0 / g, q = q0 / g, n = p + q;
  let before = 0;
  for (let j = 1; j < n; j++) before += blockSize(j);
  let idx = 0;
  for (let pp = 1; pp < p; pp++) if (gcd(pp, n - pp) === 1) idx += 2;
  const pos = before + idx + 1;
  const last = n + 1;
  let tot = 0; const sizes = [];
  for (let j = 1; j <= last; j++) { sizes.push(blockSize(j)); tot += blockSize(j); }
  const { ctx, w, h } = PP.canvas("ejp2-a156a-c2", 0.4);
  const l = 14, r = 14, y0 = 40, th = 26;
  const Xp = (k) => l + k / tot * (w - l - r);
  let acc = 0;
  sizes.forEach((sz, i) => {
    const x0 = Xp(acc), x1 = Xp(acc + sz);
    PP.rect(ctx, x0, y0, Math.max(0.6, x1 - x0), th, null, i % 2 ? C("--area") : C("--area2"));
    if (x1 - x0 > 16 || i + 1 === n) PP.label(ctx, "A" + sub(i + 1), (x0 + x1) / 2, y0 + th + 4, i + 1 === n ? C("--ink") : C("--muted"), "center", "top", 10);
    acc += sz;
  });
  PP.rect(ctx, Xp(0), y0, Xp(tot) - Xp(0), th, C("--rule"), null);
  const xm = Xp(pos - 0.5);
  PP.path(ctx, [[xm, y0 - 14], [xm, y0 + th]], C("--accent"), 2.5);
  PP.dot(ctx, xm, y0 - 14, 4, C("--accent"));
  PP.label(ctx, frac(p, q) + " en el lugar " + pos, clamp(xm, l + 60, w - r - 120), y0 - 20, C("--accent"), "center", "bottom", 12);
  // zoom del bloque Aₙ alrededor de p/q
  const elems = [];
  for (let pp = 1; pp < n; pp++) if (gcd(pp, n - pp) === 1) { elems.push(pp + "/" + (n - pp)); elems.push("−" + pp + "/" + (n - pp)); }
  const show = Math.min(elems.length, w < 420 ? 5 : 7);
  const st = clamp(idx - Math.floor(show / 2), 0, elems.length - show);
  const yz = y0 + th + 52, gap = 6;
  const bw = Math.min(64, (w - l - r - 40) / show - gap);
  const zx0 = (w - show * (bw + gap)) / 2;
  const segA = Xp(before), segB = Xp(before + blockSize(n));
  PP.path(ctx, [[segA, y0 + th], [zx0, yz - 12]], C("--muted"), 1, [3, 3]);
  PP.path(ctx, [[segB, y0 + th], [zx0 + show * (bw + gap) - gap, yz - 12]], C("--muted"), 1, [3, 3]);
  for (let i = 0; i < show; i++) {
    const e = st + i, x = zx0 + i * (bw + gap), sel = e === idx;
    PP.rect(ctx, x, yz - 12, bw, 24, sel ? C("--accent") : C("--rule"), sel ? C("--area") : null);
    PP.label(ctx, elems[e], x + bw / 2, yz, sel ? C("--ink") : C("--muted"), "center", "middle", Math.min(12, bw / 3.6));
    PP.label(ctx, String(before + e + 1), x + bw / 2, yz + 16, sel ? C("--accent") : C("--muted"), "center", "top", 9.5);
  }
  if (st > 0) PP.label(ctx, "…", zx0 - 4, yz, C("--muted"), "right", "middle", 12);
  if (st + show < elems.length) PP.label(ctx, "…", zx0 + show * (bw + gap), yz, C("--muted"), "left", "middle", 12);
  PP.label(ctx, "la cinta dibujada llega al lugar " + tot, w - r, h - 4, C("--muted"), "right", "bottom", 10);
  PP.read("ejp2-a156a-read2", [
    ["fracción", p0 + "/" + q0 + (g > 1 ? " = " + p + "/" + q + " (irreducible)" : " (ya irreducible)")],
    ["bloque", "A" + sub(n) + "  (p + q = " + n + ")"],
    ["antes de Aₙ", "|A₁| + … + |A" + sub(n - 1) + "| = " + before],
    ["lugar en la lista", String(pos) + " (finito)", "good"],
  ]);
}, ["ejp2-a156a-p", "ejp2-a156a-q"]);

/* ===================== 14 · g(n, m) = 2ⁿ3ᵐ ===================== */

PP.register(function grilla23() {
  const n = PP.val("ejp2-14-n"), m = PP.val("ejp2-14-m");
  PP.out("ejp2-14-n-o", String(n)); PP.out("ejp2-14-m-o", String(m));
  const { ctx, w, h } = PP.canvas("ejp2-14-c1", 0.72);
  const L = 44, Tp = 30, S = 5;
  const cw = (w - L - 10) / S, chh = (h - Tp - 10) / S;
  PP.label(ctx, "n →", L - 6, Tp - 14, C("--muted"), "right", "middle", 11);
  for (let i = 1; i <= S; i++) PP.label(ctx, String(i), L + (i - 0.5) * cw, Tp - 6, C("--muted"), "center", "bottom", 11);
  for (let j = 1; j <= S; j++) PP.label(ctx, "m=" + j, L - 6, Tp + (j - 0.5) * chh, C("--muted"), "right", "middle", 11);
  PP.rect(ctx, L, Tp, S * cw, chh, null, C("--area3"));
  for (let j = 1; j <= S; j++) for (let i = 1; i <= S; i++) {
    const x = L + (i - 1) * cw, y = Tp + (j - 1) * chh;
    const sel = i === n && j === m;
    PP.rect(ctx, x + 1, y + 1, cw - 2, chh - 2, sel ? C("--accent") : C("--rule"), sel ? C("--area") : null);
    PP.label(ctx, String(Math.pow(2, i) * Math.pow(3, j)), x + cw / 2, y + chh / 2, sel ? C("--ink") : C("--muted"), "center", "middle", Math.min(12, cw / 3.6));
  }
  PP.label(ctx, "imagen de f", L + S * cw - 4, Tp + 3, C("--seq3"), "right", "top", 10);
  let v = Math.pow(2, n) * Math.pow(3, m), a = 0, b = 0;
  while (v % 2 === 0) { v /= 2; a++; }
  while (v % 3 === 0) { v /= 3; b++; }
  PP.read("ejp2-14-read1", [
    ["g(" + n + ", " + m + ")", "2" + sup(n) + "·3" + sup(m) + " = " + Math.pow(2, n) * Math.pow(3, m)],
    ["÷2 hasta no poder", a + " veces → n = " + a],
    ["÷3 hasta no poder", b + " veces → m = " + b],
    ["se recupera (n, m)", a === n && b === m ? "sí ✓" : "no", "good"],
    ["¿está en la imagen de f?", m === 1 ? "sí: (" + n + ", 1) = f(" + n + ")" : "no (m ≠ 1)"],
  ]);
}, ["ejp2-14-n", "ejp2-14-m"]);

/* ===================== 15 · ℝ ∼ (0, 1) ===================== */

const f15 = (x) => x / (1 + Math.abs(x));
const finv15 = (y) => y / (1 - Math.abs(y));

PP.register(function graf15() {
  const x = PP.val("ejp2-15-x") / 10;
  PP.out("ejp2-15-x-o", PP.fmt(x, 1));
  const { ctx, w, h } = PP.canvas("ejp2-15-c1", 0.62);
  const T = PP.frame(w, h, { x0: -10, x1: 10, y0: -1.25, y1: 1.25 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "f(x)" });
  [-1, 1].forEach((v) => PP.path(ctx, [[T.X(-10), T.Y(v)], [T.X(10), T.Y(v)]], C("--muted"), 1.2, [5, 4]));
  const pts = [];
  for (let i = 0; i <= 400; i++) { const t = -10 + 20 * i / 400; pts.push([T.X(t), T.Y(f15(t))]); }
  PP.path(ctx, pts, C("--accent"), 2.2);
  const y = f15(x);
  PP.path(ctx, [[T.X(x), T.Y(0)], [T.X(x), T.Y(y)], [T.X(-10), T.Y(y)]], C("--seq2"), 1.3, [3, 3]);
  PP.dot(ctx, T.X(x), T.Y(y), 5, C("--seq2"));
  PP.label(ctx, "f(x)", T.X(-10) + 4, T.Y(y) + (y > 0 ? 4 : -4), C("--seq2"), "left", y > 0 ? "top" : "bottom", 11);
  PP.read("ejp2-15-read1", [
    ["x", PP.fmt(x, 3)],
    ["y = f(x)", PP.fmt(y, 5) + "  (|y| < 1)"],
    ["f⁻¹(y) = y/(1 − |y|)", PP.fmt(finv15(y), 3) + " = x ✓", "good"],
  ]);
}, ["ejp2-15-x"]);

PP.register(function rectas15() {
  const xs = PP.val("ejp2-15-x2") / 10;
  PP.out("ejp2-15-x2-o", PP.fmt(xs, 1));
  const { ctx, w, h } = PP.canvas("ejp2-15-c2", 0.62);
  const l = 30, r = 30, ys = [32, h / 2, h - 34];
  const X1 = (x) => l + (x + 10) / 20 * (w - l - r);
  const X2 = (y) => l + (y + 1) / 2 * (w - l - r);
  const X3 = (z) => l + z * (w - l - r);
  const names = ["ℝ", "(−1, 1)", "(0, 1)"];
  ys.forEach((y, i) => {
    PP.path(ctx, [[l, y], [w - r, y]], C("--muted"), 1.5, i === 0 ? [2, 3] : null);
    PP.label(ctx, names[i], 4, y - 8, C("--ink"), "left", "bottom", 12);
  });
  // extremos abiertos
  [[X2(-1), ys[1]], [X2(1), ys[1]], [X3(0), ys[2]], [X3(1), ys[2]]].forEach(([x, y]) => PP.circle(ctx, x, y, 4, C("--muted"), C("--panel")));
  PP.label(ctx, "−1", X2(-1), ys[1] + 7, C("--muted"), "center", "top", 10);
  PP.label(ctx, "1", X2(1), ys[1] + 7, C("--muted"), "center", "top", 10);
  PP.label(ctx, "0", X3(0), ys[2] + 7, C("--muted"), "center", "top", 10);
  PP.label(ctx, "1", X3(1), ys[2] + 7, C("--muted"), "center", "top", 10);
  PP.label(ctx, "−10", X1(-10), ys[0] + 7, C("--muted"), "center", "top", 10);
  PP.label(ctx, "10", X1(10), ys[0] + 7, C("--muted"), "center", "top", 10);
  PP.label(ctx, "f", w - 8, (ys[0] + ys[1]) / 2, C("--accent"), "right", "middle", 12);
  PP.label(ctx, "g", w - 8, (ys[1] + ys[2]) / 2, C("--seq3"), "right", "middle", 12);
  [-8, -4, -2, -1, 0, 1, 2, 4, 8].forEach((x) => {
    const y = f15(x), z = (y + 1) / 2;
    PP.path(ctx, [[X1(x), ys[0]], [X2(y), ys[1]]], C("--rule"), 1.2);
    PP.path(ctx, [[X2(y), ys[1]], [X3(z), ys[2]]], C("--rule"), 1.2);
    PP.dot(ctx, X1(x), ys[0], 2.5, C("--muted"));
    PP.dot(ctx, X2(y), ys[1], 2.5, C("--muted"));
    PP.dot(ctx, X3(z), ys[2], 2.5, C("--muted"));
  });
  const y = f15(xs), z = (y + 1) / 2;
  arrow(ctx, X1(xs), ys[0] + 4, X2(y), ys[1] - 5, C("--accent"), 2.5);
  arrow(ctx, X2(y), ys[1] + 4, X3(z), ys[2] - 5, C("--seq3"), 2.5);
  PP.dot(ctx, X1(xs), ys[0], 5, C("--accent"));
  PP.dot(ctx, X2(y), ys[1], 5, C("--accent"));
  PP.dot(ctx, X3(z), ys[2], 5, C("--seq3"));
  PP.read("ejp2-15-read2", [
    ["x ∈ ℝ", PP.fmt(xs, 3)],
    ["f(x) ∈ (−1, 1)", PP.fmt(y, 5)],
    ["g(f(x)) ∈ (0, 1)", PP.fmt(z, 5), "good"],
  ]);
}, ["ejp2-15-x2"]);

/* ===================== A1.5.6b · intervalos encajados ===================== */

const X1_B = 0.3;
/* Posición relativa de x_{n+1} dentro de I_n = [a, b] (valores elegidos para el dibujo). */
const U_B = [0.2, 0.85, 0.5, 0.12, 1.2, 0.74, 0.3, 0.9, -0.15];
function encajados(N) {
  const I = [[X1_B + 1, X1_B + 2]];
  const xs = [X1_B];
  const choice = [];
  for (let k = 0; k < N; k++) {
    const [a, b] = I[k], t = (b - a) / 3;
    const x = a + U_B[k] * (b - a);
    xs.push(x);
    const inL = x >= a && x <= a + t, inR = x >= b - t && x <= b;
    const side = inL ? "der" : "izq";
    choice.push({ side, where: inL ? "tercio izquierdo" : inR ? "tercio derecho" : "ninguno de los dos" });
    I.push(side === "izq" ? [a, a + t] : [b - t, b]);
  }
  return { I, xs, choice };
}

PP.register(function intervalos() {
  const N = PP.val("ejp2-a156b-n");
  PP.out("ejp2-a156b-n-o", String(N));
  const { I, xs, choice } = encajados(N);
  const rowH = 46;
  const el = document.getElementById("ejp2-a156b-c1");
  const W = el.clientWidth || 480;
  const { ctx, w, h } = PP.canvas(el, ((N + 1) * rowH + 18) / W);
  const l = 30, r = 12;
  // fila 0: x₁ e I₁ en escala normal
  {
    const y = 26, lo = X1_B - 0.6, hi = X1_B + 2.6;
    const Xs = (x) => l + (x - lo) / (hi - lo) * (w - l - r);
    PP.path(ctx, [[l, y], [w - r, y]], C("--muted"), 1);
    PP.rect(ctx, Xs(I[0][0]), y - 6, Xs(I[0][1]) - Xs(I[0][0]), 12, C("--accent"), C("--area"));
    PP.dot(ctx, Xs(xs[0]), y, 5, C("--fail"));
    PP.label(ctx, "x₁", Xs(xs[0]), y - 8, C("--fail"), "center", "bottom", 11);
    PP.label(ctx, "I₁", (Xs(I[0][0]) + Xs(I[0][1])) / 2, y - 8, C("--accent"), "center", "bottom", 11);
    PP.label(ctx, "ℝ", 4, y, C("--muted"), "left", "middle", 11);
  }
  for (let k = 1; k <= N; k++) {
    const y = 26 + k * rowH;
    const [a, b] = I[k - 1], span = b - a;
    const lo = a - 0.12 * span, hi = b + 0.12 * span;
    const Xs = (x) => l + (x - lo) / (hi - lo) * (w - l - r);
    // conector desde la fila anterior
    PP.label(ctx, "I" + sub(k), 4, y, C("--ink"), "left", "middle", 11);
    PP.path(ctx, [[Xs(a), y], [Xs(b), y]], C("--muted"), 2);
    const t = span / 3;
    PP.rect(ctx, Xs(a), y - 7, Xs(a + t) - Xs(a), 14, C("--rule"), null);
    PP.rect(ctx, Xs(b - t), y - 7, Xs(b) - Xs(b - t), 14, C("--rule"), null);
    const nx = choice[k - 1].side === "izq" ? [a, a + t] : [b - t, b];
    PP.rect(ctx, Xs(nx[0]), y - 7, Xs(nx[1]) - Xs(nx[0]), 14, C("--accent"), C("--area"));
    PP.label(ctx, "I" + sub(k + 1), (Xs(nx[0]) + Xs(nx[1])) / 2, y + 9, C("--accent"), "center", "top", 10);
    const x = xs[k];
    const xp = clamp(Xs(x), l, w - r);
    PP.dot(ctx, xp, y, 4.5, C("--fail"));
    PP.label(ctx, "x" + sub(k + 1) + (Xs(x) !== xp ? (Xs(x) < xp ? " ←" : " →") : ""), xp, y - 9, C("--fail"), "center", "bottom", 10);
    if (k < N) {
      const yn = y + rowH;
      PP.path(ctx, [[Xs(nx[0]), y + 7], [l + 0.12 / 1.24 * (w - l - r), yn - 7]], C("--rule"), 1, [3, 3]);
      PP.path(ctx, [[Xs(nx[1]), y + 7], [l + 1.12 / 1.24 * (w - l - r), yn - 7]], C("--rule"), 1, [3, 3]);
    }
  }
  const [aN, bN] = I[N];
  PP.read("ejp2-a156b-read1", [
    ["x" + sub(N + 1) + " cae en", choice[N - 1].where],
    ["I" + sub(N + 1), "[" + PP.fmt(aN, 6) + ", " + PP.fmt(bN, 6) + "]"],
    ["largo", "1/3" + sup(N) + " = " + PP.fmt(1 / Math.pow(3, N), 6)],
    ["xₖ ∉ Iₖ para k ≤ " + (N + 1), xs.every((x, i) => x < I[i][0] || x > I[i][1]) ? "sí ✓" : "no", "good"],
  ]);
}, ["ejp2-a156b-n"]);

/* ===================== C2-4 ===================== */

PP.register(function potImpar() {
  const k = PP.val("ejp2-c24-k");
  PP.out("ejp2-c24-k-o", String(k));
  let n = 0, o = k;
  while (o % 2 === 0) { o /= 2; n++; }
  const m = (o + 1) / 2;
  const NC = 6, NR = 8;
  const { ctx, w, h } = PP.canvas("ejp2-c24-c1", 0.8);
  const L = 50, Tp = 30, B = 22;
  const cw = (w - L - 8) / NC, chh = (h - Tp - B) / NR;
  PP.label(ctx, "2ⁿ con n =", L - 4, Tp - 6, C("--muted"), "right", "bottom", 10);
  for (let i = 0; i < NC; i++) PP.label(ctx, String(i), L + (i + 0.5) * cw, Tp - 6, i === n ? C("--accent") : C("--muted"), "center", "bottom", 11);
  for (let j = 1; j <= NR; j++) PP.label(ctx, "×" + (2 * j - 1), L - 6, Tp + (j - 0.5) * chh, j === m ? C("--accent") : C("--muted"), "right", "middle", 11);
  for (let j = 1; j <= NR; j++) for (let i = 0; i < NC; i++) {
    const x = L + i * cw, y = Tp + (j - 1) * chh, v = Math.pow(2, i) * (2 * j - 1);
    const sel = i === n && j === m;
    PP.rect(ctx, x + 1, y + 1, cw - 2, chh - 2, sel ? C("--accent") : C("--rule"), sel ? C("--area") : null);
    PP.label(ctx, String(v), x + cw / 2, y + chh / 2, sel ? C("--ink") : C("--muted"), "center", "middle", Math.min(12, cw / 3.4));
  }
  if (m > NR || n >= NC) PP.label(ctx, "la casilla de " + k + " está fuera del recorte (fila ×" + o + ", columna " + n + ")", w / 2, h - 4, C("--seq2"), "center", "bottom", 11);
  PP.read("ejp2-c24-read1", [
    ["k", String(k)],
    ["k = 2ⁿ·(2m − 1)", "2" + sup(n) + "·" + o],
    ["(n, m)", "(" + n + ", " + m + ")", "good"],
  ]);
}, ["ejp2-c24-k"]);

PP.register(function restriccion() {
  const p0 = PP.val("ejp2-c24-p"), q0 = PP.val("ejp2-c24-q");
  PP.out("ejp2-c24-p-o", String(p0)); PP.out("ejp2-c24-q-o", String(q0));
  const g = gcd(p0, q0), p = p0 / g, q = q0 / g;
  const x = p / q, y = x / (x + 1);
  const { ctx, w, h } = PP.canvas("ejp2-c24-c2", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 12.5, y0: 0, y1: 1.12 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "x/(x+1)" });
  PP.path(ctx, [[T.X(0), T.Y(1)], [T.X(12.5), T.Y(1)]], C("--muted"), 1.2, [5, 4]);
  const pts = [];
  for (let i = 1; i <= 300; i++) { const t = 12.5 * i / 300; pts.push([T.X(t), T.Y(t / (t + 1))]); }
  PP.path(ctx, pts, C("--accent"), 2.2);
  PP.circle(ctx, T.X(0), T.Y(0), 4, C("--accent"), C("--panel"));
  PP.path(ctx, [[T.X(x), T.Y(0)], [T.X(x), T.Y(y)], [T.X(0), T.Y(y)]], C("--seq2"), 1.3, [3, 3]);
  PP.dot(ctx, T.X(x), T.Y(y), 5.5, C("--seq2"));
  PP.label(ctx, frac(p, q), T.X(x), T.Y(0) - 4, C("--seq2"), "center", "bottom", 11);
  PP.label(ctx, frac(p, p + q), T.X(0) + 4, T.Y(y) - 3, C("--seq2"), "left", "bottom", 11);
  PP.read("ejp2-c24-read2", [
    ["x = p/q", p0 + "/" + q0 + (g > 1 ? " = " + frac(p, q) : "")],
    ["f(x) = p/(p+q)", frac(p, p + q) + " ≈ " + PP.fmt(y, 4) + "  ∈ (0, 1) ∩ ℚ", "good"],
    ["f⁻¹(y) = y/(1 − y)", "(" + frac(p, p + q) + ")/(" + frac(q, p + q) + ") = " + frac(p, q) + " ✓", "good"],
  ]);
}, ["ejp2-c24-p", "ejp2-c24-q"]);

const LIBRES = [2, -1, 3, 0, -2, 1, 3, -3, 2]; // valores elegidos para el dibujo
PP.register(function finalConst() {
  const k = PP.val("ejp2-c24-kk"), a = PP.val("ejp2-c24-aa");
  PP.out("ejp2-c24-kk-o", String(k)); PP.out("ejp2-c24-aa-o", neg(a));
  const M = 14;
  const seq = Array.from({ length: M }, (_, i) => (i + 1 < k ? LIBRES[i] : a));
  const { ctx, w, h } = PP.canvas("ejp2-c24-c3", 0.6);
  const T = PP.frame(w, h, { x0: 0.3, x1: M + 0.7, y0: -3.6, y1: 3.6 }, { l: 34 });
  PP.axes(ctx, T, { xLabel: "n", intX: true, yTicks: 7 });
  if (k > 1) PP.rect(ctx, T.X(0.5), T.Y(3.6), T.X(k - 0.5) - T.X(0.5), T.Y(-3.6) - T.Y(3.6), null, C("--band"));
  PP.path(ctx, [[T.X(k - 0.5), T.Y(3.6)], [T.X(k - 0.5), T.Y(-3.6)]], C("--ok"), 1.5, [4, 3]);
  PP.path(ctx, [[T.X(k - 0.5), T.Y(a)], [T.X(M + 0.7), T.Y(a)]], C("--ok"), 1.2, [2, 3]);
  PP.label(ctx, "desde n = " + k + ": aₙ = " + neg(a), T.X(M + 0.7) - 2, T.Y(a) + (a > 2 ? 6 : -6), C("--ok"), "right", a > 2 ? "top" : "bottom", 11);
  seq.forEach((v, i) => PP.dot(ctx, T.X(i + 1), T.Y(v), 4.5, C(i + 1 < k ? "--accent" : "--ok")));
  const tup = seq.slice(0, k - 1).map(neg);
  PP.read("ejp2-c24-read3", [
    ["sucesión", seq.slice(0, 10).map(neg).join(", ") + ", …"],
    ["en Aₐ,ₖ", "a = " + neg(a) + ", k = " + k],
    ["tupla en ℤ" + sup(k - 1), k === 1 ? "( ) (ℤ⁰ tiene un solo elemento)" : "(" + tup.join(", ") + ")", "good"],
  ]);
}, ["ejp2-c24-kk", "ejp2-c24-aa"]);

/* ===================== A1.5.8 · capas Bₙ ===================== */

function conjB() {
  return PP.radio("ejp2-a158-set") === "cuad"
    ? Array.from({ length: 24 }, (_, i) => 1 / ((i + 1) * (i + 1)))
    : Array.from({ length: 14 }, (_, i) => Math.pow(2, -i));
}
const nomB = (j) => (PP.radio("ejp2-a158-set") === "cuad" ? (j === 1 ? "1" : "1/" + j * j) : (j === 1 ? "1" : "1/" + Math.pow(2, j - 1)));

PP.register(function capas() {
  const n = PP.val("ejp2-a158-n");
  PP.out("ejp2-a158-n-o", String(n));
  const B = conjB();
  const { ctx, w, h } = PP.canvas("ejp2-a158-c1", 0.34);
  const T = PP.frame(w, h, { x0: 0, x1: 1.08, y0: 0, y1: 1 }, { l: 14, r: 14, t: 26, b: 30 });
  PP.rect(ctx, T.X(1 / n), T.Y(1), T.X(1.08) - T.X(1 / n), T.Y(0) - T.Y(1), null, C("--band"));
  PP.path(ctx, [[T.X(0), T.Y(0.35)], [T.X(1.08), T.Y(0.35)]], C("--muted"), 1);
  [0, 0.25, 0.5, 0.75, 1].forEach((v) => {
    PP.path(ctx, [[T.X(v), T.Y(0.35) - 4], [T.X(v), T.Y(0.35) + 4]], C("--muted"), 1);
    PP.label(ctx, PP.fmt(v, 2), T.X(v), T.Y(0.35) + 8, C("--muted"), "center", "top", 10);
  });
  PP.path(ctx, [[T.X(1 / n), T.Y(1)], [T.X(1 / n), T.Y(0)]], C("--accent"), 1.5, [5, 4]);
  PP.label(ctx, "1/" + n, T.X(1 / n) + 4, T.Y(1) + 2, C("--accent"), "left", "top", 11);
  let cnt = 0, sum = 0;
  B.forEach((x) => {
    const inn = x > 1 / n;
    if (inn) { cnt++; sum += x; }
    PP.dot(ctx, T.X(x), T.Y(0.35), inn ? 5 : 3, C(inn ? "--accent" : "--seq2"));
  });
  PP.label(ctx, "Bₙ = {x ∈ B : x > 1/n}", T.X(1.08) - 2, T.Y(1) - 4, C("--accent"), "right", "bottom", 11);
  PP.read("ejp2-a158-read1", [
    ["#B" + sub(n), String(cnt)],
    ["cota 2n", String(2 * n)],
    ["#Bₙ ≤ 2n", cnt <= 2 * n ? "sí ✓" : "no", "good"],
    ["suma de Bₙ", PP.fmt(sum, 4) + " ≤ 2"],
  ]);
}, ["ejp2-a158-n", "input[name=\"ejp2-a158-set\"]"]);

PP.register(function arquimedes() {
  const B = conjB();
  const maxJ = PP.radio("ejp2-a158-set") === "cuad" ? 10 : 8;
  const sl = document.getElementById("ejp2-a158-j");
  if (+sl.max !== maxJ) { sl.max = String(maxJ); if (+sl.value > maxJ) sl.value = String(maxJ); }
  const j = PP.val("ejp2-a158-j");
  const x = B[j - 1];
  const n = Math.floor(1 / x) + 1;
  PP.out("ejp2-a158-j-o", nomB(j));
  const { ctx, w, h } = PP.canvas("ejp2-a158-c2", 0.3);
  const hi = Math.min(1.08, 2.2 * x);
  const T = PP.frame(w, h, { x0: 0, x1: hi, y0: 0, y1: 1 }, { l: 14, r: 14, t: 20, b: 30 });
  const y0 = T.Y(0.5);
  PP.path(ctx, [[T.X(0), y0], [T.X(hi), y0]], C("--muted"), 1);
  PP.label(ctx, "0", T.X(0), y0 + 8, C("--muted"), "center", "top", 10);
  for (let m = 1; m <= 3 * n; m++) {
    const v = 1 / m;
    if (v > hi) continue;
    const isN = m === n;
    PP.path(ctx, [[T.X(v), y0 - (isN ? 14 : 6)], [T.X(v), y0 + (isN ? 14 : 6)]], isN ? C("--accent") : C("--rule"), isN ? 2.2 : 1);
  }
  PP.rect(ctx, T.X(1 / n), y0 - 10, T.X(hi) - T.X(1 / n), 20, null, C("--band"));
  PP.label(ctx, "1/" + n, T.X(1 / n), y0 + 16, C("--accent"), "center", "top", 11);
  PP.dot(ctx, T.X(x), y0, 6, C("--seq2"));
  PP.label(ctx, "x = " + nomB(j), T.X(x), y0 - 16, C("--seq2"), "center", "bottom", 12);
  PP.read("ejp2-a158-read2", [
    ["x", nomB(j) + " = " + PP.fmt(x, 6)],
    ["primer n con 1/n < x", String(n)],
    ["x ∈ B" + sub(n), "sí ✓", "good"],
  ]);
}, ["ejp2-a158-j", "input[name=\"ejp2-a158-set\"]"]);

/* ===================== A1.5.9 · algebraicos ===================== */

const POLS = [
  { name: "x² − 2", c: [-2, 0, 1], root: Math.SQRT2, rn: "√2", box: [-2.4, 2.4, -2.6, 4] },
  { name: "x³ − 2", c: [-2, 0, 0, 1], root: Math.cbrt(2), rn: "∛2", box: [-1.9, 1.9, -9, 5] },
  { name: "x⁴ − 10x² + 1", c: [1, 0, -10, 0, 1], root: Math.SQRT2 + Math.sqrt(3), rn: "√2 + √3", box: [-3.6, 3.6, -26, 30] },
];
const evalP = (c, x) => c.reduceRight((acc, a) => acc * x + a, 0);

PP.register(function polis() {
  const P = POLS[+PP.radio("ejp2-a159-pol")];
  const [x0, x1, y0, y1] = P.box;
  const { ctx, w, h } = PP.canvas("ejp2-a159-c1", 0.62);
  const T = PP.frame(w, h, { x0, x1, y0, y1 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: P.name });
  const pts = [];
  for (let i = 0; i <= 400; i++) {
    const t = x0 + (x1 - x0) * i / 400, v = evalP(P.c, t);
    pts.push([T.X(t), T.Y(clamp(v, y0 - 5, y1 + 5))]);
  }
  ctx.save(); ctx.beginPath(); ctx.rect(T.p.l, T.p.t, w - T.p.l - T.p.r, h - T.p.t - T.p.b); ctx.clip();
  PP.path(ctx, pts, C("--accent"), 2.2);
  ctx.restore();
  if (P.c.length === 5) {
    [-P.root, Math.SQRT2 - Math.sqrt(3), Math.sqrt(3) - Math.SQRT2].forEach((r) => PP.dot(ctx, T.X(r), T.Y(0), 3.5, C("--muted")));
  }
  PP.dot(ctx, T.X(P.root), T.Y(0), 6, C("--seq2"));
  PP.label(ctx, P.rn, T.X(P.root), T.Y(0) - 8, C("--seq2"), P.root > x1 - 0.6 ? "right" : "center", "bottom", 12);
  PP.read("ejp2-a159-read1", [
    ["polinomio", P.name + "  (coeficientes enteros)"],
    ["número", P.rn + " ≈ " + PP.fmt(P.root, 6)],
    ["p(número)", PP.fmt(evalP(P.c, P.root), 10) + " (cero, salvo redondeo)", "good"],
  ]);
}, ["input[name=\"ejp2-a159-pol\"]"]);

/* Raíces reales de un polinomio de grado ≤ 3 (coeficientes c[0] + c[1]x + …). */
function raices(c) {
  const n = c.length - 1;
  if (n === 1) return [-c[0] / c[1]];
  if (n === 2) {
    const [cc, b, a] = c, d = b * b - 4 * a * cc;
    if (d < 0) return [];
    if (d === 0) return [-b / (2 * a)];
    const s = Math.sqrt(d);
    return [(-b - s) / (2 * a), (-b + s) / (2 * a)];
  }
  const Bd = 1 + Math.max(...c.slice(0, n).map((x) => Math.abs(x / c[n])));
  const crit = raices([c[1], 2 * c[2], 3 * c[3]]).filter((x) => x > -Bd && x < Bd).sort((a, b) => a - b);
  const cuts = [-Bd, ...crit, Bd], out = [];
  for (let i = 0; i + 1 < cuts.length; i++) {
    let a = cuts[i], b = cuts[i + 1], fa = evalP(c, a), fb = evalP(c, b);
    if (Math.abs(fa) < 1e-12) { out.push(a); continue; }
    if (fa * fb > 0) continue;
    for (let it = 0; it < 80; it++) { const m = (a + b) / 2, fm = evalP(c, m); if (fa * fm <= 0) { b = m; fb = fm; } else { a = m; fa = fm; } }
    out.push((a + b) / 2);
  }
  if (Math.abs(evalP(c, Bd)) < 1e-12) out.push(Bd);
  return out;
}
const ROOTS_CACHE = {};
function raicesGrado(n, Hmax) {
  const key = n + ":" + Hmax;
  if (ROOTS_CACHE[key]) return ROOTS_CACHE[key];
  const map = new Map();
  let polys = 0;
  const c = new Array(n + 1).fill(0);
  const rec = (i) => {
    if (i < 0) {
      if (c[n] === 0) return;
      polys++;
      const ht = Math.max(...c.map(Math.abs));
      raices(c.slice()).forEach((r) => {
        if (r < -3 || r > 3) return;
        const k = r.toFixed(9);
        if (!map.has(k) || map.get(k).ht > ht) map.set(k, { r, ht });
      });
      return;
    }
    for (let v = -Hmax; v <= Hmax; v++) { c[i] = v; rec(i - 1); }
  };
  rec(n);
  ROOTS_CACHE[key] = { list: [...map.values()], polys };
  return ROOTS_CACHE[key];
}

PP.register(function raicesDib() {
  const n = PP.val("ejp2-a159-n"), H = PP.val("ejp2-a159-H");
  PP.out("ejp2-a159-n-o", String(n)); PP.out("ejp2-a159-H-o", String(H));
  const { list } = raicesGrado(n, 4);
  const rowH = Math.max(34, 130 / H);
  const el = document.getElementById("ejp2-a159-c2");
  const W = el.clientWidth || 480;
  const { ctx, w, h } = PP.canvas(el, (H * rowH + 50) / W);
  const l = 44, r = 12;
  const X = (x) => l + (x + 3) / 6 * (w - l - r);
  let cnt = 0, polys = 0;
  for (let hh = 1; hh <= H; hh++) {
    const y = 18 + (hh - 0.5) * rowH;
    PP.label(ctx, "H = " + hh, 4, y, C("--muted"), "left", "middle", 11);
    PP.path(ctx, [[l, y], [w - r, y]], C("--rule"), 1);
    list.forEach(({ r: x, ht }) => {
      if (ht > hh) return;
      PP.path(ctx, [[X(x), y - 8], [X(x), y + 8]], ht === hh ? C("--accent") : C("--muted"), ht === hh ? 1.6 : 1);
    });
  }
  list.forEach(({ ht }) => { if (ht <= H) cnt++; });
  polys = 2 * H * Math.pow(2 * H + 1, n);
  const yb = 18 + H * rowH + 6;
  [-3, -2, -1, 0, 1, 2, 3].forEach((v) => PP.label(ctx, neg(v), X(v), yb, C("--muted"), "center", "top", 10));
  PP.read("ejp2-a159-read2", [
    ["polinomios de grado " + n, "2H·(2H + 1)" + sup(n) + " = " + polys + " (finitos)"],
    ["raíces distintas en [−3, 3]", String(cnt)],
    ["cada polinomio aporta", "a lo sumo " + n + " raíces", "good"],
  ]);
}, ["ejp2-a159-n", "ejp2-a159-H"]);

/* ===================== Prop · φ(h) = g ∘ h ∘ f⁻¹ ===================== */

const FINV = [2, 0, 1]; // f⁻¹: x₁ ↦ a₃, x₂ ↦ a₁, x₃ ↦ a₂  (f: a₁ ↦ x₂, a₂ ↦ x₃, a₃ ↦ x₁)
const G = [1, 0];       // g: b₁ ↦ y₂, b₂ ↦ y₁
PP.register(function transporte() {
  const idx = PP.val("ejp2-prop-h") - 1;
  const hv = [0, 1, 2].map((i) => (idx >> i) & 1); // h(aᵢ) = b_{hv[i]+1}
  PP.out("ejp2-prop-h-o", String(idx + 1));
  const { ctx, w, h } = PP.canvas("ejp2-prop-c1", 0.66);
  const cols = [0.09, 0.36, 0.64, 0.91].map((t) => t * w);
  const yTop = 46, yBot = h - 20;
  const Y3 = (i) => yTop + (i + 0.5) / 3 * (yBot - yTop);
  const Y2 = (i) => yTop + (i + 1) / 3 * (yBot - yTop);
  const names = ["X", "A", "B", "Y"];
  names.forEach((nm, i) => PP.label(ctx, nm, cols[i], 16, C("--ink"), "center", "middle", 14, "bold"));
  [["f⁻¹", 0], ["h", 1], ["g", 2]].forEach(([t, i]) => PP.label(ctx, t, (cols[i] + cols[i + 1]) / 2, 30, C("--muted"), "center", "middle", 12));
  const colors = [C("--accent"), C("--seq2"), C("--seq3")];
  for (let xi = 0; xi < 3; xi++) {
    const ai = FINV[xi], bi = hv[ai], yi = G[bi];
    const col = colors[xi], off = (xi - 1) * 2;
    arrow(ctx, cols[0] + 14, Y3(xi) + off, cols[1] - 14, Y3(ai) + off, col, 1.8, null, 6);
    arrow(ctx, cols[1] + 14, Y3(ai) + off, cols[2] - 14, Y2(bi) + off, col, 1.8, null, 6);
    arrow(ctx, cols[2] + 14, Y2(bi) + off, cols[3] - 14, Y2(yi) + off, col, 1.8, null, 6);
  }
  for (let i = 0; i < 3; i++) {
    PP.label(ctx, "x" + sub(i + 1), cols[0], Y3(i), colors[i], "center", "middle", 13);
    PP.label(ctx, "a" + sub(i + 1), cols[1], Y3(i), C("--ink"), "center", "middle", 13);
  }
  for (let i = 0; i < 2; i++) {
    PP.label(ctx, "b" + sub(i + 1), cols[2], Y2(i), C("--ink"), "center", "middle", 13);
    PP.label(ctx, "y" + sub(i + 1), cols[3], Y2(i), C("--ink"), "center", "middle", 13);
  }
  const phi = [0, 1, 2].map((xi) => G[hv[FINV[xi]]]);
  const F = [1, 2, 0]; // f(aᵢ) = x_{F[i]+1}
  const GINV = [1, 0];
  const back = [0, 1, 2].map((ai) => GINV[phi[F[ai]]]);
  PP.read("ejp2-prop-read1", [
    ["h", hv.map((b, i) => "a" + sub(i + 1) + "↦b" + sub(b + 1)).join(", ")],
    ["φ(h) = g∘h∘f⁻¹", phi.map((y, i) => "x" + sub(i + 1) + "↦y" + sub(y + 1)).join(", ")],
    ["ψ(φ(h)) = g⁻¹∘φ(h)∘f", back.map((b, i) => "a" + sub(i + 1) + "↦b" + sub(b + 1)).join(", ")],
    ["¿ψ(φ(h)) = h?", back.every((b, i) => b === hv[i]) ? "sí ✓" : "no", "good"],
  ]);
}, ["ejp2-prop-h"]);

/* ===================== Prop · pegar funciones ===================== */

const PARES = [
  { f: [2, 0, 1], g: [1, 2, 0] },
  { f: [1, 2, 0], g: [2, 1, 1] },
  { f: [0, 1, 2], g: [2, 0, 2] },
  { f: [2, 2, 1], g: [0, 1, 0] },
  { f: [1, 0, 0], g: [0, 2, 1] },
  { f: [0, 0, 2], g: [1, 1, 2] },
];

/* Barras de valores en {0, 1, 2} sobre los puntos 1..5. */
function barras(ctx, T, items) {
  items.forEach(({ x, v, col, dx }) => {
    const bw = Math.min(16, (T.X(1) - T.X(0)) * 0.28);
    const cx = T.X(x) + (dx || 0) * bw * 0.65;
    if (v > 0) PP.rect(ctx, cx - bw / 2, T.Y(v), bw, T.Y(0) - T.Y(v), col, col);
    PP.dot(ctx, cx, T.Y(v), 3.5, col);
  });
}
function ejeValores(ctx, T, y0, y1) {
  [0, 1, 2].forEach((v) => {
    PP.path(ctx, [[T.X(0.4), T.Y(v)], [T.X(5.6), T.Y(v)]], C("--rule"), 1);
    PP.label(ctx, String(v), T.X(0.4) - 4, T.Y(v), C("--muted"), "right", "middle", 10);
  });
}

PP.register(function pegar() {
  const k = PP.val("ejp2-prop2-par") - 1;
  PP.out("ejp2-prop2-par-o", String(k + 1));
  const dis = PP.radio("ejp2-prop2-dis") !== "no";
  const P = PARES[k];
  const A = [1, 2, 3], Bs = dis ? [4, 5] : [3, 4, 5];
  const gv = (x) => P.g[x - 3];
  const { ctx, w, h } = PP.canvas("ejp2-prop2-c1", 0.62);
  const T = PP.frame(w, h, { x0: 0.4, x1: 5.6, y0: -0.9, y1: 2.5 }, { l: 26, r: 10, t: 14, b: 16 });
  ejeValores(ctx, T);
  const items = [];
  A.forEach((x) => items.push({ x, v: P.f[x - 1], col: C("--accent"), dx: !dis && x === 3 ? -1 : 0 }));
  Bs.forEach((x) => items.push({ x, v: gv(x), col: C("--seq2"), dx: !dis && x === 3 ? 1 : 0 }));
  const conflict = !dis && P.f[2] !== gv(3);
  if (conflict) PP.rect(ctx, T.X(2.6), T.Y(2.45), T.X(3.4) - T.X(2.6), T.Y(-0.1) - T.Y(2.45), C("--fail"), C("--failband"));
  barras(ctx, T, items);
  for (let x = 1; x <= 5; x++) PP.label(ctx, String(x), T.X(x), T.Y(-0.15), C("--ink"), "center", "top", 11);
  // llaves de A y B
  const yA = T.Y(-0.55), yB = T.Y(-0.8);
  PP.path(ctx, [[T.X(0.75), yA], [T.X(3.25), yA]], C("--accent"), 3);
  PP.label(ctx, "A", T.X(0.62), yA, C("--accent"), "right", "middle", 11);
  PP.path(ctx, [[T.X(dis ? 3.75 : 2.75), yB], [T.X(5.25), yB]], C("--seq2"), 3);
  PP.label(ctx, "B", T.X(5.4), yB, C("--seq2"), "left", "middle", 11);
  if (conflict) PP.label(ctx, "¿" + P.f[2] + " o " + gv(3) + "?", T.X(3), T.Y(2.45) - 2, C("--fail"), "center", "bottom", 11);
  const pegada = [1, 2, 3, 4, 5].map((x) => (x <= 3 ? P.f[x - 1] : gv(x)));
  PP.read("ejp2-prop2-read1", [
    ["f en A", A.map((x) => x + "↦" + P.f[x - 1]).join(", ")],
    ["g en B", Bs.map((x) => x + "↦" + gv(x)).join(", ")],
    dis ? ["φ(f, g)", pegada.map((v, i) => (i + 1) + "↦" + v).join(", ") + "  (función ✓)", "good"]
      : conflict ? ["φ(f, g)(3)", "f(3) = " + P.f[2] + " ≠ g(3) = " + gv(3) + ": no es función", "bad"]
        : ["φ(f, g)(3)", "f(3) = g(3) = " + P.f[2] + ": esta vez zafa, pero otro par falla"],
  ]);
}, ["ejp2-prop2-par", "input[name=\"ejp2-prop2-dis\"]"]);

PP.register(function restringir() {
  const k = PP.val("ejp2-prop2-h");
  PP.out("ejp2-prop2-h-o", String(k));
  let code = (k * 97 + 31) % 243;
  const hv = [];
  for (let i = 0; i < 5; i++) { hv.push(code % 3); code = Math.floor(code / 3); }
  const { ctx, w, h } = PP.canvas("ejp2-prop2-c2", 0.7);
  const half = h / 2;
  const T1 = PP.frame(w, half, { x0: 0.4, x1: 5.6, y0: -0.5, y1: 2.5 }, { l: 26, r: 10, t: 18, b: 6 });
  ejeValores(ctx, T1);
  PP.label(ctx, "h sobre A ∪ B", T1.X(5.6), 10, C("--ink"), "right", "middle", 11);
  barras(ctx, T1, hv.map((v, i) => ({ x: i + 1, v, col: C(i < 3 ? "--accent" : "--seq2") })));
  for (let x = 1; x <= 5; x++) PP.label(ctx, String(x), T1.X(x), T1.Y(-0.1), C("--muted"), "center", "top", 10);
  ctx.save(); ctx.translate(0, half);
  const T2 = PP.frame(w, half, { x0: 0.4, x1: 5.6, y0: -0.5, y1: 2.5 }, { l: 26, r: 10, t: 18, b: 6 });
  ejeValores(ctx, T2);
  PP.path(ctx, [[T2.X(3.5), T2.Y(2.5)], [T2.X(3.5), T2.Y(-0.5)]], C("--muted"), 1.2, [4, 3]);
  PP.label(ctx, "h|A", T2.X(2), 8, C("--accent"), "center", "middle", 11);
  PP.label(ctx, "h|B", T2.X(4.5), 8, C("--seq2"), "center", "middle", 11);
  barras(ctx, T2, hv.map((v, i) => ({ x: i < 3 ? i + 1 : i + 1, v, col: C(i < 3 ? "--accent" : "--seq2"), dx: i < 3 ? -0.6 : 0.6 })));
  for (let x = 1; x <= 5; x++) PP.label(ctx, String(x), T2.X(x) + (x <= 3 ? -6 : 6), T2.Y(-0.1), C("--muted"), "center", "top", 10);
  ctx.restore();
  PP.path(ctx, [[8, half], [w - 8, half]], C("--rule"), 1);
  PP.read("ejp2-prop2-read2", [
    ["h", hv.map((v, i) => (i + 1) + "↦" + v).join(", ")],
    ["ψ(h) = (h|A, h|B)", "(" + hv.slice(0, 3).join(", ") + ") , (" + hv.slice(3).join(", ") + ")"],
    ["φ(h|A, h|B) = h", "sí ✓", "good"],
  ]);
}, ["ejp2-prop2-h"]);

/* ===================== C3-2 ===================== */

const TABLA = [
  [1, 0, 1, 1, 0, 0, 1, 0],
  [0, 0, 1, 0, 1, 1, 0, 1],
  [1, 1, 1, 0, 0, 1, 0, 0],
  [0, 1, 0, 0, 1, 0, 1, 1],
  [1, 0, 0, 1, 1, 1, 0, 1],
];
PP.register(function leyExp() {
  const b = PP.val("ejp2-c32-b"), c = PP.val("ejp2-c32-c");
  PP.out("ejp2-c32-b-o", String(b)); PP.out("ejp2-c32-c-o", String(c));
  const modo = PP.radio("ejp2-c32-modo");
  const { ctx, w, h } = PP.canvas("ejp2-c32-c1", 0.6);
  const L = 56, Tp = 30, NB = 8, NC = 5;
  const cw = (w - L - 26) / NB, chh = (h - Tp - 12) / NC;
  PP.label(ctx, "b →", L - 6, Tp - 8, C("--muted"), "right", "bottom", 11);
  for (let i = 1; i <= NB; i++) PP.label(ctx, String(i), L + (i - 0.5) * cw, Tp - 6, i === b ? C("--accent") : C("--muted"), "center", "bottom", 11);
  PP.label(ctx, "…", L + NB * cw + 12, Tp - 6, C("--muted"), "center", "bottom", 11);
  for (let j = 1; j <= NC; j++) {
    const y = Tp + (j - 1) * chh;
    PP.label(ctx, modo === "fil" ? "f(" + j + ")" : "c=" + j, L - 6, y + chh / 2, j === c ? C("--accent") : C("--muted"), "right", "middle", 11);
    if (modo === "fil" && j === c) PP.rect(ctx, L, y + 1, NB * cw, chh - 2, C("--seq2"), C("--area2"));
    for (let i = 1; i <= NB; i++) {
      const x = L + (i - 1) * cw;
      const sel = i === b && j === c;
      PP.rect(ctx, x + 1, y + 1, cw - 2, chh - 2, sel ? C("--accent") : C("--rule"), sel ? C("--area") : null);
      PP.label(ctx, String(TABLA[j - 1][i - 1]), x + cw / 2, y + chh / 2, sel ? C("--ink") : C("--muted"), "center", "middle", 12);
    }
    PP.label(ctx, "…", L + NB * cw + 12, y + chh / 2, C("--muted"), "center", "middle", 11);
  }
  const v = TABLA[c - 1][b - 1];
  PP.read("ejp2-c32-read1", modo === "fil" ? [
    ["f(" + c + ") ∈ {0,1}ᴺ", "(" + TABLA[c - 1].join(", ") + ", …)"],
    ["(f(" + c + "))(" + b + ")", String(v)],
    ["Φ(f)(" + b + ", " + c + ")", String(v) + " (mismo dato)", "good"],
  ] : [
    ["g = Φ(f)", "una casilla por par (b, c)"],
    ["g(" + b + ", " + c + ")", String(v)],
    ["[Ψ(g)(" + c + ")](" + b + ")", String(v) + " (mismo dato)", "good"],
  ]);
}, ["ejp2-c32-b", "ejp2-c32-c", "input[name=\"ejp2-c32-modo\"]"]);

const esPrimo = (n) => { if (n < 2) return false; for (let d = 2; d * d <= n; d++) if (n % d === 0) return false; return true; };
const PARES_B = [
  { B: (x) => x % 2 === 0 || x === 7, Bt: (x) => x % 2 === 0, nB: "pares ∪ {7}", nBt: "pares" },
  { B: (x) => x % 2 === 1, Bt: esPrimo, nB: "impares", nBt: "primos" },
  { B: (x) => x % 3 === 0, Bt: (x) => x % 3 === 0 && x !== 9, nB: "múltiplos de 3", nBt: "múltiplos de 3 sin el 9" },
];
PP.register(function enumeracion() {
  const P = PARES_B[+PP.radio("ejp2-c32-par")];
  const { ctx, w, h } = PP.canvas("ejp2-c32-c2", 0.5);
  const M = w < 420 ? 14 : 20;
  const L = 22, R = 8, cw = (w - L - R) / M;
  const rows = [{ f: P.B, y: h * 0.33, name: "B" }, { f: P.Bt, y: h * 0.78, name: "B̃" }];
  let m = 0;
  for (let x = 1; x <= M; x++) if (P.B(x) !== P.Bt(x)) { m = x; break; }
  const j = Array.from({ length: m - 1 }, (_, i) => i + 1).filter(P.B).length;
  const fs = Math.min(11, cw * 0.62);
  const enums = rows.map((rw) => Array.from({ length: M }, (_, i) => i + 1).filter(rw.f));
  PP.path(ctx, [[L + (m - 0.5) * cw, 10], [L + (m - 0.5) * cw, h - 6]], C("--fail"), 1.5, [4, 3]);
  PP.label(ctx, "m = " + m, clamp(L + (m - 0.5) * cw + 4, 0, w - 50), 10, C("--fail"), "left", "top", 11);
  rows.forEach((rw, ri) => {
    PP.label(ctx, rw.name, 4, rw.y, C("--ink"), "left", "middle", 13);
    let pos = 0;
    for (let x = 1; x <= M; x++) {
      const cx = L + (x - 0.5) * cw, inn = rw.f(x);
      if (inn) pos++;
      const isJ1 = inn && pos === j + 1;
      PP.circle(ctx, cx, rw.y, Math.min(9, cw * 0.45), inn ? C(isJ1 ? "--fail" : "--accent") : C("--rule"), inn ? C(isJ1 ? "--failband" : "--area") : null);
      PP.label(ctx, String(x), cx, rw.y, inn ? C("--ink") : C("--muted"), "center", "middle", fs);
      if (inn) PP.label(ctx, String(pos), cx, rw.y - Math.min(9, cw * 0.45) - 3, isJ1 ? C("--fail") : C("--muted"), "center", "bottom", Math.min(9, fs));
    }
  });
  const [e1, e2] = enums;
  PP.read("ejp2-c32-read2", [
    ["B / B̃", P.nB + " / " + P.nBt],
    ["primeros j lugares", j === 0 ? "ninguno (j = 0)" : "(" + e1.slice(0, j).join(", ") + ") en los dos"],
    ["lugar j + 1 = " + (j + 1), "g(B) da " + e1[j] + ", g(B̃) da " + e2[j], "good"],
  ]);
}, ["input[name=\"ejp2-c32-par\"]"]);

const KS = [[2, 1, 3, 1, 2, 1], [1, 1, 1, 1, 1, 1], [2, 2, 2, 2, 2, 2]];
PP.register(function cadena() {
  const a = PP.val("ejp2-c32-a");
  PP.out("ejp2-c32-a-o", String(a));
  const ks = KS[+PP.radio("ejp2-c32-ks")];
  const seq = [a];
  ks.forEach((k) => seq.push(seq[seq.length - 1] * k));
  const { ctx, w, h } = PP.canvas("ejp2-c32-c3", 0.3);
  const n = seq.length, l = 8, r = 8;
  const slot = (w - l - r) / n, bw = Math.min(54, slot * 0.72), y = h * 0.5, bh = 34;
  seq.forEach((v, i) => {
    const cx = l + (i + 0.5) * slot;
    PP.rect(ctx, cx - bw / 2, y - bh / 2, bw, bh, C(i === 0 ? "--seq2" : "--accent"), C(i === 0 ? "--area2" : "--area"));
    PP.label(ctx, String(v), cx, y, C("--ink"), "center", "middle", Math.min(13, bw / 2.6));
    PP.label(ctx, "a" + sub(i + 1), cx, y + bh / 2 + 4, C("--muted"), "center", "top", 11);
    if (i < n - 1) {
      const nx = l + (i + 1.5) * slot;
      arrow(ctx, cx + bw / 2 + 1, y - 6, nx - bw / 2 - 1, y - 6, C("--muted"), 1.3, null, 5);
      PP.label(ctx, "×" + ks[i], (cx + nx) / 2, y - bh / 2 - 6, C("--seq3"), "center", "bottom", 12);
    }
  });
  PP.label(ctx, "a₁ = a", l + 0.5 * slot, y - bh / 2 - 6, C("--seq2"), "center", "bottom", 11);
  PP.read("ejp2-c32-read3", [
    ["(aₘ)", seq.join(", ") + ", …"],
    ["aₙ | aₙ₊₁", "sí ✓"],
    ["kₙ = aₙ₊₁/aₙ", seq.slice(1).map((v, i) => v / seq[i]).join(", ") + ", …  (se recuperan)", "good"],
  ]);
}, ["ejp2-c32-a", "input[name=\"ejp2-c32-ks\"]"]);

/* ===================== C3-3 · caminos de a un paso ===================== */

const BITS = [1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0];
let C33 = null;
function caminos() {
  const N = PP.val("ejp2-c33-N");
  PP.out("ejp2-c33-N-o", String(N));
  const { ctx, w, h } = PP.canvas("ejp2-c33-c1", 0.82);
  const l = 30, r = 14, bitH = 26, tTop = bitH + 20;
  const X = (n) => l + (n - 1) / (N - 1) * (w - l - r);
  const vmin = 1 - (N - 1), vmax = 1 + (N - 1);
  const Y = (v) => tTop + (vmax - v) / (vmax - vmin) * (h - tTop - 22);
  // árbol de todos los caminos
  for (let n = 1; n < N; n++) for (let v = 1 - (n - 1); v <= 1 + (n - 1); v += 2) {
    PP.path(ctx, [[X(n), Y(v)], [X(n + 1), Y(v + 1)]], C("--rule"), 1);
    PP.path(ctx, [[X(n), Y(v)], [X(n + 1), Y(v - 1)]], C("--rule"), 1);
  }
  // bits
  const cells = [];
  for (let n = 1; n < N; n++) {
    const cx = (X(n) + X(n + 1)) / 2, bw = Math.min(26, (X(2) - X(1)) * 0.8);
    cells.push({ x0: cx - bw / 2, x1: cx + bw / 2, i: n - 1 });
    const on = BITS[n - 1] === 1;
    PP.rect(ctx, cx - bw / 2, 4, bw, bitH - 6, C(on ? "--accent" : "--muted"), on ? C("--area") : null);
    PP.label(ctx, String(BITS[n - 1]), cx, 4 + (bitH - 6) / 2, C("--ink"), "center", "middle", 12);
  }
  PP.label(ctx, "b", 4, 4 + (bitH - 6) / 2, C("--muted"), "left", "middle", 12);
  // camino
  const a = [1];
  for (let n = 1; n < N; n++) a.push(a[n - 1] + (BITS[n - 1] === 1 ? 1 : -1));
  PP.path(ctx, a.map((v, i) => [X(i + 1), Y(v)]), C("--accent"), 2.5);
  a.forEach((v, i) => PP.dot(ctx, X(i + 1), Y(v), 4, C("--accent")));
  PP.label(ctx, "a₁ = 1", X(1) + 6, Y(1), C("--accent"), "left", "middle", 11);
  PP.path(ctx, [[X(1), Y(0)], [X(N), Y(0)]], C("--muted"), 1, [2, 3]);
  PP.label(ctx, "0", l - 6, Y(0), C("--muted"), "right", "middle", 10);
  for (let n = 1; n <= N; n++) PP.label(ctx, String(n), X(n), h - 4, C("--muted"), "center", "bottom", 10);
  C33 = { cells, bitH };
  PP.read("ejp2-c33-read1", [
    ["(bₙ)", BITS.slice(0, N - 1).join(", ")],
    ["(aₙ)", a.map(neg).join(", ")],
    ["|aₙ₊₁ − aₙ| = 1", "en todos los pasos ✓", "good"],
  ]);
}
PP.register(caminos, ["ejp2-c33-N"]);
pointer("ejp2-c33-c1", (px, py) => {
  if (!C33 || py > C33.bitH + 2) return false;
  const c = C33.cells.find((c) => px >= c.x0 - 3 && px <= c.x1 + 3);
  if (!c) return false;
  BITS[c.i] = 1 - BITS[c.i];
  caminos();
  return true;
});

/* ===================== C3-4 · intervalos racionales ===================== */

let X34 = 1.2345, T34 = null;
function racionalCerca(x, tol) {
  for (let d = 1; d <= 400; d++) { const p = Math.round(x * d); if (Math.abs(x - p / d) < tol) return [p, d]; }
  return [Math.round(x * 400), 400];
}
function racionalEntre(lo, hi) {
  for (let d = 1; d <= 2000; d++) { const p = Math.floor(lo * d) + 1; if (p / d < hi) return [p, d]; }
  return null;
}
function entornos() {
  const eps = PP.val("ejp2-c34-eps") / 100;
  PP.out("ejp2-c34-eps-o", PP.fmt(eps, 2));
  const x = X34;
  const [qp, qd] = racionalCerca(x, eps / 2), q = qp / qd;
  const rr = racionalEntre(Math.abs(x - q), eps / 2);
  const r = rr ? rr[0] / rr[1] : eps / 4;
  const { ctx, w, h } = PP.canvas("ejp2-c34-c1", 0.5);
  const T = PP.frame(w, h, { x0: -0.6, x1: 3.1, y0: 0, y1: 1 }, { l: 12, r: 12, t: 10, b: 26 });
  T34 = T;
  const y0 = T.Y(0.3);
  PP.path(ctx, [[T.X(-0.6), y0], [T.X(3.1), y0]], C("--muted"), 1);
  for (let v = 0; v <= 3; v++) {
    PP.path(ctx, [[T.X(v), y0 - 4], [T.X(v), y0 + 4]], C("--muted"), 1);
    PP.label(ctx, String(v), T.X(v), y0 + 8, C("--muted"), "center", "top", 10);
  }
  PP.rect(ctx, T.X(x - eps), T.Y(0.95), T.X(x + eps) - T.X(x - eps), T.Y(0.05) - T.Y(0.95), null, C("--band"));
  PP.path(ctx, [[T.X(x - eps), T.Y(0.95)], [T.X(x - eps), T.Y(0.05)]], C("--accent"), 1.2, [4, 3]);
  PP.path(ctx, [[T.X(x + eps), T.Y(0.95)], [T.X(x + eps), T.Y(0.05)]], C("--accent"), 1.2, [4, 3]);
  [x - eps / 2, x + eps / 2].forEach((v) => PP.path(ctx, [[T.X(v), T.Y(0.85)], [T.X(v), T.Y(0.75)]], C("--accent"), 1.5));
  PP.label(ctx, "x ± εₓ/2", T.X(x - eps / 2) - 4, T.Y(0.8), C("--accent"), "right", "middle", 10);
  PP.label(ctx, "x − εₓ", T.X(x - eps) + 3, T.Y(0.95), C("--accent"), "left", "top", 10);
  PP.label(ctx, "x + εₓ", T.X(x + eps) - 3, T.Y(0.95), C("--accent"), "right", "top", 10);
  const yi = T.Y(0.55);
  PP.rect(ctx, T.X(q - r), yi - 6, T.X(q + r) - T.X(q - r), 12, C("--ok"), C("--okband"));
  PP.label(ctx, "(q − r, q + r)", T.X(q), yi - 8, C("--ok"), "center", "bottom", 10);
  PP.dot(ctx, T.X(q), yi, 4, C("--seq2"));
  PP.dot(ctx, T.X(q), y0, 4, C("--seq2"));
  PP.label(ctx, "q", T.X(q), y0 - 6, C("--seq2"), "center", "bottom", 11);
  PP.path(ctx, [[T.X(x), yi + 10], [T.X(x), y0]], C("--accent"), 1, [2, 2]);
  PP.dot(ctx, T.X(x), y0, 6.5, C("--accent"));
  PP.label(ctx, "x", T.X(x) + 8, y0 + 4, C("--accent"), "left", "top", 12);
  const okIn = Math.abs(x - q) < r, okSub = q - r >= x - eps - 1e-12 && q + r <= x + eps + 1e-12;
  PP.read("ejp2-c34-read1", [
    ["x, εₓ", PP.fmt(x, 4) + ", " + PP.fmt(eps, 2)],
    ["q", frac(qp, qd) + "  (|x − q| = " + PP.fmt(Math.abs(x - q), 4) + ")"],
    ["r", (rr ? frac(rr[0], rr[1]) : PP.fmt(r, 4)) + "  (< εₓ/2 = " + PP.fmt(eps / 2, 4) + ")"],
    ["x ∈ (q − r, q + r)", okIn ? "sí ✓" : "no", okIn ? "good" : "bad"],
    ["(q − r, q + r) ⊆ entorno", okSub ? "sí ✓" : "no", okSub ? "good" : "bad"],
  ]);
}
PP.register(entornos, ["ejp2-c34-eps"]);
pointer("ejp2-c34-c1", (px, py, t) => {
  if (!T34) return false;
  X34 = clamp(T34.iX(px), -0.4, 2.9);
  entornos();
  return true;
}, true);

/* ===================== guía-3 · finitos unos ===================== */

const UNOS = new Set([2, 5, 9]);
let G3 = null;
function finitosUnos() {
  const M = 16;
  const { ctx, w, h } = PP.canvas("ejp2-g3-c1", 0.32);
  const l = 6, r = 30, cw = (w - l - r) / M, y = h * 0.42, bh = Math.min(30, cw * 1.3);
  for (let i = 1; i <= M; i++) {
    const x = l + (i - 1) * cw, on = UNOS.has(i);
    PP.rect(ctx, x + 1, y - bh / 2, cw - 2, bh, C(on ? "--accent" : "--rule"), on ? C("--area") : null);
    PP.label(ctx, on ? "1" : "0", x + cw / 2, y, on ? C("--ink") : C("--muted"), "center", "middle", Math.min(13, cw * 0.7));
    PP.label(ctx, String(i), x + cw / 2, y + bh / 2 + 4, on ? C("--accent") : C("--muted"), "center", "top", Math.min(10, cw * 0.6));
  }
  PP.label(ctx, "0 …", w - 4, y, C("--muted"), "right", "middle", 12);
  PP.label(ctx, "tocá una casilla", l, 6, C("--muted"), "left", "top", 10);
  G3 = { l, cw, y, bh };
  const pos = [...UNOS].sort((a, b) => a - b);
  PP.read("ejp2-g3-read1", [
    ["cantidad de unos", "k = " + pos.length + "  →  está en A" + sub(pos.length)],
    ["posiciones", pos.length ? "(" + pos.join(", ") + ") ∈ ℕ" + sup(pos.length) : "ninguna: es (0, 0, 0, …), el único elemento de A₀"],
    ["la sucesión se reconstruye", "unos en esas posiciones, ceros en el resto ✓", "good"],
  ]);
}
PP.register(finitosUnos, []);
pointer("ejp2-g3-c1", (px, py) => {
  if (!G3 || Math.abs(py - G3.y) > G3.bh / 2 + 4) return false;
  const i = Math.floor((px - G3.l) / G3.cw) + 1;
  if (i < 1 || i > 16) return false;
  if (UNOS.has(i)) UNOS.delete(i); else UNOS.add(i);
  finitosUnos();
  return true;
});

/* ===================== guía-4 · finitos y cofinitos ===================== */

const BZ = new Set([-3, 0, 4]);
let G4 = null;
function finCofin() {
  const lo = -8, hi = 8, M = hi - lo + 1;
  const comp = PP.radio("ejp2-g4-ver") === "C";
  const { ctx, w, h } = PP.canvas("ejp2-g4-c1", 0.32);
  const l = 22, r = 22, cw = (w - l - r) / M, y = h * 0.45, rad = Math.min(11, cw * 0.46);
  PP.path(ctx, [[4, y], [w - 4, y]], C("--muted"), 1);
  PP.label(ctx, "…", 4, y - 4, comp ? C("--seq2") : C("--muted"), "left", "bottom", 13);
  PP.label(ctx, "…", w - 4, y - 4, comp ? C("--seq2") : C("--muted"), "right", "bottom", 13);
  for (let z = lo; z <= hi; z++) {
    const cx = l + (z - lo + 0.5) * cw, inB = BZ.has(z), on = comp ? !inB : inB;
    PP.circle(ctx, cx, y, rad, on ? C(comp ? "--seq2" : "--accent") : C("--rule"), on ? C(comp ? "--area2" : "--area") : C("--panel"));
    PP.label(ctx, neg(z), cx, y + rad + 4, on ? C("--ink") : C("--muted"), "center", "top", Math.min(10, cw * 0.55));
  }
  PP.label(ctx, comp ? "ℤ ∖ B: todos menos " + BZ.size : "B: " + BZ.size + " elementos", w / 2, 6, C(comp ? "--seq2" : "--accent"), "center", "top", 11);
  G4 = { l, cw, y, rad, lo, hi };
  const el = [...BZ].sort((a, b) => a - b);
  PP.read("ejp2-g4-read1", [
    ["B", el.length ? "{" + el.map(neg).join(", ") + "}" : "∅"],
    ["k-upla ordenada", el.length ? "(" + el.map(neg).join(", ") + ") ∈ ℤ" + sup(el.length) : "( ) (k = 0)"],
    ["ℤ ∖ B", "infinito, con complemento finito: cofinito", "good"],
  ]);
}
PP.register(finCofin, ["input[name=\"ejp2-g4-ver\"]"]);
pointer("ejp2-g4-c1", (px, py) => {
  if (!G4 || Math.abs(py - G4.y) > G4.rad + 6) return false;
  const z = Math.floor((px - G4.l) / G4.cw) + G4.lo;
  if (z < G4.lo || z > G4.hi) return false;
  if (BZ.has(z)) BZ.delete(z); else BZ.add(z);
  finCofin();
  return true;
});
