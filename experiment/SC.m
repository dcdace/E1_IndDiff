function [Likert Scores SCtrap] = SC(sID, sIDDir)
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

Questions{1} = 'I have respect for the authority figures with whom I interact';
Questions{2} = 'It is important for me to maintain harmony within my group';
Questions{3} = 'My happiness depends on the happiness of those around me';
Questions{4} = 'I would offer my seat in a bus to my professor';
Questions{5} = 'I never ever wear socks at home'; % 1 trap
Questions{6} = 'I respect people who are modest about themselves';
Questions{7} = 'I will sacrifice my self-interest for the benefit of the group I am in';
Questions{8} = 'I often have a feeling that my relationship with others are more important than my own accomplishments';
Questions{9} = 'I should take into consideration my parents'' advice when making education/career plans';
Questions{10} = 'It is important to me to respect decisions made by the group';
Questions{11} = 'I will stay in a group if they need me, even when I am not happy with the group';
Questions{12} = 'I am answering honestly to these questions'; % 5 trap
Questions{13} = 'If my brother or sister fails, I feel responsible';
Questions{14} = 'Even when I strongly disagree with group members, I avoid an argument';

Questions{15} = 'I would rather say "No" directly, than risk being misunderstood';
Questions{16} = 'Speaking up during a class is not a problem for me';
Questions{17} = 'Having a lively imagination is important for me';
Questions{18} = 'I am comfortable with being singled out for praise or rewards';
Questions{19} = 'I am the same person at home that I am at school/work';
Questions{20} = 'I signed consent form to take part in this experiment.'; % 1 trap
Questions{21} = 'Being able to take care of myself is a primary concern for me';
Questions{22} = 'I act the same way no matter who I am with';
Questions{23} = 'I feel comfortable using someone''s first name soon after I meet them, even when they are much older than I am';
Questions{24} = 'I prefer to be direct and forthright when dealing with people I have just met';
Questions{25} = 'I enjoy being unique and different from others in many respects';
Questions{26} = 'My personal identity independent of others, is very important to me';
Questions{27} = 'I value being in good health above everything';

QuestionWidth = 550;  % Width of the question on the form, in pixels
NQuestions = numel(Questions);
DefaultQuestionHeight = 46;   % This is a default question height in pixels that can be adjusted with trial and error.
QuestionHeights = DefaultQuestionHeight*ones(NQuestions); % Set all question heights to the default.
% To leave more or less height for particular questions, change their
% QuestionHeights here, after the default has been set.  For example,
% QuestionHeights(5) = DefaultQuestionHeight + 10;  % This leaves 10 extra pixels of height for question 10.

Likert = CollectLikert(WindowSpecs,WindowLabel,InstructionsText,InstructionHeight,...
    ScaleLabels,ScaleLabelsHeight, ScaleSmallestValue, ...
    Questions, QuestionWidth, QuestionHeights, RequireAllAnswers, MissingValue, DefaultQuestionHeight);

%% Calculate the scores
% scores
% Interdependent = sum(Likert(1:12,1));
% Independent = sum(Likert(13:24,1));
% traps 5 12 20 
Interdependent = sum(Likert(1:14,1)) - sum(Likert([5 12],1));
Independent = sum(Likert(15:27,1)) - Likert(20,1);

% checking trap answers 5 12 20 [1 5 1]
trapCorrect = [1;5;1];
SCtrap = 3-sum(trapCorrect==Likert([5 12 20])); % how many are NOT correct

% output
Scores = [{'Interdependent' 'Independent'};...
    {Interdependent Independent}];
% save
% Get date and time
time = clock;
datetime = [datestr(now,'ddmmyyyy') '_' int2str(time(1,4)) int2str(time(1,5))];
save([sIDDir filesep num2str(sID) '_SC_' datetime '.mat'], 'Likert', 'Scores', 'SCtrap');
end