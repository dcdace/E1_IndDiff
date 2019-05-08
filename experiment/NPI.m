function [Likert, Scores, NPItrap] = NPI(sID, sIDDir)
% A simple script to demonstrate CollectLikert with a 5-point scale.

% clear;

% Specifications for the overall window holding the questionnaire:
WindowLabel = 'Q';
WindowSpecs(1) = 200; % Left edge (i.e., pixels in from left edge of screen)
WindowSpecs(2) = 100; % Bottom edge (i.e., pixels up from from bottom edge of screen)
WindowSpecs(3) = 1000; % Width in pixels
WindowSpecs(4) = 1000; % Height in pixels

% Specifications for an instruction box that appears on the questionnaire:
InstructionsText = ['\n\nThis inventory consists of a number of pairs of statements with which you may or may not identify.\n'...
  'You may identify with both 1 and 2. In this case you should choose the statement which seems closer to yourself. '...
  'Or, if you do not identify with either statement, select the one which is least objectionable or remote.\n'...
  'In other words, read each pair of statements and then choose the one that is closer to you own feelings. '...
  'Indicate your answer by choosing the option 1 or 2. Please do not skip any items.\n\n'...
  'Please call the experimenter if you have any questions.'];

InstructionHeight = 200; % This must be set to the height of the instruction box; use trial and error.

% Here are the labels (left to right on the form) of the Likert scale points.
ScaleLabels{1} = '';
ScaleLabels{2} = '';
ScaleLabelsHeight = 10; % This must be set to the height of the scale labels; use trial and error.
ScaleSmallestValue = 1; % The scale values are to be numbered starting with this value.

RequireAllAnswers = 1; % Set to 1 if all questions must be answered and 0 if some can be left blank.
MissingValue = -1; % This is the score for any question that is not answered--only used if RequireAllAnswers is 0.

Questions{1} = '1. I have a natural talent for influencing people. \\ 2. I am not good at influencing people.';
Questions{2} = '1. Modesty doesn''t become me. \\ 2. I am essentially a modest person.';
Questions{3} = '1. I would do almost anything on a dare. \\ 2. I tend to be a fairly cautious person.';
Questions{4} = '1. When people compliment me I sometimes get embarrassed. \\ 2. I know that I am good because everybody keeps telling me so.';
Questions{5} = '1. The thought of ruling the world frightens the hell out of me. \\  2. If I ruled the world it would be a better place.';
Questions{6} = '1. I can usually talk my way out of anything. \\ 2. I try to accept the consequences of my behaviour.';
Questions{7} = '1. I prefer to blend in with the crowd. \\ 2. I like to be the centre of attention.';
Questions{8} = '1. I will be a success. \\ 2. I am not too concerned about success.';
Questions{9} = '1. I am no better or worse than most people. \\  2. I think I am a special person.';
Questions{10} = '1. I am not sure if I would make a good leader. \\  2. I see myself as a good leader.';
Questions{11} = '1. I am honest answering these questions. \\ 2. I am just randomly selecting the answers.'; % 1 trap
Questions{12} = '1. I am assertive. \\ 2. I wish I were more assertive.';
Questions{13} = '1. I like to have authority over other people. \\ 2. I don''t mind following orders.';
Questions{14} = '1. I find it easy to manipulate people. \\ 2. I don''t like it when I find myself manipulating people.';
Questions{15} = '1. I insist upon getting the respect that is due me. \\ 2. I usually get the respect that I deserve.';
Questions{16} = '1. I don''t particularly like to show off my body. \\ 2. I like to show off my body.';
Questions{17} = '1. I can read people like a book. \\ 2. People are sometimes hard to understand.';
Questions{18} = '1. If I feel competent I am willing to take responsibility for making decisions. \\ 2. I like to take responsibility for making decisions.';
Questions{19} = '1. I just want to be reasonably happy. \\ 2. I want to amount to something in the eyes of the world.';
Questions{20} = '1. My body is nothing special. \\ 2. I like to look at my body.';
Questions{21} = '1. I try not to be a show off. \\ 2. I will usually show off if I get the chance.';
Questions{22} = '1. I always know what I am doing. \\ 2. Sometimes I am not sure of what I am doing.';
Questions{23} = '1. I sometimes depend on people to get things done. \\ 2. I rarely depend on anyone else to get things done.';
Questions{24} = '1. Sometimes I tell good stories. \\ 2. Everybody likes to hear my stories.';
Questions{25} = '1. The sun rotates around the earth. \\ 2. The earth rotates around the sun.'; % 2 trap
Questions{26} = '1. I expect a great deal from other people. \\ 2. I like to do things for other people.';
Questions{27} = '1. I will never be satisfied until I get all that I deserve. \\ 2. I take my satisfactions as they come.';
Questions{28} = '1. Compliments embarrass me. \\ 2. I like to be complimented.';
Questions{29} = '1. I have a strong will to power. \\ 2. Power for its own sake doesn''t interest me.';
Questions{30} = '1. I don''t care about new fads and fashions. \\ 2. I like to start new fads and fashions.';
Questions{31} = '1. I like to look at myself in the mirror. \\ 2. I am not particularly interested in looking at myself in the mirror.';
Questions{32} = '1. I really like to be the centre of attention. \\ 2. It makes me uncomfortable to be the centre of attention.';
Questions{33} = '1. I can live my life in any way I want to. \\ 2. People can''t always live their lives in terms of what they want.';
Questions{34} = '1. Being an authority doesn''t mean that much to me. \\ 2. People always seem to recognize my authority.';
Questions{35} = '1. I know I am a world famous scientist. \\ 2. I signed consent form to take part in this experiment.'; % 2 trap
Questions{36} = '1. I would prefer to be a leader. \\ 2. It makes little difference to me whether I am a leader or not.';
Questions{37} = '1. I am going to be a great person. \\ 2. I hope I am going to be successful.';
Questions{38} = '1. People sometimes believe what I tell them. \\ 2. I can make anybody believe anything I want them to.';
Questions{39} = '1. I am a born leader. \\ 2. Leadership is a quality that takes a long time to develop.';
Questions{40} = '1. I wish somebody would someday write my biography. \\ 2. I don''t like people to pry into my life for any reason.';
Questions{41} = '1. I get upset when people don''t notice how I look when I go out in public. \\ 2. I don''t mind blending into the crowd when I go out in public.';
Questions{42} = '1. I am more capable than other people. \\ 2. There is a lot that I can learn from other people.';
Questions{43} = '1. I am much like everybody else. \\ 2. I am an extraordinary person.';

