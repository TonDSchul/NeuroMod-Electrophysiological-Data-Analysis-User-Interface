function [Data] = Spike_Module_Save_for_Kilosort(Data,Autorun,SelectedFolder,Format,FileType,DatasetType)
%________________________________________________________________________________________

%% Function to save Raw Data in int format as a .dat file to load in Kilosort

% standard folder to save in is 'Recording_Path/Kilosort

% Input:
% 1. Data: Data structure of toolbox. Required fields:
% 1.1. Data.Raw with Channel x Time data matrix (Preprocessing happens in Kilosort!)
% 2. Autorun: Variable specifiying whether function is called from the
% autorun function or from the GUI; "SingleFolder" or "MultipleFolder" when
% called from autorun, something else as a string whe not
% 3. SelectedFolder: Folder from whioch data was extracted/loaded, as char
% 4. Format: Int Format for saving Data; Options: 'int16' OR 'int32' as
% char for .dat files AND 'double' as char for .bin file type
% 4. FileType: Data type to save data in; Options: '.dat' OR '.bin'; .bin
% can only be saved in format 'double'
% 5. DatasetType: char, either 'Raw Data' or 'Preprocessed Data' to take to
% corresponding dataset component and save it

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% When just converting double to int. values very close to each other get rounded to the same number. Also, if values are close to 0, every value gets rounded to 0.
% Therefore, signal has to be scaled using the full range of int32 or int 16 to
% ensure the maximum resolution
% Alternative: When data format = Intan: Gain value (0.000195) can be used to convert data into integers by dividing by the raw signal by the gain value.

if strcmp(Format,'int16') || strcmp(Format,'int32')
    if strcmp(Format,'int16')
        % Define the range of int16
        SelectedIntMax = int16(2^15 - 1);
    elseif strcmp(Format,'int32')
        % Define the range of int32
        SelectedIntMax = int32(2^31 - 1);
    end
    
    if strcmp(DatasetType,'Raw Data')
        % Find the maximum absolute value in the vector
        maxAbsValue = max(abs(Data.Raw),[],'all');
    else
        % Find the maximum absolute value in the vector
        maxAbsValue = max(abs(Data.Preprocessed),[],'all');
    end
    
    % Calculate the scaling factor
    scalingFactor = double(SelectedIntMax) / double(maxAbsValue);
end

%% Select/Prepare folder -- only when autorun! In GUI Main Window not necessary
if Autorun == "SingleFolder" % if Autorun and single recording analysed, ask user for folder to save in

    %% Select folder and file to save
    if strcmp(Format,'int16') || strcmp(Format,'int32')
        [filename, filepath] = uiputfile('*.dat', 'Save File');
    else
        [filename, filepath] = uiputfile('*.bin', 'Save File');
    end
    
    % Check if the user canceled the operation
    if isequal(filename,0) || isequal(filepath,0)
        disp('User canceled the operation.');
        return;
    end

    folderPath = fullfile(filepath, filename);

