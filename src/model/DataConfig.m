classdef DataConfig
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileName;
        time;
        y1;
        y2;
        fsample;
    end
    
    methods
       function obj = DataConfig(fileName,time,y1,y2,fsample)
           if(nargin > 0)
             obj.fileName=fileName;
             obj.time = time;
             obj.y1 = y1;
             obj.y2 = y2;
             obj.fsample = fsample;
           end
       end
    end
    
end

