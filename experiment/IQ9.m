function varargout = IQ9(varargin)
% IQ9 M-file for IQ9.fig
%      IQ9, by itself, creates a new IQ9 or raises the existing
%      singleton*.
%
%      H = IQ9 returns the handle to a new IQ9 or the handle to
%      the existing singleton*.
%
%      IQ9('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IQ9.M with the given input arguments.
%
%      IQ9('Property','Value',...) creates a new IQ9 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IQ9_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IQ9_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IQ9

% Last Modified by GUIDE v2.5 02-Mar-2015 17:53:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @IQ9_OpeningFcn, ...
    'gui_OutputFcn',  @IQ9_OutputFcn, ...
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


% --- Executes just before IQ9 is made visible.
function IQ9_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IQ9 (see VARARGIN)

% Choose default command line output for IQ9
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes IQ9 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function [score, correct, answ] = IQ9_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% for i = 1:600 % 10 min (600s)
%     pause(1);
% end
pause(600);
k = 0;
for i = 161:180
    k = k + 1;
    y = get(eval(sprintf(['handles.uipanel' num2str(i)])),'SelectedObject');
    answ{k} = get(y,'tag');
end
% 
set(handles.text1, 'Visible', 'on');
pause(2);
correct = {'q161c','q162c','q163c','q164b','q165b','q166b','q167a','q168a','q169e','q170a','q171b','q172c','q173d','q174b','q175e','q176b','q177e','q178b','q179d','q180e';};
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
