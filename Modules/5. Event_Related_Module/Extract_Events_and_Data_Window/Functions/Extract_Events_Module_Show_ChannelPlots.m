function Extract_Events_Module_Show_ChannelPlots(Channel,Folder,app,RHDAllChannelData,Type)

%________________________________________________________________________________________
%% Function to plot event data of a selected event channel 
% this function searches on startup through possible events and polots data
% for the first event channel found. Otherwise it plots/returns info that
% no data found for specified channel

% gets called when the user clicks on "Show Input Channel Plots" in the
% extract data windiw and opens the Show_Event_Channel_Window app.

% Inputs: 
% 1.Channel: type of event file to look for; for Intan: "Digital
% Inputs" or "Analog Input" or "AUX"
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.
% 2. Folder: path to folder holding event recordings as char
% 3. app: Show_Event_Channel_Window app object
% 4. RHDAllChannelData: NOTE!! ONLY IF .RHD file format analyzed! saves field
% RHDAllChannelData.board_dig_in_data containing event data (NOTE!! as a nevents x ntime matrix), since the file had
% to be loaded earlier already to know what can be shown as otions in the
% GUI. --> not as nicely doable as with individual .dat files for each
% event
% 5. Type: Determines if this function is executed on Show_Event_Channel_Window startup. If yes, additional infos are loaded. 
% If no, This has to be some other string to only extract necessary information

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% For Intan .dat files (one per channel)
if strcmp(app.Mainapp.Data.Info.RecordingType,"IntanDat") && strcmp(Channel,"Digital Inputs")
    
    if strcmp(Type,"Initial")

        [~,~,~,~,InfoRhd,~] = LoadIntanDatFiles(app.Mainapp.Data.Info.Data_Path);
        % Load Rhd Info file
        [~,~,~,~,~,~,~,~,~,app.EventChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);

        app.FileTypeDropDown_2.Items = app.EventChannelNames.Digital;
        
        app.FileTypeDropDown.Value = "Digital Inputs";
    end
    %% Load Files in folder

    for i = 1:length(app.EventChannelNames.Digital)
        if strcmp(app.EventChannelNames.Digital{i},app.FileTypeDropDown_2.Value)
            InputChannelSelection = i;
        end
    end

    [DatFilePaths,~,~,~,~,~] = LoadIntanDatFiles(Folder);

    FileIdentifier = fopen(DatFilePaths{app.EWapp.EventInfo.DIChannel(InputChannelSelection)},'r');
    
    InputChannelData = fread(FileIdentifier, 'uint16');

    InputChannelData = single(InputChannelData); %analog input to Volt (not mV!)

    lineHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Events');

    xlabel(app.UIAxes,"Time [s]")
    ylabel(app.UIAxes,"Digital Signal")
    ylim(app.UIAxes,[0,1.5]);
    title(app.UIAxes,strcat("Digital Input Channel ", num2str(InputChannelSelection)))
    if isempty(lineHandles)
        plot(app.UIAxes,app.Mainapp.Data.Time,InputChannelData,'LineWidth',1.5,'Color','b', 'Tag', 'Events');
    elseif length(lineHandles) == 1
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', InputChannelData, 'Color', 'b', 'Tag', 'Events');
    else
        delete(lineHandles(2:end))
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', InputChannelData, 'Color', 'b', 'Tag', 'Events');
    end
    
    return;
    
end

