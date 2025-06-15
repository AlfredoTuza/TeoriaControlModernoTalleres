clc;
clear;
close all;

%% Parámetros del circuito RLC
R = 22;
L = 500e-6;
C = 220e-6;

% Coeficientes del denominador
a1 = R / L;
a0 = 1 / (L * C);

%% Sistema original sin ganancia
num = [9.09e6];
den = [1 a1 a0];
G = tf(num, den);

% Paso 1: Respuesta al escalón del sistema original
figure;
step(G);
title('Respuesta al escalón del sistema original');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

% Paso 2: LGR del sistema original
figure;
rlocus(G);
title('Lugar Geométrico de las Raíces (LGR) del sistema original');
grid on;

% Paso 3: LGR con polo deseado marcado
s_deseado = -80 + 1j*181.29;
figure;
rlocus(G);
hold on;
plot(real(s_deseado), imag(s_deseado), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('LGR del sistema original con polo deseado marcado');
grid on;

%% Compensador adelanto
z_c = -20;         % Cero del compensador
p_c = -528.63;     % Polo del compensador
C = tf([1 -z_c], [1 -p_c]);  % Recuerda que es (s - z)/(s - p)

%% Sistema compensado en lazo abierto
G_open = series(C, G);

%% Cálculo de la ganancia Kc
mag = abs(evalfr(G_open, s_deseado));
Kc = 1 / mag;
fprintf('Paso 4: La ganancia Kc calculada es: %.4f\n', Kc);

%% Lazo cerrado con compensador
G_compensado = series(Kc, G_open);
CL = feedback(G_compensado, 1);

% Paso 4: Respuesta al escalón del sistema compensado
figure;
step(CL);
title('Respuesta al escalón del sistema compensado');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

% Paso 5: LGR del sistema compensado con polo deseado
figure;
rlocus(G_compensado);
hold on;
plot(real(s_deseado), imag(s_deseado), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('LGR del sistema con compensador en adelanto');
grid on;

% Paso 6: Comparación entre sistema original y compensado
CL_original = feedback(G, 1);
figure;
step(CL_original, 'b', CL, 'r');
legend('Sistema original', 'Sistema compensado');
title('Comparación de respuestas al escalón');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
info = stepinfo(CL);
disp(['Sobreimpulso (Mp): ', num2str(info.Overshoot), '%']);
disp(['Tiempo de establecimiento (tss): ', num2str(info.SettlingTime), ' s']);
% Simulación hasta 0.1 segundos (100 ms) para ver bien Mp y tss
t = 0:1e-4:0.1;
[y, t_out] = step(CL, t);
plot(t_out, y);
title('Respuesta al escalón unitario del sistema compensado');
xlabel('Tiempo (s)');
ylabel('Salida');
grid on;

% Obtener características de la respuesta
info = stepinfo(CL);
disp(info)
