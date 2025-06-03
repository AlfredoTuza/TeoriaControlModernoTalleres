clc;
clear;
close all;

% Opción 1: resolver por numerador y denominador
num = [1 3];
den = [1 5 20 16 0];
G=tf(num,den);
% Polos y ceros
zs = roots(num);
ps = roots(den);

% Graficar los polos y ceros
figure
v = [-6 6 -6 6]; % Corrección aquí
axis(v); 
axis('square');
hold on; grid on;
plot(real(zs), imag(zs), 'bo', 'LineWidth', 2); % ceros: círculos azules
plot(real(ps), imag(ps), 'rx', 'LineWidth', 2); % polos: cruces rojas
title('Diagrama de Polos y Ceros');
xlabel('Parte Real');
ylabel('Parte Imaginaria');
legend('Ceros', 'Polos');
n = length(ps); %numero de polos
m = length(zs); %numero de ceros

%angulos de las asintotas
k = 0 : n - m - 1;
tetha = (pi()*(2*k + 1) / (n - m));
tethadeg = rad2deg(tetha);

%punto de origen de las asintotas 
sigma0 = (sum(real(ps)) - sum(real(zs))) / (n - m);
plot (sigma0,0,'gh');

%corte con el eje imaginario de las asintotas
x = 0;
y1 = sqrt (3) * (x - sigma0);
y2 = -y1; %puntos simetricos
%graficamos los puntos de corte con el eje jw
plot(0,y1,'kd')
plot(0,y2,'kd')

%graficamos las lineas de las asintotas
x = sigma0:0.1:6;
y1 = sqrt (3) * (x- sigma0);
y2 =-y1;
xa =-6:0.1:sigma0;
ya = zeros(1, length(xa));
plot (x, y1, 'k-.');
plot (x, y2, 'k-.');
plot (xa, ya, 'k-.');

%puntos de llegada de los polos
fK = -1/G;
[B, A]=tfdata(fK,'v');

%plot(real(psks), imag(psks), 'ks');
[B, A] = tfdata(G, 'v');
term1 = conv(B, polyder(A));
term2 = conv(A, polyder(B));
max_length = max(length(term1),length(term2));
term1 = [zeros(1,max_length-length(term1)), term1];
term2 = [zeros(1,max_length-length(term2)), term2];
adyacentes = term1 - term2;
psKs = roots(adyacentes);
psKs = psKs(imag(psKs)==0);
plot(real(psKs),imag(psKs),'ks');

%interseccion con el eje imaginario
jwint = roots([1 7 -1344]);
jwpol = [(84 - jwint(2))/5 0 3*jwint(2)];
jwints = roots(jwpol);
plot(real(jwints),imag(jwints),'ks');

%angulos de salida
pcc = ps(imag(ps)>0);
angzs = zeros(1,length(zs));
angps=zeros(1,length(ps)-1);
j=1;
for i=1:length(ps)
    psi=ps(i);
    x=real(pcc)-real(psi);
    y=imag(pcc)-imag(psi);
    if (x==0) && (y==0)
        continue;
    end
    rel=y/x;
    ang=rad2deg(atan(rel));
    if ang <0
        ang=ang+180;
    end
    angps(j)=ang;
    j=j+1;
end


j=1;
for i=1:length(zs)
    zsi=zs(i);
    x=real(pcc)-real(zsi);
    y=imag(pcc)-imag(zsi);
    if (x==0) && (y==0)
        continue;
    end
    rel=y/x;
    ang=rad2deg(atan(rel));
    if ang <0
        ang=ang+180;
    end
    angzs(j)=ang;
    j=j+1;
end

tetha = 180 - sum(angps) + sum(angzs);

%rlocus
r = rlocus(num,den);
plot(r, '-')
