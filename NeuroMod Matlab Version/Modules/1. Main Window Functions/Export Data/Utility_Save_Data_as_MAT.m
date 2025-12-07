function Error = Utility_Save_Data_as_MAT(Fullsavefile,PlottedData,Analysis)

%________________________________________________________________________________________
%% Function to export plotted/analysed data as .mat files
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

DataToSave = [];

%% First For spike analyis (Continous and events); Otherwise unit analysis window
if ~contains(Analysis,"Plot") && ~contains(Analysis,"Event Related") && ~contains(Analysis,"Current") && ~contains(Analysis,"Phase")

%% Write TextInfos
if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
    DataToSave.Type =  PlottedData.Type;
    DataToSave.XData =  PlottedData.XData;
    DataToSave.YData =  PlottedData.YData;
    if isfield(PlottedData,'CData')
        if ~isempty(PlottedData.CData)
            DataToSave.CData =  PlottedData.CData;
        end
    end
    DataToSave.XTicks =  PlottedData.XTicks;
elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
    if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit") 
        DataToSave.MainRateUnitType =  PlottedData.MainRateUnitType;
        DataToSave.MainRateUnitXData =  PlottedData.MainRateUnitXData;
        DataToSave.MainRateUnitYData =  PlottedData.MainRateUnitYData;
        if isfield(DataToSave,'MainRateUnitCData')
            if ~isempty(PlottedData.MainRateUnitCData)
                DataToSave.MainRateUnitCData =  PlottedData.MainRateUnitCData;
            end
        end
        DataToSave.MainRateUnitXTicks =  PlottedData.MainRateUnitXTicks;

    elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && contains(Analysis,"Channel")
        DataToSave.MainRateChannelType =  PlottedData.MainRateChannelType;
        DataToSave.MainRateChannelXData =  PlottedData.MainRateChannelXData;
        DataToSave.MainRateChannelYData =  PlottedData.MainRateChannelYData;
        if isfield(DataToSave,'MainRateChannelCData')
            if ~isempty(PlottedData.MainRateChannelCData)
                DataToSave.MainRateChannelCData =  PlottedData.MainRateChannelCData;
            end
        end
        DataToSave.MainRateChannelXTicks =  PlottedData.MainRateChannelXTicks;

    elseif contains(Analysis,"Spike Rate") && ~contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
        DataToSave.MainRateTimeType =  PlottedData.MainRateTimeType;
        DataToSave.MainRateTimeXData =  PlottedData.MainRateTimeXData;
        DataToSave.MainRateTimeYData =  PlottedData.MainRateTimeYData;
        if isfield(DataToSave,'MainRateTimeCData')
            if ~isempty(PlottedData.MainRateTimeCData)
                DataToSave.MainRateTimeCData =  PlottedData.MainRateTimeCData;
            end
        end
        DataToSave.MainRateTimeXTicks =  PlottedData.MainRateTimeXTicks;

    elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
        DataToSave.MainUnitType =  PlottedData.MainUnitType;
        DataToSave.MainUnitXData =  PlottedData.MainUnitXData;
        DataToSave.MainUnitYData =  PlottedData.MainUnitYData;
        if isfield(DataToSave,'MainUnitCData')
            if ~isempty(PlottedData.MainUnitCData)
                DataToSave.MainUnitCData =  PlottedData.MainUnitCData;
            end
        end
        DataToSave.MainUnitXTicks =  PlottedData.MainUnitXTicks;
    elseif contains(Analysis,"Spike") && contains(Analysis,"Live")
        DataToSave.MainType =  PlottedData.LiveSpikeType;
        DataToSave.MainXData =  PlottedData.LiveSpikeXData;
        DataToSave.MainYData =  PlottedData.LiveSpikeYData;
        DataToSave.MainXTicks =  PlottedData.LiveSpikeXTicks;
    elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
        DataToSave.MainType =  PlottedData.MainType;
        DataToSave.MainXData =  PlottedData.MainXData;
        DataToSave.MainYData =  PlottedData.MainYData;
        if isfield(DataToSave,'MainCData')
            if ~isempty(PlottedData.MainCData)
                DataToSave.MainCData =  PlottedData.MainCData;
            end
        end
        DataToSave.MainXTicks =  PlottedData.MainXTicks;
    end
end

end