if strcmp(app.Mainapp.Data.Info.RecordingType,"IntanDat") && strcmp(Channel,"Analog Input")
    
    if strcmp(Type,"Initial")
        [~,~,~,~,InfoRhd,~] = LoadIntanDatFiles(app.Mainapp.Data.Info.Data_Path);
        % Load Rhd Info file
        [~,~,~,~,~,~,~,~,~,app.EventChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);

        app.FileTypeDropDown_2.Items = app.EventChannelNames.Analog;
        
        app.FileTypeDropDown.Value = "Analog Input";
    end
    %% Load Files in folder

    for i = 1:length(app.EventChannelNames.Analog)
        if strcmp(app.EventChannelNames.Analog{i},app.FileTypeDropDown_2.Value)
            InputChannelSelection = i;
        end
    end

    [DatFilePaths,~,~,~,~,~] = LoadIntanDatFiles(Folder);

    FileIdentifier = fopen(DatFilePaths{app.EWapp.EventInfo.ADCChannel(InputChannelSelection)},'r');
    
    InputChannelData = fread(FileIdentifier, 'uint16');

    InputChannelData = single(InputChannelData.* 0.000050354); %analog input to Volt (not mV!)

    lineHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Events');
    xlabel(app.UIAxes,"Time [s]")
    ylabel(app.UIAxes,"Analog Signal")
    title(app.UIAxes,strcat("Analog Input Channel ", num2str(InputChannelSelection)))
    if isempty(lineHandles)
        plot(app.UIAxes,app.Mainapp.Data.Time,InputChannelData,'LineWidth',1.5,'Color','b', 'Tag', 'Events');
    elseif length(lineHandles) == 1
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', InputChannelData, 'Color', 'b', 'Tag', 'Events');
    else
        delete(lineHandles(2:end))
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', InputChannelData, 'Color', 'b', 'Tag', 'Events');
    end
    
    return;

end

if strcmp(app.Mainapp.Data.Info.RecordingType,"IntanDat") && strcmp(Channel,"AUX Inputs")
    
    if strcmp(Type,"Initial")
        [~,~,~,~,InfoRhd,~] = LoadIntanDatFiles(app.Mainapp.Data.Info.Data_Path);
        % Load Rhd Info file
        [~,~,~,~,~,~,~,~,~,app.EventChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);

        app.FileTypeDropDown_2.Items = app.EventChannelNames.Aux;
    
        app.FileTypeDropDown.Value = "AUX Inputs";
    end
    %% Load Files in folder

    for i = 1:length(app.EventChannelNames.Aux)
        if strcmp(app.EventChannelNames.Aux{i},app.FileTypeDropDown_2.Value)
            InputChannelSelection = i;
        end
    end

    [DatFilePaths,~,~,~,~,~] = LoadIntanDatFiles(Folder);
    FileIdentifier = fopen(DatFilePaths{app.EWapp.EventInfo.AUXChannel(InputChannelSelection)},'r');
    
    InputChannelData = fread(FileIdentifier, 'uint16');

    InputChannelData = single(InputChannelData.* 0.0000374); %analog input to Volt (not mV!)

    lineHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Events');
    xlabel(app.UIAxes,"Time [s]")
    ylabel(app.UIAxes,"Aux Signal")
    title(app.UIAxes,strcat("Aux Input Channel ", num2str(InputChannelSelection)))
    if isempty(lineHandles)
        plot(app.UIAxes,app.Mainapp.Data.Time,InputChannelData,'LineWidth',1.5,'Color','b', 'Tag', 'Events');
    elseif length(lineHandles) == 1
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', InputChannelData, 'Color', 'b', 'Tag', 'Events');
    else
        delete(lineHandles(2:end))
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', InputChannelData, 'Color', 'b', 'Tag', 'Events');
    end

    return;

end

%% For Single Intan RHD Files

