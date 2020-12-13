%%                          K-Means
%
%   Clasificador de diferentes tipos de plantas Iris
%   Clases = Setosa=1, Versicolour=2, Virginica=3
%   Caracteristicas = Sepal length/width, Petal length/width

%%  1.- Preparar datos
close


clear
clc
load('iris.mat');   %   Esta contiene la etiqueta class
mat=iris;   %   Creamos nueva para manipularla
mat(:,5)=[];    % Eliminamos etiqueta class

%   Tomamos medidas
k=3;    % # Clusters
m=size(mat,1);  % # Training examples
n=size(mat,2);  % # Features
maxFt=zeros(1,n);   %   Maximos
minFt=zeros(1,n);   %   Minimos
for i=1: n
    minFt(1,i)=min(mat(:,i));
    maxFt(1,i)=max(mat(:,i));
end

%%  2.- Centroids

%   Creamos los centroides
centroids=zeros(k,n); 

%   Inicializamos los centroides
for j=1: k
for i=1: n
   %    Generar porcentaje aleatorio 
   randomcentroid=maxFt(i)-minFt(i);    %   Sacamos la distancia
   randomcentroid=randomcentroid*rand;  %   % random del intervalo
   
   centroids(j,i)=minFt(i)+randomcentroid;    %   Le agregamos ese % 
   
end
end

condition=zeros(k,n);   %   Creamos condicion para la convergencia


%%  Primeros Plot

%   Tomaremos como referencia para el plot el Petal length/width
close   
figure(1)   
hold on
scatter( (mat(:,3)), (mat(:,4)) ,'MarkerEdgeColor',[0 0 0]);%Muestras

scatter(  (centroids(1,3)), (centroids(1,4)) ,'MarkerEdgeColor','green');
scatter(  (centroids(2,3)), (centroids(2,4)) ,'MarkerEdgeColor','green');
scatter(  (centroids(3,3)), (centroids(3,4)) ,'MarkerEdgeColor','green');
xlabel('Petal Lenght');
ylabel('Petal Width');
hold off    

plotlock=1;    %   Bloqueamos el segundo plot hasta la segunda iteracion


while condition~=centroids

if plotlock==0
    
    %%  Plot interaciones
    %   Tomaremos como referencia para el plot el Petal length/width
    close   
    figure(1)   
    hold on
    mat3=mat(:,3);
    mat4=mat(:,4);
    k1plotX=mat3(indexM==1);
    k1plotY=mat4(indexM==1);
    k2plotX=mat3(indexM==2);
    k2plotY=mat4(indexM==2);
    k3plotX=mat3(indexM==3);
    k3plotY=mat4(indexM==3);
    
    scatter( k1plotX, k1plotY ,'MarkerEdgeColor','red');
    scatter( k2plotX, k2plotY ,'MarkerEdgeColor','blue');
    scatter( k3plotX, k3plotY ,'MarkerEdgeColor','magenta');


    scatter(  (centroids(1,3)), (centroids(1,4)) ,'MarkerEdgeColor','green');
    scatter(  (centroids(2,3)), (centroids(2,4)) ,'MarkerEdgeColor','green');
    scatter(  (centroids(3,3)), (centroids(3,4)) ,'MarkerEdgeColor','green');
    xlabel('Petal Lenght');
    ylabel('Petal Width');
    hold off 
    
end


    condition=centroids;
    %%  3.- Distancias

    distance=zeros(m,k);    %   Creamos matriz de distancias

    for i=1:m
       distance(i,:)=(sum((((mat(i,:)-centroids).^2))')).^.5;   %   Distancias  
    end

    %%  4.- Indexamos

    %   Creamos matriz logica de los valores minimos

    logicMin=zeros(m,k);
    for i=1:m
    logicMin(i,:)=(distance(i,:)==min (distance(i,:)));
    end

    %   Indexamos uno por uno
    indexM=zeros(m,1);


    for j=1: k
    for i=1:m
       if logicMin(i,j)==1
           indexM(i)=j;  
       end
    end
    end



    %%  5.- Reajustar Centroides

    for i=1:k
    centroids(i,:)=mean(mat(indexM==i,:));  %   Asignamos la media
    end
    
    plotlock=0; %   Libermos el segundo plot
    
pause
end



%%  7.- Medimos efectividad 

%   Creamos matriz con lo kluster asigados
label=iris(:,5);
labelU=unique(label);
accuaracy=0;

for i=1:size(unique(label))
    
    kAcuaracy=indexM(label==labelU(i)); %   Partimos indexM para comparar
    %   Contamos lo que se repite la moda
    accuaracy=accuaracy+ sum(kAcuaracy==mode(kAcuaracy)); 
    
end

accuaracy=accuaracy/size(label,1);
disp('Efetividad:')
disp(accuaracy*100)