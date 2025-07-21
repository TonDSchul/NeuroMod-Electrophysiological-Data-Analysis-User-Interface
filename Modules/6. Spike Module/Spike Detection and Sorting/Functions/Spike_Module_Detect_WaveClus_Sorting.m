function app = Spike_Module_Detect_WaveClus_Sorting(app,Path,Manual)

%________________________________________________________________________________________
%% Function to check waveclus sorting results are found within the Path specified

% Inputs:
% 1. app: Spike detection and sorting window object
% 2. Path: string ,Path to check for waveclus cluster results
% 3. Manual: double or logical, either 1 or 0, whether waveclus results
% folder was specified manually or not in the GUI; 1 will add '\Wave_Clus'
% to the end of the path

% Outputs
% 1. app: Spike detection and sorting window object 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% Check if spike sorting was already saved
% Check if the folder exists
if Manual
    app.SpikeSortingPath = strcat(Path);
else
    app.SpikeSortingPath = strcat(Path,'\Wave_Clus');
end

cluster_class = [];

SpikePresent = 0;
if isfield(app.Mainapp.Data,'Spikes') && strcmp(app.Mainapp.Data.Info.SpikeType,'Internal')
    SpikeText = strcat("Spike data already part of dataset with threshold ",num2str(app.Mainapp.Data.Info.SpikeDetectionNrStd),". If you want to load spike sorting data make sure the threshold is the same. Otherwise current spike data is overwritten when loading sorting results.");
    SpikePresent = 1;
else
    SpikeText = strcat("No Existing Internal Spike Data was found");
end

if SpikePresent == 0 % No sorting found
    textboxx = strcat("Spike data not found. Please first use the 'Spike Detection and Sorting' window to detect spikes using thresholding!");
    app.TextArea_3.Value = textboxx;
    app.Label.Text = "No internally extracted spike data found!";
    app.Label.FontColor = [1.00,0.00,0.00];
else

    textboxx = strcat("Spike data found as part of the dataset.");
    app.Label.Text = "Spike data found";
    app.Label.FontColor = [0.47,0.67,0.19];
end

app.TextArea_3.Value = textboxx;

