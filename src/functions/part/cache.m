classdef cache
    %CACHE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       cacheMap;
    end
    
    methods
          function obj = cache(keyType,valueType)
           % class constructor 'int64','double'
               if(nargin > 0)
                 obj.cacheMap= containers.Map('KeyType',keyType,'ValueType',valueType);
               end
           end
        function value = cacheInvocation(obj,func,param)
            if isKey(obj.cacheMap,param)      
                value = obj.cacheMap(param); %Cache hit
            else 
                value = func(param); % Calculate fitness based on crosscorrelation
                obj.cacheMap(param)=value;  %Cache call
            end;
        end
    end
    
end

