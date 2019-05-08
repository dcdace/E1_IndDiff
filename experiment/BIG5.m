function [Likert Scores BIGtrap] = BIG5(sID, sIDDir)
% A simple script to demonstrate CollectLikert with a 5-point scale.

% clear;

% Specifications for the overall window holding the questionnaire:
WindowLabel = 'Q';
WindowSpecs(1) = 200;  % Left edge (i.e., pixels in from left edge of screen)
WindowSpecs(2) = 100;  % Bottom edge (i.e., pixels up from from bottom edge of screen)
WindowSpecs(3) = 800;  % Width in pixels
WindowSpecs(4) = 1000; % Height in pixels

% Specifications for an instruction box that appears on the questionnaire:
InstructionsText = ['\n\nHere are a number of characteristics that may or may not apply to you. '...
    'For example, do you agree that you are someone who likes to spend time with others? ' ...
    'Please answer each item by marking a number to indicate how much you agree or disagree with each statement. '...
    'Answer all items even if unsure of your answer. ' ...
    'When you have finished, check over each one to make sure you have answered them all.\n\n'...
    'Please call the experimenter if you have any questions.'];
InstructionHeight = 180;  % This must be set to the height of the instruction box; use trial and error.

% Here are the labels (left to right on the form) of the Likert scale points.
ScaleLabels{1} = 'Disagree strongly';
ScaleLabels{2} = 'Disagree a little';
ScaleLabels{3} = 'Neither agree\nnor disagree';
ScaleLabels{4} = 'Agree a little';
ScaleLabels{5} = 'Agree strongly';
ScaleLabelsHeight = 120;  % This must be set to the height of the scale labels; use trial and error.
ScaleSmallestValue = 1;  % The scale values are to be numbered starting with this value.

RequireAllAnswers = 1;  % Set to 1 if all questions must be answered and 0 if some can be left blank.
MissingValue = -1;  % This is the score for any question that is not answered--only used if RequireAllAnswers is 0.

Questions{1} = 'I am someone who Is talkative ';
Questions{2} = 'I am someone who Tends to find fault with others';
Questions{3} = 'I am someone who Does a thorough job';
Questions{4} = 'I am someone who Is depressed, blue ';
Questions{5} = 'I am someone who Is original, comes up with new ideas';
Questions{6} = 'I am someone who Is reserved';
Questions{7} = 'I am someone who Is helpful and unselfish with others';
Questions{8} = 'I am someone who Can be somewhat careless';
Questions{9} = 'I am someone who Is relaxed, handles stress well';
Questions{10} = 'I am someone who Is curious about many different things ';
Questions{11} = 'I am someone who Is full of energy';
Questions{12} = 'I am someone who Starts quarrels with others';
Questions{13} = 'I am someone who Is answering these questions '; % 5 trap
Questions{14} = 'I am someone who Is a reliable worker ';
Questions{15} = 'I am someone who Can be tense ';
Questions{16} = 'I am someone who Is ingenious, a deep thinker ';
Questions{17} = 'I am someone who Generates a lot of enthusiasm';
Questions{18} = 'I am someone who Has a forgiving nature';
Questions{19} = 'I am someone who Tends to be disorganized';
Questions{20} = 'I am someone who Worries a lot ';
Questions{21} = 'I am someone who Has an active imagination ';
Questions{22} = 'I am someone who Tends to be quiet ';
Questions{23} = 'I am someone who Is generally trusting ';
Questions{24} = 'I am someone who Tends to be lazy';
Questions{25} = 'I am someone who Is emotionally stable, not easily upset';
Questions{26} = 'I am someone who Is inventive ';
Questions{27} = 'I am someone who Is not able to breathe '; % 1 trap
Questions{28} = 'I am someone who Has an assertive personality ';
Questions{29} = 'I am someone who Can be cold and aloof ';
Questions{30} = 'I am someone who Perseveres until the task is finished ';
Questions{31} = 'I am someone who Can be moody ';
Questions{32} = 'I am someone who Values artistic, aesthetic experiences ';
Questions{33} = 'I am someone who Is sometimes shy, inhibited ';
Questions{34} = 'I am someone who Is considerate and kind to almost everyone ';
Questions{35} = 'I am someone who Does things efficiently ';
Questions{36} = 'I am someone who Remains calm in tense situations ';
Questions{37} = 'I am someone who Prefers work that is routine ';
Questions{38} = 'I am someone who Is outgoing, sociable ';
Questions{39} = 'I am someone who Is sometimes rude to others';
Questions{40} = 'I am someone who Is answering honestly to these questions'; % 5 trap
Questions{41} = 'I am someone who Makes plans and follows through with them';
Questions{42} = 'I am someone who Gets nervous easily ';
Questions{43} = 'I am someone who Likes to reflect, play with ideas ';
Questions{44} = 'I am someone who Has few artistic interests ';
Questions{45} = 'I am someone who Likes to cooperate with others ';
Questions{46} = 'I am someone who Is easily distracted ';
Questions{47} = 'I am someone who Is sophisticated in art, music, or literature ';