%% Extract Event Channel Data and Plot
if strcmp(app.Mainapp.Data.Info.RecordingType,"IntanRHD") && strcmp(Channel,"Digital Inputs")
    
    if strcmp(Type,"Initial")
         [RhdFilePaths] = LoadIntanRHDFiles(app.Mainapp.Data.Info.Data_Path);
         LastDashIndex = find(RhdFilePaths == '\');
         RHDPath = RhdFilePaths(1:LastDashIndex(end));
         RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
         [~,~,~,~,~,~,~,~,~,app.EventChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Info",[]);

         app.FileTypeDropDown_2.Items = app.EventChannelNames.Digital;
        
         app.FileTypeDropDown.Value = "Digital Inputs";
    end

    for i = 1:length(app.EventChannelNames.Digital)
        if strcmp(app.EventChannelNames.Digital{i},app.FileTypeDropDown_2.Value)
            InputChannelSelection = i;
        end
    end

    lineHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Events');
    xlabel(app.UIAxes,"Time [s]")
    ylim(app.UIAxes,[0,1.5]);
    ylabel(app.UIAxes,"Digital Signal")
    title(app.UIAxes,strcat("Digital Input Channel ", num2str(InputChannelSelection)))
    
    if isempty(lineHandles)
        plot(app.UIAxes,app.Mainapp.Data.Time,RHDAllChannelData.board_dig_in_data(InputChannelSelection,:),'LineWidth',1.5,'Color','b', 'Tag', 'Events');
    elseif length(lineHandles) == 1
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', RHDAllChannelData.board_dig_in_data(InputChannelSelection,:), 'Color', 'b', 'Tag', 'Events');
    else
        delete(lineHandles(2:end))
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', RHDAllChannelData.board_dig_in_data(InputChannelSelection,:), 'Color', 'b', 'Tag', 'Events');
    end 

    return;
    
end

if strcmp(app.Mainapp.Data.Info.RecordingType,"IntanRHD") && strcmp(Channel,"Analog Input")
    
    if strcmp(Type,"Initial")
        [RhdFilePaths] = LoadIntanRHDFiles(app.Mainapp.Data.Info.Data_Path);
         LastDashIndex = find(RhdFilePaths == '\');
         RHDPath = RhdFilePaths(1:LastDashIndex(end));
         RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
         [~,~,~,~,~,~,~,~,~,app.EventChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Info",[]);

         app.FileTypeDropDown_2.Items = app.EventChannelNames.Analog;
        
        app.FileTypeDropDown.Value = "Analog Input";
    end

    for i = 1:length(app.EventChannelNames.Analog)
        if strcmp(app.EventChannelNames.Analog{i},app.FileTypeDropDown_2.Value)
            InputChannelSelection = i;
        end
    end

    %% Load Files in folder

    lineHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Events');
    xlabel(app.UIAxes,"Time [s]")
    ylabel(app.UIAxes,"Analog Signal")
    title(app.UIAxes,strcat("Analog Input Channel ", num2str(InputChannelSelection)))
    if isempty(lineHandles)
        plot(app.UIAxes,app.Mainapp.Data.Time,RHDAllChannelData.board_adc_data(InputChannelSelection,:),'LineWidth',1.5,'Color','b', 'Tag', 'Events');
    elseif length(lineHandles) == 1
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', RHDAllChannelData.board_adc_data(InputChannelSelection,:), 'Color', 'b', 'Tag', 'Events');
    else
        delete(lineHandles(2:end))
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', RHDAllChannelData.board_adc_data(InputChannelSelection,:), 'Color', 'b', 'Tag', 'Events');
    end 

    return;

end

if strcmp(app.Mainapp.Data.Info.RecordingType,"IntanRHD") && strcmp(Channel,"AUX Inputs")
    
    [RhdFilePaths] = LoadIntanRHDFiles(app.Mainapp.Data.Info.Data_Path);
     LastDashIndex = find(RhdFilePaths == '\');
     RHDPath = RhdFilePaths(1:LastDashIndex(end));
     RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
     [~,~,~,~,~,~,~,~,~,app.EventChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Info",[]);

     app.FileTypeDropDown_2.Items = app.EventChannelNames.Aux;

    app.FileTypeDropDown.Value = "AUX Inputs";

    for i = 1:length(app.EventChannelNames.Aux)
        if strcmp(app.EventChannelNames.Aux{i},app.FileTypeDropDown_2.Value)
            InputChannelSelection = i;
        end
    end

    lineHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Events');
    xlabel(app.UIAxes,"Time [s]")
    ylabel(app.UIAxes,"Aux Signal")
    title(app.UIAxes,strcat("Aux Input Channel ", num2str(InputChannelSelection)))
    if isempty(lineHandles)
        plot(app.UIAxes,app.Mainapp.Data.Time,RHDAllChannelData.aux_input_data(InputChannelSelection,:),'LineWidth',1.5,'Color','b', 'Tag', 'Events');
    elseif length(lineHandles) == 1
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', RHDAllChannelData.aux_input_data(InputChannelSelection,:), 'Color', 'b', 'Tag', 'Events');
    else
        delete(lineHandles(2:end))
        set(lineHandles(1), 'XData', app.Mainapp.Data.Time, 'YData', RHDAllChannelData.aux_input_data(InputChannelSelection,:), 'Color', 'b', 'Tag', 'Events');
    end 
    return;

end

% After each plot return is called. So if the code reaches to
% here, nothin was found to be plotted
f = msgbox("No Input Channel found for this recording!");