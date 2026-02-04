function Data = Execute_Autorun_Initialize_Data(AutorunConfig,TempData,Time,HeaderInfo,SampleRate,RecordingType,SelectedFolder)

if isempty(TempData)
    Data = [];
    return;
end
 %% Define all important Variables based on extracted dat files
if ~isa(TempData, 'single')
    Data.Raw = single(TempData);
else
    Data.Raw = TempData;
end

clear TempData;

Data.Time = Time;

if strcmp(RecordingType,"IntanDat") || strcmp(RecordingType,"IntanRHD") || strcmp(RecordingType,"Spike2") || strcmp(RecordingType,"Open Ephys") || strcmp(RecordingType,"NEO") || strcmp(RecordingType,"TDT Tank Data") || strcmp(RecordingType,"SpikeInterface Maxwell MEA .h5")
    Data.Info = HeaderInfo;
else
    fieldsToDelete = {'Header'};
    % Delete fields
    Data.Info = rmfield(HeaderInfo.orig(1).hdr, fieldsToDelete);
end

if ~isfield(Data.Info,'Channelorder')
    Data.Info.Channelorder = [];
end

if isfield(HeaderInfo,'startTimestamp')
    Data.Info.startTimestamp = HeaderInfo.startTimestamp;
else
    Data.Info.startTimestamp = 0;
end

Data.Info.num_data_points = size(Data.Raw,2);
Data.Info.NrChannel = size(Data.Raw,1);
Data.Info.Data_Path = SelectedFolder;
Data.Info.NativeSamplingRate = SampleRate;
Data.Info.RecordingType = RecordingType;

if ~strcmp(RecordingType,"SpikeInterface Maxwell MEA .h5")
    if ischar(AutorunConfig.ProbeInfo.ChannelSpacing) || isstring(AutorunConfig.ProbeInfo.ChannelSpacing)
        Data.Info.ChannelSpacing = str2double(AutorunConfig.ProbeInfo.ChannelSpacing);
    else
        Data.Info.ChannelSpacing = AutorunConfig.ProbeInfo.ChannelSpacing;
    end
    
    Data.Info.ProbeInfo.NrChannel = num2str(AutorunConfig.ProbeInfo.NrChannel);
    Data.Info.ProbeInfo.NrRows = num2str(AutorunConfig.ProbeInfo.NumberChannelRows);
    Data.Info.ProbeInfo.VertOffset = num2str(AutorunConfig.ProbeInfo.VerticalOffsetum);
    Data.Info.ProbeInfo.HorOffset = num2str(AutorunConfig.ProbeInfo.HorizontalOffsetum);
    Data.Info.ProbeInfo.ActiveChannel = sort(AutorunConfig.ProbeInfo.ActiveChannel);
    
    Data.Info.ProbeInfo.SwitchTopBottomChannel = AutorunConfig.ProbeInfo.SwitchTopBottomChannel;
    Data.Info.ProbeInfo.SwitchLeftRightChannel = AutorunConfig.ProbeInfo.SwitchLeftRightChannel;
    Data.Info.ProbeInfo.FlipLoadedData = AutorunConfig.ProbeInfo.FlipLoadedData;
    
    Data.Info.ProbeInfo.OffSetRows = double(AutorunConfig.ProbeInfo.OffSetRows);
    Data.Info.ProbeInfo.OffSetRowsDistance = AutorunConfig.ProbeInfo.OffSetRowsDistance;
    
    if isfield(AutorunConfig.ProbeInfo,'ProbeTrajectoryInfo')
        Data.Info.ProbeInfo.CompleteAreaNames = AutorunConfig.ProbeInfo.ProbeTrajectoryInfo.AreaNamesLong;
        Data.Info.ProbeInfo.ShortAreaNames = AutorunConfig.ProbeInfo.ProbeTrajectoryInfo.AreaNamesShort;
        Data.Info.ProbeInfo.AreaDistanceFromTip = AutorunConfig.ProbeInfo.ProbeTrajectoryInfo.AreaTipDistance;
    end
else
    Data.Info.num_data_points = size(Data.Raw,2);
    Data.Info.NrChannel = size(Data.Raw,1);
end

% Get True MEA Grid Locations for position related analyis
if strcmp(RecordingType,"SpikeInterface Maxwell MEA .h5")
    [Data] = Manage_Dataset_MEA_Grid_Locations(Data,Data.Info.MEACoords,HeaderInfo);
    if app.ExtractDataWindow.Save_Probe_Kilosort.Value == 1
        activechannel{1} = Data.Info.ProbeInfo.ActiveChannel;
        DummyStruc.Raw = [];
        DummyStruc.Info.ProbeInfo.NrChannel = Data.Info.ProbeInfo.NrChannel;
        msgbox("Please select a location to save the probe design in.")
        [~,~,~] = Manage_Dataset_Save_ProbeInfo_Kilosort(DummyStruc,app.executableFolder,Data.Info.ProbeInfo.NrRows,Data.Info.ProbeInfo.NrChannel,num2str(Data.Info.ChannelSpacing),activechannel,Data.Info.ProbeInfo.OffSetRows,str2double(Data.Info.ProbeInfo.OffSetRowsDistance),str2double(Data.Info.ProbeInfo.VertOffset),str2double(Data.Info.ProbeInfo.HorOffset),1);
        disp("Succesfully saved probe design in ")
        app.ExtractDataWindow.Save_Probe_SpikeInterface.Value;
    end
end

% get x and y coordinates
activechannel{1} = Data.Info.ProbeInfo.ActiveChannel;
DummyStruc.Raw = [];
DummyStruc.Info.ProbeInfo.NrChannel = Data.Info.ProbeInfo.NrChannel;

[Data.Info.ProbeInfo.xcoords,Data.Info.ProbeInfo.ycoords,~] = Manage_Dataset_Save_ProbeInfo_Kilosort(DummyStruc,"",Data.Info.ProbeInfo.NrRows,Data.Info.ProbeInfo.NrChannel,num2str(Data.Info.ChannelSpacing),activechannel,Data.Info.ProbeInfo.OffSetRows,str2double(Data.Info.ProbeInfo.OffSetRowsDistance),str2double(Data.Info.ProbeInfo.VertOffset),str2double(Data.Info.ProbeInfo.HorOffset),0);

if str2double(Data.Info.ProbeInfo.VertOffset) ~= 0
    Data.Info.ProbeInfo.FakeSpacing = unique(diff(Data.Info.ProbeInfo.ycoords));
    if length(Data.Info.ProbeInfo.FakeSpacing)>1 && str2double(Data.Info.ProbeInfo.VertOffset) > 0 % just take first distance, other distances are 'skipped'
        Data.Info.ProbeInfo.FakeSpacing = abs(Data.Info.ProbeInfo.FakeSpacing(1));
    end
else
    Data.Info.ProbeInfo.FakeSpacing = Data.Info.ChannelSpacing;
end


% Set up y labels with proper y and x coordinate
Data.Info.ProbeInfo.YLabels = arrayfun(@(yy, xx) sprintf('%.0f (%.0f µm)', yy, xx), Data.Info.ProbeInfo.ycoords, Data.Info.ProbeInfo.xcoords, 'UniformOutput', false);
    
Data.Info.SpikeType = "Non";

