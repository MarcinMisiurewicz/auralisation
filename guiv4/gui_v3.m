function varargout = gui_v3(varargin)
% GUI_V3 MATLAB code for gui_v3.fig
%      GUI_V3, by itself, creates a new GUI_V3 or raises the existing
%      singleton*.
%
%      H = GUI_V3 returns the handle to a new GUI_V3 or the handle to
%      the existing singleton*.
%
%      GUI_V3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_V3.M with the given input arguments.
%
%      GUI_V3('Property','Value',...) creates a new GUI_V3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_v3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_v3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_v3

% Last Modified by GUIDE v2.5 11-Nov-2017 20:04:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_v3_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_v3_OutputFcn, ...
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

% --- Executes just before gui_v3 is made visible.
function gui_v3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_v3 (see VARARGIN)

% Choose default command line output for gui_v3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%wczytanie wektorów k¹tów bazy HRIR
base_no=1030;
load(['IRC_', num2str(base_no), '_R_HRIR' '.mat']);

theta=l_hrir_S.elev_v*pi/180;
phi=l_hrir_S.azim_v*pi/180;
hl=l_hrir_S.content_m;
hr=r_hrir_S.content_m;
setappdata(0,'hl',hl);
setappdata(0,'hr',hr);
theta=pi/2-theta; %zmiana 0st wg definicji k¹tów harmonik sferycznych (k¹t bazy HRTF elev=0st dla theta=90

%Wyznaczenie harmonik sferycznych dla k¹tów bazy
for i=1:length(theta) 
    Y00(i)=1/sqrt(4*pi);
    Ym11(i)=sqrt(3/(8*pi))*sin(theta(i))*cos(phi(i));
    Y11(i)=-sqrt(3/(8*pi))*sin(theta(i))*sin(phi(i));
    Y01(i)=sqrt(3/(4*pi))*cos(theta(i));
end

Y=[Y00; Ym11; Y11; Y01];
Y=pinv(Y); %pseudoinwersja
setappdata(0,'Y',Y);

%wczytanie sygna³u
[sig,Fs2]=audioread('intro.wav');
sig=sig(1:1000000,1);
sig=resample(sig,44100,Fs2);
setappdata(0,'sig',sig);

load('impxShort.mat');
imp=impxShort;
setappdata(0,'imp',imp);

for i=1:187
    Hl(i,:)=fft(hl(i,:));
    Hr(i,:)=fft(hr(i,:));
end
setappdata(0,'Hl',Hl);
setappdata(0,'Hr',Hr);

% --- Outputs from this function are returned to the command line.
function varargout = gui_v3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function angSlider_Callback(hObject, eventdata, handles)
val=get(hObject,'Value');
val=round(val/15)*15;
set(handles.angLabel,'string', val);
set(hObject,'Value',val);

% --- Executes during object creation, after setting all properties.
function angSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', -180);
set(hObject, 'Max', 180);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/(360/15) , 10/(360/15) ]);

% --- Executes during object creation, after setting all properties.
function angLabel_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',0);


% --- Executes on button press in togglePlayButton.
% u¿yæ bazy C a nie R - zmniejszyæ rozmiar klatki
% zamiast obcinania dodawanie klatki do koñca poprzedniej
function togglePlayButton_Callback(hObject, eventdata, handles)

myGui=guidata(handles.figure1);
Y=getappdata(0,'Y');
imp=getappdata(0,'imp');
sig=getappdata(0,'sig');

ang1=0;
[hly, hry]=rotateBase(ang1,Y);

%AP=dsp.AudioPlayer;
ADW=audioDeviceWriter;
i=1;
angleHistory=zeros(60,1);
b2=zeros(16384+1708,2);
bBuffer=zeros(3,2);
tic;
chunkLength=2*length(hly);

while get(hObject,'Value')==1 && i*chunkLength<=length(getappdata(0,'sig')) %jeœli Play jest wciœniête i sygna³ do splotu siê ju¿ nie skoñczy³
    
    %czekanie a¿ karta puœci poprzedni¹ klatkê
    while toc<((chunkLength-100)/44100)
        pause(0.0001)
    end
    toc
    %dodanie do klatki do kolejki
    %step(ADW,b2(1700:chunkLength+1700,:)); %na 1700 miejscu klatki nie s¹ ju¿ widoczne efekty brzegowe tylko czysty splot (dobrane eksperymentalnie)
    ADW(b2(1200:17500,:));
    bBuffer=[bBuffer; b2(1200:17500,:)];
    tic
    clear b2;
   
    %obliczanie kolejnej klatki
    ang2=get(handles.angSlider,'Value'); %pobranie wartoœci suwaka
    sigChunk=sig((i-1)*chunkLength+1:i*chunkLength,:); %wybranie z sygna³u klatki odpowiadaj¹cej aktualnej iteracji
    
    if ang2~=ang1 %obliczenie obróconej bazy HRIR*Y jeœli suwak zmieni³ po³o¿enie
        [hly, hry]=rotateBase(ang2,Y); 
    end
    
    b1=zeros(size(imp,1),2);
    
    for k=1:4 %w³aœciwa filtracja impulsu filtrem HRIR*Y
             b1(:,1)=b1(:,1)+fftfilt(hly(:,k),imp(:,k));
             b1(:,2)=b1(:,2)+fftfilt(hry(:,k),imp(:,k));
    end
  
    b2(:,1)=conv(b1(:,1),sigChunk); %splot odfiltrowanego impulsu z sygna³em
    b2(:,2)=conv(b1(:,2),sigChunk);

    %rysowanie wykresów    
    
    
    axes(handles.bplot)
    figure(2)
    plot(bBuffer)
    
%     
%     axes(handles.angleplot)
%     angleHistory(i)=ang1;
%     plot(angleHistory)
%     ylim([-200 200])
%     
%     axes(handles.anglePolarPlot)
%     polar([ang1*pi/180, ang1*pi/180],[0, 1])
%   
    drawnow %przerwanie i wykonanie zaleg³ych Callbacków - suwaka i przycisku Play
    i=i+1;
    ang1=ang2;

end

release(ADW);
set(hObject,'Value',0)
