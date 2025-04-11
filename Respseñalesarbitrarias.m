% Definir el tamaño del vector (puedes ajustar 'sizev' según lo que necesites)
sizev = 100;

% Crear las señales de la señal arbitraria
s1 = zeros(1, sizev);                       % Señal de 0 en el primer intervalo
s2 = ones(1, sizev) * 5;               % Señal de 5 en el segundo intervalo
s3 = linspace(15,25, sizev) * 1;              % Señal de 10 en el tercer intervalo
s4 = ones(1, sizev)* 25;
% Definir el vector de tiempo
t = linspace(0, 50, sizev * 4);        % Tres intervalos de 10 para cubrir 0-30

% Crear la señal arbitraria combinando los tres segmentos
arbsig = [s1 s2 s3 s4]';  % Concatenamos los segmentos para formar la señal

% Graficar la señal arbitraria
figure;
subplot(2, 1, 1);
plot(t, arbsig, 'LineWidth', 2);
title('Señal aleatoria');
xlabel('Tiempo');
ylabel('Amplitud');
grid on;
%text(20, -5, '(a) Señal arbitraria', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 12);  % Título en la parte inferior

% Definir la función de transferencia del sistema (segundo orden con retardo)
num = [3];  % Numerador
den = [1 2 3];  % Denominador
G = tf(num, den, 'InputDelay', 2);  % Crear la función de transferencia con retardo de 2 segundos

% Simulación de la respuesta del sistema a la señal arbitraria
subplot(2, 1, 2);
lsim(G, arbsig, t);  % Respuesta del sistema a la señal arbitraria
xlabel('Tiempo');
ylabel('Amplitud');
grid on;
%text(20, -6.5, '(b) Respuesta del sistema a la señal arbitraria', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 12);  % Título en la parte inferior
