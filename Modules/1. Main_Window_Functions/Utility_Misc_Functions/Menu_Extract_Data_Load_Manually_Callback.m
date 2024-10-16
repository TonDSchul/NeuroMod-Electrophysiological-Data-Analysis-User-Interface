function Menu_Extract_Data_Load_Manually_Callback (app)

[file, path] = uigetfile('*.mat', 'Select a .mat file');
            
% Check if the user cancels the operation
if isequal(file,0) || isequal(path,0)
    disp('Operation canceled.');
    return;
end

Path = fullfile(path,file);

load(Path,'DatatoSave');

if ~isempty(DatatoSave)
    if ~isfield(DatatoSave,'ChannelSpacing') || ~isfield(DatatoSave,'ChannelOrder')
        disp(strcat("Saved probe information is empty or faulty and could not be loaded."));
        return;
    end
    if isempty(DatatoSave.ChannelSpacing)
        disp(strcat("Saved probe information is faulty and could not be loaded."));
        return;
    end

    app.Load_Data_Window_Info.ChannelSpacing = DatatoSave.ChannelSpacing;
    app.Load_Data_Window_Info.Channelorder = DatatoSave.ChannelOrder;
    
    if iscell(app.Load_Data_Window_Info.Channelorder)
        % convert cell in matrix
        app.Load_Data_Window_Info.Channelorder = str2double(strsplit(cell2mat(app.Load_Data_Window_Info.Channelorder),','));
    end

    disp(strcat("Saved probe information in ",Path ," succesfully loaded!"));
else
    if ~isfield(DatatoSave,'ChannelSpacing') || ~isfield(DatatoSave,'ChannelOrder')
        disp(strcat("Saved probe information is empty or faulty and could not be loaded."));
    end
end

%% Fill UI Text field accordingly

if ~isempty(app.Load_Data_Window_Info.Channelorder) && sum(isnan(app.Load_Data_Window_Info.Channelorder))==0
    texttoshow = sprintf('%d, ', app.Load_Data_Window_Info.Channelorder);
    % Remove the trailing comma and whitespace
    texttoshow(end-1:end) = [];

    if isempty(app.Load_Data_Window_Info.selectedFolder)
        app.TextArea_3.Value = ["ChannelOrder:";"";texttoshow];
    else
        app.TextArea_3.Value = ["Data Folder:";"";app.Load_Data_Window_Info.selectedFolder;"";"ChannelOrder:";"";texttoshow];
    end
else
    if isempty(app.Load_Data_Window_Info.selectedFolder)
        app.TextArea_3.Value = ["ChannelOrder:";"";"Not defined"];
    else
        app.TextArea_3.Value = ["Data Folder:";"";app.Load_Data_Window_Info.selectedFolder;"";"ChannelOrder:";"";"not defined"];
    end
end
