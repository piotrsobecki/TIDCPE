function varargout = scalogram3d(varargin)
%SCALOGRAM3D2 M-file for scalogram3d2.fig
%      SCALOGRAM3D2, by itself, creates a new SCALOGRAM3D2 or raises the existing
%      singleton*.
%
%      H = SCALOGRAM3D2 returns the handle to a new SCALOGRAM3D2 or the handle to
%      the existing singleton*.
%
%      SCALOGRAM3D2('Property','Value',...) creates a new SCALOGRAM3D2 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to scalogram3d2_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SCALOGRAM3D2('CALLBACK') and SCALOGRAM3D2('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SCALOGRAM3D2.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scalogram3d2

% Last Modified by GUIDE v2.5 17-Aug-2015 00:31:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scalogram3d_OpeningFcn, ...
                   'gui_OutputFcn',  @scalogram3d_OutputFcn, ...
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


% --- Executes just before scalogram3d2 is made visible.
function scalogram3d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for scalogram3d2
handles.output = hObject;

dataConfig = varargin{1};
analysisConfig = varargin{2};
set(gcf, 'name', analysisConfig.plot_title);
scalogram3d_func(dataConfig,analysisConfig,handles);
params_str = stringify_params(dataConfig,analysisConfig,['fileName','interp_fsample','tmin','tmax','cLevels','Bo','omega_0']);
set(findobj('Tag','description'),'String',params_str);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scalogram3d2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scalogram3d_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function saveFigure_ClickedCallback(hObject, eventdata, handles)
fileName = uiputfile('*.fig','Save Figure As');
hgsave(gcf,fileName)
