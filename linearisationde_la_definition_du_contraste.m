%% rlinéarisation de la définition du contraste
clc
clear
%I=magic(10);
I=imread('med.tif');
subplot(2,2,1)
imhist(I)
I=double(I); % convertis l'image uint8 en double
m=8;%taille de la fênètre
[N,M]=size(I);
X=0;X1=0;X2=0;
C=[];
 somme_num=0;  somme_deno=0; delta=0;
 Erreur=0;
 for b=1:3  % permet de définir le nombre d'itération pour le rehaussement
     if b>1
         I=C;
     end
for i=1:N
    X=0;
    for j=1:M
 % l'algorithme suivant calcul la valeur moyenne dans la fenêtre d'ordre m
        for l=(i-m):(i+m)
            if l>0
                if( N+1>l)&&(l~=i)% X est la moyenne des huit voisins du pixel (i,j)
                    for k=(j-m):(j+m)
                        if k>0
                            if N+1>k% pour contourner les problèmes de bord
                                X=X+I(l,k);
                            end 
                        end
                    end
                end
            end 
        end
        X1=X/(m*m);% calcul la moyenne des voisins du pixels (k,l)
    X=0; % pour libere la variable
% l'algorithme suivant calcul l'opérateur corrélé au modue du gradient
    for l=(i-m):(i+m)
            if l>0 % permet d'annuler les débordements de la matrice
                if N+1>l % centre la matrice dans region de la matrice bien connue
                    for k=(j-m):(j+m)
                        if k>0
                            if N+1>k
                                delta=abs(I(l,k)-X1);
                                somme_num=somme_num+delta*I(l,k);
                                somme_deno=somme_deno+delta;
                            end 
                        end
                    end
                end
            end 
    end
   Erreur=somme_num/somme_deno; % calcul la moyenne  des valeur de la fenetre
 
   X=max(max(I));% recupère la valeur maximale du niveau  de gris de l'image
   if I(i,j)<Erreur
    C(i,j)=Erreur-sqrt(power(Erreur,2)-Erreur*I(i,j));
   
   end
    if I(i,j)>Erreur 
      C(i,j)=Erreur+sqrt((I(i,j)-Erreur)*(X-Erreur));
    end
    
    end
   
end
    title('image avant le rehaussement')
    subplot(2,2,2)
    
 end
 C=uint8(C); %convertit le double en uint8 si non on observera le seuillage sur l'image
    imshow(C)
    subplot(2,2,3)
    imhist(C)
    title('image apres rehaussement')
   % imwrite(C,'cerveau12.tif')% permet d'enregistre l'image en format tif pour autres

