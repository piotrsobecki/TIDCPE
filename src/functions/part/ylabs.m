function [ ylab,ylabFreq,ylabScales ] = ylabs( BCF,cLevels )
%YLAB Summary of this function goes here
%   Detailed explanation goes here

    
    len = length(cLevels);
    dy = max([1, floor(len/10)]); %minimum distance between indices
    k = 1;
    tBCF = round(BCF*10)./10;
    ylab(1)  = cLevels(k); %start at bottom (smallest level == largest frequency);
    ylabFreq(1) = tBCF(k);
    next_k   = k + dy;    %next possible index
    t = ylabFreq(1); %largest frequency....
    p = 2;
    nextLab = min([find(tBCF<t), len+1]); %next index with frequency value smaller than last one
    while nextLab <= len
        if nextLab >= next_k
            k = nextLab;
            ylabFreq(p) = tBCF(k);
            ylab(p) = cLevels(k);
            p = p + 1;
            next_k = k + dy;
        end
        t = tBCF(nextLab);
        nextLab = min([find(tBCF<t), len+1]); %next index with value greater than last one
    end
    ylabScales = fliplr(ylab);
end

