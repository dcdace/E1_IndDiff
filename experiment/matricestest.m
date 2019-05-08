function matricestest(sID, fromMain, expparam)
Screen('Preference', 'SkipSyncTests', 1);
if nargin < 2
    fromMain = 0;
    expparam = 0;
end
% key names
KbName('UnifyKeyNames');

m = KbName('m');

%% =====================================================
% SCREEN & TEXT
% =====================================================
if ~fromMain
    HideCursor;
    grey = [240 240 240];
    black = [0 0 0];
    
    ScreenColor = grey;
    ScreenID = max(Screen('Screens'));
    
    [win, rect]= Screen('OpenWindow',ScreenID, ScreenColor); % full screen
    
    % define text style
    Screen('TextFont',win, 'Calibri');
    Screen('TextSize',win, 42);
    Screen('TextStyle', win, 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend
    TextColor = black;
    Screen('TextColor', win, TextColor);
else
    win = expparam.win;
    TextColor = expparam.TextColor;
end

DrawFormattedText(win, ['Ask the experimenter for Matrices test \n\n'...
    'Read the instructions carefully.\n\n'...
    'You will have 10 minutes to do this test. \n\n '...
    'Press M when you are ready to start'], 'center', 'center', TextColor);
Screen('Flip', win);
% waits for M
while KbCheck(-1); end % Wait until all keys are released
[keyIsDown, seconds, keyCode ] = KbCheck(-1);
while ~keyCode(m)
    [keyIsDown, seconds, keyCode ] = KbCheck(-1);
end
if ~fromMain
    % get back to Matlab
    clear Screen;
    ShowCursor;
end
end