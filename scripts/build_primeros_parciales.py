#!/usr/bin/env python3
"""Arma visualizaciones/primeros_parciales.html a partir de los fragmentos por examen.

Fuentes (en visualizaciones/primeros_parciales/):
  _shell.html          plantilla con estilos, librería de dibujo (PP) y popups del glosario
  {examen}.html        <section class="exam"> con sus <article class="ej">
  {examen}.json        glosario: {clave: {tipo, numero, titulo, enunciado, fuente}}
  {examen}.js          dibujos del examen (opcional), usando window.PP

Uso:
  python3 scripts/build_primeros_parciales.py                  # todos los exámenes
  python3 scripts/build_primeros_parciales.py --only p1-2c2025 --out /tmp/x.html

Valida: ids únicos, que toda referencia data-ref tenga entrada en el glosario,
que los temas estén en la lista y que cada ejercicio tenga título y tema.
"""
import argparse
import html
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "visualizaciones" / "primeros_parciales"
OUT = ROOT / "visualizaciones" / "primeros_parciales.html"

# Orden cronológico. (id, título corto)
EXAMS = [
    ("p1-1c2024", "Primer parcial · 1C 2024"),
    ("p1-2c2024", "Primer parcial · 2C 2024"),
    ("p1-1c2025", "Primer parcial · 1C 2025"),
    ("r1-1c2025", "Recuperatorio · 1C 2025"),
    ("p1-2c2025", "Primer parcial · 2C 2025"),
    ("r1-2c2025", "Recuperatorio · 2C 2025"),
]

TOPICS = {
    "supremo": "Supremo, ínfimo, máximo y mínimo",
    "cardinalidad": "Cardinalidad",
    "sucesiones": "Sucesiones y límites",
    "metricas": "Métricas: verificar, comparar, bolas",
    "topologia": "Abiertos, cerrados, interior y clausura",
    "densidad": "Densidad",
    "completitud": "Sucesiones de Cauchy y completitud",
    "continuidad": "Continuidad, continuidad uniforme y Lipschitz",
    "funciones": "Espacios de funciones C([a, b])",
    "compacidad": "Compacidad",
}

ART_RE = re.compile(r'<article\s+class="ej"[^>]*>', re.S)
ATTR_RE = re.compile(r'([a-z-]+)="([^"]*)"')
SEC_RE = re.compile(r'<section\s+class="exam"[^>]*>', re.S)


def attrs(tag):
    return dict(ATTR_RE.findall(tag))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", action="append", help="id de examen (se puede repetir)")
    ap.add_argument("--out", default=str(OUT))
    a = ap.parse_args()

    exams = [e for e in EXAMS if not a.only or e[0] in a.only]
    shell = (SRC / "_shell.html").read_text(encoding="utf-8")
    errors, warnings = [], []
    glossary, bodies, scripts, nav, by_topic = {}, [], [], [], {t: [] for t in TOPICS}
    all_ids, n_ejs = {}, 0

    for eid, short in exams:
        f_html, f_json, f_js = SRC / f"{eid}.html", SRC / f"{eid}.json", SRC / f"{eid}.js"
        if not f_html.exists():
            errors.append(f"falta {f_html.relative_to(ROOT)}")
            continue
        body = f_html.read_text(encoding="utf-8")
        sec = SEC_RE.search(body)
        if not sec or attrs(sec.group(0)).get("id") != eid:
            errors.append(f"{eid}: el fragmento debe abrir con <section class=\"exam\" id=\"{eid}\" ...>")
        sec_a = attrs(sec.group(0)) if sec else {}
        if f_json.exists():
            g = json.loads(f_json.read_text(encoding="utf-8"))
            for k, v in g.items():
                if k not in glossary:
                    glossary[k] = v
                elif glossary[k].get("titulo") != v.get("titulo"):
                    warnings.append(f"glosario: {k} con títulos distintos ({glossary[k].get('titulo')!r} vs {v.get('titulo')!r}); se queda el primero")
        for m in re.finditer(r'\bid="([^"]+)"', body):
            i = m.group(1)
            if i in all_ids:
                errors.append(f"id repetido: {i} ({all_ids[i]} y {eid})")
            all_ids[i] = eid
            if not i.startswith(eid):
                errors.append(f"{eid}: el id {i!r} no empieza con el id del examen")
        chips = []
        for m in ART_RE.finditer(body):
            at = attrs(m.group(0))
            aid, title, short_t = at.get("id"), at.get("data-title"), at.get("data-short")
            topics = [t.strip() for t in at.get("data-topics", "").split(",") if t.strip()]
            if not aid or not title or not short_t:
                errors.append(f"{eid}: <article class=\"ej\"> sin id, data-title o data-short")
                continue
            if not topics:
                errors.append(f"{aid}: sin data-topics")
            for t in topics:
                if t not in TOPICS:
                    errors.append(f"{aid}: tema desconocido {t!r}")
                else:
                    by_topic[t].append((aid, short, short_t, title))
            chips.append(f'<li><a href="#{aid}">{html.escape(short_t)}</a></li>')
            n_ejs += 1
        nav.append(
            f'    <li><a class="ex-link" href="#{eid}">{html.escape(short)}</a>'
            f'<span class="meta">{html.escape(sec_a.get("data-meta", ""))}</span>'
            f'<ul class="chips">{"".join(chips)}</ul></li>'
        )
        bodies.append(body.strip())
        if f_js.exists():
            scripts.append(f"<script>\n/* {eid} */\n(() => {{\n\"use strict\";\n{f_js.read_text(encoding='utf-8').strip()}\n}})();\n</script>")

    # referencias
    used = set()
    for body in bodies:
        used |= set(re.findall(r'data-ref="([^"]+)"', body))
    for k in sorted(used - glossary.keys()):
        errors.append(f"referencia sin glosario: {k}")
    for k in sorted(glossary.keys() - used):
        warnings.append(f"glosario sin uso: {k}")

    topics_html = []
    for t, name in TOPICS.items():
        items = by_topic[t]
        if not items:
            continue
        links = "".join(
            f'<li><a href="#{aid}" title="{html.escape(title)}">{html.escape(exam_short.split(" · ")[1])} · {html.escape(ej_short)}</a></li>'
            for aid, exam_short, ej_short, title in items
        )
        topics_html.append(
            f'    <section class="tema" id="tema-{t}"><h3>{html.escape(name)}<span class="cnt">{len(items)} ejercicio{"s" if len(items) != 1 else ""}</span></h3>'
            f'<ul class="chips">{links}</ul></section>'
        )

    gjson = json.dumps(glossary, ensure_ascii=False, indent=1).replace("</", "<\\/")
    page = (shell.replace("{{NAV}}", "\n".join(nav))
            .replace("{{TOPICS}}", "\n".join(topics_html))
            .replace("{{EXAMS}}", "\n\n".join(bodies))
            .replace("{{GLOSSARY}}", gjson)
            .replace("{{SCRIPTS}}", "\n".join(scripts))
            .replace("{{N_EXAMS}}", str(len(exams)))
            .replace("{{N_EJS}}", str(n_ejs)))

    for w in warnings:
        print("aviso:", w)
    for e in errors:
        print("ERROR:", e)
    Path(a.out).write_text(page, encoding="utf-8")
    print(f"escrito {a.out}: {len(exams)} exámenes, {n_ejs} ejercicios, {len(glossary)} entradas de glosario, {len(page) // 1024} KB")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
