function varargout = gui_v6(varargin)
% GUI_V6 MATLAB code for gui_v6.fig
%      GUI_V6, by itself, creates a new GUI_V6 or raises the existing
%      singleton*.
%
%      H = GUI_V6 returns the handle to a new GUI_V6 or the handle to
%      the existing singleton*.
%
%      GUI_V6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_V6.M with the given input arguments.
%
%      GUI_V6('Property','Value',...) creates a new GUI_V6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_v6_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_v6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_v6

% Last Modified by GUIDE v2.5 02-Dec-2017 20:04:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_v6_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_v6_OutputFcn, ...
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

%dodac przebiegi overlap save'a i porownanie zlozonosci obliczneiowej obu

% --- Executes just before gui_v6 is made visible.
function gui_v6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handl es    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_v6 (see VARARGIN)

% Choose default command line output for gui_v6

handles.output = hObject;


%wczytanie wektorów k¹tów bazy HRIR
base_no=1057;
load(['IRC_', num2str(base_no), '_C_HRIR' '.mat']);

theta=l_eq_hrir_S.elev_v*pi/180;
phi=l_eq_hrir_S.azim_v*pi/180;
hl=l_eq_hrir_S.content_m;
hr=r_eq_hrir_S.content_m;
setappdata(0,'hl',hl);
setappdata(0,'hr',hr);
setappdata(0,'thetaapp',theta);
setappdata(0,'phiapp',phi);
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
sig=sig(:,1);
sig=resample(sig,44100,Fs2);
setappdata(0,'sig',sig);
% load('impxShort.mat');
% imp=impxShort;
% setappdata(0,'imp',imp);

for i=1:187
    Hl(i,:)=fft(hl(i,:));
    Hr(i,:)=fft(hr(i,:));
end
setappdata(0,'Hl',Hl);
setappdata(0,'Hr',Hr);

% for i=1:10
%    [ytemp, fs]=audioread(['imp_no_' num2str(i) '.wav']);
%    for k=1:4
%         y(:,k)=resample(ytemp(:,k),44100,fs);
%    end
%    y2=y(1160:end,:);
%    impulseMap(:,:,i)=y2(1:2^17,:,:);
% end

load('impulseMap')
impulseMap=impulseMap(1:2^17,:,:);

% impulseMap=zeros(2^17,4,10);
% for i=1:10
%     impulseMap(1,1,i)=1;
%     impulseMap(1,2,i)=1;
% end

% figure(2)
% plot(impulseMap(:,1,6))
setappdata(0,'impulseMap',impulseMap);

filFoto=imread('map.jpg');
axes(handles.posMap)
imshow(filFoto)
set(handles.pb1,'Value',1)

xy=imread('xy.jpg');
axes(handles.ax_xy)
imshow(xy)

zx=imread('zx.jpg');
axes(handles.ax_zx)
imshow(zx)

zy=imread('zy.jpg');
axes(handles.ax_zy)
imshow(zy)


% % Create variables and timer objeect
% handles.xData=[];
% handles.yData=[];
% % Initialize the plot, then define and link the data sources
% plot(handles.angleplot,1,1,'LineWidth',2);
% set(get(handles.angleplot,'Children'),'XDataSource','handles.xData');
% set(get(handles.angleplot,'Children'),'YDataSource','handles.yData');
% linkdata on;

% angleHistory=[];
% angleXHistory=[];


guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = gui_v6_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function v2AngSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', -90);
set(hObject, 'Max', 90);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/(180/15) , 10/(180/15) ]);

% --- Executes during object creation, after setting all properties.
function v2AngLabel_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',0);

% --- Executes during object creation, after setting all properties.
function hAngSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', -180);
set(hObject, 'Max', 180);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/(360/15) , 10/(360/15) ]);

% --- Executes during object creation, after setting all properties.
function hAngLabel_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',0);

% --- Executes during object creation, after setting all properties.
function vAngSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', -45);
set(hObject, 'Max', 90);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/(135/15) , 10/(135/15) ]);

