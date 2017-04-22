function [] = scalogram3d_func(dataConfig, analysisConfig, handles)



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


% 2 plots for input data
% 3D plot of coscalogram

plot_title = analysisConfig.plot_title;

plot1_1 = handles.plot1_1;
plot1_5 = handles.plot1_5;
plot2_1 = handles.plot2_1;

setYaxis(1:5) = false;

FntSz = 7;

discard = false;         %whether or not to discard scales less than the Nyquist
byscale = true;         %True == Color coefficients by each scale (not "all" scales)


% calculate time interpolation from  whole signal fragment analysis
[time_interp] = timeinterp(time,-inf, inf, interp_fsample); 

%interpolate signals
y1 = interp1(time, y1, time_interp, 'linear');
y2 = interp1(time, y2, time_interp, 'linear');

%use target sampling frequency
[BCF, wave_name] = morletWaveletDetails(omega_0,Bo,cLevels,interp_fsample,discard);

[ylab,ylab2] = ylabs(BCF,cLevels);


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

% plot first data set
axes(plot1_1);
plot(time_interp, y1, 'r');
set(gca,'FontSize', FntSz);
set(gca,'XTickLabel',{[]}, 'FontSize', FntSz, 'xlim', [tmin, tmax], 'YColor', 'red');
ylabel(sprintf('%s\n%s', y1_title, y1_units));
title( plot_title, 'Interpreter','none' );

% plot second data set
axes(plot1_5);
plot(time_interp, y2, 'b');
set(gca,'FontSize', FntSz);
set(gca,'xlim', [tmin, tmax], 'YColor', 'blue');
ylabel(sprintf('%s\n%s', y2_title, y2_units));

% plot 3D coscalogram
axes(plot2_1);
color_levels = 128;
colormap( jet(color_levels) );
im = abs(c1 .* conj(c2));  %coscalogram
subplot_title =  {[deblank(y1_title) '-' deblank(y2_title)]; 'Coscalogram'};
C = wcodemat(im,color_levels,'row',1);
mesh(time_interp, BCF, im, C);
zlabel(subplot_title);

set(gca,'YDir','reverse','Box','off',...
    'YScale','log','YTick',fliplr(ylab2),'YTickLabel',fliplr(ylab2),...
    'ylim',[min(ylab2) max(ylab2)], 'YMinorGrid','off', 'YMinorTick','off');     
set(gca,'FontSize', FntSz-1); 
set(gca,'FontAngle','italic');
xlim([tmin, tmax]);
xlabel(['Time (' t_units ')']);
ylabel(['Central Frequency (Hz)']);
