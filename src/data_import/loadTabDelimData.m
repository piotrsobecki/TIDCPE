function [u, t, txt, units] = loadTabDelimData(dataSourceConfig, tab)
    fname = [dataSourceConfig.path dataSourceConfig.file];
    fsample = dataSourceConfig.fsample;
    uc = dataSourceConfig.columns;
    headerlinesIn = 2;
    [txt,units] = loadTabDelimDataHeaders(fname,tab);
    txt = [txt(1),txt(uc)];
    units = ['seconds',units(uc)];
    importedData = importdata(fname,tab,headerlinesIn);
    importedData = importedData.data;
    dataLen = length(importedData);
    t= [0:1/fsample:dataLen/fsample]';
    u = importedData(:,uc);
    t = t(1:dataLen);
end