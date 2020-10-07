function [sb_received] = demodulatePPM(sl_t,Fse)
p_t = [-0.5*ones(1,Fse/2)  0.5*ones(1,Fse/2)]; %filtre de mise en forme

nl_t = 0; %bruit nul

yl_t = sl_t + nl_t;

ga = fliplr(p_t); %filtre adapté
rl_t = conv(ga,yl_t); %filtrage
rl_se = rl_t(Fse:Fse:end); %ajustement du au décalage total de Fse cause par les filtres

for j=1:length(rl_se)
    if rl_se(j) < 0
        sb_received(j) = 1;
    else
        sb_received(j) = 0;
    end
end
end