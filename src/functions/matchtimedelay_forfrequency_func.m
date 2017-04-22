function [shifts] = matchtimedelay_forfrequency_func( dataConfig, analysisConfig, handles )
    [ y1, y2,time_interp,tmin,tmax, c1,c2,shifts ] = matchtimedelay_forfrequency_part( dataConfig, analysisConfig );
    
    
    
    
    time = dataConfig.time.y;
    y1_title = dataConfig.y1.title;
    y2_title = dataConfig.y2.title;
    y1_units = dataConfig.y1.unit;
    y2_units = dataConfig.y2.unit;
    t_units = dataConfig.time.unit;
    fsample = dataConfig.fsample;


interp_fsample = analysisConfig.interp_fsample;
    cLevels = analysisConfig.cLevels;
    Bo = analysisConfig.Bo;
    omega_0 = analysisConfig.omega_0;

    
    plot_title = analysisConfig.plot_title;
    

    plot1_1 = handles.plot1_1;
    plot1_2 = handles.plot1_2;
    plot1_3 = handles.plot1_3;
    plot1_4 = handles.plot1_4;
    plot1_5 = handles.plot1_5;


    FntSz = 9;

   
    
    
    [BCF,wave_name] = morletWaveletDetails(omega_0,Bo, cLevels,time,interp_fsample,true);

    [ylab,ylab2] = ylabs(BCF,cLevels);


    
    
    
    
    
    
    ylab2Shifts = [];   

    for k = 1:length(ylab2)
        shiftForLevel = -1 * shifts(k)/interp_fsample;
        ylab2Shifts{k} =  [num2str(ylab2(k),'%4.1f'), ' | ',num2str(shiftForLevel)];
    end

    
    
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
    ylabel(sprintf('%s Scalogram\nFrequency (Hz)', y1_title));
    xlim([tmin, tmax]);
    set(gca,'YTick', ylab,'YTickLabel',ylab2);    

    % plot second scalogram
    axes(plot1_4);
    
    
    colormap( jet(color_levels) );
    im = wcodemat(abs(c2).^2,color_levels,'row',1);
    image(time_interp, cLevels, im);
    set(gca,'FontSize', FntSz);
    ylabel(sprintf('%s Scalogram\nFreq (Hz) | Delay (s)', y2_title));
    xlim([tmin, tmax]);

    set(gca,'YTick', ylab,'YTickLabel',ylab2Shifts);   
 
    
    
    
    
    % plot coscalogram
    axes(plot1_5);
  
    colormap( jet(color_levels) );
    im = wcodemat(c1.*conj(c2),color_levels,'row',1);
    image(time_interp, cLevels, im);
    set(gca,'FontSize', FntSz);
    ylabel(sprintf('%s-%s Cocalogram\nFreq (Hz) | Delay (s)', y1_title, y2_title));
    xlim([tmin, tmax]);
    set(gca,'YTick', ylab,'YTickLabel',ylab2Shifts);   
    xlabel(['Time ' t_units ] ); 
   

end

