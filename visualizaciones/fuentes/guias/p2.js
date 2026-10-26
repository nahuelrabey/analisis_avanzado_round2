/* Dibujos de la guía de la Práctica 2 (enunciados). Usa window.PP. */
const G = "guiap2";
const C = (t) => PP.css(t);
const gcd = (a, b) => (b === 0 ? Math.abs(a) : gcd(b, a % b));
const isPrime = (n) => { if (n < 2) return false; for (let d = 2; d * d <= n; d++) if (n % d === 0) return false; return true; };
const minus = (s) => String(s).replace(/-/g, "−");

function numberLine(ctx, T, y0, x0, x1, step, labelEvery) {
  PP.path(ctx, [[T.X(x0), y0], [T.X(x1), y0]], C("--muted"), 1.2);
  for (let k = Math.ceil(x0 / step) * step; k <= x1 + 1e-9; k += step) {
    PP.path(ctx, [[T.X(k), y0 - 4], [T.X(k), y0 + 4]], C("--muted"), 1);
    if (labelEvery && Math.round(k / step) % labelEvery === 0) PP.label(ctx, minus(PP.fmt(k, 2)), T.X(k), y0 + 8, C("--muted"), "center", "top", 11);
  }
}

/* ===================== Ejercicio 1 ===================== */
PP.register(function drawEj1() {
  const it = PP.radio(G + "-ej1-it"), K = PP.val(G + "-ej1-K");
  PP.out(G + "-ej1-K-o", String(K));
  if (it === "c") {
    const { ctx, w, h } = PP.canvas(G + "-ej1-c", 0.62);
    const T = PP.frame(w, h, { x0: -K - 0.8, x1: K + 0.8, y0: 0, y1: K + 0.8 }, { l: 30, r: 12, t: 12, b: 26 });
    PP.axes(ctx, T, { xLabel: "m ∈ ℤ", yLabel: "n ∈ ℕ", xTicks: 8, yTicks: 5 });
    let cnt = 0;
    for (let m = -K; m <= K; m++) for (let n = 1; n <= K; n++) { PP.dot(ctx, T.X(m), T.Y(n), 3.6, C("--accent")); cnt++; }
    PP.read(G + "-ej1-read", [["conjunto", "ℤ × ℕ"], ["pares dibujados", cnt + "  (|m| ≤ " + K + ", n ≤ " + K + ")"]]);
    return;
  }
  if (it === "d") {
    const { ctx, w, h } = PP.canvas(G + "-ej1-c", 0.62);
    const T = PP.frame(w, h, { x0: -1.1, x1: 1.1, y0: K + 0.7, y1: 0.3 }, { l: 34, r: 12, t: 12, b: 26 });
    const Yq = (q) => T.p.t + (q - 0.3) / (K + 0.4) * (h - T.p.t - T.p.b);
    numberLine(ctx, T, h - T.p.b, -1, 1, 0.5, 1);
    PP.circle(ctx, T.X(-1), h - T.p.b, 4, C("--muted"), C("--bg"), null, 1.5);
    PP.circle(ctx, T.X(1), h - T.p.b, 4, C("--muted"), C("--bg"), null, 1.5);
    let cnt = 0;
    for (let q = 1; q <= K; q++) {
      PP.label(ctx, "q=" + q, T.p.l - 4, Yq(q), C("--muted"), "right", "middle", 10);
      for (let p = -q + 1; p <= q - 1; p++) {
        if (gcd(p, q) !== 1 && !(p === 0 && q === 1)) continue;
        PP.dot(ctx, T.X(p / q), Yq(q), 3.4, C("--accent"));
        cnt++;
      }
    }
    PP.read(G + "-ej1-read", [["conjunto", "(−1, 1) ∩ ℚ"], ["fracciones dibujadas", cnt + "  (denominador ≤ " + K + ", sin repetir)"]]);
    return;
  }
  const { ctx, w, h } = PP.canvas(G + "-ej1-c", 0.42);
  const span = it === "a" ? [-3 - 3 * K, 1] : [-5 * K - 2, 5 * K + 2];
  const T = PP.frame(w, h, { x0: span[0], x1: span[1], y0: 0, y1: 1 }, { l: 16, r: 16, t: 10, b: 10 });
  const y0 = h * 0.55;
  const step = it === "a" ? 1 : 5;
  numberLine(ctx, T, y0, Math.ceil(span[0]), Math.floor(span[1]), 1, it === "a" ? (K > 5 ? 3 : 1) : 5);
  let cnt = 0;
  if (it === "a") { for (let z = -3; z >= span[0]; z--) { PP.dot(ctx, T.X(z), y0, 4, C("--accent")); cnt++; } }
  else { for (let z = -5 * K; z <= 5 * K; z += step) { PP.dot(ctx, T.X(z), y0, 4, C("--accent")); cnt++; } }
  PP.label(ctx, "…", T.X(span[0]) + 2, y0 - 10, C("--accent"), "left", "bottom", 14);
  if (it === "b") PP.label(ctx, "…", T.X(span[1]) - 2, y0 - 10, C("--accent"), "right", "bottom", 14);
  PP.read(G + "-ej1-read", [["conjunto", it === "a" ? "ℤ≤−3 = {−3, −4, −5, …}" : "5ℤ = {…, −5, 0, 5, …}"], ["elementos dibujados", String(cnt)]]);
}, ["input[name='" + G + "-ej1-it']", G + "-ej1-K"]);

