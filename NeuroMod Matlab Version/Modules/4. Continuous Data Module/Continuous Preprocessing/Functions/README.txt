This folder contains the following functions with respective Header:

 ###################################################### 

File: Preprocess_ApplyStimArtefactRejection.m
%________________________________________________________________________________________

%% Function apply stimulation artefact rejection (interpolation) to the dataset
% This function is called in the Preprocess_Module_Apply_Pipeline.m
% function when the user added artefact rejection to the preprocessing
% pipeline and executes the pipeline. It interpolates all data points
% around event indicie of a selected input event channel holding time
% points of the stimulation

% Input:
% 1. Data: Either Data.Raw or Data.Preprocessed data, depending on whether its the
% fist preprocessing step or not. If yes, pass raw data, otherwise
% preprocessed data
% 2. Info: Data.Info structure of main dataset
% 3. Events: Data.Events field of main dataset; 1 x number events cell array with each cell containing the
% indicies of extracted events. 
% 4. PreproInfo: strcuture holding the infos about added preprocessing
% steps (paramater to apply), comes from
% Preprocess_Module_Construct_Pipeline.m when adding a step to the pipeline
% 5.SampleRate: double, sample rate after signal was potentially
% downsampled
% 6. Downsampled: 1 or 0, 1 if downsampled, 0 otherwise

% Output: 
% 1. Data: Either corrected Data.Raw or correctr Data.Preprocessed data from the main dataset, depending on whether its the first preprocessing step . 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_DeleteLastPipeline_Entry.m
%________________________________________________________________________________________

%% Function to delete the last preprocessing pipeline step added

%Input/Output:
% app: preprocessing app window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_Extract_and_Plot_Stimulation_Artefact.m
%________________________________________________________________________________________

%% Function to plot artefact time range around the event selected for the Stimulation Artefact Rejection window
% This function is called in the Stimulation Artefact Rejection window
% started when the Stimulation Artefact Rejection button is pressed in the
% preprocessing window. It takes the eventchannel selected in the window,
% extracts data around events saved for this channel and plots them.

% Input:
% 1. Data: main window data structure
% 2. TimeAroundEventsEditField: char, time around events to extract data from. Two numbers split by a comma, i.e. -0.005,0005
% 3. EventChannelforStimulationDropDown: Name of the event channel from
% which event indicies are taken. Identical to names in Data.Info.EventChannelNames
% 4. EventstoPlotDropDown: char, which event ttl's to plot from the selected
% event channel. Either 'Mean over all Trials' OR the number of the
% event,i.e. '1' for the first ttl
% 5. SpacingSlider: double, spacing between channel for plotting
% 6. Figure: figure object handle to plot data (in seconds)
% 7. ActiveChannel: double vector with all active channel in the probe view
% window

% Output: 
% 1. ArtefactRelatedData: nchannel x ntime x nevents matrix containg the data that is plotted. 
% 2. StimArtefactInfo: strcuture holding info necessray to apply artefact
% rejection to the dataset when the user adds it to the preprocessing
% pipeline. Fields are: StimArtefactInfo.SelectedEventChannelName (char)
% and SamplesToPlot (1 x 2 double in )

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_Get_Statistics_for_Spikes.m
%________________________________________________________________________________________

%% Function to get global std over all channel after high pass filtering for axon viewer threshold

% Input:
% 1. Data: Data structure containing raw and potentially preprocessed data as a Channel x Time matrix
% and Info structure with already applied preprocessing steps and other infos

% Output: 
% 1. Data with Data.Info.HighPassStatistics being added

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_Module_Apply_Pipeline.m
%________________________________________________________________________________________

%% Function to Preprocess Data 
% This function uses the fieldtrip tool box for the preprocessing steps
% involving filtering data (lowpass,highpass,bandstop,narrowband and median filter)
% Fieldtrip offical website: https://www.fieldtriptoolbox.org/
% Fieldtrip Github project: https://github.com/fieldtrip/fieldtrip
% Functions used from fieldtrip: 
%ft_preproc_lowpassfilter
%ft_preproc_highpassfilter
%ft_preproc_bandpassfilter
%ft_preproc_bandstopfilter
%ft_preproc_medianfilter -- functions were not modified

% Input:
% 1. Data: Data structure containing raw data as a Channel x Time matrix
% and Info structure with already applied preprocessing steps and other infos
% 2. Sampling Rate: as double in Hz. Not taken from Data.Info to preserve
%original sampling rate temporarily 
% 3. PreprocessingSteps: string array with names of preprocessing steps
% captured in the gui. The are computed in the order specified in the
% array. Options: % Preprocessing ethod to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 4. PlotExample: 1 or 0 as double to specify whether preprocessing step is
%executed on whole dataset or just on a subsection (50000 samples)´to plot
%an example of what the preprocessing does. 1 for example plot
%5. PreProInfo: Structure containing parameters for each preprocessing
%step. This is populated in the 'Preprocess_Module_Construct_Pipeline'
%function
% 6. ChannelDeletion: double array of channels to be deleted, only required
%if Channeldeletion selected as preprocessing step
% 7. TextObject: App object of text are in the preprocessing window to show
% information about progress and settings. Can be defined as an empty
% variable if run outside of GUI

