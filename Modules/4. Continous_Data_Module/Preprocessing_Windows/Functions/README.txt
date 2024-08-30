This folder contains the following functions with respective Header:

 ###################################################### 

File: Preprocess_Module_Apply_Pipeline.m
%________________________________________________________________________________________

%% Function to Preprocess Raw Data 
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
% 3. PreprocessingSteps: tring array that get filled with the name of the preprocesing step added and displayed in the textbox of the
% preprocessing window. When Pipiline is executed it loops over those names and based on the name applies the corresponding preprocessing function. 
% 4: PlotExample: true or false, if true all of the stuff here is temporary
% to plot an example of what the preprocessing would look like.
% 5. FilterMethod: char with name of filter when filtering selected. Either "Low-Pass" OR "High-Pass" OR "Band-Stop" OR "Median Filter" OR "Narrowband"
% 6. FilterType: char input Options: "Butterworth IR" OR "FIR-1" OR "Firls" 
% 7. CuttoffFrequency: number as char char, Cut off frequency for filters. Only requied when filter selected in PreproMethod field, Input as char in Hz
% 8. FilterDirection: char. Options: "Zero-phase forward and reverse" OR "Forward" OR "Reverse" OR "Zero-phase reverse and forward"
% 9. FilterOrder: number as char specifying the filter order for applied filter. Input as char. This only is required when a filter is selected as the methods field.
% 10. DownsampleFactor: number as char, New downsampled sampling rate in Hz; input as char. This only is required when a filter is selected as the methods field.
% 11. SampleRate: Sampling Rate in Hz as double

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
% 5: current iteration of preprocessing steps execute, as double (index of PreprocessingSteps currently executed)

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

