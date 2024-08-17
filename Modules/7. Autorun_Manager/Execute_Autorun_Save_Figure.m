function Execute_Autorun_Save_Figure(Figure, ImageFormat, deletefigure, SaveName, LoadDataPath, Plottype, OENodePath, PlotAddons, RecordingsSystem, LoadedData, PlotName)

if LoadedData == false
    % Define name of the folder and files to create
    if strcmp(RecordingsSystem,"Open Ephys")
        folderName = strcat('Matlab\',OENodePath);
        if strcmp(PlotName,"TF")
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,"\",Plottype,"_",SaveName,PlotAddons);
        elseif strcmp(PlotName,"StaticPowerSpectrum") || strcmp(PlotName,"ContInternalSpikes") || strcmp(PlotName,"InternalEventSpikes") || strcmp(PlotName,"KilosortEventSpikes")
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName,'_',Plottype);
        elseif strcmp(PlotName,"KilosortContinousIteration") 
            Filename = strcat(LoadDataPath,'\Matlab\',OENodePath,'\Units','\',SaveName,'_',Plottype);
            folderName = 'Matlab\Units';
        elseif strcmp(PlotName,"KilosortContinous") 
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName,'_',Plottype);
        else
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName);
        end
    else
        folderName = 'Matlab';
        if strcmp(PlotName,"TF")
            Filename = strcat(LoadDataPath,"\Matlab\",Plottype,"_",SaveName,PlotAddons);
        elseif strcmp(PlotName,"StaticPowerSpectrum") || strcmp(PlotName,"ContInternalSpikes") || strcmp(PlotName,"InternalEventSpikes") || strcmp(PlotName,"KilosortEventSpikes") 
            Filename = strcat(LoadDataPath,"\Matlab\",Plottype,'_',SaveName);
        elseif strcmp(PlotName,"KilosortContinousIteration") 
            Filename = strcat(LoadDataPath,'\Matlab\Units\',SaveName,'_',Plottype);
            folderName = 'Matlab\Units';
        elseif strcmp(PlotName,"KilosortContinous") 
            Filename = strcat(LoadDataPath,"\Matlab\",SaveName,'_',Plottype);
        else
            Filename = strcat(LoadDataPath,"\Matlab\",SaveName);
        end
    end
    
    % Check if folder already exists
    if ~exist(strcat(LoadDataPath,"\",folderName),'dir')
        mkdir(strcat(LoadDataPath,"\",folderName));
    end

elseif LoadedData == true
    % Define name of the folder and files to create
    if strcmp(RecordingsSystem,"Open Ephys")
        folderName = strcat('Matlab\',OENodePath);
        if strcmp(PlotName,"TF")
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,"\",Plottype,"_",SaveName,PlotAddons);
        elseif strcmp(PlotName,"StaticPowerSpectrum") || strcmp(PlotName,"ContInternalSpikes") || strcmp(PlotName,"InternalEventSpikes") || strcmp(PlotName,"KilosortEventSpikes") 
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName,'_',Plottype);
        elseif strcmp(PlotName,"KilosortContinousIteration") 
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\Units\',SaveName,'_',Plottype);
            folderName = strcat('Matlab\',OENodePath,'\Units');
        elseif strcmp(PlotName,"KilosortContinous") 
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName,'_',Plottype);
        else
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName);
        end
    else
        folderName = 'Matlab';
        if isstring(LoadDataPath)
            LoadDataPath = convertStringsToChars(LoadDataPath);
        end
        Dashindex = find(LoadDataPath=='\');
        LoadDataPath = LoadDataPath(1:Dashindex(end-1)-1);

        if strcmp(PlotName,"TF")
            Filename = strcat(LoadDataPath,'\Matlab\',Plottype,"_",SaveName,PlotAddons);
        elseif strcmp(PlotName,"StaticPowerSpectrum") || strcmp(PlotName,"ContInternalSpikes") || strcmp(PlotName,"InternalEventSpikes") || strcmp(PlotName,"KilosortEventSpikes") || strcmp(PlotName,"KilosortContinous")
            Filename = strcat(LoadDataPath,'\Matlab\',Plottype,"_",SaveName);
        elseif strcmp(PlotName,"KilosortContinousIteration") 
            Filename = strcat(LoadDataPath,'\Matlab\Units\',SaveName,'_',Plottype);
            folderName = strcat('Matlab\Units');
        elseif strcmp(PlotName,"KilosortContinous") 
            Filename = strcat(LoadDataPath,'\Matlab\',Plottype,"_",SaveName);
        else  
            Filename = strcat(LoadDataPath,'\Matlab\',SaveName);
        end
        
    end

    % Check if folder already exists
    if ~exist(strcat(LoadDataPath,"\",folderName),'dir')
        mkdir(strcat(LoadDataPath,"\",folderName));
    end
end


% Check if the figure handle is valid
if ~ishandle(Figure)
    error('Invalid figure handle');
end

% Check if the format is valid
validFormats = {'fig', 'png', 'svg'};
if ~ismember(ImageFormat, validFormats)
    error('Invalid format. Valid formats are: ''fig'', ''png'', ''svg''.');
end

% Maximize the figure window
set(Figure, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);

% Pause briefly to allow the figure to render at the new size
pause(0.5);

% Save the figure in the specified format
switch ImageFormat
    case 'fig'
        savefig(Figure, [Filename, '.fig']);
        %disp(['Figure saved as ', filename, '.fig']);
    case 'png'
        saveas(Figure, strcat(Filename, '.png'));
        %disp(['Figure saved as ', filename, '.png']);
    case 'svg'
        saveas(Figure, [Filename, '.svg']);
        %disp(['Figure saved as ', filename, '.svg']);
end

disp('Figure succesfully saved');

if strcmp(deletefigure,"on")
    close(Figure);
end
