function varargout = IQ2(varargin)
% IQ2 M-file for IQ2.fig
%      IQ2, by itself, creates a new IQ2 or raises the existing
%      singleton*.
%
%      H = IQ2 returns the handle to a new IQ2 or the handle to
%      the existing singleton*.
%
%      IQ2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IQ2.M with the given input arguments.
%
%      IQ2('Property','Value',...) creates a new IQ2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IQ2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IQ2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IQ2

% Last Modified by GUIDE v2.5 01-Mar-2015 20:21:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @IQ2_OpeningFcn, ...
    'gui_OutputFcn',  @IQ2_OutputFcn, ...
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


% --- Executes just before IQ2 is made visible.
function IQ2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IQ2 (see VARARGIN)

% Choose default command line output for IQ2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes IQ2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function [score, correct, answ] = IQ2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% for i = 1:420 % 7 min (420s)
%     pause(1);
% end
pause(420);
k = 0;
for i = 21:40
    k = k + 1;
    y = get(eval(sprintf(['handles.uipanel' num2str(i)])),'SelectedObject');
    answ{k} = get(y,'tag');
end

set(handles.text1, 'Visible', 'on');
pause(2);
correct = {'q21a','q22b','q23c','q24d','q25c','q26e','q27e','q28b','q29d','q30c','q31a','q32c','q33a','q34b','q35e','q36c','q37b','q38d','q39b','q40c';};
answ(cellfun(@isempty,answ))= {'x'};
score = size((intersect(correct,answ)),2);
close force


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(hObject);
