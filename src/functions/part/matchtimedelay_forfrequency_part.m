function [ y1, y2,time_interp,tmin,tmax, cwt1,cwt2,shifts ] = matchtimedelay_forfrequency_part( dataConfig, analysisConfig )
   

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


     % calculate time interpolation from  whole signal fragment analysis
     [time_interp,from,to,total,tmin,tmax] = timeinterp(time,-inf, inf, interp_fsample); 
 
     %Fix maximum, minimum delays from input
     totalLengthSec = interp_fsample * length(time_interp);
     
     %Minimum, Maximum shift value
     getShiftFromSec = @(delaySec)(-1 * min(totalLengthSec,delaySec) * interp_fsample);
     minShift = getShiftFromSec(maxDelaySec); %to array index
     maxShift = getShiftFromSec(minDelaySec); %to array index
          
     % interpolate signal 1
     interpl_y1 = interp1(time, y1, time_interp, 'linear'); 
     y1 = interpl_y1;
     % interpolate signal 2
     interpl_y2 = interp1(time, y2, time_interp, 'linear'); 
     y2 = interpl_y2;
     
     
     cwtProv = cwtprovider(cLevels,wave_name);
     % Calculate CWT of signal 1 
     [original_cwt1] = cwtProv.provide(interpl_y1);  
     % Calculate CWT of signal 2 - this one will shift
     [original_cwt2] = cwtProv.provide(interpl_y2);  
 
        
     % Plot Fitness
    % howManyLevels = length(cLevels);
     mFF = @(conv,s)(- mean(mean(conv)));
    % sFF = @(conv,s)(- sum(sum(conv)));
     fitnessFunc=mFF;
   
     
     
     cwt_size = size(original_cwt1);
     cwt2_shifted = zeros(cwt_size);
     shifts = zeros(cwt_size(1),1);
     for current_row = 1:cwt_size(1);
         %Cache for fitness function
         fitnessCache = cache('int64','any');
         cwt1 = original_cwt1(current_row,:);
         cwt2 = original_cwt2(current_row,:);
         %minimization
         shift= minimumFitness(@cachedCalculateFitness,minShift,maxShift);
         cwt2_shifted(current_row,:)=circshift(cwt2,shift,2);
         shifts(current_row) = shift;
     end;
   
    
    
     % --------------------- OUTPUT ---------------------------
     cwt1 = original_cwt1; % First signal is not changed
     cwt2 = cwt2_shifted; % Second signal is shifted
     shifts  = shifts';
    function minimized = minimumFitness(func,limitFrom,limitTo)
         %Use hybrid function
         ga_options = gaoptimset('PopulationSize',200); 
         %Genetic Algorithm - fitness function, one variable optimization, options 
         minimized = ga(func,1,[],[],[],[],limitFrom,limitTo,[],1,ga_options);
    end

    function c = cachedCalculateFitness(shift)
        c=fitnessCache.cacheInvocation(@(x)(calculateFitnessByIndexShift(cwt1,cwt2,x)),shift);
    end
  
    %Cross correlation resulting in fitness 
    function fitness = calculateFitnessByIndexShift(cwt1,cwt2,shiftInt)
          [s_cwt2] = circshift(cwt2,shiftInt,2); % Shift interpolated signal
          convolution = cwt1 .* s_cwt2; % Calculate coscalogram
          fitness = fitnessFunc(convolution,shiftInt);
    end

  
end

