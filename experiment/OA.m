function OA
Screen('Preference', 'SkipSyncTests', 1);
% change dir to the dir where this .m file is
[folder] = fileparts(which(mfilename));
cd(folder);
% =====================================================
% PARAMETERS
% =====================================================
rand('twister',sum(100*clock));

% PARTICIPANT DATA
group = 'OA';

% Get date and time
time = clock;
if time(1,4) < 10
    hr = ['0' num2str(time(1,4))];
else
    hr = num2str(time(1,4));
end
if time(1,5) < 10
    minutes = ['0' num2str(time(1,5))];
else
    minutes = num2str(time(1,5));
end
datetime = [datestr(now,'yyyymmdd') '_' hr minutes];


%% generate sID
[ans pcname] =  system('hostname');
sID = [datestr(now,'mmdd') hr minutes pcname];
sID = regexp(sID,'\.','split');
sID = cellstr(sID{1});
%%
[sIDDir, participant] = getParticipantE1(sID, group);
%
% sequences for conditions
% if parameter file exists, take seqCond from there!
parameterFile = [sIDDir 'parameters.mat'];
if exist(parameterFile, 'file') == 2;
    load(parameterFile)
else
    % if not, then generate new
    X = Shuffle(1:12);
    seqCond = X(1,1:4);
    % sequences 11 and 12 can't be in the same condition
    while (sum(ismember([11,12],seqCond (1:2)))==2 || (sum(ismember([11,12],seqCond (3:4)))==2))
        X = Shuffle(1:12);
        seqCond = X(1,1:4);
    end
    % finds familiarisation sequece
    Fs = randi(12);
    while any(seqCond==Fs)
        Fs = randi(12);
    end
    % save parameters
    save(parameterFile);
end
% % =====================================================
% SCREEN & TEXT
% =====================================================
% HideCursor;
expparam.white  = [255 255 255];
expparam.grey   = [127 127 127];
expparam.black  = [0 0 0];

expparam.ScreenColor    = expparam.grey;
expparam.ScreenID       = max(Screen('Screens'));

[expparam.win, expparam.rect]= Screen('OpenWindow',expparam.ScreenID, expparam.ScreenColor); 

