function [event,Texttoshow] = Extract_Events_Module_Load_Neuralynx_Events(Data,NeuralynxRecordingPath)

Texttoshow = [];
% check if .nce files found in recording folder
FilesIndex = {};
[stringarray] = Utility_Extract_Contents_of_Folder(NeuralynxRecordingPath);
FilesIndex = endsWith(stringarray, ".nev");
FileEndingsExist = sum(FilesIndex);

Filename = strcat(NeuralynxRecordingPath,'\',stringarray{FilesIndex==1});

if ~isfile(Filename)
    msgbox("No Neuralynx event file could be found!");
    Texttoshow = ("No Neuralynx event file could be found!");
    event = [];
    return;
end

[event] = Extract_Events_Module_Extract_Events_Neuralynx(Filename,NeuralynxRecordingPath);

if isempty(event)
    msgbox("No Neuralynx events could be extracted from file!");
    Texttoshow = ("No Neuralynx events could be extracted from file!");
    event = [];
    return;
end

% Delete First channel with start and stop time stamps
EventChannel = double(cell2mat({event.value}));
UniqueEventChannel = unique(EventChannel);

if isscalar(UniqueEventChannel)
    msgbox("Error: Just one event channel found which holds start and stop time stamps!");
    Texttoshow = ("Error: Just one event channel found which holds start and stop time stamps!");
    event = [];
    return;
end

% delete first and last indice
IndiciesToDelete = double(cell2mat({event.sample}))==1;
IndiciesToDelete = IndiciesToDelete + (double(cell2mat({event.sample}))==length(Data.Time));
%IndiciesToDelete = EventChannel==UniqueEventChannel(1);
EventChannel(IndiciesToDelete==1) = [];

event(IndiciesToDelete == 1) = [];
IndiciesToDelete = [];

%% Check if sample bigger than time
if ~isfield(Data.Info,'CutEnd') && ~isfield(Data.Info,'CutStart')
    EventSamples = double(cell2mat({event.sample}));
    
    if sum(EventSamples>length(Data.Time))>0
        IndiciesToDelete = EventSamples>length(Data.Time);
        if sum(IndiciesToDelete) == length(EventSamples)
            msgbox("Error: All trigger times outside of time window! Make sure recording time was not cut and that sample rate of raw signal is not downsampled!");
            Texttoshow("Error: All trigger times outside of time window! Make sure recording time was not cut and that sample rate of raw signal is not downsampled!");
            event = [];
            return;
        else
            warning(strcat(num2str(sum(IndiciesToDelete))," trigger indices that violate time limits where deleted."))
            msgbox(strcat(num2str(sum(IndiciesToDelete))," trigger indices that violate time limits where deleted."))
        end
        event(IndiciesToDelete == 1) = [];
    end
end