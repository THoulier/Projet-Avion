clear 
close all
clc


%% Parametres

Ts=1*10^(-6);
fp=1.09*10^9;
Fe=20*10^6;
Nfft = 256;
Nb = 10000; % Nombre de bits generes
Te= 1/Fe;
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles



%% Modulation
sb = randi([0,1],1,Nb);
p_t = [-0.5*ones(1,Fse/2)  0.5*ones(1,Fse/2)]; 

sl_t=modulatePPM(sb,Fse);


%% Welch

[welch ,axe_freq] = Mon_Welch(sl_t,Nfft,Fe);

figure;
plot(axe_freq,welch');

figure;
semilogy(axe_freq,welch'/Fe)
hold on;
semilogy(axe_freq,p)



