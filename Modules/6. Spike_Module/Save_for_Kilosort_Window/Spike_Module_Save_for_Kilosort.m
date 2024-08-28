function [Data] = Spike_Module_Save_for_Kilosort(Data,Autorun,SelectedFolder,Format)
%________________________________________________________________________________________

%% Function to save Raw Data in int format as a .dat file to load in Kilosort
% Input:
% 1. Data: Data structure of toolbox. Required fields:
% 1.1. Data.Raw with Channel x Time data matrix (Preprocessing happens in Kilosort!)
% 2. Autorun: Variable specifiying whether function is called from the
% autorun function or from the GUI; "SingleFolder" or "MultipleFolder" when
% called from autorun, something else as a string whe not
% 3. SelectedFolder: Folder from whioch data was extracted/loaded, as char
% 4. Format: Int Format for saving Data; Options: 'int16' OR 'int32' as
% char -- doesnt make a qualitative difference

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% When just converting double to int. values very close to each other get rounded to the same number. Also, if values are close to 0, every value gets rounded to 0.
% Therefore, signal has to be scaled using the full range of int32 or int 16 to
% ensure the maximum resolution
% Alternative: When data format = Intan: Gain value (0.000195) can be used to convert data into integers by dividing by the raw signal by the gain value.

if strcmp(Format,'int16')
    % Define the range of int16
    SelectedIntMax = int16(2^15 - 1);
elseif strcmp(Format,'int32')
    % Define the range of int32
    SelectedIntMax = int32(2^31 - 1);
end

% Find the maximum absolute value in the vector
maxAbsValue = max(abs(Data.Raw),[],'all');

% Calculate the scaling factor
scalingFactor = double(SelectedIntMax) / double(maxAbsValue);

%% Select/Prepare folder -- only when autorun! In GUI Main Window not necessary
if Autorun == "SingleFolder" % if Autorun and single recording analysed, ask user for folder to save in

    %% Select folder and file to save
    [filename, filepath] = uiputfile('*.dat', 'Save File');
    
    % Check if the user canceled the operation
    if isequal(filename,0) || isequal(filepath,0)
        disp('User canceled the operation.');
        return;
    end

    folderPath = fullfile(filepath, filename);

elseif Autorun == "MultipleFolder" % if Autorun and multiple recording analysed, set folder automatically. Standard folder data for kilosort is saved in: RecordingFolder/Kilosort
    dashindex = find(SelectedFolder=='\');
    filepath = convertStringsToChars(strcat(SelectedFolder,'\'));
    filename = convertStringsToChars(strcat(SelectedFolder(dashindex(end-1)+1:dashindex(end)-1),".dat"));
    folderPath = fullfile(filepath, filename);
else % If from GUI
    folderPath = SelectedFolder;
end

%% Scale Raw Data to int32 or int16
if strcmp(Format,'int16')
    SaveDataRaw = int16(Data.Raw .* scalingFactor);
elseif strcmp(Format,'int32')
    SaveDataRaw = int32(Data.Raw .* scalingFactor);
end

%% Save Raw data in chunks (increases performane)
% Initiate Progressbar
h = waitbar(0, 'Saving data...', 'Name','Saving data...');
cN = 100;  % number of steps/chunks
% Divide the data into chunks (last chunk is smaller than the rest)
dN = size(SaveDataRaw,2);
dataIdx = [1 : round(dN/cN) : dN, dN+1];  % cN+1 chunk location indexes
% Save the data in chunks
fidRaw = fopen(folderPath, 'W'); 
for chunkIdx = 0 : cN-1
   % Update the progress bar
   fraction = chunkIdx/cN;
   msg = sprintf('Saving data... (%d%% done)', round(100*fraction));
   waitbar(fraction, h, msg);
   % Save the next data chunk
   chunkData = SaveDataRaw(:,dataIdx(chunkIdx+1) : dataIdx(chunkIdx+2)-1);
   if strcmp(Format,'int32')
    fwrite(fidRaw,chunkData, '*int32');
   elseif strcmp(Format,'int16')
    fwrite(fidRaw,chunkData, '*int16');
   end
end

%% Save Scalingfactor for later when kilosort is loaded to scale amplitude back
Data.Info.KilosortScalingFactor = scalingFactor;

fclose(fidRaw);
close(h);