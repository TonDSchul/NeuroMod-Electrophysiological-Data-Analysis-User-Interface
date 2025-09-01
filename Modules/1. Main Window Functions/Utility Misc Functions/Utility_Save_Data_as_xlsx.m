function Utility_Save_Data_as_xlsx(Fullsavefile,PlottedData,Analysis)

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

Error = 0;
if contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
    if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit") 
        if ~isfield(PlottedData,'MainRateUnitType')
            msgbox("Error: No unit was plotted to export data from.")
            Error = 1;
            return;
        end
    end
    if ~contains(Analysis,"Spike Rate") && contains(Analysis,"Unit") 
        if ~isfield(PlottedData,'MainUnitType')
            msgbox("Error: No unit was plotted to export data from.")
            Error = 1;
            return;
        end
    end
end

%% First For spike analyis (Continous and events); Otherwise unit analysis window
if ~contains(Analysis,"Plot") && ~contains(Analysis,"Event Related") && ~contains(Analysis,"Current") && ~contains(Analysis,"Phase") && ~contains(Analysis,"Instantaneous")
    
    if ~exist(fileparts(Fullsavefile), 'dir')
        mkdir(fileparts(Fullsavefile));
    end

    %% --- Collect TextInfos ---
    TextInfos = {};
    
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
    writecell(TextInfos', Fullsavefile, 'Sheet', 1, 'Range', 'E1');

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
        elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
            XData = PlottedData.MainRateTimeXData;
            YData = PlottedData.MainRateTimeYData;
            XTick = PlottedData.MainRateTimeXTicks;
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            XData = PlottedData.MainUnitXData;
            YData = PlottedData.MainUnitYData;
            XTick = PlottedData.MainUnitXTicks;
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Live")
            XData = PlottedData.MainXData;
            YData = PlottedData.MainYData;
            XTick = PlottedData.MainXTicks;
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
        XTick(end+1:maxLen) = {''};
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

        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            if ~isempty(PlottedData.MainUnitCData)
                CData = PlottedData.MainUnitCData;
            end
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Live") && ~contains(Analysis,"Spike Times") || contains(Analysis,"Heatmap")
            if ~isempty(PlottedData.MainCData)
                CData = PlottedData.MainCData;
            end
        end
    end
    
    %% --- Convert to column if numeric ---
    if ~isempty(CData)
        CData = CData(:);  % convert to column
    end

    %% --- First write X/Y/XTick table (as before) ---
    maxLen = max([length(XData), length(YData), length(XTick)]);
    if length(XData) < maxLen, XData(end+1:maxLen) = NaN; end
    if length(YData) < maxLen, YData(end+1:maxLen) = NaN; end
    if length(XTick) < maxLen, XTick(end+1:maxLen) = {''}; end
    if size(XTick,1)>size(XTick,2)
        XTick = XTick';
    end

    T = table(XData', YData', XTick', 'VariableNames', {'X_Data','Y_Data','X_Tick'});
    
    % Write table to Excel
    tableStartRow = length(TextInfos) + 2;  % leave 1 empty row below TextInfos
    writetable(T, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);

    %% --- Combine with existing table if CData exists ---
    if ~isempty(CData)
        % Add a header
        writecell({"***** C_Data *****"}, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow)]);

        % Write matrix as-is (keeps 2D shape!)
        writematrix(PlottedData.CData, Fullsavefile, 'Sheet', 1, 'Range', ['D' num2str(tableStartRow+1)]);
    end
        
end %If spike analyis (Continous and events); 

