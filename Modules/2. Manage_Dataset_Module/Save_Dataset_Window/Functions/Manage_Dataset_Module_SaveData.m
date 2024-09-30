function [filepath,Error] = Manage_Dataset_Module_SaveData(Data,Type,Whattosave,executablefolder,Autorun,SelectedFolder)

%________________________________________________________________________________________

%% Function to save data (Channel x Time single maxtrix) as a .dat file in in16 format or as a mat file.

% Saving is performed in chunks to increase performance and values get
% converted to binaries,w hich also increases loading performance 

% Input:
% 1. Data: Data structure containing preprocessed data as a Channel x Time
% matrix containing data.
% 2. Type: Which format to save data in. Possibilitioes are ".dat" and
% ".mat" (char or string)
% 3. Whattosave: vector with 6 numbers being either a 1 or a 0. Each
% indicie of the vector stands for a component of the dataset. The number 1 indicates, this component
% should be save. Components in the correct order are:
% [Raw,Preprocessed,Events,Spikes,EventrelatedData,PreprocessedEventrelatedData] --> [1,1,1,0,0,0] saves raw data, preprocessed data and event time points
% 4. executablefolder: Path to folder GUI is saved in as a string
% 5. Autorun: string specifying whether this function is called from the autorun functions or from the GUI
% if no Autorun: "No" ; if Autorun == "SingleFolder" or "MultipleFolder",
% depending on whether the autorun loops over multiple recordings
% (MultipleFolder).
% 6. SelectedFolder: Path as char to the folder the user selected containing the
% data to load. Only required when executed from Autorun with MultipleFolder, since
% then it automatically creates the save file folder, otherwise empty

% Output: 
% 1. filepath: string of path the file was saved in
% 2. Error: 1 if error occured, 0 otherwise

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Error = 0;
filepath = [];

if sum(Whattosave) == 0
    f = msgbox("No Selection was made what to save. Please select the parts of the data structure you want to save or save the whole structure");
    Error = 1;
    return;
end

cd(executablefolder);

if Whattosave(1) == 0 && Whattosave(2) == 0
    msgbox("Warning: When not saving raw and/or preprocessed data, the file cannot be loaded in the Toolbox! Use the 'Manage Dataset Window' export function to export dataset components other then raw and preprocessed data! Returning.");
    return;
elseif Whattosave(1) == 0 && Whattosave(2) == 1
    msgbox("Warning: Only preprocessed data is saved. When loading this dataset, GUI will copy preprocessed data and take it as raw data.");
end

