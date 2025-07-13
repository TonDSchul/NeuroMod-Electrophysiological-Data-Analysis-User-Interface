function [texttoshow] = Preprocessing_Events_ExtractPreprocessingStep(Data)

PreproStruc = [];

if isfield(Data.Info,'FilterMethod')
    PreproStruc.Cutoff = Data.Info.Cutoff;
    PreproStruc.FilterOrder = Data.Info.FilterOrder;
    PreproStruc.FilterMethod = Data.Info.FilterMethod;
    PreproStruc.FilterType = Data.Info.FilterType;
    PreproStruc.FilterDirection = Data.Info.FilterDirection;
end
if isfield(Data.Info,'MedianFilterMethod')
    PreproStruc.MedianFilterOrder = Data.Info.MedianFilterOrder;
    PreproStruc.MedianFilterMethod = Data.Info.MedianFilterMethod;
end
if isfield(Data.Info,'NarrowbandFilterMethod')
    PreproStruc.NarrowbandFilterMethod = Data.Info.NarrowbandFilterMethod;
    PreproStruc.NarrowbandFilterType = Data.Info.NarrowbandFilterType;
    PreproStruc.NarrowbandFilterDirection = Data.Info.NarrowbandFilterDirection;
    PreproStruc.NarrowbandCutoff = Data.Info.NarrowbandCutoff;
    PreproStruc.NarrowbandFilterOrder = Data.Info.NarrowbandFilterOrder;
end
if isfield(Data.Info,'BandStopFilterMethod')
    PreproStruc.BandStopCutoff = Data.Info.BandStopCutoff;
    PreproStruc.BandStopFilterOrder = Data.Info.BandStopFilterOrder;
    PreproStruc.BandStopFilterMethod = Data.Info.BandStopFilterMethod;
    PreproStruc.BandStopFilterType = Data.Info.BandStopFilterType;
    PreproStruc.BandStopFilterDirection = Data.Info.BandStopFilterDirection;
end
if isfield(Data.Info,'DownsampleFactor')
    PreproStruc.DownsampleFactor = Data.Info.DownsampleFactor;
    PreproStruc.DownsampledSampleRate = Data.Info.DownsampledSampleRate;
end
if isfield(Data.Info,'ASR')
    PreproStruc.ASRLineNoiseC = Data.Info.ASRLineNoiseC;
    PreproStruc.ASRHPTransitions = Data.Info.ASRHPTransitions;
    PreproStruc.ASRBurstC = Data.Info.ASRBurstC;
    PreproStruc.WindowC = Data.Info.WindowC;
    PreproStruc.ASR = Data.Info.ASR;
end
if isfield(Data.Info,'Normalize')
    PreproStruc.Normalize = Data.Info.Normalize;
end
if isfield(Data.Info,'GrandAverage')
    PreproStruc.GrandAverage = Data.Info.GrandAverage;
end
if isfield(Data.Info,'StimArtefactChannel')
    PreproStruc.StimArtefactChannel = Data.Info.StimArtefactChannel;
    PreproStruc.TimeAroundStimArtefact = Data.Info.TimeAroundStimArtefact;
end

% fields = fieldnames(PreproStruc);
% texttoshow = strjoin(fields, ', ');

fields = fieldnames(PreproStruc);
texttoshow = cell(numel(fields), 1);

for i = 1:numel(fields)
    fname = fields{i};
    val = PreproStruc.(fname);
    
    % Convert value to string based on its type
    if isstruct(val)
        valStr = '[struct]';
    elseif isnumeric(val)
        if isempty(val)
            valStr = '[]';
        else
            valStr = mat2str(val);
        end
    elseif ischar(val)
        valStr = val;  % char array
    elseif isstring(val)
        valStr = char(val);  % convert to char for consistency
    elseif isempty(val)
        valStr = '[]';
    else
        valStr = '[unsupported type]';
    end
    
    % Construct the output string
    texttoshow{i} = sprintf('%s: %s', fname, valStr);
end