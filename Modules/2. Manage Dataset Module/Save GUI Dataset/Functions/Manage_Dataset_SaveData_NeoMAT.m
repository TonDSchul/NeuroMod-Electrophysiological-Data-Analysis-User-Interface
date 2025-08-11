function Manage_Dataset_SaveData_NeoMAT(Data,SampleRate,DataToSave,SaveEvents,SaveSpikes,Time)

block = struct();
block.segments = { };
block.name = 'my block with matlab';

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
    
    %% Save Events 
    if SaveEvents == 1
        event = struct();
        event.times = [0, 10, 30];
        event.times_units = 'ms';
        event.labels = ['trig0'; 'trig1'; 'trig2'];
        seg.events{1} = event;
        epoch = struct();
        epoch.times = [10, 20];
        epoch.times_units = 'ms';
        epoch.durations = [4, 10];
        epoch.durations_units = 'ms';
        epoch.labels = ['a0'; 'a1'];
        seg.epochs{1} = epoch;
    end

    block.segments{segmentnr} = seg;
    
end

save 'myblock.mat' block -V7