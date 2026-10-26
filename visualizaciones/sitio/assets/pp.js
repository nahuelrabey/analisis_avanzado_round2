/* Librería mínima de dibujo compartida por todos los ejercicios (window.PP). */
window.PP = (() => {
  "use strict";
  const draws = [];
  const css = (name) => getComputedStyle(document.documentElement).getPropertyValue(name).trim();
  const fmt = (x, d = 3) => {
    if (typeof x !== "number") return String(x);
    if (!isFinite(x)) return x > 0 ? "+∞" : "−∞";
    return Number(x).toFixed(d).replace(/\.?0+$/, "").replace("-", "−");
  };
  function canvas(el, ratio) {
    if (typeof el === "string") el = document.getElementById(el);
    const w = el.clientWidth || 480;
    const h = Math.max(180, Math.round(w * (ratio || 0.62)));
    const dpr = window.devicePixelRatio || 1;
    el.width = Math.round(w * dpr); el.height = Math.round(h * dpr); el.style.height = h + "px";
    const ctx = el.getContext("2d");
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0); ctx.clearRect(0, 0, w, h);
    return { ctx, w, h };
  }
  function frame(w, h, box, pad) {
    const p = Object.assign({ l: 44, r: 14, t: 14, b: 30 }, pad || {});
    const X = (x) => p.l + (x - box.x0) / (box.x1 - box.x0) * (w - p.l - p.r);
    const Y = (y) => h - p.b - (y - box.y0) / (box.y1 - box.y0) * (h - p.t - p.b);
    const iX = (px) => box.x0 + (px - p.l) / (w - p.l - p.r) * (box.x1 - box.x0);
    const iY = (py) => box.y0 + (h - p.b - py) / (h - p.t - p.b) * (box.y1 - box.y0);
    return { X, Y, iX, iY, p, box, w, h };
  }
  function niceStep(span, target) {
    const raw = span / target, m = Math.pow(10, Math.floor(Math.log10(raw))), f = raw / m;
    return (f < 1.5 ? 1 : f < 3.5 ? 2 : f < 7.5 ? 5 : 10) * m;
  }
  function axes(ctx, T, opts) {
    const o = Object.assign({ xLabel: "", yLabel: "", xTicks: 6, yTicks: 5, intX: false, grid: true, zero: true }, opts || {});
    const { box, w, h, p } = T;
    ctx.save();
    ctx.font = "11px 'IBM Plex Sans', system-ui, sans-serif"; ctx.fillStyle = css("--muted"); ctx.strokeStyle = css("--rule"); ctx.lineWidth = 1;
    const ys = niceStep(box.y1 - box.y0, o.yTicks);
    ctx.textAlign = "right"; ctx.textBaseline = "middle";
    for (let y = Math.ceil(box.y0 / ys) * ys; y <= box.y1 + 1e-9; y += ys) {
      if (o.grid) { ctx.beginPath(); ctx.moveTo(p.l, T.Y(y)); ctx.lineTo(w - p.r, T.Y(y)); ctx.stroke(); }
      ctx.fillText(fmt(y, 2), p.l - 6, T.Y(y));
    }
    let xs = niceStep(box.x1 - box.x0, o.xTicks); if (o.intX) xs = Math.max(1, Math.round(xs));
    ctx.textAlign = "center"; ctx.textBaseline = "top";
    for (let x = Math.ceil(box.x0 / xs) * xs; x <= box.x1 + 1e-9; x += xs) {
      if (o.intX && x < 1) continue;
      ctx.fillText(fmt(x, 2), T.X(x), h - p.b + 6);
    }
    if (o.zero) {
      ctx.strokeStyle = css("--muted");
      if (box.y0 < 0 && box.y1 > 0) { ctx.beginPath(); ctx.moveTo(p.l, T.Y(0)); ctx.lineTo(w - p.r, T.Y(0)); ctx.stroke(); }
      if (box.x0 < 0 && box.x1 > 0) { ctx.beginPath(); ctx.moveTo(T.X(0), p.t); ctx.lineTo(T.X(0), h - p.b); ctx.stroke(); }
    }
    if (o.xLabel) { ctx.textAlign = "right"; ctx.textBaseline = "bottom"; ctx.fillText(o.xLabel, w - p.r, h - p.b - 3); }
    if (o.yLabel) { ctx.textAlign = "left"; ctx.textBaseline = "top"; ctx.fillText(o.yLabel, p.l + 4, p.t); }
    ctx.restore();
  }
  function dot(ctx, x, y, r, fill, stroke) {
    ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2);
    if (fill) { ctx.fillStyle = fill; ctx.fill(); }
    if (stroke) { ctx.strokeStyle = stroke; ctx.lineWidth = 1.5; ctx.stroke(); }
  }
  function path(ctx, pts, color, width, dash, close, fill) {
    if (!pts.length) return;
    ctx.save(); ctx.beginPath(); ctx.moveTo(pts[0][0], pts[0][1]);
    for (let i = 1; i < pts.length; i++) ctx.lineTo(pts[i][0], pts[i][1]);
    if (close) ctx.closePath();
    if (fill) { ctx.fillStyle = fill; ctx.fill(); }
    if (color) { ctx.strokeStyle = color; ctx.lineWidth = width || 1.5; ctx.setLineDash(dash || []); ctx.stroke(); }
    ctx.restore();
  }
  function circle(ctx, x, y, r, stroke, fill, dash, width) {
    ctx.save(); ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2);
    if (fill) { ctx.fillStyle = fill; ctx.fill(); }
    if (stroke) { ctx.strokeStyle = stroke; ctx.lineWidth = width || 1.5; ctx.setLineDash(dash || []); ctx.stroke(); }
    ctx.restore();
  }
  function rect(ctx, x, y, w, h, stroke, fill, dash) {
    ctx.save();
    if (fill) { ctx.fillStyle = fill; ctx.fillRect(x, y, w, h); }
    if (stroke) { ctx.strokeStyle = stroke; ctx.lineWidth = 1.5; ctx.setLineDash(dash || []); ctx.strokeRect(x, y, w, h); }
    ctx.restore();
  }
  function label(ctx, text, x, y, color, align, base, size) {
    ctx.save(); ctx.font = (size || 12) + "px 'IBM Plex Sans', system-ui, sans-serif"; ctx.fillStyle = color || css("--ink");
    ctx.textAlign = align || "left"; ctx.textBaseline = base || "bottom"; ctx.fillText(text, x, y); ctx.restore();
  }
  function read(el, rows) {
    if (typeof el === "string") el = document.getElementById(el);
    el.innerHTML = rows.map(([k, v, cls]) => `<dt>${k}</dt><dd${cls ? ` class="${cls}"` : ""}>${v}</dd>`).join("");
  }
  function out(id, text) { const o = document.getElementById(id); if (o) o.textContent = text; }
  function radio(name) { const r = document.querySelector(`input[name="${name}"]:checked`); return r ? r.value : null; }
  function val(id) { return +document.getElementById(id).value; }
  /* Registra una función de dibujo: se llama al cargar, al cambiar de tamaño o de tema, y cuando cambia cualquiera de los controles listados. */
  function register(draw, controls) {
    draws.push(draw);
    (controls || []).forEach((sel) => {
      document.querySelectorAll(sel.startsWith("#") || sel.startsWith(".") || sel.startsWith("input") ? sel : "#" + sel).forEach((el) => {
        el.addEventListener(el.type === "radio" || el.type === "checkbox" ? "change" : "input", () => { try { draw(); } catch (e) { console.error(e); } });
      });
    });
  }
  function redrawAll() { draws.forEach((d) => { try { d(); } catch (e) { console.error(e); } }); }
  return { css, fmt, canvas, frame, axes, dot, path, circle, rect, label, read, out, radio, val, register, redrawAll, niceStep };
})();
