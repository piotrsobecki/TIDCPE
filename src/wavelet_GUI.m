function varargout = wavelet_GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wavelet_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @wavelet_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% Function calls that may need to be changed
%%%%%%%%%%%%%%%%%%%%%%%%%



function wavelet_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for wavelet_GUI
    handles.output = hObject;
    handles.t_min = 20;
    handles.t_max = 40;
    handles.N = 500;
    handles.cLevelsStr = '1:10:400';
    handles.cLevels = 1:10:400;
    handles.columns_str = '2,3';
    handles.Bo = 1; % bandwidth
    handles.omega_0 = 6; % center frequency
    handles.tN = 500;
    handles.sN = 1;  
    handles.interpolation_sampling_rate = 1500;
    eval(['handles.t_min = ' num2str(handles.t_min) ';']);
    eval(['handles.t_max = ' num2str(handles.t_max) ';']);
    eval(['handles.columns = [' handles.columns_str '];']);
    guidata(hObject, handles);

        
function showDefaultData(handles)
    setInputTagValue('data_columns',handles.columns_str);
    setInputTagValue('scales',handles.cLevelsStr);
    setInputTagValue('sampling_rate',handles.N);
    setInputTagValue('interpolation_sampling_rate',handles.interpolation_sampling_rate);
    setInputTagValue('bandwidth',handles.Bo);
    setInputTagValue('center_frequency',handles.omega_0);
    setInputTagValue('time_smoothing',handles.tN);
    setInputTagValue('scale_smoothing',handles.sN);
    setInputTagValue('minimum_time',num2str(handles.t_min));
    setInputTagValue('maximum_time',num2str(handles.t_max));
    set_frequency(handles);


function varargout = wavelet_GUI_OutputFcn(hObject, eventdata, handles) 
    showDefaultData(handles)
    guidata(hObject, handles);
    varargout{1} = handles.output;

    
% --------------------------------------------------------------------  

function setInputTagValue(tag,value)
    set(findobj('Tag',tag),'String',value);

% --------------------------------------------------------------------     
    




% --------------------------------------------------------------------  
function  [analysisConfig] = getAnalysisConfig(handles)
    analysisConfig = AnalysisConfig();
    analysisConfig.interp_fsample = handles.interpolation_sampling_rate;
    analysisConfig.tmin = handles.t_min;
    analysisConfig.tmax = handles.t_max;
    analysisConfig.cLevels = handles.cLevels; 
    analysisConfig.Bo = handles.Bo; 
    analysisConfig.omega_0 = handles.omega_0; 
    analysisConfig.tN = handles.tN; 
    analysisConfig.sN = handles.sN;
    
    
    
    
function  [dataConfig] = getDataConfig(handles)
    dataSourceConfig=DataSourceConfig(handles.path,handles.file,handles.columns,handles.N);
     switch handles.dataSource
        case 'physionet'
             [data, time, labels, units] =  loadTabDelimData(dataSourceConfig, '\t');
     end       
    timeSignal =  SignalConfig(time,labels{1},units{1});
    y1Signal =    SignalConfig(data(:,1),labels{2},units{2});
    y2Signal =    SignalConfig(data(:,2),labels{3},units{3});
    dataConfig =  DataConfig(handles.file,timeSignal,y1Signal,y2Signal,handles.N);
    
    
    
    
function [handles,dataConfig] = setDataConfigProperties(handles,dataConfig)
    t = dataConfig.time.y;
    handles.t_min = t(1);
    handles.t_max = t(length(t));

% --------------------------------------------------------------------



    
    
    
% --------------------------------------------------------------------
function save_figure_Callback(hObject, eventdata, handles)

    
function sampling_rate_Callback(hObject, eventdata, handles)
    handles.N = str2double(get(hObject, 'String'));
    
    
    dataConfig = getDataConfig(handles);
    [handles,dataConfig] = setDataConfigProperties(handles,dataConfig);
    showDefaultData(handles);

    
    guidata(hObject, handles);

function sampling_rate_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function data_columns_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function data_columns_Callback(hObject, eventdata, handles)
    columns_str = get(hObject, 'String');
    try eval(['handles.columns = [' columns_str '];']); end
    guidata(hObject, handles);
% --------------------------------------------------------------------    


% --------------------------------------------------------------------


function set_frequency(handles)
    interp_fsample = handles.interpolation_sampling_rate;
    cLevels = handles.cLevels;
    Bo = handles.Bo;
    omega_0 = handles.omega_0;
    [BCF, wave_name] = morletWaveletDetails(omega_0,Bo,cLevels,interp_fsample,false);
    [ylab,ylab2,ylabScales] = ylabs(BCF,cLevels);    
    setInputTagValue('frequency',sprintf('Frequency range: %.1f Hz - %.1f Hz',  ylab2(1), ylab2(length(ylab))));

function interpolation_sampling_rate_Callback(hObject, eventdata, handles)
   handles.interpolation_sampling_rate = str2double(get(hObject, 'String'));
   set_frequency(handles);
   guidata(hObject, handles);

function interpolation_sampling_rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function scales_Callback(hObject, eventdata, handles)
    cLevelsStr = get(hObject, 'String');
    cLevels = eval(cLevelsStr);
    handles.cLevels = cLevels;
    handles.cLevelsStr = cLevelsStr;
    set_frequency(handles);
    guidata(hObject, handles);

