function [EventRelatedData] = Preprocessing_Events_Interpolate_Channel(EventRelatedData,Rejectedchan)

if ~isempty(Rejectedchan)
    Rejectedchan = unique(Rejectedchan);  % Ensure uniqueness
    Rejectedchan = sort(Rejectedchan);

    goodchannel = 1:size(EventRelatedData,1);
    goodchannel(Rejectedchan) = [];

    % Get list of all channels
    %goodchannel = setdiff(1:nchannel, Rejectedchan);
    
    if length(goodchannel) <= 2
        msgbox("Error: At least two valid channels required, Exiting");
        return;
    end

    [nChannel, nTrial, nTime] = size(EventRelatedData);

    % Work with a copy of the original data
    InterpolatedData = EventRelatedData;

    for i = 1:length(Rejectedchan)
        badIdx = Rejectedchan(i);

        % Find neighboring good channels
        lowerGood = goodchannel(find(goodchannel < badIdx, 1, 'last'));
        upperGood = goodchannel(find(goodchannel > badIdx, 1, 'first'));

        if ~isempty(lowerGood) && ~isempty(upperGood)
            InterpolatedData(badIdx, :, :) = ...
                (EventRelatedData(lowerGood, :, :) + EventRelatedData(upperGood, :, :)) / 2;

        elseif ~isempty(lowerGood)
            InterpolatedData(badIdx, :, :) = EventRelatedData(lowerGood, :, :);

        elseif ~isempty(upperGood)
            InterpolatedData(badIdx, :, :) = EventRelatedData(upperGood, :, :);

        else
            warning('No good neighboring channels found for bad channel %d. Skipping interpolation.', badIdx);
        end
    end

    % Apply the interpolation only once, after all are computed
    EventRelatedData = InterpolatedData;
end