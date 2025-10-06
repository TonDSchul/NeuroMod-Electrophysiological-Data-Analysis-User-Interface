function app = Utility_ProbeView_Mouse_Wheel_CalBack(app,event,NrChannel)

%________________________________________________________________________________________
%% Function to change zoomed channel shown on the right when the user scrolls with the mouse wheel while hovering over the probe view plot

% Inputs: 
% 1. app: probe view window object
% 2. event: event structure from mouse wheel scroll
% 3. NrChannel: double, from Data.Info 

% Outputs:
% 1. app: probe view window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


CurrentZoomChannel = app.FirstZoomChannel;
 % Get the current mouse position
currentPoint = app.UIAxes.CurrentPoint;
x = currentPoint(1,1);
y = currentPoint(1,2);

% Get the axes limits to check if the cursor is within the UIAxes bounds
xLimits = app.UIAxes.XLim;
yLimits = app.UIAxes.YLim;

if NrChannel>=32
    if event.VerticalScrollCount > 0 % Mouse wheel down
        if NrChannel<64
            if (app.FirstZoomChannel-1)>0
                % Check if mouse is within UIAxes limits
                if x >= xLimits(1) && x <= xLimits(2) && y >= yLimits(1) && y <= yLimits(2)
                    app.FirstZoomChannel = CurrentZoomChannel-1;
                end
            end
        else
            if (app.FirstZoomChannel-2)>0 || (app.FirstZoomChannel-1)>0
                if (app.FirstZoomChannel-2)>0
                    % Check if mouse is within UIAxes limits
                    if x >= xLimits(1) && x <= xLimits(2) && y >= yLimits(1) && y <= yLimits(2)
                        app.FirstZoomChannel = CurrentZoomChannel-2;
                    end
                else
                    % Check if mouse is within UIAxes limits
                    if x >= xLimits(1) && x <= xLimits(2) && y >= yLimits(1) && y <= yLimits(2)
                        app.FirstZoomChannel = CurrentZoomChannel-1;
                    end
                end
            end
        end
    else % Mouse wheel up
        if NrChannel<64
            if (app.FirstZoomChannel+1)+32<=NrChannel
                % Check if mouse is within UIAxes limits
                if x >= xLimits(1) && x <= xLimits(2) && y >= yLimits(1) && y <= yLimits(2)
                    app.FirstZoomChannel = CurrentZoomChannel+1;
                end
            end
        else
            if (app.FirstZoomChannel+1)+32<=NrChannel || (app.FirstZoomChannel+1)+31<=NrChannel
                if (app.FirstZoomChannel+1)+32<=NrChannel
                    % Check if mouse is within UIAxes limits
                    if x >= xLimits(1) && x <= xLimits(2) && y >= yLimits(1) && y <= yLimits(2)
                        app.FirstZoomChannel = CurrentZoomChannel+2;
                    end
                else
                    % Check if mouse is within UIAxes limits
                    if x >= xLimits(1) && x <= xLimits(2) && y >= yLimits(1) && y <= yLimits(2)
                        app.FirstZoomChannel = CurrentZoomChannel+1;
                    end
                end
            end
        end
    end
else
   return;
end

if isprop(app,'ProbeLayoutWindowUIFigure')
    if isfield(app.ProbeTrajectoryInfo,'AreaNamesLong')
        BrainAreaInfo = app.ProbeTrajectoryInfo;
    else
        BrainAreaInfo = [];
    end
else
    if isfield(app.Mainapp.Data.Info.ProbeInfo,'CompleteAreaNames')
        BrainAreaInfo = app.Mainapp.Data.Info.ProbeInfo.CompleteAreaNames;
    else
        BrainAreaInfo = [];
    end
end

if isprop(app,'ProbeLayoutWindowUIFigure')

    if ~isempty(app.ActiveChannelField.Value{1})
        ActiveChannel = str2double(strsplit(app.ActiveChannelField.Value{1},','));
    else
        ActiveChannel = 1:str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value);
    end
    
    if app.ReverseTopandBottomChannelNumberCheckBox.Value == 1
        ActiveChannel = (str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value)+1)-ActiveChannel;
    end

    Utility_Plot_Interactive_Probe_View(app.UIAxes,str2double(app.ChannelSpacingumEditField.Value),str2double(app.NrChannelEditField.Value),str2double(app.ChannelRowsDropDown.Value),str2double(app.HorizontalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField.Value),app.ChannelOrderField.Value,ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,ActiveChannel,app.ShowChannelSpacingCheckBox.Value,1,1,[],app.CheckBox.Value,[],app.ReverseTopandBottomChannelNumberCheckBox.Value,app.SwitchLeftandRightChannelNumberCheckBox.Value,app.ECoGArrayCheckBox.Value)
else
    Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,0,[],app.Mainapp.Data.Info.ProbeInfo.OffSetRows,[],app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel,app.Mainapp.Data.Info.ProbeInfo.SwitchLeftRightChannel,app.Mainapp.Data.Info.ProbeInfo.ECoGArray)
end