function Manage_Dataset_SaveData_NWB(Data,Method,DataType)

%% ----------------- Get Save Location


if strcmp(Method,"HDF5")
    

%% ----------------------- NWB Format -----------------------
else
    [file, path] = uiputfile('*.nwb', 'Save as');
    
    SavePath = fullfile(path,file);

    generateCore()

    % Initialize MatNWB
    nwb = NwbFile( ...
        'session_description', 'NeuroMod Export', ...
        'identifier', 'EX123', ...
        'session_start_time', datetime('now'), ...
        'general_experimenter', 'NeuroMod User', ...
        'general_session_id', 'Session01');
    
    % Example data
    if strcmp(DataType,"Raw Data")
        data = (Data.Raw/1000);  % convert mv to Volts!
    else
        data = (Data.Preprocessed/1000);  % convert mv to Volts!
    end

    sampling_rate = Data.Info.NativeSamplingRate; % Hz

    % Create ElectricalSeries object
    ephys_ts = types.core.ElectricalSeries( ...
        'starting_time', 0.0, ...
        'starting_time_rate', sampling_rate, ...
        'data', types.untyped.DataPipe('data', data, 'axis', 2), ... % transpose: time x channels
        'electrodes', types.untyped.SoftLink('/general/extracellular_ephys/electrodes'));
    
    % Add device and electrode group (minimal setup)
    device = types.core.Device('description', 'ephys device');
    nwb.general_devices.set('device1', device);
    
    eg = types.core.ElectrodeGroup( ...
        'description', 'ephys electrode group', ...
        'location', 'brain', ...
        'device', types.untyped.SoftLink('/general/devices/device1'));
    nwb.general_extracellular_ephys.set('eg1', eg);
    

    %% ---------------------------- PROBE INFO GENERATION ----------------------------
    tempactivechannel = strjoin(string(Data.Info.ProbeInfo.ActiveChannel), ',');
    activechannel{1} = convertStringsToChars(tempactivechannel);
    [xcoords,ycoords,~] = Manage_Dataset_Save_ProbeInfo_Kilosort("",Data.Info.ProbeInfo.NrRows,Data.Info.ProbeInfo.NrChannel,num2str(Data.Info.ChannelSpacing),activechannel,Data.Info.ProbeInfo.OffSetRows,str2double(Data.Info.ProbeInfo.OffSetRowsDistance),str2double(Data.Info.ProbeInfo.VertOffset),str2double(Data.Info.ProbeInfo.HorOffset),0);
                
    num_channels = str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows);
    channel_labels = arrayfun(@(x) sprintf('Ch%d', x), 1:num_channels, 'UniformOutput', false);
    
    channel_labels = cellfun(@char, channel_labels, 'UniformOutput', false);

    % Prepare columns for the electrode table
    electrodes_table = types.core.ElectrodesTable();
    
    % Standard required columns
    electrodes_table.id = types.hdmf_common.ElementIdentifiers('data', int64(0:num_channels-1)');
    electrodes_table.x = types.hdmf_common.VectorData('data', xcoords, 'description', 'x coordinate');
    electrodes_table.y = types.hdmf_common.VectorData('data', ycoords, 'description', 'y coordinate');
    electrodes_table.z = types.hdmf_common.VectorData('data', nan(num_channels,1), 'description', 'z coordinate');
    electrodes_table.imp = types.hdmf_common.VectorData('data', nan(num_channels,1), 'description', 'Impedance');
    electrodes_table.location = types.hdmf_common.VectorData( ...
        'data', repmat({'brain'}, num_channels, 1), ...
        'description', 'Recording location');
    electrodes_table.filtering = types.hdmf_common.VectorData( ...
        'data', repmat({'none'}, num_channels, 1), ...
        'description', 'No filtering applied');
    
    % Electrode group reference
    eg_ref = types.untyped.ObjectView('/general/extracellular_ephys/eg1');
    electrodes_table.group = types.hdmf_common.VectorData( ...
        'data', repmat({eg_ref}, num_channels, 1), ...
        'description', 'Reference to ElectrodeGroup');
    
    % Human-readable group names (like 'Ch1', 'Ch2', etc.)
    electrodes_table.group_name = types.hdmf_common.VectorData( ...
        'data', channel_labels(:), ...
        'description', 'Channel name');
    
    % Required properties
    electrodes_table.description = 'Table of all recorded electrodes and their metadata';
    electrodes_table.colnames = { ...
        'x', ...
        'y', ...
        'z', ...
        'imp', ...
        'location', ...
        'filtering', ...
        'group', ...
        'group_name', ...
    };

    % Electrode group reference
    eg_ref = types.untyped.ObjectView('/general/extracellular_ephys/eg1');
    electrodes_table.group = types.hdmf_common.VectorData( ...
        'data', repmat(eg_ref, num_channels, 1), ...
        'description', 'Electrode group reference');
    
    % Assign electrode table to the NWB file
    nwb.general_extracellular_ephys_electrodes = electrodes_table;

    % Create electrode table region (all electrodes)
    elec_table_region = types.hdmf_common.DynamicTableRegion( ...
        'table', types.untyped.ObjectView('/general/extracellular_ephys/electrodes'), ...
        'description', 'all electrodes', ...
        'data', int64(0:num_channels-1)');
    
    % Update electrical series with electrode region
    ephys_ts.electrodes = elec_table_region;
    
    % Add to acquisition
    nwb.acquisition.set('ElectricalSeries1', ephys_ts);
    
    method = types.core.ProcessingModule( ...
    'description', 'Dummy generator info' ...
    );
    nwb.general_was_generated_by = { ...
        'MethodName'; 'Dummy description about how data was generated' ...
    };

    %% 
    % event_times = Data.Events./sampling_rate; % replace with your event times
    % event_labels = {'start', 'stimulus', 'stop'}; % optional, replace with your event labels
    % 



    % Export to NWB file
    nwbExport(nwb, SavePath, 'overwrite');

end