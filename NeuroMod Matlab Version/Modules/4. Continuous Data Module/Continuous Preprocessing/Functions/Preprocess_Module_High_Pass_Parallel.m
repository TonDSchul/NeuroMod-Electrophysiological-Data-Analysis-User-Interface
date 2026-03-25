function [Raw,Preprocessed,h] = Preprocess_Module_High_Pass_Parallel(Raw,Preprocessed,SampleRate,Cutoff,filterorder,type,dir,wintype,AlreadyPreprocessed,h)

if AlreadyPreprocessed
    [nChan, ~] = size(Preprocessed);
else
    [nChan, ~] = size(Raw);
end

msg = sprintf('High Pass Filtering, Parallel Processing... (%d%% done)', 10);
waitbar(0.1, h, msg);
pause(0.1)
tic
parfor channelnr = 1:nChan
    if AlreadyPreprocessed
        CurrentDataRow = Preprocessed(channelnr,:);                 
    else
        CurrentDataRow = Raw(channelnr,:);                 
    end

    NonNan = ~isnan(CurrentDataRow);

    if any(NonNan)
        filtered = ft_preproc_highpassfilter( ...
            double(CurrentDataRow(NonNan)), ...
            SampleRate, Cutoff, filterorder, type, dir, ...
            'no', [], wintype, [], 'no', 'no');

        CurrentDataRow(NonNan) = filtered;             % modify in place
    end

    Preprocessed(channelnr,:) = CurrentDataRow;        % no extra temp array
end
toc
msg = sprintf('High Pass Filtering... (%d%% done)', 100);
waitbar(1, h, msg);