/* ===================== Ejercicio 5 ===================== */
PP.register(function drawEj5() {
  const m = PP.val(G + "-ej5-m");
  PP.out(G + "-ej5-m-o", String(m));
  const { ctx, w, h } = PP.canvas(G + "-ej5-c", 0.62);
  const T = PP.frame(w, h, { x0: -0.2, x1: 4.4, y0: 0, y1: 1 }, { l: 36, r: 12, t: 10, b: 26 });
  const lo = (n) => n / 2 - 0.5, hi = (n) => n / 2 + 0.6;
  const rowH = (h - 70) / 7;
  for (let n = 1; n <= m; n++) {
    const y = 14 + (n - 0.5) * rowH;
    PP.path(ctx, [[T.X(lo(n)), y], [T.X(hi(n)), y]], C("--accent"), 5);
    PP.label(ctx, "A" + "₁₂₃₄₅₆₇"[n - 1], 6, y, C("--accent"), "left", "middle", 12);
  }
  const yU = h - 40;
  PP.path(ctx, [[T.X(lo(1)), yU], [T.X(hi(m)), yU]], C("--seq2"), 7);
  PP.label(ctx, "⋃", 8, yU, C("--seq2"), "left", "middle", 13);
  numberLine(ctx, T, h - 18, 0, 4, 0.5, 2);
  PP.read(G + "-ej5-read", [["⋃ₙ≤ₘ Aₙ", "[0, " + PP.fmt(hi(m), 2) + "]"]]);
}, [G + "-ej5-m"]);

/* ===================== Ejercicio 6 ===================== */
PP.register(function drawEj6() {
  const k = +PP.radio(G + "-ej6-A"), m = PP.val(G + "-ej6-m");
  PP.out(G + "-ej6-m-o", String(m));
  const letters = "abc".slice(0, k);
  const words = [];
  const rec = (s) => { if (s.length === m) { words.push(s); return; } for (const c of letters) rec(s + c); };
  rec("");
  const show = words.slice(0, 81);
  const w0 = document.getElementById(G + "-ej6-c").clientWidth || 480;
  const cols = Math.min(show.length, w0 < 420 ? 6 : 9);
  const rows = Math.ceil(show.length / cols);
  const { ctx, w, h } = PP.canvas(G + "-ej6-c", (rows * 32 + 20) / w0);
  const cw = (w - 20) / cols, ch = Math.min(32, (h - 20) / Math.max(rows, 1));
  show.forEach((s, i) => {
    const x = 10 + (i % cols) * cw, y = 10 + Math.floor(i / cols) * ch;
    PP.rect(ctx, x + 2, y + 2, cw - 4, ch - 4, C("--accent"), C("--band"));
    PP.label(ctx, s, x + cw / 2, y + ch / 2, C("--ink"), "center", "middle", ch < 22 ? 10 : 12);
  });
  let total = 0; for (let j = 1; j <= m; j++) total += Math.pow(k, j);
  PP.read(G + "-ej6-read", [["#A", String(k)], ["#Aᵐ", k + "^" + m + " = " + Math.pow(k, m)], ["palabras de longitud ≤ " + m, String(total)]]);
}, ["input[name='" + G + "-ej6-A']", G + "-ej6-m"]);