% Output: 
% 1. Data with added field Data.Preprocessed containing the
% preprocessed data as well addition of preprocessing settings to Data.Info
% to preserver info what has been done to data.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_Module_ChannelDeletion.m
%________________________________________________________________________________________

%% Function to apply channel deletion to GUI data

% Input:
% 1. Data: Data structure containing raw and potentially preprocessed data as a Channel x Time matrix
% and Info structure with already applied preprocessing steps and other infos
% 2. ChannelDeletion: double array with channel to be deleted.

% Output: 
% 1. Data with modified fields. Channel get deleted for Raw and
% Preprocessed Data, Event Related Data and Spike Data from internal spike detection (thresholding). Spike Data from Kilosort is just deleted and
% has to be extracted again. Potential TO DO but a lot of work and the
% kilosort .dat file used for analysis is not based on the same channel anymore, so loading
% kilosort data has to be modified too. 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_Module_Construct_Pipeline.m
%________________________________________________________________________________________

%% Function that adds a preprocessing option to the pipeline. 
% When the user clicks on the 'Add to Pipeline' Button, this function is
% called to save the selected settings for later, when the
% 'Preprocess_Module_Apply_Pipeline' performs the actual preprocessing

% Input:
% 1. type: char name of preprocessing step applied. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 2. Info: Structure of preprocessing app that gets filled based on the other inputs to this function to save infos for later preprocessing. % NOTE: % Paremeters Saved in app.Info variable (NOT THE MAINAPP Original DATA)!! Only applied to the
% mainapp data after preprocessing pipeline finsihed. Has to be already saved here bc multiple filter can be applied. 
% 3. PreprocessingSteps: string array with the name of the preprocesing steps added and displayed in the textbox of the
% preprocessing window. When Pipeline is executed it loops over those names and based on the name applies the corresponding preprocessing function. 
% 4: PlotExample: true or false, if true everything is temporary
% to plot an example of what the preprocessing would look like.
% 5. FilterMethod: char with name of filter when filtering selected. Either "Low-Pass" OR "High-Pass" OR "Band-Stop" OR "Median Filter" OR "Narrowband"
% 6. FilterType: char input Options: "Butterworth IR" OR "FIR-1" OR "Firls" 
% 7. CuttoffFrequency: number as char char, Cut off frequency for filters. Only requied when filter selected in PreproMethod field, Input as char in Hz
% 8. FilterDirection: char. Options: "Zero-phase forward and reverse" OR "Forward" OR "Reverse" OR "Zero-phase reverse and forward"
% 9. FilterOrder: number as char specifying the filter order for applied filter. Input as char. This only is required when a filter is selected as the methods field.
% 10. DownsampleFactor: number as char, New downsampled sampling rate in Hz; input as char. This only is required when a filter is selected as the methods field.
% 11. SampleRate: Sampling Rate in Hz as double
% 12. ArtefactRejectionInfo: structure holding info about stimulation
% artefact rejection. Required fields: TimeAroundEvents: 1x2 double with
% time around event to reject in samples (both numbers positive, i.e.
% 150,150) and SelectedEventChannelName: Name of the event channel to
% take the artefact indicie from. Comes from Data.Info.EventChannelNames
% IMPORTANT: empty when no artefact rejection

% Output: 
% 1. Info (app.Info, not part of the original main window dataset!). Holds
% all infos passed to this function to be read by the
% 'Preprocess_Module_Apply_Pipeline' to know what to do

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_Module_Delete_Old_Settings.m
%________________________________________________________________________________________

%% function that deletes all fields of the structure app.Data.Info that correspond to preprocessing that was already applied.

% If user executes new preprocessing, old Data.Preprocessing structure
% gets overwritten. All variables and fields of the Data.Info field that
% correspond to the old preprocessing have to be deleted accordingly

% Input:
% 1. Data: Data structure holding Raw, Preprocessed data and Info structure
% 2. Info: Info structure from preprocessing GUI, NOT the info from the
% variable above!! It holds all infos about the currently selected
% preprocessing steps
% 3. PreprocessingSteps: string array with names of preprocessing steps
% captured in the gui. The are computed in the order specified in the
% array. Options: % Preprocessing ethod to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 4. ChannelDeletion: double array of channels to be deleted
% 5. TextArea: app object of textarea to show info. Can be empty variable
% when execute outside of GUI

% Outputs:
% 1. Data: Data structure holding Raw, Preprocessed data and Info structure
% 2. Info: currently added prepro infos of all components part of the
% pipeline
% 3. TextArea: content of textarea field in prepro window in case warning
% has to be displayed (line 61) 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_Module_Inspect_Filter.m
%________________________________________________________________________________________

