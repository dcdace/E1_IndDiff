function [LikertLineScores] = CollectLikert(WindowSpecs, WindowTitle, InstructionsText, InstructionsHeight, ...
    ScaleLabels, ScaleLabelsHeight, ScaleSmallestValue, ...
    Questions, QuestionWidth, QuestionHeights, RequireAllAnswers, MissingValue, DefaultQuestionHeight)
% CollectLikert: Collect responses to a Likert-type questionnaire.

% This function presents a Likert-type questionnaire, records the responses,
% and returns those responses when the user clicks the "Done" button.
% If there are too many questions to display on a single page,
% the routine handles multiple pages automatically.

% See DemoLikert5.m for a script demonstrating the use of the function.

% **************** Explanation of the Parameters Starts Here

% WindowSpecs is an array of 4 numbers determining the pixel coordinates of the questionnaire window.
% These pixel coordinates are relative to the overall screen resolution (e.g., 1366 x 768 or whatever).
%   WindowSpecs(1) = Number of pixels between left edge of screen and left edge of window.
%   WindowSpecs(2) = Number of pixels between bottom edge of screen and bottom edge of window.
%   WindowSpecs(3) = Width of the window, in pixels.
%   WindowSpecs(4) = Height of the window, in pixels.

% WindowTitle is a string written at the top of the questionnaire window.

% InstructionsText is a string written as instructions at the top of the questionnaire window.
%   It can exend across several lines by including the \n newline character where you want
%   a new line to start.

% InstructionsHeight is the height (in pixels) of the instruction block at the top of the questionnaire window.

% The next 3 parameters describe the Likert scale:
%   ScaleLabels is an array of strings, with one string to label each point on the scale.
%   ScaleLabelsHeight is the height (in pixels) need to write these labels
%      (they are written vertically between the instructions and the first question).
%   ScaleSmallestValue is the number assigned to the smallest scale value (typically 0 or 1).

% The next three parameters describe the questions/items for which Likert responses should be collected:
%   Questions is an array of strings that are the actual questions/items that are to be rated on the Likert scale.
%   QuestionWidth is the width (in pixels) of the text block allocated for each question.  This is the same
%     for all questions/items.
%   QuestionHeights is an _array_ with one entry per question.  Each array element is the height (in pixels)
%     allocated to the corresponding question.  This parameter is provided so that long questions/items
%     can be displayed across multiple lines (and thus need more height).

% RequireAllAnswers is either 0 or 1:
%   Use 0 if some questions may be left blank.
%   Use 1 if all questions must be answered.

% MissingValue is the numerical value that will be returned for any questionnaire item that is not answered.
%   (This parameter is only used if RequireAllAnswers is 0.)


% **************** Explanation of the Parameters Ends Here


% **************** Here are some additional display layout parameters.
% These are reasonable defaults but can be changed as needed.
LeftMargin = 10;
RightMargin = 10;
BottomMargin = 10;  % From bottom of window to bottom edge of buttons Done, etc
TopMargin = 5;
% The radio buttons are used for the Likert scale answer points:
RadioButtonHeight = DefaultQuestionHeight;
RadioButtonWidth = 35;
QuestionVerticalGap = 5;  % Vertical gap between questions
ButtonNextStr = 'Next';
ButtonBackStr = 'Back';
ButtonDoneStr = 'Done';
ButtonWidth = 60;
ButtonHeight = 40;
TextHeight = 20;
GapBetweenQuestionColumns = 30;
% **************** End of display layout parameters.

% Ideally, nothing should be changed after this point.

% Define the window:
WindowLowerLeftX = WindowSpecs(1);  % Number of pixels between left edge of screen and left edge of window.
WindowLowerLeftY = WindowSpecs(2);  % Number of pixels between bottom edge of screen and bottom edge of window.
WindowWidth = WindowSpecs(3);       % Width of the window, in pixels.
WindowHeight = WindowSpecs(4);      % Height of the window, in pixels.


% Define handles to display all of the questions.

% This command activates the an overall window (figure) for the questionnaire form.
WindowHandle = figure('MenuBar','None','NumberTitle','off','name',WindowTitle, ...
    'Position',[WindowLowerLeftX, WindowLowerLeftY, WindowWidth, WindowHeight], 'Color', [1 1 1]);
Shared = guihandles(WindowHandle);  % Create a structure for storing shared data

