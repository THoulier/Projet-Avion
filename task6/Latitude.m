function [lat] = Latitude(LAT,latref,i)

    Nz = 15;
    Dlat = 360/(4*Nz-i);
    Nb = 17;
    
    j = floor(latref/Dlat) +floor((1/2) + (mod(latref,Dlat)/Dlat) - (LAT/(2^Nb)));
    lat = Dlat*(j + (LAT/2^Nb));

end