/* ===================== Ejercicio 10 ===================== */
PP.register(function drawEj10() {
  const v = PP.val(G + "-ej10-x"), x = v / 1024;
  const L = 10;
  const bits = [];
  { let r = v; for (let k = L - 1; k >= 0; k--) { bits.push((r >> k) & 1); } }
  PP.out(G + "-ej10-x-o", PP.fmt(x, 4));
  const { ctx, w, h } = PP.canvas(G + "-ej10-c", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: 1, y0: 0, y1: 1 }, { l: 34, r: 14, t: 12, b: 26 });
  const levels = 8, rh = (h - T.p.t - T.p.b) / (levels + 0.5);
  let a = 0, len = 1;
  for (let k = 1; k <= levels; k++) {
    const y = T.p.t + (k - 1) * rh;
    const b = bits[k - 1];
    const half = len / 2;
    PP.rect(ctx, T.X(a), y + 3, T.X(a + half) - T.X(a), rh - 6, C("--rule"), b === 0 ? C("--area") : null);
    PP.rect(ctx, T.X(a + half), y + 3, T.X(a + len) - T.X(a + half), rh - 6, C("--rule"), b === 1 ? C("--area") : null);
    PP.label(ctx, "b" + (k === 1 ? "₁" : "₂₃₄₅₆₇₈"[k - 2]) + "=" + b, T.p.l - 4, y + rh / 2, C("--muted"), "right", "middle", 10);
    if (b === 1) a += half;
    len = half;
  }
  const yb = h - T.p.b;
  numberLine(ctx, T, yb, 0, 1, 0.25, 1);
  PP.path(ctx, [[T.X(x), T.p.t], [T.X(x), yb]], C("--seq2"), 1.5, [4, 3]);
  PP.dot(ctx, T.X(x), yb, 5, C("--seq2"));
  // los dos desarrollos de un múltiplo de 1/1024
  const s = bits.join("");
  const last1 = s.lastIndexOf("1");
  let dev1, dev2;
  if (v === 0) { dev1 = "0.000000000…"; dev2 = "no tiene otro"; }
  else {
    const t = s.slice(0, last1 + 1);
    dev1 = "0." + t + "000…";
    dev2 = "0." + t.slice(0, -1) + "0" + "111…";
  }
  PP.read(G + "-ej10-read", [["x", v + "/1024 = " + PP.fmt(x, 6)], ["desarrollo", dev1], ["otro desarrollo", dev2]]);
}, [G + "-ej10-x"]);

/* ===================== Ejercicio 12 ===================== */
PP.register(function drawEj12() {
  const { ctx, w, h } = PP.canvas(G + "-ej12-c", 0.62);
  const cw = (w - 20) / 10, ch = (h - 20) / 10;
  let cnt = 0;
  for (let n = 1; n <= 100; n++) {
    const i = (n - 1) % 10, j = Math.floor((n - 1) / 10);
    const x = 10 + i * cw, y = 10 + j * ch, p = isPrime(n);
    if (p) cnt++;
    PP.rect(ctx, x + 1.5, y + 1.5, cw - 3, ch - 3, p ? C("--accent") : C("--rule"), p ? C("--area") : null);
    PP.label(ctx, String(n), x + cw / 2, y + ch / 2, p ? C("--accent") : C("--muted"), "center", "middle", Math.min(13, ch * 0.42));
  }
  PP.read(G + "-ej12-read", [["primos entre 1 y 100", String(cnt)]]);
}, []);

/* ===================== Ejercicio 13 ===================== */
PP.register(function drawEj13() {
  const B = PP.radio(G + "-ej13-B");
  const inB = { par: (n) => n % 2 === 0, tres: (n) => n % 3 === 0, primo: isPrime, cuad: (n) => Number.isInteger(Math.sqrt(n)) }[B];
  const { ctx, w, h } = PP.canvas(G + "-ej13-c", 0.4);
  const per = 15, rows = 4, cw = (w - 20) / per, ch = Math.min(42, (h - 20) / rows);
  let nb = 0;
  for (let n = 1; n <= 60; n++) {
    const i = (n - 1) % per, j = Math.floor((n - 1) / per);
    const x = 10 + i * cw, y = 10 + j * (ch + 6);
    const b = inB(n);
    if (b) nb++;
    PP.rect(ctx, x + 1.5, y, cw - 3, ch, null, b ? C("--accent") : C("--area2"));
    PP.label(ctx, String(n), x + cw / 2, y + ch / 2, b ? C("--bg") : C("--seq2"), "center", "middle", Math.min(12, cw * 0.45));
  }
  const name = { par: "pares", tres: "múltiplos de 3", primo: "primos", cuad: "cuadrados" }[B];
  PP.read(G + "-ej13-read", [["B", name], ["en B (1 a 60)", String(nb)], ["en ℕ ∖ B (1 a 60)", String(60 - nb)]]);
}, ["input[name='" + G + "-ej13-B']"]);

