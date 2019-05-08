function [Likert Scores IRItrap] = IRI(sID, sIDDir)
% A simple script to demonstrate CollectLikert with a 5-point scale.

% clear;

% Specifications for the overall window holding the questionnaire:
WindowLabel = 'Q';
WindowSpecs(1) = 200;  % Left edge (i.e., pixels in from left edge of screen)
WindowSpecs(2) = 100;  % Bottom edge (i.e., pixels up from from bottom edge of screen)
WindowSpecs(3) = 1000;  % Width in pixels
WindowSpecs(4) = 1000; % Height in pixels

% Specifications for an instruction box that appears on the questionnaire:
InstructionsText = ['\n\nThe following statements inquire about your thoughts and feelings in a variety of situations. \n'...
    'For each item, indicate how well it describes you by choosing the appropriate number on the scale from 1 to 5. '...
    'READ EACH ITEM CAREFULLY BEFORE RESPONDING.  Answer as honestly as you can. '...
    'When you have finished, check over each one to make sure you have answered them all.\n\n'...
    'Please call the experimenter if you have any questions.'];
InstructionHeight = 160;  % This must be set to the height of the instruction box; use trial and error.

% Here are the labels (left to right on the form) of the Likert scale points.
ScaleLabels{1} = 'Does not\ndescribe\nme well';
ScaleLabels{2} = '';
ScaleLabels{3} = '';
ScaleLabels{4} = '';
ScaleLabels{5} = 'Describes me\nvery well';
ScaleLabelsHeight = 100;  % This must be set to the height of the scale labels; use trial and error.
ScaleSmallestValue = 1;  % The scale values are to be numbered starting with this value.

RequireAllAnswers = 1;  % Set to 1 if all questions must be answered and 0 if some can be left blank.
MissingValue = -1;  % This is the score for any question that is not answered--only used if RequireAllAnswers is 0.

Questions{1} = 'I daydream and fantasize, with some regularity, about things that might happen to me. ';
Questions{2} = 'I often have tender, concerned feelings for people less fortunate than me. ';
Questions{3} = 'I sometimes find it difficult to see things from the "other guy''s" point of view. ';
Questions{4} = 'Sometimes I don''t feel very sorry for other people when they are having problems. ';
Questions{5} = 'I really get involved with the feelings of the characters in a novel. ';
Questions{6} = 'In emergency situations, I feel apprehensive and ill-at-ease. ';
Questions{7} = 'I am usually objective when I watch a movie or play, and I don''t often get completely caught up in it. ';
Questions{8} = 'I am answering honestly to these questions.'; % 5 trap
Questions{9} = 'I try to look at everybody''s side of a disagreement before I make a decision. ';
Questions{10} = 'When I see someone being taken advantage of, I feel kind of protective towards them. ';
Questions{11} = 'I sometimes feel helpless when I am in the middle of a very emotional situation. ';
Questions{12} = 'I sometimes try to understand my friends better by imagining how things look from their perspective. ';
Questions{13} = 'Becoming extremely involved in a good book or movie is somewhat rare for me. ';
Questions{14} = 'When I see someone get hurt, I tend to remain calm. ';
Questions{15} = 'Other people''s misfortunes do not usually disturb me a great deal. ';
Questions{16} = 'If I''m sure I''m right about something, I don''t waste much time listening to other people''s arguments. ';
Questions{17} = 'After seeing a play or movie, I have felt as though I were one of the characters. ';
Questions{18} = 'Being in a tense emotional situation scares me. ';
Questions{19} = 'When I see someone being treated unfairly, I sometimes don''t feel very much pity for them. ';
Questions{20} = 'When going out shopping I never take money with me.'; % 1 trap
Questions{21} = 'I am usually pretty effective in dealing with emergencies. ';
Questions{22} = 'I am often quite touched by things that I see happen. ';
Questions{23} = 'I believe that there are two sides to every question and try to look at them both. ';
Questions{24} = 'I would describe myself as a pretty soft-hearted person. ';
Questions{25} = 'When I watch a good movie, I can very easily put myself in the place of a leading character. ';
Questions{26} = 'I tend to lose control during emergencies. ';
Questions{27} = 'I signed consent form to take part in this experiment.'; % 5 trap
Questions{28} = 'When I''m upset at someone, I usually try to "put myself in his shoes" for a while. ';
Questions{29} = 'When I am reading an interesting story or novel, I imagine how I would feel if the events in the story were happening to me.';
Questions{30} = 'When I see someone who badly needs help in an emergency, I go to pieces. ';
Questions{31} = 'Before criticizing somebody, I try to imagine how I would feel if I were in their place. ';

QuestionWidth = 800;  % Width of the question on the form, in pixels
NQuestions = numel(Questions);
DefaultQuestionHeight = 60;   % This is a default question height in pixels that can be adjusted with trial and error.
QuestionHeights = DefaultQuestionHeight*ones(NQuestions); % Set all question heights to the default.
% To leave more or less height for particular questions, change their
% QuestionHeights here, after the default has been set.  For example,
% QuestionHeights(5) = DefaultQuestionHeight + 10;  % This leaves 10 extra pixels of height for question 10.

Likert = CollectLikert(WindowSpecs,WindowLabel,InstructionsText,InstructionHeight,...
    ScaleLabels,ScaleLabelsHeight, ScaleSmallestValue, ...
    Questions, QuestionWidth, QuestionHeights, RequireAllAnswers, MissingValue, DefaultQuestionHeight)
%% Calculate the scores
% changing the scale from 0 - 4 (was 1 - 5)
Likert = Likert - 1;
% reversing scores
Reversed = [3, 4, 7, 13, 14, 15, 16, 19, 21]';

ReversedLikert = Likert;
for i = 1 : 31
    if ismember(i, Reversed)
        ReversedLikert(i) = 4 - Likert(i);
    end
end
% keys
% PT = perspective-taking scale
PTKey = [3, 9, 12, 16, 23, 28, 31];
% FS = fantasy scale
FSKey = [1, 5, 7, 13, 17, 25, 29];
% EC = empathic concern scale
ECKey = [2, 4, 10, 15, 19, 22, 24];
% PD = personal distress scale
PDKey = [6, 11, 14, 18, 21, 26, 30];

% scores
PT = sum(ReversedLikert(PTKey));
FS = sum(ReversedLikert(FSKey));
EC = sum(ReversedLikert(ECKey));
PD = sum(ReversedLikert(PDKey));
% checking trap answers 8 20 27 [5 1 5]
trapCorrect = [4;0;4];
IRItrap = 3-sum(trapCorrect==ReversedLikert([8 20 27])); % how many are NOT correct

% output
Scores = [{'PT' 'FS' 'EC' 'PD'};...
    {PT FS EC PD}];
% save
% Get date and time
time = clock;
datetime = [datestr(now,'ddmmyyyy') '_' int2str(time(1,4)) int2str(time(1,5))];
save([sIDDir filesep num2str(sID) '_IRI_' datetime '.mat'], 'Likert', 'Scores', 'IRItrap');
end