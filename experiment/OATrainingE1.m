function errorRate = OATrainingE1(sID, seqCond, sIDDir, group, run)
Screen('Preference', 'SkipSyncTests', 1);
repetitions = 9; % 9
numOfVideos = 2; % 2

% change dir to the dir where this .m file is
[folder] = fileparts(which(mfilename));
cd(folder);
% get Stimuli directory name
stimuliDir = [folder filesep 'stimuli' filesep];
% Get date and time
time = clock;
if time(1,5) < 10
    sec = ['0' num2str(time(1,5))];
else
    sec = num2str(time(1,5));
end
datetime = [datestr(now,'yyyymmdd') '_' int2str(time(1,4)) sec];

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
DrawFormattedText(win, ['Watching block ' num2str(run) ' of 4 \n\n'...
    'You will learn 2 sequences by watching videos of somebody else tapping them 5x. \n\n'...
    'Watch carefully and learn. Pay close attention whether the sequences are performed correctly. \n\n'...
    'Occasionally you will be asked whether the performer in the video made an error \n in any of the 5 repetitions.\n\n'...
    'Press M for Yes or L for No \n\n' ...
    'We will monitor how well you can spot the errors. \n\n'...
    'At the end we will test how well you have learned the sequences.'...
    'Press M to start'], 'center', 'center');
Screen('Flip', win);
% waits for keyM
while KbCheck(-1); end % Wait until all keys are released
[keyIsDown, seconds, keyCode ] = KbCheck(-1);
while ~keyCode(keyM)
    [keyIsDown, seconds, keyCode ] = KbCheck(-1);
end

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
AllResults = [];
k = 1;
totalErrors = 0;
% shuffle the 9 videos to show them each time in different order
x = Shuffle(1:9);
% generates when the attention q will be asked
% will ask the question 5 - 6 times
numOfQ = randi([5 6]);
totaltrials = repetitions * numOfVideos; % 18
askQ = Shuffle([zeros(totaltrials-numOfQ,1); ones(numOfQ,1)]);
tr = 0; % which trial
for b = 1:repetitions %9
    sequenceNr = Shuffle(seqCond(1,1:2)); % shuffle them to show each time in different order
    for j = 1 : numOfVideos % 2 videos
        tr = tr + 1;
        s = num2str(sequenceNr(j));
        % video to show
        videoFileNr = x(b);
        fileStruct = dir([stimuliDir s num2str(videoFileNr) '*']);
        fileName{k,1} = fileStruct.name;
        [movie movieduration] = Screen('OpenMovie', win, [stimuliDir fileName{k,1}]);
        % is there an error
        if strfind(fileName{k}, 'e')
            e = 1;
        else
            e = 0;
        end
        errors(k,1) = e;
        
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
        % always asks the question, if it was an error trial
        if e
            askQ(tr,1) = 1;
        end
        if askQ(tr,1) % ask the question
            DrawFormattedText(win, ['Was there an error in any of the 5 repetitions of the last sequence? \n\n' ...
                'M - Yes    L - No'], 'center', 'center', TextColor);
            Screen('Flip', win);
            % waits for the answer
            %% start the keyboard check
            KbQueueStart(); %start listening
            KbQueueFlush(); %removes all keyboard presses
            % waits for a key press
            
            pressed = 0;
            correct = 0;
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
                totalErrors = totalErrors + 1;
            end
            Results(k,1:3) = [e Yes_pressed correct];
            KbQueueStop();
        end
        k=k+1;
    end
    %     if b < 9
    %         DrawFormattedText(win, [num2str(b) '/9 done. Have a rest! \n\n Press M to continue'], 'center', 'center', TextColor);
    %         Screen('Flip', win);
    %         % waits for keyM
    %         while KbCheck(-1); end % Wait until all keys are released
    %         [keyIsDown, seconds, keyCode ] = KbCheck(-1);
    %         while ~keyCode(keyM)
    %             [keyIsDown, seconds, keyCode ] = KbCheck(-1);
    %         end
    %     end
end
% error feedback

errorRate = totalErrors/totaltrials*100; % INCORRECT!!! should be totalErrors/sum(askQ)*100

DrawFormattedText(win, ['Your answered correctly ' num2str(sum(askQ)-totalErrors) ' out of ' num2str(sum(askQ)) ' times. \n\n' ...
    'Press M to continue with a questionnaire'], 'center', 'center', TextColor);
Screen('Flip', win);
% waits for keyM
while KbCheck(-1); end % Wait until all keys are released
[keyIsDown, seconds, keyCode ] = KbCheck(-1);
while ~keyCode(keyM)
    [keyIsDown, seconds, keyCode ] = KbCheck(-1);
end
AllResults = [AllResults; Results];

if sID < 10
    sIDtxt = ['0' num2str(sID)];
else
    sIDtxt = num2str(sID);
end
filename = [sIDDir group sIDtxt 'run' num2str(run) '_' datetime '_watching.mat'];
save(filename);
ShowCursor;
% get back to Matlab
clear Screen;
end