% --- Executes during object creation, after setting all properties.
function vAngLabel_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',0);

% --- Executes on slider movement.
function hAngSlider_Callback(hObject, eventdata, handles)
val=get(hObject,'Value');
val=round(val/15)*15;
set(handles.hAngLabel,'string', val);
set(hObject,'Value',val);

% --- Executes on slider movement.
function vAngSlider_Callback(hObject, eventdata, handles)
val=get(hObject,'Value');
val=round(val/15)*15;
set(handles.vAngLabel,'string', val);
set(hObject,'Value',val);

% --- Executes on slider movement.
function v2AngSlider_Callback(hObject, eventdata, handles)
val=get(hObject,'Value');
val=round(val/15)*15;
set(handles.v2AngLabel,'string', val);
set(hObject,'Value',val);

% --- Executes on button press in togglePlayButton.
function togglePlayButton_Callback(hObject, eventdata, handles)
myGui=guidata(handles.figure1);
Y=getappdata(0,'Y'); %macierz harmonik sferycznych
impulseMap=getappdata(0,'impulseMap'); %mapa impulsów w B-formacie
sig=getappdata(0,'sig'); %œcie¿ka muzyczna

hAng1=0; %k¹t obrotu w p³aszczyŸnie horyzontalnej
vAng1=0; %k¹t obrotu w p³aszczyŸnie œrodkowej
v2Ang1=0; %k¹t obrotu w p³aszczyŸnie przedniej
[hly, hry]=rotateBase_v6(hAng1,vAng1,v2Ang1, Y); %mno¿enie macierzy HRIR i Y + obrót (potrzebne do pierwszej iteracji, dalej program robi to w while'u)

ADW=audioDeviceWriter;
i=1;
% angleHistory=[];
% angleXHistory=[];
chunkLength=2^16; %definicja d³ugoœci filtrowanego bloku
b2=zeros(chunkLength,2);
bBuffer=[]; %bufor próbek aktualnej iteracji
allBuffer=[]; %wektor wszystkich przetworzonych próbek od naciœniêcia Play
bBufferOld=[]; %bufor próbek poprzedniej iteracji
flag=0; %czy pozycja siê zmieni³a od ostatniej iteracji
pos1=1; %pozycja w sali
tic;

angleHistory=[];
angleXHistory=[];
% assignin('base','angleHistory',angleHistory);
% assignin('base','angleXHistory',angleXHistory);
% set(hLine,'YDataSource','angleHistory')
% set(hLine,'XDataSource','angleXHistory')
% linkdata on
while get(hObject,'Value')==1 && i*chunkLength<=length(sig)-2*chunkLength %jeœli Play jest wciœniête i sygna³ do splotu siê ju¿ nie skoñczy³
% if i==20
%     profile on
% end
i
    %pobranie wartoœci suwaków
    hAng2=get(handles.hAngSlider,'Value'); 
    vAng2=get(handles.vAngSlider,'Value');
    v2Ang2=get(handles.v2AngSlider,'Value');
    pos2=str2double(get(handles.pos_label,'String'));
    
    drawnow %przerwanie i wykonanie zaleg³ych Callbacków - suwaka i przycisku Play

    %obliczenie obróconej bazy HRIR*Y jeœli jakiolwiek suwak zmieni³
    %po³o¿enie (Y to macierz harmonik)
    if hAng2~=hAng1 || vAng2~=vAng1 || v2Ang2~=v2Ang1 
        [hly, hry]=rotateBase_v6(hAng2,vAng2,v2Ang2, Y); %funkcja rotateBase oprócz obrotu, dodatkowo wymna¿a macierze Y i HRIR
        flag=1;
    end

    b1=zeros(length(impulseMap(:,1,1)),2);
    for k=1:4 %w³aœciwa filtracja impulsu (w B-formacie) filtrem HRIR*Y - konwersja B2Binaural
        b1(:,1)=b1(:,1)+fftfilt(hly(:,k),impulseMap(:,k,pos2));
        b1(:,2)=b1(:,2)+fftfilt(hry(:,k),impulseMap(:,k,pos2));
    end    
    b1=b1/4
    
    % splot impulsu binauralnego ze œcie¿k¹ muzyczn¹
    % if jest dodany tylko ze wzglêdu na u¿ycie overlap-save'a po to, ¿eby program ³agodnie zaczyna³
    % odtwarzanie. Przez pierwsze kilka iteracji program korzysta z
    % pierwszego warunku, a potem w stanie ustalonym korzysta, ju¿ do
    % koñca, z drugiego.
    if i<=length(impulseMap)/chunkLength
        sigChunk=sig(1:i*chunkLength); %wybranie z sygna³u klatki odpowiadaj¹cej aktualnej iteracji
        b2=fftfilt(b1(:,1),sigChunk);
        b2(:,2)=fftfilt(b1(:,2),sigChunk);
        bBuffer=b2((i-1)*chunkLength+1:i*chunkLength,:)/30;
    else
        sigChunk=sig((i-1)*chunkLength+1-length(impulseMap(:,1,1)):i*chunkLength); %wybranie z sygna³u klatki odpowiadaj¹cej aktualnej iteracji
        b2=fftfilt(b1(:,1),sigChunk);
        b2(:,2)=fftfilt(b1(:,2),sigChunk);
        bBuffer=b2(length(impulseMap)+1:length(impulseMap)+chunkLength,:)/30;
    end
 
    if pos1~=pos2
        flag=1;
    end
    
    % próba z³agodzenia nieci¹g³oœci sygna³u podczas zmiany filtrów,
    % podejœcie raczej nieudane
    for f=1
    if flag==1 && i~=1
        y(1)=bBufferOld(end-10,1);
        y(2)=bBufferOld(end,1);
        y(3)=bBuffer(10,1);
        y(4)=bBuffer(20,1);
        x=[-9,1,10,20];
        p=polyfit(x,y,3);
        x1=x(2):1:x(3);
        y1=polyval(p,x1);
        bBuffer(1:9,1)=y1(2:10);
        y(1)=bBufferOld(end-10,2);
        y(2)=bBufferOld(end,2);
        y(3)=bBuffer(10,2);
        y(4)=bBuffer(20,2);  
        p=polyfit(x,y,3);
        y1=polyval(p,x1);
        bBuffer(1:9,2)=y1(2:10);
        flag=0;
    end
    end

    % aktualizacja historii zmian suwaków i pozycji
    hAng1=hAng2;
    vAng1=vAng2;
    v2Ang1=v2Ang2;
    angleXHistory(i)=i;
    angleHistory(i)=hAng1;
    pos1=pos2;
    
    % czekanie a¿ karta puœci poprzedni¹ klatkê
%     while toc<((chunkLength-100)/44100)
%         pause(0.0001)
%     end

    %dodanie klatki do kolejki
    ADW(bBuffer);
    
%     profile viewer
%     profile on  

    tic
    allBuffer=[allBuffer; bBuffer];
    bBufferOld=bBuffer;

    
%     if i==20
%        profile viewer 
%     end
    i=i+1;

end
axes(handles.angleplot)
plot(angleXHistory,angleHistory);
ylim([-200 200])
xlim([0 100])

axes(handles.bplot)
plot(allBuffer)

release(ADW);

set(hObject,'Value',0)


% --- Executes during object creation, after setting all properties.
function pos_label_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',1);


% --- Executes on button press in up_button.
function up_button_Callback(hObject, eventdata, handles)
pos1=get(handles.pos_label,'String');
pos2=moveRec(1,str2double(pos1));
set(handles.pos_label,'String',pos2);
buttons_list = [handles.pb1, handles.pb2, handles.pb3, handles.pb4, handles.pb5, handles.pb6, handles.pb7, handles.pb8, handles.pb9, handles.pb10];
set(buttons_list, 'Value', 0);
switch pos2
    case 1
        set(handles.pb1,'Value',1);
        
    case 2
        set(handles.pb2,'Value',1);
        
    case 3
        set(handles.pb3,'Value',1);
        
    case 4
        set(handles.pb4,'Value',1);
        
    case 5
        set(handles.pb5,'Value',1);
        
    case 6
        set(handles.pb6,'Value',1);
        
    case 7
        set(handles.pb7,'Value',1);
        
    case 8
        set(handles.pb8,'Value',1);
        
    case 9
        set(handles.pb9,'Value',1);
        
    case 10
        set(handles.pb10,'Value',1);
end


% --- Executes on button press in left_button.
function left_button_Callback(hObject, eventdata, handles)
pos1=get(handles.pos_label,'String');
pos2=moveRec(4,str2double(pos1));
set(handles.pos_label,'String',pos2);
buttons_list = [handles.pb1, handles.pb2, handles.pb3, handles.pb4, handles.pb5, handles.pb6, handles.pb7, handles.pb8, handles.pb9, handles.pb10];
set(buttons_list, 'Value', 0);
switch pos2
    case 1
        set(handles.pb1,'Value',1);
        
    case 2
        set(handles.pb2,'Value',1);
        
    case 3
        set(handles.pb3,'Value',1);
        
    case 4
        set(handles.pb4,'Value',1);
        
    case 5
        set(handles.pb5,'Value',1);
        
    case 6
        set(handles.pb6,'Value',1);
        
    case 7
        set(handles.pb7,'Value',1);
        
    case 8
        set(handles.pb8,'Value',1);
        
    case 9
        set(handles.pb9,'Value',1);
        
    case 10
        set(handles.pb10,'Value',1);
end


% --- Executes on button press in right_button.
function right_button_Callback(hObject, eventdata, handles)
pos1=get(handles.pos_label,'String');
pos2=moveRec(2,str2double(pos1));
set(handles.pos_label,'String',pos2);
buttons_list = [handles.pb1, handles.pb2, handles.pb3, handles.pb4, handles.pb5, handles.pb6, handles.pb7, handles.pb8, handles.pb9, handles.pb10];
set(buttons_list, 'Value', 0);
switch pos2
    case 1
        set(handles.pb1,'Value',1);
        
    case 2
        set(handles.pb2,'Value',1);
        
    case 3
        set(handles.pb3,'Value',1);
        
    case 4
        set(handles.pb4,'Value',1);
        
    case 5
        set(handles.pb5,'Value',1);
        
    case 6
        set(handles.pb6,'Value',1);
        
    case 7
        set(handles.pb7,'Value',1);
        
    case 8
        set(handles.pb8,'Value',1);
        
    case 9
        set(handles.pb9,'Value',1);
        
    case 10
        set(handles.pb10,'Value',1);
end


% --- Executes on button press in down_button.
function down_button_Callback(hObject, eventdata, handles)
pos1=get(handles.pos_label,'String');
pos2=moveRec(3,str2double(pos1));
set(handles.pos_label,'String',pos2);
buttons_list = [handles.pb1, handles.pb2, handles.pb3, handles.pb4, handles.pb5, handles.pb6, handles.pb7, handles.pb8, handles.pb9, handles.pb10];
set(buttons_list, 'Value', 0);
switch pos2
    case 1
        set(handles.pb1,'Value',1);
        
    case 2
        set(handles.pb2,'Value',1);
        
    case 3
        set(handles.pb3,'Value',1);
        
    case 4
        set(handles.pb4,'Value',1);
        
    case 5
        set(handles.pb5,'Value',1);
        
    case 6
        set(handles.pb6,'Value',1);
        
    case 7
        set(handles.pb7,'Value',1);
        
    case 8
        set(handles.pb8,'Value',1);
        
    case 9
        set(handles.pb9,'Value',1);
        
    case 10
        set(handles.pb10,'Value',1);
end