function scales_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function maximum_time_Callback(hObject, eventdata, handles)
    handles.t_max = str2double(get(hObject, 'String'));
    guidata(hObject, handles);

function maximum_time_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function minimum_time_Callback(hObject, eventdata, handles)
    handles.t_min = str2double(get(hObject, 'String'));
    guidata(hObject, handles);

function minimum_time_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function data_file_Callback(hObject, eventdata, handles)
    handles.data_file = get(hObject, 'String');
    try handles.data = loadColumnData(handles.data_file, handles.columns, '\t', 2); end
    guidata(hObject, handles);

function data_file_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function bandwidth_Callback(hObject, eventdata, handles)
    handles.Bo = str2double(get(hObject, 'String'));
    set_frequency(handles);
    guidata(hObject, handles);

function bandwidth_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function center_frequency_Callback(hObject, eventdata, handles)
    handles.omega_0 = str2double(get(hObject, 'String'));
    set_frequency(handles);
    guidata(hObject, handles);

function center_frequency_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function time_smoothing_Callback(hObject, eventdata, handles)
    handles.tN = str2double(get(hObject, 'String'));
    guidata(hObject, handles);

function time_smoothing_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function scale_smoothing_Callback(hObject, eventdata, handles)
    handles.sN = str2double(get(hObject, 'String'));
    guidata(hObject, handles);

function scale_smoothing_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
% --------------------------------------------------------------------




% --- Executes on button press in openPlot2.
function openPlot2_Callback(~, ~, handles)
    scalogramData_GUI( ...
        handles.time, ...
        handles.data(:,1), ...
        handles.name_1,...
        handles.t_min, ...
        handles.t_max, ...
        handles.N, ...
        handles.cLevels, ...
        handles.Bo, ...
        handles.omega_0);

    
    
    
% --------------------------------------------------------------------
function sac_Callback(hObject, ~, handles)
    dataConfig = getDataConfig(handles);
    analysisConfig = getAnalysisConfig(handles);
    analysisConfig.plot_title = sprintf('%s and %s coscalogram', dataConfig.y1.title, dataConfig.y2.title);
    scalogram2d(dataConfig,analysisConfig);
    guidata(hObject, handles);

function c3d_Callback(hObject, ~, handles)
    dataConfig = getDataConfig(handles);
    analysisConfig = getAnalysisConfig(handles);
    analysisConfig.plot_title = sprintf('%s and %s 3d coscalogram', dataConfig.y1.title, dataConfig.y2.title);
    scalogram3d(dataConfig,analysisConfig);
    guidata(hObject, handles);

function wccc_Callback(hObject, ~, handles)
    dataConfig = getDataConfig(handles);
    analysisConfig = getAnalysisConfig(handles);
    analysisConfig.plot_title = sprintf('Correlation and cross coherence of %s and %s', dataConfig.y1.title, dataConfig.y2.title);
    wlcc_cwcf(dataConfig,analysisConfig);
    guidata(hObject, handles);

function wc_Callback(hObject, ~, handles)
    dataConfig = getDataConfig(handles);
    analysisConfig = getAnalysisConfig(handles);
    analysisConfig.plot_title = sprintf('Coherence of %s and %s', dataConfig.y1.title, dataConfig.y2.title);
    wavelet_coherence(dataConfig,analysisConfig);
    guidata(hObject, handles);

function wb_Callback(hObject, ~, handles)
    dataConfig = getDataConfig(handles);
    analysisConfig = getAnalysisConfig(handles);
    analysisConfig.plot_title = sprintf('Bicoherence of %s and %s', dataConfig.y1.title, dataConfig.y2.title);
    wavelet_bicoherence(dataConfig,analysisConfig);
    guidata(hObject, handles);
    
    
function cc_Callback(hObject, ~, handles)
    dataConfig = getDataConfig(handles);
    analysisConfig = getAnalysisConfig(handles);
    analysisConfig.plot_title =  sprintf('%s and %s cross correlation', dataConfig.y1.title, dataConfig.y2.title); 
    matchtimedelay(dataConfig,analysisConfig);
    guidata(hObject, handles);
    
function ccv_Callback(hObject, eventdata, handles)
    dataConfig = getDataConfig(handles);
    analysisConfig = getAnalysisConfig(handles);
    analysisConfig.plot_title =  sprintf('%s and %s vectorised cross correlation', dataConfig.y1.title, dataConfig.y2.title);
    matchtimedelay_forfrequency(dataConfig,analysisConfig);
    guidata(hObject, handles);
    

function od_Callback(hObject, eventdata, handles)
    [file,path] = uigetfile('*.txt');
    if ~isequal(file, 0)
        handles.dataSource='physionet';
        handles.file=file;
        handles.path=path;       
        setInputTagValue('openedDataFile',file);
        
        dataConfig = getDataConfig(handles);
        [handles,dataConfig] = setDataConfigProperties(handles,dataConfig);
        showDefaultData(handles);
        
        guidata(hObject, handles);
    end  


function Untitled_4_Callback(hObject, eventdata, handles)


function Untitled_5_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
