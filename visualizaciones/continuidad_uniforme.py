# /// script
# requires-python = ">=3.11"
# dependencies = ["matplotlib", "numpy"]
# ///
"""Continuidad vs. continuidad uniforme, de forma interactiva.

Correr con:  uv run visualizaciones/continuidad_uniforme.py

Arriba: el gráfico de f y una "caja" de ancho 2δ y alto 2ε centrada en (x0, f(x0)).
La caja es VERDE si el gráfico de f sobre (x0 - δ, x0 + δ) no se sale por arriba ni
por abajo (es decir, f(B(x0, δ)) ⊆ B(f(x0), ε)), y ROJA si se sale.

Abajo: para cada x0, el δ más grande que sirve en ese punto, δ_max(x0).
- f continua      <=> δ_max(x0) > 0 para todo x0.
- f unif. continua <=> inf δ_max(x0) > 0: hay UN δ que sirve para todos los x0.

Para x² el δ que sirve es δ_max(x0) = √(x0² + ε) - |x0| = ε / (√(x0² + ε) + |x0|),
que es positivo en cada punto pero tiende a 0 cuando |x0| -> ∞: la pendiente crece,
así que hay que achicar la caja cada vez más. Por eso no hay un δ común.
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import RadioButtons, Slider

FUNCIONES = {
    "x²": (lambda x: x**2, (-6.0, 6.0)),
    "sen(x)": (np.sin, (-6.0, 6.0)),
    "√x en [0, ∞)": (np.sqrt, (0.0, 12.0)),
    "1/x en (0, ∞)": (lambda x: 1 / x, (0.05, 6.0)),
}

# Grilla fina para estimar el sup/inf de f en un intervalo.
N_MUESTRAS = 400


def oscilacion(f, x0, delta, dominio):
    """max |f(x) - f(x0)| para x en (x0 - δ, x0 + δ) ∩ dominio."""
    a, b = dominio
    izq = max(x0 - delta, a)
    der = min(x0 + delta, b) if np.isfinite(b) else x0 + delta
    xs = np.linspace(izq, der, N_MUESTRAS)
    return np.max(np.abs(f(xs) - f(x0)))


def delta_max(f, x0, eps, dominio, techo=10.0):
    """El δ más grande con f(B(x0, δ)) ⊆ B(f(x0), ε), por bisección."""
    if oscilacion(f, x0, techo, dominio) < eps:
        return techo
    lo, hi = 0.0, techo
    for _ in range(40):
        mid = (lo + hi) / 2
        if oscilacion(f, x0, mid, dominio) < eps:
            lo = mid
        else:
            hi = mid
    return lo


def dominio_real(nombre):
    # El dominio matemático (para no evaluar fuera de él), no la ventana del gráfico.
    return {"√x en [0, ∞)": (0.0, np.inf), "1/x en (0, ∞)": (1e-9, np.inf)}.get(
        nombre, (-np.inf, np.inf)
    )


fig = plt.figure(figsize=(11, 8))
ax_f = fig.add_axes([0.08, 0.50, 0.62, 0.45])
ax_d = fig.add_axes([0.08, 0.27, 0.62, 0.17])
ax_radio = fig.add_axes([0.76, 0.62, 0.21, 0.30])
ax_eps = fig.add_axes([0.12, 0.15, 0.55, 0.03])
ax_del = fig.add_axes([0.12, 0.10, 0.55, 0.03])
ax_x0 = fig.add_axes([0.12, 0.05, 0.55, 0.03])
ax_txt = fig.add_axes([0.74, 0.05, 0.25, 0.52])
ax_txt.axis("off")

radio = RadioButtons(ax_radio, list(FUNCIONES))
ax_radio.set_title("Función")
s_eps = Slider(ax_eps, "ε", 0.05, 2.0, valinit=0.5)
s_del = Slider(ax_del, "δ (fijo)", 0.01, 1.0, valinit=0.3)
s_x0 = Slider(ax_x0, "x0", -6.0, 6.0, valinit=0.5)

estado = {"nombre": "x²"}


def redibujar(_=None):
    nombre = estado["nombre"]
    f, (a, b) = FUNCIONES[nombre]
    dom = dominio_real(nombre)
    eps, delta = s_eps.val, s_del.val
    x0 = float(np.clip(s_x0.val, a, b))

    # --- gráfico de f con la caja ε-δ ---
    ax_f.clear()
    xs = np.linspace(a, b, 1500)
    ax_f.plot(xs, f(xs), color="black", lw=1.8)
    y0 = f(x0)
    falla = oscilacion(f, x0, delta, dom) >= eps
    color = "#dc2626" if falla else "#16a34a"
    izq = max(x0 - delta, dom[0])
    ax_f.add_patch(
        plt.Rectangle((izq, y0 - eps), x0 + delta - izq, 2 * eps, color=color, alpha=0.25)
    )
    ax_f.axhspan(y0 - eps, y0 + eps, color="#4f46e5", alpha=0.07)
    xs_caja = np.linspace(izq, x0 + delta, 300)
    ax_f.plot(xs_caja, f(xs_caja), color=color, lw=3)
    ax_f.plot([x0], [y0], "o", color="black")
    ys = f(xs)
    ax_f.set_xlim(a, b)
    ax_f.set_ylim(min(ys.min(), y0 - eps) - 0.5, max(ys.max(), y0 + eps) + 0.5)
    ax_f.set_title(
        f"f(x) = {nombre}  —  con δ = {delta:.2f} la caja "
        + ("SE ROMPE en este x0" if falla else "funciona en este x0"),
        color=color,
    )
    ax_f.grid(alpha=0.3)

    # --- δ_max(x0) para todos los x0 ---
    ax_d.clear()
    x0s = np.linspace(a, b, 250)
    dmax = np.array([delta_max(f, p, eps, dom) for p in x0s])
    ax_d.plot(x0s, dmax, color="#4f46e5", lw=2, label="δ_max(x0)")
    ax_d.axhline(delta, color="black", ls="--", lw=1, label="δ elegido")
    ax_d.fill_between(x0s, 0, 1, where=dmax < delta, color="#dc2626", alpha=0.15,
                      transform=ax_d.get_xaxis_transform(), label="ahí δ no alcanza")
    ax_d.axvline(x0, color="black", lw=0.8)
    ax_d.set_xlim(a, b)
    ax_d.set_ylim(0, min(max(dmax.max(), delta) * 1.15, 10))
    ax_d.set_xlabel("x0")
    ax_d.legend(loc="upper right", fontsize=8)
    ax_d.grid(alpha=0.3)

    # --- texto ---
    ax_txt.clear()
    ax_txt.axis("off")
    d_aca = delta_max(f, x0, eps, dom)
    ax_txt.text(
        0, 1,
        f"En x0 = {x0:.2f}:\n"
        f"  δ_max(x0) = {d_aca:.4f}\n\n"
        f"Mínimo de δ_max en la ventana:\n"
        f"  {dmax.min():.4f}\n\n"
        "Continua: δ_max(x0) > 0\n"
        "en cada punto.\n\n"
        "Uniformemente continua:\n"
        "inf δ_max(x0) > 0 en TODO\n"
        "el dominio (no sólo en la\n"
        "ventana): un mismo δ sirve\n"
        "para todos los x0.\n\n"
        "Probá: con x² fijá ε y δ,\n"
        "y mové x0 hacia los costados.",
        va="top", family="monospace", fontsize=9,
    )
    fig.canvas.draw_idle()


def cambiar_funcion(nombre):
    estado["nombre"] = nombre
    _, (a, b) = FUNCIONES[nombre]
    s_x0.valmin, s_x0.valmax = a, b
    ax_x0.set_xlim(a, b)
    s_x0.set_val(float(np.clip(s_x0.val, a, b)))
    redibujar()


radio.on_clicked(cambiar_funcion)
for s in (s_eps, s_del, s_x0):
    s.on_changed(redibujar)

redibujar()

if __name__ == "__main__":
    plt.show()
