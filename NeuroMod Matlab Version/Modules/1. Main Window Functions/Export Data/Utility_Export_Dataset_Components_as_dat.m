function Utility_Export_Dataset_Components_as_dat(Data,Component,Format,SaveFolder,Fullsavefile,ExecuteOutsideGUI)

%________________________________________________________________________________________

%% This function exports dataset components, i.e. app.Data field structures as a .txt file

% Input:
% 1. Data: struc with main window data
% 2. Component: char, dataset component to extract. "Info" OR "Events" OR "Spikes" OR "Time" OR "TimeDownsampled"
% 3. Format: not necessary anymore but preserverd -- ToDO
% 4. SaveFolder: not necessary anymore but preserverd -- ToDO
% 5. Fullsavefile: path to save data in (with filename and ending)
% 6. ExecuteOutsideGUI: double, 1 or 0 whether called in GUI or
% outside of GUI in Autorun/batch analysis

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

folderPath = Fullsavefile;

%% Save Raw data
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
fidRaw = fopen(folderPath, 'wb'); 

Lengthcount = 0;
for chunkIdx = 1:nChunks
    % progress bar
    fraction = chunkIdx/nChunks;
    msg = sprintf('Saving data... (%d%% done)', round(100*fraction));
    waitbar(fraction, h, msg);

    % chunk
    chunkData = double(Data.(Component)(:, dataIdx(chunkIdx):dataIdx(chunkIdx+1)-1));

    Lengthcount = Lengthcount + length(chunkData);
    
    try
        fwrite(fidRaw,chunkData,'*double');
    catch
        msgbox("Could not access file location to save in. Make sure the recording folder still exists and there isnt already a file saved for sorting (at the same location) that is opened in external programs like the external Kilosort GUI or Phy.")
        warning("Could not access file location to save in. Make sure the recording folder still exists and there isnt already a file saved for sorting (at the same location) that is opened in external programs like the external Kilosort GUI or Phy.")
        return;
    end
end

fclose(fidRaw);
close(h);