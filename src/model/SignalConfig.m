classdef SignalConfig
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        y;
        title;
        unit;
    end
    
     methods
       function obj = SignalConfig(y,title,unit)
           if(nargin > 0)
             obj.y=y;
             obj.title=title;
             obj.unit=unit;
           end
       end
    end
    
end

