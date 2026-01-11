function Error = Utility_Check_Saved_Spike_PlotData(PlottedData,Analysis)

%________________________________________________________________________________________

%% This function checks what kind of spike data the user wants to save and gives warnings/messages how/what/what is not possible

% Input:
% 1. PlottedData: struc with saved data from plot to export
% 2. Analysis: string specifying the name of the analysis the user wants to
% export

% Output:
% 1. Error: double, 1 or 0 whether an error occured

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Error = 0;

%%------------------------------------------------------- Event Related Spike Rate Heatmap -------------------------------------------------------
%% Non-Unit!
if contains(Analysis,'Heatmap') && ~contains(Analysis,'Unit') 
    if ~contains(PlottedData.MainType,'Heatmap')
        msgbox("Please first plot heatmap for all spikes (no unit selection) before exporting results of all spikes.")
        Error = 1;
        return
    end
end
%% Unit!
if contains(Analysis,'Heatmap') && contains(Analysis,'Unit') 
    Error = 1;
    
    warning("Export unit analysis for heatmap just exports the whole heatmap since unit information is just overlayed. To export unit information use the spike map.")
    return
end

%%------------------------------------------------------- Spike Triggered Average -------------------------------------------------------
%% Non-Unit!
if contains(Analysis,'Spike Triggered') && ~contains(Analysis,'Unit') 
    if ~contains(PlottedData.MainType,'Spike Triggered')
        msgbox("Please first plot spike triggered average for all spikes (no unit selection) before exporting results of all spikes.")
        Error = 1;
        return
    end
end
%% Unit!
if contains(Analysis,'Spike Triggered') && contains(Analysis,'Unit') 
    try
        if ~contains(PlottedData.MainType,'Spike Triggered')
            msgbox("Please first plot spike triggered average for a unit before exporting results of a unit.")
            Error = 1;
            return
        end
    catch
        msgbox("Please first plot spike triggered average for a unit before exporting results of a unit.")
        Error = 1;
        return
    end
end

%%------------------------------------------------------- Spike Waveform -------------------------------------------------------
%% Non-Unit!
if contains(Analysis,'Waveform') && ~contains(Analysis,'Average') && ~contains(Analysis,'Unit') 
    if ~contains(PlottedData.MainType,'Individual Spike Waveforms')
        msgbox("Please first plot individual spike waveforms for all spikes (no unit selection) before exporting results of all spikes.")
        Error = 1;
        return
    end
end
%% Unit!
if contains(Analysis,'Waveform') && ~contains(Analysis,'Average') && contains(Analysis,'Unit') && ~contains(Analysis,'Plot') 
    try
        if ~contains(PlottedData.MainType,'Individual Spike Waveforms')
            msgbox("Please first plot individual spike waveforms for a unit before exporting results of a unit.")
            Error = 1;
            return
        end
    catch
        msgbox("Please first plot individual spike waveforms for a unit before exporting results of a unit.")
        Error = 1;
        return
    end
end

%%------------------------------------------------------- Average Waveform -------------------------------------------------------
%% Non-Unit!
if contains(Analysis,'Average Waveform') && ~contains(Analysis,'Unit')
    if ~contains(PlottedData.MainType,'Average Waveform')
        msgbox("Please first plot average waveforms for all spikes (no unit selection) before exporting results of all spikes.")
        Error = 1;
        return
    end
end
%% Unit!
if contains(Analysis,'Average Waveform') && contains(Analysis,'Unit')
    try
        if ~contains(PlottedData.MainUnitType,'Average Waveform')
            msgbox("Please first plot average waveforms for a unit before exporting results of a unit.")
            Error = 1;
            return
        end
    catch
        msgbox("Please first plot average waveforms for a unit before exporting results of a unit.")
        Error = 1;
        return
    end
end

%%------------------------------------------------------- Spike Amplitude -------------------------------------------------------

%% Only export spike amplitude density data when already computed!
%% Non-Unit!
if contains(Analysis,'Spike Amplitude Density') && ~contains(Analysis,'Unit')
    if contains(Analysis,'Cumulative')
        if ~contains(PlottedData.MainType,'Cumulative')
            msgbox("Please first plot cumulative spike amplitude density for all spikes (no unit selection) before exporting results of all spikes.")
            Error = 1;
            return
        end
    end
    if ~contains(Analysis,'Cumulative')
        if contains(PlottedData.MainType,'Cumulative')
            msgbox("Please first plot spike amplitude density for all spikes (no unit selection) before exporting results of all spikes.")
            Error = 1;
            return
        end
    end
end
%% Only export spike amplitude density data when already computed!
%% Unit!
if contains(Analysis,'Spike Amplitude Density') && contains(Analysis,'Unit')
    if contains(Analysis,'Cumulative')
        try
            if ~contains(PlottedData.MainUnitType,'Cumulative')
                msgbox("Please first plot cumulative spike amplitude density for a unit before exporting results for a unit.")
                Error = 1;
                return
            end
        catch
            msgbox("Please first plot cumulative spike amplitude density for a unit before exporting results for a unit.")
            Error = 1;
            return
        end
    end
    if ~contains(Analysis,'Cumulative')
        try
            if contains(PlottedData.MainUnitType,'Cumulative')
                msgbox("Please first plot spike amplitude density for a unit before exporting results for a unit.")
                Error = 1;
                return
            end
        catch
            msgbox("Please first plot spike amplitude density for a unit before exporting results for a unit.")
            Error = 1;
            return
        end
    end
end

%% Only export spike amplitude density data when already computed!
%% Fallback1

if ~isfield(PlottedData,'MainXData') && contains(Analysis,'Spike Amplitude Density') && ~contains(Analysis,'Unit')
    msgbox("Please first plot spike amplitude density for all spikes (no unit selection) before exporting results of all spikes.")
    Error = 1;
    return
elseif isfield(PlottedData,'MainXData') && contains(Analysis,'Spike Amplitude Density') && ~contains(Analysis,'Unit')
    if isempty(PlottedData.MainXData)
        msgbox("Please first plot spike amplitude density for all spikes (no unit selection) before exporting results of all spikes.")
        Error = 1;
        return
    else
        if ~contains(PlottedData.MainType,'Spike Amplitude Density')
            msgbox("Please first plot spike amplitude density for all spikes (no unit selection) before exporting results of all spikes.")
            Error = 1;
            return
        end
    end
end

%% Check if unit was selcted 
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