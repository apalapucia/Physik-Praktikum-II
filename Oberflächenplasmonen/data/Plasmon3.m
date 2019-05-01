function varargout = Plasmon3(varargin)
% PLASMON3 MATLAB code for Plasmon3.fig
%      PLASMON3, by itself, creates a new PLASMON3 or raises the existing
%      singleton*.
%
%      H = PLASMON3 returns the handle to a new PLASMON3 or the handle to
%      the existing singleton*.
%
%      PLASMON3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLASMON3.M with the given input arguments.
%
%      PLASMON3('Property','Value',...) creates a new PLASMON3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plasmon3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plasmon3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plasmon3

% Last Modified by GUIDE v2.5 20-May-2015 17:48:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plasmon3_OpeningFcn, ...
                   'gui_OutputFcn',  @Plasmon3_OutputFcn, ...
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

% --- Executes just before Plasmon3 is made visible.
function Plasmon3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Plasmon3 (see VARARGIN)

% Choose default command line output for Plasmon3
handles.output = hObject;
handles.versuchsdaten=[];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Plasmon3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
aktualisieren(handles);


% --- Outputs from this function are returned to the command line.
function varargout = Plasmon3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function aktualisieren(handles)
disp('Neuberechnung');
%Edit-Boxen aktualisieren:
set(handles.prisma_n_edit,'string',num2str(get(handles.prisma_n_slider,'value')));
set(handles.layer1_n_edit,'string',num2str(get(handles.layer1_n_slider,'value')));
set(handles.layer2_n_edit,'string',num2str(get(handles.layer2_n_slider,'value')));
set(handles.subphase_n_edit,'string',num2str(get(handles.subphase_n_slider,'value')));
set(handles.layer1_k_edit,'string',num2str(get(handles.layer1_k_slider,'value')));
set(handles.layer2_k_edit,'string',num2str(get(handles.layer2_k_slider,'value')));
set(handles.layer1_d_edit,'string',num2str(get(handles.layer1_d_slider,'value')));
set(handles.layer2_d_edit,'string',num2str(get(handles.layer2_d_slider,'value')));
set(handles.normierungs_edit,'string',num2str(get(handles.normierungs_slider,'value')));
set(handles.konstante_edit,'string',num2str(get(handles.konstante_slider,'value')));
%Werte einlesen und ins gleiche Format bringen wie in Plasmon2:
en1=get(handles.prisma_n_slider,'value');
en2=get(handles.layer1_n_slider,'value');
en3=get(handles.layer2_n_slider,'value');
en4=get(handles.subphase_n_slider,'value');
ek2=get(handles.layer1_k_slider,'value');
ek3=get(handles.layer2_k_slider,'value');
d2=get(handles.layer1_d_slider,'value')*1e-9;
d3=get(handles.layer2_d_slider,'value')*1e-9;
%alphas_ext_rad=((-5:.002:5)')*pi/180;
thetas_ext_deg=((35:.01:55)');
if(isempty(handles.versuchsdaten))
    thetas_exp_deg=[];
    y_exp=[];
else
    alphas_exp_rad=handles.versuchsdaten.alphas_exp_rad;
    thetas_exp_rad=pi/4+asin(sin(atan(tan(2*alphas_exp_rad)*10/5.25)+get(handles.konstante_slider,'value')/180*pi)/1.51);
    thetas_exp_deg=thetas_exp_rad*180/pi;
    
    %%%%%%Falsch:
    %thetas_exp_deg=alphas_exp_rad/pi*180+get(handles.konstante_slider,'value');
    %%%%%%
    
    %y_exp=handles.versuchsdaten.spannungen*get(handles.normierungs_slider,'value');
    
    
    spannungen=handles.versuchsdaten.spannungen;
    m=str2double(get(handles.m_edit,'string'));
    b=str2double(get(handles.a1,'string'));
    c=str2double(get(handles.c_edit,'string'));
    alphas_exp_grad=alphas_exp_rad*180/pi;
    reflektivitaet=m*alphas_exp_grad+b*alphas_exp_grad.^2+c;
    y_exp=spannungen./reflektivitaet*get(handles.normierungs_slider,'value');
    
    
end
%Simulationsdaten ermitteln:
REF=simulationsfunktion(thetas_ext_deg,en1,en2,en3,en4,ek2,ek3,d2,d3,...
    get(handles.eintrittsverlusteberuecksichtigen_checkbox,'value'),get(handles.konstante_slider,'value'),...
    1e-9*str2double(get(handles.lambda_edit,'string')));
plot(handles.axes1,thetas_ext_deg,REF,thetas_exp_deg,y_exp,'xk');
zoom on;
%Ausgabe der Minima:
[~,index_min_ext]=min(REF);
theta_min_ext=thetas_ext_deg(index_min_ext);    %Ungefähres Minimum (Simulation)
theta_min_ext=fminsearch(@(theta)simulationsfunktion(theta,en1,en2,en3,en4,ek2,ek3,d2,d3,...
    get(handles.eintrittsverlusteberuecksichtigen_checkbox,'value'),get(handles.konstante_slider,'value'),...
    1e-9*str2double(get(handles.lambda_edit,'string'))),theta_min_ext);     %Exaktes Minimum (Simulation)
set(handles.minimumsimulation_static,'string',['Minimum Simulation: ' num2str(theta_min_ext,'%.4f') '°']);

function REF=simulationsfunktion(THETA_ext_deg,en1,en2,en3,en4,ek2,ek3,d2,d3,eintrittsverlusteberuecksichtigen,prismaverdrehung,lambda)
%thetas_ext_rad=pi/4+asin(sin(atan(tan(2*alphas_ext_rad)*10/5))/1.51);
%THETA_ext_deg=thetas_ext_rad*180/pi;
%Aus Plasmon2, angepasst
%Dummy-Werte bei Schichtdicke 0, damit die Rechnung funktioniert:
if(d2==0)
    en2=1;
    ek2=1;
end
if(d3==0)
    en3=1;
    ek3=1;
end
%Konstanten:
%lambda=680.8e-9;
fukso=1i;
%Format anpassen:
en=zeros(1,4);
ek=zeros(1,4);
d=zeros(1,4);
en(1)=en1;
en(2)=en2;
en(3)=en3;
en(4)=en4;
ek(2)=ek2;
ek(3)=ek3;
d(2)=d2;
d(3)=d3;
%calcolo costanti dielettriche
er=en(1)^2-ek(1)^2;
ei=2*en(1)*ek(1);
e(1)=complex(er,ei);
er=en(2)^2-ek(2)^2;
ei=2*en(2)*ek(2);
e(2)=complex(er,ei);
er=en(3)^2-ek(3)^2;
ei=2*en(3)*ek(3);
e(3)=complex(er,ei);
er=en(4)^2-ek(4)^2;
ei=2*en(4)*ek(4);
e(4)=complex(er,ei);
%     --------- CALCOLI VERI ----------
THETA=THETA_ext_deg/180*pi;
%THETA=pi/4+asin(1/en(1)*sin(THETA_ext-pi/4));
REF=zeros(1,length(THETA));
TRA=zeros(1,length(THETA));
em=zeros(3,2,2);
for jtheta=1:length(THETA);
    theta=THETA(jtheta);
    q1=sqrt(e(1)-en(1)^2*sin(theta)^2)/e(1);
    qn=sqrt(e(end)-en(1)^2*sin(theta)^2)/e(end);
    for j=2:(length(e)-1)
        beta=d(j)*2*pi/lambda*sqrt(e(j)-en(1)^2*sin(theta)^2);
        q=sqrt(e(j)-en(1)^2*sin(theta)^2)/e(j);
        em(j,1,1)=cos(beta);
        em(j,1,2)=-fukso*sin(beta)/q;
        em(j,2,1)=-fukso*sin(beta)*q;
        em(j,2,2)=cos(beta);
    end
    emtot=[1 0;0 1];
    for j=2:(length(e)-1)
        emtot1(:,:)=em(j,:,:);
        emtot=emtot*emtot1;
    end
    rp=((emtot(1,1)+emtot(1,2)*qn)*q1-(emtot(2,1)+emtot(2,2)*qn))/...
        ((emtot(1,1)+emtot(1,2)*qn)*q1+(emtot(2,1)+emtot(2,2)*qn));
    tp=2*q1/((emtot(1,1)+emtot(1,2)*qn)*q1+(emtot(2,1)+emtot(2,2)*qn));
    ref=rp*conj(rp);
    tra=tp*conj(tp)/cos(theta)*en(1)*qn;
    REF(jtheta)=ref;
    TRA(jtheta)=tra;
end
%Berücksichtigung der Verluste beim Eintritt in den Prisma:
if(eintrittsverlusteberuecksichtigen)
    %tp=(2*en4*en1*cos(prismaverdrehung/180*pi+pi/4+asin(en1*sin(THETA-pi/4))))./...
        %(en1^2*cos(prismaverdrehung/180*pi+pi/4+asin(en1*sin(THETA-pi/4)))+...
        %en4*sqrt(en1^2-en4^2*sin(prismaverdrehung/180*pi+pi/4+asin(en1*sin(THETA-pi/4))).^2));
    %tp(imag(tp)~=0)=inf;
    %tp=tp';
    %REF=REF.*tp;
    
%     figure;
%     plot(asin(en1*sin(THETA-pi/4))*180/pi,tp);
%     figure;
%     plot(THETA_ext_deg,tp);
end

% --------------------------------------------------------------------
function xls_datei_oeffnen_menu_Callback(hObject, eventdata, handles)
% hObject    handle to xls_datei_oeffnen_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [FileName,PathName]=uigetfile('*.xls');
    rohdaten=xlsread([PathName FileName],'','','basic');
    schritte_original=rohdaten(:,1);
    ppolar=rohdaten(:,2);
    %spolar=rohdaten(:,3);
    %spannungen=ppolar./spolar;
    spannungen=ppolar;
    [~,minimumsstelle]=min(spannungen);
    schritte_verschoben=schritte_original-schritte_original(minimumsstelle);
    eingabe=inputdlg({'Anzahl der Schritte des Motors','Überwundener Winkel in Grad'},'Eingabe',1,{'10400','6'});
    schritte=str2double(eingabe{1});
    winkel=str2double(eingabe{2});
    %alphas_deg=schritte_verschoben/10400*6*4;
    alphas_deg=schritte_verschoben/schritte*winkel;
    alphas_rad=alphas_deg/180*pi;
    handles.versuchsdaten=struct('alphas_exp_rad',alphas_rad,...
        'spannungen',spannungen);
    %thetas_ohne_const_rad=asin(sin(atan(tan(2*alphas_rad)*10/5))/1.51);
    %thetas_ohne_const_deg=thetas_ohne_const_rad*180/pi;
    %handles.versuchsdaten=struct('thetas_ohne_const_deg',thetas_ohne_const_deg,...
    %    'spannungen',spannungen);
    set(handles.normierungs_slider,'value',1/max(spannungen))
catch exc
    handles.dateidaten=[];
    boxhandle=msgbox('Öffnen der Datei fehlgeschlagen');
    waitfor(boxhandle);
    rethrow(exc);
end
aktualisieren(handles);
% Update handles structure
guidata(hObject, handles);

% % --- Executes on button press in curvefitting_layer1_button.
% function curvefitting_layer1_button_Callback(hObject, eventdata, handles)
% % hObject    handle to curvefitting_layer1_button (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% fitparameter=[1 1]; %benötigt?
% 
% %
% en1=get(handles.prisma_n_slider,'value');
% en3=get(handles.layer2_n_slider,'value');
% en4=get(handles.subphase_n_slider,'value');
% ek3=get(handles.layer2_k_slider,'value');
% d2=get(handles.layer1_d_slider,'value')*1e-9;
% d3=get(handles.layer2_d_slider,'value')*1e-9;
% %
% 
% alphas_exp_rad=handles.versuchsdaten.alphas_exp_rad;
% thetas_exp_rad=asin(sin(atan(tan(2*alphas_exp_rad)*10/5)+get(handles.konstante_slider,'value')/180*pi)/1.51);
% thetas_exp_deg=thetas_exp_rad*180/pi;
% %%%%%%Falsch:
% thetas_exp_deg=alphas_exp_rad/pi*180+get(handles.konstante_slider,'value');
% %%%%%%
% y_exp=handles.versuchsdaten.spannungen*get(handles.normierungs_slider,'value');
% fitfunktion=@(fitparameter,THETA_ext_deg)simulationsfunktion(THETA_ext_deg,en1,...
%     fitparameter(1),en3,en4,fitparameter(2),ek3,d2,d3,get(handles.eintrittsverlusteberuecksichtigen_checkbox,'value'),...
%     get(handles.konstante_slider,'value'));
% 
% ergebnis=lsqcurvefit(fitfunktion,[.5 .5],thetas_exp_deg',y_exp');
% 
% layer1_n=ergebnis(1)
% layer1_k=ergebnis(2)

% --- Executes on selection change in layer1_popup.
function layer1_popup_Callback(hObject, eventdata, handles)
% hObject    handle to layer1_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns layer1_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from layer1_popup
switch(get(hObject,'value'))
    case 1  %leer
        set(handles.layer1_n_slider,'value',0);
        set(handles.layer1_k_slider,'value',0);
        set(handles.layer1_d_slider,'value',0);
    case 2  %Silber
        set(handles.layer1_n_slider,'value',.08);
        set(handles.layer1_k_slider,'value',4.12);
    case 3  %Gold
        set(handles.layer1_n_slider,'value',.17);
        set(handles.layer1_k_slider,'value',3.7);
end
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer1_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer1_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in layer2_popup.
function layer2_popup_Callback(hObject, eventdata, handles)
% hObject    handle to layer2_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns layer2_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from layer2_popup
switch(get(hObject,'value'))
    case 1  %leer
        set(handles.layer2_n_slider,'value',0);
        set(handles.layer2_k_slider,'value',0);
        set(handles.layer2_d_slider,'value',0);
    case 2  %Silber
        set(handles.layer2_n_slider,'value',.08);
        set(handles.layer2_k_slider,'value',4.12);
    case 3  %Gold
        set(handles.layer2_n_slider,'value',.17);
        set(handles.layer2_k_slider,'value',3.7);
end
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer2_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer2_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function layer1_n_slider_Callback(hObject, eventdata, handles)
% hObject    handle to layer1_n_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer1_n_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer1_n_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function layer2_n_slider_Callback(hObject, eventdata, handles)
% hObject    handle to layer2_n_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer2_n_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer2_n_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function layer1_k_slider_Callback(hObject, eventdata, handles)
% hObject    handle to layer1_k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer1_k_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer1_k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function layer2_k_slider_Callback(hObject, eventdata, handles)
% hObject    handle to layer2_k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer2_k_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer2_k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function layer1_d_slider_Callback(hObject, eventdata, handles)
% hObject    handle to layer1_d_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer1_d_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer1_d_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function layer2_d_slider_Callback(hObject, eventdata, handles)
% hObject    handle to layer2_d_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer2_d_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer2_d_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function layer1_n_edit_Callback(hObject, eventdata, handles)
% hObject    handle to layer1_n_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of layer1_n_edit as text
%        str2double(get(hObject,'String')) returns contents of layer1_n_edit as a double
set(handles.layer1_n_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer1_n_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer1_n_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function layer2_n_edit_Callback(hObject, eventdata, handles)
% hObject    handle to layer2_n_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of layer2_n_edit as text
%        str2double(get(hObject,'String')) returns contents of layer2_n_edit as a double
set(handles.layer2_n_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer2_n_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer2_n_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function layer1_k_edit_Callback(hObject, eventdata, handles)
% hObject    handle to layer1_k_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of layer1_k_edit as text
%        str2double(get(hObject,'String')) returns contents of layer1_k_edit as a double
set(handles.layer1_k_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer1_k_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer1_k_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function layer2_k_edit_Callback(hObject, eventdata, handles)
% hObject    handle to layer2_k_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of layer2_k_edit as text
%        str2double(get(hObject,'String')) returns contents of layer2_k_edit as a double
set(handles.layer2_k_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer2_k_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer2_k_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function layer1_d_edit_Callback(hObject, eventdata, handles)
% hObject    handle to layer1_d_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of layer1_d_edit as text
%        str2double(get(hObject,'String')) returns contents of layer1_d_edit as a double
set(handles.layer1_d_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer1_d_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer1_d_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function layer2_d_edit_Callback(hObject, eventdata, handles)
% hObject    handle to layer2_d_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of layer2_d_edit as text
%        str2double(get(hObject,'String')) returns contents of layer2_d_edit as a double
set(handles.layer2_d_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function layer2_d_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer2_d_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function subphase_n_slider_Callback(hObject, eventdata, handles)
% hObject    handle to subphase_n_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function subphase_n_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subphase_n_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function subphase_n_edit_Callback(hObject, eventdata, handles)
% hObject    handle to subphase_n_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subphase_n_edit as text
%        str2double(get(hObject,'String')) returns contents of subphase_n_edit as a double
set(handles.subphase_n_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function subphase_n_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subphase_n_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function prisma_n_slider_Callback(hObject, eventdata, handles)
% hObject    handle to prisma_n_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function prisma_n_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prisma_n_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function prisma_n_edit_Callback(hObject, eventdata, handles)
% hObject    handle to prisma_n_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prisma_n_edit as text
%        str2double(get(hObject,'String')) returns contents of prisma_n_edit as a double
set(handles.prisma_n_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function prisma_n_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prisma_n_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in subphase_popup.
function subphase_popup_Callback(hObject, eventdata, handles)
% hObject    handle to subphase_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subphase_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subphase_popup
if(get(hObject,'value')==1)     %Luft
    set(handles.subphase_n_slider,'value',1.00029);
elseif(get(hObject,'value')==2) %Wasser
    set(handles.subphase_n_slider,'value',1.3329);
end
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function subphase_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subphase_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function normierungs_slider_Callback(hObject, eventdata, handles)
% hObject    handle to normierungs_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function normierungs_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normierungs_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function normierungs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to normierungs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of normierungs_edit as text
%        str2double(get(hObject,'String')) returns contents of normierungs_edit as a double
set(handles.normierungs_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function normierungs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normierungs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function konstante_slider_Callback(hObject, eventdata, handles)
% hObject    handle to konstante_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function konstante_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to konstante_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function konstante_edit_Callback(hObject, eventdata, handles)
% hObject    handle to konstante_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of konstante_edit as text
%        str2double(get(hObject,'String')) returns contents of konstante_edit as a double
set(handles.konstante_slider,'value',str2double(get(hObject,'string')));
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function konstante_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to konstante_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in eintrittsverlusteberuecksichtigen_checkbox.
function eintrittsverlusteberuecksichtigen_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to eintrittsverlusteberuecksichtigen_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eintrittsverlusteberuecksichtigen_checkbox
aktualisieren(handles);

function lambda_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda_edit as text
%        str2double(get(hObject,'String')) returns contents of lambda_edit as a double
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function lambda_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m_edit_Callback(hObject, eventdata, handles)
% hObject    handle to m_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m_edit as text
%        str2double(get(hObject,'String')) returns contents of m_edit as a double
aktualisieren(handles);

function m_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function c_edit_Callback(hObject, eventdata, handles)
% hObject    handle to c_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c_edit as text
%        str2double(get(hObject,'String')) returns contents of c_edit as a double
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function c_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a1_Callback(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a1 as text
%        str2double(get(hObject,'String')) returns contents of a1 as a double
aktualisieren(handles);

% --- Executes during object creation, after setting all properties.
function a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