% define text style
Screen('TextFont', expparam.win, 'Calibri');
Screen('TextSize', expparam.win, 42);
Screen('TextStyle', expparam.win, 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend
expparam.TextColor = expparam.black;
Screen('TextColor', expparam.win, expparam.TextColor);

% =====================================================
% PROCEDURE
% =====================================================
% TEST - PROCESSING SPEED
% paper-pen test
matricestest(sID); % Matrices test

% TEST - MATRICES (IQ9)
[score9, correct9, answ9] = IQ9;
filename = [sIDDir 'IQ9.mat'];
save(filename, 'score9', 'correct9', 'answ9');

% THE SEQUENCES TRAINING AND QUESTIONNAIRES

% FAMILIARISATION
familiariseE1(Fs);

% pre Test
[PreOAavgs, PreUNavgs, PreOA, PreUN] = preTrainingE1(sID{1}, seqCond, sIDDir, group);

% Training & Questionnaires
familiariseOAE1(Fs);
% OA 9x
errorRate1 = OATrainingE1(sID{1}, seqCond, sIDDir, group, 1);
% BIG 5
[LikertBIG5 ScoresBIG5 BIGtrap] = BIG5(sID{1}, sIDDir);

% OA 9x
errorRate2 = OATrainingE1(sID{1}, seqCond, sIDDir, group, 2);
% IRI
[LikertIRI ScoresIRI IRItrap]= IRI(sID{1}, sIDDir);

% OA 9x
errorRate3 = OATrainingE1(sID{1}, seqCond, sIDDir, group, 3);
% NPI
[LikertNPI ScoresNPI NPItrap] = NPI(sID{1}, sIDDir);

% OA 9x
errorRate4 = OATrainingE1(sID{1}, seqCond, sIDDir, group, 4);
% Self-Construal scale
[LikertSC ScoresSC SCtrap] = SC(sID{1}, sIDDir);

% post Test
[PostOAavgs, PostUNavgs, PostOA, PostUN] = postTrainingE1(sID{1}, seqCond, sIDDir, group);
%

%% Save Questionnaires
filename = [sIDDir 'questionnaires.mat'];
save(filename, 'LikertBIG5', 'ScoresBIG5', 'BIGtrap', 'LikertIRI', 'IRItrap', 'ScoresIRI', 'LikertNPI', 'NPItrap', 'ScoresNPI', 'LikertSC', 'SCtrap', 'ScoresSC');

% ANALOGIES TEST (IQ2)
IQ2instr;
[score2, correct2, answ2] = IQ2;
filename = [sIDDir 'IQ2.mat'];
save(filename, 'score2', 'correct2', 'answ2');

% NUMBER SERIES TEST (IQ5)
IQ5instr;
[score5, correct5, answ5] = IQ5;
filename = [sIDDir 'IQ5.mat'];
save(filename, 'score5', 'correct5', 'answ5');

% WORKING MEMORY TEST (SSTM)
WMinstr;
filename = [sIDDir 'WM.mat'];
WMscore = SSTM(sID{1}, filename);

% ALL DONE
% Save results

PreOAadjMT = mean(PreOAavgs(:,2))*(mean(PreOAavgs(:,4))/5) + mean(PreOAavgs(:,2)); % RT * eror rate + RT
PreUNadjMT = mean(PreUNavgs(:,2))*(mean(PreUNavgs(:,4))/5) + mean(PreUNavgs(:,2)); % RT * eror rate + RT
PostOAadjMT = mean(PostOAavgs(:,2))*(mean(PostOAavgs(:,4))/5) + mean(PostOAavgs(:,2)); % RT * eror rate + RT
PostUNadjMT = mean(PostUNavgs(:,2))*(mean(PostUNavgs(:,4))/5) + mean(PostUNavgs(:,2)); % RT * eror rate + RT

AllResults = [
    mean(PreOAavgs(:,2:4)) ... % 1-3
    PreOAadjMT ... % RT * eror rate
    mean(PreUNavgs(:,2:4)) ... % 4-6
    PreUNadjMT ...
    mean(PostOAavgs(:,2:4)) ... % 7-9
    PostOAadjMT ...
    mean(PostUNavgs(:,2:4)) ... % 10-12
    PostUNadjMT ...
    mean(PreOAavgs(:,2:4)) - mean(PostOAavgs(:,2:4)) ... % 13-15
    PreOAadjMT - PostOAadjMT ...
    mean(PreUNavgs(:,2:4)) - mean(PostUNavgs(:,2:4)) ... % 16-18
    PreUNadjMT - PostUNadjMT ...
    errorRate1 errorRate2 errorRate3 errorRate4 ... % 19-22
    WMscore score2 score5 score9 sum([score2 score5 score9])... % 23-27
    cell2mat(ScoresBIG5(2,:)) BIGtrap cell2mat(ScoresIRI(2,:)) IRItrap cell2mat(ScoresNPI(2,1)) NPItrap cell2mat(ScoresSC(2,:)) SCtrap]; % 28-35

AllResults = num2cell(AllResults);

if isempty(participant.age)
    participant.age = {''};
end
if isempty(participant.gender)
    participant.gender = {''};
end
if isempty(participant.handed)
    participant.handed = {''};
end
if isempty(participant.english)
    participant.english = {''};
end

if ~isfield(participant, 'email') || isempty(participant.email)
    participant.email = {''};
end
AllResults = [seqCond participant.sID participant.email participant.gender participant.age participant.handed participant.english AllResults];
% save all subjects AllResults
AllResultsTxt={
    'seqCond' 'sID' 'email' 'gender' 'age' 'rightHanded' 'English' ...
    'PreOAMT' 'PreOACorrMT' 'PreOAErr' 'PreOAadjMT'...
    'PreUNMT' 'PreUNCorrMT' 'PreUNErr' 'PreUNadjMT'...
    'PostOAMT' 'PostOACorrMT' 'PostOAErr' 'PostOAadjMT' ...
    'PostUNMT' 'PostUNCorrMT' 'PostUNErr' 'PostUNadjMT' ...
    'PePoOAMT' 'PePoOACorrMT' 'PePoOAErr' 'PePoOAadjMT' ...
    'PePoUNMT' 'PePoUNCorrMT' 'PePoUNErr' 'PePoUNadjMT' ...
    'errorRate1' 'errorRate2' 'errorRate3' 'errorRate4' ...
    'WMscore' 'IQ2' 'IQ5' 'IQ9' 'IQsum' ...
    'Extraversion' 'Agreeableness' 'Conscientiousness' 'Neuroticism' 'Openness' 'BIGtrap' 'PT' 'FS' 'EC' 'PD' 'IRItrap' 'NPI' 'NPItrap' 'Interdependent' 'Independent' 'SCtrap'};

filename = [sIDDir 'Results.mat'];
save(filename);
end