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

%Cargamos imagen target
target = rgb2gray(imread('target3.jpg'));

%creamos el mosaico
ALTO_MOSAICO = size(target,1);
ANCHO_MOSAICO = size(target,2);
mosaico=uint8(zeros(ALTO_MOSAICO,ANCHO_MOSAICO));

%Reducimos imagenes
F=4;
reds=imresize(imags,1/F);

%rellenamos con las imagenes
veces = zeros(1,NUM);
ry=(1:ALTO_IMG);
for k=1:(ALTO_MOSAICO/ALTO_IMG)
    rx=(1:ANCHO_IMG);
    for j=1:(ANCHO_MOSAICO/ANCHO_IMG)
        
        %Extraemos sub-imagen objetivo
        sub_img = imresize(target(ry,rx),1/F);
        
        %Comparamos con las otras imágenes
        MIN = -1;
        INDICE = -1;
        
        for i=1:NUM
           
            %diferencia reducidas
            dif = double(reds(:,:,i))- double(sub_img(:,:)); 
            
            %abs
            absoluto = abs(dif);
            
            %mean2
            media = mean2(absoluto);
            
            %Calculamos factor
            factor = 1 + ((4*veces(i))/(max(veces)+1));
            media = media*factor;
            
            if INDICE < 0 || MIN > media
                INDICE = i;
                MIN = media;
            end
        end
        
        %introducimos la imagen
        mosaico(ry,rx)=imags(:,:,INDICE);
        veces(INDICE) = veces(INDICE)+1;
        rx=rx+ANCHO_IMG;
        
    end
    ry=ry+ALTO_IMG;
end


% mostramos el resultado
%figure();
%plot(veces);
figure();
imshow(mosaico);

%buscamos las X más usadas
%X = 2;
%for n=1:X
%    [maximo,ind] = max(veces);
%    figure();
%    imshow(imags(:,:,ind));
%    veces(ind) = 0;
%end