% Display the instructions at the top of the window:
InstructionX = LeftMargin;
InstructionY = WindowHeight-TopMargin-InstructionsHeight;
InstructionWidth = WindowWidth - LeftMargin - RightMargin;
% Note: Must use sprintf(Instruction) to interpret newlines.
InstructionHandle = uicontrol(WindowHandle,'Style','text','String',sprintf(InstructionsText), ...
    'HorizontalAlignment','left', ...
    'Position',[InstructionX InstructionY InstructionWidth InstructionsHeight], ...
    'FontSize', 16, 'FontUnits', 'pixels', 'FontName', 'Veranda', 'BackgroundColor', [1 1 1]);

Shared.NScalePoints = numel(ScaleLabels);  % Number of responses on scale
ColumnWidth = QuestionWidth+Shared.NScalePoints*RadioButtonWidth;

% Display the labels of the Likert scale points.
% Unfortunately, a serious cluge is needed to get rotated text:
% ScaleLabelsX and Y positions must be defined relative to a 0-1 coordinate axes
% of an invisible (but necessary graph). The cluge is needed because
% MatLab provides no rotation property for text uicontrols.  The only
% way to get rotated text is to define a graph (with axes) and then
% use the "text" command which works relative to that graph.
% The position property is used so that the axes span (almost) the whole window.
% Known "bug": This will display label headings over empty columns if there are not enough
% questions to justify having those column(s)--eg on later pages or with wide windows! :(
CurrentColumn = 0;
ScaleLabelsXPos = -ColumnWidth;
axeshandle = axes('Position',[0.01 0.02 0.99 0.99],'Visible','off');
while ScaleLabelsXPos < WindowWidth-ColumnWidth
    CurrentColumn = CurrentColumn + 1;
    ScaleLabelsXPos = LeftMargin+(CurrentColumn-1)*(ColumnWidth+GapBetweenQuestionColumns)+QuestionWidth;   % RadioButtonWidth/2 is a cluge but looks OK
    ScaleLabelsYPos = WindowHeight-InstructionsHeight-ScaleLabelsHeight;
    for iLabel = 1:Shared.NScalePoints
        ScaleLabelsThisX = ScaleLabelsXPos + (iLabel-1)*RadioButtonWidth;
        h = text(ScaleLabelsThisX/WindowWidth/0.99,ScaleLabelsYPos/WindowHeight,sprintf(ScaleLabels{iLabel}),'Rotation',90,...
            'FontSize', 13, 'FontUnits', 'pixels','FontName', 'Veranda');
    end
end

NQuestions = length(Questions);

TopQuestionStartY = InstructionY - ScaleLabelsHeight;

% Define controls for each of the questions and its associated radio buttons,
% setting visibility to off for all of them.
% If there are more questions that will fit on a single page,
% we will present multiple pages with "next" and "back" buttons, etc.
HeightAvailableForQuestions = WindowHeight - InstructionsHeight - ScaleLabelsHeight - ButtonHeight - BottomMargin;
Shared.CurrentPage = 1;
CurrentColumn = 1;
QuestionX = LeftMargin;
SumQuestionHeightsThisColumn = 0;
StartQuestionThisPage = 1;
for iQuestion = 1:NQuestions
    SumQuestionHeightsThisColumn = SumQuestionHeightsThisColumn + QuestionHeights(iQuestion);
    if SumQuestionHeightsThisColumn > HeightAvailableForQuestions
        % Start a new column or a new page
        CurrentColumn = CurrentColumn + 1;
        QuestionX = LeftMargin + (CurrentColumn-1)*(ColumnWidth+GapBetweenQuestionColumns);
        SumQuestionHeightsThisColumn = QuestionHeights(iQuestion);
        if QuestionX + ColumnWidth > WindowWidth
            % Must start a new page
            Shared.PageQuestions(Shared.CurrentPage,1) = StartQuestionThisPage;
            Shared.PageQuestions(Shared.CurrentPage,2) = iQuestion - 1;
            Shared.CurrentPage = Shared.CurrentPage + 1;
            StartQuestionThisPage = iQuestion;
            CurrentColumn = 1;
            QuestionX = LeftMargin;
        end
    end
    QuestionY = TopQuestionStartY - SumQuestionHeightsThisColumn;
    SumQuestionHeightsThisColumn = SumQuestionHeightsThisColumn + QuestionVerticalGap;
    Shared.QuestionHandles(iQuestion) = uicontrol(WindowHandle,'Style','text','String',Questions(iQuestion), ...
        'HorizontalAlignment','left', ...
        'Visible','off', ...
        'Position',[QuestionX,QuestionY,QuestionWidth,QuestionHeights(iQuestion)],...
        'FontSize', 16, 'FontUnits', 'pixels', 'FontName', 'Veranda');
    RadioButtonX = QuestionX+QuestionWidth;
    RadioButtonY = QuestionY;
    for iResp = 1:Shared.NScalePoints
        Shared.RadioHandles(iQuestion).radio(iResp) = uicontrol('Style', 'radiobutton', ...
            'Callback', @myRadio, ...
            'Units',    'pixels', ...
            'Visible','off', ...
            'Position', [RadioButtonX+(iResp-1)*RadioButtonWidth, RadioButtonY, RadioButtonWidth, RadioButtonHeight], ...
            'String',   num2str(iResp-1+ScaleSmallestValue), ...
            'Value',    0,...
            'FontSize', 14, 'FontUnits', 'pixels');
    end
end
Shared.PageQuestions(Shared.CurrentPage,1) = StartQuestionThisPage;
Shared.PageQuestions(Shared.CurrentPage,2) = NQuestions;
Shared.NPages = Shared.CurrentPage;

% Here is a structure to hold the radio button values.
Shared.StoredRadioValues=zeros(NQuestions,Shared.NScalePoints);

% Allocate the buttons and page strings shown at the bottom of the form.
ButtonX = LeftMargin;
ButtonY = BottomMargin;
Shared.ButtonBack = uicontrol('Position', [ButtonX ButtonY ButtonWidth ButtonHeight], 'String',ButtonBackStr, ...
    'Callback', @myBack, 'Visible','off');
ButtonX = WindowWidth-ButtonWidth-RightMargin;
Shared.ButtonNext = uicontrol('Position', [ButtonX ButtonY ButtonWidth ButtonHeight], 'String',ButtonNextStr, ...
    'Callback', @myNext, 'Visible','off');
Shared.ButtonDone = uicontrol('Position', [ButtonX ButtonY ButtonWidth ButtonHeight], 'String',ButtonDoneStr, ...
    'Callback', 'uiresume(gcbf)', 'Visible','off');

if Shared.NPages > 1
    Shared.PageNumberHandle = uicontrol(WindowHandle,'Style','text','String','page X of Y', ...
        'HorizontalAlignment','center', ...
        'Position',[WindowWidth/2-2*ButtonWidth BottomMargin 4*ButtonWidth TextHeight]);
end

red = [1 0 0];  % Color to mark unanswered questions.
AnswerAllHandle = uicontrol(WindowHandle,'Style','text','String','Please answer all questions!', ...
    'ForegroundColor',red, ...
    'HorizontalAlignment','center', ...
    'Visible','off', ...
    'Position',[WindowWidth/2-2*ButtonWidth BottomMargin+TextHeight 4*ButtonWidth TextHeight],...
    'FontSize', 16, 'FontUnits', 'pixels', 'FontName', 'Veranda', 'FontWeight', 'bold', 'BackgroundColor', [1 1 1]);

Shared.CurrentPage = 1;

guidata(WindowHandle,Shared);  % stores Shared info
MakeVisible(WindowHandle);  % Show the first page

uiwait(WindowHandle);
Shared = guidata(WindowHandle);  % Retrieve Shared info after interacting with user.

if RequireAllAnswers > 0
    black = [0 0 0];  % Color to mark answered questions.
    
    Incomplete = 1;
    while Incomplete > 0
        Incomplete = 0;
        for iQuestion = 1:NQuestions
            if sum(Shared.StoredRadioValues(iQuestion,:)) == 0
                Incomplete = 1;
                set(Shared.QuestionHandles(iQuestion),'ForegroundColor',red);
            else
                set(Shared.QuestionHandles(iQuestion),'ForegroundColor',black);
            end
        end
        guidata(WindowHandle,Shared);  % stores Shared info
        if Incomplete > 0
            MakeInvisible(WindowHandle);
            Shared = guidata(WindowHandle);  % Retrieve Shared info after interacting with user.
            Shared.CurrentPage = FirstIncompletePageNumber(WindowHandle);
            set(AnswerAllHandle,'Visible','on');
            guidata(WindowHandle,Shared);  % stores Shared info
            MakeVisible(WindowHandle);
            uiwait(WindowHandle);
            Shared = guidata(WindowHandle);  % Retrieve Shared info after interacting with user.
        end
    end
end

LikertLineScores = zeros(NQuestions,1);
for iQuestion=1:NQuestions
    a=find(Shared.StoredRadioValues(iQuestion,:)>0);
    if numel(a) ~= 1
        a = MissingValue + 1 - ScaleSmallestValue;  % The final result will be "MissingValue"
    end
    LikertLineScores(iQuestion) = a - 1 + ScaleSmallestValue;
end

close(WindowHandle);

end  % function LikertCollect


function [] = myRadio(WindowHandle, ~)
% This function handles the change in status for any radio button.
% It first checks the current status of all radio buttons
% against an array of stored radio values to see which
% question has had a button changed.  Then it turns off all of the other
% radio buttons for that question.
Shared = guidata(WindowHandle);   % retrieves Shared info
FirstQuestionThisPage = Shared.PageQuestions(Shared.CurrentPage,1);
LastQuestionThisPage = Shared.PageQuestions(Shared.CurrentPage,2);
black = [0 0 0];  % Color to mark answered questions.
for iQuestion=FirstQuestionThisPage:LastQuestionThisPage;
    for iScale=1:Shared.NScalePoints
        if get(Shared.RadioHandles(iQuestion).radio(iScale),'Value') ~= Shared.StoredRadioValues(iQuestion,iScale)
            ChangedQuestion = iQuestion;
            set(Shared.QuestionHandles(ChangedQuestion),'ForegroundColor',black);
            NewScale = iScale;
            Shared.StoredRadioValues(iQuestion,iScale) = get(Shared.RadioHandles(iQuestion).radio(iScale),'Value');
        end
    end
end
for iScale=1:Shared.NScalePoints
    if iScale ~= NewScale
        set(Shared.RadioHandles(ChangedQuestion).radio(iScale),'Value',0);
        Shared.StoredRadioValues(ChangedQuestion,iScale) = 0;
    end
end
guidata(WindowHandle,Shared);   % stores altered Shared info
end

function [] = myBack(WindowHandle, ~)
% This function handles a press of the Back button
MakeInvisible(WindowHandle);
Shared = guidata(gcbf);
Shared.CurrentPage = Shared.CurrentPage - 1;
guidata(gcbf,Shared);
MakeVisible(WindowHandle);
end

function [] = myNext(WindowHandle, ~)
% This function handles a press of the Next button
MakeInvisible(WindowHandle);
Shared = guidata(gcbf);
Shared.CurrentPage = Shared.CurrentPage + 1;
guidata(gcbf,Shared);
MakeVisible(WindowHandle);
end

function [] = MakeVisible(WindowHandle)
Shared = guidata(WindowHandle);
for iQuestion=Shared.PageQuestions(Shared.CurrentPage,1):Shared.PageQuestions(Shared.CurrentPage,2)
    set(Shared.QuestionHandles(iQuestion),'Visible','on');
    for iRadio=1:Shared.NScalePoints
        set(Shared.RadioHandles(iQuestion).radio(iRadio),'Visible','on');
    end
end
if Shared.NPages > 1
    set(Shared.PageNumberHandle,'string',['page ' num2str(Shared.CurrentPage) ' of ' num2str(Shared.NPages)]);
end
if Shared.CurrentPage > 1
    set(Shared.ButtonBack,'Visible','on');
else
    set(Shared.ButtonBack,'Visible','off');
end
if Shared.CurrentPage < Shared.NPages
    set(Shared.ButtonNext,'Visible','on');
    set(Shared.ButtonDone,'Visible','off');
else
    set(Shared.ButtonNext,'Visible','off');
    set(Shared.ButtonDone,'Visible','on')
end
guidata(WindowHandle,Shared);
end

function [] = MakeInvisible(WindowHandle)
Shared = guidata(WindowHandle);
for iQuestion=Shared.PageQuestions(Shared.CurrentPage,1):Shared.PageQuestions(Shared.CurrentPage,2)
    set(Shared.QuestionHandles(iQuestion),'Visible','off');
    for iRadio=1:Shared.NScalePoints
        set(Shared.RadioHandles(iQuestion).radio(iRadio),'Visible','off');
    end
end
guidata(WindowHandle,Shared);
end

function SomePage = FirstIncompletePageNumber(WindowHandle)
Shared = guidata(WindowHandle);   % retrieves Shared info
iPage = 1;
SomePage = -1;
while SomePage < 0
    for iQuestion = Shared.PageQuestions(iPage,1):Shared.PageQuestions(iPage,2)
        if sum(Shared.StoredRadioValues(iQuestion,:)) == 0
            SomePage = iPage;
        end
    end
    iPage = iPage + 1;
end
end
