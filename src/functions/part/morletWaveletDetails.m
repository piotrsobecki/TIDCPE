function [ BCF, wave_name ] = morletWaveletDetails( omega_0,Bo, cLevels,fsample,discard )

    Nu_0 = omega_0 / (2 * pi);

    BCF = Nu_0 ./ cLevels * fsample;            %Center Frequency
    Bs = Bo ./ (4 * pi * cLevels) * fsample;    %Bandwidth at scale specific scale (cLevels)
    LBL = BCF - Bs./2;                          %Lowermost Frequency at scale
    UBL = BCF + Bs./2;                          %Uppermost Frequency at scale
   
    if (discard)
        Nyquist = 1/( (1/fsample) * 2);
        ix = (LBL<=Nyquist);      %Discard frequencies greater than Nyquist
        cLevels = cLevels(ix);
        BCF = BCF(ix);
        LBL = LBL(ix);
        UBL = UBL(ix);
    end

    wave_name = sprintf('cmor%f-%f', Bo, Nu_0);
end

