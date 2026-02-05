function [Data] = Manage_Dataset_MEA_Grid_Locations(Data,MEACoords,HeaderInfo)

%________________________________________________________________________________________

%% function that creates a probe design for NeuroMod based on the Maxwell MEA channel coordinates from SpikeINterface
% Also figures out the active channel! Since some random channel inbetween
% can be inactive, which are not indicated

% Input:
% 1. Data.Info: structure with recording metadata (app.Data.Data.Info)
% 2. MEACoords: nchannel x 2 matric with x and y coordinates of each
% channel, comes from spikeinterface
% 3. HeaderInfo: metadata extracted from the raw recording before its
% 'curated' and becomes app.Data.Data.Info

% Output: 
% 1. Data.Info: structure with recording metadata (app.Data.Data.Info)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


x = MEACoords(:,1);
y = MEACoords(:,2);

xDiff = diff(sort(x(:)));                     
XDist = max(xDiff);

yDiff = diff(sort(y(:)));                     
YDist = max(yDiff);

Data.Info.ChannelSpacing = YDist;

Data.Info.ProbeInfo.NrChannel = num2str(numel(unique(y)));
Data.Info.ProbeInfo.NrRows = num2str(numel(unique(x)));
Data.Info.ProbeInfo.VertOffset = num2str(0);
Data.Info.ProbeInfo.HorOffset = num2str(XDist);

Data.Info.ProbeInfo.ECoGArray = 1;
Data.Info.ProbeInfo.SwitchTopBottomChannel = 0;
Data.Info.ProbeInfo.SwitchLeftRightChannel = 0;
Data.Info.ProbeInfo.FlipLoadedData = 0;

Data.Info.ProbeInfo.OffSetRows = 0;
Data.Info.ProbeInfo.OffSetRowsDistance = "0";

%% get ActiveChannel from Probe -- just for layout, no influence on how channels are displayed!
% Only specific channel 
if ~strcmp(HeaderInfo.TimeAndChannelToExtract.ChannelToExtract,"All")
    ChannelToExtract = eval(HeaderInfo.TimeAndChannelToExtract.ChannelToExtract);
else
    ChannelToExtract = 1:size(MEACoords,1);
end

activechannel{1} = 1:size(MEACoords,1);
DummyStruc.Raw = [];
DummyStruc.Info.ProbeInfo.NrChannel = Data.Info.ProbeInfo.NrChannel;

[xcoords,ycoords,~] = Manage_Dataset_Save_ProbeInfo_Kilosort(DummyStruc,"",Data.Info.ProbeInfo.NrRows,Data.Info.ProbeInfo.NrChannel,num2str(Data.Info.ChannelSpacing),activechannel,Data.Info.ProbeInfo.OffSetRows,str2double(Data.Info.ProbeInfo.OffSetRowsDistance),str2double(Data.Info.ProbeInfo.VertOffset),str2double(Data.Info.ProbeInfo.HorOffset),0,"");
xcoords = xcoords + min(MEACoords(:,1));
ycoords = ycoords + min(MEACoords(:,2));

ActiveChannel = [];
Laufvariable = 1;

TempMEACoords=Data.Info.MEACoords;
TempMEACoords=TempMEACoords(ChannelToExtract,:);

for n = 1:length(xcoords)
    IndiciesX = find(xcoords(Laufvariable) == TempMEACoords(:,1));
    CorrespondingY = TempMEACoords(IndiciesX,2);
    IndiciesY = CorrespondingY == ycoords(Laufvariable);
    ResultingIndex = IndiciesX(IndiciesY);
    
    if ~isempty(ResultingIndex)
        ActiveChannel = [ActiveChannel,Laufvariable];
    end

    Laufvariable = Laufvariable + 1;
end

Data.Info.ProbeInfo.ActiveChannel = ActiveChannel;

%% Infer Channelorder from given channel positions >> just order MEA Coords and take order for channel too!
[~, Data.Info.Channelorder] = sortrows(MEACoords, [2 1]);

Data.Raw = Data.Raw(Data.Info.Channelorder,:);


