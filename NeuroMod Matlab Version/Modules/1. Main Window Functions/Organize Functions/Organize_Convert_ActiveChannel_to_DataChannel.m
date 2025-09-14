function [DataChannel] = Organize_Convert_ActiveChannel_to_DataChannel(AllActiveChannel,SelectedActiveChannel,Type)

%________________________________________________________________________________________
%% Function to convert active channel selection to a data channel.
% This function is necessary bc. the active channel can have interruptions
% (i.e. 1,2,4,5,6,8..) which can not be used to index the data matrix. Therefore this has to be changed to an index within the data channel range 

% Input Arguments:
% 1. AllActiveChannel: vector, all active channel the user set when
% specifying probe design
% 2. SelectedActiveChannel: vector, all channel the user currently selected
% in the probe view window
% 3. Type: char, either 'Spikes' or someting else, 'Spikes' for spike analysis 

% Output Arguments:
% 1. DataChannel: vector, contains selected data channel indices 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

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

