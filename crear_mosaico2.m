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
ALTO_MOSAICO = 4608;
ANCHO_MOSAICO = 7680;
mosaico=uint8(zeros(ALTO_MOSAICO,ANCHO_MOSAICO));

%Cargamos imagen target
target = imread('target.jpg');

%Reducimos imagenes
F=4;
reds=imresize(imags,1/F);
ALTO_IMG = ALTO_IMG/F;
ANCHO_IMG = ANCHO_IMG/F;
%rellenamos con las imagenes
veces = zeros(1,NUM);
ry=(1:ALTO_IMG);
for k=1:(ALTO_MOSAICO/ALTO_IMG)
    rx=(1:ANCHO_IMG);
    for j=1:(ANCHO_MOSAICO/ANCHO_IMG)
        
        %Extraemos sub-imagen objetivo
        sub_img = target(ry,rx);
        
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
        mosaico(ry,rx)=reds(:,:,INDICE);
        veces(INDICE) = veces(INDICE)+1;
        rx=rx+ANCHO_IMG;
        
    end
    ry=ry+ALTO_IMG;
end


% mostramos el resultado
figure();
imshow(mosaico);

