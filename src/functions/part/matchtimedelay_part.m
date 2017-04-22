function [ o_y1,o_y2,cwtShift,delay ] = matchtimedelay_part( dataConfig, analysisConfig )
    

y1 = dataConfig.y1.y;
y2 = dataConfig.y2.y;
time = dataConfig.time.y;
fsample = dataConfig.fsample;
cLevels = analysisConfig.cLevels;
omega_0 = analysisConfig.omega_0;
Bo = analysisConfig.Bo;
minDelaySec = analysisConfig.minDelaySec;
maxDelaySec = analysisConfig.maxDelaySec;

interp_fsample = analysisConfig.interp_fsample;
[BCF,wave_name] = morletWaveletDetails(omega_0,Bo, cLevels,interp_fsample,true);



%Function optimizing y1 and y2 by signal shifting for best match
    %  This function shifts y2 and calculates the fitness of coscalogram of y1
    %  and shifted y2 for best match. To do that it uses the GA optimization.

     %Cache for fitness function
     fitnessCache = cache('int64','any');
     
     % calculate time interpolation from  whole signal fragment analysis
     [time_interp] = timeinterp(time,-inf, inf, interp_fsample); 
 
     %Fix maximum, minimum delays from input
     time_len = interp_fsample * length(time_interp);
     
     %Convert minimum and maximum delay from seconds to samples
     secToSample = @(sec)( min(time_len,sec) * interp_fsample);
     sampleToSec = @(sample)(sample/interp_fsample);
     
     %Minimum, Maximum shift value
     minShift = - secToSample(maxDelaySec); 
     maxShift = - secToSample(minDelaySec); 
          
    
     % interpolate signal 1
     interpl_y1 = interp1(time, y1, time_interp, 'linear'); 
     % interpolate signal 2
     interpl_y2 = interp1(time, y2, time_interp, 'linear'); 
     
    
     cwtProv = cwtprovider(cLevels,wave_name);
     % Calculate CWT of signal 1 
     [o_cwt1] = cwtProv.provide(interpl_y1);  
     % Calculate CWT of signal 2 - this one will shift
     [o_cwt2] = cwtProv.provide(interpl_y2);  
 
   
     
     % Plot Fitness
     bcf_count = length(cLevels);
     mFF = @(conv,s)(- mean(mean(conv)));
     sFF = @(conv,s)(- sum(sum(conv)));
     
     %Waging functions
     dnW = @(bcf_i)(1);
     mUp = @(bcf_i)(bcf_i/bcf_count);
     mDown = @(bcf_i)(1 - bcf_i/ bcf_count);
     mUp2 = @(bcf_i)(1/2 +  bcf_i/(2*bcf_count));
     mDown2 = @(bcf_i)(1 - bcf_i/(2*bcf_count));

     wagingFuncs =  {dnW,mUp,mDown,mUp2,mDown2};
     howManyWagingFuncs = length(wagingFuncs);
     fitnessFunc=@(conv,s)(-mean(mean(conv)));
     
     wagingFunc=@(m)(m/bcf_count);
     %multiply cwt1 and cwt2 by a waging function
     [cwt1,cwt2] = wageCWT(o_cwt1,o_cwt2,wagingFunc); 
     %minimization of fitness function
     cwtShift = minimumFitness(@cachingFunc,minShift,maxShift); 
     % Taking into account time interpolation to obtain signal shift
     timeS  = size(time);
     timeInterpS = size(time_interp);
     signalShift = floor(cwtShift*timeS(1)/timeInterpS(1));
     % --------------------- OUTPUT --------------------------- 
     o_y2 = shiftArray1D(y2,signalShift); % Second signal is shifted
     o_y1 = y1; % First signal is not changed
     delay = sampleToSec(-1*cwtShift); %Delay in seconds
     %! -------------------- OUTPUT --------------------------- 
    
    function minimized = minimumFitness(func,limitFrom,limitTo)
         minimized = ga(... % genetic algorithm 
            func,...        % fitness function
            1, ...          % single variable optimization
            [],[],[],[], ...
            limitFrom,...   % search for solution greater than
            limitTo,...     % search for solution lower than
            [],...
            1,...           % use integer variables
            gaoptimset('PopulationSize',200)); 
     end

        function [cwt1_w,cwt2_w] = wageCWT(cwt1,cwt2,wagingFunction)
             [m,n] = size(cwt1);
             wages = matrix(m, n, @(m)(wagingFunction(m)));
             cwt1_w = wages.*cwt1;
             cwt2_w = wages.*cwt2;   
        end

    %Cross correlation resulting in fitness
    function fitness = calculateFitness(cwt1,cwt2,shiftInt)
        [s_cwt2] = shiftArray2D(cwt2,shiftInt); % Shift interpolated signal
        convolution = cwt1 .* s_cwt2; % Calculate coscalogram
        fitness = fitnessFunc(convolution,shiftInt);
    end
    %Function that caches invocations of fitness functions for params
    function c = cachingFunc(shift)
        c=fitnessCache.cacheInvocation(...
            @(x)(calculateFitness(cwt1,cwt2,x)),shift...
        );
    end
  
    function shifted = shiftArray1D(arr,indexShift)
        shifted = circshift(arr,indexShift);
    end
    function shifted = shiftArray2D(cwt,indexShift)
        shifted = circshift(cwt,indexShift,2);
    end

 


  
end

