function Menu_Extract_Data_Load_Manually_Callback (app)

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
    app.Load_Data_Window_Info.ActiveChannel = sort(DatatoSave.ActiveChannel);
    app.Load_Data_Window_Info.NrChannel = DatatoSave.NrChannel;
    app.Load_Data_Window_Info.HorizontalOffsetum = DatatoSave.HorizontalOffsetum;
    app.Load_Data_Window_Info.VerticalOffsetum = DatatoSave.VerticalOffsetum;
    app.Load_Data_Window_Info.NumberChannelRows = DatatoSave.NumberChannelRows;
    
    if iscell(app.Load_Data_Window_Info.Channelorder)
        % convert cell in matrix
        app.Load_Data_Window_Info.Channelorder = str2double(strsplit(cell2mat(app.Load_Data_Window_Info.Channelorder),','));
    end

    if iscell(app.Load_Data_Window_Info.ActiveChannel)
        % convert cell in matrix
        app.Load_Data_Window_Info.ActiveChannel = sort(str2double(strsplit(cell2mat(app.Load_Data_Window_Info.ActiveChannel),',')));
    end

    disp(strcat("Saved probe information in ",Path ," succesfully loaded!"));
else
    if ~isfield(DatatoSave,'ChannelSpacing') || ~isfield(DatatoSave,'ChannelOrder')
        disp(strcat("Saved probe information is empty or faulty and could not be loaded."));
    end
end

%% Fill UI Text field accordingly
if strcmp(Window,"Extract Data")
    % CHannelorder
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
end

if strcmp(Window,"ProbeLayout")

    %channel order
    if ~isempty(app.Load_Data_Window_Info.Channelorder) && sum(isnan(app.Load_Data_Window_Info.Channelorder))==0
        texttoshow = sprintf('%d, ', app.Load_Data_Window_Info.Channelorder);
        % Remove the trailing comma and whitespace
        texttoshow(end-1:end) = [];
        app.ChannelOrderFormat1234LeaveemptyfornocostumorderEditField.Value = texttoshow;
    end
    %Active Channel
    if ~isempty(app.Load_Data_Window_Info.ActiveChannel) && sum(isnan(app.Load_Data_Window_Info.ActiveChannel))==0
        texttoshow = sprintf('%d, ', app.Load_Data_Window_Info.ActiveChannel);
        % Remove the trailing comma and whitespace
        texttoshow(end-1:end) = [];
        app.ActiveChannelField.Value = texttoshow;
    end

    app.NrChannelEditField.Value = app.Load_Data_Window_Info.NrChannel;
    app.ChannelSpacingumEditField.Value = app.Load_Data_Window_Info.ChannelSpacing;
    app.Load_Data_Window_Info.ActiveChannel = sort(DatatoSave.ActiveChannel);
    app.HorizontalOffsetumEditField.Value = app.Load_Data_Window_Info.HorizontalOffsetum;
    app.VerticalOffsetumEditField.Value = app.Load_Data_Window_Info.VerticalOffsetum;
    app.ChannelRowsDropDown.Value = app.Load_Data_Window_Info.NumberChannelRows;

    Utility_Plot_Interactive_Probe_View(app.UIAxes,str2double(app.ChannelSpacingumEditField.Value),str2double(app.NrChannelEditField.Value),str2double(app.ChannelRowsDropDown.Value),str2double(app.HorizontalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField.Value),app.ChannelOrderFormat1234LeaveemptyfornocostumorderEditField.Value,app.ActiveChannelField.Value,app.FirstZoomChannel,1)

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
        
    end

end
