function [Data,Textbox] = Manage_Dataset_Module_Load_NeoMatData(FullDataPath,FullPathInfo)

Textbox = [];
Data = [];

%% ------------------------------ Load Neo converted .mat Data ------------------------------
    
h = waitbar(0, 'Loading Neo .mat files...', 'Name','Loading Neo .mat files...');
msg = sprintf('Loading Neo .mat files... (%d%% done)', 25);
waitbar(25, h, msg);

try
    load(FullDataPath)
catch
    warning("NEOMatlabConversion.mat file could not be openend. Make sure it is part of the folder you selected!")
    Textbox = "NEOMatlabConversion.mat file could not be openend. Make sure it is part of the folder you selected!";
    Data = [];
    close(h);
    return;
end

msg = sprintf('Loading Neo .mat files... (%d%% done)', 50);
waitbar(50, h, msg);

%% ------------------------------ Load Info file ------------------------------
try
    load(FullPathInfo)
catch
    warning("'filename'_Info.mat file could not be openend. Make sure it is part of the folder you selected!")
    Textbox = "'filename'_Info.mat file could not be openend. Make sure it is part of the folder you selected!";
    Data = [];
    close(h);
    return;
end

msg = sprintf('Loading Neo .mat files... (%d%% done)', 75);
waitbar(75, h, msg);

%% ------------------------------ Load Event Data if present ------------------------------
SampleRate = block.segments{1}.analogsignals{1}.sampling_rate;

if isfield(block.segments{1},'events')
    event_channels = [];
    event_labels = [];
    event_samples = [];
    event_labels{1} = [];
    
    Laufvariable = 1;
    for i = 1:length(block.segments{1}.events)
        
        if isempty(block.segments{1}.events{i}.times)
            continue
        end
        
        Data.Info.EventChannelNames{Laufvariable} = block.segments{1}.events{i}.labels(1,:);
        Data.Events{Laufvariable} = block.segments{1}.events{i}.times;
    
        if strcmp(block.segments{1}.events{i}.times_units,'ms')
            Data.Events{Laufvariable} = round((Data.Events{Laufvariable}/1000)*SampleRate);
        elseif strcmp(block.segments{1}.events{i}.times_units,'s')
            Data.Events{Laufvariable} = round((Data.Events{Laufvariable})*SampleRate);
        else
            Data.Events{Laufvariable} = round((Data.Events{Laufvariable})*SampleRate);
        end
    
        Laufvariable = Laufvariable+1;
    end
end
%% ------------------------------ Wrap up ------------------------------

Data.Raw = block.segments{1}.analogsignals{1}.signal;

if size(Data.Raw,1)>size(Data.Raw,2)
    Data.Raw = Data.Raw';
end

if exist('Info','var')
    Data.Info = Info;
else
    warning("Mat file with recording infos ('filename'_Info.mat') does not contain the expected Info strcuture (called Info)!")
    Textbox = "Mat file with recording infos ('filename'_Info.mat') does not contain the expected Info strcuture (called Info)!";
    Data = [];
    close(h);
    return;
end

Data.Time = 0:1/SampleRate:(double(Data.Info.num_data_points)-1)*(1/SampleRate);

msg = sprintf('Loading Neo .mat files... (%d%% done)', 100);
waitbar(100, h, msg);

close(h);
