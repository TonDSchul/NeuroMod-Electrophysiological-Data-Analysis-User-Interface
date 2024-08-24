function Extract_Events_Module_Show_ChannelPlots(Data,Channel,Folder,app,RHDAllChannelData,Type,DownsampleRate)

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
if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD")
    if ~isempty(Channel)
        if strcmp(Data.Info.RecordingType,"IntanDat")
            [FilePaths,~,EventInfo,~,InfoRhd,~] = CheckIntanDatFiles(Folder);
            % Load Rhd Info file
            if isempty(app.EventChannelNames)
                [~,~,~,~,~,~,~,~,~,app.EventChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
            end
        elseif strcmp(Data.Info.RecordingType,"IntanRHD")
            if strcmp(Channel,"DINChannel") || strcmp(Channel,"DIChannel")
                RHDData = RHDAllChannelData.board_dig_in_data;
            elseif strcmp(Channel,"ADCChannel")
                RHDData = RHDAllChannelData.board_adc_data;
            elseif strcmp(Channel,"AUXChannel")
                RHDData = RHDAllChannelData.aux_input_data;
            end

            [RHDFilePaths] = LoadIntanRHDFiles(Folder);

            LastDashIndex = find(RHDFilePaths == '\');
            RHDPath = RHDFilePaths(1:LastDashIndex(end));
            RHDFiles = RHDFilePaths(LastDashIndex(end)+1:end);
            
            FilePaths = RHDPath;
            
            if isempty(RHDAllChannelData)
                [~,~,~,~,ChannelNameStructure,~,~,~,NumChannel] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Extracting",[]);
            else
                [~,~,~,~,ChannelNameStructure,~,~,~,NumChannel] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"NumChannel",[]);
            end

            if NumChannel.num_board_adc_channels == 0 && NumChannel.num_board_dig_in_channels == 0 && NumChannel.aux_input_channels == 0
                msgbox("Warning: No event data found in folder the dataset was extracted from. Please select a different folder.");
                return;
            end

            EventInfo = [];
            RHDEventChannelNames = cell(1,length(ChannelNameStructure));
            
            for p = 1:length(ChannelNameStructure)
                if strfind(ChannelNameStructure(p).native_channel_name,"DIGITAL")
                    app.EventChannelNames.Digital{p} = ChannelNameStructure(p).custom_channel_name;
                    if NumChannel.num_board_dig_in_channels > 0 && ~isfield(EventInfo,'DIChannel')
                        EventInfo.DIChannel = 1:NumChannel.num_board_dig_in_channels;
                    end                    
                elseif strfind(ChannelNameStructure(p).native_channel_name,"ADC")
                    app.EventChannelNames.Analog{p} = ChannelNameStructure(p).custom_channel_name;
                    if NumChannel.num_board_adc_channels > 0 && ~isfield(EventInfo,'ADCChannel')
                        EventInfo.ADCChannel = 1:NumChannel.num_board_dig_in_channels;
                    end
                elseif strfind(ChannelNameStructure(p).native_channel_name,"AUX")
                    app.EventChannelNames.Aux{p} = ChannelNameStructure(p).custom_channel_name;
                    if NumChannel.aux_input_channels > 0 && ~isfield(EventInfo,'AUXChannel')
                        EventInfo.AUXChannel = 1:NumChannel.aux_input_channels;
                    end  
                end
            end
        end
                
        if strcmp(Channel,"DIChannel")
            app.FileTypeDropDown_2.Items = app.EventChannelNames.Digital;
            app.FileTypeDropDown.Value = "Digital Inputs";
            ModifiedEventInfo = EventInfo.DIChannel;
        elseif strcmp(Channel,"ADCChannel")
            app.FileTypeDropDown_2.Items = app.EventChannelNames.Analog;
            app.FileTypeDropDown.Value = "Analog Inputs";
            ModifiedEventInfo = EventInfo.ADCChannel;
        elseif strcmp(Channel,"AUXChannel")
            app.FileTypeDropDown_2.Items = app.EventChannelNames.Aux;
            app.FileTypeDropDown.Value = "AUX Inputs";
            ModifiedEventInfo = EventInfo.AUXChannel;
        elseif strcmp(Channel,"DINChannel")
            app.FileTypeDropDown_2.Items = app.EventChannelNames.Digital;
            app.FileTypeDropDown.Value = "DIN Inputs";
            ModifiedEventInfo = EventInfo.DINChannel;
        end

        Extract_Events_Module_Load_and_Plot_Events_Intan(ModifiedEventInfo,FilePaths,app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown_2.Items,Data,RHDData,DownsampleRate);
    
    else
        msgbox("No Input Channel found for this recording!");
    end
end

if strcmp(Data.Info.RecordingType,"Open Ephys")

    IsNodeAvailable = 0;
    for i = 1:length(Channel.Info.AvailabelNodes)
        if Channel.Info.AvailabelNodes{i} == Channel.SelectedLineNode
            IsNodeAvailable = i;
            break;
        end
    end

    if IsNodeAvailable ~= 0
        EventInfotoShow = app.EWapp.EventInfo{IsNodeAvailable};
    else
        msgbox("Selected Node contains no events!");
        return;
    end

    SelectedLineIndicies = EventInfotoShow.line == Channel.LineNumbers;

    if isprop(EventInfotoShow,'sample_number')
        sampleNumber = EventInfotoShow.sample_number;
    elseif isprop(EventInfotoShow,'sampleNumber')
        sampleNumber = EventInfotoShow.sampleNumber;
    else
        for nprops = 1:length(EventInfotoShow.Properties.VariableNames)
            if ~isempty(strfind(EventInfotoShow.Properties.VariableNames{nprops},'sample'))
                fieldname = EventInfotoShow.Properties.VariableNames{nprops};
                sampleNumber = eval(strcat('EventInfotoShow.',fieldname));
            end
        end
    end

    SampleNumber = sampleNumber(SelectedLineIndicies==1);
    
    zerosample = SampleNumber == 0;

    if sum(zerosample)>0
        msgbox("Warning: Sample Nr 0 found and deleted");
        SampleNumber(zerosample==1) = [];
    end

    % Include a specific duration of the event to make it clearly visible
    % -- 2ms standard
    Numsamplesevent = Data.Info.NativeSamplingRate*0.002;

    EventData = zeros(1,length(Data.Time));

    % Just one sample would be visibly different to others. This can be
    % hard to see so I add 1ms to the right of the trigger 
    for i = 1:length(SampleNumber)
        if SampleNumber(i)+Numsamplesevent<=length(EventData)
            EventData(SampleNumber(i):SampleNumber(i)+Numsamplesevent) = 1;
        elseif SampleNumber(i)+Numsamplesevent>length(EventData)
            EventData(1:end) = 1;
        end
    end

    Extract_Events_Module_Load_and_Plot_Events_Intan(EventData,[],app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown.Value,Data,[],DownsampleRate)
    
end


if strcmp(Data.Info.RecordingType,"Neuralynx")

    EventData = zeros(1,length(Data.Time));
    EventData(Channel.Samples{1}) = 1;

    % Include a specific duration of the event to make it clearly visible
    % -- 2ms standard
    Numsamplesevent = Data.Info.NativeSamplingRate*0.002;
    % Just one sample would be visibly different to others. This can be
    % hard to see so I add 1ms to the right of the trigger 
    for i = 1:length(Channel.Samples{1})
        if Channel.Samples{1}(i)+Numsamplesevent<=length(EventData)
            EventData(Channel.Samples{1}(i):Channel.Samples{1}(i)+Numsamplesevent) = 1;
        elseif Channel.Samples{1}(i)+Numsamplesevent>length(EventData)
            EventData(Channel.Samples{1}(i):end) = 1;
        end
    end

    Extract_Events_Module_Load_and_Plot_Events_Intan(EventData,[],app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown.Value,Data,[],DownsampleRate)
    

end
                