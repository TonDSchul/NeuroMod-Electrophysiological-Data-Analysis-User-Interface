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

    Utility_Plot_Interactive_Probe_View(app.UIAxes,str2double(app.ChannelSpacingumEditField.Value),str2double(app.NrChannelEditField.Value),str2double(app.ChannelRowsDropDown.Value),str2double(app.HorizontalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField.Value),app.ChannelOrderField.Value,ActiveChannel,app.FirstZoomChannel,0)

%% No probe layout window
elseif ~ProbeViewWindow % no change when user clicked on a channel square in the right

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

     %% If clicked Channel is actoive, inactivate it
    if strcmp(Window,'Main Window') || strcmp(Window,'All Windows Opened') || strcmp(Window,'Main Plot Current Source Density') || strcmp(Window,'Main Plot Power Estimate') || strcmp(Window,'Main Plot Spike Rate')
        if ~isempty(ChannelClicked)
            if sum(ChannelClicked==app.Mainapp.Data.Info.ProbeInfo.ActiveChannel)>0
                app.Mainapp.ActiveChannel(ChannelClicked==app.Mainapp.Data.Info.ProbeInfo.ActiveChannel) = [];
            else
                app.Mainapp.ActiveChannel = sort([app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,ChannelClicked]);
            end
        end

        Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.Channelorder,app.Mainapp.ActiveChannel,app.FirstZoomChannel,1)
        
        app.Mainapp.ChannelChange = "ProbeView";

        Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp,0,"Subsequent","Static",app.Mainapp.PlotEvents,app.Mainapp.Plotspikes);
    end

    if strcmp(Window,'Static Spectrum Window') || strcmp(Window,'All Windows Opened')
        if ~isempty(app.Mainapp.ContStaticSpectrumWindow)
            if isvalid(app.Mainapp.ContStaticSpectrumWindow)
                if strcmp(app.Mainapp.ContStaticSpectrumWindow.AnalysisDropDown.Value,'Band Power over Depth')
                    [app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,~] = Continous_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.ContStaticSpectrumWindow.DataSourceDropDown.Value,app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,app.Mainapp.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Value,app.Mainapp.ContStaticSpectrumWindow.UIAxes,app.Mainapp.ContStaticSpectrumWindow.UIAxes_2,app.Mainapp.ContStaticSpectrumWindow.TextArea,'All',app.Mainapp.ContStaticSpectrumWindow.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.ActiveChannel);
                else
                    [app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,~] = Continous_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.ContStaticSpectrumWindow.DataSourceDropDown.Value,app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,app.Mainapp.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Value,app.Mainapp.ContStaticSpectrumWindow.UIAxes,app.Mainapp.ContStaticSpectrumWindow.UIAxes_2,app.Mainapp.ContStaticSpectrumWindow.TextArea,'Just Frequency Bands',app.Mainapp.ContStaticSpectrumWindow.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.ActiveChannel);
                end
            end
        end
    end

end

