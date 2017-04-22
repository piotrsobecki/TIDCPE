function [] = wlcc_cwcf_func(dataConfig, analysisConfig, handles)




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



% plot WLCC
% plot CWCF

plot3_1 = handles.plot3_1;
plot3_2 = handles.plot3_2;

setYaxis(1:4) = false;

FntSz = 9;

discard = true;         %whether or not to discard scales less than the Nyquist
byscale = true;        %True == Color coefficients by each scale (not "all" scales)


%for Morlet Wavelet
[BCF, wave_name] = morletWaveletDetails(omega_0,Bo,cLevels,interp_fsample,discard);


%Linearly Interpolate Loads so that wavelet detail is better seen
time_interp = timeinterp(time,-inf, inf, interp_fsample); 
y1 = interp1(time, y1, time_interp, 'linear');
y2 = interp1(time, y2, time_interp, 'linear');

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
dt = time_interp(1) - time_interp(2);

% Wavelet Local Correlation Coefficient
WLCC = real(c1 .* conj(c2)) ./ (abs(c1) .* abs(c2));

% Cross Wavelet Coherence Function
CWCF = 2 .* abs(c1 .* conj(c2)) .^ 2 ./ (abs(c1) .^ 4 + abs(c2) .^ 4);

[ylab,ylab2,ylabScales] = ylabs(BCF,cLevels);

% plot WLCC
axes(plot3_1);
color_levels = 128;
colormap( jet(color_levels) );
im = wcodemat(WLCC,color_levels,'row',1);
image(time_interp, cLevels, im);
set(gca,'FontSize', FntSz);
ylabel('Frequency Hz');
xlim([tmin, tmax]);
title('Cross Wavelet Local Correlation (Phase Coherence)');

set(gca,'YTick', ylab,'YTickLabel',ylab2); 

set(gca,'box','off');

%second axis for scales
gcaPos = get(gca,'Position');
gcaUnits = get(gca,'Units');
ax2 = axes('Position',gcaPos,'Units',gcaUnits);
set(ax2,'XAxisLocation','top');
set(ax2,'YAxisLocation','right');
set(ax2,'Color','none');
set(ax2,'FontSize', FntSz,...
    'YTick', ylab,...
    'YTickLabel', ylabScales,...
    'XTick',[]);
ylim([ylab(1), ylab(length(ylab))]);
ylabel('Scale');


% plot CWCF
axes(plot3_2);
colormap( jet(color_levels) );
im = wcodemat(CWCF,color_levels,'row',1);
image(time_interp, cLevels, im);
set(gca,'FontSize', FntSz);
ylabel('Frequency Hz');
xlim([tmin, tmax]);
set(gca,'YTick', ylab,'YTickLabel',ylab2);
title('Cross Wavelet Coherence Function (Intensity Coherence)');
xlabel(['Time ' t_units ]);
set(gca,'box','off');



%second axis for scales
gcaPos = get(gca,'Position');
gcaUnits = get(gca,'Units');
ax2 = axes('Position',gcaPos,'Units',gcaUnits);
set(ax2,'XAxisLocation','top');
set(ax2,'YAxisLocation','right');
set(ax2,'Color','none');
set(ax2,'FontSize', FntSz);
set(ax2,'YTick', ylab,'YTickLabel', ylabScales);
set(ax2,'XTick',[]);
ylim([ylab(1), ylab(length(ylab))]);
ylabel('Scale');

