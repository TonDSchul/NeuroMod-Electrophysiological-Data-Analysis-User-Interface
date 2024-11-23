function [DataChannel] = Organize_Convert_ActiveChannel_to_DataChannel(AllActiveChannel,SelectedActiveChannel,Type)

 % active channel can be 380. However data can have less channel -->
% translate into channels for data
DataChannel = [];

if ~strcmp(Type,'Spikes')

    for i = 1:length(AllActiveChannel)
        if sum(SelectedActiveChannel==AllActiveChannel(i))>0
            DataChannel = [DataChannel,i];
        end
    end

else
    for nall = 1:length(AllActiveChannel)
        for nselected = 1:length(SelectedActiveChannel)
            if sum(SelectedActiveChannel(nselected)==AllActiveChannel(nall))>0
                SelectedActiveChannel(nselected) = nall;
                % break;
            end
        end
    end

    DataChannel = SelectedActiveChannel;

end

