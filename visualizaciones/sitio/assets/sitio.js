/* Arranque de dibujos y popups del glosario. */
(() => {
  "use strict";
  PP.redrawAll();
  let pending = 0;
  const later = () => { cancelAnimationFrame(pending); pending = requestAnimationFrame(PP.redrawAll); };
  if (window.ResizeObserver) { const ro = new ResizeObserver(later); document.querySelectorAll(".viz canvas").forEach((c) => ro.observe(c)); }
  window.addEventListener("resize", later);
  window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", later);
  new MutationObserver(later).observe(document.documentElement, { attributes: true, attributeFilter: ["data-theme"] });
  if (document.fonts && document.fonts.ready) document.fonts.ready.then(later);

  const G = JSON.parse(document.getElementById("glosario").textContent);
  const pop = document.getElementById("popup");
  let current = null, hideTimer = 0, shownAt = 0;
  function render(key) {
    const g = G[key];
    if (!g) return `<div class="pop-title">Referencia</div><p>${key}</p>`;
    const head = [g.tipo, g.numero].filter(Boolean).join(" ");
    const m = /^guia-p(\d+)-ej(\d+)/.exec(key);
    const base = document.body.dataset.base || "";
    const link = m ? `<div class="pop-src"><a href="${base}guias/p${m[1]}.html#guiap${m[1]}-ej${m[2]}">Ver el ejercicio en la guía →</a></div>` : "";
    return `<div class="pop-title">${head}</div>${g.titulo ? `<div class="pop-name">${g.titulo}</div>` : ""}${g.enunciado}${g.fuente ? `<div class="pop-src">${g.fuente}</div>` : ""}${link}`;
  }
  function place(el) {
    const r = el.getBoundingClientRect(), pw = pop.offsetWidth, ph = pop.offsetHeight, vw = window.innerWidth, vh = window.innerHeight;
    let left = Math.min(Math.max(16, r.left), vw - pw - 16);
    let top = r.bottom + 8;
    if (top + ph > vh - 12) top = Math.max(12, r.top - ph - 8);
    pop.style.left = left + "px"; pop.style.top = top + "px";
  }
  function show(el) {
    clearTimeout(hideTimer);
    if (current === el && !pop.hidden) return;
    current = el; shownAt = performance.now();
    pop.innerHTML = render(el.dataset.ref);
    pop.hidden = false; place(el);
    if (window.MathJax && MathJax.typesetPromise) {
      MathJax.typesetClear && MathJax.typesetClear([pop]);
      MathJax.typesetPromise([pop]).then(() => { if (current === el) place(el); }).catch(() => {});
    }
  }
  function hide(delay) { clearTimeout(hideTimer); hideTimer = setTimeout(() => { pop.hidden = true; current = null; }, delay || 0); }
  document.querySelectorAll(".ref[data-ref]").forEach((el) => {
    if (!el.hasAttribute("tabindex")) el.setAttribute("tabindex", "0");
    el.setAttribute("role", "button");
    if (!G[el.dataset.ref]) console.warn("Referencia sin glosario:", el.dataset.ref);
    el.addEventListener("mouseenter", () => show(el));
    el.addEventListener("mouseleave", () => hide(180));
    el.addEventListener("focus", () => show(el));
    el.addEventListener("blur", () => hide(120));
    /* El foco (o el mouseenter) ya abre el popup justo antes del clic: un clic inmediato no lo cierra; uno posterior, sí. */
    el.addEventListener("click", (e) => { e.preventDefault(); if (current === el && !pop.hidden && performance.now() - shownAt > 400) hide(); else show(el); });
    el.addEventListener("keydown", (e) => { if (e.key === "Escape") hide(); });
  });
  pop.addEventListener("mouseenter", () => clearTimeout(hideTimer));
  pop.addEventListener("mouseleave", () => hide(150));
  document.addEventListener("click", (e) => { if (!pop.hidden && !pop.contains(e.target) && !(e.target.closest && e.target.closest(".ref"))) hide(); });
  window.addEventListener("scroll", () => { if (!pop.hidden && current) place(current); }, { passive: true });
})();
