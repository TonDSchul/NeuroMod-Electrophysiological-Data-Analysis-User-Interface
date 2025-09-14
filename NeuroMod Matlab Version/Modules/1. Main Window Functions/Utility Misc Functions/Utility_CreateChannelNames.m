function names = Utility_CreateChannelNames(app)
%________________________________________________________________________________________
%% Function to create standard channel names (Channel1, Channel2 and so on)
% This function gets called for example to display the create channel names when the
% user clicks on the data plot of the main window

% Input Arguments:
% 1. app: app object with fields 'Data.Raw' needed for max channel nr

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

names = cell(1, size(app.Data.Raw,1));
for i = 1:size(app.Data.Raw,1)
    names{i} = sprintf('Channel %d', i);
end
