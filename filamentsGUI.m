function varargout = filamentsGUI(varargin)
% FILAMENTSGUI MATLAB code for filamentsGUI.fig
%      FILAMENTSGUI, by itself, creates a new FILAMENTSGUI or raises the existing
%      singleton*.
%
%      H = FILAMENTSGUI returns the handle to a new FILAMENTSGUI or the handle to
%      the existing singleton*.
%
%      FILAMENTSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILAMENTSGUI.M with the given input arguments.
%
%      FILAMENTSGUI('Property','Value',...) creates a new FILAMENTSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filamentsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filamentsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filamentsGUI

% Last Modified by GUIDE v2.5 02-Jun-2014 12:24:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filamentsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @filamentsGUI_OutputFcn, ...
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


% --- Executes just before filamentsGUI is made visible.
function filamentsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filamentsGUI (see VARARGIN)

% Choose default command line output for filamentsGUI
handles.output = hObject;

handles.def_varTh = 0.0025;
handles.def_distTh = 8.5;
handles.def_rgLow = 3.75;
handles.def_dilation = 16;
handles.def_fill = 4;

initialProcessing(hObject, eventdata, handles);
handles = guidata(hObject); 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes filamentsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = filamentsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

thresh = get(hObject,'Value');
% setappdata(0,'var_thresh',thresh);
handles.var_thresh = thresh;
set(handles.text1, 'String', ['Variance Threshold: ',num2str(thresh)]);

updateAxis2(hObject, handles);
handles = guidata(hObject); 
updateAxis3(hObject, handles);
handles = guidata(hObject); 
updateAxis4(hObject, handles);
handles = guidata(hObject); 
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject,'Max',0.01);
set(hObject,'Value',0.0025);
% set(hObject,'Value',getappdata(0,'var_thresh'));


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialProcessing(hObject, eventdata, handles);
handles = guidata(hObject); 
% Update handles structure
guidata(hObject, handles);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

thresh = get(hObject,'Value');
% setappdata(hObject,'dist_thresh',thresh);
handles.dist_thresh = thresh;
set(handles.text6, 'String', ['Dist. Threshold: ',num2str(thresh)]);

updateAxis3(hObject, handles);
handles = guidata(hObject); 
updateAxis4(hObject, handles);
handles = guidata(hObject); 

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject,'Max',15);
set(hObject,'Value',8.5);
% set(hObject,'Value',getappdata(0,'dist_thresh'));

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

thresh = get(hObject,'Value');
handles.rgLow_thresh = thresh;
set(handles.text7, 'String', ['RG Low-Threshold: ',num2str(thresh)]);

updateAxis4(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject,'Max',7);
set(hObject,'Value',3.75);
% set(hObject,'Value',getappdata(0,'rgLow_thresh'));

% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

thresh = get(hObject,'Value');
handles.dilation = thresh;
set(handles.text9, 'String', ['Dist Dilate: ',num2str(thresh)]);

updateAxis3(hObject, handles);
handles = guidata(hObject); 
updateAxis4(hObject, handles);
handles = guidata(hObject); 

% Update handles structure
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'Max',30);
set(hObject,'Value',16);
set(hObject, 'SliderStep', [1/30, 1/30]);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
    
end

% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
thresh = get(hObject,'Value');
handles.fill_area = thresh;
set(handles.text10, 'String', ['Fill areas: ',num2str(thresh)]);

img_filled = fillImg(handles.img_bw,handles.fill_area);
handles.img_filled = img_filled;
axes(handles.axes2);
imshow(img_filled);
updateAxis3(hObject, handles);
handles = guidata(hObject); 
updateAxis4(hObject, handles);
handles = guidata(hObject); 

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
set(hObject,'Max',15);
set(hObject,'Value',4);
set(hObject, 'SliderStep', [1/15, 1/15]);

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
histogram;

% ---
function initialProcessing(hObject, eventdata, handles)
[fileName,PathName] = uigetfile('*.bmp','Select image to be processed');
fileName = strcat(PathName,fileName);
setappdata(gcf,'fileName',fileName );

handles.var_thresh = handles.def_varTh;
handles.dist_thresh = handles.def_distTh;
handles.rgLow_thresh = handles.def_rgLow;
handles.dilation = handles.def_dilation;
handles.fill_area = handles.def_fill;

set(handles.text1, 'String', ['Variance Threshold: ',num2str(handles.var_thresh)]);
% set(handles.edit1, 'String', num2str(handles.var_thresh));
set(handles.text6, 'String', ['Dist. Threshold: ',num2str(handles.dist_thresh)]);
set(handles.text7, 'String', ['RG Low-Threshold: ',num2str(handles.rgLow_thresh)]);
set(handles.text9, 'String', ['Dist Dilate: ',num2str(handles.dilation)]);
set(handles.text10, 'String', ['Fill areas: ',num2str(handles.fill_area)]);

set(handles.slider1,'Value',handles.var_thresh);
set(handles.slider2,'Value',handles.dist_thresh);
set(handles.slider3,'Value',handles.rgLow_thresh);
set(handles.slider6,'Value',handles.dilation);
set(handles.slider10,'Value',handles.fill_area);

img = imread(fileName);
handles.img = img;
img_orig = imresize(img,0.5);
img_orig_cut = imcrop(img_orig, [3 3 691 515]);
handles.img_cut = img_orig_cut;

axes(handles.axes1);
imshow(img_orig);

updateAxis2(hObject, handles);
handles = guidata(hObject); 
updateAxis3(hObject, handles);
handles = guidata(hObject); 
updateAxis4(hObject, handles);
handles = guidata(hObject); 

setappdata(0,'img_cut',img_orig_cut);
% Update handles structure
guidata(hObject, handles);


function updateAxis2(hObject, handles)
img_bw = binarizeImg(handles.img,handles.var_thresh);
handles.img_bw = img_bw;
img_filled = fillImg(handles.img_bw,handles.fill_area);
handles.img_filled = img_filled;
axes(handles.axes2);
imshow(img_filled);
% Update handles structure
guidata(hObject, handles);


function updateAxis3(hObject, handles)
img_distFilt = distFiltering(handles.img_filled,handles.dist_thresh,handles.dilation);
handles.img_distFilt = img_distFilt;
axes(handles.axes3);
imshow(img_distFilt);
% Update handles structure
guidata(hObject, handles);

function updateAxis4(hObject, handles)
[img_RGFilt,lengths] = RGFiltering2(handles.img_filled,handles.img_distFilt,...
                         handles.rgLow_thresh);
handles.img_RGFilt = img_RGFilt;
axes(handles.axes4);
% imshow(img_RGFilt);
imshow(handles.img_cut); hold on;
red = cat(3, ones(size(img_RGFilt)), zeros(size(img_RGFilt)), zeros(size(img_RGFilt)));
h = imshow(red);
set(h, 'AlphaData', img_RGFilt);

setappdata(0,'lengths',lengths);
setappdata(0,'img_thin',img_RGFilt);
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.def_varTh = handles.var_thresh;
handles.def_distTh = handles.dist_thresh;
handles.def_rgLow = handles.rgLow_thresh;
handles.def_dilation = handles.dilation;
handles.def_fill = handles.fill_area;

guidata(hObject, handles);