QuestionWidth = 800; % Width of the question on the form, in pixels
NQuestions = numel(Questions);
DefaultQuestionHeight = 40;  % This is a default question height in pixels that can be adjusted with trial and error.
QuestionHeights = DefaultQuestionHeight*ones(NQuestions); % Set all question heights to the default.
% To leave more or less height for particular questions, change their
% QuestionHeights here, after the default has been set. For example,
% QuestionHeights(5) = DefaultQuestionHeight + 10; % This leaves 10 extra pixels of height for question 10.

Likert = CollectLikert(WindowSpecs,WindowLabel,InstructionsText,InstructionHeight,...
  ScaleLabels,ScaleLabelsHeight, ScaleSmallestValue, ...
  Questions, QuestionWidth, QuestionHeights, RequireAllAnswers, MissingValue, DefaultQuestionHeight);

%% Calculate the scores
NPIkey = [1;1;1;2;2;1;2;1;2;2;0;1;1;1;1;2;1;2;2;2;2;1;2;2;0;1;1;2;1;2;1;1;1;2;0;1;1;2;1;1;1;1;2;];
AuthorityKey        = [1, 8, 10, 12, 13, 34, 36, 39];
SelfSufficiencyKey  = [18, 22, 23, 33, 37, 42];
SuperiorityKey      = [4, 9, 28, 40, 43];
ExhibitionismKey    = [2, 3, 7, 21, 30, 32, 41];
ExploitativenessKey = [6, 14, 17, 24, 38];
VanityKey           = [16, 20, 31];
EntitlementKey      = [5, 15, 19, 26, 27, 29];

NPI = 0;
[Authority, SelfSufficiency, Superiority,Exhibitionism, Exploitativeness, Vanity, ...
    Entitlement] = deal(0);
for i = 1 : 43
    if Likert(i,1) == NPIkey(i,1)
        NPI = NPI + 1;
        if ismember(i,AuthorityKey)
            Authority = Authority + 1;
        end
        if ismember(i,SelfSufficiencyKey)
            SelfSufficiency = SelfSufficiency + 1;
        end
        if ismember(i,SuperiorityKey)
            Superiority = Superiority + 1;
        end
        if ismember(i,ExhibitionismKey)
            Exhibitionism = Exhibitionism + 1;
        end
         if ismember(i,ExploitativenessKey)
            Exploitativeness = Exploitativeness + 1;
         end
        if ismember(i,VanityKey)
            Vanity = Vanity + 1;
        end
        if ismember(i,EntitlementKey)
            Entitlement = Entitlement + 1;
        end
    end
end
Scores = [{'NPI', 'Authority', 'SelfSufficiency', 'Superiority', 'Exhibitionism', 'Exploitativeness', 'Vanity', ...
    'Entitlement'}; ...
{NPI, Authority, SelfSufficiency, Superiority, Exhibitionism, Exploitativeness, Vanity, ...
    Entitlement}];
% checking trap answers 11 25 35 [1 2 2]
trapCorrect = [1;2;2];
NPItrap = 3-sum(trapCorrect==Likert([11 25 35])); % how many are NOT correct

% save
% Get date and time
time = clock;
datetime = [datestr(now,'ddmmyyyy') '_' int2str(time(1,4)) int2str(time(1,5))];
save([sIDDir filesep num2str(sID) '_NPI_' datetime '.mat'], 'Likert', 'Scores', 'NPItrap');
end