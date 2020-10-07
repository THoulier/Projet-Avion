function [sl_t] = modulatePPM(sb, Fse)

p_t = [-0.5*ones(1,Fse/2)  0.5*ones(1,Fse/2)]; %filtre de mise en forme
sl_t=[];

for i = 1 : length(sb)
    if sb(i) == 0
        sl_t = [sl_t, p_t];
    
    elseif  sb(i) == 1
        sl_t = [sl_t, -p_t];
    end
end
sl_t = 0.5 + sl_t;
end