%% Inst. Frequency/Phase analysis
if contains(Analysis,"Instantaneous")
    writematrix(strcat("***** Time Duration of Analyzed Data: ",num2str(PlottedData.TimeDuration),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Start Time of Analyzed Data: ",num2str(PlottedData.Time_Points_Plot(1)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Stop Time of Analyzed Data: ",num2str(PlottedData.Time_Points_Plot(2)),"s *****"),Fullsavefile, 'WriteMode', 'append');

    writecell({" "},Fullsavefile, 'WriteMode', 'append');
    
    if contains(Analysis,"Phase Time Series")
        writecell({"***** Phase Time Series Data (Phase Angles Over Time in Radians) *****"},Fullsavefile, 'WriteMode', 'append');
        % Write XData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.PhaseAngleTimesXData)', Fullsavefile, 'WriteMode', 'append');
        % Write YData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.PhaseAngleTimesSyncYData)', Fullsavefile, 'WriteMode', 'append');
        % Write XTicks
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(PlottedData.PhaseAngleTimesSyncXTicks', Fullsavefile, 'WriteMode', 'append');

    elseif contains(Analysis,"Phase Amplitude Envelope")
        writecell({"***** Phase Amplitude Envelope Over Complex Hilbert Transform Result *****"},Fullsavefile, 'WriteMode', 'append');
        % Write XData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.PhaseAmplitudeEnvelopeXData)', Fullsavefile, 'WriteMode', 'append');
        % Write YData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.PhaseAmplitudeEnvelopeYData)', Fullsavefile, 'WriteMode', 'append');
        % Write XTicks
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.PhaseAmplitudeEnvelopeXTicks)', Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"All To All Connectivity")
        writecell({"***** All To All Connectivity Phase Synchronization (Length of Average Phase Difference Vector) *****"},Fullsavefile, 'WriteMode', 'append');
        % Write XData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.AllToAllSyncXData)', Fullsavefile, 'WriteMode', 'append');
        % Write YData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.AllToAllSyncYData)', Fullsavefile, 'WriteMode', 'append');
        % Write CData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** C_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.AllToAllSyncCData, Fullsavefile, 'WriteMode', 'append');
        % Write XTicks
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(PlottedData.AllToAllSyncXTicks', Fullsavefile, 'WriteMode', 'append');

    elseif contains(Analysis,"Polar Phase Angle Differences")
        writecell({"***** Polar Phase Angle Differences (Theta and Radii for Each Data Time Point)*****"},Fullsavefile, 'WriteMode', 'append');
        % Write XData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.PhaseDiffsXData)', Fullsavefile, 'WriteMode', 'append');
        % Write YData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.PhaseDiffsYData)', Fullsavefile, 'WriteMode', 'append');
    end
end

