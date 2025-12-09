function Utility_Export_Dataset_Components_as_XLSX(Data,Component,Format,SaveFolder,Fullsavefile,ExecuteOutsideGUI)

DataToExport = Data.(Component);

%% Save as xlsx
if strcmp(Component,"Info")
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
    
    if ExecuteOutsideGUI == 0
        msgbox(strcat("Succesfully exported Dataset to: ",Fullsavefile))
    else
        disp(strcat("Succesfully exported Dataset to: ",Fullsavefile))
    end
end

if ~strcmp(Component,"Info") 
    
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
        
        msg = sprintf('Exporting %s Data.. (%d%% done)', Component, round(25));
        waitbar(0.25, h, msg);

        TextInfos = {};
        TextInfos{end+1,1} = convertStringsToChars(strcat("*****", Component," Data in Samples *****"));
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Event Channel Type: ",Data.Info.EventChannelType," *****"));
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Event Channel Names: ",EventChannelNames," *****"));

        writecell(TextInfos, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);
                
        msg = sprintf('Exporting %s Data.. (%d%% done)', Component, round(50));
        waitbar(0.50, h, msg);

        % Write Data
        TempEventChannelNames = string(strsplit(EventChannelNames,','));
        for ii = 1:length(DataToExport)
            if size(DataToExport{ii},1)<size(DataToExport{ii},2)
                DataToExport{ii} = DataToExport{ii}';
            end
        end

        msg = sprintf('Exporting %s Data.. (%d%% done)', Component, round(75));
        waitbar(0.75, h, msg);

        % create table holding event infos
        vars  = DataToExport(:)';                     % column vectors
        names = cellfun(@convertStringsToChars, ...
                        TempEventChannelNames(:), ...
                        'UniformOutput', false);
        
        T = table(vars{:}, 'VariableNames', names);

        writetable(T, Fullsavefile, 'Sheet', 1, 'Range', ['A' num2str(tableStartRow)]);

        msg = sprintf('Exporting %s Data.. (%d%% done)', Component, round(100));
        waitbar(1, h, msg);

    elseif strcmp(Component,"Spikes")
        TextInfos = {};
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Spike Data Structure *****"));
        TextInfos{end+1,1} = convertStringsToChars(strcat("***** Spike Times in Samples, Spike Depths in um when using spike sorter or as channel ID when using internal spike detection, SpikeAmps in mV*****"));
        
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

            msg = sprintf('Exporting %s Data.. (%d%% done)', Component, round(100*(ii/length(AllfieldNames))));
            waitbar(ii/length(AllfieldNames), h, msg);

        end
    end
    
    % Close the file after writing
    %fclose(fileID);
    close(h);

    if ExecuteOutsideGUI == 0
        msgbox(strcat("Succesfully exported Dataset to: ",Fullsavefile))
    else
        disp(strcat("Succesfully exported Dataset to: ",Fullsavefile))
    end
end