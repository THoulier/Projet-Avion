function [Y,F] = Mon_Welch(X, Nfft,Fe)

size_reshape = length(X)-mod(length(X),Nfft); %sl_t de longueur multiple de 256 pour construire le plus de segments de taille 256 de sl_t

Seg = reshape(X(1:size_reshape),Nfft,round(length(X)/Nfft)); %matrice de 781 segments de taille 256
FFT = fftshift(fft(Seg,Nfft)); %matrice des fft de chaque segments
DSP = abs(FFT).^2; %Matrice des DSP de chaque segments
Y = sum(DSP,2)/size(DSP,2); %Moyennage
F = [-Fe/2+1:Fe/Nfft:Fe/2];
end