%% unit analysis window
if contains(Analysis,"Plot")

    writematrix(strcat("***** Time Duration of Analyzed Data: ",num2str(PlottedData.TimeDuration),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Start Time of Analyzed Data: ",num2str(PlottedData.Time_Points_Plot(1)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Stop Time of Analyzed Data: ",num2str(PlottedData.Time_Points_Plot(2)),"s *****"),Fullsavefile, 'WriteMode', 'append');

    writecell({" "},Fullsavefile, 'WriteMode', 'append');

    for nrunit = 1:size(PlottedData.UnitAnalyisWaveformsType,2)

        % Write TextInfos
        AnalyisText = convertStringsToChars(Analysis);
        SelectedPlot = str2double(AnalyisText(end-1:end)); 

        if contains(Analysis,"Waveform Analysis")

            writematrix(strcat("***** ",convertStringsToChars(PlottedData.UnitAnalyisWaveformsType{SelectedPlot,nrunit})," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
            % Write XData
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(num2cell(PlottedData.UnitAnalyisWaveformsXData{SelectedPlot,nrunit})', Fullsavefile, 'WriteMode', 'append');
    
            % Write XTicks
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(PlottedData.UnitAnalyisWaveformsXTicks{SelectedPlot,nrunit}', Fullsavefile, 'WriteMode', 'append');
    
            % Write YData
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(num2cell(PlottedData.UnitAnalyisWaveformsYData{SelectedPlot,nrunit})', Fullsavefile, 'WriteMode', 'append');

        elseif contains(Analysis,"ISI Analyis")
            
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.UnitAnalyisISIType{SelectedPlot,nrunit})," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
            % Write XData
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(num2cell(PlottedData.UnitAnalyisISIXData{SelectedPlot,nrunit})', Fullsavefile, 'WriteMode', 'append');
    
            % Write XTicks
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(PlottedData.UnitAnalyisISIXTicks{SelectedPlot,nrunit}', Fullsavefile, 'WriteMode', 'append');
    
            % Write YData
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(num2cell(PlottedData.UnitAnalyisISIYData{SelectedPlot,nrunit})', Fullsavefile, 'WriteMode', 'append');

            % No CData for ISI

        elseif contains(Analysis,"Autocorrelogram Analyis")
            
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.UnitAnalyisAutoType{SelectedPlot,nrunit})," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
            % Write XData
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(num2cell(PlottedData.UnitAnalyisAutoXData{SelectedPlot,nrunit})', Fullsavefile, 'WriteMode', 'append');
    
            % Write XTicks
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(PlottedData.UnitAnalyisAutoXTicks{SelectedPlot,nrunit}', Fullsavefile, 'WriteMode', 'append');
    
            % Write YData
            writecell({" "},Fullsavefile, 'WriteMode', 'append');
            writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
            writecell(num2cell(PlottedData.UnitAnalyisAutoYData{SelectedPlot,nrunit})', Fullsavefile, 'WriteMode', 'append');

            % No CData for Autocorrelogram

        end

        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        % No CData for Unit Analyis window to save
    end
end

%% For LFP Analysis of event related data

if contains(Analysis,"Event Related") || contains(Analysis,"Current")
    
    writematrix(strcat("***** Time Duration of Analyzed Data: ",num2str(PlottedData.TimeDuration),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Start Time of Analyzed Data: ",num2str(PlottedData.Time_Points_Plot(1)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Stop Time of Analyzed Data: ",num2str(PlottedData.Time_Points_Plot(2)),"s *****"),Fullsavefile, 'WriteMode', 'append');

    writecell({" "},Fullsavefile, 'WriteMode', 'append');

    if contains(Analysis,"Potential") && contains(Analysis,"Events")
        writematrix(strcat("***** ",convertStringsToChars(PlottedData.ERPoverEventsType)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
        % Write XData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.ERPoverEventsXData)', Fullsavefile, 'WriteMode', 'append');

        % Write XTicks
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(PlottedData.ERPoverEventsXTicks', Fullsavefile, 'WriteMode', 'append');

        % Write YData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.ERPoverEventsYData)', Fullsavefile, 'WriteMode', 'append');

        % No CData for ERP

    elseif contains(Analysis,"Potential") && contains(Analysis,"Channel")
        writematrix(strcat("***** ",convertStringsToChars(PlottedData.ERPoverChannelType)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
        % Write XData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.ERPoverChannelXData)', Fullsavefile, 'WriteMode', 'append');

        % Write XTicks
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(PlottedData.ERPoverChannelXTicks', Fullsavefile, 'WriteMode', 'append');

        % Write YData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.ERPoverChannelYData)', Fullsavefile, 'WriteMode', 'append');

        % No CData for ERP

    elseif contains(Analysis,"Current")
        writematrix(strcat("***** ",convertStringsToChars(PlottedData.CSDType)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
        % Write XData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.CSDXData)', Fullsavefile, 'WriteMode', 'append');

        % Write XTicks
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(PlottedData.CSDXTicks', Fullsavefile, 'WriteMode', 'append');

        % Write YData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writecell(num2cell(PlottedData.CSDYData)', Fullsavefile, 'WriteMode', 'append');

        % Write CData
        writecell({" "},Fullsavefile, 'WriteMode', 'append');
        writecell({"***** C_Data *****"},Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.CSDCData, Fullsavefile, 'WriteMode', 'append');

    end

end

%% Time Freuwncy Power

if contains(Analysis,"Phase") && ~contains(Analysis,"Instantaneous")
    writematrix(strcat("***** Time Duration of Analyzed Data: ",num2str(PlottedData.TimeDuration),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Start Time of Analyzed Data: ",num2str(PlottedData.Time_Points_Plot(1)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Stop Time of Analyzed Data: ",num2str(PlottedData.Time_Points_Plot(2)),"s *****"),Fullsavefile, 'WriteMode', 'append');

    writecell({" "},Fullsavefile, 'WriteMode', 'append');

    writematrix(strcat("***** ",convertStringsToChars(PlottedData.TFPowerType)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
    % Write XData
    writecell({" "},Fullsavefile, 'WriteMode', 'append');
    writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');
    writecell(num2cell(PlottedData.TFPowerXData)', Fullsavefile, 'WriteMode', 'append');

    % Write XTicks
    writecell({" "},Fullsavefile, 'WriteMode', 'append');
    writecell({"***** X_Ticks *****"},Fullsavefile, 'WriteMode', 'append');
    writecell(num2cell(PlottedData.TFPowerXTicks)', Fullsavefile, 'WriteMode', 'append');

    % Write YData
    writecell({" "},Fullsavefile, 'WriteMode', 'append');
    writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');
    writecell(num2cell(PlottedData.TFPowerYData)', Fullsavefile, 'WriteMode', 'append');

    % Write CData
    writecell({" "},Fullsavefile, 'WriteMode', 'append');
    writecell({"***** C_Data *****"},Fullsavefile, 'WriteMode', 'append');
    writematrix(PlottedData.TFPowerCData, Fullsavefile, 'WriteMode', 'append');

end