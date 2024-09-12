function Utility_Export_Dataset_Components(Data,Component,Format,executableFolder)

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

DataToExport = [1,2,3,4;4,3,2,1;1,2,3,4;4,3,2,1];

%% Save as .csv in chunks

if ~strcmp(Component,"Info") && strcmp(Format,".csv") || ~strcmp(Component,"Info") && strcmp(Format,".txt")

    h = waitbar(0, 'Exporting data...', 'Name','Exporting data...');
    
    if strcmp(Component,"Time")
        writematrix(strcat("*****", Component," Data in s *****"),Fullsavefile);
    elseif strcmp(Component,"Events")
        writematrix(strcat("*****", Component," Data in samples *****"),Fullsavefile);
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
        writematrix(strcat("***** Spike Data Structure *****"),Fullsavefile);
    end

    if iscell(DataToExport)
        numiters = length(DataToExport);
    elseif isstruct(DataToExport)
        numiters = length(fieldnames(DataToExport));
        Spikefieldnames = fieldnames(DataToExport);
    else
        numiters = size(DataToExport,1);
    end

    for ncomponents = 1:numiters
        
        if strcmp(Component,"Raw") || strcmp(Component,"Preprocessed") 
            writematrix(strcat("***** Channel ",num2str(ncomponents)," Data in uV *****"),Fullsavefile, 'WriteMode', 'append');
        elseif strcmp(Component,"Events")
            writematrix(strcat("*****", Component," Data for Event Channel ",Data.Info.EventChannelNames(ncomponents)," *****"),Fullsavefile, 'WriteMode', 'append');
        elseif strcmp(Component,"Spikes")
            writematrix(strcat("***** Content of Spike Data Field ",Spikefieldnames(ncomponents)," *****"),Fullsavefile, 'WriteMode', 'append');
        end

        if strcmp(Component,"Raw") || strcmp(Component,"Preprocessed") || strcmp(Component,"Time") 
            numchunks = 1000;
            cols_per_chunk = floor(length(DataToExport)/numchunks);
        else
            numchunks = 10;
            if iscell(DataToExport)
                cols_per_chunk = floor(length(DataToExport{ncomponents})/numchunks);
            elseif isstruct(DataToExport)
                StrucDataToSave = DataToExport.(Spikefieldnames{ncomponents})';
                cols_per_chunk = floor(length(StrucDataToSave)/numchunks);
            end
        end

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
                    chunk = DataToExport(ncomponents, col_range_Start:col_range_Stop);
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
            writematrix(chunk', Fullsavefile,'WriteMode', 'append', 'Delimiter', ',');
        
            % Update the progress bar
            fraction = nchunks/numchunks;
            msg = sprintf('Exporting data... (%d%% done)', round(100*fraction));
            waitbar(fraction, h, msg);
        end

    end
    
    % Close the file after writing
    %fclose(fileID);
    close(h);
    msgbox(strcat("Succesfully exported Dataseot to: ",Fullsavefile))
end

if strcmp(Format,".mat")
    dlgbox = msgbox(strcat(Component," is saved. Please wait until a message appears that saveing was succesfull!"));
    save(Fullsavefile,'DataToExport');
    delete(dlgbox);
    msgbox(strcat("Succesfully exported Dataseot to: ",Fullsavefile))
end



