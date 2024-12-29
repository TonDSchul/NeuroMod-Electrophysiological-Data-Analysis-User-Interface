function Utility_Plot_Interactive_Probe_View(Figure,ChannelSpacing,NrChannel,ChannelRows,HorOffset,VerOffset,ChannelOrder,ActiveChannel,FirstZoomChannel,LeftProbeChanged,ProbeBrainAreas,AllActiveChannel,PlotChannelSpacing,CreateProbeWindow,ChannelActivation,ChannelClicked,OffSetRows,RowClicked,SwitchTopBottom,SwitchLeftRight)

%________________________________________________________________________________________
%% Main Function to plot interactive probe view. Handles all sub functions to plot individual parts

%% Executed every time something about a probe view is plotted. Most necessray parameter come from Data.Info structure or the create probe view window as
%% well as the clickcallbacks executed when the user clicks something (like what exactly was clicked on, which channel are shwon at the moment etc.)
%% Most Inputs are logical 1 or 0 or double 1 or 0 specifying what happended and should be plotted. T

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. ChannelSpacing: double, from Data.Info structure in um
% 3. NrChannel: double, from Data.Info structure or create probe view window
% 4. ChannelRows: double, 1 or 2 from Data.Info structure or create probe view window
% 5. HorOffset: Horizontal offset in um between channel rows (0 if 1 channel row)
% 6. VerOffset: Vertical offset in um between channel rows (0 if 1 channel
% row) --> affects right row only. Positive and negative possible
% 7. ChannelOrder: double, vector with channel order. 1:NrChannel when no
% costume channel order from Data.Info structure
% 8. ActiveChannel: double vector with all channel selected/activated by the
% user in the probe view window
% 9. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 10. LeftProbeChanged: double, 1 or 0 - if the left probe plot has to be
% updated -- saves time if not
% 11. ProbeBrainAreas: structure from trajectory explorer, empty if non
% 12. AllActiveChannel: double, vector with active channel  from Data.Info
% structure
% 13. PlotChannelSpacing: logical 1 or 0, if channel spacing should be
% shown in plot (rectangles for channel do not touch each other, gives more
% accurate scale and appearance) - selected in checkbox of probe view
% window
% 14. CreateProbeWindow: double, 1 or 0, if plot is for create probe window
% or probe view window
% 15. ChannelActivation: double, 1 or 0, if user activated/deactivated a
% channel (comes from ClickCallbacks), but also 1 if initialy created!!
% 16. ChannelClicked: double, channel the user clicked on if he did so,
% empty if not
% 17. OffSetRows: logical, 1 or 0, if left and right row have an offset (only if two channelrows)
% 18. RowClicked: 0 if clicked on a row on the left
% 19. SwitchTopBottom:  logical 1 or 0 if channel names are reversed from
% top to bottom
% 20. SwitchLeftRight logical 1 or 0 if channel names are switched between
% left and right channel row

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


% SwitchTopBottom = logical 1 or 0 
% SwitchLeftRight = logical 1 or 0 only when 2 channelrows

%% Set Plot properties

if isnan(VerOffset)
    VerOffset = 0;
end

