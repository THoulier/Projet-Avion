clear;
close all;
clc;

%% Paramètres

Ts=1*10^(-6);
fp=1.09*10^9;
fe=20*10^6;
Fse=20;
Nb = 88;


gen = crc.generator([1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,1,0,0,1]);
h = crc.detector(gen);


%% Démodulation 
sb=randi([0,1],1,Nb);

%Encode la sequence de bits
encoded = encodeCRC(sb',h,gen);

%Encode la sequence avec une erreur
%idx_error = randi(Nb,1,1);
%encoded(idx_error) = 1 - encoded(idx_error);


p_t = [-0.5*ones(1,Fse/2)  0.5*ones(1,Fse/2)]; 

sl_t=[];

for i = 1 : Nb
    if encoded(i) == 0
        sl_t = [sl_t, p_t];
    
    elseif  encoded(i) == 1
        sl_t = [sl_t, -p_t];

    end
end

nl_t = 0;
yl_t = sl_t + nl_t;

ga = fliplr(p_t);
rl_t = conv(ga,yl_t);
rl_se = rl_t(Fse:Fse:end);

%% Affichage

figure;
subplot(2,2,1);
plot(sl_t)
legend('sl(t)');

hold on

subplot(2,2,2);
plot(rl_t)
legend('rl(t)');

hold on

subplot(2,2,3);
stem(rl_se)
legend('r_m');

%% Décision

sb_received=[];

for j=1:length(rl_se)
    if rl_se(j) < 0
        sb_received(j) = 1;
    else
        sb_received(j) = 0;
    end
end
       
%% TEST
[sortie, erreur] = decodeCRC(encoded,h);





