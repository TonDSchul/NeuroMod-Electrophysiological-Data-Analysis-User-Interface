function [Datatoload] = Manage_Dataset_Module_LoadData(Format,FullPath,FullPathInfo,Textbox)

%________________________________________________________________________________________

%% Function to load data this toolbox created, saved either as a .mat or as a .dat file
% loading is performed with memory mapping function which gives the highest
% performance

% Input:
% 1. Format: Which format data should be save in; string either ".mat" or ".dat"
% 2. FullPath: Full Path the user selected to save data at. String
% including filename and fileending.
% 3. FullPathInfo: Path to the Info file saved along with the .dat data
% file, when .dat is selected as data format. If .mat is selected, Info file is saved in
% same .mat file as data and this input is disregarded
% 4. Textbox = handle to text in GUI displaying info

% Output: Datatoload = structure containing all data loaded (including info
% file) - i.e. Datatoload.Raw and Datatoload.Info and so on.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if strcmp(Format,".mat")
    Datatoload = [];
    %% Load Data   
    % Load the selected .mat file and save in the mainapp
    h = waitbar(0, 'Loading saved .mat file...', 'Name','Loading saved .mat file...');
    msg = sprintf('Loading saved .mat file... (%d%% done)', 50);
    waitbar(50, h, msg);
    Datatoload = load(FullPath);
end

if strcmp(Format,".dat")
    
    Header = load(FullPathInfo);

    h = waitbar(0, 'Preparing Data to load...', 'Name','Preparing Data to load...');
    msg = sprintf('Preparing Data to Save... (%d%% done)', 25);
    waitbar(25, h, msg);
    
    nchan = Header.Info.NrChannel;
    ntime = Header.Info.num_data_points;
    
    Datatoload = [];
    FileIdentifier = fopen(FullPath,'r');

    if FileIdentifier == -1
        error('Failed to open the file.');
    end

    msg = sprintf('Loading Data... (%d%% done)', 50);
    waitbar(50, h, msg);

    if isfield(Header,'Whattosave')
        if Header.Whattosave(1) == 1 && Header.Whattosave(2) == 0
            dN = ntime;
            Datatoload.Raw = NaN(nchan,ntime);
            Datatoload.Raw = NaN(nchan,ntime);
            mmf = memmapfile(FullPath, 'Format', {'int16', [nchan ntime], 'x'});

            Datatoload.Raw = mmf.Data.x(1:nchan,1:dN);
            Datatoload.Raw = single(Datatoload.Raw) / Header.Info.scalingFactor;

        elseif Header.Whattosave(1) == 0 && Header.Whattosave(2) == 1
        
            Datatoload.Raw = [];
            dN = ntime;

            Datatoload.Raw = NaN(nchan,ntime);
            mmf = memmapfile(FullPath, 'Format', {'int16', [nchan ntime], 'x'});
            Datatoload.Raw = mmf.Data.x(1:nchan,1:dN);
            Datatoload.Raw = single(Datatoload.Raw) / Header.Info.scalingFactor;
            Datatoload.Preprocessed = Datatoload.Raw;

        elseif Header.Whattosave(1) == 1 && Header.Whattosave(2) == 1
  
            if isfield(Header.Info,'DownsampleFactor')
                ntime_Preprocessed = Header.Info.num_data_points_Downsampled;
            else
                ntime_Preprocessed = ntime;
            end

            dN = ntime+ntime_Preprocessed;
            
            Datatoload.Raw = NaN(nchan,dN);
            Datatoload.Preprocessed = NaN(nchan,ntime_Preprocessed);

            mmf = memmapfile(FullPath, 'Format', {'int16', [nchan dN], 'x'});
            Datatoload.Raw = mmf.Data.x(1:nchan,1:dN);

            Datatoload.Preprocessed = Datatoload.Raw(:,ntime+1:end);
            Datatoload.Raw(:,ntime+1:end) = [];

            Datatoload.Raw = single(Datatoload.Raw) / Header.Info.scalingFactor(1);
            Datatoload.Preprocessed = single(Datatoload.Preprocessed) / Header.Info.scalingFactor(2);
        end
    end

    msg = sprintf('Loading Header Info... (%d%% done)', 75);
    waitbar(75, h, msg);

    Textbox.Value = [Textbox.Value;"Loading Channel Data finished"];

    if isfield(Header,'Events')
        Datatoload.Events = Header.Events;
        fieldsToDelete = {'Events'};
        % Delete fields
        Header = rmfield(Header, fieldsToDelete);
    end
    if isfield(Header,'Spikes')
        Datatoload.Spikes = Header.Spikes;
        fieldsToDelete = {'Spikes'};
        % Delete fields
        Header = rmfield(Header, fieldsToDelete);
    end
    if isfield(Header,'InternalSpikes')
        Datatoload.InternalSpikes = Header.InternalSpikes;
        fieldsToDelete = {'InternalSpikes'};
        % Delete fields
        Header = rmfield(Header, fieldsToDelete);
    end

    if isfield(Header,'EventRelatedSpikes')
        Datatoload.EventRelatedSpikes = Header.EventRelatedSpikes;
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Header = rmfield(Header, fieldsToDelete);
    end

    if isfield(Header,'PreprocessedEventRelatedData')
        Datatoload.PreprocessedEventRelatedData = Header.PreprocessedEventRelatedData;
        fieldsToDelete = {'PreprocessedEventRelatedData'};
        % Delete fields
        Header = rmfield(Header, fieldsToDelete);
    end

    if isfield(Header,'EventRelatedData')
        Datatoload.EventRelatedData = Header.EventRelatedData;
        fieldsToDelete = {'EventRelatedData'};
        % Delete fields
        Header = rmfield(Header, fieldsToDelete);
    end

    if isfield(Header,'Whattosave')
        fieldsToDelete = {'Whattosave'};
        % Delete fields
        Header = rmfield(Header, fieldsToDelete);
    end

    if isfield(Header.Info,'scalingFactor')
        fieldsToDelete = {'scalingFactor'};
        % Delete fields
        Header.Info = rmfield(Header.Info, fieldsToDelete);
    end

    if isfield(Header.Info,'num_data_points_Downsampled')
        fieldsToDelete = {'num_data_points_Downsampled'};
        % Delete fields
        Header.Info = rmfield(Header.Info, fieldsToDelete);
    end

    Datatoload.Info = Header.Info;
    Datatoload.Time = Header.Time;

    if isfield(Header,'TimeDownsampled')
        Datatoload.TimeDownsampled = Header.TimeDownsampled;
    end

end

msg = sprintf('Loading Header Info... (%d%% done)', 100);
waitbar(100, h, msg);
close(h);