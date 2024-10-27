function [app] = ProbeViewClickLineCallback(app, event)

% Get the click coordinates
clickPoint = event.IntersectionPoint; % X, Y, and Z of click
xClick = clickPoint(1);
yClick = clickPoint(2);

Channel = round(yClick/str2double(app.ChannelSpacingumEditField.Value));
rows = str2double(app.ChannelRowsDropDown.Value);

if Channel < 0
    Channel = 0;
end

if rows == 1
    if str2double(app.NrChannelEditField.Value)>=32
        if Channel+32 > str2double(app.NrChannelEditField.Value)
            Channel = str2double(app.NrChannelEditField.Value)-32;
        end
    else
        if Channel+32 > str2double(app.NrChannelEditField.Value)
            Channel = 1;
        end
    end
else
    if str2double(app.NrChannelEditField.Value)>=32
        if Channel+64 > str2double(app.NrChannelEditField.Value)*2
            Channel = str2double(app.NrChannelEditField.Value)-64;
        end
    else
        if Channel + (str2double(app.NrChannelEditField.Value)*2) > str2double(app.NrChannelEditField.Value)*2
            Channel = str2double(app.NrChannelEditField.Value) - (str2double(app.NrChannelEditField.Value)*2);
        end
    end

end

app.FirstZoomChannel = Channel-1;

Utility_Plot_Interactive_Probe_View(app.UIAxes,str2double(app.ChannelSpacingumEditField.Value),str2double(app.NrChannelEditField.Value),str2double(app.ChannelRowsDropDown.Value),str2double(app.HorizontalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField.Value),app.ChannelOrderFormat1234LeaveemptyfornocostumorderEditField.Value,app.ChannelOrderFormat1234LeaveemptyfornocostumorderEditField_3.Value,app.FirstZoomChannel,0)
            
% if ~isempty(app.NrChannelEditField.Value) && ~isempty(app.ChannelSpacingumEditField.Value)
%     %% Initiate Callback
%     if isempty(app.UIAxes.ButtonDownFcn)
%         app.UIAxes.ButtonDownFcn = @(src1, event1) ProbeViewClickCallback(app, event1);
%     end    
% 
%     % Add ButtonDownFcn to each line object in UIAxis
%     lines = findobj(app.UIAxes, 'Type', 'line');
% 
%     % Add ButtonDownFcn to each line object in UIAxis
%     ChannelViewRight = findobj(app.UIAxes,'Tag','ChannelViewRight');
% 
%     % Add ButtonDownFcn to each line object in UIAxis
%     ChannelViewLeft = findobj(app.UIAxes,'Tag','ChannelViewLeft');
% 
%     % Add ButtonDownFcn to each line object in UIAxis
%     GrayProbeFilling = findobj(app.UIAxes,'Tag','GrayProbeFilling');
% 
%     %% Set the ButtonDownFcn for UIAxes to register clicks on a plotted line directly
%     % lines plotted
%     for i = 1:numel(lines)
%         % Call Lineclicked function if that happens
%         lines(i).ButtonDownFcn = @(src1, event1) ProbeViewClickLineCallback(app, event1);
%     end
% 
%     % Channel squares on the right
%     for i = 1:numel(ChannelViewRight)
%         % Call Lineclicked function if that happens
%         ChannelViewRight(i).ButtonDownFcn = @(src1, event1) ProbeViewClickLineCallback(app, event1);
%     end
%     % Channel squares on the left
%     for i = 1:numel(ChannelViewLeft)
%         % Call Lineclicked function if that happens
%         ChannelViewLeft(i).ButtonDownFcn = @(src1, event1) ProbeViewClickLineCallback(app, event1);
%     end
%     % Channel squares on the left
%     for i = 1:numel(GrayProbeFilling)
%         % Call Lineclicked function if that happens
%         GrayProbeFilling(i).ButtonDownFcn = @(src1, event1) ProbeViewClickLineCallback(app, event1);
%     end
% 
% end