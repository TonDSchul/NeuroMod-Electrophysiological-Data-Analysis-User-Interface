function Utility_Plot_Interactive_Probe_View(Figure,ChannelSpacing,NrChannel,ChannelRows,HorOffset,VerOffset,ChannelOrder,ActiveChannel,FirstZoomChannel,LeftProbeChanged,ProbeBrainAreas)

%% Set Plot properties

if isnan(VerOffset)
    VerOffset = 0;
end

if ~isnan(NrChannel) && ~isnan(ChannelSpacing)
    %% Get existing handles
    % Add ButtonDownFcn to each line object in UIAxis
    ProbeLines = findobj(Figure,'Tag','ProbeLines');
    % Add ButtonDownFcn to each line object in UIAxis
    BracketLine = findobj(Figure, 'Tag', 'BracketLine');
    % Add ButtonDownFcn to each line object in UIAxis
    ChannelViewRight = findobj(Figure,'Tag','ChannelViewRight');
    if LeftProbeChanged
        % Add ButtonDownFcn to each line object in UIAxis
        ChannelViewLeft = findobj(Figure,'Tag','ChannelViewLeft');
        % Add ButtonDownFcn to each line object in UIAxis
        GrayProbeFilling = findobj(Figure,'Tag','GrayProbeFilling');
    else
        % Add ButtonDownFcn to each line object in UIAxis
        ChannelViewLeft = [];
        % Add ButtonDownFcn to each line object in UIAxis
        GrayProbeFilling = [];
    end
    % Add ButtonDownFcn to each line object in UIAxis
    ChannelText = findobj(Figure,'Tag','ChannelText');
    if LeftProbeChanged
        if length(GrayProbeFilling)>2
            delete(GrayProbeFilling(2:end));
            GrayProbeFilling = findobj(Figure,'Tag','GrayProbeFilling');
        end
        if length(ProbeLines)>4
            delete(ProbeLines(5:end));
            ProbeLines = findobj(Figure,'Tag','ProbeLines');
        end
        if length(ChannelViewLeft)>NrChannel*ChannelRows
            delete(ChannelViewLeft(NrChannel*ChannelRows+1:end));
            ChannelViewLeft = findobj(Figure,'Tag','ChannelViewLeft');
        end
    else
        GrayProbeFilling = [];
        ProbeLines = [];
        ChannelViewLeft = [];
    end
    
    if length(BracketLine)>6
        delete(ProbeLines(7:end));
        BracketLine = findobj(Figure,'Tag','BracketLine');
    end
    
    if LeftProbeChanged
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
    end
    
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

    %% Plot Probe Scheme on the right
    [yPoint,yLimits,ActiveChannel,yLimitsSquares,squareHeight] = Utility_Plot_Probe_Scheme(Figure,GrayProbeFilling,ProbeLines,ChannelViewLeft,NrChannel,ChannelSpacing,ActiveChannel,VerOffset,ChannelRows,LeftProbeChanged);

    %% Plot Brackets
    [yLimitBracktes] = Utitlity_Plot_Brackets_Probe_View(Figure,BracketLine,NrChannel,ChannelSpacing,yPoint,yLimits,yLimitsSquares,squareHeight,FirstZoomChannel,ChannelRows);
    
    %% Plot Zoomed Channel on the right side

    [numSquares,squareHeight,lowylimits,CorrrectedVerOffset] = Utitlity_Plot_Zoomed_Channel_Right_Side(Figure,ChannelViewRight,NrChannel,ChannelSpacing,yPoint,ChannelRows,VerOffset,FirstZoomChannel,ActiveChannel,ChannelRows,yLimitBracktes);

    %% Plot Channel Names on the right side

    Utitlity_Plot_Zoomed_Text_Channel_Right_Side(Figure,ChannelText,NrChannel,ChannelRows,FirstZoomChannel,numSquares,squareHeight,lowylimits,CorrrectedVerOffset)
    
    if yLimits(2)>=yLimitBracktes(2)
        ylim(Figure,[yPoint yLimits(2)])
    else
        ylim(Figure,[yPoint yLimitBracktes(2)])
    end

    %% Plot Brain Areas
    % Position based on distance to tip
    
    Utility_Plot_BrainAreas(Figure,ProbeBrainAreas);

end