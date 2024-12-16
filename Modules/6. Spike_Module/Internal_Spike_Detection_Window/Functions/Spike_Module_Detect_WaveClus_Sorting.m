function app = Spike_Module_Detect_WaveClus_Sorting(app,Path,Manual)
% Check if spike sorting was already saved
% Check if the folder exists
if Manual
    app.SpikeSortingPath = strcat(Path);
else
    app.SpikeSortingPath = strcat(Path,'\Wave_Clus');
end

cluster_class = [];

if isfield(app.Mainapp.Data,'Spikes') && strcmp(app.Mainapp.Data.Info.SpikeType,'Internal')
    SpikeText = strcat("Spike data already part of dataset with threshold ",num2str(app.Mainapp.Data.Info.SpikeDetectionNrStd),". If you want to load spike sorting data make sure the threshold is the same. Otherwise current spike dta is overwritten when loading sorting results.");
else
    SpikeText = strcat("No Existing Internal Spike Data was found");
end

if ~isfolder(app.SpikeSortingPath) % No sorting found
    textboxx = strcat("Path: ",app.SpikeSortingPath," does not contain spike sorting results folder or path is not available anymore. Eihter start a new sorting or load a different folder");
    app.TextArea_3.Value = textboxx;
    app.Label.Text = "Folder does not exist and times_spikes.mat not found!";
    app.Label.FontColor = [1.00,0.00,0.00];
else

    textboxx = strcat("Spike Sorting Data found in: ",app.SpikeSortingPath,". Select the 'Load Sorting Results' option and press 'RUN' to load spike sorting.");
    app.Label.Text = "Saved WaveClus_3 sorting in times_spikes.mat found!";
    app.Label.FontColor = [0.47,0.67,0.19];

    if isfile(strcat(strcat(app.SpikeSortingPath,'\times_spikes.mat')))
        load(strcat(strcat(app.SpikeSortingPath,'\times_spikes.mat')));
        SortingType = "AllChannel";
        textboxx = [textboxx;"";"Type: Sorted all channel together."];
    else
        if isfile(strcat(strcat(app.SpikeSortingPath,'\times_CH',num2str(1),'.mat')))
            load(strcat(strcat(app.SpikeSortingPath,'\times_CH',num2str(1),'.mat')));
            SortingType = "IndividualChannel";
            textboxx = [textboxx;"";"Type: Sorted channel individually."];
        else
            textboxx = strcat("Path: ",app.SpikeSortingPath," does not contain spike sorting results folder or path is not available anymore. Eihter start a new sorting or load a different folder");
            app.TextArea_3.Value = textboxx;
            app.Label.Text = "Folder does not exist and times_spikes.mat not found!";
            app.Label.FontColor = [1.00,0.00,0.00];
            return;
        end
    end

    if strcmp(SortingType,"AllChannel")
        numclu = length(unique(cluster_class(:,1)));

        textboxx = [textboxx;" ";strcat("Number of Cluster: ",num2str(numclu));""];
        
        % Initialize a string array to store the output
        outputText = "";
        
        % Get all field names from the structure
        fields = fieldnames(par);

        % Loop through each field and concatenate the field name and value
        for i = 1:numel(fields)
            fieldName = fields{i};
            fieldValue = par.(fieldName);
            
            % Convert the field value to a string if it is not already
            if isnumeric(fieldValue)
                fieldValue = num2str(fieldValue);
            elseif ischar(fieldValue)
                fieldValue = string(fieldValue);
            end
            
            % Concatenate the field name and value
            outputText = outputText + fieldName + ": " + fieldValue + newline;
        end
        
        % Set the TextArea_3 value in the app (assuming app.TextArea_3 is the name of the TextArea_3)
        textboxx = [textboxx;outputText];
        
        app.TextArea_3.Value = textboxx;
    else
        app.TextArea_3.Value = textboxx;
    end
end