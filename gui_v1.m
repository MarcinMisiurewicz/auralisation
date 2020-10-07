function varargout = gui_v1(varargin)
% GUI_V1 MATLAB code for gui_v1.fig
%      GUI_V1, by itself, creates a new GUI_V1 or raises the existing
%      singleton*.
%
%      H = GUI_V1 returns the handle to a new GUI_V1 or the handle to
%      the existing singleton*.
%
%      GUI_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_V1.M with the given input arguments.
%
%      GUI_V1('Property','Value',...) creates a new GUI_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_v1

% Last Modified by GUIDE v2.5 28-Oct-2017 14:42:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before gui_v1 is made visible.
function gui_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_v1 (see VARARGIN)

% Choose default command line output for gui_v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.angleLabel,'String',get(handles.slider,'Value'));

% UIWAIT makes gui_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=get(hObject,'Value');
val=round(val/15)*15;
set(handles.angleLabel,'string', val);


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', -180);
set(hObject, 'Max', 180);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/(360/15) , 10/(360/15) ]);


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ang=get(handles.slider,'Value'); %pobranie k¹ta z pozycji slidera
    b=main_function(ang,1030);
    soundsc(b,44100)

% --- Executes during object creation, after setting all properties.
function angleLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over angleLabel.
function angleLabel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to angleLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
