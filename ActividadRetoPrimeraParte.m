num = [3];
den = [1 2 3];
G = tf(num, den, 'InputDelay', 0);

ts = 0.1;
t = (0:ts:50)';
N = length(t);

% Definimos tamaños de segmentos
size_short = floor(N * 0.1);   % 5 segundos
size_med = floor(N * 0.1);% 10 segundos
size_mid = floor(N * 0.2);
size_mod = floor(N * 0.2);
size_long = N - (4 * size_med + size_short);  % lo que queda (20 s)

% Construcción de segmentos
s1 = zeros(1, size_short);                  % 0 a 5 s
s2 = linspace(0, 5, size_med);              % 5 a 10 s (rampa)
s3 = ones(1, size_mid) * 5;                 % 10 a 20 s
s4 = ones(1, size_mod) * 10;                % 20 a 30 s
s5 = linspace(25, 15, size_long);           % 30 a 50 s (20 s)

% Señal completa
arbsig = [s1 s2 s3 s4 s5]';

% Asegurar que arbsig y t tengan misma longitud
if length(arbsig) < N
    arbsig(end+1:N) = arbsig(end);
elseif length(arbsig) > N
    arbsig = arbsig(1:N);
end

% Simulación
%lsim(G, arbsig, t)
%title('Respuesta del sistema con rampa desde 5s')
%xlabel('Tiempo [s]')
%ylabel('Salida')
%figure

subplot(2, 1, 1);
plot(t, arbsig, 'LineWidth', 2);
title('Señal aleatoria');
xlabel('Time (seconds)');
ylabel('Amplitud');
grid on;



subplot(2, 1, 2);
lsim(G, arbsig, t);  % Simulación de respuesta al sistema
%title('Linear simulation results');
%xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

