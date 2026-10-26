#!/usr/bin/env python3
"""Genera el sitio de visualizaciones: visualizaciones/sitio/.

    python3 scripts/build_visualizaciones.py            # todo
    python3 scripts/build_visualizaciones.py --only guias/p4 --only ejemplos/p1   # sólo esas páginas (y la portada)

Fuentes (visualizaciones/fuentes/):
  assets/sitio.css, assets/pp.js, assets/sitio.js   compartidos por todas las páginas
  claves_apunte.json                                 claves canónicas del glosario (cajas de apuntes.typ)
  parciales/{id}.html|.json|.js                      un fragmento por examen: <section class="exam" id="{id}">
  ejemplos/{parte}.html|.json|.js                    fragmentos de ejemplos: <section class="bloque" id="ej{pag}-b{k}">
  guias/p{N}.html|.json|.js                          un fragmento por guía: <article class="ej" id="guiap{N}-ej{M}">
Además se copian, envueltas con su propio esqueleto, las visualizaciones sueltas de visualizaciones/*.html.

Salida (visualizaciones/sitio/):
  index.html          portada (es la página del artefacto: sin doctype propio)
  parciales/*.html, ejemplos/*.html, guias/*.html, otras/*.html, assets/*

Convenciones que el script resuelve:
  <span class="ref" data-ref="CLAVE">        hover con el enunciado (glosario unificado; cada página embebe lo que usa)
  <a class="xg" data-guia="p1" data-ej="7">  enlace a un ejercicio de guía; además alimenta "Ejemplos que lo preparan"
  <div class="preparan" data-ej="7"></div>   (en guías) se llena con los ejemplos y parciales que citan ese ejercicio
  href="#tema-X" → portada, índice por tema;  href="#inicio" → principio de la página
"""
import argparse
import html
import json
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
VIS = ROOT / "visualizaciones"
SRC = VIS / "fuentes"
OUT = VIS / "sitio"

TOPICS = {
    "supremo": "Supremo, ínfimo, máximo y mínimo",
    "cardinalidad": "Cardinalidad",
    "sucesiones": "Sucesiones y límites",
    "series": "Series",
    "metricas": "Métricas: verificar, comparar, bolas",
    "topologia": "Abiertos, cerrados, interior y clausura",
    "densidad": "Densidad",
    "completitud": "Sucesiones de Cauchy y completitud",
    "continuidad": "Continuidad, continuidad uniforme y Lipschitz",
    "funciones": "Espacios de funciones C([a, b])",
    "compacidad": "Compacidad",
    "normados": "Espacios normados y operadores",
    "convergencia-funciones": "Convergencia puntual y uniforme",
    "medida": "Medida de Lebesgue",
    "integracion": "Funciones medibles e integración",
}

