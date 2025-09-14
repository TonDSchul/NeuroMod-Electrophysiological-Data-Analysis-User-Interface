function Utility_Export_Dataset_Components(Data,Component,Format,executableFolder)

%________________________________________________________________________________________
%% Function to export some dataset components as txt,csv or .mat
% This function gets called in the Export Dataset Components Window when
% the user clicks the "Export" button

% NOTE: At standard the folder to save dataset components in is:
% Data_to_GUI\Analysis_Results

% NOTE: To export Raw and Preprocessed data, use the save dataset function.
% This saves the raw and/or preprocessed data as a .dat file which is faster and easier on memory.
% Also prevents .txt or csv files from not being readable due to to much data.

% Input Arguments:
% 1. Data: main window structure holding dataset components (i.e. Data.Events, Data.Spikes ...)
% 2. Component: Selected dataset component as string, i.e. "Events" or "Spikes"
% 3. Format: Format to save data in, as string, ".mat" OR ".txt" OR ".csv"
% 4. executableFolder_ Path to GUI currently executed as char (created on startup of Main Window)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Save Path
current_time = char(datetime('now'));
current_time(current_time==':') = '_';
current_time(current_time==' ') = '_';

SaveFolder = strcat(executableFolder,"\Analysis Results\");
dashindex = find(Data.Info.Data_Path=='\');

Savefile = strcat(Data.Info.Data_Path(dashindex(end)+1:end),"_",Component,"_",current_time,"_",Format);

if isfolder(SaveFolder)
    Fullsavefile = fullfile(SaveFolder,Savefile);
else
    msgbox("Please select a folder to save the results in.")
    % Prompt user to select a folder
    Fullsavefile = uigetfile;
    
    % Check if the user canceled the dialog
    if Fullsavefile == 0
        disp('User canceled folder selection.');
        return;
    else
        disp(['Selected folder: ', Fullsavefile]);
    end
end

%% Take Dataset
DataToExport = Data.(Component);

%% Save as .csv or .txt in chunks
% Data and strings are always written to the file using writematrix. the
% rest of the code is concerned with writing additional string infos along
% with data and to write data in chunks to make it faster and to show
% proper progress of saveing.

if ~strcmp(Component,"Info") && strcmp(Format,".csv") || ~strcmp(Component,"Info") && strcmp(Format,".txt")
    
    %% Write Info File
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    
    writematrix(strcat("***** Recording Infos *****"),Fullsavefile, 'WriteMode', 'append');
    
    writestruct(Data.Info, Fullsavefile, FileType="json");
    
    writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    
    if strcmp(Component,"Info")
        msgbox(strcat("Succesfully exported Dataseot to: ",Fullsavefile))
        return;
    end

    h = waitbar(0, strcat("Exporting ",Component ," Data..."), 'Name','Exporting Data...');
    
    if strcmp(Component,"Time") || strcmp(Component,"TimeDownsampled")
        writematrix(strcat("*****", Component," Vector in Seconds *****"),Fullsavefile, 'WriteMode', 'append');
    elseif strcmp(Component,"Events")
        writematrix(strcat("*****", Component," Data in Samples *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** Event Channel Type: ",Data.Info.EventChannelType," *****"),Fullsavefile, 'WriteMode', 'append');
        EventChannelNames = [];
        for z = 1:length(Data.Info.EventChannelNames)
            if z ~= length(Data.Info.EventChannelNames)
                EventChannelNames=[EventChannelNames,Data.Info.EventChannelNames{z},','];
            else
                EventChannelNames=[EventChannelNames,Data.Info.EventChannelNames{z}];
            end
        end

        writematrix(strcat("***** Event Channel Names: ",EventChannelNames," *****"),Fullsavefile, 'WriteMode', 'append');

    elseif strcmp(Component,"Spikes")
        writematrix(strcat("***** Spike Data Structure *****"),Fullsavefile, 'WriteMode', 'append');
    elseif strcmp(Component,"EventRelatedSpikes")
        writematrix(strcat("***** Event Related Spike Data Structure *****"),Fullsavefile, 'WriteMode', 'append');
    elseif strcmp(Component,"EventRelatedData")
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** Event Related Data (3D Matrix with dimensions: nchannel x nevents x ntime) *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    elseif strcmp(Component,"PreprocessedEventRelatedData")
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat("***** Preprocessed Event Related Data (3D Matrix with dimensions: nchannel x nevents x ntime) *****"),Fullsavefile, 'WriteMode', 'append');
        writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
    end

    if iscell(DataToExport)
        numiters = length(DataToExport);
    elseif isstruct(DataToExport)
        numiters = length(fieldnames(DataToExport));
        Spikefieldnames = fieldnames(DataToExport);
    else
        if strcmp(Component,"EventRelatedData") || strcmp(Component,"PreprocessedEventRelatedData")
            numiters = 1; % save 3 d matrix, not multiple components of a structure or cell
        else
            numiters = size(DataToExport,1);
        end
    end

    for ncomponents = 1:numiters
        
        if strcmp(Component,"Time") || strcmp(Component,"TimeDownsampled")
            numchunks = 1000;
            cols_per_chunk = floor(length(DataToExport)/numchunks);
        else
            if strcmp(Component,"EventRelatedData") || strcmp(Component,"PreprocessedEventRelatedData") % 3d data is saved at once
                StrucDataToSave = DataToExport;
            else %% for faster saving and to display progress save in steps.
                numchunks = 10;
                if iscell(DataToExport)
                    cols_per_chunk = floor(length(DataToExport{ncomponents})/numchunks);
                elseif isstruct(DataToExport)
                    if ndims(DataToExport.(Spikefieldnames{ncomponents}))<3
                        StrucDataToSave = DataToExport.(Spikefieldnames{ncomponents})';
                        cols_per_chunk = floor(length(StrucDataToSave)/numchunks);
                    else
                        StrucDataToSave = DataToExport.(Spikefieldnames{ncomponents});
                    end
                end
            end
        end

        if strcmp(Component,"Events")
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat("*****", Component," Data for Event Channel ",Data.Info.EventChannelNames(ncomponents)," *****"),Fullsavefile, 'WriteMode', 'append');
            writematrix(strcat(" "),Fullsavefile, 'WriteMode', 'append');
        elseif strcmp(Component,"Spikes") || strcmp(Component,"EventRelatedSpikes")
            if strcmp(Spikefieldnames(ncomponents),"BiggestAmplWaveform") || strcmp(Spikefieldnames(ncomponents),"kept_spikes")
                continue;
            end

            if ndims(StrucDataToSave)<3
                writematrix(strcat("***** Content of Spike Data Field ",Spikefieldnames(ncomponents)," *****"),Fullsavefile, 'WriteMode', 'append');
            elseif ndims(StrucDataToSave)==3
                writematrix(strcat("***** Content of Spike Data Field ",Spikefieldnames(ncomponents)," is three dimensional and can not be sensibly saved here. Please export as .mat file for full compatibility *****"),Fullsavefile, 'WriteMode', 'append');
                disp(strcat("***** Content of Spike Data Field ",Spikefieldnames(ncomponents)," is three dimensional and can not be sensibly saved here. Please export as .mat file for full compatibility *****"));
                continue;
            end
        end      
        
        if ~strcmp(Component,"EventRelatedData") && ~strcmp(Component,"PreprocessedEventRelatedData") % 3d data is saved at once
            col_range_Start = 1;
            col_range_Stop = cols_per_chunk;

            for nchunks = 1:numchunks
                % Extract the current column chunk
                % iscell when event data is saved
                if nchunks ~=cols_per_chunk
                    if iscell(DataToExport)
                        chunk = DataToExport{ncomponents}(col_range_Start:col_range_Stop)';
                    elseif isstruct(DataToExport)
                        if strcmp(Spikefieldnames{ncomponents},'DataPath')
                            chunk = StrucDataToSave(col_range_Start:col_range_Stop);
                        else
                            %determine if matrix or vector
                            [nr,nc] = size(StrucDataToSave);
                            if nr == 1 || nc == 1
                                chunk = StrucDataToSave(col_range_Start:col_range_Stop)';
                            elseif nr ~= 1
                                chunk = StrucDataToSave(:,col_range_Start:col_range_Stop)';
                            end
                        end
                    else
                        chunk = DataToExport(ncomponents, col_range_Start:col_range_Stop)';
                    end
                else % last chunk: all data till ends
                    if iscell(DataToExport)
                        chunk = DataToExport{ncomponents}(col_range_Start:end)';
                    elseif isstruct(DataToExport)
                        if strcmp(Spikefieldnames{ncomponents},'DataPath')
                            chunk = StrucDataToSave(col_range_Start:col_range_Stop);
                        else
                            if nr == 1 || nc == 1
                                chunk = StrucDataToSave(col_range_Start:end)';
                            elseif nr ~= 1
                                chunk = StrucDataToSave(:,col_range_Start:end)';
                            end
                        end
                    else
                        chunk = DataToExport(ncomponents, col_range_Start:size(DataToExport,2));
                    end
                end
            
                col_range_Start = col_range_Stop+1;
                col_range_Stop = col_range_Stop+cols_per_chunk;
            
                % Write the current chunk of columns
                writematrix(chunk', Fullsavefile,'WriteMode', 'append');
            
                % Update the progress bar
                fraction = nchunks/numchunks;
                
                msg = sprintf('Exporting %s Data... (%d%% done)', Component, round(100*fraction));
                waitbar(fraction, h, msg);
            end

        else
            writematrix(DataToExport, Fullsavefile,'WriteMode', 'append');
        end
    end
    
    % Close the file after writing
    %fclose(fileID);
    close(h);
    msgbox(strcat("Succesfully exported Dataseot to: ",Fullsavefile))
end

if strcmp(Format,".mat")
    dlgbox = msgbox(strcat("Data Component ",Component," is saved. Please wait until a message appears that saving was succesfull! This window closes automatically."));

    Fullsavefile=convertStringsToChars(Fullsavefile);
    % Saved variable name is the name of the component selected
    eval([Component ' = DataToExport;']);
    % save as .mat
   
    if ~strcmp(Component,"Info")
        Info = Data.Info;
        save(Fullsavefile,Component,'Info','-v7.3');
    else
        save(Fullsavefile,Component,'-v7.3');
    end        
    
    delete(dlgbox);
    msgbox(strcat("Succesfully exported Dataseot to: ",Fullsavefile))
end



