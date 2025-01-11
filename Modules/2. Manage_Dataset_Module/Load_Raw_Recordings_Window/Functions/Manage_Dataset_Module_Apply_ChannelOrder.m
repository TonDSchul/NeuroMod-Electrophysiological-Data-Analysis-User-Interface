function [Data] =  Manage_Dataset_Module_Apply_ChannelOrder (Data,ChannelOrder)

%________________________________________________________________________________________

%% This function applies a costum channel order to the raw data after extracting

% This gets called in the Extract_Data_Window app window or Autorun template function after data
% extraction finished

% Input:
% 1. Data: structre with Data.Raw field containing nchannel x ntimepoints
% single matrix
% 2. ChannelOrder: double 1 x nchannel vector containing the new channel
% order; i.e. [2,6,4,8,10,22...]

% Output: 
% 1. Data: structre with modified Data.Raw field

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


if ~isempty(ChannelOrder) && length(ChannelOrder) == size(Data.Raw,1) 
    % If first channel is designated with a 0, we cant loop
    % over it. So we add +1 to every channel number
    if find(ChannelOrder == 0)
        ChannelOrder = ChannelOrder+1;
    end

    %% Create Channel Order
    %If the user selcted a costum channel order
    if Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
        InversedChannelOrder = zeros(size(ChannelOrder))+length(ChannelOrder);
        InversedChannelOrder = (InversedChannelOrder - ChannelOrder)+1;
        %% Reorder data according to loaded Channelorder

        Data.Raw = Data.Raw(InversedChannelOrder, :); % reorder 
    else
        % Reorder data according to loaded Channelorder

        Data.Raw = Data.Raw(ChannelOrder, :); % reorder 
    end

    Data.Info.Channelorder = ChannelOrder;
    
    disp("Costum Channel Order loaded.")

    clear('tempMatrix');
    
elseif isnan(ChannelOrder(1))
    disp("No Channel Order selected.")
else
    % If no channelorder selected, it is 1 to channel size
    % by default
    Data.Info.Channelorder = 1:1:size(Data.Raw,1);
    stringtoshow = "Channelorder could not be loaded or has more/less elements than data has channel. Data was loaded without costum channelorder.";
    msgbox(stringtoshow);
end