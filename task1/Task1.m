clear;
close all;
clc;

%% Parametres

Ts=1*10^(-6);
fp=1.09*10^9;
fe=20*10^6;
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(fe/Rb); % Nombre d'echantillons par symboles

%% Chaine Rx 
sb=[1,0,0,1,0]; %sequence de bits
p_t = [-0.5*ones(1,Fse/2)  0.5*ones(1,Fse/2)]; %filtre de mise en forme

sl_t = modulatePPM(sb,Fse);


%% Affichage
nl_t = 0; %bruit nul
yl_t = sl_t + nl_t;

ga = fliplr(p_t); %filtre adapté
rl_t = conv(ga,yl_t); %filtrage
rl_se = rl_t(Fse:Fse:end); %ajustement du au décalage total de Fse cause par les filtres

t = (0:length(sl_t)-1)/fe;

figure;
subplot(2,2,1);
plot(t * 1e6,sl_t)
legend('sl(t)');

hold on

subplot(2,2,2);
plot(rl_t)
legend('rl(t)');

hold on

subplot(2,2,3);
stem(rl_se)
legend('r_m');

%% Chaine Tx

sb_received = demodulatePPM(sl_t,Fse);


%% Calcul de TEB avec bruit non nul

Nb = 1000;

eb_n0_dB = 0:10;
eb_n0 = 10.^(eb_n0_dB/10);

TEB = zeros(size(eb_n0)); % TEB experimental
TEB_th = zeros(size(eb_n0));  % TEB theorique

Eb = sum(abs(p_t.^2)); % Energie du filtre 
N0 = Eb./eb_n0;



for i=1:length(eb_n0)
    
    error_cnt = 0;
    bit_cnt = 0;
    
    while error_cnt <10 
        
        sb2=randi([0,1],1,Nb);
        % Modulation
        sl_t2=modulatePPM(sb2,Fse);
        % Bruit
        nl_t2 = sqrt(N0(i)/2) .* randn(1,length(sl_t2));
        yl_t2 = sl_t2 + nl_t2;
        % Demodulation
        ga2 = fliplr(p_t);
        rl_t2 = conv(ga2,yl_t2);
        rl_se2 = rl_t2(Fse:Fse:end); %sous echantillonnage (car decalage de Fse/2 à chaque filtre)
        
        sb_received2=demodulatePPM_err(yl_t2,Fse);
        
        % Incrementation compteur erreurs
        error_cnt = error_cnt + sum(sb_received2~=sb2);
        
        bit_cnt = bit_cnt +Nb;
    end
    TEB_th(i) = 0.5 * erfc(sqrt(eb_n0(i)));
    TEB(i) = error_cnt/bit_cnt;
end



figure(2);
semilogy(eb_n0_dB,TEB)
hold on;
semilogy(eb_n0_dB,TEB_th)
legend('TEB experimentale','TEB theorique');








