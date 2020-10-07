function [lon] = Longitude(LON,lonref,i,lat)
    Nb = 17;
    Dlon = 0;
    NL = cprNL(lat);
    if ((NL-i)>0)
        Dlon = 360/(NL-i);
    elseif ((NL-i)==0)
        Dlon = 360;
    end
    m = floor(lonref/Dlon) + floor((1/2) + (mod(lonref,Dlon))/Dlon - (LON/(2^Nb)));
      
    lon = Dlon*(m + (LON/2^Nb));
end