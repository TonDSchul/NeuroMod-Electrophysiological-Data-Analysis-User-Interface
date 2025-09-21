function Error = Utility_Save_Data_as_xlsx(Fullsavefile,PlottedData,Analysis)

%________________________________________________________________________________________
%% Function to export plotted/Analyzed data as .csv or .txt files
% This function gets called in the Utility_Get_Plot_Data function

% Input Arguments:
% 1. Fullsavefile: char, Pcomplete path to the .mat file to save data in (including the .mat file ending)
% 2. PlottedData: structure holding data that was plotted. Spike Analysis,
% Main Window Analysis and LFP Analysis all create new fieldnames and are
% therefore saved seperately.
% 3: Analysis: string specifying the name of the analysis. This has to
% obey some rules! For Unit analysis, it has to cointain the string "Unit".
% For Spike analyis it has to contain "Spike" or "Spikes"
% For Time Frequency power it has to contain the string "Phase"
% For CSD and ERP anylsis it has to contain the string "Current" or
% "Potential" and so on. See Utility_Save_Data_as_TXT_CSV and
% Utility_Save_Data_as_MAT functions

% Output Arguments: 
% 1. Error: 1 if an error occured, 0 if not. gets checked in Utility_Get_Plot_Data function

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Check if basic requirements for currently seelcted export are fullfilled --> i.e. when untis selected that units were plotted before
Error = Utility_Check_Saved_Spike_PlotData(PlottedData,Analysis);

if Error == 1
    return
end

if ~exist(fileparts(Fullsavefile), 'dir')
    mkdir(fileparts(Fullsavefile));
end

TextInfos = {};

%% Delete Info files too big to reasonably show
if isfield(PlottedData.Info,'Channelorder')
    fieldsToDelete = {'Channelorder'};
    % Delete fields
    PlottedData.Info = rmfield(PlottedData.Info, fieldsToDelete);
end
if isfield(PlottedData.Info,'EventRelatedActiveChannel')
    fieldsToDelete = {'EventRelatedActiveChannel'};
    % Delete fields
    PlottedData.Info = rmfield(PlottedData.Info, fieldsToDelete);
end
if isfield(PlottedData.Info,'EventRelatedTime')
    fieldsToDelete = {'EventRelatedTime'};
    % Delete fields
    PlottedData.Info = rmfield(PlottedData.Info, fieldsToDelete);
end

