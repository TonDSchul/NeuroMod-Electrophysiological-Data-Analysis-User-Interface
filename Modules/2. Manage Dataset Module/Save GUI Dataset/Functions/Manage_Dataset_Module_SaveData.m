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

if Whattosave(1) == 0 && Whattosave(2) == 0
    msgbox("Warning: When not saving raw and/or preprocessed data, the file cannot be loaded in the Toolbox! Use the 'Manage Dataset Window' export function to export dataset components other then raw and preprocessed data! Returning.");
    return;
elseif Whattosave(1) == 0 && Whattosave(2) == 1
    msgbox("Warning: Only preprocessed data is saved. When loading this dataset, GUI will copy preprocessed data and take it as raw data.");
end

%% -------------------- Only Raw Data -------------------- 
if Whattosave(1) == 1 && Whattosave(2) == 0 
    %% If just Raw Data saved: Delete preprocessing infos from Data.Info structure.
    % They all come after the field "ChannelOrder
    % Find the index of the specific field
    [Data,Error] = Organize_Delete_Dataset_Components(Data,"Preprocessed");
end

%% -------------------- Only Preprocessed Data -------------------- 
 % If only Preprocessed Data saved: Delete Raw, leave everything else as it
 % is. When loading: Raw Data = Preprocessed