# (sección, id de página, título, eyebrow, descripción, [fragmentos], prefijo de ids)
PARCIALES = [
    ("p1-1c2024", "Primer parcial · 1C 2024"),
    ("p1-2c2024", "Primer parcial · 2C 2024"),
    ("p1-1c2025", "Primer parcial · 1C 2025"),
    ("r1-1c2025", "Recuperatorio · 1C 2025"),
    ("p1-2c2025", "Primer parcial · 2C 2025"),
    ("r1-2c2025", "Recuperatorio · 2C 2025"),
]
EJEMPLOS = [
    ("p1", "Práctica 1", "Números reales, supremo e ínfimo, sucesiones y series", ["p1"]),
    ("p2", "Práctica 2", "Cardinalidad", ["p2"]),
    ("p3", "Práctica 3", "Espacios métricos: métricas, topología, sucesiones y completitud", ["p3-1", "p3-2"]),
    ("p4", "Práctica 4", "Funciones continuas", ["p4"]),
    ("p4alt", "Práctica 4 · alternativos", "Funciones continuas, con ejemplos de apuntes de otras universidades", ["p4alt-1", "p4alt-2", "p4alt-3"]),
    ("p5", "Práctica 5", "Compacidad", ["p5"]),
    ("p6", "Práctica 6", "Espacios normados y operadores", ["p6"]),
]
GUIAS = [
    ("p1", "Práctica 1", "Números reales, supremo e ínfimo, sucesiones"),
    ("p2", "Práctica 2", "Cardinalidad"),
    ("p3", "Práctica 3", "Espacios métricos"),
    ("p4", "Práctica 4", "Funciones continuas"),
    ("p5", "Práctica 5", "Compacidad"),
    ("p6", "Práctica 6", "Espacios normados"),
    ("p7", "Práctica 7", "Sucesiones de funciones"),
    ("p8", "Práctica 8", "Medida de Lebesgue"),
    ("p9", "Práctica 9", "Funciones medibles e integración"),
]
OTRAS = [
    ("algebra_limites", "Álgebra de límites", "Repaso de límites de sucesiones de las Prácticas 1 y 3, con seis dibujos interactivos."),
    ("subsucesiones", "Subsucesiones", "Subsucesiones y sus límites."),
    ("lipschitz_sucesiones", "Lipschitz y sucesiones", "Funciones Lipschitz vistas a través de sucesiones."),
    ("continuidad_uniforme", "Continuidad uniforme", "La caja ε–δ, la lupa y la curva δ máximo según el punto."),
    ("extension_denso", "Extensión desde un denso", "La demostración del Teorema 5.22 paso a paso."),
    ("integral_lipschitz", "La integral es Lipschitz", "El Ejemplo 5.26 c) dibujado."),
    ("proyecciones_producto", "Proyecciones en un producto", "Proyecciones de X × Y con d∞: abiertas y no cerradas."),
    ("ejemplos_p4", "Ejemplos de continuidad", "Los ejemplos de la Práctica 4 con dibujos interactivos (página original)."),
]

ATTR_RE = re.compile(r'([a-zA-Z-]+)="([^"]*)"')
ART_RE = re.compile(r'<article\s+class="ej"[^>]*>', re.S)
SEC_RE = re.compile(r'<section\s+class="(?:exam|bloque)"[^>]*>', re.S)
H2_RE = re.compile(r"<h2[^>]*>(.*?)</h2>", re.S)
TAG_RE = re.compile(r"<[^>]+>")

errors, warnings = [], []


def attrs(tag):
    return dict(ATTR_RE.findall(tag))


def plain(s):
    s = TAG_RE.sub("", s)
    return html.unescape(re.sub(r"\s+", " ", s)).strip()


def read(p):
    return p.read_text(encoding="utf-8") if p.exists() else None


