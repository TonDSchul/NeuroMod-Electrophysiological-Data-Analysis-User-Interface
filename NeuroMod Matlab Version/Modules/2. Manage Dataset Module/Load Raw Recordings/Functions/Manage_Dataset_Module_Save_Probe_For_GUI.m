function Savefilepath = Manage_Dataset_Module_Save_Probe_For_GUI(PathToSave,app)

if isfolder(PathToSave)
    % Prompt user for file save location and name
    [file, path] = uiputfile(fullfile(PathToSave,'*.mat'), 'Save as');
else
     % Prompt user for file save location and name
    [file, path] = uiputfile('*.mat', 'Save as');
end

if isequal(file,0) || isequal(path,0)
    disp('User canceled the operation.');
    return;
end

Savefilepath = fullfile(path,file);

DatatoSave.ChannelOrder = app.ChannelOrderField.Value;

if isempty(app.ActiveChannelField.Value{1})
    DatatoSave.ActiveChannel = 1:str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value);
else
    if length(str2double(strsplit(app.ActiveChannelField.Value{1},','))) > str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value)
        msgbox("Error: Number of active channel exceeds number of channel specified!")
        return;
    else
        DatatoSave.ActiveChannel = sort(str2double(strsplit(app.ActiveChannelField.Value{1},',')));
    end
end

DatatoSave.ChannelSpacing = app.ChannelSpacingumEditField.Value;

DatatoSave.NumberChannelRows = app.ChannelRowsDropDown.Value;

DatatoSave.NrChannel = app.NrChannelEditField.Value;
DatatoSave.HorizontalOffsetum = app.HorizontalOffsetumEditField.Value;
DatatoSave.VerticalOffsetum = app.VerticalOffsetumEditField.Value;
DatatoSave.VerticalOffsetum = app.VerticalOffsetumEditField.Value;

DatatoSave.SwitchTopBottomChannel = app.ReverseTopandBottomChannelNumberCheckBox.Value;
DatatoSave.SwitchLeftRightChannel = app.SwitchLeftandRightChannelNumberCheckBox.Value;
DatatoSave.FlipLoadedData = app.ReverseTopandBottomChannelNumberCheckBox_2.Value;

DatatoSave.OffSetRows = app.CheckBox.Value;
DatatoSave.ECoGArray = app.ECoGArrayCheckBox.Value;

if ~isempty(app.VerticalOffsetumEditField_2.Value)
    DatatoSave.OffSetRowsDistance = app.VerticalOffsetumEditField_2.Value;
else
    DatatoSave.OffSetRowsDistance = '0';
end

if ~isempty(app.ProbeTrajectoryInfo)
    if isfield(app.ProbeTrajectoryInfo,'AreaNamesLong')       
        DatatoSave.AreaNamesLong = app.ProbeTrajectoryInfo.AreaNamesLong;
        DatatoSave.AreaNamesShort = app.ProbeTrajectoryInfo.AreaNamesShort;
        DatatoSave.AreaTipDistance = app.ProbeTrajectoryInfo.AreaTipDistance;
    end
end

save(Savefilepath,"DatatoSave");

msgbox(strcat("Probe layout succesfully saved to: ",Savefilepath));
disp(strcat("Probe layout succesfully saved to: ",Savefilepath));