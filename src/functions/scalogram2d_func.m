function [] = scalogram2d_func(dataConfig, analysisConfig, handles)


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


% creates 5 figures within GUI:
% 2 plots of the original data
% 2 scalograms - 1 for each data set
% plot of coscalogram


plot_title =analysisConfig.plot_title; % sprintf('%s and %s coscalogram', y1_title, y2_title);


plot1_1 = handles.plot1_1;
plot1_2 = handles.plot1_2;
plot1_3 = handles.plot1_3;
plot1_4 = handles.plot1_4;
plot1_5 = handles.plot1_5;

setYaxis(1:5) = false;

FntSz = 9;

discard = false;       %whether or not to discard scales less than the Nyquist
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

[ylab,ylab2,ylabScales] = ylabs(BCF,cLevels);

% plot first data set
axes(plot1_1);
plot(time_interp, y1, 'r');
set(gca,'FontSize', FntSz);
set(gca,'XTickLabel',{[]}, 'FontSize', FntSz, 'xlim', [tmin, tmax], 'YColor', 'red');
ylabel(sprintf('%s\n%s', y1_title, y1_units));
title( plot_title, 'Interpreter','none' );

% plot second data set
axes(plot1_2);
plot(time_interp, y2, 'b');
set(gca,'FontSize', FntSz);
set(gca,'xlim', [tmin, tmax], 'YColor', 'blue');
ylabel(sprintf('%s\n%s', y2_title, y2_units));

% plot first scalogram
axes(plot1_3);
color_levels = 128;
colormap( jet(color_levels) );
im = wcodemat(abs(c1).^2,color_levels,'row',1);
image(time_interp, cLevels, im);
set(gca,'FontSize', FntSz);
ylabel(sprintf('%s Scalogram\nFrequency Hz', y1_title));
xlim([tmin, tmax]);
%ylabStr = num2str(ylab2,'%4.1f|');
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

%set(gca,'YTick',ylab,'YTickLabel',num2str(ylab));
%set(gca,'XTick',[]);

% plot second scalogram
axes(plot1_4);
colormap( jet(color_levels) );
im = wcodemat(abs(c2).^2,color_levels,'row',1);
image(time_interp, cLevels, im);
set(gca,'FontSize', FntSz);
ylabel(sprintf('%s Scalogram\nFrequency Hz', y2_title));
xlim([tmin, tmax]);
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

% plot coscalogram
axes(plot1_5);
colormap( jet(color_levels) );
im = wcodemat(c1.*conj(c2),color_levels,'row',1);
image(time_interp, cLevels, im);
set(gca,'FontSize', FntSz);
ylabel(sprintf('%s-%s Cocalogram\nFrequency Hz', y1_title, y2_title));
xlim([tmin, tmax]);
set(gca,'YTick', ylab,'YTickLabel',ylab2);   
xlabel(['Time ' t_units ] );
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













% plot first scalogram
figure;
axes;
color_levels = 128;
colormap( jet(color_levels) );
im = wcodemat(abs(c1).^2,color_levels,'row',1);
image(time_interp, cLevels, im);
set(gca,'FontSize', FntSz);
ylabel(sprintf('%s Scalogram\nFrequency Hz', y1_title));
xlim([tmin, tmax]);
%ylabStr = num2str(ylab2,'%4.1f|');
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

%set(gca,'YTick',ylab,'YTickLabel',num2str(ylab));
%set(gca,'XTick',[]);

% plot second scalogram
figure;
axes;
colormap( jet(color_levels) );
im = wcodemat(abs(c2).^2,color_levels,'row',1);
image(time_interp, cLevels, im);
set(gca,'FontSize', FntSz);
ylabel(sprintf('%s Scalogram\nFrequency Hz', y2_title));
xlim([tmin, tmax]);
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

