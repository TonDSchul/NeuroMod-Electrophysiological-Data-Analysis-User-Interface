function Menu_Extract_Data_Load_Manually_Callback (app, Window)

%________________________________________________________________________________________

%% This is the callback function executed when the user clicks on laoding a probe design manually (selecting folder themselves)

% This fucntion is executed when the user clicks on the Manually Select
% File menu option in the Extract Data Window

% Input:
% 1. app: app object of the extract data window to access the
% Load_Data_Window_Info variable which holds the loaded channel order and
% channelspacing 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

[file, path] = uigetfile('*.mat', 'Select a .mat file');
            
% Check if the user cancels the operation
if isequal(file,0) || isequal(path,0)
    disp('Operation canceled.');
    return;
end

Path = fullfile(path,file);

load(Path,'DatatoSave');

if isfield(app,'ActiveChannelField')
    app.ActiveChannelField.Value = '';
    app.ChannelOrderField.Value = '';
end

if ~isempty(DatatoSave)
    if ~isfield(DatatoSave,'ChannelSpacing') || ~isfield(DatatoSave,'ChannelOrder')
        disp(strcat("Saved probe information is empty or faulty and could not be loaded."));
        return;
    end
    if isempty(DatatoSave.ChannelSpacing)
        disp(strcat("Saved probe information is faulty and could not be loaded."));
        return;
    end

    app.ProbeInfoandPath .ChannelSpacing = DatatoSave.ChannelSpacing;
    app.ProbeInfoandPath .Channelorder = DatatoSave.ChannelOrder;
    app.ProbeInfoandPath .ActiveChannel = DatatoSave.ActiveChannel;
    app.ProbeInfoandPath .NrChannel = DatatoSave.NrChannel;
    app.ProbeInfoandPath .HorizontalOffsetum = DatatoSave.HorizontalOffsetum;
    app.ProbeInfoandPath .VerticalOffsetum = DatatoSave.VerticalOffsetum;
    app.ProbeInfoandPath .NumberChannelRows = DatatoSave.NumberChannelRows;

    app.ProbeInfoandPath.SwitchTopBottomChannel = double(DatatoSave.SwitchTopBottomChannel);
    app.ProbeInfoandPath.SwitchLeftRightChannel = double(DatatoSave.SwitchLeftRightChannel);
    app.ProbeInfoandPath.FlipLoadedData = double(DatatoSave.FlipLoadedData);
    
    app.ProbeInfoandPath .OffSetRows = DatatoSave.OffSetRows;
    app.ProbeInfoandPath .OffSetRowsDistance = DatatoSave.OffSetRowsDistance;
    
    if iscell(app.ProbeInfoandPath .Channelorder)
        % convert cell in matrix
        app.ProbeInfoandPath .Channelorder = str2double(strsplit(cell2mat(app.ProbeInfoandPath .Channelorder),','));
    end

    if iscell(app.ProbeInfoandPath .ActiveChannel)
        % convert cell in matrix
        app.ProbeInfoandPath .ActiveChannel = sort(str2double(strsplit(cell2mat(app.ProbeInfoandPath .ActiveChannel),',')));
    elseif ischar(app.ProbeInfoandPath .ActiveChannel)
        app.ProbeInfoandPath .ActiveChannel = sort(str2double(strsplit(app.ProbeInfoandPath .ActiveChannel,',')));
    end

    disp(strcat("Saved probe information in ",Path ," succesfully loaded!"));
else
    if ~isfield(DatatoSave,'ChannelSpacing') || ~isfield(DatatoSave,'ChannelOrder')
        disp(strcat("Saved probe information is empty or faulty and could not be loaded."));
    end
end

