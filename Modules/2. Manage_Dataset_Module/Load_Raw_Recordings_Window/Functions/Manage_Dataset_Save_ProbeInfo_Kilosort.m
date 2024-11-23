function Manage_Dataset_Save_ProbeInfo_Kilosort(executableFolder,ChannelRowsDropDown,NrChannelEditField,ChannelSpacingumEditField,ActiveChannelField)

app.ExtractRecordingWindow.Load_Data_Window_Info.Mainapp.executableFolder

cd(strcat(executableFolder,'\Probe Layouts\Kilosort Channelmaps\'));

if str2double(ChannelRowsDropDown) == 1
    chanMap = 1:str2double(NrChannelEditField);
    chanMap0ind = 0:str2double(NrChannelEditField)-1;

    if isempty(ActiveChannelField{1})
        connected = true(size(chanMap,1),size(chanMap,2));
    else
        activeChannels = str2double(strsplit(ActiveChannelField{1},','));
        connected = false(size(chanMap,1),size(chanMap,2));
        connected(activeChannels) = true;
    end
    kcoords = zeros(size(chanMap,1),size(chanMap,2))+1;
    xcoords = zeros(size(chanMap,1),size(chanMap,2));
    ycoords = 0:str2double(ChannelSpacingumEditField):(str2double(NrChannelEditField)-1)*str2double(ChannelSpacingumEditField);
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