% Program scalogram2.m
% Programmer: Bonnie Jonkman
% Date: 17 August 2004
% Purpose: Analysis of turbine response with scalograms of two signals (y1
% & y2) and their coscalogram.
function [time_interp,from,to,total,tmin,tmax] = timeinterp(time, tmin, tmax, fsample)
tmin1 = time(1);                %min time value in event
tmax1 = time(length(time));     %max time value in event (l.u.b. of max time & NaN for level 9)


%Linearly Interpolate Loads so that wavelet detail is better seen
time_interp = [ tmin1:1/fsample:tmax1 ]';

%Continuous wavelet transform

% chop off the ends that we don't want to see...
tmin = max( [ tmin, time(1) ] );                %min time value in event
tmax = min( [ tmax, time(length(time)) ] );     %max time value in event (l.u.b. of max time & NaN for level 9)

mask        = time_interp>=tmin & time_interp<=tmax;
from = find(mask,1, 'first');
to = find(mask,1, 'last');
total = length(mask);
time_interp = time_interp(mask);