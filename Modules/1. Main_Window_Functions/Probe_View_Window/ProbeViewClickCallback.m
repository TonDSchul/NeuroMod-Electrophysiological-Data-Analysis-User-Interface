function [app] = ProbeViewClickCallback(app, event, Window)

if isprop(app,'NrChannelEditField')
    ProbeViewWindow = 1;
else
    ProbeViewWindow = 0;
end

if isprop(app,'ChangeforWindowDropDown')
    Window = app.ChangeforWindowDropDown.Value;
end

% Get the click coordinates
clickPoint = event.IntersectionPoint; % X, Y, and Z of click
xClick = clickPoint(1);
yClick = clickPoint(2);

%% Check whether user clicked on a channel square on the right
ClickedOnChannelXDirection = 0;
ClickedOnChannelYDirection = 0;
ClickedOnChannelXDirectionRight = 0;
ClickedOnChannelXDirectionLeft = 0;

ClickedLeftSide = 0;
ClickedRightSide = 0;

ClickedLeftSideR1 = 0;
ClickedLeftSideR2 = 0;
ClickedRightSideR1 = 0;
ClickedRightSideR2 = 0;

ChannelClicked = [];

%% Deal with changing view of channel on the right when user clicked on the plot

if ProbeViewWindow 

    Channel = ceil(yClick/str2double(app.ChannelSpacingumEditField.Value));
    rows = str2double(app.ChannelRowsDropDown.Value);
    
    if Channel <= 0
        Channel = 1;
    end
    
    if rows == 1
        if str2double(app.NrChannelEditField.Value)>=32 % for 32 channel: ends up with channel 1
            if Channel+32-1 > str2double(app.NrChannelEditField.Value)
                Channel = str2double(app.NrChannelEditField.Value)-32+1;
            end
        else % less than 32 channels: dont update, start channel is always 1
            Channel = 1;
        end
    else
        if str2double(app.NrChannelEditField.Value)*2>=64
            if Channel+64-1 > str2double(app.NrChannelEditField.Value)*2
                Channel = str2double(app.NrChannelEditField.Value)*2-64+1;
            end
        else
            if Channel + (str2double(app.NrChannelEditField.Value)*2) > str2double(app.NrChannelEditField.Value)*2
                Channel = 1;
            end
        end
    end

    app.FirstZoomChannel = Channel;
    
    if isempty(app.ActiveChannelField.Value{1})
        ActiveChannel = 1:str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value);
    else
        ActiveChannel = str2double(strsplit(app.ActiveChannelField.Value{1},','));
    end

    if isfield(app.ProbeTrajectoryInfo,'AreaNamesLong')
        BrainAreaInfo = app.ProbeTrajectoryInfo;
    else
        BrainAreaInfo = [];
    end

    Utility_Plot_Interactive_Probe_View(app.UIAxes,str2double(app.ChannelSpacingumEditField.Value),str2double(app.NrChannelEditField.Value),str2double(app.ChannelRowsDropDown.Value),str2double(app.HorizontalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField.Value),app.ChannelOrderField.Value,ActiveChannel,app.FirstZoomChannel,0,BrainAreaInfo,ActiveChannel,app.ShowChannelSpacingCheckBox.Value,1,0,[],app.CheckBox.Value,[],app.ReverseTopandBottomChannelNumberCheckBox.Value,app.SwitchLeftandRightChannelNumberCheckBox.Value)

%% No probe layout window
elseif ~ProbeViewWindow % no change when user clicked on a channel square in the right

    %% Only want to update if user is NOT clicking on the right side!
    
    %% Check if x pos. of squares was clicked
    x1 = 4;   % lower x-limit of squares
    x2 = 6;   % upper x-limit of squares
   
    if xClick <= x2 && xClick >= x1
        return;
    end
  
    Channel = ceil(yClick/app.Mainapp.Data.Info.ChannelSpacing);
    rows = str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows);
    
    if Channel <= 0
        Channel = 1;
    end
    
    if rows == 1
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)>=32 % for 32 channel: ends up with channel 1
            if Channel+32-1 > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)
                Channel = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-32+1;
            end
        else % less than 32 channels: dont update, start channel is always 1
            Channel = 1;
        end
    else
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2>=64
            if Channel+64-1 > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2
                Channel = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2-64+1;
            end
        else
            if Channel + (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2) > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2
                Channel = 1;
            end
        end
    end

    app.FirstZoomChannel = Channel;

    if isfield(app.Mainapp.Data.Info.ProbeInfo,'CompleteAreaNames')
        BrainAreaInfo = app.Mainapp.Data.Info.ProbeInfo.CompleteAreaNames;
    else
        BrainAreaInfo = [];
    end

    Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,0,[],app.Mainapp.Data.Info.ProbeInfo.OffSetRows,[],app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel,app.Mainapp.Data.Info.ProbeInfo.SwitchLeftRightChannel)

end