%% Function to inspect filter kernel properties in the preprocessing window
% This function is called in the preprocessing window when the user presses
% the Inspect Filter button. It gets called in the
% Preprocess_Module_Apply_Pipeline.m function

% Input:
% 1. Data: data structure from main window dataset
% 2. PreProInfo: structure holding parameter for preprocessing steps
% applied to pipeline, comes from Preprocess_Module_Construct_Pipeline.m
% 3. PreprocessingSteps: string array holding steps added to the pipeline,
% comes from Preprocess_Module_Inspect_Filter
% 4. PPSteps: Current preprocessing step executed (comes from Preprocess_Module_Apply_Pipeline)
% 5. SampleRate: double in Hz
% 6. A: First coefficient from selected filter, double, comes from the fieldtrip
% filtering functions
% 7. B: Second coefficient from selected filter, double, comes from the fieldtrip
% filtering funcitons
% 8. Cutoff: double, cutoff frequency for filter in Hz
% 9. filterorder: double, selected filter order for filter
% 10. NonNan: Indicies where data is not nan (neurlynx can have nan in dataset)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocess_Module_Set_Filter_Parameter.m
%________________________________________________________________________________________

%% Function to Set Parameters for Filter functions based on saved filter parameter in app.Info structure
% Filtering is done with fieldtrip functions. The inputs to those functions
% specifying for example the filtertype are not user friendly. Therefore,
% the names in the GUI are different from those fieldtrip needs and are
% therefore translated in this function to be compatible with fieldtrip.

% Input:
% 1. PPSteps: Current iteration of preprocessing steps conducted (double)
% 2. PreprocessingSteps: string array with names of preprocessing steps
% captured in the gui. The are computed in the order specified in the
% array. Options: % Preprocessing ethod to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 3. Info: Structure containing parameters for each preprocessing
% step. This is populated in the 'Preprocess_Module_Construct_Pipeline'
% function.

% Outputs
% For type,dir,filterorder,wintype look below in the code how the GUI
% inputs are translated into different chars
% df always stays emtpy
% Cutoff: double 1x1 or 1x2 array with cutoff frequencies. For Narrowband
% a lower and upper cutoff has to be specified. Then it is 1x2, otherwise
% 1x1
% DownsampleFactor: Just taken from Info structure. Only non-emtpy when
% downsampling is the current preprocessing step

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocessing_Check_Band_Stop_Conditions.m
%________________________________________________________________________________________

%% Function to check whether data was low pass filtered and downsampled before applying band stop.
% If not, a window opens asking the user if he wants to add these steps
%  automatically

%Input:
% app: preprocessing app window object

% Outputs:
% 1. Proceed: 1 or 0, 1 if user proceeded with selection and asomething is
% added to the pipeline
% 2. ExtraPrepro: 1 or 0, 1 if extra preprocessing steps have to be added
% 3. NewSampleFrequency: Not used currently! 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocessing_Check_NarrowBand_Conditions.m
%________________________________________________________________________________________

%% Function to check whether data was low pass filtered and downsampled before applying narrowband filter.
% If not, a window opens asking the user if he wants to add these steps
%  automatically before the narrowband filter

%Input:
% app: preprocessing app window object

% Outputs:
% 1. Proceed: 1 or 0, 1 if user proceeded with selection and asomething is
% added to the pipeline
% 2. ExtraPrepro: 1 or 0, 1 if extra preprocessing steps have to be added
% 3. NewSampleFrequency: Not used currently! 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Preprocessing_Module_Cut_Time.m
%________________________________________________________________________________________

%% Function to delete specific time spans of the recording. 
% Time span can either be from 0 to a specified amount of seconds (CutStart)
% or a specified time point till the end of the recording (CutEnd)

% Input:
% 1. Data: Data structure
% 2. CutType: Either 'CutStart' or 'CutEnd' as char to specify if first or
% last seconds of the recording are deleted
% 3. CutTime: Time in seconds as double specifying the duration of data to
% delete. (if 20 seconds and CutEnd: The last 20 seconds of the recording are deleted)
% 4: PreprocessingSteps: string array with names of preprocessing steps
% captured in the gui. The are computed in the order specified in the
% array. Options: % Preprocessing ethod to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 5: PPSteps: current iteration of preprocessing steps execute, as double (index of PreprocessingSteps currently executed)

% NOTE: If Kilosort spike data extracted: Spike data gets deleted. It could
% be modified accordingly, but would then differ in time from the file
% kilosort analysed and the kilosort ouput data is based on. Therefore I
% want to force the user to save for kilosort again, analyse again and have
% a matching set of datasets in the gui and kilosort.
% Internal spikes are modified accordingly, all spike indicies in deleted
% time range get deleted too.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

