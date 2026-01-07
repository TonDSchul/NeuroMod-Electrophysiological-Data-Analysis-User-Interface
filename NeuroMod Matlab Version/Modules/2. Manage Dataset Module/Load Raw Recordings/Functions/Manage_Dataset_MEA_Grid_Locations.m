function [Info] = Manage_Dataset_MEA_Grid_Locations(Info,MEACoords,HeaderInfo)

x = MEACoords(:,1);
y = MEACoords(:,2);

xDiff = diff(sort(x(:)));                     
XDist = max(xDiff);

yDiff = diff(sort(y(:)));                     
YDist = max(yDiff);

Info.ChannelSpacing = YDist;

Info.ProbeInfo.NrChannel = num2str(numel(unique(y)));
Info.ProbeInfo.NrRows = num2str(numel(unique(x)));
Info.ProbeInfo.VertOffset = num2str(0);
Info.ProbeInfo.HorOffset = num2str(XDist);

Info.ProbeInfo.ECoGArray = 1;
Info.ProbeInfo.SwitchTopBottomChannel = 0;
Info.ProbeInfo.SwitchLeftRightChannel = 0;
Info.ProbeInfo.FlipLoadedData = 0;

Info.ProbeInfo.OffSetRows = 0;
Info.ProbeInfo.OffSetRowsDistance = "0";

%% get ActiveChannel from Probe -- just for layout, no influence on how channels are displayed!
% Only specific channel 
if ~strcmp(HeaderInfo.TimeAndChannelToExtract.ChannelToExtract,"All")
    ChannelToExtract = eval(HeaderInfo.TimeAndChannelToExtract.ChannelToExtract);
else
    ChannelToExtract = 1:size(MEACoords,1);
end

activechannel{1} = 1:size(MEACoords,1);
DummyStruc.Raw = [];
DummyStruc.Info.ProbeInfo.NrChannel = Info.ProbeInfo.NrChannel;

[xcoords,ycoords,~] = Manage_Dataset_Save_ProbeInfo_Kilosort(DummyStruc,"",Info.ProbeInfo.NrRows,Info.ProbeInfo.NrChannel,num2str(Info.ChannelSpacing),activechannel,Info.ProbeInfo.OffSetRows,str2double(Info.ProbeInfo.OffSetRowsDistance),str2double(Info.ProbeInfo.VertOffset),str2double(Info.ProbeInfo.HorOffset),0);
xcoords = xcoords + min(MEACoords(:,1));
ycoords = ycoords + min(MEACoords(:,2));

ActiveChannel = [];
Laufvariable = 1;

TempMEACoords=Info.MEACoords;
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

Info.ProbeInfo.ActiveChannel = ActiveChannel;



