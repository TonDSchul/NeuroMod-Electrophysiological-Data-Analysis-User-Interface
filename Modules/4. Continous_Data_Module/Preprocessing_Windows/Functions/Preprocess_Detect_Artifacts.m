function artifact_indices = Preprocess_Detect_Artifacts(Data, window_size, threshold, method)
    % Detect artifacts in a signal using Moving Average or Median Filtering for baseline drift
    % Data is channel x time
    
    for nchannel = 1:size(Data,1)

        % Validate method input
        if ~strcmp(method, 'average') && ~strcmp(method, 'median')
            error('Method must be "average" or "median".');
        end
        
        % Apply the chosen filter to calculate the baseline
        if strcmp(method, 'average')
            % Moving Average Filter
            baseline = movmean(Data(nchannel,:), window_size);
        elseif strcmp(method, 'median')
            % Moving Median Filter
            baseline = movmedian(Data(nchannel,:), window_size);
        end
        
        % Calculate the difference between the signal and the baseline
        deviation = abs(Data(nchannel,:) - baseline);
        
        % Detect artifacts where deviation exceeds the threshold
        artifact_indices = deviation > threshold;
        
        %% Extract Example Data
    end

end