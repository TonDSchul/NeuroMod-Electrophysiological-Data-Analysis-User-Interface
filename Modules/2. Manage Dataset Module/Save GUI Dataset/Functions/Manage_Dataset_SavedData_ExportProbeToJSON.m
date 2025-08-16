function Probe = Manage_Dataset_SavedData_ExportProbeToJSON(Data)

Probe = [];

%% ------------------------- Set Basic Parameter -------------------------
NrChannels = str2double(Data.Info.ProbeInfo.NrChannel);
Radius = 10;

tempactivechannel = strjoin(string(Data.Info.ProbeInfo.ActiveChannel), ',');
activechannel{1} = convertStringsToChars(tempactivechannel);
[xcoords,ycoords,~] = Manage_Dataset_Save_ProbeInfo_Kilosort("",Data.Info.ProbeInfo.NrRows,Data.Info.ProbeInfo.NrChannel,num2str(Data.Info.ChannelSpacing),activechannel,Data.Info.ProbeInfo.OffSetRows,str2double(Data.Info.ProbeInfo.OffSetRowsDistance),str2double(Data.Info.ProbeInfo.VertOffset),str2double(Data.Info.ProbeInfo.HorOffset),0);
      
contact_positions = [xcoords, ycoords];

device_channel_indices = 0:NrChannels-1;
contact_ids = 0:NrChannels-1;

%% ------------------------- Build probe struct -------------------------

probe_struct.ndim = 2;
probe_struct.si_units = 'um';
probe_struct.contact_positions = contact_positions;
probe_struct.contact_shapes = 'circle';
probe_struct.contact_shape_params.radius = Radius;
probe_struct.device_channel_indices = device_channel_indices;
probe_struct.contact_ids = contact_ids;

% Suppose your probe struct is called 'probe_struct'
num_contacts = length(probe_struct.contact_positions);

% Create the contact_plane_axes array
plane_axes = repmat({[1 0; 0 1]}, 1, num_contacts);

% Add to the struct
probe_struct.contact_plane_axes = plane_axes;

probe_struct.probe_name = 'custom_probe';
probe_struct.annotations = struct();

%% ------------------------- Save as cell in output struc -------------------------
Probe.probes = {probe_struct};

