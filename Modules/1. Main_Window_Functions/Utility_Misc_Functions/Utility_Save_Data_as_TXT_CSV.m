function Error = Utility_Save_Data_as_TXT_CSV(Fullsavefile,PlottedData,Analysis)

% Saves infos for spike related things and other things seperately. Spike
% things are further diffeerntiated in unit spikes and all spikes for spike rate plots and for the main plot. This
% ensures, that all lastly plotted data can be exported

% Limitation: Continous spike window and event spike window open at the
% same time. If you plot something in the event window and export data in
% the continous window, data from the event windiw is saved. Didnt want to
% put another layer of complexity and amount of variables in yet.

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

%% Write Info File
writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');

writematrix(strcat("***** Recording Infos *****"),Fullsavefile, 'WriteMode', 'append');

writestruct(PlottedData.Info, Fullsavefile, FileType="json");

writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');

%% First For spike analyis (Continous and events); Otherwise unit analysis window
if ~contains(Analysis,"Plot") && ~contains(Analysis,"Event Related") && ~contains(Analysis,"Current") && ~contains(Analysis,"Phase")

    %% Write TextInfos
    if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data  
        writematrix(strcat("***** ",convertStringsToChars(PlottedData.Type)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
    elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
        if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit") 
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.MainRateUnitType)," *****"),Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && contains(Analysis,"Channel")
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.MainRateChannelType)," *****"),Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.MainRateTimeType)," *****"),Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.MainUnitType)," *****"),Fullsavefile, 'WriteMode', 'append');
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.MainType)," *****"),Fullsavefile, 'WriteMode', 'append');
        end
    end
    
    writematrix(strcat("***** Time Duration of Analysed Data: ",num2str(PlottedData.TimeDuration),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Start Time of Analysed Data: ",num2str(PlottedData.Time_Points_Plot(1)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Stop Time of Analysed Data: ",num2str(PlottedData.Time_Points_Plot(2)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    %% Write XData
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** X_Data *****"),Fullsavefile, 'WriteMode', 'append');
    
    if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
        writematrix(PlottedData.XData, Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
        if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
            writematrix(PlottedData.MainRateUnitXData, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && contains(Analysis,"Channel")
            writematrix(PlottedData.MainRateChannelXData, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
            writematrix(PlottedData.MainRateTimeXData, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            writematrix(PlottedData.MainUnitXData, Fullsavefile, 'WriteMode', 'append');
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            writematrix(PlottedData.MainXData, Fullsavefile, 'WriteMode', 'append');
        end
    end
    
    %% Write XTicks
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** X_Tick Labels *****"),Fullsavefile, 'WriteMode', 'append');
    
    if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
        writecell(PlottedData.XTicks, Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
        if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
            writecell(PlottedData.MainRateUnitXTicks, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && contains(Analysis,"Channel")
            writecell(PlottedData.MainRateChannelXTicks, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
            writecell(PlottedData.MainRateTimeXTicks, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            writecell(PlottedData.MainUnitXTicks, Fullsavefile, 'WriteMode', 'append');
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            writecell(PlottedData.MainXTicks, Fullsavefile, 'WriteMode', 'append');
        end
    end
    
    %% Write YData
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Y_Data *****"),Fullsavefile, 'WriteMode', 'append');
    
    if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
        writematrix(PlottedData.YData, Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
        if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
            writematrix(PlottedData.MainRateUnitYData, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && contains(Analysis,"Channel")
            writematrix(PlottedData.MainRateChannelYData, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
            writematrix(PlottedData.MainRateTimeYData, Fullsavefile, 'WriteMode', 'append');
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            writematrix(PlottedData.MainUnitYData, Fullsavefile, 'WriteMode', 'append');
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            writematrix(PlottedData.MainYData, Fullsavefile, 'WriteMode', 'append');
        end
    end
    
    %% Write CData if available (Z data is not saved since its the same as C data when 3d plot is selected)
    
    if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
        if ~isempty(PlottedData.CData)
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** C_Data *****"),Fullsavefile, 'WriteMode', 'append');
            writematrix(PlottedData.CData, Fullsavefile, 'WriteMode', 'append');
        end
    elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
        if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit") %% No Cdata for spike rate
            % if ~isempty(PlottedData.CData)
            %     writematrix(PlottedData.CData, Fullsavefile, 'WriteMode', 'append');
            % end
        elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") %% No Cdata for spike rate
            % if ~isempty(PlottedData.CData)
            %     writematrix(PlottedData.CData, Fullsavefile, 'WriteMode', 'append');
            % end
        elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            if ~isempty(PlottedData.MainUnitCData)
                writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
                writematrix(strcat("***** C_Data *****"),Fullsavefile, 'WriteMode', 'append');
                writematrix(PlottedData.MainUnitCData, Fullsavefile, 'WriteMode', 'append');
            end
        elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
            if ~isempty(PlottedData.MainCData)
                writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
                writematrix(strcat("***** C_Data *****"),Fullsavefile, 'WriteMode', 'append');
                writematrix(PlottedData.MainCData, Fullsavefile, 'WriteMode', 'append');
            end
        end
    end

end %If spike analyis (Continous and events); 

%% unit analysis window
if contains(Analysis,"Plot")

    writematrix(strcat("***** Time Duration of Analysed Data: ",num2str(PlottedData.TimeDuration),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Start Time of Analysed Data: ",num2str(PlottedData.Time_Points_Plot(1)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Stop Time of Analysed Data: ",num2str(PlottedData.Time_Points_Plot(2)),"s *****"),Fullsavefile, 'WriteMode', 'append');

    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');

    for nrunit = 1:size(PlottedData.UnitAnalyisWaveformsType,2)

        % Write TextInfos
        AnalyisText = convertStringsToChars(Analysis);
        SelectedPlot = str2double(AnalyisText(end-1:end)); 

        if contains(Analysis,"Waveform Analysis")

            writematrix(strcat("***** ",convertStringsToChars(PlottedData.UnitAnalyisWaveformsType{SelectedPlot,nrunit})," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
            % Write XData
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** X_Data *****"),Fullsavefile, 'WriteMode', 'append');
            writematrix(PlottedData.UnitAnalyisWaveformsXData{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');
    
            % Write XTicks
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** X_Ticks *****"),Fullsavefile, 'WriteMode', 'append');
            writecell(PlottedData.UnitAnalyisWaveformsXTicks{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');
    
            % Write YData
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** Y_Data *****"),Fullsavefile, 'WriteMode', 'append');
            writematrix(PlottedData.UnitAnalyisWaveformsYData{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');

        elseif contains(Analysis,"ISI Analyis")
            
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.UnitAnalyisISIType{SelectedPlot,nrunit})," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
            % Write XData
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** X_Data *****"),Fullsavefile, 'WriteMode', 'append');
            writematrix(PlottedData.UnitAnalyisISIXData{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');
    
            % Write XTicks
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** X_Ticks *****"),Fullsavefile, 'WriteMode', 'append');
            writecell(PlottedData.UnitAnalyisISIXTicks{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');
    
            % Write YData
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** Y_Data *****"),Fullsavefile, 'WriteMode', 'append');
            writematrix(PlottedData.UnitAnalyisISIYData{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');

            % No CData for ISI

        elseif contains(Analysis,"Autocorrelogram Analyis")
            
            writematrix(strcat("***** ",convertStringsToChars(PlottedData.UnitAnalyisAutoType{SelectedPlot,nrunit})," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
            % Write XData
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** X_Data *****"),Fullsavefile, 'WriteMode', 'append');
            writematrix(PlottedData.UnitAnalyisAutoXData{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');
    
            % Write XTicks
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** X_Ticks *****"),Fullsavefile, 'WriteMode', 'append');
            writecell(PlottedData.UnitAnalyisAutoXTicks{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');
    
            % Write YData
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("***** Y_Data *****"),Fullsavefile, 'WriteMode', 'append');
            writematrix(PlottedData.UnitAnalyisAutoYData{SelectedPlot,nrunit}, Fullsavefile, 'WriteMode', 'append');

            % No CData for Autocorrelogram

        end

        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        % No CData for Unit Analyis window to save
    end
end

%% For LFP Analysis of event related data

if contains(Analysis,"Event Related") || contains(Analysis,"Current")
    
    writematrix(strcat("***** Time Duration of Analysed Data: ",num2str(PlottedData.TimeDuration),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Start Time of Analysed Data: ",num2str(PlottedData.Time_Points_Plot(1)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Stop Time of Analysed Data: ",num2str(PlottedData.Time_Points_Plot(2)),"s *****"),Fullsavefile, 'WriteMode', 'append');

    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');

    if contains(Analysis,"Potential") && contains(Analysis,"Events")
        writematrix(strcat("***** ",convertStringsToChars(PlottedData.ERPoverEventsType)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
        % Write XData
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** X_Data *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.ERPoverEventsXData, Fullsavefile, 'WriteMode', 'append');

        % Write XTicks
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** X_Ticks *****"),Fullsavefile, 'WriteMode', 'append');
        writecell(PlottedData.ERPoverEventsXTicks, Fullsavefile, 'WriteMode', 'append');

        % Write YData
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** Y_Data *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.ERPoverEventsYData, Fullsavefile, 'WriteMode', 'append');

        % No CData for ERP

    elseif contains(Analysis,"Potential") && contains(Analysis,"Channel")
        writematrix(strcat("***** ",convertStringsToChars(PlottedData.ERPoverChannelType)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
        % Write XData
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** X_Data *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.ERPoverChannelXData, Fullsavefile, 'WriteMode', 'append');

        % Write XTicks
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** X_Ticks *****"),Fullsavefile, 'WriteMode', 'append');
        writecell(PlottedData.ERPoverChannelXTicks, Fullsavefile, 'WriteMode', 'append');

        % Write YData
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** Y_Data *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.ERPoverChannelYData, Fullsavefile, 'WriteMode', 'append');

        % No CData for ERP

    elseif contains(Analysis,"Current")
        writematrix(strcat("***** ",convertStringsToChars(PlottedData.CSDType)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
        % Write XData
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** X_Data *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.CSDXData, Fullsavefile, 'WriteMode', 'append');

        % Write XTicks
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** X_Ticks *****"),Fullsavefile, 'WriteMode', 'append');
        writecell(PlottedData.CSDXTicks, Fullsavefile, 'WriteMode', 'append');

        % Write YData
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** Y_Data *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.CSDYData, Fullsavefile, 'WriteMode', 'append');

        % Write CData
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** C_Data *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(PlottedData.CSDCData, Fullsavefile, 'WriteMode', 'append');

    end

end

%% Time Freuwncy Power

if contains(Analysis,"Phase")
    writematrix(strcat("***** Time Duration of Analysed Data: ",num2str(PlottedData.TimeDuration),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Start Time of Analysed Data: ",num2str(PlottedData.Time_Points_Plot(1)),"s *****"),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Stop Time of Analysed Data: ",num2str(PlottedData.Time_Points_Plot(2)),"s *****"),Fullsavefile, 'WriteMode', 'append');

    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');

    writematrix(strcat("***** ",convertStringsToChars(PlottedData.TFPowerType)," *****"),Fullsavefile, 'WriteMode', 'append'); % Main Window stuff, i.e. static spectrum, spike rate, power estimate and csd for main window plot
            
    % Write XData
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    writematrix(strcat("***** X_Data *****"),Fullsavefile, 'WriteMode', 'append');
    writematrix(PlottedData.TFPowerXData, Fullsavefile, 'WriteMode', 'append');

    % Write XTicks
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    writematrix(strcat("***** X_Ticks *****"),Fullsavefile, 'WriteMode', 'append');
    writecell(PlottedData.TFPowerXTicks, Fullsavefile, 'WriteMode', 'append');

    % Write YData
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    writematrix(strcat("***** Y_Data *****"),Fullsavefile, 'WriteMode', 'append');
    writematrix(PlottedData.TFPowerYData, Fullsavefile, 'WriteMode', 'append');

    % Write CData
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    writematrix(strcat("***** C_Data *****"),Fullsavefile, 'WriteMode', 'append');
    writematrix(PlottedData.TFPowerCData, Fullsavefile, 'WriteMode', 'append');

end