%% Fill UI Text field accordingly
if strcmp(Window,"Extract Data")

    NeoTextNoFolder = ["No folder or file selected to pass to NEO:";"";"Using the NeuralEnsemble NEO library to extract data from a raw recording. If using NEO for the first time, you are asked for a path to the python.exe in the environment you installed the package in. Please refer to the README how to install NEO and select the python.exe.";"";"First select a folder or file containing your recording data. Currently supported formats that can be loaded into NeuroMod using NEO include Neuralynx, Plexon, Open Ephys and Neuroexplorer recordings.";"";"**NOTE**";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software!";"";"After selecting a folder, it will be auto-searched for a suitable recording format. If it found one compatible with NEO, you can select it as the data extraction library to use. The 'Select Recording System' dropdown allows you to use NEO's format autodetection or directly use the format detection already done in Matlab (switch in case of incompatibilities).";"";"After Neo extracted data, it is saved in a newly created folder next to the recording folder to be loaded into NeuroMod. You can determine the format it is saved in (for further personal use) using the 'Format to Save and Read into Matlab' dropdown menu. Neo format .mat files are created using a function of NEO directly, while 'costum format' saves a .dat file for channel data and .mat file for meta – and event data. The next time you want to load a recording you already extracted, select the 'Load Already Saved Files' checkbox to skip data extraction with NEO and load the saved file immediately.";"";"After selecting a folder, specify probe information. Required fields are channel number and channel spacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"";"After setting the probe information you can start the data extraction.";"This opens a python console prompt window showing the progress of data extraction. If something should not work, activate the 'Keep Console Open' checkbox to see potential error messages (and make sure to press enter in the console after the python script finished!). If the folder should NOT contain a suitable recording, you are being informed about it here."];
    NeoTextWithFolder = ["Using the NeuralEnsemble Neo library to extract data from a raw recording. If using NEO for the first time, you are asked for a path to the python.exe in the environment you installed Neo in. Please refer to the README how to install NEO and select the python.exe.";"";"**NOTE**";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software!";"";"After selecting a folder, it will be auto-searched for a suitable recording format. If it found one compatible with NEO, you can select it as the data extraction library to use. The 'Select Recording System' dropdown allows you to use NEO's format autodetection or directly use the format detection already done in Matlab (switch in case of incompatibilities).";"";"After Neo extracted data, it is saved in a newly created folder next to the recording folder to be loaded into NeuroMod. You can determine the format it is saved in (for further personal use) using the 'Format to Save and Read into Matlab' dropdown menu. Neo format .mat files are created using a function of NEO directly, while 'costum format' saves a .dat file for channel data and .mat file for meta – and event data. The next time you want to load a recording you already extracted, select the 'Load Already Saved Files' checkbox to skip data extraction with NEO and load the saved file immediately.";"";"After selecting a folder, specify probe information. Required fields are channel number and channel spacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"";"After setting the probe information you can start the data extraction.";"This opens a python console prompt window showing the progress of data extraction. If something should not work, activate the 'Keep Console Open' checkbox to see potential error messages (and make sure to press enter in the console after the python script finished!). If the folder should NOT contain a suitable recording, you are being informed about it here."];
     
    MatlabTextNoFolder = ["No folder or file selected to pass to Matlab:";"";"Please select a folder containing your recording data. Supported are formats recorded with the Open Ephys GUI, Intan RHX data acquisition software (and legacy RHD software), Spike2 as well as Neuralynx Cheetah and Tucker Davis (TDT) recordings. This includes binary, .nwb and Open Ephys data formats from the Open Ephys GUI recorded with Neuropixels, Open Ephys and Intan acquisition boards; .dat and .rhd files from the Intan RHX and RHD software; .smrx files from Spike2, .ncs (and accompanying) Neuralynx files from Chetaah and .sev (and accompanying) files for TDT recordings. Folder contents, file types and recording system will be shown automatically if folder contains one of the supported file types.";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software OR this GUI!";"";"After selecting a folder, specify probe information. Required fields are channel number and channelspacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"After setting the probe information you can start the data extraction.";"";"Note: For Open Ephys data the expected folder structure is Date/Record Node/experiment/recordings/.... Multiple recordings within the same sessions can be concatonated or loaded individually. Please make sure only one recording session is present in the selected file, independent of the file format and recording system!"];
    MatlabTextWithFolder = ["Folder contents, file types and recording system will be shown automatically if folder contains one of the supported file types.";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software OR this GUI!";"";"After selecting a folder, specify probe information. Required fields are channel number and channelspacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"After setting the probe information you can start the data extraction.";"";"Note: For Open Ephys data the expected folder structure is Date/Record Node/experiment/recordings/.... Multiple recordings within the same sessions can be concatonated or loaded individually. Please make sure only one recording session is present in the selected file, independent of the file format and recording system!"];

    % 
    if ~isempty(app.ProbeInfoandPath .Channelorder) && sum(isnan(app.ProbeInfoandPath .Channelorder))==0

        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",app.ProbeInfoandPath .NrChannel);strcat("Channel Spacing: ",app.ProbeInfoandPath .ChannelSpacing);strcat("Nr Channel Rows: ",app.ProbeInfoandPath .NumberChannelRows);"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(app.ProbeInfoandPath.OffSetRows));strcat("Nr Active Channel: ",num2str(length(app.ProbeInfoandPath .ActiveChannel)))];

        if isempty(app.ProbeInfoandPath.selectedFolder)
            if strcmp(app.RecordingSystemDropDown_2.Value,"NeuralEnsemble NEO Python Library")
                ProbeInfoText = [NeoTextNoFolder;"";ProbeInfoText];
            else
                ProbeInfoText = [MatlabTextNoFolder;"";ProbeInfoText];
            end
            app.TextArea.Value = ProbeInfoText;
        else
            if strcmp(app.RecordingSystemDropDown_2.Value,"NeuralEnsemble NEO Python Library")
                app.TextArea.Value = ["Path to recording folder that is passed to NEO";"";app.ProbeInfoandPath.selectedFolder;"";NeoTextWithFolder;"";ProbeInfoText];
            else
                app.TextArea.Value = ["Path to recording folder that is passed to Matlab";"";app.ProbeInfoandPath.selectedFolder;"";MatlabTextWithFolder;"";ProbeInfoText];
            end
        end
    else
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",app.ProbeInfoandPath .NrChannel);strcat("Channel Spacing: ",app.ProbeInfoandPath .ChannelSpacing);strcat("Nr Channel Rows: ",app.ProbeInfoandPath .NumberChannelRows);"Costum Channel Order: No";strcat("Offset Every Second Row: ",num2str(app.ProbeInfoandPath.OffSetRows));strcat("Nr Active Channel: ",num2str(length(app.ProbeInfoandPath .ActiveChannel)))];

        if isempty(app.ProbeInfoandPath.selectedFolder)
            if strcmp(app.RecordingSystemDropDown_2.Value,"NeuralEnsemble NEO Python Library")
                ProbeInfoText = [NeoTextNoFolder;"";ProbeInfoText];
            else
                ProbeInfoText = [MatlabTextNoFolder;"";ProbeInfoText];
            end
            app.TextArea.Value = ProbeInfoText;
        else
            if strcmp(app.RecordingSystemDropDown_2.Value,"NeuralEnsemble NEO Python Library")
                app.TextArea.Value = ["Path to recording folder that is passed to NEO";"";app.ProbeInfoandPath.selectedFolder;"";NeoTextWithFolder;"";ProbeInfoText];
            else
                app.TextArea.Value = ["Path to recording folder that is passed to Matlab";"";app.ProbeInfoandPath.selectedFolder;"";MatlabTextWithFolder;"";ProbeInfoText];
            end
        end
    end
