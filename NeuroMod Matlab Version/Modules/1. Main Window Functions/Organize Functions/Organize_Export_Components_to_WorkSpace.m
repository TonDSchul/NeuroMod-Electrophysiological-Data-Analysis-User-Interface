function Organize_Export_Components_to_WorkSpace(Data,Component,ExecutedInGUI)

%________________________________________________________________________________________

%% This function exports a component of the main window data structure to the matlab workspace

% Input:
% 1. Data: main window data structure
% 2. Component: string specifying the name of the dataset component to
% export; see below for options
% 3. ExecutedInGUI: double, 1 or 0 whether it is executed in GUI (1) or not
% (0)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

exported = 0;

if strcmp(Component,"Raw")
    assignin('base','RawData', Data.Raw);
    exported = 1;
elseif strcmp(Component,"Preprocessed")
    assignin('base','PreprocessedData', Data.Preprocessed);
    exported = 1;
elseif strcmp(Component,"Spikes")
    assignin('base','Spikes', Data.Spikes);
    exported = 1;
elseif strcmp(Component,"Events")
    assignin('base','Events', Data.Events);
    exported = 1;
elseif strcmp(Component,"EventRelatedData")
    assignin('base','EventRelatedData', Data.EventRelatedData);
    exported = 1;
elseif strcmp(Component,"PreprocessedEventRelatedData")
    assignin('base','PreprocessedEventRelatedData', Data.PreprocessedEventRelatedData);
    exported = 1;
elseif strcmp(Component,"Info")
    assignin('base','Info', Data.Info);
    exported = 1;
elseif strcmp(Component,"EventRelatedSpikes")
    assignin('base','EventRelatedSpikes', Data.EventRelatedSpikes);
    exported = 1;
elseif strcmp(Component,"Time")
    assignin('base','Time', Data.Time);
    exported = 1;
elseif strcmp(Component,"TimeDownsampled")
    assignin('base','TimeDownsampled', Data.TimeDownsampled);
    exported = 1;
end

if exported
    if ExecutedInGUI
        msgbox(strcat("Succesfully exported ",Component," data to Matlab workspace."))
    else
        disp(strcat("Succesfully exported ",Component," data to Matlab workspace."))
    end
else
    if ExecutedInGUI
        msgbox(strcat("Could not find ",Component," data."))
    else
        disp(strcat("Could not find ",Component," data."))
    end
end