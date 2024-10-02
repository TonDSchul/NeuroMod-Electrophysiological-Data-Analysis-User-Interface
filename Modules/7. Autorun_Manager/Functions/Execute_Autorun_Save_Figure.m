function Execute_Autorun_Save_Figure(Figure, ImageFormat, deletefigure, SaveName, LoadDataPath, Plottype, OENodePath, PlotAddons, RecordingsSystem, LoadedData, PlotName)

%________________________________________________________________________________________
%% This is the main function to save figures when plotted during an autorun

% This function is called every time, a plotted figure is supposed to be
% saved. This follows a standard folder scheme. 
% For Intan: Pictures of all analysis
% excecpt of waveform plots for individual units is save in the
% recordingfolder/Matlab in the specified format. Unit waveform plots are
% saved in recordingfolder/Matlab/Units.
% For Open Ephys: Pictures of all analysis
% excecpt of waveform plots for individual units is save in the
% recordingfolder/Matlab/Record Node in the specified format. Unit waveform plots are
% saved in recordingfolder/Matlab/Record Node/Units.

% Inputs:
% 1. Figure: figure axes handle to plot in
% 2. ImageFormat: char, Otions: 'png', 'svg', 'fig'
% 3. deletefigure: if 1: figure is deleted after saving, Otherwise 0
% 4. SaveName: char, name of the saved picture (gets combined with Plottype input argument)
% 5. LoadDataPath: char, path to currently analyzed folder
% 6. Plottype: char, specifies from which module the analysis comes (kilosort and internal spikes would have same name when save if the kind is not incorporated in the name)
% 7. OENodePath: Just open Ephys: name of the record node as the folder to
% save figures in (Path/Matlab/Record Node)
% 8. PlotAddons: char, If one analysis has multiple ways of plotting that
% are looped through, specified the name here. i.e. for time frequency power user
% can plot ITPC and Time Frequency Power which has to be incorporate in
% name to make the unique
% 9. RecordingsSystem: char, just important if 'Open Ephys', not relevant
% for other recording systems here
% 10. LoadedData: true when data was laoded, false when it was executed
% 11. PlotName: Name of the current plot to identify where this function is
% executed. For Options see below

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if LoadedData == false
    % Define name of the folder and files to create
    if strcmp(RecordingsSystem,"Open Ephys")
        folderName = strcat('Matlab\',OENodePath);
        if strcmp(PlotName,"TF")
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,"\",Plottype," ",SaveName,PlotAddons);
        elseif strcmp(PlotName,"StaticPowerSpectrum") || strcmp(PlotName,"ContInternalSpikes") || strcmp(PlotName,"InternalEventSpikes") || strcmp(PlotName,"KilosortEventSpikes") || strcmp(PlotName,"ContWaveforms")
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName,' ',Plottype);
        elseif strcmp(PlotName,"KilosortContinousIteration") || strcmp(PlotName,"InternalContinousIteration") || strcmp(PlotName,"KilosortEventIteration") || strcmp(PlotName,"InternalEventIteration")
            Filename = strcat(LoadDataPath,'\Matlab\',OENodePath,'\Units','\',SaveName,' ',Plottype);
            folderName = strcat('\Matlab\',OENodePath,'\Units');
        elseif strcmp(PlotName,"KilosortContinous") 
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName,' ',Plottype);
        else
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName);
        end
    else
        folderName = 'Matlab';
        if strcmp(PlotName,"TF")
            Filename = strcat(LoadDataPath,"\Matlab\",Plottype," ",SaveName,PlotAddons);
        elseif strcmp(PlotName,"StaticPowerSpectrum") || strcmp(PlotName,"ContInternalSpikes") || strcmp(PlotName,"InternalEventSpikes") || strcmp(PlotName,"KilosortEventSpikes") || strcmp(PlotName,"ContWaveforms")
            Filename = strcat(LoadDataPath,"\Matlab\",Plottype,' ',SaveName);
        elseif strcmp(PlotName,"KilosortContinousIteration") || strcmp(PlotName,"InternalContinousIteration") || strcmp(PlotName,"KilosortEventIteration") || strcmp(PlotName,"InternalEventIteration")
            Filename = strcat(LoadDataPath,'\Matlab\Units\',SaveName,' ',Plottype);
            folderName = 'Matlab\Units';
        elseif strcmp(PlotName,"KilosortContinous") 
            Filename = strcat(LoadDataPath,"\Matlab\",SaveName,' ',Plottype);
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
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,"\",Plottype," ",SaveName,PlotAddons);
        elseif strcmp(PlotName,"StaticPowerSpectrum") || strcmp(PlotName,"ContInternalSpikes") || strcmp(PlotName,"InternalEventSpikes") || strcmp(PlotName,"KilosortEventSpikes") || strcmp(PlotName,"ContWaveforms")
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName,' ',Plottype);
        elseif strcmp(PlotName,"KilosortContinousIteration") || strcmp(PlotName,"InternalContinousIteration") || strcmp(PlotName,"KilosortEventIteration") || strcmp(PlotName,"InternalEventIteration")
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\Units\',SaveName,' ',Plottype);
            folderName = strcat('Matlab\',OENodePath,'\Units');
        elseif strcmp(PlotName,"KilosortContinous") 
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName,' ',Plottype);
        else
            Filename = strcat(LoadDataPath,"\Matlab\",OENodePath,'\',SaveName);
        end
    else
        folderName = 'Matlab';
        if isstring(LoadDataPath)
            LoadDataPath = convertStringsToChars(LoadDataPath);
        end
        % % Dashindex = find(LoadDataPath=='\');
        % % LoadDataPath = LoadDataPath(1:Dashindex(end-1)-1);

        if strcmp(PlotName,"TF")
            Filename = strcat(LoadDataPath,'\Matlab\',Plottype," ",SaveName,PlotAddons);
        elseif strcmp(PlotName,"StaticPowerSpectrum") || strcmp(PlotName,"ContInternalSpikes") || strcmp(PlotName,"InternalEventSpikes") || strcmp(PlotName,"KilosortEventSpikes") || strcmp(PlotName,"KilosortContinous") || strcmp(PlotName,"ContWaveforms")
            Filename = strcat(LoadDataPath,'\Matlab\',Plottype," ",SaveName);
        elseif strcmp(PlotName,"KilosortContinousIteration") || strcmp(PlotName,"InternalContinousIteration") || strcmp(PlotName,"KilosortEventIteration") || strcmp(PlotName,"InternalEventIteration")
            Filename = strcat(LoadDataPath,'\Matlab\Units\',SaveName,' ',Plottype);
            folderName = strcat('Matlab\Units');
        elseif strcmp(PlotName,"KilosortContinous") 
            Filename = strcat(LoadDataPath,'\Matlab\',Plottype," ",SaveName);
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

disp(strcat("Figure ",SaveName," succesfully saved."));

if strcmp(deletefigure,"on")
    close(Figure);
end