DownsampleFlag = 0;
DownsampleFactor = [];
if Whattosave(1) == 0 && Whattosave(2) == 1
    if isfield(Data,"Preprocessed")
        Data.Raw = Data.Preprocessed;
        if isfield(Data,'Preprocessed')
            fieldsToDelete = {'Preprocessed'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end
        if isfield(Data.Info,'DownsampleFactor')
            DownsampleFlag = 1;
            DownsampleFactor = Data.Info.DownsampleFactor;

            % prepro info as new standard info
            Data.Time = Data.TimeDownsampled;
            Data.Info.NativeSamplingRate = Data.Info.DownsampledSampleRate;
            Data.Info.num_data_points = length(Data.TimeDownsampled);
    
            fieldsToDelete = {'DownsampledSampleRate'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);

            fieldsToDelete = {'TimeDownsampled'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);


            fieldsToDelete = {'DownsampleFactor'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
    else
        Whattosave(1) = 1;
        Whattosave(2) = 0;
    end
end

%% -------------------- Raw and Preprocessed Data -------------------- 
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
%% -------------------- Event Data-------------------- 
if Whattosave(3) == 0
    if isfield(Data,'Events')
        % If no events saved: Delete Info fields about events
        [Data,~] = Organize_Delete_Dataset_Components(Data,"Events");
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
%% -------------------- Spike Data-------------------- 
if Whattosave(4) == 0
    if isfield(Data,'Spikes')
        [Data,~] = Organize_Delete_Dataset_Components(Data,"Spikes");
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
%% -------------------- Event Related Data-------------------- 
if Whattosave(5) == 0
    if isfield(Data,'EventRelatedData')
        [Data,~] = Organize_Delete_Dataset_Components(Data,"EventRelatedData");
    end
else
    % First delete, then ask which settings 
    if isfield(Data,'EventRelatedData')
        fieldsToDelete = {'EventRelatedData'};
        Data = rmfield(Data, fieldsToDelete);
    end

    if ~isfield(Data,'EventRelatedData')
        % if only prepro data saved and downsampled: adjust event indices!
        if Whattosave(1) == 0 && Whattosave(2) == 1 && DownsampleFlag == 1
            msgbox("Warning: Only downsampled preprocessed data saved. Loading spike sorting data or event data based on the original sampling rate wont work anymore!")
            warning("Only downsampled preprocessed data saved. Loading spike sorting data or event trigger times based on the original sampling rate wont work anymore!")
            % adjust event data to downsampled data
            if ~isempty(DownsampleFactor)
                warning("Aplying downsampled factor to event indices!")
                for i = 1:length(Data.Events)
                    Data.Events{i} = round(Data.Events{i}/DownsampleFactor);
                end
            end
            warning("Aplying downsampled factor to spike times!")
            Data.Spikes.SpikeTimes = round(Data.Spikes.SpikeTimes/DownsampleFactor); 
        end
        
        ERDParameterWindow = Ask_ERD_Parameter(Data,"Raw Event Related Data");
        
        uiwait(ERDParameterWindow.AskForEventRelatedDataExtractionUIFigure);
        
        if isvalid(ERDParameterWindow)
            if ~isempty(ERDParameterWindow.ERDParameter)
                [Data,~] = Event_Module_Extract_Event_Related_Data(Data,ERDParameterWindow.ERDParameter.EventChannel,ERDParameterWindow.ERDParameter.TimearoundEvent,ERDParameterWindow.ERDParameter.DatatoExtractFrom,"Raw Event Related Data");
            else
                msgbox("No event related data extracted.")
            end
            try
                delete(ERDParameterWindow)
            end
        else
            msgbox("No event related data extracted.")
            try
                delete(ERDParameterWindow)
            end
        end
    end

    if ~isfield(Data,'EventRelatedData')
        Whattosave(5) = 0;
    else
        if isempty(Data.EventRelatedData)
            Whattosave(5) = 0;
        end
    end
end
%% -------------------- Preprocessed Event Related Data-------------------- 
if Whattosave(6) == 0
    if isfield(Data,'PreprocessedEventRelatedData')
        [Data,~] = Organize_Delete_Dataset_Components(Data,"PreprocessedEventRelatedData");        
    end
else
    % First delete, then ask which settings 
    if isfield(Data,'PreprocessedEventRelatedData')
        fieldsToDelete = {'PreprocessedEventRelatedData'};
        Data = rmfield(Data, fieldsToDelete);
    end

    if ~isfield(Data,'PreprocessedEventRelatedData')
        ERDParameterWindowPrepr = Ask_ERD_Parameter(Data,"Preprocessed Event Related Data");
        
        uiwait(ERDParameterWindowPrepr.AskForEventRelatedDataExtractionUIFigure);
        
        if isvalid(ERDParameterWindowPrepr)
            if ~isempty(ERDParameterWindowPrepr.ERDParameter)
                [Data,~] = Event_Module_Extract_Event_Related_Data(Data,ERDParameterWindowPrepr.ERDParameter.EventChannel,ERDParameterWindowPrepr.ERDParameter.TimearoundEvent,ERDParameterWindowPrepr.ERDParameter.DatatoExtractFrom,"Preprocessed Event Related Data");
            else
                msgbox("No preprocessed event related data extracted.")
            end
        else
            msgbox("No preprocessed event related data extracted.")
        end
    end
    
    if ~isfield(Data,'PreprocessedEventRelatedData')
        Whattosave(6) = 0;
    else
        if isempty(Data.PreprocessedEventRelatedData)
            Whattosave(6) = 0;
        end
    end
end

%% -------------------- Save -------------------- 
PathToSave = (strcat(executablefolder,'\Recording Data\Saved GUI Data\'));

if ~isempty(Data)
    if strcmp(Type,".mat")
        
        if Autorun == "No" || Autorun == "SingleFolder"

            if ~isfolder(PathToSave)
                [file, path] = uiputfile('*.mat', 'Save as');
            else
                [file, path] = uiputfile(fullfile(PathToSave, '*.mat'), 'Save as');
            end
            
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
            if ~isfolder(PathToSave)
                [filename, filepath] = uiputfile('*.dat', 'Save as');
            else
                [filename, filepath] = uiputfile(fullfile(PathToSave, '*.dat'), 'Save as');
            end
               
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
                    filename = convertStringsToChars(strcat(SelectedFolder(dashindex(end-2)+1:dashindex(end-1)-1),".dat"));
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
            
        elseif Whattosave(1) == 0 && Whattosave(2) == 1
            filenamePrepro = filename; 

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
            fidPrepro = fopen(fullfile(filepath, filenamePrepro), 'Wb'); 
            for chunkIdx = 0 : cN-1
               % Update the progress bar
               fraction = chunkIdx/cN;
               msg = sprintf('Saving data... (%d%% done)', round(100*fraction));
               waitbar(fraction, h, msg);
               % Save the next data chunk
               %chunkData = Data.Preprocessed(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1);
               fwrite(fidPrepro,Data.Raw(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1), 'int16');
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

        msg = sprintf('Saving data... (%d%% done)', round(100));
               waitbar(fraction, h, msg);

        Data.Whattosave = [Whattosave(1),Whattosave(2)];
        filenameInfo = [filename(1:end-4),'_Info'];
        % Save the variables to the .mat file
        save(fullfile(filepath, filenameInfo), '-struct','Data','-v7.3');
        disp(['Variables saved to: ' filepath]);
        disp("Saving Data finished");

    end
    
else
    f = msgbox("An Error occured in 'Module_SaveData' function. Please check the 'Whattosave' Variable and that there is data in the strucutre to save.");
end

try 
    close(h);
end

try
    delete(ERDParameterWindowPrepr)
end