function varargout = matchtimedelay(varargin)
%SCALOGRAM2D M-file for scalogram2d.fig
%      SCALOGRAM2D, by itself, creates a new SCALOGRAM2D or raises the existing
%      singleton*.
%
%      H = SCALOGRAM2D returns the handle to a new SCALOGRAM2D or the handle to
%      the existing singleton*.
%
%      SCALOGRAM2D('Property','Value',...) creates a new SCALOGRAM2D using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to scalogram2d_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SCALOGRAM2D('CALLBACK') and SCALOGRAM2D('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SCALOGRAM2D.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scalogram2d

% Last Modified by GUIDE v2.5 21-Sep-2015 20:03:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matchtimedelay_OpeningFcn, ...
                   'gui_OutputFcn',  @matchtimedelay_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before scalogram2d is made visible.
function matchtimedelay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for scalogram2d
handles.output = hObject;
handles.dataConfig = varargin{1};
handles.analysisConfig = varargin{2};
handles.analysisConfig.minDelaySec=0;
handles.analysisConfig.maxDelaySec=0;
setInputTagValue('minDelay',0);
setInputTagValue('maxDelay',0);

set(gcf, 'name', handles.analysisConfig.plot_title);
scalogram2d_func(handles.dataConfig, handles.analysisConfig,handles);
params_str = stringify_params( handles.dataConfig, handles.analysisConfig,['fileName','tmin','tmax','interp_fsample','cLevels','Bo','omega_0']);
set(findobj('Tag','description'),'String',params_str);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scalogram2d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = matchtimedelay_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function setInputTagValue(tag,value)
    set(findobj('Tag',tag),'String',value);
    
    
% --------------------------------------------------------------------
function saveFigure_ClickedCallback(hObject, eventdata, handles)
fileName = uiputfile('*.fig','Save Figure As');
hgsave(gcf,fileName)


function minDelay_Callback(hObject, eventdata, handles)
handles.analysisConfig.minDelaySec = str2double(get(hObject, 'String'));
guidata(hObject, handles);
    
function minDelay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxDelay_Callback(hObject, eventdata, handles)
handles.analysisConfig.maxDelaySec = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function maxDelay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in analyze.
function analyze_Callback(hObject, eventdata, handles)
% hObject    handle to analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delay = matchtimedelay_func(handles.dataConfig, handles.analysisConfig,handles);
y1_title = handles.dataConfig.y1.title;
y2_title = handles.dataConfig.y2.title;
plot_title = sprintf('%s and %s cross correlation', y1_title, y2_title);
title( plot_title, 'Interpreter','none' );
setInputTagValue('detectedDelay',delay);



function detectedDelay_Callback(hObject, eventdata, handles)

function detectedDelay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in analyze.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


