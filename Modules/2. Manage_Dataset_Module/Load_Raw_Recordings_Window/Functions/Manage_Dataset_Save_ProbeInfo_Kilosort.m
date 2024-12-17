function Manage_Dataset_Save_ProbeInfo_Kilosort(executableFolder,ChannelRowsDropDown,NrChannelEditField,ChannelSpacingumEditField,ActiveChannelField,VerOffsetSecondRow,VerOffsetDistanceSecondRow,VerOffsetRows,HorOffset)

cd(strcat(executableFolder,'\Probe Layouts\Kilosort Channelmaps\'));

if isempty(ActiveChannelField{1})
    NrChannel = str2double(NrChannelEditField)*str2double(ChannelRowsDropDown);
else
    NrChannel = length(str2double(strsplit(ActiveChannelField{1})));
end

%% 1 Channel Row
if str2double(ChannelRowsDropDown) == 1
    chanMap = 1:NrChannel;
    chanMap0ind = 0:NrChannel-1;

    if isempty(ActiveChannelField{1})
        connected = true(size(chanMap,1),size(chanMap,2));
    else
        activeChannels = str2double(strsplit(ActiveChannelField{1},','));
        connected = false(size(chanMap,1),size(chanMap,2));
        connected(activeChannels) = true;
    end

    kcoords = zeros(size(chanMap,1),size(chanMap,2))+1;

    if ~VerOffsetSecondRow
        xcoords = zeros(size(chanMap,1),size(chanMap,2));
    else
        xcoords = zeros(size(chanMap,1),size(chanMap,2));
        xcoords(2:2:end) = 0 + VerOffsetDistanceSecondRow;
    end
    ycoords = 0:str2double(ChannelSpacingumEditField):(NrChannel-1)*str2double(ChannelSpacingumEditField);
end

%% 2 Channel Rows
if str2double(ChannelRowsDropDown) == 2

    % vec = 1:NrChannel; % Create a vector from 1 to ChannelNr
    % reorderedVec = reshape(vec, 2, [])'; % Group numbers in pairs
    % reorderedVec = reorderedVec(:, [2, 1]); % Swap the columns to get the desired order
    % reorderedVec = reorderedVec'; % Transpose for column-wise flattening
    % chanMap = reorderedVec(:)'; % Flatten into a single row
    % 
    % chanMap0ind = chanMap-1;

    chanMap = 1:NrChannel;
    chanMap0ind = chanMap-1;

    if isempty(ActiveChannelField{1})
        connected = true(size(chanMap,1),size(chanMap,2));
    else
        activeChannels = str2double(strsplit(ActiveChannelField{1},','));
        connected = false(size(chanMap,1),size(chanMap,2));
        connected(activeChannels) = true;
    end
    
    kcoords = zeros(size(chanMap,1),size(chanMap,2))+1;

    if ~VerOffsetSecondRow
        xcoords = zeros(size(chanMap,1),size(chanMap,2));
        xcoords(2:2:end) = 0 + HorOffset;
    else
        xcoords = zeros(size(chanMap,1),size(chanMap,2));
        xcoords(1:2:end) = 0 + HorOffset;
        
        vec = 1:length(chanMap);
        %% Select 2 indicies, leave next two alone
        step = 4; % Step size (4 values: take 2, skip 2)
        indices = [];
        for start_idx = 3:step:length(vec)
            indices = [indices, start_idx, start_idx + 1]; % Take the first two values of each group
        end
        indices = indices(indices <= length(vec));  
        ProperIndicies = vec(indices);

        %xcoords(ProperIndicies) = xcoords(ProperIndicies) - VerOffsetDistanceSecondRow;
        xcoords(ProperIndicies) = xcoords(ProperIndicies) + VerOffsetDistanceSecondRow;
    end
    
    Alldepths = 0:str2double(ChannelSpacingumEditField):((NrChannel-1)/2)*str2double(ChannelSpacingumEditField);
    ycoords = zeros(size(chanMap));
    
    vec = 1:length(chanMap);
    %% Select 2 indicies, leave next two alone
    step = 4; % Step size (4 values: take 2, skip 2)
    indices = [];
    for start_idx = 1:step:length(vec)
        indices = [indices, start_idx, start_idx + 1]; % Take the first two values of each group
    end
    indices = indices(indices <= length(vec));  
    ProperIndicies = vec(indices);

    for i = 1:2:length(ProperIndicies)
        ycoords(ProperIndicies(i):ProperIndicies(i+1)) = Alldepths(i);
        ycoords(ProperIndicies(i)+2:ProperIndicies(i)+3) = Alldepths(i+1);
    end

    ycoords(1:2:end)=ycoords(1:2:end)+VerOffsetRows;

end

% Prompt user for file save location and name
[file, path] = uiputfile('*.mat', 'Save as');

if isequal(file,0) || isequal(path,0)
    disp('User canceled the operation.');
    return;
end

% Construct the full file path
filepath = fullfile(path, file);
% Save the variables to the .mat file
save(filepath, 'chanMap', 'chanMap0ind', 'connected', 'kcoords', 'xcoords', 'ycoords');
stringtoshow = ['Kilosort channel map saved to: ' filepath];
msgbox(stringtoshow);