/* ===================== Ejercicio 16 ===================== */
PP.register(function drawEj16() {
  const p = PP.val(G + "-ej16-p");
  PP.out(G + "-ej16-p-o", String(p));
  const block = [[1, 2], [-1, 1], [3, 4], [0, 1], [2, 1], [-1, 3]].slice(0, p);
  const N = 24;
  const { ctx, w, h } = PP.canvas(G + "-ej16-c", 0.62);
  const T = PP.frame(w, h, { x0: 0, x1: N + 1, y0: -1.4, y1: 2.4 }, { l: 40, r: 12, t: 14, b: 28 });
  for (let s = 0; s * p < N; s += 2) PP.rect(ctx, T.X(s * p + 0.5), T.p.t, T.X(Math.min((s + 1) * p, N) + 0.5) - T.X(s * p + 0.5), h - T.p.t - T.p.b, null, C("--band"));
  PP.axes(ctx, T, { xLabel: "n", intX: true });
  for (let n = 1; n <= N; n++) { const [a, b] = block[(n - 1) % p]; PP.dot(ctx, T.X(n), T.Y(a / b), 3.6, C("--accent")); }
  const fr = ([a, b]) => minus(b === 1 ? String(a) : a + "/" + b);
  PP.read(G + "-ej16-read", [["bloque que se repite", "(" + block.map(fr).join(", ") + ")"], ["aₙ₊ₚ = aₙ", "para todo n"]]);
}, [G + "-ej16-p"]);

/* ===================== Ejercicio 17 ===================== */
PP.register(function drawEj17() {
  const it = PP.radio(G + "-ej17-it"), N = PP.val(G + "-ej17-N");
  PP.out(G + "-ej17-N-o", String(N));
  if (it === "a") {
    const { ctx, w, h } = PP.canvas(G + "-ej17-c", 0.42);
    const T = PP.frame(w, h, { x0: -0.03, x1: 1.05, y0: 0, y1: 1 }, { l: 16, r: 16, t: 10, b: 10 });
    const y0 = h * 0.58;
    numberLine(ctx, T, y0 + 22, 0, 1, 0.25, 1);
    for (let k = 1; k <= N; k++) {
      const a = 1 / (k + 1), b = 1 / k, col = k % 2 ? C("--accent") : C("--seq2");
      PP.path(ctx, [[T.X(a) + 1.5, y0], [T.X(b) - 1.5, y0]], col, 6);
      if (T.X(b) - T.X(a) > 26) PP.label(ctx, "A" + (k < 10 ? "₀₁₂₃₄₅₆₇₈₉"[k] : k), (T.X(a) + T.X(b)) / 2, y0 - 8, col, "center", "bottom", 11);
    }
    PP.read(G + "-ej17-read", [["Aₖ", "(1/(k+1), 1/k), k = 1, …, " + N], ["¿disjuntos dos a dos?", "sí", "good"]]);
    return;
  }
  const { ctx, w, h } = PP.canvas(G + "-ej17-c", 0.62);
  const jumps = []; for (let k = 1; k <= N; k++) jumps.push([1 / k, 1 / (2 * k)]);
  const f = (x) => x / 2 + jumps.reduce((s, [p, j]) => s + (x >= p ? j : 0), 0);
  const ymax = f(1.2) + 0.1;
  const T = PP.frame(w, h, { x0: 0, x1: 1.2, y0: 0, y1: ymax }, { l: 40, r: 12, t: 14, b: 28 });
  PP.axes(ctx, T, { xLabel: "x", yLabel: "f(x)" });
  const cuts = [0, ...jumps.map(([p]) => p).sort((a, b) => a - b), 1.2];
  for (let i = 0; i < cuts.length - 1; i++) {
    const a = cuts[i], b = cuts[i + 1];
    PP.path(ctx, [[T.X(a), T.Y(f(a))], [T.X(b), T.Y(f(b - 1e-9))]], C("--accent"), 2.2);
  }
  jumps.forEach(([p]) => {
    PP.circle(ctx, T.X(p), T.Y(f(p - 1e-9)), 3.5, C("--accent"), C("--bg"), null, 1.6);
    PP.dot(ctx, T.X(p), T.Y(f(p)), 3.5, C("--accent"));
  });
  PP.read(G + "-ej17-read", [["f", "creciente, con " + N + " saltos"], ["saltos en", jumps.slice(0, 6).map(([p], i) => "1/" + (i + 1)).join(", ") + (N > 6 ? ", …" : "")]]);
}, ["input[name='" + G + "-ej17-it']", G + "-ej17-N"]);
