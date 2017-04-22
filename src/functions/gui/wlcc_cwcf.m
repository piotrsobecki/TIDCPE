function varargout = wlcc_cwcf(varargin)
%WLCC_CWCF M-file for wlcc_cwcf.fig
%      WLCC_CWCF, by itself, creates a new WLCC_CWCF or raises the existing
%      singleton*.
%
%      H = WLCC_CWCF returns the handle to a new WLCC_CWCF or the handle to
%      the existing singleton*.
%
%      WLCC_CWCF('Property','Value',...) creates a new WLCC_CWCF using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to wlcc_cwcf_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WLCC_CWCF('CALLBACK') and WLCC_CWCF('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WLCC_CWCF.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wlcc_cwcf

% Last Modified by GUIDE v2.5 17-Aug-2015 00:31:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wlcc_cwcf_OpeningFcn, ...
                   'gui_OutputFcn',  @wlcc_cwcf_OutputFcn, ...
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


% --- Executes just before wlcc_cwcf is made visible.
function wlcc_cwcf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for wlcc_cwcf
handles.output = hObject;

dataConfig = varargin{1};
analysisConfig = varargin{2};
set(gcf, 'name', analysisConfig.plot_title);

wlcc_cwcf_func( dataConfig, analysisConfig, handles);
params_str = stringify_params(dataConfig,analysisConfig,['fileName','interp_fsample','tmin','tmax','cLevels','Bo','omega_0']);
set(findobj('Tag','description'),'String',params_str);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wlcc_cwcf wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wlcc_cwcf_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function saveFigure_ClickedCallback(hObject, eventdata, handles)
fileName = uiputfile('*.fig','Save Figure As');
hgsave(gcf,fileName)
