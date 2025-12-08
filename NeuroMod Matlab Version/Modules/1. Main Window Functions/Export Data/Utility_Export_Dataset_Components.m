function Utility_Export_Dataset_Components(Data,Component,Format,executableFolder,ExecuteOutsideGUI)

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
% 5. ExecuteOutsideGUI: double 1 or 0, if executed outside of gui use 1

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Save Path
current_time = char(datetime('now'));
current_time(current_time==':') = '_';
current_time(current_time==' ') = '_';

if ExecuteOutsideGUI == 0
    SaveFolder = strcat(executableFolder,"\Analysis Results\");
else
    SaveFolder = strcat(Data.Info.Data_Path,"\Matlab\Exported Results\");
    if ~exist(SaveFolder, 'dir')
        mkdir(SaveFolder);
    end
end
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
if strcmp(Component,"Info") && strcmp(Format,".xlsx")
    TextInfos = {};

    %% Write Info File    
    TextInfos{end+1} = convertStringsToChars(strcat("***** Recording Infos *****"));
    %% Write TextInfos to Excel (starting at row 1, column A)
    writecell(TextInfos', Fullsavefile, 'Sheet', 1, 'Range', 'A1');

    %% Write Info
    % Example: Convert structure fields into "field: value" text
    fn = fieldnames(Data.Info);
    TextInfos = {};
    for k = 1:numel(fn)
        val = Data.Info.(fn{k});
        if isnumeric(val)
            if size(val,1)<size(val,2)
                val = val';
            end

            valStr = num2str(val);
        elseif isstring(val) || ischar(val)
            valStr = char(val);
        else
            valStr = '<non-displayable>';
        end

        if isnumeric(val) && length(val)>1
            TextInfos{end+1,1} = ['***** Meta Data: ' fn{k} ' *****'];
            Currentlength = length(TextInfos);
            for tt = 1:length(valStr)
                TextInfos{Currentlength+tt} = valStr(tt,:);
            end
        else
            TextInfos{end+1,1} = ['***** Meta Data: ' fn{k} ' = ' valStr ' *****'];
        end

    end
    
    % Write to Excel (column E, starting at row 1)
    writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', 'A3');

end

if ~strcmp(Component,"Info") && strcmp(Format,".xlsx")
    
    TextInfos = {};
    
    %% Write Info File    
    TextInfos{end+1} = convertStringsToChars(strcat("***** Recording Infos *****"));
    
    %% Write TextInfos to Excel (starting at row 1, column A)
    writecell(TextInfos', Fullsavefile, 'Sheet', 1, 'Range', 'A1');
    
    TempInfo = [];
    TempInfo.Info = Data.Info;
    %% Delete Info files too big to reasonably show
    if isfield(TempInfo.Info,'Channelorder')
        fieldsToDelete = {'Channelorder'};
        % Delete fields
        TempInfo.Info = rmfield(TempInfo.Info, fieldsToDelete);
    end
    if isfield(TempInfo.Info,'EventRelatedActiveChannel')
        fieldsToDelete = {'EventRelatedActiveChannel'};
        % Delete fields
        TempInfo.Info = rmfield(TempInfo.Info, fieldsToDelete);
    end
    if isfield(TempInfo.Info,'EventRelatedTime')
        fieldsToDelete = {'EventRelatedTime'};
        % Delete fields
        TempInfo.Info = rmfield(TempInfo.Info, fieldsToDelete);
    end
    
    %% Write Info
    % Example: Convert structure fields into "field: value" text
    fn = fieldnames(TempInfo.Info);
    TextInfos = {};
    for k = 1:numel(fn)
        val = TempInfo.Info.(fn{k});
        if isnumeric(val)
            valStr = num2str(val);
        elseif isstring(val) || ischar(val)
            valStr = char(val);
        else
            valStr = '<non-displayable>';
        end
        TextInfos{end+1,1} = ['***** Meta Data: ' fn{k} ' = ' valStr ' *****'];
    end
    
    % Write to Excel (column E, starting at row 1)
    writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', 'F1');
    
    h = waitbar(0, strcat("Exporting ",Component ," Data..."), 'Name','Exporting Data...');
    
    tableStartRow = length(TextInfos) + 2;  % leave 1 empty row below TextInfos

    %%%% T = table(XData', YData', XTick', 'VariableNames', {'Spike Amplitude (mV)','Depth (um)','Spike Amplitude Labels (mV)'});

    if strcmp(Component,"Time") || strcmp(Component,"TimeDownsampled")
        TextInfos = {};
        TextInfos{end+1,1} = convertStringsToChars(strcat("*****", Component," Vector in Seconds *****"));

        writecell(TextInfos', Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);

        T = table(DataToExport', 'VariableNames', {'Time (s)'});

        writetable(T, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow+2)]);

    elseif strcmp(Component,"Events")
        EventChannelNames = [];
        for z = 1:length(Data.Info.EventChannelNames)
            if z ~= length(Data.Info.EventChannelNames)
                EventChannelNames=[EventChannelNames,Data.Info.EventChannelNames{z},','];
            else
                EventChannelNames=[EventChannelNames,Data.Info.EventChannelNames{z}];
            end
        end

        TextInfos = {};
        TextInfos{end+1,1} = convertStringsToChars(strcat("*****", Component," Data in Samples *****"));
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Event Channel Type: ",Data.Info.EventChannelType," *****"));
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Event Channel Names: ",EventChannelNames," *****"));

        writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);
        
        % Write Data
        TempEventChannelNames = string(strsplit(EventChannelNames,','));
        for ii = 1:length(DataToExport)
            if size(DataToExport{ii},1)<size(DataToExport{ii},2)
                DataToExport{ii} = DataToExport{ii}';
            end
        end
        % create table holding event infos
        vars  = DataToExport(:)';                     % column vectors
        names = cellfun(@convertStringsToChars, ...
                        TempEventChannelNames(:), ...
                        'UniformOutput', false);
        
        T = table(vars{:}, 'VariableNames', names);

        writetable(T, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);


    elseif strcmp(Component,"Spikes")
        TextInfos = {};
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Spike Data Structure *****"));
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Spike Times in Samples, Spike Depths in um when using spike sorter or as channel ID when using internal spike detection*****"));
        
        writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);
        
        tableStartRow = tableStartRow + 3;

        AllfieldNames = fieldnames(DataToExport);
        
        Extraontop  = 0;
        for ii = 1:length(AllfieldNames)
            currentfieldname = AllfieldNames{ii};
            % create table holding event infos
            if size(DataToExport.(currentfieldname),1)==1 && size(DataToExport.(currentfieldname),2)~=1
                DataToExport.(currentfieldname) = DataToExport.(currentfieldname)';
            end

            if ~isempty(DataToExport.(currentfieldname))
                if size(DataToExport.(currentfieldname),2)==1
                    T = table(DataToExport.(currentfieldname), 'VariableNames', {currentfieldname});
                    CurrentTableletter = char('A' + (ii-1 + Extraontop));
                    writetable(T, Fullsavefile, 'Sheet', 1, 'Range', [CurrentTableletter num2str(tableStartRow)]);
                else
                    if size(DataToExport.(currentfieldname),2)==2 % Spike Positions and channel locations
                        data = DataToExport.(currentfieldname);      % N×2 numeric
                        T = table(data(:,1), data(:,2), ...
                            'VariableNames', {['X ' currentfieldname], ['Y ' currentfieldname]});

                        %Extraontop = Extraontop
                        CurrentTableletter = char('A' + (ii-1+Extraontop));
                        writetable(T, Fullsavefile, 'Sheet', 1, 'Range', [CurrentTableletter num2str(tableStartRow)]);
                        Extraontop = Extraontop+1;
                    else
                        TextInfos = {};
                        CurrentTableletter = char('A' + (ii-1+Extraontop));
                        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Content of Spike Data Field ",AllfieldNames{ii}," is three dimensional and can not be sensibly saved here. Please export as .mat file for full compatibility *****"));                            
                        writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', [CurrentTableletter num2str(tableStartRow)]);
                        warning(strcat("***** Content of Spike Data Field ",AllfieldNames{ii}," is three dimensional and can not be sensibly saved here. Please export as .mat file for full compatibility *****"));
                    end
                end
            else
                CurrentTableletter = char('A' + (ii-1));
                TextInfos = {};
                TextInfos{end+1,1} = convertStringsToChars(currentfieldname);                
                TextInfos{end+1,1} = convertStringsToChars(strcat("No values!"));                
                writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', [CurrentTableletter num2str(tableStartRow)]);
            end
            T = [];
        end
    elseif strcmp(Component,"EventRelatedSpikes")
        TextInfos = {};
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Event Related Data (3D Matrix with dimensions: nchannel x nevents x ntime) *****"));
        writecell(TextInfos', Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);
    end
    
    % Close the file after writing
    %fclose(fileID);
    close(h);
    msgbox(strcat("Succesfully exported Dataset to: ",Fullsavefile))
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
    msgbox(strcat("Succesfully exported Dataset to: ",Fullsavefile))
end



