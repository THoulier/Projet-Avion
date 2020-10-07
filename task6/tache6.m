clear 
close all
clc

%% Load des trames 
load("adsb_msgs.mat");

%% Mise à jour du registre
lonref = -0.606629;
latref = 44.806884;

latitude=[];
longitude=[];
Registre_MAJ = bit2registre(adsb_msgs(:,25)',latref,lonref)

for i=1:27
    Registre_MAJ = bit2registre(adsb_msgs(:,i)',latref,lonref);
    longitude = [longitude Registre_MAJ.longitude];
    latitude = [latitude Registre_MAJ.latitude];
end

%% Affichage de la trajectoire de l'avion
affiche_carte(lonref,latref)
plot(longitude,latitude,'--k')
