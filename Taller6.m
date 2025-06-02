clc; clear; close all;

s = tf('s');

% Planta
G = 4.5455e4 / (s^2 + 50*s + 4.5455e4);

% PID Controller parameters
Kp = 10;
Ki = 1000;
Kd = 0.01;

% PID controller with filter dynamics
C = ((Kp + 1e6*Kd)*s^2 + (1e6*Kp + Ki)*s + 1e6*Ki) / (s^2 + 1e6*s);

% Closed-loop system
CL = feedback(C*G, 1);

% Routh-Hurwitz: get denominator coefficients
[~, den] = tfdata(CL, 'v');
disp('Polos del sistema (roots del denominador):');
disp(roots(den));

% Step input of 5V at t = 10 ms
t = 0:1e-4:0.1;  % Time from 0 to 100 ms
u = zeros(size(t));
u(t >= 0.01) = 5;

% Plotting
figure;
subplot(1,2,1);
pzmap(CL);
title('Mapa de Polos y Ceros');

subplot(1,2,2);
lsim(CL, u, t);
title('Respuesta a escalón de 5V en t = 10 ms');
xlabel('Tiempo (s)');
ylabel('Voltaje de salida');