def load_glossary():
    g = {}
    for f in sorted(SRC.glob("*/*.json")):
        try:
            data = json.loads(f.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            errors.append(f"{f.relative_to(ROOT)}: JSON inválido ({e})")
            continue
        for k, v in data.items():
            if k not in g:
                g[k] = dict(v)
            elif len(v.get("enunciado", "")) > len(g[k].get("enunciado", "")):
                g[k] = dict(v, titulo=g[k].get("titulo") or v.get("titulo", ""))
            elif not g[k].get("titulo") and v.get("titulo"):
                g[k]["titulo"] = v["titulo"]
    return g


def head(title, depth, extra=""):
    base = "../" * depth
    return f"""<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>{html.escape(title)}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,600;1,8..60,400&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&display=swap">
<script>
  window.MathJax = {{
    tex: {{ inlineMath: [["$", "$"]], displayMath: [["$$", "$$"]] }},
    svg: {{ fontCache: "global" }},
    options: {{ enableMenu: false }},
  }};
</script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/tex-svg.js" defer></script>
<link rel="stylesheet" href="{base}assets/sitio.css">
<style>:root {{ padding-top: env(safe-area-inset-top, 0px); padding-bottom: env(safe-area-inset-bottom, 0px); }} body {{ margin: 0; }} [hidden] {{ display: none !important; }}</style>
{extra}</head>
"""


def sitebar(crumbs, prev=None, nxt=None):
    items = []
    for i, (label, href) in enumerate(crumbs):
        if href and i < len(crumbs) - 1:
            items.append(f'<li><a href="{href}">{html.escape(label)}</a></li>')
        else:
            items.append(f'<li><span aria-current="page">{html.escape(label)}</span></li>')
    pg = ""
    if prev is not None or nxt is not None:
        def a(x, txt):
            return f'<a href="{x[1]}" title="{html.escape(x[0])}">{txt}</a>' if x else f'<a aria-disabled="true">{txt}</a>'
        pg = f'<div class="pager">{a(prev, "← Anterior")}{a(nxt, "Siguiente →")}</div>'
    return f'<nav class="sitebar" aria-label="Navegación del sitio"><div class="in"><ol class="crumbs">{"".join(items)}</ol>{pg}</div></nav>'


def wrap_js(name, code):
    return f"<script>\n/* {name} */\n(() => {{\n\"use strict\";\n{code.strip()}\n}})();\n</script>"


class Page:
    def __init__(self, section, pid, title, eyebrow, desc, parts, prefix, out):
        self.section, self.pid, self.title, self.eyebrow, self.desc = section, pid, title, eyebrow, desc
        self.parts, self.prefix, self.out = parts, prefix, out
        self.body, self.js, self.articles, self.groups, self.meta = "", [], [], [], ""
        self.missing = False

    def load(self):
        bodies = []
        for part in self.parts:
            h = read(SRC / self.section / f"{part}.html")
            if h is None:
                self.missing = True
                continue
            bodies.append(h.strip())
            js = read(SRC / self.section / f"{part}.js")
            if js:
                self.js.append(wrap_js(f"{self.section}/{part}", js))
        self.body = "\n\n".join(bodies)
        if not self.body:
            return
        m = re.search(r'<section\s+class="exam"[^>]*data-meta="([^"]*)"', self.body)
        self.meta = m.group(1) if m else ""
        # ids
        seen_ids = set()
        for m in re.finditer(r'\bid="([^"]+)"', self.body):
            if m.group(1) in seen_ids:
                errors.append(f"{self.section}/{self.pid}: id repetido {m.group(1)!r}")
            seen_ids.add(m.group(1))
            if not m.group(1).startswith(self.prefix):
                errors.append(f"{self.section}/{self.pid}: id {m.group(1)!r} no empieza con {self.prefix!r}")
        # índice local: secciones (bloques) y artículos
        pos = sorted([(m.start(), "sec", m.group(0)) for m in SEC_RE.finditer(self.body)] +
                     [(m.start(), "art", m.group(0)) for m in ART_RE.finditer(self.body)])
        cur = None
        for start, kind, tag in pos:
            at = attrs(tag)
            if kind == "sec":
                h2 = H2_RE.search(self.body, start)
                h2txt = re.sub(r'<span class="bn">(.*?)</span>', r"\1 · ", h2.group(1), count=1, flags=re.S) if h2 else ""
                cur = {"id": at.get("id"), "title": plain(h2txt) if h2 else at.get("id"), "items": []}
                self.groups.append(cur)
            else:
                aid, short, title = at.get("id"), at.get("data-short"), at.get("data-title")
                topics = [t.strip() for t in at.get("data-topics", "").split(",") if t.strip()]
                if not aid or not short or not title:
                    errors.append(f"{self.section}/{self.pid}: <article class=\"ej\"> sin id, data-short o data-title ({tag[:80]})")
                    continue
                if not topics:
                    warnings.append(f"{aid}: sin data-topics")
                for t in topics:
                    if t not in TOPICS:
                        errors.append(f"{aid}: tema desconocido {t!r}")
                art = {"id": aid, "short": short, "title": title, "topics": topics}
                self.articles.append(art)
                if cur is None:
                    cur = {"id": None, "title": "", "items": []}
                    self.groups.append(cur)
                cur["items"].append(art)


def build(only):
    glossary = load_glossary()
    pages = []
    for pid, title in PARCIALES:
        pages.append(Page("parciales", pid, title, "Primeros parciales resueltos", "", [pid], pid, f"parciales/{pid}.html"))
    for pid, title, desc, parts in EJEMPLOS:
        pages.append(Page("ejemplos", pid, f"Ejemplos · {title}", "Ejemplos resueltos", desc, parts, f"ej{pid}-", f"ejemplos/{pid}.html"))
    for pid, title, desc in GUIAS:
        pages.append(Page("guias", pid, f"Guía · {title}", "Guías de ejercicios", desc, [pid], f"guia{pid}-", f"guias/{pid}.html"))
    for p in pages:
        p.load()
        if p.missing:
            (warnings if not only else warnings).append(f"falta el fragmento de {p.section}/{p.pid} ({', '.join(p.parts)})")

    # enlaces a guías (a.xg) y "ejemplos que lo preparan"
    guide_ex = {}
    for p in pages:
        if p.section == "guias":
            for a in p.articles:
                m = re.match(rf"guia{p.pid}-ej(\d+)$", a["id"])
                if m:
                    guide_ex[(p.pid, m.group(1))] = a
    backlinks = {}
    for p in pages:
        if p.section == "guias" or not p.body:
            continue
        spans = [(m.start(), a["id"], a) for a in p.articles for m in [re.search(rf'id="{re.escape(a["id"])}"', p.body)] if m]
        secs = [(m.start(), attrs(m.group(0)).get("id")) for m in SEC_RE.finditer(p.body)]

        def owner(pos):
            art = [s for s in spans if s[0] <= pos]
            sec = [s for s in secs if s[0] <= pos]
            art = art[-1] if art else None
            sec = sec[-1] if sec else None
            if art and (not sec or art[0] > sec[0]):
                return art[1], f'{art[2]["short"]} · {art[2]["title"]}'
            if sec:
                g = next((g for g in p.groups if g["id"] == sec[1]), None)
                return sec[1], g["title"] if g else sec[1]
            return None, p.title

        def repl(m):
            at = attrs(m.group(0))
            g, e = at.get("data-guia"), at.get("data-ej")
            if not g or not e:
                errors.append(f"{p.out}: a.xg sin data-guia/data-ej: {m.group(0)[:80]}")
                return m.group(0)
            if (g, e) not in guide_ex and any(gp.pid == g and gp.body for gp in pages if gp.section == "guias"):
                errors.append(f"{p.out}: enlace a guía inexistente {g} Ej. {e}")
            anchor, label = owner(m.start())
            backlinks.setdefault((g, e), []).append((p, anchor, label))
            return m.group(0).replace("<a ", f'<a href="../guias/{g}.html#guia{g}-ej{e}" ', 1)
        p.body = re.sub(r'<a\s+class="xg"[^>]*>', repl, p.body)

    for p in pages:
        if p.section != "guias" or not p.body:
            continue

        def fill(m):
            e = attrs(m.group(0)).get("data-ej")
            refs = backlinks.get((p.pid, e), [])
            seen, items = set(), []
            for q, anchor, label in refs:
                key = (q.out, anchor)
                if key in seen:
                    continue
                seen.add(key)
                href = f"../{q.out}" + (f"#{anchor}" if anchor else "")
                items.append(f'<li><a href="{href}" title="{html.escape(label)}">{html.escape(q.title.replace("Ejemplos · ", "Ej. ") if q.section == "ejemplos" else q.title)} · {html.escape(label[:60])}{"…" if len(label) > 60 else ""}</a></li>')
            if not items:
                return m.group(0)
            return m.group(0)[:-len("</div>")] + f'<b>Ejemplos y parciales que lo preparan</b><ul class="chips">{"".join(items)}</ul></div>'
        p.body = re.sub(r'<div class="preparan"[^>]*></div>', fill, p.body)

    # enlaces internos
    for p in pages:
        p.body = p.body.replace('href="#inicio"', 'href="#top"')
        p.body = re.sub(r'href="#tema-([a-z-]+)"', r'href="../index.html#tema-\1"', p.body)

    # referencias del glosario
    for p in pages:
        for k in sorted(set(re.findall(r'data-ref="([^"]+)"', p.body)) - glossary.keys()):
            errors.append(f"{p.out}: referencia sin glosario: {k}")

    if OUT.exists() and not only:
        shutil.rmtree(OUT)
    (OUT / "assets").mkdir(parents=True, exist_ok=True)
    for f in ("sitio.css", "pp.js", "sitio.js"):
        shutil.copy(SRC / "assets" / f, OUT / "assets" / f)

    # páginas
    by_section = {}
    for p in pages:
        by_section.setdefault(p.section, []).append(p)
    sec_names = {"parciales": "Primeros parciales", "ejemplos": "Ejemplos", "guias": "Guías"}
    written = 0
    for sec, lst in by_section.items():
        present = [p for p in lst if p.body]
        for i, p in enumerate(present):
            if only and f"{p.section}/{p.pid}" not in only:
                continue
            prev = (present[i - 1].title, f"../{present[i - 1].out}") if i > 0 else None
            nxt = (present[i + 1].title, f"../{present[i + 1].out}") if i + 1 < len(present) else None
            bar = sitebar([("Visualizaciones", "../index.html"), (sec_names[sec], f"../index.html#{sec}"), (p.title.split(" · ", 1)[-1] if sec != "parciales" else p.title, None)], prev, nxt)
            toc_groups = []
            for g in p.groups:
                chips = "".join(f'<li><a href="#{a["id"]}" title="{html.escape(a["title"])}">{html.escape(a["short"])}</a></li>' for a in g["items"])
                head_link = f'<a href="#{g["id"]}">{html.escape(g["title"])}</a>' if g["id"] else f'<span class="src">Ejercicios</span>'
                if sec == "parciales":
                    head_link = '<span class="src">Ejercicios</span>'
                toc_groups.append(f'<div class="toc-group">{head_link}<ul class="chips">{chips}</ul></div>')
            n = len(p.articles)
            noun = {"parciales": "ejercicio", "ejemplos": "ejemplo", "guias": "ejercicio"}[sec]
            intro_txt = {
                "parciales": f"{p.meta}. Cada ejercicio, paso a paso: los dibujos se pueden mover y cada resultado subrayado con puntos muestra su enunciado al pasar el mouse, al enfocarlo o al tocarlo.",
                "ejemplos": f"{p.desc}. Los ejemplos de <code>apuntes-typst/ejemplos/{p.pid.replace('p4alt', 'p4_alternativos')}.typ</code>, con la resolución partida en pasos y un dibujo en cada paso que se puede dibujar. Cada resultado subrayado con puntos muestra su enunciado.",
                "guias": f"{p.desc}. Los enunciados de <code>apuntes-typst/guias/{p.pid}.typ</code>, con un dibujo para cada objeto que se puede dibujar y, debajo de cada ejercicio, los ejemplos y parciales que lo preparan.",
            }[sec]
            body = f"""<body data-base="../">
{bar}
<div class="page">
<header class="intro" id="top">
  <p class="eyebrow">{html.escape(p.eyebrow)} · {n} {noun}{"s" if n != 1 else ""}</p>
  <h1>{html.escape(p.title.split(" · ", 1)[1] if sec == "ejemplos" or sec == "guias" else p.title)}</h1>
  <p>{intro_txt}</p>
</header>
<nav class="toc" aria-labelledby="toc-h"><h2 id="toc-h">En esta página</h2>{"".join(toc_groups)}</nav>

{p.body}

<footer><p>Generado por <code>scripts/build_visualizaciones.py</code> desde <code>visualizaciones/fuentes/{p.section}/</code>. Los enunciados del glosario son los de <code>apuntes-typst/apuntes.typ</code> y de las guías.</p></footer>
</div>
<div id="popup" role="tooltip" hidden></div>
"""
            used = sorted(set(re.findall(r'data-ref="([^"]+)"', p.body)))
            gsub = {k: glossary[k] for k in used if k in glossary}
            gjson = json.dumps(gsub, ensure_ascii=False, indent=1).replace("</", "<\\/")
            tail = f'<script type="application/json" id="glosario">{gjson}</script>\n<script src="../assets/pp.js"></script>\n' + "\n".join(p.js) + '\n<script src="../assets/sitio.js"></script>\n</body>\n</html>\n'
            out = OUT / p.out
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_text(head(p.title, 1) + body + tail, encoding="utf-8")
            written += 1

    # visualizaciones sueltas
    (OUT / "otras").mkdir(exist_ok=True)
    for name, title, _ in OTRAS:
        src = VIS / f"{name}.html"
        if not src.exists():
            warnings.append(f"no existe visualizaciones/{name}.html")
            continue
        content = src.read_text(encoding="utf-8")
        back = ('<div style="position:sticky;top:0;z-index:40;font:13px \'IBM Plex Sans\',system-ui,sans-serif;'
                'padding:6px 16px;background:Canvas;color:CanvasText;border-bottom:1px solid rgba(128,128,128,.35)">'
                '<a href="../index.html#otras" style="color:inherit">← Visualizaciones</a></div>')
        (OUT / "otras" / f"{name}.html").write_text(
            '<!doctype html>\n<html lang="es">\n<head>\n<meta charset="utf-8">\n'
            '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
            '<style>:root { color-scheme: light dark; padding-top: env(safe-area-inset-top, 0px); padding-bottom: env(safe-area-inset-bottom, 0px); } '
            'body { margin: 0; font: 14px system-ui; } img { max-width: 100%; } [hidden] { display: none !important; }</style>\n'
            f'</head>\n<body>\n{back}\n{content}\n</body>\n</html>\n', encoding="utf-8")

    # portada
    def cards(lst, kind):
        out = []
        for p in lst:
            if not p.body:
                continue
            n = len(p.articles)
            noun = "ejemplos" if kind == "ejemplos" else "ejercicios"
            label = p.title.split(" · ", 1)[1] if kind != "parciales" else p.title
            sub = p.meta if kind == "parciales" else p.desc
            out.append(f'<li><a class="card-link" href="{p.out}">{html.escape(label)}</a><span class="meta">{n} {noun}</span><p>{html.escape(sub)}</p></li>')
        return "\n".join(out)

    topic_html = []
    for t, name in TOPICS.items():
        groups = []
        total = 0
        for sec in ("parciales", "ejemplos", "guias"):
            items = []
            for p in by_section.get(sec, []):
                for a in p.articles:
                    if t in a["topics"]:
                        lab = (p.title.replace("Primer parcial · ", "").replace("Recuperatorio · ", "Recu ") if sec == "parciales"
                               else p.title.split(" · ", 1)[1].replace("Práctica ", "P").replace(" · alternativos", " alt")) + " · " + a["short"]
                        items.append(f'<li><a href="{p.out}#{a["id"]}" title="{html.escape(a["title"])}">{html.escape(lab)}</a></li>')
            if items:
                total += len(items)
                groups.append(f'<div class="grp"><span>{sec_names[sec]}</span><ul class="chips">{"".join(items)}</ul></div>')
        if groups:
            topic_html.append(f'<details class="tema-det" id="tema-{t}"><summary>{html.escape(name)}<span class="cnt">{total}</span></summary>{"".join(groups)}</details>')

    otras_cards = "\n".join(
        f'<li><a class="card-link" href="otras/{n}.html">{html.escape(t)}</a><p>{html.escape(d)}</p></li>'
        for n, t, d in OTRAS if (VIS / f"{n}.html").exists())
    counts = {s: sum(len(p.articles) for p in by_section.get(s, [])) for s in sec_names}
    hub = f"""<title>Visualizaciones de Análisis Avanzado</title>
<meta name="claude:viewport-fit-sides" content="cover">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,600;1,8..60,400&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&display=swap">
<link rel="stylesheet" href="assets/sitio.css">
<!-- GENERADO por scripts/build_visualizaciones.py: no editar a mano. -->
<nav class="sitebar" aria-label="Navegación del sitio"><div class="in"><ol class="crumbs"><li><span aria-current="page">Visualizaciones</span></li></ol></div></nav>
<div class="page">
<header class="intro" id="top">
  <p class="eyebrow">Análisis Avanzado · FCEN-UBA</p>
  <h1>Visualizaciones</h1>
  <p>Todo el material del repositorio en páginas para recorrer: los primeros parciales resueltos, los ejemplos de cada práctica y las guías de ejercicios. En todas, los dibujos se pueden mover y cada definición, teorema o proposición subrayada con puntos muestra su enunciado al pasar el mouse o al tocarla.</p>
  <ul class="tabs" aria-label="Secciones">
    <li><a href="#parciales">Primeros parciales · {counts["parciales"]}</a></li>
    <li><a href="#ejemplos">Ejemplos · {counts["ejemplos"]}</a></li>
    <li><a href="#guias">Guías · {counts["guias"]}</a></li>
    <li><a href="#temas">Por tema</a></li>
    <li><a href="#otras">Otras visualizaciones</a></li>
  </ul>
</header>

<section class="hub-sec" id="parciales" aria-labelledby="h-par"><h2 id="h-par"><span class="bn">Sección</span>Primeros parciales</h2>
<p class="unlock">Cada examen en su página, con la resolución transcrita paso a paso: la de la cátedra en 2024 y la propuesta del repositorio, verificada en Lean, en 2025.</p>
<ul class="cards">
{cards(by_section.get("parciales", []), "parciales")}
</ul></section>

<section class="hub-sec" id="ejemplos" aria-labelledby="h-ej"><h2 id="h-ej"><span class="bn">Sección</span>Ejemplos de las prácticas</h2>
<p class="unlock">Los ejemplos resueltos de <code>apuntes-typst/ejemplos/</code> (del apunte, de clase y de otras universidades), ordenados por técnica como en el Typst, con un dibujo en cada paso que se puede dibujar.</p>
<ul class="cards">
{cards(by_section.get("ejemplos", []), "ejemplos")}
</ul></section>

<section class="hub-sec" id="guias" aria-labelledby="h-gu"><h2 id="h-gu"><span class="bn">Sección</span>Guías de ejercicios</h2>
<p class="unlock">Los enunciados de las nueve prácticas, con dibujos de los objetos que aparecen y, en cada ejercicio, los ejemplos y parciales que lo preparan.</p>
<ul class="cards">
{cards(by_section.get("guias", []), "guias")}
</ul></section>

<section class="hub-sec" id="temas" aria-labelledby="h-te"><h2 id="h-te"><span class="bn">Índice</span>Por tema</h2>
<p class="unlock">Abrí un tema para ver todos los ejercicios y ejemplos que lo trabajan, en las tres secciones.</p>
<div>
{"".join(topic_html)}
</div></section>

<section class="hub-sec" id="otras" aria-labelledby="h-ot"><h2 id="h-ot"><span class="bn">Sección</span>Otras visualizaciones</h2>
<p class="unlock">Páginas temáticas sueltas, hechas antes del sitio.</p>
<ul class="cards">
{otras_cards}
</ul></section>

<footer><p>Generado por <code>scripts/build_visualizaciones.py</code> desde <code>visualizaciones/fuentes/</code>. El Typst y los PDF siguen siendo la fuente: estas páginas los transcriben.</p></footer>
</div>
<script>
/* Abre el tema enlazado desde una página (index.html#tema-X). */
(() => {{ const open = () => {{ const t = document.getElementById(location.hash.slice(1)); if (t && t.tagName === "DETAILS") t.open = true; }}; open(); window.addEventListener("hashchange", open); }})();
</script>
"""
    (OUT / "index.html").write_text(hub, encoding="utf-8")

    used_all = set()
    for p in pages:
        used_all |= set(re.findall(r'data-ref="([^"]+)"', p.body))
    for w in warnings:
        print("aviso:", w)
    for e in errors:
        print("ERROR:", e)
    print(f"sitio: {written} páginas, {sum(len(p.articles) for p in pages)} fichas, {len(used_all)} claves de glosario usadas → {OUT.relative_to(ROOT)}")
    return 1 if errors else 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", action="append", help="sección/página, p. ej. guias/p4 (se puede repetir)")
    a = ap.parse_args()
    sys.exit(build(set(a.only or [])))
