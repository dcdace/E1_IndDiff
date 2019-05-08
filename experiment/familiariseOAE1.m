function familiariseOAE1(fs)
Screen('Preference', 'SkipSyncTests', 1);
% change dir to the dir where this .m file is
[folder] = fileparts(which(mfilename));
cd(folder);
% get Stimuli directory name
stimuliDir = [folder filesep 'stimuli' filesep];

% all sequences
Sequences = [
    5,3,4,2,1;      %1
    5,2,1,3,4 ;     %2
    4,5,1,3,2 ;     %3
    4,1,3,5,2 ;     %4
    3,1,4,2,5 ;     %5
    2,3,5,4,1 ;     %6
    2,5,3,1,4 ;     %7
    1,4,2,5,3 ;     %8
    1,2,4,3,5 ;     %9
    1,5,4,2,3 ;     %10
    3,5,2,1,4 ;     %11
    3,2,5,1,4 ;     %12
    ];

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
keyM = KbName('m');
keyL = KbName('l');
keylist = ones(1,256); % create a list of 256 zeros

KbQueueCreate(theKb,keylist); % Make kb queue
%% =====================================================
% SCREEN & TEXT
% =====================================================
HideCursor;
grey = [240 240 240];
black = [0 0 0];

ScreenColor = grey;
ScreenID = max(Screen('Screens'));

[win, rect]= Screen('OpenWindow',ScreenID, ScreenColor); % full screen
%[win, rect]= Screen('OpenWindow',ScreenID, ScreenColor, [0 0 1000 500]); % 1000x750 screen

% define text style
Screen('TextFont',win, 'Calibri');
Screen('TextSize',win, 42);
Screen('TextStyle', win, 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend
TextColor = black;
Screen('TextColor', win, TextColor);
%% =====================================================
% Instructions
% =====================================================
DrawFormattedText(win, ['In the next task you will learn sequences by watching videos of somebody else tapping them 5x. \n\n'...
    'Don''t do anything with your left hand! Keep it still! \n\n'...
    'Just watch the videos carefully and learn. \n Pay close attention whether the sequences are performed correctly. \n\n'...
    'Occasionally you will be asked whether the performer in the video made an error \n in any of the 5 repetitions.\n'...
    'We will monitor how well you can spot the errors. \n\n'...
    'At the end we will test how well you have learned the sequences.\n\n'...
    'Press M to start an example trial.'], 'center', 'center');
Screen('Flip', win);
% waits for keyM
while KbCheck(-1); end % Wait until all keys are released
[keyIsDown, seconds, keyCode ] = KbCheck(-1);
while ~keyCode(keyM)
    [keyIsDown, seconds, keyCode ] = KbCheck(-1);
end
DrawFormattedText(win, '..loading..', 'center', 'center');
Screen('Flip', win);
%% =====================================================
% 5 SQUARE POSITIONS
% =====================================================
% square size
sw = 40; % square width in px
sh = 40; % square height
sg = 0; % gap between squares
sn = 5; %

[x,y] = RectCenter(rect);
% left and right border position for the first square
l = x - (sn/3+1)*(90/3) - (sn/3)*sw;
r = l + sw;
b = rect(1,4) - 10;
t = b - sh;

Squares=zeros(4,sn);
for i = 1 : sn
    Squares(:,i) = [l;t;r;b];
    l = l + sw + sg;
    r = r + sw + sg;
end
%border = [Squares(1,1), Squares(2,1), Squares(3,5), Squares(4,5)];
%% ================
k = 1;
s = num2str(fs);
% video to show
videoFileNr = 1;
fileStruct = dir([stimuliDir s num2str(videoFileNr) '*']);
fileName{k,1} = fileStruct.name;
[movie movieduration] = Screen('OpenMovie', win, [stimuliDir fileName{k,1}]);
% is there an error
if strfind(fileName{k}, 'e')
    e = 1;
else
    e = 0;
end

%%
% show the sequence for 2.7s
sequence = Sequences(str2num(s),:);
% fixation cross
Screen('Flip', win);
WaitSecs(0.2);
% Screen('FrameRect', win, black, border );
DrawFormattedText(win, ' * ', 'center', 'center', TextColor);
Screen('Flip', win);
WaitSecs(1);
% sequence
%Screen('FrameRect', win, black, border );
DrawFormattedText(win, num2str(sequence), 'center', 'center', TextColor);
Screen('Flip', win);
WaitSecs(2.7);
% show the video 5x
Screen('Flip', win);
Show_Video(win, rect, movie, movieduration);

% Attention check

DrawFormattedText(win, ['Was there an error in any of the 5 repetitions of the last sequence? \n\n' ...
    'M - Yes    L - No'], 'center', 'center', TextColor);
Screen('Flip', win);
% waits for the answer
%% start the keyboard check
KbQueueStart(); %start listening
KbQueueFlush(); %removes all keyboard presses
% waits for a key press

pressed = 0;
while ~pressed
    % check if keyM or keyL is pressed
    [pressed, firstPress] = KbQueueCheck(); %check response
    Yes_pressed = (any(find(firstPress) == keyM));
    No_pressed = (any(find(firstPress) == keyL));
    if Yes_pressed || No_pressed
        pressed = 1;
    end
end
% correct if e and Yes or e and No
if (e && Yes_pressed) || (~e && No_pressed)
    correct = 1;
else
    correct = 0;
end
KbQueueStop();

if correct
    text = 'Your answer was correct, the sequence was executed correctly all 5 times!!';
else
    text = 'Your answer was not correct, the sequence was executed correctly all 5 times!';
end

DrawFormattedText(win, [text '\n\n Press M to start the task'], 'center', 'center', TextColor);
Screen('Flip', win);
% waits for keyM
while KbCheck(-1); end % Wait until all keys are released
[keyIsDown, seconds, keyCode ] = KbCheck(-1);
while ~keyCode(keyM)
    [keyIsDown, seconds, keyCode ] = KbCheck(-1);
end
ShowCursor;
% get back to Matlab
clear Screen;
end
