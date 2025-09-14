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

if strcmp(RecordingType,"IntanDat") || strcmp(RecordingType,"IntanRHD") || strcmp(RecordingType,"Spike2") || strcmp(RecordingType,"Open Ephys") || strcmp(RecordingType,"NEO") || strcmp(RecordingType,"TDT Tank Data")
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