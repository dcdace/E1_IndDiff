function varargout = sIDdetails(varargin)
% SIDDETAILS M-file for sIDdetails.fig
%      SIDDETAILS, by itself, creates a new SIDDETAILS or raises the existing
%      singleton*.
%
%      H = SIDDETAILS returns the handle to a new SIDDETAILS or the handle to
%      the existing singleton*.
%
%      SIDDETAILS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIDDETAILS.M with the given input arguments.
%
%      SIDDETAILS('Property','Value',...) creates a new SIDDETAILS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sIDdetails_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sIDdetails_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sIDdetails

% Last Modified by GUIDE v2.5 04-Oct-2015 22:12:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @sIDdetails_OpeningFcn, ...
    'gui_OutputFcn',  @sIDdetails_OutputFcn, ...
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


% --- Executes just before sIDdetails is made visible.
function sIDdetails_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sIDdetails (see VARARGIN)

% Choose default command line output for sIDdetails
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sIDdetails wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function [participant] = sIDdetails_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
age = get(handles.popupAge,'String');
gender = get(handles.popupGender,'String');
handed = get(handles.popupHanded,'String');
english = get(handles.popupEnglish,'String');
email = get(handles.editEmail,'String');

participant.age = age{get(handles.popupAge,'Value')};
participant.gender = gender{get(handles.popupGender,'Value')};
participant.handed = handed{get(handles.popupHanded,'Value')};
participant.english = english{get(handles.popupEnglish,'Value')};
participant.email = email;

guidata(hObject, handles);
delete(hObject);



% --- Executes on selection change in popupGender.
function popupGender_Callback(hObject, eventdata, handles)
% hObject    handle to popupGender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupGender contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupGender


% --- Executes during object creation, after setting all properties.
function popupGender_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupGender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupAge.
function popupAge_Callback(hObject, eventdata, handles)
% hObject    handle to popupAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAge contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAge

% --- Executes during object creation, after setting all properties.
function popupAge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupHanded.
function popupHanded_Callback(hObject, eventdata, handles)
% hObject    handle to popupHanded (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupHanded contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupHanded


% --- Executes during object creation, after setting all properties.
function popupHanded_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupHanded (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupEnglish.
function popupEnglish_Callback(hObject, eventdata, handles)
% hObject    handle to popupEnglish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupEnglish contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupEnglish


% --- Executes during object creation, after setting all properties.
function popupEnglish_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupEnglish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume();



function editEmail_Callback(hObject, eventdata, handles)
% hObject    handle to editEmail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEmail as text
%        str2double(get(hObject,'String')) returns contents of editEmail as a double


% --- Executes during object creation, after setting all properties.
function editEmail_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEmail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
