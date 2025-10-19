function [xcoords,ycoords,chanMap] = Manage_Dataset_Save_ProbeInfo_Kilosort(executableFolder,ChannelRowsDropDown,NrChannelEditField,ChannelSpacingumEditField,ActiveChannelField,VerOffsetSecondRow,VerOffsetDistanceSecondRow,VerOffsetRows,HorOffset,SaveProbe)

%________________________________________________________________________________________

%% This function saves the current probelayout for external use in Kilosort (saves as .mat file)

% Input:
% 1. executableFolder: path the GUI is executed/saved in
% 2. ChannelRowsDropDown: char; Dropdownmenu value from probe window specifying
% number of channelrows.
% 3. NrChannelEditField: char, editfield value from probe window specifying
% number of channels.
% 4. ChannelSpacingumEditField: char, editfield value from probe window specifying
% channel spacing.
% 5. ActiveChannelField: single cell containing char, editfield value from probe window specifying
% all active channel.
% 6. VerOffsetSecondRow: double, 1 or 0 if true or false to set veroffset
% 7. VerOffsetDistanceSecondRow: double, editfield value from probe window specifying
% vertical offset between both rows.
% 8. VerOffsetRows: double, vertical offset between rows
% 9. HorOffset: char, editfield value from probe window specifying
% horizontal offset between channel rows.
% 10. SaveProbe: double, 1 or 0 to specify whether map should be saved or
% not

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

NrChannel = str2double(NrChannelEditField);

% force to char
if isstring(ActiveChannelField{1})
    ActiveChannelField{1} = convertStringsToChars(ActiveChannelField{1});
end

if ischar(ActiveChannelField{1})
    if length(str2double(strsplit(ActiveChannelField{1},','))) > NrChannel*str2double(ChannelRowsDropDown)
        msgbox("Number of active channel is bigger than speciefied number of channel in probe design.")
        xcoords = [];
        ycoords = [];
        chanMap = [];
        return;
    end
else
    if length(ActiveChannelField{1}) > NrChannel*str2double(ChannelRowsDropDown)
        msgbox("Number of active channel is bigger than speciefied number of channel in probe design.")
        xcoords = [];
        ycoords = [];
        chanMap = [];
        return;
    end
end

% if ischar(ActiveChannelField{1})
%     if isempty(ActiveChannelField{1})
%         NrChannel = str2double(NrChannelEditField)*str2double(ChannelRowsDropDown);
%     else
%         NrChannel = length(str2double(strsplit(ActiveChannelField{1})));
%     end
% else
%     NrChannel = length(ActiveChannelField{1});
% end

%% 1 Channel Row
if str2double(ChannelRowsDropDown) == 1
    chanMap = 1:NrChannel;
    chanMap0ind = 0:NrChannel-1;
    
    if isempty(ActiveChannelField{1})
        connected = true(size(chanMap,1),size(chanMap,2));
    else
        if ischar(ActiveChannelField{1})
            activeChannels = str2double(strsplit(ActiveChannelField{1},','));
        else
            activeChannels = ActiveChannelField{1};
        end
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
        if ischar(ActiveChannelField{1})
            activeChannels = str2double(strsplit(ActiveChannelField{1},','));
        else
            activeChannels = ActiveChannelField{1};
        end
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
    
    Alldepths = 0:str2double(ChannelSpacingumEditField):((NrChannel)-1)*str2double(ChannelSpacingumEditField);
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

%% 3 and more Channel Rows
if str2double(ChannelRowsDropDown) > 2
    
    NrChannel = round(NrChannel/str2double(ChannelRowsDropDown));

    chanMap = 1:NrChannel*str2double(ChannelRowsDropDown);
    chanMap0ind = chanMap-1;

    if isempty(ActiveChannelField{1})
        connected = true(size(chanMap,1),size(chanMap,2));
    else
        if ischar(ActiveChannelField{1})
            activeChannels = str2double(strsplit(ActiveChannelField{1},','));
        else
            activeChannels = ActiveChannelField{1};
        end
        connected = false(size(chanMap,1),size(chanMap,2));
        connected(activeChannels) = true;
    end
    
    kcoords = zeros(size(chanMap,1),size(chanMap,2))+1;

    xcoords = zeros(size(chanMap,1),size(chanMap,2));
    xcoordtemp = 0:HorOffset:HorOffset*str2double(ChannelRowsDropDown)-1;
    Laufvariable = 1;
    for tt = NrChannel:str2double(ChannelRowsDropDown):NrChannel*str2double(ChannelRowsDropDown)
        if VerOffsetSecondRow == 1
            if mod(Laufvariable,2) == 0
                xcoords(1,tt-str2double(ChannelRowsDropDown)+1:tt) = xcoordtemp+VerOffsetDistanceSecondRow;
            else
                xcoords(1,tt-str2double(ChannelRowsDropDown)+1:tt) = xcoordtemp;
            end
        else
            xcoords(1,tt-str2double(ChannelRowsDropDown)+1:tt) = xcoordtemp;
        end
        Laufvariable = Laufvariable + 1;
    end
    
    Alldepths = 0:str2double(ChannelSpacingumEditField):((NrChannel)-1)*str2double(ChannelSpacingumEditField);
    ycoords = zeros(size(chanMap));
    
    Laufvariable = 1;
    for tt = NrChannel:str2double(ChannelRowsDropDown):NrChannel*str2double(ChannelRowsDropDown)
        ycoords(1,tt-str2double(ChannelRowsDropDown)+1:tt) = Alldepths(Laufvariable);
        Laufvariable = Laufvariable + 1;
    end
end


if SaveProbe
    
    PathToSave = (strcat(executableFolder,'\Probe Layouts\Kilosort Channelmaps\'));

    % Prompt user for file save location and name
    if ~isfolder(PathToSave)
        [file, path] = uiputfile('*.mat', 'Save as');
    else
        [file, path] = uiputfile(fullfile(PathToSave, '*.mat'), 'Save as');
    end
   
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
end