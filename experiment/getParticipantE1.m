function [sIDDir, participant] = getParticipantE1(sID, group)
% change dir to the dir where this .m file is
[folder] = fileparts(which(mfilename));
cd(folder);
% get Data directory name
dataDir = [folder filesep 'Data' filesep];
% if Data dir doesn't exist, creat it
if ~exist(dataDir, 'dir')
    mkdir(dataDir);
    fprintf('Created ''Data'' folder %s \n', dataDir);
end

% Get date and time
time = clock;
if time(1,4) < 10
    hr = ['0' num2str(time(1,4))];
else
    hr = num2str(time(1,4));
end
if time(1,5) < 10
    min = ['0' num2str(time(1,5))];
else
    min = num2str(time(1,5));
end
datetime = [datestr(now,'yyyymmdd') '_' hr min];

% create the participant folder
sIDDir = [dataDir group sID filesep];
sIDDir = sprintf('%s',sIDDir{1:length(sIDDir)});
if ~exist(sIDDir, 'dir')
    mkdir(sIDDir);
end

% opens on screen keyboard
if regexp(computer,'PCW\w*')
    system('%windir%\system32\osk.exe &'); % on Win
else
    system('open -n  /System/Library/Input\ Methods/KeyboardViewer.app'); % on Mac
end
%

% opens dialog
participant = sIDdetails;
participant.sID = sID;
participant.datetime = datetime;
% save
filename = [sIDDir 'demographics.mat'];
save(filename, 'participant');

