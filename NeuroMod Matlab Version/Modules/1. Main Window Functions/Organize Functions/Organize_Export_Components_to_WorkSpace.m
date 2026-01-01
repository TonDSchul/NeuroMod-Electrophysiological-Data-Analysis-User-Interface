function Organize_Export_Components_to_WorkSpace(Data,Component,ExecutedInGUI)

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