%% First For spike analyis (Continous and events); Otherwise unit analysis window
if ~contains(Analysis,"Plot") && ~contains(Analysis,"Event Related") && ~contains(Analysis,"Current") && ~contains(Analysis,"Phase") && ~contains(Analysis,"Instantaneous")

    % Main type info
    if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes")
        TextInfos{end+1} = ['***** ' char(PlottedData.Type) ' *****'];
    elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")
        if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
            TextInfos{end+1} = ['***** ' char(PlottedData.MainRateUnitType) ' *****'];
        elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && contains(Analysis,"Channel")
            TextInfos{end+1} = ['***** ' char(PlottedData.MainRateChannelType) ' *****'];
        elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
            TextInfos{end+1} = ['***** ' char(PlottedData.MainRateTimeType) ' *****'];
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            TextInfos{end+1} = ['***** ' char(PlottedData.MainUnitType) ' *****'];
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Live")
            TextInfos{end+1} = ['***** ' char(PlottedData.MainType) ' *****'];
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && contains(Analysis,"Live")
            TextInfos{end+1} = ['***** ' char(PlottedData.LiveSpikeType) ' *****'];
        end
    end

    % Time info
    TextInfos{end+1} = ['***** Time Duration of Analyzed Data: ' num2str(PlottedData.TimeDuration) 's *****'];
    TextInfos{end+1} = ['***** Start Time of Analyzed Data: ' num2str(PlottedData.Time_Points_Plot(1)) 's *****'];
    TextInfos{end+1} = ['***** Stop Time of Analyzed Data: ' num2str(PlottedData.Time_Points_Plot(2)) 's *****'];
    
    %% Write TextInfos to Excel (starting at row 1, column A)
    writecell(TextInfos', Fullsavefile, 'Sheet', 1, 'Range', 'A1');

    %% Write Info
    % Example: Convert structure fields into "field: value" text
    fn = fieldnames(PlottedData.Info);
    TextInfos = {};
    for k = 1:numel(fn)
        val = PlottedData.Info.(fn{k});
        if isnumeric(val)
            valStr = num2str(val);
        elseif isstring(val) || ischar(val)
            valStr = char(val);
        else
            valStr = '<non-displayable>';
        end
        TextInfos{end+1,1} = ['***** Meta Data: ' fn{k} ' = ' valStr ' *****'];
    end
    
    % Write to Excel (column E, starting at row 1)
    writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', 'F1');

    %% Write X,Y data
   
    %% Choose X_Data, Y_Data, X_Tick depending on Analysis
    if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes")
        XData  = PlottedData.XData;
        YData  = PlottedData.YData;
        XTick  = PlottedData.XTicks;
    elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")
        % X_Data
        if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
            XData = PlottedData.MainRateUnitXData;
            YData = PlottedData.MainRateUnitYData;
            XTick = PlottedData.MainRateUnitXTicks;
        elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && contains(Analysis,"Channel")
            XData = PlottedData.MainRateChannelXData;
            YData = PlottedData.MainRateChannelYData;
            XTick = PlottedData.MainRateChannelXTicks;
        elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && ~contains(Analysis,"Channel") && ~contains(Analysis,"Heatmap")
            XData = PlottedData.MainRateTimeXData;
            YData = PlottedData.MainRateTimeYData;
            XTick = PlottedData.MainRateTimeXTicks;
        elseif contains(Analysis,"Heatmap")
            XData = PlottedData.MainXData;
            YData = PlottedData.MainYData;
            XTick = PlottedData.MainXTicks;
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            XData = PlottedData.MainUnitXData;
            YData = PlottedData.MainUnitYData;
            XTick = PlottedData.MainUnitXTicks;
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Live")
            if contains(Analysis,"Waveforms") && ~contains(Analysis,"Average")
                XData = PlottedData.MainXData;
                YData = [];
                XTick = PlottedData.MainXTicks;
            else
                XData = PlottedData.MainXData;
                YData = PlottedData.MainYData;
                XTick = PlottedData.MainXTicks;
            end
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && contains(Analysis,"Live")
            XData = PlottedData.LiveSpikeXData;
            YData = PlottedData.LiveSpikeYData;
            XTick = PlottedData.LiveSpikeXTicks;
        end
    end

    %% Find max length to pad shorter columns with NaN
    maxLen = max([length(XData), length(YData), length(XTick)]);
    if length(XData) < maxLen
        XData(end+1:maxLen) = NaN;
    end
    if length(YData) < maxLen
        YData(end+1:maxLen) = NaN;
    end
    if length(XTick) < maxLen
        if isempty(XTick)
            XTick(1:maxLen) = '-';
        else
            XTick(end+1:maxLen) = {''};
        end
    end
   
    %% Write CData if available (Z data is not saved since its the same as C data when 3d plot is selected)
    
    %% --- Prepare C_Data ---
    CData = [];  % default empty

    if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
        if ~isempty(PlottedData.CData)
            CData = PlottedData.CData;
        end
    elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
        if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit") %% No Cdata for spike rate
        
        elseif contains(Analysis,"Spike Triggered") && ~contains(Analysis,"Unit")
            CData = PlottedData.MainCData;
        elseif contains(Analysis,"Spike Triggered") && contains(Analysis,"Unit")
            CData = PlottedData.MainUnitCData;
        elseif contains(Analysis,"Amplitude Density Along Depth") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit")
            CData = PlottedData.MainCData;
        elseif contains(Analysis,"Amplitude Density Along Depth") && ~contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
            CData = PlottedData.MainUnitCData;
        elseif contains(Analysis,"Average Waveforms") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit")
            CData = PlottedData.MainCData;
        elseif contains(Analysis,"Average Waveforms") && ~contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
            CData = PlottedData.MainUnitCData;
        elseif contains(Analysis,"Waveforms") && ~contains(Analysis,"Average") && ~contains(Analysis,"Unit")
            CData = PlottedData.MainYData;
        elseif contains(Analysis,"Waveforms") && ~contains(Analysis,"Average") && contains(Analysis,"Unit")
            CData = PlottedData.MainUnitYData;
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Spike Times")
            if ~isempty(PlottedData.MainUnitCData)
                CData = PlottedData.MainUnitCData;
            end
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Live") && ~contains(Analysis,"Spike Times") || contains(Analysis,"Heatmap")
            if ~isempty(PlottedData.MainCData)
                CData = PlottedData.MainCData';
            end
        end
    end

    %% --- First write X/Y/XTick table (as before) ---
    maxLen = max([length(XData), length(YData), length(XTick)]);
    if length(XData) < maxLen, XData(end+1:maxLen) = NaN; end
    if length(YData) < maxLen, YData(end+1:maxLen) = NaN; end
    if length(XTick) < maxLen, XTick(end+1:maxLen) = {''}; end
    if size(XTick,1)>size(XTick,2)
        XTick = XTick';
    end
    
    T = Utility_Save_xlsx_Set_VariableNames(PlottedData,Analysis,XData,YData,XTick);
    
    % Write table to Excel
    tableStartRow = length(TextInfos) + 2;  % leave 1 empty row below TextInfos
    writetable(T, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);

    %% --- Combine with existing table if CData exists ---
    if ~isempty(CData)
      
        % Add a header
        try
            writematrix(CData, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow+1)]);
        catch
            writematrix(CData', Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow+1)]);
        end
        
        if contains(Analysis,"Waveforms") && ~contains(Analysis,"Average")
            writecell({"***** Waveform Data (Waveforms x Time)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
        elseif contains(Analysis,"Heatmap")
            writecell({"***** Heatmap data (Time x Channel)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
        elseif contains(Analysis,"Spike Triggered LFP")
            writecell({"***** Spike Triggered LFP (Depth x Time)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
        elseif contains(Analysis,"Waveforms") && contains(Analysis,"Average")
            writecell({"***** Average Waveform Over Depth Data (Depth x Waveform)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
        elseif contains(Analysis,"Amplitude Density Along Depth")
            writecell({"***** Amplitude Density Spike Rate (Depth x Amplitude)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
        else
            if size(PlottedData.CData,1)>size(PlottedData.CData,2)
                writecell({"***** C_Data (Channel x Time)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
            else
                writecell({"***** C_Data (Time x Channel)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
            end
        end
    end
        
end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% If spike analyis (Continous and events); 

TextInfosStart = {};
%% -------------------- Unit Analysis -------------------- 
if contains(Analysis,"Plot")
    TextInfosStart{end+1} = ['***** Time Duration of Analyzed Data: ' num2str(PlottedData.TimeDuration) 's *****'];
    TextInfosStart{end+1} = ['***** Start Time of Analyzed Data: ' num2str(PlottedData.Time_Points_Plot(1)) 's *****'];
    TextInfosStart{end+1} = ['***** Stop Time of Analyzed Data: ' num2str(PlottedData.Time_Points_Plot(2)) 's *****'];
    
    CData = [];
    TotalLengthSoFarlength = 0;

    for nrunit = 1:size(PlottedData.UnitAnalyisWaveformsType,2)
        AnalyisText = convertStringsToChars(Analysis);
        SelectedPlot = str2double(AnalyisText(end-1:end)); 
        
        if contains(Analysis,"Waveform Analysis")
            TextInfo = ['***** ' convertStringsToChars(PlottedData.UnitAnalyisWaveformsType{SelectedPlot,nrunit}) ' *****'];
            XData = PlottedData.UnitAnalyisWaveformsXData{SelectedPlot,nrunit};
            YData = PlottedData.UnitAnalyisWaveformsYData{SelectedPlot,nrunit};
            XTick = PlottedData.UnitAnalyisWaveformsXTicks{SelectedPlot,nrunit};
            CData = YData';
            YData = [];
            % No CData
            
        elseif contains(Analysis,"ISI Analyis")
            TextInfo = ['***** ' convertStringsToChars(PlottedData.UnitAnalyisISIType{SelectedPlot,nrunit}) ' *****'];
            XData = PlottedData.UnitAnalyisISIXData{SelectedPlot,nrunit};
            YData = PlottedData.UnitAnalyisISIYData{SelectedPlot,nrunit};
            XTick = PlottedData.UnitAnalyisISIXTicks{SelectedPlot,nrunit};
            % No CData
            
        elseif contains(Analysis,"Autocorrelogram Analyis")
            TextInfo = ['***** ' convertStringsToChars(PlottedData.UnitAnalyisAutoType{SelectedPlot,nrunit}) ' *****'];
            XData = PlottedData.UnitAnalyisAutoXData{SelectedPlot,nrunit};
            YData = PlottedData.UnitAnalyisAutoYData{SelectedPlot,nrunit};
            XTick = PlottedData.UnitAnalyisAutoXTicks{SelectedPlot,nrunit};
            % No CData
            
        end
        
        % You can store TextInfo if you want to write later
        TextInfosStart{end+1} = TextInfo;

        % Only do once
        if nrunit == 1

            %% Write Info
            % Example: Convert structure fields into "field: value" text
            fn = fieldnames(PlottedData.Info);
            TextInfos = {};
            for k = 1:numel(fn)
                val = PlottedData.Info.(fn{k});
                if isnumeric(val)
                    valStr = num2str(val);
                elseif isstring(val) || ischar(val)
                    valStr = char(val);
                else
                    valStr = '<non-displayable>';
                end
                TextInfos{end+1,1} = ['***** Meta Data: ' fn{k} ' = ' valStr ' *****'];
            end
            
            % Write to Excel (column E, starting at row 1)
            writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', 'F1');
        end
        
        if nrunit == 1
            TotalLengthSoFarlength = TotalLengthSoFarlength+length(TextInfos)+1;
            %% Write TextInfos to Excel (starting at row 1, column A)
            writecell(TextInfosStart', Fullsavefile, 'Sheet', 1, 'Range', 'A1');
        else
            TotalLengthSoFarlength = TotalLengthSoFarlength+length(XData)+1;
            %% Write TextInfos to Excel (starting at row 1, column A)
            writecell(TextInfosStart', Fullsavefile, 'Sheet', 1, 'Range', strcat('A',num2str(TotalLengthSoFarlength)));
        end

        %% --- First write X/Y/XTick table (as before) ---
        maxLen = max([length(XData), length(YData), length(XTick)]);
        if length(XData) < maxLen, XData(end+1:maxLen) = NaN; end
        if length(YData) < maxLen, YData(end+1:maxLen) = NaN; end
        if length(XTick) < maxLen, XTick(end+1:maxLen) = {''}; end
        if size(XTick,1)>size(XTick,2)
            XTick = XTick';
        end
        
        T = Utility_Save_xlsx_Set_VariableNames(PlottedData,Analysis,XData,YData,XTick);

        % Write table to Excel
        tableStartRow = length(TextInfos) + 2;  % leave 1 empty row below TextInfos
        writetable(T, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(TotalLengthSoFarlength)]);
        
        %% --- Combine with existing table if CData exists ---
        if ~isempty(CData)
          
            % Add a header
            if contains(Analysis,"Waveform Analysis")
                writecell({"***** Time x Waveforms *****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(TotalLengthSoFarlength)]);
            else
                writecell({"***** C_Data *****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(TotalLengthSoFarlength)]);
            end
        
            try
                writematrix(CData, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(TotalLengthSoFarlength+1)]);
            catch
                writematrix(CData', Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(TotalLengthSoFarlength+1)]);
            end
        end

    end
end


%% -------------------------------------------- For LFP Analysis of event related data --------------------------------------------

if contains(Analysis,"Event Related") || contains(Analysis,"Current")
    TextInfos{end+1} = ['***** Time Duration of Analyzed Data: ' num2str(PlottedData.TimeDuration) 's *****'];
    TextInfos{end+1} = ['***** Start Time of Analyzed Data: ' num2str(PlottedData.Time_Points_Plot(1)) 's *****'];
    TextInfos{end+1} = ['***** Stop Time of Analyzed Data: ' num2str(PlottedData.Time_Points_Plot(2)) 's *****'];
    CData = [];
    if contains(Analysis,"Potential") && contains(Analysis,"Events")
        TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.ERPoverEventsType) ' *****'];
        XData = PlottedData.ERPoverEventsXData;
        YData = PlottedData.ERPoverEventsYData;
        XTick = PlottedData.ERPoverEventsXTicks;
        CData = YData';
        % No CData
        
    elseif contains(Analysis,"Potential") && contains(Analysis,"Channel")
        TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.ERPoverChannelType) ' *****'];
        XData = PlottedData.ERPoverChannelXData;
        YData = NaN(size(XData));
        XTick = PlottedData.ERPoverChannelXTicks;
        CData = PlottedData.ERPoverChannelYData';
        % No CData
        
    elseif contains(Analysis,"Current")
        TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.CSDType) ' *****'];
        XData = PlottedData.CSDXData;
        YData = PlottedData.CSDYData;
        XTick = PlottedData.CSDXTicks;
        CData = PlottedData.CSDCData';

    elseif contains(Analysis,"Static Spectrum")
        if contains(Analysis,"Depth")
            TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.EventSpectrumDepthType) ' *****'];
            XData = PlottedData.EventSpectrumDepthXData;
            YData = PlottedData.EventSpectrumDepthYData;
            XTick = PlottedData.EventSpectrumDepthXTicks;
            CData = PlottedData.EventSpectrumDepthCData;
        else
            TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.EventSpectrumType) ' *****'];
            XData = PlottedData.EventSpectrumXData;
            YData = PlottedData.EventSpectrumYData;
            XTick = PlottedData.EventSpectrumXTicks;
            CData = [];
        end
    elseif contains(Analysis,"Time Frequency Power")
        TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.TFPowerType) ' *****'];
        XData = PlottedData.TFPowerXData;
        YData = PlottedData.TFPowerYData;
        XTick = PlottedData.TFPowerXTicks;
        CData = PlottedData.TFPowerCData';
    end
    
    %% Write TextInfos to Excel (starting at row 1, column A)
    writecell(TextInfos', Fullsavefile, 'Sheet', 1, 'Range', 'A1');
    
    %% Write Info
    % Example: Convert structure fields into "field: value" text
    fn = fieldnames(PlottedData.Info);
    TextInfos = {};
    for k = 1:numel(fn)
        val = PlottedData.Info.(fn{k});
        if isnumeric(val)
            valStr = num2str(val);
        elseif isstring(val) || ischar(val)
            valStr = char(val);
        else
            valStr = '<non-displayable>';
        end
        TextInfos{end+1,1} = ['***** Meta Data: ' fn{k} ' = ' valStr ' *****'];
    end
    
    % Write to Excel (column E, starting at row 1)
    writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', 'F1');

    %% --- First write X/Y/XTick table (as before) ---
    maxLen = max([length(XData), length(YData), length(XTick)]);
    if length(XData) < maxLen, XData(end+1:maxLen) = NaN; end
    if length(YData) < maxLen, YData(end+1:maxLen) = NaN; end
    if length(XTick) < maxLen, XTick(end+1:maxLen) = {''}; end
    if size(XTick,1)>size(XTick,2)
        XTick = XTick';
    end
    
    T = Utility_Save_xlsx_Set_VariableNames(PlottedData,Analysis,XData,YData,XTick);

    % Write table to Excel
    tableStartRow = length(TextInfos) + 2;  % leave 1 empty row below TextInfos
    writetable(T, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);
    
    %% --- Combine with existing table if CData exists ---
    if ~isempty(CData)
      
        % Add a header
        try
            writematrix(CData, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow+1)]);
        catch
            writematrix(CData', Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow+1)]);
        end
        
        if contains(Analysis,"Potential") && contains(Analysis,"Events") 
            writecell({"***** Time x Trials Matrix *****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
        elseif contains(Analysis,"Potential") && contains(Analysis,"Channel")
            writecell({"***** Time x Channel Matrix *****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
        elseif contains(Analysis,"Time Frequency Power")
            writecell({"***** Time x Frequency Matrix *****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
        else
            if size(PlottedData.CData,1)>size(PlottedData.CData,2)
                writecell({"***** C_Data (Channel x Time)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
            else
                writecell({"***** C_Data (Time x Channel)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
            end
        end
    end
end

% if contains(Analysis,"Phase") && ~contains(Analysis,"Instantaneous")
% 
%     TextInfos{end+1} = ['***** Time Duration of Analyzed Data: ' num2str(PlottedData.TimeDuration) 's *****'];
%     TextInfos{end+1} = ['***** Start Time of Analyzed Data: ' num2str(PlottedData.Time_Points_Plot(1)) 's *****'];
%     TextInfos{end+1} = ['***** Stop Time of Analyzed Data: ' num2str(PlottedData.Time_Points_Plot(2)) 's *****'];
% 
%     TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.TFPowerType) ' *****'];
%     XData = PlottedData.TFPowerXData;
%     YData = PlottedData.TFPowerYData;
%     XTick = PlottedData.TFPowerXTicks;
%     CData = PlottedData.TFPowerCData;
% 
%     %% Write TextInfos to Excel (starting at row 1, column A)
%     writecell(TextInfos', Fullsavefile, 'Sheet', 1, 'Range', 'E1');
% 
%     %% --- First write X/Y/XTick table (as before) ---
%     maxLen = max([length(XData), length(YData), length(XTick)]);
%     if length(XData) < maxLen, XData(end+1:maxLen) = NaN; end
%     if length(YData) < maxLen, YData(end+1:maxLen) = NaN; end
%     if length(XTick) < maxLen, XTick(end+1:maxLen) = {''}; end
%     if size(XTick,1)>size(XTick,2)
%         XTick = XTick';
%     end
% 
%     T = table(XData', YData', XTick', 'VariableNames', {'X_Data','Y_Data','X_Tick'});
% 
%     % Write table to Excel
%     tableStartRow = length(TextInfos) + 2;  % leave 1 empty row below TextInfos
%     writetable(T, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);
% 
%     %% --- Combine with existing table if CData exists ---
%     if ~isempty(CData)
%         % Add a header
%         try
%             writematrix(PlottedData.CData, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow+1)]);
%         catch
%             writematrix(PlottedData.CData', Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow+1)]);
%         end
% 
%         if size(PlottedData.CData,1)>size(PlottedData.CData,2)
%             writecell({"***** C_Data (Channel x Time)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
%         else
%             writecell({"***** C_Data (Time x Channel)*****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);
%         end
% 
%     end
% end


