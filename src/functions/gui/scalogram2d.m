function varargout = scalogram2d(varargin)
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

% Last Modified by GUIDE v2.5 17-Aug-2015 00:29:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scalogram2d_OpeningFcn, ...
                   'gui_OutputFcn',  @scalogram2d_OutputFcn, ...
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
function scalogram2d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for scalogram2d
handles.output = hObject;

dataConfig = varargin{1};
analysisConfig = varargin{2};
scalogram2d_func(dataConfig, analysisConfig,handles);

params_str = stringify_params(dataConfig,analysisConfig,['fileName','tmin','tmax','interp_fsample','cLevels','Bo','omega_0']);
set(findobj('Tag','description'),'String',params_str);

set(gcf, 'name', analysisConfig.plot_title);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scalogram2d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scalogram2d_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function saveFigure_ClickedCallback(hObject, eventdata, handles)
fileName = uiputfile('*.fig','Save Figure As');
hgsave(gcf,fileName)
% hObject    handle to saveFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