%% Get and manage existing handles
if ~isnan(NrChannel) && ~isnan(ChannelSpacing)
   
    if CreateProbeWindow

        ProbeLines = findobj(Figure,'Tag','ProbeLines');
        if length(ProbeLines)>4
            delete(ProbeLines(5:end));
            ProbeLines = findobj(Figure,'Tag','ProbeLines');
        end
        GrayProbeFilling = findobj(Figure,'Tag','GrayProbeFilling');
        if length(GrayProbeFilling)>2
            delete(GrayProbeFilling(2:end));
            GrayProbeFilling = findobj(Figure,'Tag','GrayProbeFilling');
        end
    else
        GrayProbeFilling = [];
        ProbeLines = [];
    end

    if CreateProbeWindow || ~ChannelActivation
        BracketLine = findobj(Figure, 'Tag', 'BracketLine');
        if length(BracketLine)>6
            delete(BracketLine(7:end));
            BracketLine = findobj(Figure,'Tag','BracketLine');
        end
    else
        BracketLine = [];
    end

    ChannelViewRight = findobj(Figure,'Tag','ChannelViewRight');

    if NrChannel >= 32
        if length(ChannelViewRight)>32*ChannelRows
            delete(ChannelViewRight(32*ChannelRows+1:end));
            ChannelViewRight = findobj(Figure,'Tag','ChannelViewRight');
        end
    else
        if length(ChannelViewRight)>NrChannel*ChannelRows
            delete(ChannelViewRight(NrChannel*ChannelRows+1:end));
            ChannelViewRight = findobj(Figure,'Tag','ChannelViewRight');
        end
    end

    if CreateProbeWindow || ChannelActivation
        ChannelViewLeft = findobj(Figure,'Tag','ChannelViewLeft');
        if length(ChannelViewLeft)>NrChannel*ChannelRows
            delete(ChannelViewLeft(NrChannel*ChannelRows+1:end));
            ChannelViewLeft = findobj(Figure,'Tag','ChannelViewLeft');
        end
    else
        ChannelViewLeft = [];
    end

    if ~ChannelActivation || CreateProbeWindow
        ChannelText = findobj(Figure,'Tag','ChannelText');
        if NrChannel >= 32
            if length(ChannelText)>32*ChannelRows
                delete(ChannelText(32*ChannelRows+1:end));
                ChannelText = findobj(Figure,'Tag','ChannelText');
            end
        else
            if length(ChannelText)>NrChannel*ChannelRows
                delete(ChannelText(NrChannel*ChannelRows+1:end));
                ChannelText = findobj(Figure,'Tag','ChannelText');
            end
        end
    else
        ChannelText = [];
    end 
    
    %% Adjust First Channel selected if it would exceed limits
    if ChannelRows == 2
        if FirstZoomChannel + 32 > NrChannel
            if NrChannel>=32
                FirstZoomChannel = NrChannel-31;
            else
                FirstZoomChannel = 1;
            end
        end
    end
    
    %% Plot Probe Scheme on the left

    [yPoint,yLimits,ActiveChannel,yLimitsSquares,squareHeight] = Utility_Plot_Probe_Scheme(Figure,GrayProbeFilling,ProbeLines,ChannelViewLeft,NrChannel,ChannelSpacing,ActiveChannel,VerOffset,ChannelRows,LeftProbeChanged,AllActiveChannel,CreateProbeWindow,ChannelActivation,ChannelClicked,OffSetRows,RowClicked,FirstZoomChannel);
    
    %% Plot Brackets

    [yLimitBracktes] = Utitlity_Plot_Brackets_Probe_View(Figure,BracketLine,NrChannel,ChannelSpacing,yPoint,yLimits,yLimitsSquares,squareHeight,FirstZoomChannel,ChannelRows,CreateProbeWindow,ChannelActivation);
    
    %% Plot Zoomed Channel on the right side

    [numSquares,squareHeight,lowylimits,CorrrectedVerOffset] = Utitlity_Plot_Zoomed_Channel_Right_Side(Figure,ChannelViewRight,NrChannel,ChannelSpacing,PlotChannelSpacing,ChannelRows,VerOffset,FirstZoomChannel,ActiveChannel,ChannelRows,yLimitBracktes,AllActiveChannel,OffSetRows,SwitchTopBottom);

    %% Plot Channel Names on the right side

    Utitlity_Plot_Zoomed_Text_Channel_Right_Side(Figure,ChannelText,NrChannel,ChannelRows,FirstZoomChannel,numSquares,squareHeight,lowylimits,CorrrectedVerOffset,CreateProbeWindow,ChannelActivation,PlotChannelSpacing,VerOffset,ChannelSpacing,SwitchTopBottom)
    
    if yLimits(2)>=yLimitBracktes(2)
        ylim(Figure,[yPoint yLimits(2)])
    else
        ylim(Figure,[yPoint yLimitBracktes(2)])
    end

    %% Plot Brain Areas

    % Position based on distance to tip
    if ~isempty(ProbeBrainAreas)
        Utility_Plot_BrainAreas(Figure,ProbeBrainAreas);
    end
    
    
    Probe_View_Set_Y_Ticks(Figure,yLimits(2)-ChannelSpacing,yLimits(1),CreateProbeWindow,ChannelClicked)
end