QuestionWidth           = 500;  % Width of the question on the form, in pixels
NQuestions              = numel(Questions);
DefaultQuestionHeight   = 30;   % This is a default question height in pixels that can be adjusted with trial and error.
QuestionHeights         = DefaultQuestionHeight*ones(NQuestions); % Set all question heights to the default.
% To leave more or less height for particular questions, change their
% QuestionHeights here, after the default has been set.  For example,
% QuestionHeights(5) = DefaultQuestionHeight + 10;  % This leaves 10 extra pixels of height for question 10.

Likert = CollectLikert(WindowSpecs,WindowLabel,InstructionsText,InstructionHeight,...
    ScaleLabels,ScaleLabelsHeight, ScaleSmallestValue, ...
    Questions, QuestionWidth, QuestionHeights, RequireAllAnswers, MissingValue, DefaultQuestionHeight);

%% Calculate the scores
% reversing scores
Reversed = [6, 22, 33, 2, 12, 29, 39,2, 12, 29, 39, 8, 19, 24, 46, 9, 25, 36, 37, 44]';
ReversedLikert = Likert;
for i = 1 : 47
    if ismember(i, Reversed)
        ReversedLikert(i) = 6 - Likert(i);
    end
end

% keys
ExtraversionKey         = [1, 6, 11, 17, 22, 28, 33, 38];
AgreeablenessKey        = [2, 7, 12, 18, 23, 29, 34, 39, 45];
ConscientiousnessKey    = [3, 8, 14, 19, 24, 30, 35, 41, 46];
NeuroticismKey          = [4, 9, 15, 20, 25, 31, 36, 42];
OpennessKey             = [5, 10, 16, 21, 26, 32, 37, 43, 44, 47];

% scores
Extraversion        = mean(ReversedLikert(ExtraversionKey));
Agreeableness       = mean(ReversedLikert(AgreeablenessKey));
Conscientiousness   = mean(ReversedLikert(ConscientiousnessKey));
Neuroticism         = mean(ReversedLikert(NeuroticismKey));
Openness            = mean(ReversedLikert(OpennessKey));
% checking trap answers 13 27 40 [5 1 5]
trapCorrect = [5;1;5];
BIGtrap = 3-sum(trapCorrect==ReversedLikert([13 27 40])); % how many are NOT correct
% output
Scores = [{'Extraversion' 'Agreeableness' 'Conscientiousness' 'Neuroticism' 'Openness'};...
    {Extraversion Agreeableness Conscientiousness Neuroticism Openness}];
% save
% Get date and time
time = clock;
datetime = [datestr(now,'ddmmyyyy') '_' int2str(time(1,4)) int2str(time(1,5))];
save([sIDDir filesep num2str(sID) '_BIG5_' datetime '.mat'], 'Likert', 'Scores', 'BIGtrap');
end