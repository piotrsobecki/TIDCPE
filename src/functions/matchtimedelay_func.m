function [delay] = matchtimedelay_func( dataConfig, analysisConfig, handles )
    [ y1,y2,cwtShift,delay ] = matchtimedelay_part( dataConfig, analysisConfig );
    dataConfig.y1.y=y1;
    dataConfig.y2.y=y2;
    scalogram2d_func(dataConfig,analysisConfig,handles);
end

