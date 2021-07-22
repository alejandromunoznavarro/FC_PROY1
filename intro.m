% Reseteamos
clear;
clc;

%Cargamos imagenes contenidas en ./retratos
lee_jpgs;

%Guardamos el número de imagenes
NUM = L;

%Guardamos el tamaño de las imagenes
ALTO_IMG = N;
ANCHO_IMG = M;

%creamos el mosaico
ALTO_MOSAICO = 2880;
ANCHO_MOSAICO = 4800;
mosaico=uint8(zeros(ALTO_MOSAICO,ANCHO_MOSAICO));

%rellenamos con las imagenes
n=1;
ry=(1:ALTO_IMG);
for k=1:(ALTO_MOSAICO/ALTO_IMG)
    rx=(1:ANCHO_IMG);
    for j=1:(ANCHO_MOSAICO/ANCHO_IMG)
        mosaico(ry,rx)=imags(:,:,n);
        rx=rx+ANCHO_IMG;
        n=n+1;
    end
    ry=ry+ALTO_IMG;
end

% mostramos el resultado
%imshow(mosaico);

%borramos el contenido del mosaico
mosaico(:,:)=0;

%Insertamos imagenes aleatorias

for n=1:L
    yo=floor(rand(1)*(ALTO_MOSAICO-ALTO_IMG));
    xo=floor(rand(1)*(ANCHO_MOSAICO-ANCHO_IMG));
    ry=yo+(1:ALTO_IMG);
    rx=xo+(1:ANCHO_IMG);
    mosaico(ry,rx)=imags(:,:,n);
end

% mostramos el resultado
imshow(mosaico);