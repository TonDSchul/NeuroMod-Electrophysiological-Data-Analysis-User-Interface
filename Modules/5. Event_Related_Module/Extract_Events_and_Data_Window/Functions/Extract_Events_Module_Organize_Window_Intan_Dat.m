function [DIChannel,ADCChannel,AUXChannel,texttoshow] = Extract_Events_Module_Organize_Window_Intan_Dat(app,DatFilePaths,Type,DIChannel,ADCChannel,AUXChannel,AllChannel,AmplifierDataIndex,ChannelType)

%________________________________________________________________________________________
%% Function show found event channel infos in the event extraction window for Intan .dat recordings

% gets called by the Extract_Events_Module_Determine_Available_EventChannel
% function on startup of the event extraction window, when the folder supposed to contain event data gets
% changed and when the type of event file is changed in the extract events window (Digital, Analog and Aux inputs for intan, "Record Node 101" or whatever node contains events of interest for Open Ephys)

% Inputs: 
% 1.app: app object containing the components of the extract events window.
% 2. DatFilePaths: NOTE: only non empty on startup and folder change; 1xn
% cell array with each cell containing a string with a single content of
% the selected folder
% 3: Type: char, 'Initial' to populate textare in window on startup and
% folder change; When event filetype change some other string to just
% update the app.NrInputChinfolderEditField,
% app.AnalogThresholdVEditField and app.InputChannelSelectionEditField
% fields
% 4. DIChannel: empty on startup and folder change; when event file type
% change: contains indicies of DatFilePaths with path to the event file for
% Digital events as 1xn double array
% 5. ADCChannel: empty on startup and folder change; when event file type
% change: contains indicies of DatFilePaths with path to the event file for
% Analog events as 1xn double array
% 6. AUXChannel:empty on startup and folder change; when event file type
% change: contains indicies of DatFilePaths with path to the event file for
% Aux events as 1xn double array
% 7. AllChannel: empty on event file type
% change; on startup contains indicies of DatFilePaths with path to the all event file types as 1xn double array
% 8. AmplifierDataIndex: empty on event file type
% change; on startup contains indicies of DatFilePaths with path to the all amplifier data file types as 1xn double array
% 9. ChannelType: selected filetype in the main window (Digital, Analog and Aux inputs for intan, "Record Node 101" or whatever node contains events of interest for Open Ephys)

% Outputs:
% 1. DIChannel: empty on startup and folder change; when event file type
% change: contains indicies of DatFilePaths with path to the event file for
% Digital events as 1xn double array
% 2. ADCChannel: empty on startup and folder change; when event file type
% change: contains indicies of DatFilePaths with path to the event file for
% Analog events as 1xn double array
% 3. AUXChannel:empty on startup and folder change; when event file type
% change: contains indicies of DatFilePaths with path to the event file for
% Aux events as 1xn double array
% 4: texttoshow: app textarea showing all event files (and in some cases amplifier files)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


texttoshow(1) = "Found Input Channel:";

if strcmp(Type,"Initial")
        
        if ~isempty(AllChannel)
        texttoshow(1) = "Found Input Channel:";
    
            for i = 1:length(AllChannel)
                currentstring = DatFilePaths{AllChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow(i+1) = currentstring;
            end
        end
    
        if ~isempty(AmplifierDataIndex)
        texttoshow(end+1) = "Amplifier Input Channel:";
        currentelements = length(texttoshow);
        
            for i = 1:length(AmplifierDataIndex)
                currentstring = DatFilePaths{AmplifierDataIndex(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow(i+currentelements) = currentstring;
            end
            
        end
                        
        for k = 1:length(DatFilePaths)
            if strcmp(DatFilePaths{k}(end-16:end-16+6),"DIGITAL")
                DIChannel = [DIChannel,k];
            end
            if strcmp(DatFilePaths{k}(end-9:end-9+2),"DIN")
                DIChannel = [DIChannel,k];
            end
            if strcmp(DatFilePaths{k}(end-9:end-7),"ADC")
                ADCChannel = [ADCChannel,k];
            end
                
            if strcmp(DatFilePaths{k}(end-7:end-5),"AUX")
                AUXChannel = [AUXChannel,k];
            end
        end
        
else % If Fileytype changed
            
        if strcmp(ChannelType, "Digital Inputs")

            app.AnalogThresholdVEditField.Value = "1";

            if ~isempty(DIChannel)
                app.NrInputChinfolderEditField.Value = num2str(length(DIChannel));

                channelselctiontoshow = [];
                channelselctiontoshow = "1";
 
                for i = 2:length(DIChannel)
                    channelselctiontoshow = strcat(channelselctiontoshow,",",num2str(i));
                end

                app.InputChannelSelectionEditField.Value = channelselctiontoshow;

            else
                app.NrInputChinfolderEditField.Value = num2str(0);
                app.InputChannelSelectionEditField.Value = "";
            end
            
        elseif strcmp(ChannelType, "Analog Input")
            app.AnalogThresholdVEditField.Enable = "on";
            if ~isempty(ADCChannel)

                app.NrInputChinfolderEditField.Value = num2str(length(ADCChannel));

                channelselctiontoshow = "1";     
               
                for i = 2:length(ADCChannel)
                    channelselctiontoshow = strcat(channelselctiontoshow,",",num2str(i));
                end

                app.InputChannelSelectionEditField.Value = channelselctiontoshow;
            else
                app.NrInputChinfolderEditField.Value = num2str(0);
                app.InputChannelSelectionEditField.Value = "";
            end

        elseif strcmp(ChannelType, "AUX Inputs")
            app.AnalogThresholdVEditField.Enable = "on";
            if ~isempty(AUXChannel)

                app.NrInputChinfolderEditField.Value = num2str(length(AUXChannel));

                channelselctiontoshow = [];
                channelselctiontoshow = "1";

                for i = 2:length(AUXChannel)
                    channelselctiontoshow = strcat(channelselctiontoshow,",",num2str(i));
                end

                app.InputChannelSelectionEditField.Value = channelselctiontoshow;
            else
                app.NrInputChinfolderEditField.Value = num2str(0);
                app.InputChannelSelectionEditField.Value = "";
            end
        end

end





