function [app] = ProbeViewClickLineCallback(app, event, Window)


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

ChannelClicked = [];

if ProbeViewWindow == 0    

    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)<=32
            numSquares = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel); % Number of squares - 
        else
            numSquares = 32; % Number of squares - 
        end
    else
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)<=32
            numSquares = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)/2; % Number of squares - 
        else
            numSquares = 32; % Number of squares - 
        end
    end

    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1 %% X for 1 row
        %% Check if x pos. of squares was clicked
        x1 = 4;   % lower x-limit of squares
        x2 = 6;   % upper x-limit of squares
    
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1
            Tempxdistances = (x1:(x2 - x1) / ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)*2)+1):x2)+1;
        else
            Tempxdistances = x1:(x2 - x1) / ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)*2)+1):x2;
        end

        squareWidth = Tempxdistances(2)-Tempxdistances(1);
        
        xdistances(1) = Tempxdistances(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows));
        xdistances(2) = xdistances(1) + squareWidth;

        % if click in xrange of squares
        if xClick >= xdistances(1) && xClick <= xdistances(2)
            ClickedOnChannelXDirection = 1;
        end
    end
    
    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 2 %% X for 2 rows
        %% Check if x pos. of squares was clicked
        x1 = 4;   % lower x-limit of squares
        x2 = 6;   % upper x-limit of squares
    
        Tempxdistances= x1:(x2 - x1) / ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)*2)+1):x2;

        squareWidth = Tempxdistances(2)-Tempxdistances(1);
        
        xdistanceRight(1) = Tempxdistances(2);
        xdistanceRight(2) = xdistanceRight(1) + squareWidth;

        xdistanceLeft(1) = Tempxdistances(4);
        xdistanceLeft(2) = xdistanceLeft(1) + squareWidth;

        % if click in xrange of squares
        if xClick >= xdistanceRight(1) && xClick <= xdistanceRight(2)
            ClickedOnChannelXDirectionLeft = 1;
        end
        % if click in xrange of squares
        if xClick >= xdistanceLeft(1) && xClick <= xdistanceLeft(2)
            ClickedOnChannelXDirectionRight = 1;
        end
    end

    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1 || str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 2
        %% Check if y pos. of squares was clicked
        yLimits = [0 ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-1)*app.Mainapp.Data.Info.ChannelSpacing)+(app.Mainapp.Data.Info.ChannelSpacing)*2];  % Get current y-axis limits to extend the lines
        yPoint = yLimits(1) - (yLimits(2) - yLimits(1)) / 10;  % y position below the minimum of the plotted lines

        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)<=64 % imit to show: 64 channel
            yLimitBracktes(1) = yPoint+abs(yPoint/2);
            yLimitBracktes(2) = ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-1)*app.Mainapp.Data.Info.ChannelSpacing)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel);
        else
            yLimitBracktes(1) = yPoint+abs(yPoint/2);
            yLimitBracktes(2) = ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-1)*app.Mainapp.Data.Info.ChannelSpacing)-str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel);
        end

        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1
            highylimits = yLimitBracktes(2);
            lowylimits = yLimitBracktes(1);
        else
            highylimits = yLimitBracktes(2);
            lowylimits = yLimitBracktes(1);

            squareHeight = (highylimits-lowylimits)/numSquares;

            if str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset) ~= 0
                CorrectionFactor = app.Mainapp.Data.Info.ChannelSpacing/str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset);
                
                CorrrectedVerOffset = squareHeight/CorrectionFactor;
            else
                CorrrectedVerOffset = 0;
            end

            highylimits = yLimitBracktes(2)+CorrrectedVerOffset;
            lowylimits = yLimitBracktes(1)+CorrrectedVerOffset;
        end
        
        squareHeight = (highylimits-lowylimits)/numSquares;
                
        if yClick >= lowylimits && yClick <= highylimits
            ClickedOnChannelYDirection = 1;
        end
    end

    %% If user clicked on channel on the right detect channel
    if ClickedOnChannelXDirection == 1 && ClickedOnChannelYDirection == 1 || ClickedOnChannelXDirectionRight == 1 && ClickedOnChannelYDirection == 1 || ClickedOnChannelXDirectionLeft == 1 && ClickedOnChannelYDirection == 1
        
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1
            if app.FirstZoomChannel > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)
                if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)>=32
                    app.FirstZoomChannel = app.FirstZoomChannel-32+1;
                else
                    app.FirstZoomChannel = 1;
                end
            end
            if app.FirstZoomChannel+31 > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)
                app.FirstZoomChannel = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-32+1;
            end
        else
            if (app.FirstZoomChannel*2)+64 >= str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2+1
                %dont update plot
                
                if app.Mainapp.Data.Info.ProbeInfo.NrChannel*2>=64
                    app.FirstZoomChannel = round(((str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2-64)+1)/2);
                else
                    app.FirstZoomChannel = 1;
                end
            end
        end
 
        if app.FirstZoomChannel <= 0
            app.FirstZoomChannel = 1;
        end

        %% detect based on plotted channelnames
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==2 && ClickedOnChannelXDirectionRight == 1
            
            yPos = NaN((numSquares) - 1,2);
            currentchannel = [];

            for i = 0:((numSquares) - 1) 
               yPos(i+1,1) = (lowylimits+ (i * squareHeight)); % lower y pos
               yPos(i+1,2) = (lowylimits+ (i * squareHeight)) +squareHeight; % upper y pos
             
               currentchannel(i+1) = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1-(app.FirstZoomChannel+1+i);

            end
          
            currentchannel = currentchannel+str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1;

        elseif str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==2 && ClickedOnChannelXDirectionLeft == 1
            yPos = NaN((numSquares) - 1,2);
            currentchannel = [];

            if CorrrectedVerOffset ~=0
                 for i = 0:((numSquares) - 1) 
                    yPos(i+1,1) = lowylimits+ ((i * (squareHeight)))-CorrrectedVerOffset; % lower y pos
                    yPos(i+1,2) = lowylimits+ ((i * (squareHeight)))+squareHeight-CorrrectedVerOffset; % upper y pos
    
                    currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel))+2-(app.FirstZoomChannel+1+i);
                 end
            else
                for i = 0:((numSquares) - 1) 
                    yPos(i+1,1) = lowylimits+ ((i * (squareHeight))); % lower y pos
                    yPos(i+1,2) = lowylimits+ ((i * (squareHeight)))+squareHeight; % upper y pos
    
                    currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel))+2-(app.FirstZoomChannel+1+i);
                 end
            end
        end

        %% detect based on plotted channelnames
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==1 
            yPos = NaN((numSquares) - 1,2);
            currentchannel = [];

             for i = 0:((numSquares) - 1) 
                yPos(i+1,1) = lowylimits+ ((i * (squareHeight))); % lower y pos
                yPos(i+1,2) = lowylimits+ ((i * (squareHeight)))+squareHeight; % upper y pos

                currentchannel(i+1) = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1-(app.FirstZoomChannel+i);
             end
        end
        
        % Find the index where y_value lies within the range
        Index = find(yClick >= yPos(:,1) & yClick <= yPos(:,2), 1);
        
        if isempty(Index)
            Index = 1;
        end

        ChannelClicked = currentchannel(Index);

        if sum(ChannelClicked == app.Mainapp.Data.Info.ProbeInfo.ActiveChannel)>0
            %% If clicked Channel is actoive, inactivate it

            if sum(ChannelClicked==app.Mainapp.Data.Info.ProbeInfo.ActiveChannel)>0
                if sum(ChannelClicked==app.Mainapp.ActiveChannel)>0
                    if length(app.Mainapp.ActiveChannel)>=2
                        app.Mainapp.ActiveChannel(ChannelClicked==app.Mainapp.ActiveChannel) = [];
                    else
                        msgbox("Warning: At least one channel required to be active.")
                    end
                else
                    app.Mainapp.ActiveChannel = sort([app.Mainapp.ActiveChannel,ChannelClicked]);
                end
            end

            if isscalar(app.Mainapp.ActiveChannel)
                app.Mainapp.UIAxes.YTickMode = 'auto';
                app.Mainapp.UIAxes.YTickLabelMode = 'auto';
                ylabel(app.Mainapp.UIAxes,"Signal [mV]");
            else
                app.Mainapp.UIAxes.YTick = [];         % Remove Y ticks
                app.Mainapp.UIAxes.YTickLabel = {};    % Remove Y tick labels
                ylabel(app.Mainapp.UIAxes,"");
            end


            if isfield(app.Mainapp.Data.Info.ProbeInfo,'CompleteAreaNames')
                BrainAreaInfo = app.Mainapp.Data.Info.ProbeInfo.CompleteAreaNames;
            else
                BrainAreaInfo = [];
            end

            %% Update plots with new channelselection

        
            if strcmp(Window,'Main Window') || strcmp(Window,'All Windows Opened') || strcmp(Window,'Main Plot Current Source Density') || strcmp(Window,'Main Plot Power Estimate') || strcmp(Window,'Main Plot Spike Rate')
              
                Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,1,ChannelClicked)
                
                app.Mainapp.ChannelChange = "ProbeView";
    
                Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp,0,"Subsequent","Static",app.Mainapp.PlotEvents,app.Mainapp.Plotspikes);
            end
           
            if strcmp(Window,'Static Spectrum Window') || strcmp(Window,'All Windows Opened')
                if ~isempty(app.Mainapp.ContStaticSpectrumWindow)
                    if isvalid(app.Mainapp.ContStaticSpectrumWindow)
                        Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,1,ChannelClicked) 
                        if strcmp(app.Mainapp.ContStaticSpectrumWindow.AnalysisDropDown.Value,'Band Power over Depth')
                            [app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,~] = Continous_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.ContStaticSpectrumWindow.DataSourceDropDown.Value,app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,app.Mainapp.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Value,app.Mainapp.ContStaticSpectrumWindow.UIAxes,app.Mainapp.ContStaticSpectrumWindow.UIAxes_2,app.Mainapp.ContStaticSpectrumWindow.TextArea,'All',app.Mainapp.ContStaticSpectrumWindow.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.ActiveChannel);
                        else
                            [app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,~] = Continous_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.ContStaticSpectrumWindow.DataSourceDropDown.Value,app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,app.Mainapp.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Value,app.Mainapp.ContStaticSpectrumWindow.UIAxes,app.Mainapp.ContStaticSpectrumWindow.UIAxes_2,app.Mainapp.ContStaticSpectrumWindow.TextArea,'Just Frequency Bands',app.Mainapp.ContStaticSpectrumWindow.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.ActiveChannel);
                        end
                    end
                end
            end
            
            if strcmp(Window,'Cont. Internal Spikes') || strcmp(Window,'All Windows Opened') || strcmp(Window,'Cont. Kilosort Spikes')
                if ~isempty(app.Mainapp.ConInternalSpikesWindow) || ~isempty(app.Mainapp.ConKilosortSpikesWindow)
                    Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,1,ChannelClicked);
                    [app] = Utility_ProbeChange_Plot_ContSpikes(app);
                end
            end

            if strcmp(Window,'Event Internal Spikes') || strcmp(Window,'All Windows Opened') || strcmp(Window,'Event Kilosort Spikes')
                if ~isempty(app.Mainapp.EventInternalSpikesWindow) || ~isempty(app.Mainapp.EventKilosortSpikesWindow)
                    Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,1,ChannelClicked);
                    [app] = Utility_ProbeChange_Plot_EventSpikes(app);
                end
            end

            if strcmp(Window,'Event ERP Window') || strcmp(Window,'All Windows Opened') || strcmp(Window,'Event CSD Window') || strcmp(Window,'Event CSD Window')|| strcmp(Window,'Event Static Spectrum Window')  || strcmp(Window,'Event Time Frequency Power Window') 
                if ~isempty(app.Mainapp.EventLFPERP) || ~isempty(app.Mainapp.EventLFPCSD) || ~isempty(app.Mainapp.EventLFPSSP) || ~isempty(app.Mainapp.EventLFPTF)
                    Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,1,ChannelClicked);
                    if strcmp(Window,'Event CSD Window') && ~isempty(app.Mainapp.EventLFPCSD) || strcmp(Window,'All Windows Opened') && ~isempty(app.Mainapp.EventLFPCSD)
                        [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'CSD');
                    elseif strcmp(Window,'Event ERP Window') && ~isempty(app.Mainapp.EventLFPERP) || strcmp(Window,'All Windows Opened') && ~isempty(app.Mainapp.EventLFPERP)
                        [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'ERP');
                    elseif strcmp(Window,'Event Static Spectrum Window') && ~isempty(app.Mainapp.EventLFPSSP) || strcmp(Window,'All Windows Opened') && ~isempty(app.Mainapp.EventLFPSSP)
                        [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'EventSpectrum');
                    elseif strcmp(Window,'Event Time Frequency Power Window') && ~isempty(app.Mainapp.EventLFPTF) || strcmp(Window,'All Windows Opened') && ~isempty(app.Mainapp.EventLFPTF)
                        [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'TF');
                    end
                end
            end

            if strcmp(Window,'Prepro Artefact Rejection') || strcmp(Window,'All Windows Opened')
                if ~isempty(app.Mainapp.PreproArtefactRejection)
                    [~,app.Mainapp.PreproArtefactRejection.StimArtefactInfo] = Preprocess_Extract_and_Plot_Stimulation_Artefact(app.Mainapp.Data, app.Mainapp.PreproArtefactRejection.TimeAroundEventsEditField_2.Value ,app.Mainapp.PreproArtefactRejection.TimeAroundEventsEditField.Value, app.Mainapp.PreproArtefactRejection.EventChannelforStimulationDropDown.Value, app.Mainapp.PreproArtefactRejection.EventstoPlotDropDown.Value, app.Mainapp.PreproArtefactRejection.Slider.Value, app.Mainapp.PreproArtefactRejection.UIAxes, app.Mainapp.ActiveChannel);            
                end
            end
           
        end
    end
end


%% Set Probe Information Window for data extraction stuff

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

    Utility_Plot_Interactive_Probe_View(app.UIAxes,str2double(app.ChannelSpacingumEditField.Value),str2double(app.NrChannelEditField.Value),str2double(app.ChannelRowsDropDown.Value),str2double(app.HorizontalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField.Value),app.ChannelOrderField.Value,ActiveChannel,app.FirstZoomChannel,0,BrainAreaInfo,ActiveChannel,app.ShowChannelSpacingCheckBox.Value,1,0,[])

%% Main Window probe view_____if clicked on a line but not on a channel on the right side --> not to change channel selection
elseif ~ProbeViewWindow && sum([ClickedOnChannelXDirection,ClickedOnChannelYDirection]) < 2 && ClickedOnChannelYDirection == 0 || ClickedOnChannelXDirection == 0 % no change when user clicked on a channel square in the right
    
    if ClickedOnChannelXDirectionLeft == 0 && ClickedOnChannelXDirectionRight == 0
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

        Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,0,[])
    end
end
