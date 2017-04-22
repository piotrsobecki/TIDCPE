classdef cwtprovider
    %CACHE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       wave_name;
       cLevels;
    end
    
    methods
        
        function obj = cwtprovider(cLevels,wave_name)
            obj.wave_name=wave_name;   
            obj.cLevels=cLevels;   
        end
        
        function value = provide(obj,signal)
            value = cwt(signal, obj.cLevels, obj.wave_name);  
        end
           
    end
end
