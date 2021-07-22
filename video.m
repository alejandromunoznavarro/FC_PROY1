
fps = get(obj,'FrameRate');
T = NF/fps; %segundos del video
tiempo=zeros(NF,4);
for j=1:NF
    for x=1:4
        tiempo(j,x)= (T/NF) *j;
    end
end

figure();
plot(tiempo,U);
