classdef DataSourceConfig
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        path;
        file;
        columns;
        fsample;
    end
    
    methods
       % methods, including the constructor are defined in this block
       function obj = DataSourceConfig(path,file,columns,fsample)
       % class constructor
           if(nargin > 0)
             obj.path = path;
             obj.file = file;
             obj.columns=columns;
             obj.fsample = fsample;
           end
       end
    end
    
end

