function [ txt,units ] = readDataHeaders( fname,delim)
    txt=[];
    units=[];
    fid = fopen(fname);  
    if (fid > 0)
        txt_str = fgetl(fid);
        units_str = fgetl(fid);
        txt=strtrim(strsplit(txt_str,delim));
        units=strtrim(strsplit(units_str,delim));
        fclose(fid);
    end
end

