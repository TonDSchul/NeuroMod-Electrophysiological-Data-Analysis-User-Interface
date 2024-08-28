function [DIChannel,ADCChannel,AUXChannel,AllChannel,FoundChannelString] = Extract_Events_Module_Organize_Window_Intan_RHD(app,RhdFilePaths,Type,DIChannel,ADCChannel,AUXChannel,ChannelType)

%________________________________________________________________________________________
%% Function show found event channel infos in the event extraction window for Intan .rhd recordings

% gets called by the Extract_Events_Module_Determine_Available_EventChannel
% function on startup of the event extraction window, when the folder supposed to contain event data gets
% changed and when the type of event file is changed in the extract events window (Digital, Analog and Aux inputs for intan, "Record Node 101" or whatever node contains events of interest for Open Ephys)

% Inputs: 
% 1.app: app object containing the components of the extract events window.
% 2. RhdFilePaths: NOTE: only non empty on startup and folder change; 1xn
% cell array with each cell containing a string with a single content of
% the selected folder
% 3: Type: char, 'Initial' to populate textare in window on startup and
% folder change; When event filetype change some other string to just
% update the app.NrInputChinfolderEditField,
% app.AnalogThresholdVEditField and app.InputChannelSelectionEditField
% fields
% 4. DIChannel: empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Digital events as 1xn double array
% 5. ADCChannel: empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Analog events as 1xn double array
% 6. AUXChannel:empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Aux events as 1xn double array
% 9. ChannelType: selected filetype in the main window (Digital, Analog and Aux inputs for intan, "Record Node 101" or whatever node contains events of interest for Open Ephys)

% Outputs:
% 1. DIChannel: empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Digital events as 1xn double array
% 2. ADCChannel: empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Analog events as 1xn double array
% 3. AUXChannel:empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Aux events as 1xn double array
% 4. AllChannel: empty on event file type
% change; on startup contains indicies of RHDFilePaths with path to the all event file types as 1xn double array
% 5: FoundChannelString: string array holding names of all event files (and in some cases amplifier files)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

FoundChannelString = [];
AllChannel = [];

if strcmp(Type,"Initial")   
   
    LastDashIndex = find(RhdFilePaths == '\');
    RHDPath = RhdFilePaths(1:LastDashIndex(end));
    RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
    
    [~,AllChannel.board_adc_data,~,AllChannel.board_dig_in_data,~,~,~,AllChannel.aux_input_data,NumChannel] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"NumChannel",[]);

    FoundChannelString = "Found Input Channel:";
    FoundChannelString = [FoundChannelString;""];

    if ~isempty(NumChannel.num_board_dig_in_channels)
        FoundChannelString = [FoundChannelString;strcat(num2str(NumChannel.num_board_dig_in_channels)," Digital Channel")];
        DIChannel = NumChannel.num_board_dig_in_channels;
    else
        FoundChannelString = [FoundChannelString;" 0 Digital Channel"];
    end

    if ~isempty(NumChannel.num_board_adc_channels)
        FoundChannelString = [FoundChannelString;strcat(num2str(NumChannel.num_board_adc_channels)," Analog Channel")];
        ADCChannel = NumChannel.num_board_adc_channels;
    else
        FoundChannelString = [FoundChannelString;" 0 Analog Channel"];
    end

    if ~isempty(NumChannel.aux_input_channels)
        FoundChannelString = [FoundChannelString;strcat(num2str(NumChannel.aux_input_channels)," Aux Channel")];
        AUXChannel = NumChannel.aux_input_channels;
    else
        FoundChannelString = [FoundChannelString;" 0 Aux Channel"];
    end

    if isempty(NumChannel.num_board_adc_channels) && isempty(NumChannel.num_board_dig_in_channels) && isempty(NumChannel.aux_input_channels)
        % app.TextArea.Value = "Warning: No Event Channel found in this folder. Please select a different folder.";
        return;
    end     
    
else % If Fileytype changed
            
        if strcmp(ChannelType, "Digital Inputs")

            app.AnalogThresholdVEditField.Value = "1";

            if DIChannel ~= 0  
          
                app.NrInputChinfolderEditField.Value = num2str(DIChannel);

                channelselctiontoshow = [];
                channelselctiontoshow = "1";

                for i = 2:DIChannel
                    channelselctiontoshow = strcat(channelselctiontoshow,",",num2str(i));
                end
             
                app.InputChannelSelectionEditField.Value = channelselctiontoshow;

            else
                app.NrInputChinfolderEditField.Value = num2str(0);
                app.InputChannelSelectionEditField.Value = "";
            end
            
        elseif strcmp(ChannelType, "Analog Input")
            app.AnalogThresholdVEditField.Enable = "on";
            if ADCChannel ~= 0          
                app.NrInputChinfolderEditField.Value = num2str(ADCChannel);
              
                channelselctiontoshow = "1";
                
                for i = 2:ADCChannel
                    channelselctiontoshow = strcat(channelselctiontoshow,",",num2str(i));
                end
               
                app.InputChannelSelectionEditField.Value = channelselctiontoshow;
            else
                app.NrInputChinfolderEditField.Value = num2str(0);
                app.InputChannelSelectionEditField.Value = "";
            end

        elseif strcmp(ChannelType, "AUX Inputs")
            app.AnalogThresholdVEditField.Enable = "on";
            if AUXChannel ~= 0    
                app.NrInputChinfolderEditField.Value = num2str(AUXChannel);
            
                channelselctiontoshow = [];
                channelselctiontoshow = "1";

                for i = 2:AUXChannel
                    channelselctiontoshow = strcat(channelselctiontoshow,",",num2str(i));
                end

                app.InputChannelSelectionEditField.Value = channelselctiontoshow;
            else
                app.NrInputChinfolderEditField.Value = num2str(0);
                app.InputChannelSelectionEditField.Value = "";
            end
        end

end





