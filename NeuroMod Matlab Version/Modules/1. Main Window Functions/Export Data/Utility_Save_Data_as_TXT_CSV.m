function Error = Utility_Save_Data_as_TXT_CSV(Fullsavefile,PlottedData,Analysis)

%________________________________________________________________________________________
%% Function to export plotted/Analyzed data as .txt file
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

%% Check if basic requirements for currently seelcted export are fullfilled --> i.e. when untis selected that units were plotted before
Error = Utility_Check_Saved_Spike_PlotData(PlottedData,Analysis);

if Error == 1
    return
end

if ~exist(fileparts(Fullsavefile), 'dir')
    mkdir(fileparts(Fullsavefile));
end

fid = fopen(Fullsavefile,'w');  % open file for writing

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
    TextInfos{end+1} = '';
    TextInfos{end+1} = '****************************************************************************************************';
    TextInfos{end+1} = '';
    for i = 1:length(TextInfos)
        fprintf(fid, '%s\n', TextInfos{i});
    end

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
        if size(valStr,1)==1 || size(valStr,2)==1
            TextInfos{end+1,1} = ['***** Meta Data: ' fn{k} ' = ' valStr ' *****'];
        end
    end
    
    TextInfos{end+1} = '';
    TextInfos{end+1} = '****************************************************************************************************';
    TextInfos{end+1} = '';
    for i = 1:length(TextInfos)
        fprintf(fid, '%s\n', TextInfos{i});
    end

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
    
    %% --- Combine with existing table if CData exists ---
    if ~isempty(CData)
      
        if contains(Analysis,"Waveforms") && ~contains(Analysis,"Average")
            fprintf(fid, '\n***** Waveform Data (Waveforms x Time) (each new line is a new row, column entries for a row are comma separated!) *****\n');
        elseif contains(Analysis,"Heatmap")
            fprintf(fid, '\n***** Heatmap data (Time x Channel) (each new line is a new row, column entries for a row are comma separated!) *****\n');
        elseif contains(Analysis,"Spike Triggered LFP")
            fprintf(fid, '\n***** Spike Triggered LFP (Depth x Time) (each new line is a new row, column entries for a row are comma separated!) *****\n');
        elseif contains(Analysis,"Waveforms") && contains(Analysis,"Average")
            fprintf(fid, '\n***** Average Waveform Over Depth Data (Depth x Waveform) (each new line is a new row, column entries for a row are comma separated!) *****\n');
        elseif contains(Analysis,"Amplitude Density Along Depth")
            fprintf(fid, '\n***** Amplitude Density Spike Rate (Depth x Amplitude) (each new line is a new row, column entries for a row are comma separated!) *****\n');
        else
            if size(PlottedData.CData,1)>size(PlottedData.CData,2)
                fprintf(fid, '\n***** C_Data (Channel x Time) (each new line is a new row, column entries for a row are comma separated!) *****\n');
            else
                fprintf(fid, '\n***** C_Data (Time x Channel) (each new line is a new row, column entries for a row are comma separated!) *****\n');
            end
        end

        % Write each row of the matrix
        for i = 1:size(CData,1)
            fprintf(fid, '%g', CData(i,1));             % write first column
            for j = 2:size(CData,2)
                fprintf(fid, ',%g', CData(i,j));       % write remaining columns with comma
            end
            fprintf(fid, '\n');                         % end of row
        end
    end
    
    % Write table to Excel
    fprintf(fid, '\n');
    fprintf(fid, '****************************************************************************************************');
    fprintf(fid, '\n');
    fprintf(fid, strcat(T.Properties.VariableNames{1},',',T.Properties.VariableNames{2},',',T.Properties.VariableNames{3},'\n'));
    writetable(T, Fullsavefile, 'Delimiter', ',', 'WriteMode', 'append');
        
end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% If spike analyis (Continous and events); 

