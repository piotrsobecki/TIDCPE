function [h_col] = wavelet_bicoherence_func(dataConfig,analysisConfig, handles)



time = dataConfig.time.y;
y1 = dataConfig.y1.y;
y2 = dataConfig.y2.y;
y1_title = dataConfig.y1.title;
y2_title = dataConfig.y2.title;
y1_units = dataConfig.y1.unit;
y2_units = dataConfig.y2.unit;
t_units = dataConfig.time.unit;
fsample = dataConfig.fsample;

interp_fsample = analysisConfig.interp_fsample;
tmin = analysisConfig.tmin;
tmax = analysisConfig.tmax;
cLevels = analysisConfig.cLevels;
Bo = analysisConfig.Bo;
omega_0 = analysisConfig.omega_0;
tN = analysisConfig.tN;
sN = analysisConfig.sN;

% plot wavelet bicoherence

plot4_1 = handles.plot4_1;

FntSz = 9;

plot_title = analysisConfig.plot_title;

discard = false;         %whether or not to discard scales less than the Nyquist
byscale = true;        %True == Color coefficients by each scale (not "all" scales)


% calculate time interpolation from  whole signal fragment analysis
[time_interp] = timeinterp(time,-inf, inf, interp_fsample); 

%interpolate signals
y1 = interp1(time, y1, time_interp, 'linear');
y2 = interp1(time, y2, time_interp, 'linear');

%use target sampling frequency
[BCF, wave_name] = morletWaveletDetails(omega_0,Bo,cLevels,interp_fsample,discard);

[ylab,ylab2,ylabScales] = ylabs(BCF,cLevels);

%Continuous wavelet transform
c1 = cwt(y1, cLevels, wave_name);
c2 = cwt(y2, cLevels, wave_name);

% chop off the ends that we don't want to see...
tmin = max( [ tmin, time(1) ] );                %min time value in event
tmax = min( [ tmax, time(length(time)) ] );     %max time value in event (l.u.b. of max time & NaN for level 9)

mask        = find(time_interp>=tmin & time_interp<=tmax);
time_interp = time_interp(mask);
c1          = c1(:,mask);
c2          = c2(:,mask);
y1          = y1(mask);
y2          = y2(mask);


scales = cLevels;
sc_len = length(scales);
t_len = length(time_interp);
dt = time_interp(2) - time_interp(1);

% Wavelet Bicoherence
WB1 = zeros(sc_len, sc_len);
WB2 = zeros(sc_len, sc_len);

parfor k = 1 : sc_len
    for j = 1 : sc_len
        s = round((1 / k + 1 / j) ^ (-1));
        B_112 = sum(c1(j,:) .* c1(k,:) .* conj(c2(s,:)));
        WB1(j,k) = abs(B_112) .^ 2 ./ (sum(abs(c1(j,:) .* c1(k,:)) .^ 2) .* ...
            sum(abs(c2(s,:)) .^ 2));
    end
end

% plot wavelet bicoherence
axes(plot4_1);
contourf(1:sc_len, 1:sc_len, WB1, 20);
h_col = colorbar;
set(gca, 'FontSize', FntSz);
title(plot_title);


set(gca, 'XTick',1:sc_len/length(ylab2):sc_len);
set(gca, 'XTickLabel', ylab2);
set(gca, 'YTick', 1:sc_len/length(ylab2):sc_len);
set(gca, 'YTickLabel', ylab2);

xlim([1, sc_len]);
ylim([1, sc_len]);

xlabel('Frequency Hz');
ylabel('Frequency Hz');

















