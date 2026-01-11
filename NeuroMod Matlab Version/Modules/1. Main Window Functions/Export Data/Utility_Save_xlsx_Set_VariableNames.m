function T = Utility_Save_xlsx_Set_VariableNames(PlottedData,Analysis,XData,YData,XTick)

%________________________________________________________________________________________

%% This function puts x,y, and xtick data that is supposed to be exported in a table to save in a .xlsx file

% Input:
% 1. PlottedData: struc with info about data to be exported (which is the
% same as plotted data, therefore the name)
% 2. Analysis: char, kind of analysis for which data is exported. sets
% header name of each table row
% 3. XData: double vector with x data to be exported
% 4. YData: double vector with y data to be exported
% 5. XTick: cell array with each cell holding a char representing one xtick
% label


% Output: 
% 1. folderPath: char, path the user selected to save in

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


if contains(Analysis,"All Spikes Spike Rate over Time")
    T = table(XData', YData', XTick', 'VariableNames', {'Time Bin','Spike Rate (Hz)','Time Labels (s)'});
elseif contains(Analysis,"All Spikes Spike Rate over Channel")
    T = table(XData', YData', XTick', 'VariableNames', {'Spike Rate (Hz)','Depth Bin','Spike Rate Labels (Hz)'});
elseif contains(Analysis,"Spike Rate Unit over Time")
    T = table(XData', YData', XTick', 'VariableNames', {'Time Bin','Spike Rate (Hz)','Time Labels (s)'});
elseif contains(Analysis,"Spike Times Spike Map")
    if strcmp(PlottedData.Info.Sorter,'Non')
        T = table(XData', YData', XTick', 'VariableNames', {'Spike Times (s)','Spike Positions (channel)','Time Labels (s)'});
    else
        T = table(XData', YData', XTick', 'VariableNames', {'Spike Times (s)','Spike Positions (um)','Time Labels (s)'});
    end
elseif contains(Analysis,"Unit Spike Times") && ~ contains(Analysis,"Waveforms")
    T = table(XData', YData', XTick', 'VariableNames', {'Spike Times (s)','Spike Positions (channel)','Time Labels (s)'});
elseif contains(Analysis,"Unit Spike Times") && contains(Analysis,"Waveforms") && contains(Analysis,"Average")
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','Depth (um)','Time Labels (s)'});
elseif contains(Analysis,"Unit Spike Times") && contains(Analysis,"Waveforms") && ~contains(Analysis,"Average")
    YData = NaN(size(XData));
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','-','Time Labels (s)'});
elseif contains(Analysis,"Spike Amplitude Density") && ~contains(Analysis,"Cumulative")
    T = table(XData', YData', XTick', 'VariableNames', {'Spike Amplitude (mV)','Depth (um)','Spike Amplitude Labels (mV)'});
elseif contains(Analysis,"Cumulative Spike Amplitude Density")
    T = table(XData', YData', XTick', 'VariableNames', {'Spike Amplitude (mV)','Depth (um)','Spike Amplitude Labels (mV)'});
elseif contains(Analysis,"Average Waveforms")
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','Depth (um)','Time Labels (s)'});
elseif contains(Analysis,"Spike Waveforms") && ~contains(Analysis,"Average")
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','-','Time Labels (s)'});
elseif contains(Analysis,"Spike Triggered")
    T = table(XData', YData', XTick', 'VariableNames', {'Time (ms)','Depth (um)','Time Labels (ms)'});
%% Live Plot Analysis
elseif strcmp(Analysis,"Live_Spectral_Power_Estimate_Main_Window")
    T = table(XData', YData', XTick', 'VariableNames', {'Bar Index','Power/Frequency (dB/Hz)','Frequency Band Labels'});
elseif strcmp(Analysis,"Live_CSD_Main_Window")
    T = table(XData', YData', XTick', 'VariableNames', {'Time(s)','Depth(um)','Time Labels (s)'});
elseif strcmp(Analysis,"Live_Spike_Rate_Main_Window")
    T = table(XData', YData', XTick', 'VariableNames', {'Time Bin','Spike Rate (Hz)','Time Labels (s)'});
elseif contains(Analysis,"Live Spectrogram Plot")
    T = table(XData', YData, XTick', 'VariableNames', {'Time [s]','Frequency (Hz)','Time Labels (s)'});
%% Continous Spectrum
elseif strcmp(Analysis,"Static_Spectrum")
    if strcmp(PlottedData.Type,"Power Spectrum over Depth")
        T = table(XData', YData', XTick', 'VariableNames', {'Frequency (Hz)','Depth (um)','Frequency Labels (Hz)'});
    else
        T = table(XData', YData', XTick', 'VariableNames', {'Frequency (Hz)','Power/Frequency (dB/Hz)','Frequency Labels (Hz)'});
    end

%% Event Related LFP Analyis
elseif strcmp(Analysis,"Event Related Potential over Events")
    if size(YData,1)~=1 && size(YData,2)~=1
        YData = NaN(size(XData));
    end
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','-','Time Labels (s)'});
elseif contains(Analysis,"Potential") && contains(Analysis,"Channel")
    if size(YData,1)~=1 && size(YData,2)~=1
        YData = NaN(size(XData));
    end
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','-','Time Labels (s)'});
elseif strcmp(Analysis,"Current Source Density Analysis")
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','Depth (um)','Time Labels (s)'});
elseif contains(Analysis,"Event Related Static Spectrum") && contains(Analysis,"Channel") 
    T = table(XData', YData', XTick', 'VariableNames', {'Frequency (Hz)','Power/Frequency (dB/Hz)','Frequency Labels (Hz)'});
elseif contains(Analysis,"Event Related Static Spectrum") && contains(Analysis,"Depth") 
    T = table(XData', YData', XTick', 'VariableNames', {'Frequency (Hz)','Depth (um)','Frequency Labels (Hz)'});
elseif contains(Analysis,"Time Frequency Power") 
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','Frequency (Hzs)','Time Labels (s)'});

%% Event Related Spike Analyis
elseif strcmp(Analysis,"Heatmap")
    T = table(XData', YData', XTick', 'VariableNames', {'Time (s)','Depth (um)','Time Labels (s)'});

%% Unit alaysis
elseif contains(Analysis,"Waveform Analysis") && contains(Analysis,"Plot")
    T = table(XData', YData', XTick', 'VariableNames', {'Time (ms)','-','Time Labels (ms)'});
elseif contains(Analysis,"ISI") && contains(Analysis,"Plot")
    T = table(XData', YData', XTick', 'VariableNames', {'Time Bins','ISI Probability (%)','ISI (s)'});
elseif contains(Analysis,"Auto") && contains(Analysis,"Plot")
    T = table(XData', YData', XTick', 'VariableNames', {'Time Lag (ms)','Spike Count','Time Lag Labels (ms)'});
%% anything else
else
    T = table(XData', YData', XTick', 'VariableNames', {'X_Data','Y_Data','X_Tick'});
end