TextInfosStart = {};
%% -------------------- Unit Analysis -------------------- 
if contains(Analysis,"Plot") && ~contains(Analysis,"Spectrogram")
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
            
            TextInfos{end+1} = '';
            TextInfos{end+1} = '****************************************************************************************************';
            TextInfos{end+1} = '';
            for i = 1:length(TextInfos)
                fprintf(fid, '%s\n', TextInfos{i});
            end
        end
        
        if nrunit == 1
            %% Write TextInfos to Excel (starting at row 1, column A)
            TextInfosStart{end+1} = '';
            TextInfosStart{end+1} = '****************************************************************************************************';
            TextInfosStart{end+1} = '';
            for i = 1:length(TextInfosStart)
                fprintf(fid, '%s\n', TextInfosStart{i});
            end
        else
            
            %% Write TextInfos to Excel (starting at row 1, column A)
            TextInfosStart{end+1} = '';
            TextInfosStart{end+1} = '****************************************************************************************************';
            TextInfosStart{end+1} = '';
            
            if ~contains(Analysis,"Waveform Analysis")
                TextInfosStart = TextInfosStart(end-6:end);
            end

            for i = 1:length(TextInfosStart)
                fprintf(fid, '%s\n', TextInfosStart{i});
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
        
        %% --- Combine with existing table if CData exists ---
        if ~isempty(CData)

            % Add a header
            if contains(Analysis,"Waveform Analysis")
                fprintf(fid, '\n***** Time x Waveforms (each new line is a new row, column entries for a row are comma separated!) *****\n');
            else
                fprintf(fid, '\n***** C_Data (each new line is a new row, column entries for a row are comma separated!) *****\n');
            end
        
            % Write each row of the matrix
            for i = 1:size(CData,1)
                fprintf(fid, '%g', CData(i,1));             % write first column
                for j = 2:size(CData,2)
                    fprintf(fid, ',%g', CData(i,j));       % write remaining columns with comma
                end
                fprintf(fid, '\n');                         % end of row
            end
        end

        % Write table to Excel
        if contains(Analysis,"Waveform Analysis")
            fprintf(fid, '\n');
            fprintf(fid, '****************************************************************************************************');
            fprintf(fid, '\n');
            fprintf(fid, strcat(T.Properties.VariableNames{1},',',T.Properties.VariableNames{2},',',T.Properties.VariableNames{3},'\n'));
        end

        if ~contains(Analysis,"Waveform Analysis")
            % --- Write header
            fprintf(fid, '%s , %s\n', T.Properties.VariableNames{2},T.Properties.VariableNames{3});
            
            % --- Write numeric data (no exponential, 6 decimals)
            for i = 1:height(T)
                fprintf(fid, '%.6f , %.6f\n', T{i,2},T{i,3});
            end
        else
            writetable(T, Fullsavefile, 'Delimiter', ',', 'WriteMode', 'append');
        end

    end
    
end

