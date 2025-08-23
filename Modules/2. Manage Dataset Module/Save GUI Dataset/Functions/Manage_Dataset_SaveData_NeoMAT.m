function [PathToSave,Error] = Manage_Dataset_SaveData_NeoMAT(Data,SampleRate,DataToSave,SaveEvents,SaveSpikes,Time,Autorun,FolderToSave)

Error = 0;
PathToSave = [];

%% Determine Folder structure for GUI and Autorun
if Autorun == "No" || Autorun == "SingleFolder"
    [file, path] = uiputfile('*.mat', 'Save as');
    
    if ~ischar(file) || ~ischar(path)
        disp("No folder selected.")
        return;
    else
        PathToSave = fullfile(path,file);
    end
else
    if isstring(FolderToSave)
        FolderToSave = convertStringsToChars(FolderToSave);
    end
    dashindex = find(FolderToSave=='\');
    filepath = convertStringsToChars(strcat(FolderToSave,'\'));
    filename = convertStringsToChars(strcat("NEO_",FolderToSave(dashindex(end-2)+1:dashindex(end-1)-1),".mat"));
    
    PathToSave = fullfile(filepath,filename);
end

h = waitbar(0, 'Saving Data as .mat for NEO...', 'Name','Saving Data as .mat for NEO...');

block = struct();
block.segments = { };
block.name = 'my block with matlab';

msg = sprintf('Saving Data as .mat for NEO... (%d%% done)', round(0));     
waitbar(0, h, msg);

for segmentnr = 1:1
    %% Save Metadata and channel data 
    seg = struct();
    seg.name = strcat('segment ',num2str(segmentnr));
    seg.analogsignals = { };
    for a = 1:1
        anasig = struct();
        if strcmp(DataToSave,"Raw Data")
            anasig.signal = Data.Raw';
        elseif strcmp(DataToSave,"Preprocessed Data")
            anasig.signal = Data.Preprocessed';
        end
        anasig.signal_units = 'mV';
        if isfield(Data.Info,'Acquisition_start_samples')
            anasig.t_start = Data.Info.Acquisition_start_samples;
        else
            anasig.t_start = 0;
        end
        anasig.t_start_units = 's';
        anasig.sampling_rate = SampleRate;
        anasig.sampling_rate_units = 'Hz';
        seg.analogsignals{a} = anasig;
    end

    msg = sprintf('Saving Data as .mat for NEO... (%d%% done)', round(25));     
    waitbar(25, h, msg);

    %% Save spikes 
    if SaveSpikes == 1
        if ~isempty(Data.Spikes.SpikeCluster)
            disp("Saving Spike Data")
            seg.spiketrains = { };
            if min(Data.Spikes.SpikeCluster)==0
                Data.Spikes.SpikeCluster = Data.Spikes.SpikeCluster +1;
            end

            for nCluster = 1:length(Data.Spikes.SpikeCluster)
                CurrentClusterTimes = Data.Spikes.SpikeTimes(Data.Spikes.SpikeCluster==nCluster);
                sptr = struct();
                sptr.times = (CurrentClusterTimes / SampleRate) * 1000; % from samples in ms
                sptr.times_units = 'ms';
                sptr.t_start = 0;
                sptr.t_start_units = 'ms';
                sptr.t_stop = Time(end) * 1000;
                sptr.t_stop_units = 'ms';
                seg.spiketrains{nCluster} = sptr;
            end
        else
            disp("No sorted data found. No spiketrains can be created for NEO.")
        end
    end
    
    msg = sprintf('Saving Data as .mat for NEO... (%d%% done)', round(50));     
    waitbar(50, h, msg);
    %% Save Events 
    if SaveEvents == 1
        seg.events = {};  % Make sure events is initialized as a cell array

        % Example structure: EventData.ChNames = {'TriggerA','TriggerB',...}
        %                    EventData.Samples = { [10,100,500], [200,700], ... }
        for evCh = 1:length(Data.Events)
            event = struct();
            
            % Convert from samples to ms
            event.times = (Data.Events{evCh} / SampleRate) * 1000; 
            event.times_units = 'ms';
    
            % Use channel name as label (one label per time)
            % Make sure labels is an Nx1 cell array of strings
            labels = repmat(Data.Info.EventChannelNames{evCh}, numel(event.times), 1);
            event.labels = labels;
    
            seg.events{evCh} = event;
        end


        epoch = struct();
        epoch.times = [10, 20];
        epoch.times_units = 'ms';
        epoch.durations = [4, 10];
        epoch.durations_units = 'ms';
        epoch.labels = ['a0'; 'a1'];
        seg.epochs{1} = epoch;
    end
    
    msg = sprintf('Saving Data as .mat for NEO... (%d%% done)', round(75));     
    waitbar(75, h, msg);

    block.segments{segmentnr} = seg;
    
end

save(PathToSave,'block',"-v7.3")

msg = sprintf('Saving Data as .mat for NEO... (%d%% done)', round(100));     
waitbar(100, h, msg);

close(h)