end

if strcmp(Window,"ProbeLayout")
    
    if str2double(app.ProbeInfoandPath.NumberChannelRows) == 2
        app.SwitchLeftandRightChannelNumberCheckBox.Enable = "on";
        app.HorizontalOffsetumEditField.Enable = "on";
        app.VerticalOffsetumEditField.Enable = "on";
    else
        app.SwitchLeftandRightChannelNumberCheckBox.Enable = "off";
        app.HorizontalOffsetumEditField.Enable = "off";
        app.VerticalOffsetumEditField.Enable = "off";

        app.SwitchLeftandRightChannelNumberCheckBox.Value = 0;
        app.HorizontalOffsetumEditField.Value = "0";
        app.VerticalOffsetumEditField.Value = "0";
    end

    %channel order
    if ~isempty(app.ProbeInfoandPath .Channelorder) && sum(isnan(app.ProbeInfoandPath .Channelorder))==0
        texttoshow = sprintf('%d, ', app.ProbeInfoandPath .Channelorder);
        % Remove the trailing comma and whitespace
        texttoshow(end-1:end) = [];
        app.ChannelOrderField.Value = texttoshow;
    else
        app.ChannelOrderField.Value = '';
    end
    %Active Channel
    if ~isempty(app.ProbeInfoandPath .ActiveChannel) && sum(isnan(app.ProbeInfoandPath .ActiveChannel))==0
        texttoshow = sprintf('%d, ', app.ProbeInfoandPath .ActiveChannel);
        % Remove the trailing comma and whitespace
        texttoshow(end-1:end) = [];
        app.ActiveChannelField.Value = texttoshow;
    else
        app.ActiveChannelField.Value = '';
    end

    app.NrChannelEditField.Value = app.ProbeInfoandPath .NrChannel;
    app.ChannelSpacingumEditField.Value = app.ProbeInfoandPath .ChannelSpacing;
    app.ProbeInfoandPath .ActiveChannel = sort(DatatoSave.ActiveChannel);
    app.HorizontalOffsetumEditField.Value = app.ProbeInfoandPath .HorizontalOffsetum;
    app.VerticalOffsetumEditField.Value = app.ProbeInfoandPath .VerticalOffsetum;
    app.ChannelRowsDropDown.Value = app.ProbeInfoandPath .NumberChannelRows;

    app.ReverseTopandBottomChannelNumberCheckBox.Value = app.ProbeInfoandPath.SwitchTopBottomChannel;
    app.SwitchLeftandRightChannelNumberCheckBox.Value = app.ProbeInfoandPath.SwitchLeftRightChannel;
    app.ReverseTopandBottomChannelNumberCheckBox_2.Value = app.ProbeInfoandPath.FlipLoadedData;

    app.CheckBox.Value = app.ProbeInfoandPath.OffSetRows;
    app.VerticalOffsetumEditField_2.Value = app.ProbeInfoandPath.OffSetRowsDistance;

    if str2double(app.ProbeInfoandPath .NrChannel)<32
        app.FirstZoomChannel = 1;
    else
        app.FirstZoomChannel = str2double(app.ProbeInfoandPath .NrChannel)-31;
    end

    if isempty(app.ActiveChannelField.Value{1})
        ActiveChannel = 1:str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value);
    else
        ActiveChannel = str2double(strsplit(app.ActiveChannelField.Value{1},','));
    end

    if app.ReverseTopandBottomChannelNumberCheckBox.Value == 1 && str2double(app.ChannelRowsDropDown.Value) == 2
        ActiveChannel = (str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value)+1)-ActiveChannel;
        oddIndices = find(mod(ActiveChannel, 2) == 1);
        evenIndices = find(mod(ActiveChannel, 2) == 0);
        ActiveChannel(oddIndices) = ActiveChannel(oddIndices)+1;
        ActiveChannel(evenIndices) = ActiveChannel(evenIndices)-1;
    elseif app.ReverseTopandBottomChannelNumberCheckBox.Value == 1 && str2double(app.ChannelRowsDropDown.Value) == 1
        ActiveChannel = (str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value)+1)-ActiveChannel;
    end

    if isfield(app.ProbeTrajectoryInfo,'AreaNamesLong')
        BrainAreaInfo = app.ProbeTrajectoryInfo;
    else
        BrainAreaInfo = [];
    end

    Utility_Plot_Interactive_Probe_View(app.UIAxes,str2double(app.ChannelSpacingumEditField.Value),str2double(app.NrChannelEditField.Value),str2double(app.ChannelRowsDropDown.Value),str2double(app.HorizontalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField.Value),app.ChannelOrderField.Value,ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,ActiveChannel,app.ShowChannelSpacingCheckBox.Value,1,1,[],app.CheckBox.Value,[],app.ProbeInfoandPath.SwitchTopBottomChannel,app.ProbeInfoandPath.SwitchLeftRightChannel)

    if ~isempty(app.NrChannelEditField.Value) && ~isempty(app.ChannelSpacingumEditField.Value)
        %% Initiate Callback
        if isempty(app.UIAxes.ButtonDownFcn)
            app.UIAxes.ButtonDownFcn = @(src1, event1) ProbeViewClickCallback(app, event1);
        end    
    
        % Add ButtonDownFcn to each line object in UIAxis
        lines = findobj(app.UIAxes, 'Type', 'line');
        
        % Add ButtonDownFcn to each line object in UIAxis
        ChannelViewRight = findobj(app.UIAxes,'Tag','ChannelViewRight');
    
        % Add ButtonDownFcn to each line object in UIAxis
        ChannelViewLeft = findobj(app.UIAxes,'Tag','ChannelViewLeft');
    
        % Add ButtonDownFcn to each line object in UIAxis
        GrayProbeFilling = findobj(app.UIAxes,'Tag','GrayProbeFilling');
            
        %% Set the ButtonDownFcn for UIAxes to register clicks on a plotted line directly
        % lines plotted
        for i = 1:numel(lines)
            % Call Lineclicked function if that happens
            lines(i).ButtonDownFcn = @(src1, event1) ProbeViewClickLineCallback(app, event1);
        end
    
        % Channel squares on the right
        for i = 1:numel(ChannelViewRight)
            % Call Lineclicked function if that happens
            ChannelViewRight(i).ButtonDownFcn = @(src1, event1) ProbeViewClickLineCallback(app, event1);
        end
        % Channel squares on the left
        for i = 1:numel(ChannelViewLeft)
            % Call Lineclicked function if that happens
            ChannelViewLeft(i).ButtonDownFcn = @(src1, event1) ProbeViewClickLineCallback(app, event1);
        end
        % Channel squares on the left
        for i = 1:numel(GrayProbeFilling)
            % Call Lineclicked function if that happens
            GrayProbeFilling(i).ButtonDownFcn = @(src1, event1) ProbeViewClickLineCallback(app, event1);
        end

        %% Create Legend
        % Create a dummy red line plot for the legend
        dummyLine = plot(app.UIAxes2, NaN, NaN, 'Color', 'red', 'LineWidth', 2);
        
        % Create a dummy yellow rectangle using a patch for the legend
        dummyRect = patch(app.UIAxes2, NaN, NaN, 'yellow', 'EdgeColor', 'none');
        
        % Create the legend and position it at the center of the plot
        legend(app.UIAxes2, [dummyLine, dummyRect], {'All Active Channel', 'Currently Active Channel'}, 'AutoUpdate', 'off');
        
        % Position the legend in the middle of the figure (over the entire figure size)
        legendPosition = [0.6, 0.9, 0.15, 0.04]; % x, y, width, height (normalized)
        set(app.UIAxes2.Legend, 'Position', legendPosition);
        
    end

end
