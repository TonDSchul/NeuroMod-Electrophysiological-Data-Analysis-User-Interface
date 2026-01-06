function [Info] = Manage_Dataset_MEA_Grid_Locations(Info)

x = Info.MEACoords(:,1);
y = Info.MEACoords(:,2);

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

%% Create True MEA ChannelOrder based on x and y position of each channel index from spikeinterface
% get x and y coordinates
activechannel{1} = 1:size(Info.MEACoords,1);
DummyStruc.Raw = [];
DummyStruc.Info.ProbeInfo.NrChannel = Info.ProbeInfo.NrChannel;

[xcoords,ycoords,~] = Manage_Dataset_Save_ProbeInfo_Kilosort(DummyStruc,"",Info.ProbeInfo.NrRows,Info.ProbeInfo.NrChannel,num2str(Info.ChannelSpacing),activechannel,Info.ProbeInfo.OffSetRows,str2double(Info.ProbeInfo.OffSetRowsDistance),str2double(Info.ProbeInfo.VertOffset),str2double(Info.ProbeInfo.HorOffset),0);

xcoords = xcoords + min(Info.MEACoords(:,1));
ycoords = ycoords + min(Info.MEACoords(:,2));
Laufvariable = 1;
FakechannelMatrix = [];

for m = 1:numel(unique(x))
    for n = 1:numel(unique(y))
        FakechannelMatrix(n,m) = Laufvariable;
        Laufvariable = Laufvariable+1;
    end
end


% for n = 1:numel(unique(y))
%     for m = 1:numel(unique(x))
%         FakechannelMatrix(n,m) = Laufvariable;
%         Laufvariable = Laufvariable+1;
%     end
% end

NewChannelOrder = [];
for iii = 1:size(Info.MEACoords,1)    
    [~, iy] = min(abs(unique(xcoords) - Info.MEACoords(iii,1)));
    [~, ix] = min(abs(unique(ycoords) - Info.MEACoords(iii,2)));
    
    NewChannelOrder = [NewChannelOrder,FakechannelMatrix(ix,iy)];
end

Info.ProbeInfo.ActiveChannel = sort(NewChannelOrder);

Info.ProbeInfo.MEAChannelOrder = NewChannelOrder;

%Info = rmfield(Info, 'MEACoords');




