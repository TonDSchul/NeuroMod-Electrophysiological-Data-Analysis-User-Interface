function Use_Saved_FieldTrip_Compatible_Files_Example()

% Example sctipt how to load FieldTrip compatible .mat files saved in
% Neuromod and use with fieldtrip data and event data explorer GUI's

SavedFieldTripFilePath = 'C:\Users\tonyd\Desktop\FieldTripData.mat';

load(SavedFieldTripFilePath,'raw','eventdata')

% raw = strcu with fields for continuous data (example data):
% fsample: 30000
% trial: 1x1 cell with channel x time data (continuos)
% time: cell, empty
% sampleinfo: 1x2 double with start and stop sample of recording
% label: 1xnchannel cell array with a char as channel name for each channel
% cfg: empty

%  eventdata = strcu with fields for event data (example data): 
% fsample: 30000
% label: 1xnchannel cell array with a char as channel name for each channel
% trial: 1xnevents cell array with a channel x time matrix in each cell holding event
% related data for each event
% time: 1xnevents cell array with a 1 x time vector holding event related
% time (from negative prestim to positive poststim)
% trialinfo: nevents x 1 vector with active trials (1 for acitve, 0 otherwise)
% sampleinfo: nevents x 2 vector with start and stop sample for each
% trial in samples (in respect to continuous data). Difference between start and stop sample is length(time{1,1}) 

% Open FieldTrip's Raw Data Browser
ft_databrowser([], raw);        % browse continuous data

% Open FieldTrip's Event Data Browser

ft_databrowser([], eventdata);  % browse trial-segmented data
