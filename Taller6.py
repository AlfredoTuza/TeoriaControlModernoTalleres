# -*- coding: utf-8 -*-
"""Untitled6.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1zjeEkNxnC2dpa1ZX2nVeU6CfFSI68jbJ
"""

import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

# --- 1. Planta: sistema RLC ---
num_G = [4.5455e4]
den_G = [1, 50, 4.5455e4]
G = ctrl.tf(num_G, den_G)

# --- 2. Controlador PID con filtro derivativo ---
Kp = 10
Ki = 1000
Kd = 0.01
N = 1e6  # Filtro derivativo alto

num_C = [Kp + N * Kd, N * Kp + Ki, N * Ki]
den_C = [1, N, 0]
C = ctrl.tf(num_C, den_C)

# --- 3. Sistema en lazo cerrado ---
L = ctrl.series(C, G)
CL = ctrl.feedback(L, 1)

# --- 4. Polos del sistema en lazo cerrado ---
poles_CL = np.roots(CL.den[0][0])
print("Polos del sistema en lazo cerrado:")
print(poles_CL)

# --- 5. Escalón de 5V activado en 10 ms ---
t = np.linspace(0, 0.1, 1000)  # 0 a 100 ms
u = np.zeros_like(t)
u[t >= 0.01] = 5  # Escalón a los 10 ms

# --- 6. Simulación de la respuesta ---
t_out, y_out = ctrl.forced_response(CL, T=t, U=u)

# --- 7. Gráfica de la respuesta ---
plt.figure(figsize=(10, 5))
plt.plot(t_out, y_out, label='Salida del sistema')
plt.plot(t, u, 'k--', label='Entrada escalón de 5V')
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.title('Respuesta al escalón de 5V (desde t = 10 ms)')
plt.grid(True)
plt.legend()
plt.tight_layout()

# --- 8. Mapa de polos y ceros ---
plt.figure(figsize=(6, 6))
ctrl.pzmap(CL, grid=True)
plt.title("Mapa de Polos y Ceros")
plt.tight_layout()

plt.show()

pip install --upgrade control

pip install control matplotlib numpy