%% Live Spectrogram window
if contains(Analysis,"Plot") && contains(Analysis,"Spectrogram")
    XData  = PlottedData.LiveSpectroXData;
    YData  = PlottedData.LiveSpectroYData;
    XTick  = PlottedData.LiveSpectroXTicks;
    CData = PlottedData.LiveSpectroCData;  
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
    
    TextInfos{end+1} = '';
    TextInfos{end+1} = '****************************************************************************************************';
    TextInfos{end+1} = '';
    for i = 1:length(TextInfos)
        fprintf(fid, '%s\n', TextInfos{i});
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

    %% --- First write X/Y/XTick table (as before) ---
    maxLen = max([length(XData), length(YData), length(XTick)]);
    if length(XData) < maxLen, XData(end+1:maxLen) = NaN; end
    if length(YData) < maxLen, YData(end+1:maxLen) = NaN; end
    if length(XTick) < maxLen, XTick(end+1:maxLen) = {''}; end
    if size(XTick,1)>size(XTick,2)
        XTick = XTick';
    end
    
    T = Utility_Save_xlsx_Set_VariableNames(PlottedData,Analysis,XData,YData,XTick);

    %% --- Combine with existing table if CData exists ---
    if ~isempty(CData)
     
        fprintf(fid, '\n***** C_Data (Frequency (Hz) x Time (s)) (each new line is a new row, column entries for a row are comma separated!) *****\n');

        % Write each row of the matrix
        for i = 1:size(CData,1)
            fprintf(fid, '%g', CData(i,1));             % write first column
            for j = 2:size(CData,2)
                fprintf(fid, ',%g', CData(i,j));       % write remaining columns with comma
            end
            fprintf(fid, '\n');                         % end of row
        end
    end

    % Write table to Excel
    fprintf(fid, '\n');
    fprintf(fid, '****************************************************************************************************');
    fprintf(fid, '\n');
    fprintf(fid, strcat(T.Properties.VariableNames{1},',',T.Properties.VariableNames{2},',',T.Properties.VariableNames{3},'\n'));
    writetable(T, Fullsavefile, 'Delimiter', ',', 'WriteMode', 'append');
    
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
        YData = [];
        XTick = PlottedData.ERPoverEventsXTicks;
        CData = PlottedData.ERPoverEventsYData';
        % No CData
    elseif contains(Analysis,"Grid") && ~contains(Analysis,"Spectrum")
        TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.ERPGridType) ' *****'];
        XData = PlottedData.ERPGridXData;
        YData = [];
        XTick = PlottedData.ERPGridXTicks;
        CData = PlottedData.ERPGridYData';
    elseif contains(Analysis,"Grid") && contains(Analysis,"Spectrum")
        TextInfos{end+1} = ['***** ' convertStringsToChars(PlottedData.SpectrumGridType) ' *****'];
        XData = PlottedData.SpectrumGridXData;
        YData = [];
        XTick = PlottedData.SpectrumGridXTicks;
        CData = PlottedData.SpectrumGridYData';
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
    TextInfos{end+1} = '';
    TextInfos{end+1} = '****************************************************************************************************';
    TextInfos{end+1} = '';
    for i = 1:length(TextInfos)
        fprintf(fid, '%s\n', TextInfos{i});
    end
    
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
        if any(size(valStr,1:2) == 1) && all(size(valStr,1:2) < 1000)
            TextInfos{end+1,1} = ['***** Meta Data: ' fn{k} ' = ' valStr ' *****'];
        end
    end
    
    TextInfos{end+1} = '';
    TextInfos{end+1} = '****************************************************************************************************';
    TextInfos{end+1} = '';
    for i = 1:length(TextInfos)
        fprintf(fid, '%s\n', TextInfos{i});
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

    %% --- Combine with existing table if CData exists ---
    if ~isempty(CData)
        
        if contains(Analysis,"Potential") && contains(Analysis,"Events") 
            fprintf(fid, '\n***** Time x Trials Matrix (each new line is a new row, column entries for a row are comma separated!) *****\n');
        elseif contains(Analysis,"Potential") && contains(Analysis,"Channel")
            fprintf(fid, '\n***** Time x Channel Matrix (each new line is a new row, column entries for a row are comma separated!) *****\n');
        elseif contains(Analysis,"Time Frequency Power")
            fprintf(fid, '\n***** Time x Frequency Matrix (each new line is a new row, column entries for a row are comma separated!) *****\n');
        else
            if contains(Analysis,"Grid")
                fprintf(fid, '\n*****  Grid Data Matrix. Each excel sheet row is a probe column and contains data of all probe rows. In the Grid Plot, rows are demarcated using plotted lines after as many samples as one ERP takes (see event related time and sample frequency). *****\n');
            else
                if size(PlottedData.CData,1)>size(PlottedData.CData,2)
                    fprintf(fid, '\n***** C_Data Matrix (Channel x Time) (each new line is a new row, column entries for a row are comma separated!) *****\n');
                else
                    fprintf(fid, '\n***** C_Data Matrix (Time x Channel) (each new line is a new row, column entries for a row are comma separated!) *****\n');
                end
            end
        end
        
        % Write each row of the matrix
        for i = 1:size(CData,1)
            fprintf(fid, '%g', CData(i,1));             % write first column
            for j = 2:size(CData,2)
                fprintf(fid, ',%g', CData(i,j));       % write remaining columns with comma
            end
            fprintf(fid, '\n');                         % end of row
        end
    end
    
    % Write table to Excel
    fprintf(fid, '\n');
    fprintf(fid, '****************************************************************************************************');
    fprintf(fid, '\n');
    fprintf(fid, strcat(T.Properties.VariableNames{1},',',T.Properties.VariableNames{2},',',T.Properties.VariableNames{3},'\n'));
    writetable(T, Fullsavefile, 'Delimiter', ',', 'WriteMode', 'append');

end


fclose(fid);
