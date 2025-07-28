function InformationTextArea = Utility_Show_Narrowband_FilterStatusMessage(Data,InformationTextArea,DropDown)

%________________________________________________________________________________________
%% Function to populate the info field showing preprocessing steps applied for phase sync analysis

% This function is called in the phase sync windows after analysis was
% finsihed

% Input Arguments:
% 1. Data: main app data objects with all relevant data components
% 2. InformationTextArea: text area from the respective window in which
% info is shown
% 3. DropDown: main window dropdown menu, either 'Raw Data' or 'Preprocessed Data'

% Output Arguments:
% 1. Corrected_Input: char with either the original input when its format
% is proper, char with standardvalue if format was violated

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

NBF = 0;
DS = 0;

if isfield(Data.Info,'DownsampledSampleRate')
    DS = 1;
end

if isfield(Data.Info,'NarrowbandFilterMethod')
    NBF = 1;
end

if strcmp(DropDown,"Raw Data")
    InformationTextArea = "Signal has to be narrowband filtered since raw data was selected in the main window plot. Signal is automatically low pass filtered, downsampled and narrowband filtered. The only case those step are not automatically applied is when preprocessed data was selected in the main window and preprocessing includes a narrowband filter.";
    if isfield(Data,'Preprocessed')
        if DS == 1 && NBF == 1
            InformationTextArea = [InformationTextArea;"Preprocessed signal with narrowband filter and downsampling found. Change the main window plot to show phase analysis of preprocessed data without additional low pass filter and downsampling."];
        elseif DS == 1 && NBF == 0
            InformationTextArea = [InformationTextArea;"Preprocessed signal without narrowband filter and with downsampling found. When changing the main plot to show preprocessed data, data will be narrowband filtered for this analysis. This leads to alisasing. To avoid this, first low pass filter the signal before downsampling!"];
        elseif DS == 0 && NBF == 1
            InformationTextArea = [InformationTextArea;"Preprocessed signal with narrowband filter and without downsampling found. Change the main window plot to show phase analysis of preprocessed data with additional downsampling."];
        elseif DS == 0 && NBF == 0
            InformationTextArea = [InformationTextArea;"Preprocessed signal without narrowband filter and without downsampling found. Change the main window plot to show phase analysis of preprocessed data with additional low pass filter - and downsampling step applied."];
        end
    end
else
    if DS == 1 && NBF == 1
        InformationTextArea = "Preprocessed signal with narrowband filter and downsampling found. Phase analysis of preprocessed data is conducted without additional low pass filter and downsampling.";
    elseif DS == 1 && NBF == 0
        InformationTextArea = "Preprocessed signal without narrowband filter and with downsampling found. Data will be narrowband filtered for this analysis, leading to alisasing. To avoid this, first low pass filter the signal before downsampling!";
    elseif DS == 0 && NBF == 1
        InformationTextArea = "Preprocessed signal with narrowband filter and without downsampling found. Phase analysis of preprocessed data is conducted with additional downsampling.";
    elseif DS == 0 && NBF == 0
        InformationTextArea = "Preprocessed signal without narrowband filter and without downsampling found. Phase analysis of preprocessed data is conducted with an additional low pass filter and downsampling step being applied.";
    end
end