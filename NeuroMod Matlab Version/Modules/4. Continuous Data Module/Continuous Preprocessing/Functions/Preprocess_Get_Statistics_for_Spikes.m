function [Data] = Preprocess_Get_Statistics_for_Spikes(Data)

%________________________________________________________________________________________

%% Function to get global std over all channel after high pass filtering for axon viewer threshold

% Input:
% 1. Data: Data structure containing raw and potentially preprocessed data as a Channel x Time matrix
% and Info structure with already applied preprocessing steps and other infos

% Output: 
% 1. Data with Data.Info.HighPassStatistics being added

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if isfield(Data.Info,'HighPassStatistics')
    fieldsToDelete = {'HighPassStatistics'};
    % Delete fields
    Data.Info = rmfield(Data.Info, fieldsToDelete);
end

if isfield(Data.Info,'FilterMethod')
    if strcmp(Data.Info.FilterMethod,"High-Pass") || strcmp(Data.Info.FilterMethod,"Band-Pass")
        h2 = waitbar(0, 'Calculating Signal Statistics (mean, std)...', 'Name','Preprocessing...');
        msg = sprintf('Calculating Signal Statistics (mean, std)... (%d%% done)', round(100*(1/2)));
        waitbar(1/2, h2, msg);

        Data.Info.HighPassStatistics.Mean = nan(1,size(Data.Raw,1));
        Data.Info.HighPassStatistics.Std = nan(1,size(Data.Raw,1));

        %for nchannel = 1:size(Data.Raw,1)
        Data.Info.HighPassStatistics.Mean = mean(Data.Preprocessed(:));
        Data.Info.HighPassStatistics.Std = std(Data.Preprocessed(:));
        %end

        msg = sprintf('Calculating Signal Statistics (mean, std)... (%d%% done)', round(100*(1)));
        waitbar(1, h2, msg);
        close(h2);
    end
end

