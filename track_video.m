 clear

 X=[490 754 862 591];
 Y=[320 220 485 591];
 
 col = [  13  133 32 7
          10  30 86 90
          12  16 31 104 ];
 
 obj=VideoReader('./color.mp4');
 NF = get(obj, 'NumberOfFrames');

 figure(1);  
 frame=read(obj,1); im_obj=imshow(frame); hold on; 
 pp_obj=plot(X,Y,'yo','MarkerFaceCol','y','MarkerSize',4); 
 tt=text(X+20,Y+20,['1';'2';'3';'4']);
 t_frame=text(15,20,'Frame# 001','Color','y','FontSize',18);
 set(tt,'FontWeight','Bold','Color',[0 0 1]);
 hold off

 pause
 
RAD=25; % Zona de exploracion
dx=ones(2*RAD+1,1)*(-RAD:RAD); 
dy=(-RAD:RAD)'*ones(1,2*RAD+1);

%Creamos U y V para guardar la posicion de las X's y las Y's
U = zeros(NF,4);
V = zeros(NF,4);
% Calculamos variables para el futuro calculo del tiempo en cada frame
fps = get(obj,'FrameRate');
T = NF/fps; %tiempo total del video (segundos)
% inicializamos variable para guardar el tiempo de cada frame
tiempo=zeros(NF,4);

for k=1:NF

  frame=read(obj,k); set(im_obj,'Cdata',frame);
    
 % Bucle actualizando posiciones X(j),Y(j) de las 4 esquinas
  for j=1:4   
     % Calculamos coordenadas
     x=round(X(j));
     y=round(Y(j));
     rx=x+(-RAD:RAD);
     ry=y+(-RAD:RAD);
     % Extraemos subimagen
     sub_img=frame(ry,rx,:);
     % Sacamos los componentes
     R=double(sub_img(:,:,1));
     G=double(sub_img(:,:,2));
     B=double(sub_img(:,:,3));
     % Calculamos la diferencia en canales
     T=10;
     dr=(R-col(1,j))./T;
     dg=(G-col(2,j))./T;
     db=(B-col(3,j))./T;
     % Calculamos w
     w=exp(-(dr.^2 + dg.^2 + db.^2));
     % Normalizamos w
     w=w./sum(w(:));
     % Calculamos estimacion y actualizamos
     Ax=(x+dx).*w;
     X(j) = sum(Ax(:));
     Ay=(y+dy).*w;
     Y(j) = sum(Ay(:));
     % Estabilización del color
     Ar = R.*w;
     col(1,j)=mean2(sum(Ar(:)));
     Ag = G.*w;
     col(2,j)=mean2(sum(Ag(:)));
     Ab = B.*w;
     col(3,j)=mean2(sum(Ab(:)));
     U(k,j)=X(j);
     V(k,j)=Y(j);
     % calculamos tiempo para hacer el plot de U y V
     tiempo(k,j)= (T/NF) *k;
     
  end

 
 % Actualizar plot y etiquetas de los puntos sobre la imagen. 
 %set(pp_obj,'Xdata',X,'Ydata',Y); 
 hold on;
 plot(X,Y,'y.');
 hold off;
 for z=1:4, set(tt(z) ,'Position',[X(z)+15 Y(z)+15 0]); end  
 set(t_frame,'String',sprintf('Frame# %03d',k));
 drawnow
end

% Mostramos plot de U en la figura 2 y plot de V en la figura 3
figure();
plot(tiempo,U);
figure();
plot(tiempo,V);