elseif Autorun == "MultipleFolder" % if Autorun and multiple recording analysed, set folder automatically. Standard folder data for kilosort is saved in: RecordingFolder/Kilosort
    dashindex = find(SelectedFolder=='\');
    filepath = convertStringsToChars(strcat(SelectedFolder,'\'));
    if strcmp(Format,'int16') || strcmp(Format,'int32')
        filename = convertStringsToChars(strcat(SelectedFolder(dashindex(end-1)+1:dashindex(end)-1),".dat"));
    else
        filename = convertStringsToChars(strcat(SelectedFolder(dashindex(end-1)+1:dashindex(end)-1),".bin"));
    end
    folderPath = fullfile(filepath, filename);
else % If from GUI
    folderPath = SelectedFolder;
end

%% Scale Raw Data to int32 or int16
if strcmp(Format,'int16')

elseif strcmp(Format,'int32')

else
    folderPath = convertStringsToChars(folderPath);
    % Check if the folder exists
    dashindex = find(folderPath=='\');
    TempfolderPath = folderPath(1:dashindex(end));
    if ~exist(TempfolderPath, 'dir')
        mkdir(TempfolderPath);  % Create the folder
        fprintf('Folder created: %s\n', TempfolderPath);
    else
        fprintf('Folder already exists: %s\n', TempfolderPath);
    end
end

%% Save Raw data in chunks (increases performane)
% Initiate Progressbar
h = waitbar(0, 'Saving data...', 'Name','Saving data...');

%Set chunk size
dN = size(Data.Raw,2);
if dN >2000
    stepSize = round(dN/500);   
else
    stepSize = round(dN/100);  
end
dataIdx = [1:stepSize:dN, dN+1];   % always end at dN+1

nChunks = numel(dataIdx) - 1;  

% Save the data in chunks 
if strcmp(Format,'int16') || strcmp(Format,'int32') 
    fidRaw = fopen(folderPath, 'W'); 
else 
    fidRaw = fopen(folderPath, 'wb'); 
end

Lengthcount = 0;
for chunkIdx = 1:nChunks
    % progress bar
    fraction = chunkIdx/nChunks;
    msg = sprintf('Saving data... (%d%% done)', round(100*fraction));
    waitbar(fraction, h, msg);

    % chunk
    if strcmp(Format,'int32')
        if strcmp(DatasetType,'Raw Data')
            chunkData = int32(Data.Raw(:, dataIdx(chunkIdx):dataIdx(chunkIdx+1)-1) .* scalingFactor);
        else
            chunkData = int32(Data.Preprocessed(:, dataIdx(chunkIdx):dataIdx(chunkIdx+1)-1) .* scalingFactor);
        end
    elseif strcmp(Format,'int16')
        if strcmp(DatasetType,'Raw Data')
            chunkData = int16(Data.Raw(:, dataIdx(chunkIdx):dataIdx(chunkIdx+1)-1) .* scalingFactor);
        else
            chunkData = int16(Data.Preprocessed(:, dataIdx(chunkIdx):dataIdx(chunkIdx+1)-1) .* scalingFactor);
        end
    elseif strcmp(Format,'double')
        if strcmp(DatasetType,'Raw Data')
            chunkData = double(Data.Raw(:, dataIdx(chunkIdx):dataIdx(chunkIdx+1)-1));
        else
            chunkData = double(Data.Preprocessed(:, dataIdx(chunkIdx):dataIdx(chunkIdx+1)-1));
        end
    end

    Lengthcount = Lengthcount + length(chunkData);
    
    try
        if strcmp(Format,'int32')
            fwrite(fidRaw,chunkData,'*int32');
        elseif strcmp(Format,'int16')
            fwrite(fidRaw,chunkData,'*int16');
        else
            fwrite(fidRaw,chunkData,'*double');
        end
    catch
        msgbox("Could not access file location to save in. Make sure the recording folder still exists and there isnt already a file saved for sorting (at the same location) that is opened in external programs like the external Kilosort GUI or Phy.")
        warning("Could not access file location to save in. Make sure the recording folder still exists and there isnt already a file saved for sorting (at the same location) that is opened in external programs like the external Kilosort GUI or Phy.")
        return;
    end
end

if strcmp(Format,'int16') || strcmp(Format,'int32')
    %% Save Scalingfactor for later when kilosort is loaded to scale amplitude back
    Data.Info.KilosortScalingFactor = scalingFactor;
    
    %Save Scaling Factor in same directory as kilsoort data
    CharPath = convertStringsToChars(folderPath);
    dashindex = strfind(CharPath,'\');
    
    FolderForScaling = CharPath(1:dashindex(end)-1);
    
    if strcmp(Format,'int32')
        Savename = strcat(FolderForScaling,"\Scaling Factor int32.mat");
    elseif strcmp(Format,'int16')
        Savename = strcat(FolderForScaling,"\Scaling Factor int16.mat");
    end
    
    save(Savename,'scalingFactor');
end

fclose(fidRaw);
close(h);