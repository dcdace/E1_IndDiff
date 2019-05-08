function IQ5instr(fromMain, expparam)
Screen('Preference', 'SkipSyncTests', 1);
folder = fileparts(which(mfilename));
if ~nargin 
    fromMain = 0;
    expparam = 0;
end

% key names
% theKb = GetKeyboard(0);
% key names
% if Mac then getKeyboard
if regexp(computer,'PCW\w*')
    theKb = 0;
else
    theKb = GetKeyboard(0);
end
KbName('UnifyKeyNames');
spacebar = KbName('m');
keylist = ones(1,256); % create a list of 256 zeros

KbQueueCreate(theKb,keylist); % Make kb queue
%% =====================================================
% SCREEN & TEXT
% =====================================================
if ~fromMain
    HideCursor;
    grey = [240 240 240];
    black = [0 0 0];
    
    ScreenColor = [255 255 255];
    ScreenID = max(Screen('Screens'));
    
    [win, rect]= Screen('OpenWindow',ScreenID, ScreenColor); % full screen
    %[win, rect]= Screen('OpenWindow',ScreenID, ScreenColor, [0 0 1000 500]); % 1000x750 screen
    
    % define text style
    Screen('TextFont',win, 'Calibri');
    Screen('TextSize',win, 42);
    Screen('TextStyle', win, 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend
    TextColor = black;
    Screen('TextColor', win, TextColor);
else
    win = expparam.win;
    rect = expparam.rect;
    TextColor = expparam.TextColor;
    grey = expparam.grey;
    black = expparam.black;
end
%% =====================================================
% Instructions
% =====================================================
img = imread([folder filesep 'IQ5intro.png']);
introImg = Screen('MakeTexture', win, img);
Screen('DrawTexture', win, introImg);
Screen('Flip', win);
% DrawFormattedText(win, ['IQ test 2'], 'center', 'center');
% Screen('Flip', win);
% waits for spacebar
while KbCheck(-1); end % Wait until all keys are released
[keyIsDown, seconds, keyCode ] = KbCheck(-1);
while ~keyCode(spacebar)
    [keyIsDown, seconds, keyCode ] = KbCheck(-1);
end

% if ~fromMain
    % get back to Matlab
    clear Screen;
    ShowCursor;
% end
end