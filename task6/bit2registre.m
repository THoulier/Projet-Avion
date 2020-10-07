function [registre] = bit2registre(Vect,latref,lonref)
registre = struct('adresse',[],'format',[],'type',[],'nom',[],'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[], 'crcErrFlag',[]);

%% TESTS

gen = crc.generator([1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,1,0,0,1]);
h = crc.detector(gen);
[sortie, erreur] = decodeCRC(Vect',h);
if (erreur == 1)
   error("erreur CRC");
   registre.crcErrFlag = 1;
end 

registre.crcErrFlag = 0;

%% MAJ du registre

if (bi2de(Vect(1:5),'left-msb')==17)% voie descendante cod�e par les 5 premiers bites de la trame == 17?
    %% Traitement des premieres parties de la trame (bits 1->32)
    registre.adresse=dec2hex(bi2de(Vect(9:32),'left-msb')); %bits representants l'adresse OACI de l'appareil
    registre.format=17;
    
    %% Traitement MSG ADSB (bits 33->89)
    MSG_ADSB = Vect(33:89); % 56 bits en taille
    
    %FTC
    FTC = bi2de(MSG_ADSB(1:5),'left-msb');
    registre.type = FTC;
    %TimeFlag
    registre.timeFlag = MSG_ADSB(21);
    %cprFlag
    registre.cprFlag = MSG_ADSB(22);
    
    %% MSG identification
    Tab_caracteres=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",0,0,0,0,0," ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"0","1","2","3","4","5","6","7","8","9"];
    nom='';
    Caractere_ADSB = reshape(MSG_ADSB(9:56),6,8);  %Matrices des segments des 8 caracteres de l'avion
    
    if (ismember(registre.type,[1:4]))
        for i=1:8
            if (bi2de(Caractere_ADSB(:,i)','left-msb') ~= 0)
                nom = nom + Tab_caracteres(bi2de(Caractere_ADSB(:,i)','left-msb'));
            end
        end
    
    
    registre.nom = nom;
    %% MSG position en vol
    
    elseif (ismember(registre.type,[[9:18] [20:22]]))
        registre.etat="Position en vol";
        i = MSG_ADSB(22);
        %Latitude
        LAT = bi2de(MSG_ADSB(23:39),'left-msb');
        
        lat = Latitude(LAT,latref,i);
        registre.latitude = lat;
        
        %Longitude
        LON = bi2de(MSG_ADSB(40:56),'left-msb');
   
        lon = Longitude(LON,lonref,i,lat);
        registre.longitude = lon;
        
        %altitude
        ALT = bi2de([MSG_ADSB(9:15) MSG_ADSB(17:20)],'left-msb');
        alt = 25*ALT-1000;
        registre.altitude = alt;
    
    %% MSG position au sol
    
    elseif (ismember(registre.type,[5:8]))
        registre.etat="Position au sol";
        i = MSG_ADSB(22);
        %Latitude        
        LAT=bi2de([MSG_ADSB(14:20)  MSG_ADSB(23:39)],'left-msb');
        
        lat = Latitude(LAT,latref,i);
        registre.latitude = lat;

        %Longitude        
        LON = bi2de(MSG_ADSB(40:56),'left-msb');
        
        lon = Longitude(LON,lonref,i,lat);
        registre.longitude = lon;
    
    
    %% Vitesse de l'avion
    elseif (registre.type == 19)
        
    
end
end