if Whattosave(1) == 1 && Whattosave(2) == 0 

    %% If just Raw Data saved: Delete preprocessing infos from Data.Info structure.
    % They all come after the field "ChannelOrder
    % Find the index of the specific field
    if isfield(Data.Info,'DownsampleFactor')
        fieldsToDelete = {'TimeDownsampled','DownsampledSampleRate'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'DownsampleFactor'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    fieldNames = fieldnames(Data.Info);
    idx = find(strcmp(fieldNames, 'Channelorder'));
   
    TempEventChannel = [];
    TempEventDataType = [];
    TempEventTimeRange = [];
    TempPreproInfoType = [];
    TempSpikeDetectionThreshold = [];
    TempKilosortScalingFactor = [];
    TempSpikeType = Data.Info.SpikeType;
    TempCutStart = [];
    TempCutStop = [];
    TempChannelDeletion = [];
    TempSpike2EventChannelToTake = [];
    TempSpikeSorting = [];
    TempSpikeDetectionNrStd = [];

    if isfield(Data.Info,'CutStart')
        TempCutStart = Data.Info.CutStart;
    end

    if isfield(Data.Info,'Spike2EventChannelToTake')
        TempSpike2EventChannelToTake = Data.Info.Spike2EventChannelToTake;
    end

    if isfield(Data.Info,'CutEnd')
        TempCutStop = Data.Info.CutEnd;
    end

    if isfield(Data.Info,'ChannelDeletion')
        TempChannelDeletion = Data.Info.ChannelDeletion;
    end

    if isfield(Data.Info,'KilosortScalingFactor')
        TempKilosortScalingFactor = Data.Info.KilosortScalingFactor;
    end

    if isfield(Data,'EventRelatedData')
        TempEventChannel = Data.Info.EventRelatedDataChannel;
        TempEventDataType = Data.Info.EventRelatedDataType;
        TempEventTimeRange = Data.Info.EventRelatedDataTimeRange;
    end

    if isfield(Data,'PreprocessedEventRelatedData')
        if isfield(Data.Info,'EventRelatedPreprocessing')
            TempPreproInfoType = Data.Info.EventRelatedPreprocessing;
        end
    end

    if isfield(Data.Info,'SpikeSorting')
        TempSpikeSorting = Data.Info.SpikeSorting;
    end

    if isfield(Data.Info,'SpikeDetectionNrStd')
        TempSpikeDetectionNrStd = Data.Info.SpikeDetectionNrStd;
    end

    if isfield(Data.Info,'SpikeDetectionThreshold')
        TempSpikeDetectionThreshold = Data.Info.SpikeDetectionThreshold;
    end
    
    if isfield(Data.Info,'EventChannelNames')
        TempEventChannelNames = Data.Info.EventChannelNames;
        TempEventChannelType = Data.Info.EventChannelType;
    else
        TempEventChannelNames = [];
    end

    % Create a new structure with only the fields up to the found index
    Data.Info = rmfield(Data.Info, fieldNames(idx+1:end));

    if ~isempty(TempEventChannelNames)
        Data.Info.EventChannelNames = TempEventChannelNames;
        Data.Info.EventChannelType = TempEventChannelType;
    end

    if ~isempty(TempPreproInfoType)
        Data.Info.EventRelatedPreprocessing = TempPreproInfoType;
    end

    if ~isempty(TempEventChannel)
        Data.Info.EventRelatedDataChannel = TempEventChannel;
        Data.Info.EventRelatedDataType = TempEventDataType;
        Data.Info.EventRelatedDataTimeRange = TempEventTimeRange;
    end

    if ~isempty(TempSpikeDetectionThreshold)
        Data.Info.SpikeDetectionThreshold = TempSpikeDetectionThreshold;
    end

    if ~isempty(TempKilosortScalingFactor)
        Data.Info.KilosortScalingFactor = TempKilosortScalingFactor;
    end

    if ~isempty(TempCutStart)
         Data.Info.CutStart = TempCutStart;
    end

    if ~isempty(TempCutStop)
        Data.Info.CutEnd = TempCutStop;
    end

    if ~isempty(TempChannelDeletion)
        Data.Info.ChannelDeletion = TempChannelDeletion;
    end

    if ~isempty(TempSpike2EventChannelToTake)
        Data.Info.Spike2EventChannelToTake = TempSpike2EventChannelToTake;
    end

    if ~isempty(TempSpikeSorting)
        Data.Info.SpikeSorting = TempSpikeSorting;
    end
    
    if ~isempty(TempSpikeDetectionNrStd)
        Data.Info.SpikeDetectionNrStd = TempSpikeDetectionNrStd;
    end

    Data.Info.SpikeType = TempSpikeType;

    if isfield(Data,'Preprocessed')
        fieldsToDelete = {'Preprocessed'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end

    if isfield(Data.Info,'EventRelatedDataType')
        if strcmp(Data.Info.EventRelatedDataType,"Preprocessed")
            msgbox("Event related data is based on preprocessed data and will be deleted");
            if isfield(Data,'EventRelatedData')
                fieldsToDelete = {'EventRelatedData'};
                % Delete fields
                Data = rmfield(Data, fieldsToDelete);
                fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
                Data.Info = rmfield(Data.Info, fieldsToDelete);
            end
            if isfield(Data,'PreprocessedEventRelatedData')
                fieldsToDelete = {'PreprocessedEventRelatedData'};
                % Delete fields
                Data = rmfield(Data, fieldsToDelete);
                
                if isfield(Data.Info,'EventRelatedPreprocessing')
                    fieldsToDelete = {'EventRelatedPreprocessing'};
                    % Delete fields
                    Data.Info = rmfield(Data.Info, fieldsToDelete);
                end

            end
        end
    end

end
 % If only Preprocessed Data saved: Delete Raw, leave everything else as it
 % is. When loading: Raw Data = Preprocessed
if Whattosave(1) == 0 && Whattosave(2) == 1
    if isfield(Data,"Preprocessed")
        if isfield(Data,'Raw')
            fieldsToDelete = {'Raw'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end
        if isfield(Data.Info,'DownsampleFactor')
            Data.Time = Data.TimeDownsampled;
            Data.Info.NativeSamplingRate = Data.Info.DownsampledSampleRate;
            Data.Info.num_data_points = length(Data.Time);
    
            fieldsToDelete = {'TimeDownsampled','DownsampledSampleRate'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
            fieldsToDelete = {'DownsampleFactor'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
    
        if isfield(Data.Info,'EventRelatedDataType')
            if strcmp(Data.Info.EventRelatedDataType,"Raw")
                msgbox("Event related data is based on raw data and will be deleted");
                if isfield(Data,'EventRelatedData')
                    fieldsToDelete = {'EventRelatedData'};
                    % Delete fields
                    Data = rmfield(Data, fieldsToDelete);
                    fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
                    Data.Info = rmfield(Data.Info, fieldsToDelete);
                end
                if isfield(Data,'PreprocessedEventRelatedData')
                    fieldsToDelete = {'PreprocessedEventRelatedData'};
                    % Delete fields
                    Data = rmfield(Data, fieldsToDelete);
            
                    if isfield(Data.Info,'EventRelatedPreprocessing')
                        fieldsToDelete = {'EventRelatedPreprocessing'};
                        % Delete fields
                        Data.Info = rmfield(Data.Info, fieldsToDelete);
                    end 
                end
            end
        end
        if isfield(Data,'EventRelatedSpikes')
            fieldsToDelete = {'EventRelatedSpikes'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end

    else
        Whattosave(1) = 1;
        Whattosave(2) = 0;
    end
end

if Whattosave(1) == 1 && Whattosave(2) == 1
    if ~isfield(Data,"Preprocessed")
        Whattosave(2) = 0;
    else
        if isempty(Data.Preprocessed)
            Whattosave(2) = 0;
        end
    end
    if isfield(Data.Info,'DownsampleFactor')
        Data.Info.num_data_points_Downsampled = length(Data.TimeDownsampled);
    end
end

if Whattosave(3) == 0
    % If no events saved: Delete Info fields about events
    if isfield(Data,'Events')
        fieldsToDelete = {'Events'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        if isfield(Data.Info,'EventChannelType')
            fieldsToDelete = {'EventChannelType', 'EventChannelNames'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
    end
else
    if ~isfield(Data,'Events')
        Whattosave(3) = 0;
    else
        if isempty(Data.Events)
            Whattosave(3) = 0;
        end
    end
end

if Whattosave(4) == 0
    if isfield(Data,'Spikes')
        fieldsToDelete = {'Spikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        if isfield(Data.Info,'SpikeDetectionThreshold')
            fieldsToDelete = {'SpikeDetectionThreshold'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        if isfield(Data.Info,'KilosortScalingFactor')
            fieldsToDelete = {'KilosortScalingFactor'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        if isfield(Data,'EventRelatedSpikes')
            fieldsToDelete = {'EventRelatedSpikes'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end
        if isfield(Data.Info,'SpikeSorting')
            fieldsToDelete = {'SpikeSorting'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        if isfield(Data.Info,'SpikeDetectionNrStd')
            fieldsToDelete = {'SpikeDetectionNrStd'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        Data.Info.SpikeType = "Non";
    end
else
    if ~isfield(Data,'Spikes')
        Whattosave(4) = 0;
    else
        if isempty(Data.Spikes)
            Whattosave(4) = 0;
        end
    end
end

if Whattosave(5) == 0
    if isfield(Data,'EventRelatedData')
        fieldsToDelete = {'EventRelatedData'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);

        if Whattosave(6) == 0
            if isfield(Data.Info,'EventRelatedDataChannel')
                fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
                Data.Info = rmfield(Data.Info, fieldsToDelete);

                if isfield(Data.Info,'EventRelatedPreprocessing')
                    fieldsToDelete = {'EventRelatedPreprocessing'};
                    % Delete fields
                    Data.Info = rmfield(Data.Info, fieldsToDelete);
                end 
            end
        end
    end

    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end
else
    if ~isfield(Data,'EventRelatedSpikes')
        Whattosave(5) = 0;
    else
        if isempty(Data.EventRelatedSpikes)
            Whattosave(5) = 0;
        end
    end
end

if Whattosave(6) == 0
    if isfield(Data,'PreprocessedEventRelatedData')
        fieldsToDelete = {'PreprocessedEventRelatedData'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);

        if isfield(Data.Info,'EventRelatedPreprocessingType')
            fieldsToDelete = {'EventRelatedPreprocessingType'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end

        if isfield(Data.Info,'TrialRejectionChannel')
            fieldsToDelete = {'TrialRejectionChannel'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        if isfield(Data.Info,'TrialRejectionTrials')
            fieldsToDelete = {'TrialRejectionTrials'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end

        if isfield(Data.Info,'ArtefactRejectionChannel')
            fieldsToDelete = {'ArtefactRejectionChannel'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        if isfield(Data.Info,'ArtefactRejectionTrials')
            fieldsToDelete = {'ArtefactRejectionTrials'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        if isfield(Data.Info,'ArtefactRejectionTimeRange')
            fieldsToDelete = {'ArtefactRejectionTimeRange'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end

        if isfield(Data.Info,'ChannelRejectionChannel')
            fieldsToDelete = {'ChannelRejectionChannel'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        if isfield(Data.Info,'ChannelRejectionTrials')
            fieldsToDelete = {'ChannelRejectionTrials'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
    end
else
    if ~isfield(Data,'PreprocessedEventRelatedData')
        Whattosave(6) = 0;
    else
        if isempty(Data.PreprocessedEventRelatedData)
            Whattosave(6) = 0;
        end
    end
end

if ~isempty(Data)
    if strcmp(Type,".mat")

        if Autorun == "No" || Autorun == "SingleFolder"
            % Prompt user for file save location and name
            [file, path] = uiputfile('*.mat', 'Save as');
            
            if isequal(file,0) || isequal(path,0)
                disp('User canceled the operation.');
                Error = 1;
                return;
            end
    
            % Construct the full file path
            FullPath = fullfile(path, file);
            filepath = FullPath;
        else
            dashindex = find(SelectedFolder=='\');
            filepath = SelectedFolder;
            filename = strcat(SelectedFolder(dashindex(end-1)+1:dashindex(end)-1),".mat");
            FullPath = fullfile(filepath, filename);
            filepath = FullPath;
        end

        % Save the variables to the .mat file
        save(FullPath, '-struct','Data','-v7.3');
        disp(['Variables saved to: ' FullPath]);
        disp("Saving Data finished");

    elseif strcmp(Type,".dat")
        
        % Define the range of int16
        int16Min = int16(-2^15);
        int16Max = int16(2^15 - 1);

        if Autorun == "No" || Autorun == "SingleFolder"
            [filename, filepath] = uiputfile('*.dat', 'Save File');
                
            if isequal(filename,0) || isequal(filepath,0)
                disp('User canceled the operation.');
                Error = 1;
                return;
            end
        else
            if isstring(SelectedFolder)
                SelectedFolder = convertStringsToChars(SelectedFolder);
            end
            dashindex = find(SelectedFolder=='\');
            filepath = convertStringsToChars(strcat(SelectedFolder,'\'));
            if Autorun == "SingleFolder"
                filename = convertStringsToChars(strcat(SelectedFolder(dashindex(end-1)+1:dashindex(end)-1),".dat"));
            elseif Autorun == "MultipleFolder"
                if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD") || strcmp(Data.Info.RecordingType,"Neuralynx") || strcmp(Data.Info.RecordingType,"Spike2")
                    filename = convertStringsToChars(strcat(SelectedFolder(dashindex(end-1)+1:dashindex(end)-1),".dat"));
                elseif strcmp(Data.Info.RecordingType,"Open Ephys")
                    filename = convertStringsToChars(strcat(SelectedFolder(dashindex(end-2)+1:dashindex(end-1)-1),".dat"));
                end
            end
        end

        if Whattosave(1) == 1 && Whattosave(2) == 0
            filenameRaw = filename; 

            % Find the maximum absolute value in the vector
            maxAbsValue = max(max(abs(Data.Raw)));
            
            % Calculate the scaling factor
            scalingFactor = double(int16Max) / double(maxAbsValue);
            Data.Info.scalingFactor = scalingFactor;
            % Apply the scaling factor
            Data.Raw = int16(Data.Raw .* scalingFactor);
            
            h = waitbar(0, 'Saving data...', 'Name','Saving data...');
            cN = 1000;  % number of steps/chunks
            % Divide the data into chunks (last chunk is smaller than the rest)
            dN = size(Data.Raw,2);
            
            % Check if numSteps is an integer
            if mod(dN, cN) ~= 0
                % If not, adjust chunks to be the closest divisor of nTimePoints
                cN = gcd(cN, dN);
            end

            dataIdx = [1 : round(dN/cN) : dN, dN+1];  % cN+1 chunk location indexes

            % Save the data
            fidRaw = fopen(fullfile(filepath, filenameRaw), 'Wb'); 
            for chunkIdx = 0 : cN-1
               % Update the progress bar
               fraction = chunkIdx/cN;
               msg = sprintf('Saving data... (%d%% done)', round(100*fraction));
               waitbar(fraction, h, msg);
               % Save the next data chunk
               fwrite(fidRaw,Data.Raw(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1), 'int16');
            end
            fclose(fidRaw);
            close(h);

        elseif Whattosave(1) == 1 && Whattosave(2) == 1
            filenameRaw = filename; 
 
            % Find the maximum absolute value in the vector
            maxAbsValue = max(max(abs(Data.Preprocessed)));
            
            % Calculate the scaling factor
            scalingFactor = double(int16Max) / double(maxAbsValue);
            Data.Info.scalingFactor(2) = scalingFactor;
            % Apply the scaling factor
            Data.Preprocessed = int16(Data.Preprocessed .* scalingFactor);

            % Find the maximum absolute value in the vector
            maxAbsValue = max(max(abs(Data.Raw)));
            
            % Calculate the scaling factor
            scalingFactor = double(int16Max) / double(maxAbsValue);
            Data.Info.scalingFactor(1) = scalingFactor;
            % Apply the scaling factor
            Data.Raw = int16(Data.Raw .* scalingFactor);

            h = waitbar(0, 'Saving data...', 'Name','Saving data...');
            cN = 1000;  % number of steps/chunks
            % Divide the data into chunks (last chunk is smaller than the rest)
            for i = 1:2
                if i == 1
                    fidPrepro = fopen(fullfile(filepath, filenameRaw), 'Wb'); 
                    dN = size(Data.Raw,2);
                else
                    dN = size(Data.Preprocessed,2);
                end
                % Check if numSteps is an integer
                if mod(dN, cN) ~= 0
                    % If not, adjust chunks to be the closest divisor of nTimePoints
                    cN = gcd(cN, dN);
                end

                dataIdx = [1 : round(dN/cN) : dN, dN+1];  % cN+1 chunk location indexes
                % Save the data
                
                for chunkIdx = 0 : cN-1
                   % Update the progress bar
                   fraction = chunkIdx/cN;
                   msg = sprintf('Saving data... (%d%% done)', round(100*fraction));
                   waitbar(fraction, h, msg);
                   % Save the next data chunk
                   %chunkData = SaveData(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1);
                   if i == 1
                        fwrite(fidPrepro,Data.Raw(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1), 'int16');
                   else
                        fwrite(fidPrepro,Data.Preprocessed(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1), 'int16');
                   end
                end
            end
            fclose(fidPrepro);
            close(h);

        elseif Whattosave(1) == 0 && Whattosave(2) == 1
            filenamePrepro = filename; 

            % Find the maximum absolute value in the vector
            maxAbsValue = max(max(abs(Data.Preprocessed)));
            
            % Calculate the scaling factor
            scalingFactor = double(int16Max) / double(maxAbsValue);
            Data.Info.scalingFactor = scalingFactor;
            % Apply the scaling factor
            Data.Preprocessed = int16(Data.Preprocessed .* scalingFactor);

            h = waitbar(0, 'Saving data...', 'Name','Saving data...');
            cN = 1000;  % number of steps/chunks
            % Divide the data into chunks (last chunk is smaller than the rest)
            dN = size(Data.Preprocessed,2);
            % Check if numSteps is an integer
            if mod(dN, cN) ~= 0
                % If not, adjust chunks to be the closest divisor of nTimePoints
                cN = gcd(cN, dN);
            end
            dataIdx = [1 : round(dN/cN) : dN, dN+1];  % cN+1 chunk location indexes
            % Save the data
            fidPrepro = fopen(fullfile(filepath, filenamePrepro), 'Wb'); 
            for chunkIdx = 0 : cN-1
               % Update the progress bar
               fraction = chunkIdx/cN;
               msg = sprintf('Saving data... (%d%% done)', round(100*fraction));
               waitbar(fraction, h, msg);
               % Save the next data chunk
               %chunkData = Data.Preprocessed(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1);
               fwrite(fidPrepro,Data.Preprocessed(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1), 'int16');
            end

            fclose(fidPrepro);
            
        else
            disp("No Data selected, just saving Info.mat")
        end
       
        if isfield(Data,'Raw')
            fieldsToDelete = {'Raw'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end
        if isfield(Data,'Preprocessed')
            fieldsToDelete = {'Preprocessed'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end

        h = waitbar(100, 'Saving Info as .mat file (and event related data if selected)...', 'Name','Saving Info as .mat file...');

        Data.Whattosave = [Whattosave(1),Whattosave(2)];
        filenameInfo = [filename(1:end-4),'_Info'];
        % Save the variables to the .mat file
        save(fullfile(filepath, filenameInfo), '-struct','Data','-v7.3');
        disp(['Variables saved to: ' filepath]);
        disp("Saving Data finished");

        close(h);
    end
    
else
    f = msgbox("An Error occured in 'Module_SaveData' function. Please check the 'Whattosave' Variable and that there is data in the strucutre to save.");
end

