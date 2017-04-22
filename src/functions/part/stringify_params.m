
function [ str ] = stringify_params( dataConfig, analysisConfig, properties )

    file_name = dataConfig.fileName;
    interp_fsample = analysisConfig.interp_fsample;
    tmin = analysisConfig.tmin;
    tmax = analysisConfig.tmax;
    cLevels = analysisConfig.cLevels;
    Bo = analysisConfig.Bo;
    omega_0 = analysisConfig.omega_0;
    tN = analysisConfig.tN;
    sN = analysisConfig.sN;

    str = '';
    
    if any(strfind(properties,'fileName'))
       str = strcat(str,{' '},sprintf('File=%s;',file_name)); 
    end
    
    if any(strfind(properties,'interp_fsample'))
       str = strcat(str,{' '},sprintf('S-Rate=%d;',interp_fsample)); 
    end
    
    
    if any(strfind(properties,'tmin'))
       str = strcat(str,{' '},sprintf('Min_t=%0.2f;',tmin)); 
    end
    
    if any(strfind(properties,'tmax'))
       str = strcat(str,{' '},sprintf('Max_t=%0.2f;',tmax)); 
    end
        
    if any(strfind(properties,'cLevels'))
       firstLevel = cLevels(1);
       stepLevel = cLevels(2)-cLevels(1); 
       maxLevel = cLevels(length(cLevels)) + stepLevel - firstLevel;
       str = strcat(str,{' '},sprintf('Scales=[%d:%d:%d];',firstLevel,stepLevel,maxLevel)); 
    end
        
    if any(strfind(properties,'Bo'))
       str = strcat(str,{' '},sprintf('Bwidth=%d;',Bo)); 
    end
        
    if any(strfind(properties,'omega_0'))
       str = strcat(str,{' '},sprintf('C.Freq=%d;',omega_0)); 
    end
       
    if any(strfind(properties,'tN'))
       str = strcat(str,{' '},sprintf('Smooth/time=%d; ',tN)); 
    end     
    
    if any(strfind(properties,'sN'))
       str = strcat(str,{' '},sprintf('Smooth/scales=%d; ',sN)); 
    end

end

