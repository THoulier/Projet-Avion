function [sb_received] = demodulatePPM_err(yl_t,Fse)
p_t = [-0.5*ones(1,Fse/2)  0.5*ones(1,Fse/2)]; %filtre de mise en forme

ga2 = fliplr(p_t);
rl_t2 = conv(ga2,yl_t);
rl_se2 = rl_t2(Fse:Fse:end); %sous echantillonnage (car decalage de Fse/2 à chaque filtre)

sb_received=[];

        for j=1:length(rl_se2)
            if rl_se2(j) < 0
                sb_received(j) = 1;
            else
                sb_received(j) = 0;
            end
        end
end
        