function varargout = gui_v2(varargin)
% GUI_V2 MATLAB code for gui_v2.fig
%      GUI_V2, by itself, creates a new GUI_V2 or raises the existing
%      singleton*.
%
%      H = GUI_V2 returns the handle to a new GUI_V2 or the handle to
%      the existing singleton*.
%
%      GUI_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_V2.M with the given input arguments.
%
%      GUI_V2('Property','Value',...) creates a new GUI_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_v2

% Last Modified by GUIDE v2.5 31-Oct-2017 12:50:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_v2_OutputFcn, ...
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


% --- Executes just before gui_v2 is made visible.
function gui_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_v2 (see VARARGIN)

% Choose default command line output for gui_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.angleLabel,'String',get(handles.angSlider,'Value'));

% UIWAIT makes gui_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on angSlider movement.
function angSlider_Callback(hObject, eventdata, handles)

val=get(hObject,'Value');
val=round(val/15)*15
set(handles.angleLabel,'String', val);






% --- Executes during object creation, after setting all properties.
function angSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: angSlider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', -180);
set(hObject, 'Max', 180);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/(360/15) , 10/(360/15) ]);

% --- Executes during object creation, after setting all properties.
function angleLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of playButton
i=1;
%tic
while get(hObject,'Value')==1
    angSlider_Callback(handles.angSlider, eventdata, handles);
    [sig,Fs]=audioread('intro.wav');
    sig=sig(1:400000,1);
    sig=resample(sig,44100,48000);
    chunk=[(i-1)*66200+1, i*66200];
    ang=get(handles.angSlider,'Value');
    ang=round(ang/15)*15;
    b=main_function_v2(ang,1030,chunk,sig);
    player = audioplayer(b,44100);
    while toc<1
        toc
    end
    play(player)
    tic
    i=i+1;
end


% --- Executes during object creation, after setting all properties.
function playButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over playButton.
function playButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
