% Reiniciamos veces
veces = zeros(1,NUM);

contador = 0;
ITERACIONES = 500;
aciertos = ITERACIONES*0.01;
FI = 16;
reds=imresize(imags,1/FI);
%bucle de iteraciones
while aciertos >= ITERACIONES*0.01
    contador=contador+1;
    aciertos = 0;
    for x = 1:ITERACIONES
        %escoger una posición aleatoria
        yo=floor(rand(1)*(ALTO_MOSAICO-(ALTO_IMG/FI)));
        xo=floor(rand(1)*(ANCHO_MOSAICO-(ANCHO_IMG/FI)));
        ry=yo+(1:ALTO_IMG/FI);
        rx=xo+(1:ANCHO_IMG/FI);
    
        %selecionamos imagen target
        sub_img = target(ry,rx);
    
        %selecionamos imagen mosaico
        %sub_mos = imresize(cpy_mosaico(ry,rx),1/FI);
        sub_mos = mosaico(ry,rx);
        
        %diferencia reducidas
        dif = double(sub_mos(:,:)) - double(sub_img(:,:)); 
            
        %abs
        absoluto = abs(dif);
            
        %mean2
        E_min = mean2(absoluto);
        
        INDICE = 0;
        %recorremos imagenes
        for i=1:NUM
            %diferencia reducidas
            dif = double(reds(:,:,i)) - double(sub_img(:,:)); 
            
            %abs
            absoluto = abs(dif);
            
            %mean2
            media = mean2(absoluto);
            
            %Calculamos factor
            factor = 1 + ((4*veces(i))/(max(veces)+1));
            media = media*factor;
            
            if E_min > media
                INDICE = i;
                E_min = media;
            end
        end
        if INDICE ~= 0
            %introducimos la imagen
            mosaico(ry,rx)=reds(:,:,INDICE);
            veces(INDICE) = veces(INDICE)+1;
            aciertos = aciertos+1;
        end
    end
end

% mostramos el resultado
imshow(mosaico);