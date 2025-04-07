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
DeltaU = 1.5;  % señal de entrada es de 0 a 1.5
DeltaY = Linehundred - Linebase;  % Cambio en la salida

% 📌 Ganancia del sistema K
K = DeltaY / DeltaU;

% 📌 Calcular el tiempo de 63.21% de la respuesta del sistema
% Encontramos el tiempo en que la respuesta alcanza el 63.21% de su valor final
y63 = Linebase + 0.6321 * DeltaY;  % Valor de la salida al 63.21%
p63 = find(y >= y63, 1);  % Índice donde la respuesta alcanza el 63.21%
t63 = t(p63);  % Tiempo correspondiente al 63.21%

% 📌 Calcular el parámetro Tau (constante de tiempo)
tau = t63 - t(1);  % El tiempo desde el inicio hasta el 63.21%

% 📌 Crear el modelo de primer orden con retardo
G_miller = tf([K], [tau 1], 'InputDelay', 0);  % Modelo de primer orden

% 📌 Simular la respuesta del modelo obtenido
[y_model, t_model] = step(G_miller, t);  % Respuesta del sistema modelo

% 📌 Graficar datos experimentales vs modelo
figure;
plot(t, y, 'b', 'LineWidth', 1.5); hold on; % Respuesta real
plot(t_model, y_model, 'r--', 'LineWidth', 1.5); % Modelo de primer orden
plot(t63, y63, 'ro', 'MarkerSize', 8, 'LineWidth', 2); % Punto del 63.21%

% 📌 Graficar líneas base y línea 100%
plot([t(1), t(end)], [Linebase, Linebase], 'k--', 'LineWidth', 1.2); % Línea base
plot([t(1), t(end)], [Linehundred, Linehundred], 'm--', 'LineWidth', 1.2); % Línea 100%

% 📌 Mostrar líneas guía para el 63.21%
plot([t63, t63], [Linebase, y63], 'g--', 'LineWidth', 1.2);

% 📌 Configuración del gráfico
xlabel("Tiempo (s)", 'FontSize', 12);
ylabel("Amplitud", 'FontSize', 12);
title("Método de Miller", 'FontSize', 14);
legend("Respuesta del Sistema", "Modelo Ajustado", "Punto 63.21%", ...
       "Línea Base", "Línea 100%", "63.21%", 'Location', 'Best');
grid on;

% 📌 Mostrar resultados en la consola
fprintf('Tau estimado: %.4f s\n', tau);
fprintf('Ganancia K estimada: %.4f\n', K);
