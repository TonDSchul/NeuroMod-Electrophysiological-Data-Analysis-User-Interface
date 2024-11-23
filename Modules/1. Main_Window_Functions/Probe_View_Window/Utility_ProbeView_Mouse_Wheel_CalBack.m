function app = Utility_ProbeView_Mouse_Wheel_CalBack(app,event,NrChannel)

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

if isfield(app.Mainapp.Data.Info.ProbeInfo,'CompleteAreaNames')
    BrainAreaInfo = app.Mainapp.Data.Info.ProbeInfo.CompleteAreaNames;
else
    BrainAreaInfo = [];
end

Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,0,[],app.Mainapp.Data.Info.ProbeInfo.OffSetRows,[],app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel,app.Mainapp.Data.Info.ProbeInfo.SwitchLeftRightChannel)