if contains(Analysis,"Instantaneous")
    if contains(Analysis,"Phase Time Series")
        DataToSave.PhaseAngleTimesSyncType =  PlottedData.PhaseAngleTimesSyncType;
        DataToSave.PhaseAngleTimesSyncXData =  PlottedData.PhaseAngleTimesXData;
        DataToSave.PhaseAngleTimesSyncYData =  PlottedData.PhaseAngleTimesSyncYData;
        if isfield(DataToSave,'PhaseAngleTimesSyncCData')
            if ~isempty(PlottedData.PhaseAngleTimesSyncCData)
                DataToSave.PhaseAngleTimesSyncCData =  PlottedData.PhaseAngleTimesSyncCData;
            end
        end
    elseif contains(Analysis,"Phase Amplitude Envelope")
        DataToSave.PhaseAmplitudeEnvelopeType =  PlottedData.PhaseAmplitudeEnvelopeType;
        DataToSave.PhaseAmplitudeEnvelopeXData =  PlottedData.PhaseAmplitudeEnvelopeXData;
        DataToSave.PhaseAmplitudeEnvelopeYData =  PlottedData.PhaseAmplitudeEnvelopeYData;
        if isfield(DataToSave,'PhaseAmplitudeEnvelopeCData')
            if ~isempty(PlottedData.PhaseAmplitudeEnvelopeCData)
                DataToSave.PhaseAmplitudeEnvelopeCData =  PlottedData.PhaseAmplitudeEnvelopeCData;
            end
        end
    elseif contains(Analysis,"All To All Connectivity")
        DataToSave.AllToAllSyncType =  PlottedData.AllToAllSyncType;
        DataToSave.AllToAllSyncXData =  PlottedData.AllToAllSyncXData;
        DataToSave.AllToAllSyncYData =  PlottedData.AllToAllSyncYData;
        DataToSave.AllToAllSyncCData =  PlottedData.AllToAllSyncCData;
            
        
    elseif contains(Analysis,"Polar Phase Angle Differences")
        DataToSave.PhaseDiffsType =  PlottedData.PhaseDiffsType;
        DataToSave.PhaseDiffsXData =  PlottedData.PhaseDiffsXData;
        DataToSave.PhaseDiffsYData =  PlottedData.PhaseDiffsYData;
        if isfield(DataToSave,'MainCData')
            if ~isempty(PlottedData.PhaseDiffsCData)
                DataToSave.PhaseDiffsCData =  PlottedData.PhaseDiffsCData;
            end
        end
    end
end

if contains(Analysis,"Plot")

    % Write TextInfos
        AnalyisText = convertStringsToChars(Analysis);
        SelectedPlot = str2double(AnalyisText(end-1:end)); 

        if contains(Analysis,"Waveform Analysis")
            
            DataToSave.UnitAnalyisWaveformsType =  PlottedData.UnitAnalyisWaveformsType;
            DataToSave.UnitAnalyisWaveformsXData =  PlottedData.UnitAnalyisWaveformsXData;
            DataToSave.UnitAnalyisWaveformsYData =  PlottedData.UnitAnalyisWaveformsYData;
            %No CData
            DataToSave.UnitAnalyisWaveformsXTicks =  PlottedData.UnitAnalyisWaveformsXTicks;
            DataToSave.DimensionsOfCells = ["Nr Plots (1 to 3)","Nr Units per Plot"];

        elseif contains(Analysis,"ISI Analysis")
            
            DataToSave.UnitAnalyisISIType =  PlottedData.UnitAnalyisISIType;
            DataToSave.UnitAnalyisISIXData =  PlottedData.UnitAnalyisISIXData;
            DataToSave.UnitAnalyisISIYData =  PlottedData.UnitAnalyisISIYData;
            %No CData
            DataToSave.UnitAnalyisISIXTicks =  PlottedData.UnitAnalyisISIXTicks;
            DataToSave.DimensionsOfCells = ["Nr Plots (1 to 3)","Nr Units per Plot"];

        elseif contains(Analysis,"Autocorrelogram Analysis")
            
            DataToSave.UnitAnalyisAutoType =  PlottedData.UnitAnalyisAutoType;
            DataToSave.UnitAnalyisAutoXData =  PlottedData.UnitAnalyisAutoXData;
            DataToSave.UnitAnalyisAutoYData =  PlottedData.UnitAnalyisAutoYData;
            %No CData
            DataToSave.UnitAnalyisAutoXTicks =  PlottedData.UnitAnalyisAutoXTicks;
            DataToSave.DimensionsOfCells = ["Nr Plots (1 to 3)","Nr Units per Plot"];

        end

end

if contains(Analysis,"Event Related") || contains(Analysis,"Current")

    if contains(Analysis,"Potential") && contains(Analysis,"Events")
        DataToSave.ERPoverEventsType =  PlottedData.ERPoverEventsType;
        DataToSave.ERPoverEventsXData =  PlottedData.ERPoverEventsXData;
        DataToSave.ERPoverEventsYData =  PlottedData.ERPoverEventsYData;
        %No CData
        DataToSave.ERPoverEventsXTicks =  PlottedData.ERPoverEventsXTicks;
    
    elseif contains(Analysis,"Potential") && contains(Analysis,"Channel")
        DataToSave.ERPoverChannelType =  PlottedData.ERPoverChannelType;
        DataToSave.ERPoverChannelXData =  PlottedData.ERPoverChannelXData;
        DataToSave.ERPoverChannelYData =  PlottedData.ERPoverChannelYData;
        %No CData
        DataToSave.ERPoverChannelXTicks =  PlottedData.ERPoverChannelXTicks;

    elseif contains(Analysis,"Current")
        DataToSave.CSDType =  PlottedData.CSDType;
        DataToSave.CSDXData =  PlottedData.CSDXData;
        DataToSave.CSDYData =  PlottedData.CSDYData;
        DataToSave.CSDCData =  PlottedData.CSDCData;
        DataToSave.CSDXTicks =  PlottedData.CSDXTicks;
    end

end

if contains(Analysis,"Phase") && ~ contains(Analysis,"Instantaneous")
    DataToSave.TFPowerType =  PlottedData.TFPowerType;
    DataToSave.TFPowerXData =  PlottedData.TFPowerXData;
    DataToSave.TFPowerYData =  PlottedData.TFPowerYData;
    DataToSave.TFPowerCData =  PlottedData.TFPowerCData;
    DataToSave.TFPowerXTicks =  PlottedData.TFPowerXTicks;
end

save(Fullsavefile,"DataToSave");