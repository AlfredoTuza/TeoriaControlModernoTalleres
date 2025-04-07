clc; clear; close all;

% 📌 Cargar datos desde el archivo CSV
data = readtable("data_motor.csv");

% 📌 Ajustar nombres de columnas según el CSV
t = data.time_t_;  % Tiempo
u = data.ex_signal_u_; % Señal de entrada
y = data.system_response_y_; % Respuesta del sistema

% 📌 Calcular líneas base y valores de escalado
Linebase = min(y);  % Línea base (valor mínimo de la salida)
Linehundred = mean(y(end-10:end));  % Promedio de los últimos valores para aproximar el 100%
DeltaU = 1.5;  %la señal de entrada es de 0 a 1.5
DeltaY = Linehundred - Linebase;  % Cambio en la salida

% 📌 Determinar la ganancia del sistema (K = cambio en salida / cambio en entrada)
K = DeltaY / DeltaU;

% 📌 Encontrar el punto de inflexión (máxima pendiente)
dy = diff(y) ./ diff(t); % Derivada numérica
[~, p_inf] = max(dy); % Índice del punto de inflexión
t_inf = t(p_inf); % Tiempo en el punto de inflexión
m_inf = dy(p_inf); % Pendiente en el punto de inflexión

% 📌 Calcular Theta (intersección de la tangente con el eje de tiempo)
theta = t_inf - (y(p_inf) / m_inf);

% 📌 Calcular Tau (cuando la tangente alcanza el 100% de la respuesta)
tau = (Linehundred - y(p_inf)) / m_inf;

% 📌 Crear modelo de primer orden con retardo
G = tf([K], [tau 1], 'InputDelay', theta);

% 📌 Simular la respuesta del modelo obtenido
[y_model, t_model] = step(G, t);

% 📌 Graficar datos experimentales vs modelo
figure;
plot(t, y, 'b', 'LineWidth', 1.5); hold on; % Respuesta real
plot(t_model, y_model, 'r--', 'LineWidth', 1.5); % Modelo de primer orden
plot(t_inf, y(p_inf), 'ro', 'MarkerSize', 8, 'LineWidth', 2); % Punto de inflexión

% 📌 Graficar tangente en el punto de inflexión
t_tan = linspace(theta, t_inf + 5, 100); % Rango de la tangente
y_tan = m_inf * (t_tan - t_inf) + y(p_inf);
plot(t_tan, y_tan, 'g--', 'LineWidth', 1.5); % Línea tangente

% 📌 Graficar líneas base y línea 100%
plot([t(1), t(end)], [Linebase, Linebase], 'k--', 'LineWidth', 1.2); % Línea base
plot([t(1), t(end)], [Linehundred, Linehundred], 'm--', 'LineWidth', 1.2); % Línea 100%

% 📌 Mostrar líneas guía para theta y tau
plot([theta, theta], [0, 0.1], 'k--', 'LineWidth', 1.2);
plot([theta + tau, theta + tau], [0, 1], 'g--', 'LineWidth', 1.2);

% 📌 Configuración del gráfico
xlabel("Tiempo (s)", 'FontSize', 12);
ylabel("Amplitud", 'FontSize', 12);
title("Método de Ziegler & Nichols", 'FontSize', 14);
legend("Respuesta del Sistema", "Modelo Ajustado", "Punto de Inflexión", ...
       "Tangente", "Línea Base", "Línea 100%", "\theta", "\tau", 'Location', 'Best');
grid on;

% 📌 Mostrar resultados en la consola
fprintf('Theta estimado: %.4f s\n', theta);
fprintf('Tau estimado: %.4f s\n', tau);
fprintf('Ganancia K estimada: %.4f\n', K);
