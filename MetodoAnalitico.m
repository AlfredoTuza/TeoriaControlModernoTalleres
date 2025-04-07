clc;
clear;
close all;

% 📌 Cargar datos desde el archivo CSV
data = readtable("data_motor.csv");

% 📌 Ajustar nombres de columnas según el CSV
t = data.time_t_;  % Tiempo
u = data.ex_signal_u_; % Señal de entrada
y = data.system_response_y_; % Respuesta del sistema

% 📌 Calcular líneas base y valores de escalado
Linebase = min(y);  % Línea base (mínimo de la respuesta)
Linehundred = mean(y(end-10:end));  % Línea del 100% (promedio de los últimos 10 puntos)
DeltaU = 1.5;  % la señal de entrada (0 a 1.5)
DeltaY = Linehundred - Linebase;  % Cambio en la salida

% 📌 Definir los dos puntos clave: 28.4% y 63.2% de la respuesta final
y28 = Linebase + 0.284 * DeltaY;  % 28.4% de la respuesta
y63 = Linebase + 0.632 * DeltaY;  % 63.2% de la respuesta

% 📌 Encontrar los tiempos correspondientes a esos puntos
p28 = find(y >= y28, 1);  % Índice donde la respuesta alcanza el 28.4%
p63 = find(y >= y63, 1);  % Índice donde la respuesta alcanza el 63.2%

t28 = t(p28);  % Tiempo en el 28.4%
t63 = t(p63);  % Tiempo en el 63.2%

% 📌 Calcular los parámetros Tau y Theta
tau = t63 - t28;  % La constante de tiempo (diferencia entre los dos tiempos)
theta = t28 - (y(p28) / (y(p63) - y(p28))) * (t63 - t28);  % Estimación del retardo

% 📌 Crear el modelo de primer orden con retardo
K = DeltaY / DeltaU;  % Ganancia del sistema
G_analitico = tf([K], [tau 1], 'InputDelay', theta);  % Función de transferencia con retardo

% 📌 Simular la respuesta del modelo obtenido
[y_model, t_model] = step(G_analitico, t);  % Respuesta del sistema modelo

% 📌 Graficar datos experimentales vs modelo
figure;
plot(t, y, 'b', 'LineWidth', 1.5); hold on; % Respuesta real
plot(t_model, y_model, 'r--', 'LineWidth', 1.5); % Modelo de primer orden ajustado
plot(t28, y28, 'ro', 'MarkerSize', 8, 'LineWidth', 2); % Punto del 28.4%
plot(t63, y63, 'go', 'MarkerSize', 8, 'LineWidth', 2); % Punto del 63.2%

% 📌 Graficar líneas base y línea 100%
plot([t(1), t(end)], [Linebase, Linebase], 'k--', 'LineWidth', 1.2); % Línea base
plot([t(1), t(end)], [Linehundred, Linehundred], 'm--', 'LineWidth', 1.2); % Línea 100%

% 📌 Mostrar líneas guía para los puntos 28.4% y 63.2%
plot([t28, t28], [Linebase, y28], 'g--', 'LineWidth', 1.2);  % Línea para el 28.4%
plot([t63, t63], [Linebase, y63], 'c--', 'LineWidth', 1.2);  % Línea para el 63.2%

% 📌 Configuración del gráfico
xlabel("Tiempo (s)", 'FontSize', 12);
ylabel("Amplitud", 'FontSize', 12);
title("Método Analítico", 'FontSize', 14);
legend("Respuesta del Sistema", "Modelo Ajustado", "Punto 28.4%", "Punto 63.2%", ...
       "Línea Base", "Línea 100%", "Punto 28.4%", "Punto 63.2%", 'Location', 'Best');
grid on;

% 📌 Mostrar resultados en la consola
fprintf('Theta estimado: %.4f s\n', theta);
fprintf('Tau estimado: %.4f s\n', tau);
fprintf('Ganancia K estimada: %.4f\n', K);
