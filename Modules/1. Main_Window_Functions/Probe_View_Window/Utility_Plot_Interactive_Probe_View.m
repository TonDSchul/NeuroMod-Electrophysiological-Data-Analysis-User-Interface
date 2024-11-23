function Utility_Plot_Interactive_Probe_View(Figure,ChannelSpacing,NrChannel,ChannelRows,HorOffset,VerOffset,ChannelOrder,ActiveChannel,FirstZoomChannel,LeftProbeChanged,ProbeBrainAreas,AllActiveChannel,PlotChannelSpacing,CreateProbeWindow,ChannelActivation,ChannelClicked,OffSetRows,RowClicked,SwitchTopBottom,SwitchLeftRight)

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

    [numSquares,squareHeight,lowylimits,CorrrectedVerOffset] = Utitlity_Plot_Zoomed_Channel_Right_Side(Figure,ChannelViewRight,NrChannel,ChannelSpacing,PlotChannelSpacing,ChannelRows,VerOffset,FirstZoomChannel,ActiveChannel,ChannelRows,yLimitBracktes,AllActiveChannel,OffSetRows);

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
end