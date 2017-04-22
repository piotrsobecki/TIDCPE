function [h_col] = wavelet_coherence_func(dataConfig, analysisConfig, handles)




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


% plot wavelet coherence in GUI

plot4_1 = handles.plot4_1;

plot_title = analysisConfig.plot_title;
FntSz = 9;

discard = 0;         %whether or not to discard scales less than the Nyquist
byscale = true;        %True == Color coefficients by each scale (not "all" scales)

% calculate time interpolation from  whole signal fragment analysis
[time_interp] = timeinterp(time,-inf, inf, interp_fsample); 

%interpolate signals
y1 = interp1(time, y1, time_interp, 'linear');
y2 = interp1(time, y2, time_interp, 'linear');

%use target sampling frequency
[BCF, wave_name] = morletWaveletDetails(omega_0,Bo,cLevels,interp_fsample,discard);


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

% Check if the integral image function (in the computer vision toolbox)
% exists. This way is much faster.
if exist('integralImage', 'file')
    s_12 = zeros(sc_len, t_len);
    s_11 = zeros(sc_len, t_len);
    s_22 = zeros(sc_len, t_len);
    int_12 = c1 .* conj(c2);
    int_11 = c1 .* conj(c1);
    int_22 = c2 .* conj(c2);
    int_12_real = integralImage(real(int_12));
    int_12_imag = integralImage(imag(int_12));
    int_11_real = integralImage(real(int_11));
    int_11_imag = integralImage(imag(int_11));
    int_22_real = integralImage(real(int_22));
    int_22_imag = integralImage(imag(int_22));

    parfor k = 1 : sc_len
        for j = 1 : t_len
            
            % Notice that sR = eR, this makes it so there is no
            % smoothing over the scales, only time smoothing
            [sR sC eR eC] = deal(k + sN, j - tN, k+sN, j + tN);
            
            if k - sN < 1 
                sR = 1;
                eR = 1;
            elseif k + sN > sc_len
                sR = sc_len;
                eR = sc_len;
            end
            if j - tN < 1
                sC = 1;
            end
            if j + tN > t_len
                eC = t_len;
            end
            
            value_12_real = int_12_real(eR+1,eC+1) - int_12_real(eR+1,sC) ...
                - int_12_real(sR,eC+1) + int_12_real(sR,sC);
            value_12_imag = int_12_imag(eR+1,eC+1) - int_12_imag(eR+1,sC) ...
                - int_12_imag(sR,eC+1) + int_12_imag(sR,sC);
            value_11_real = int_11_real(eR+1,eC+1) - int_11_real(eR+1,sC) ...
                - int_11_real(sR,eC+1) + int_11_real(sR,sC);
            value_11_imag = int_11_imag(eR+1,eC+1) - int_11_imag(eR+1,sC) ...
                - int_11_imag(sR,eC+1) + int_11_imag(sR,sC);
            value_22_real = int_22_real(eR+1,eC+1) - int_22_real(eR+1,sC) ...
                - int_22_real(sR,eC+1) + int_22_real(sR,sC);
            value_22_imag = int_22_imag(eR+1,eC+1) - int_22_imag(eR+1,sC) ...
                - int_22_imag(sR,eC+1) + int_22_imag(sR,sC);
            s_12(k,j) = 1 ./ scales(k) .* dt .* (value_12_real + 1i * value_12_imag);
            s_11(k,j) = 1 ./ scales(k) .* dt .* (value_11_real + 1i * value_11_imag);
            s_22(k,j) = 1 ./ scales(k) .* dt .* (value_22_real + 1i * value_22_imag);
        end
    end

% Use this if the integral image funciton is not available.
% This way is much slower.
else
    w1 = [zeros(sN, 2 * tN + t_len); zeros(sc_len, tN) c1 zeros(sc_len, tN); ...
        zeros(sN, 2 * tN + t_len)];
    w2 = [zeros(sN, 2 * tN + t_len); zeros(sc_len, tN) c2 zeros(sc_len, tN); ...
        zeros(sN, 2 * tN + t_len)];
    s_12 = zeros(sc_len, t_len);
    s_11 = zeros(sc_len, t_len);
    s_22 = zeros(sc_len, t_len);


    parfor k = 1 : sc_len
        for j = 1 : t_len
            s_12(k,j) = 1 ./ scales(k) .* dt .* ...
                sum(sum(w1(k:k+2*sN,j:j+2*tN) .* conj(w2(k:k+2*sN,j:j+2*tN))));
            s_11(k,j) = 1 ./ scales(k) .* dt .* ...
                sum(sum(w1(k:k+2*sN,j:j+2*tN) .* conj(w1(k:k+2*sN,j:j+2*tN))));
            s_22(k,j) = 1 ./ scales(k) .* dt .* ...
                sum(sum(w2(k:k+2*sN,j:j+2*tN) .* conj(w2(k:k+2*sN,j:j+2*tN))));
        end
    end
end


WC = abs(s_12) .^ 2 ./ (s_11 .* s_22);

% Wavelet Phase Coherence
WBB = atan(real(s_12) ./ imag(s_12));

v_contour = (2:10) .* 0.1;

WC(WC < 0.2) = 0.2;

axes(plot4_1);
contourf(time_interp, 1:sc_len, WC, v_contour);
hold on;
colormap([[1 1 1]; jet]);
h_col = colorbar;

[x_fine y_fine] = meshgrid(time_interp, 1:sc_len);
[x_course y_course] = meshgrid(linspace(time_interp(1),time_interp(end),10),...
    linspace(1,sc_len, 20));
quivers = interp2(x_fine, y_fine, WBB, x_course, y_course, 'linear');
WC_course = interp2(x_fine, y_fine, WC, x_course, y_course, 'linear');
quivers(WC_course < 0.3) = NaN;

quivers_x = cos(quivers) .* 1;
quivers_y = sin(quivers) .* 1;
quiver(x_course, y_course, quivers_x, quivers_y, 0,'k');

set(gca, 'FontSize', FntSz);
title(plot_title);
y_label_scaled = linspace(1, sc_len, 10);
y_label = interp1(1:sc_len, fliplr(BCF), y_label_scaled);
y_label(1) = ceil(y_label(1) * 10) / 10;
y_label(end) = floor(y_label(end) * 10) / 10;
y_label(2:end-1) = round(y_label(2:end-1) * 10) / 10;
set(gca, 'YTick', y_label_scaled);
set(gca, 'YTickLabel', y_label);
xlabel(['Time ' t_units]);
ylabel('Frequency Hz');
hold off;



