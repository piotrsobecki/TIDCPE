function varargout = wavelet_coherence(varargin)
%WAVELET_COHERENCE M-file for wavelet_coherence.fig
%      WAVELET_COHERENCE, by itself, creates a new WAVELET_COHERENCE or raises the existing
%      singleton*.
%
%      H = WAVELET_COHERENCE returns the handle to a new WAVELET_COHERENCE or the handle to
%      the existing singleton*.
%
%      WAVELET_COHERENCE('Property','Value',...) creates a new WAVELET_COHERENCE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to wavelet_coherence_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WAVELET_COHERENCE('CALLBACK') and WAVELET_COHERENCE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WAVELET_COHERENCE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wavelet_coherence

% Last Modified by GUIDE v2.5 21-Sep-2015 19:07:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wavelet_coherence_OpeningFcn, ...
                   'gui_OutputFcn',  @wavelet_coherence_OutputFcn, ...
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


% --- Executes just before wavelet_coherence is made visible.
function wavelet_coherence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for wavelet_coherence
handles.output = hObject;

dataConfig = varargin{1};
analysisConfig = varargin{2};
set(gcf, 'name', analysisConfig.plot_title);
wavelet_coherence_func(dataConfig,analysisConfig,handles);
params_str = stringify_params(dataConfig,analysisConfig,['fileName','interp_fsample','tmin','tmax','cLevels','Bo','omega_0','tN','sN']);
set(findobj('Tag','description'),'String',params_str);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wavelet_coherence wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wavelet_coherence_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function saveFigure_ClickedCallback(hObject, eventdata, handles)
fileName = uiputfile('*.fig','Save Figure As');
hgsave(gcf,fileName)
