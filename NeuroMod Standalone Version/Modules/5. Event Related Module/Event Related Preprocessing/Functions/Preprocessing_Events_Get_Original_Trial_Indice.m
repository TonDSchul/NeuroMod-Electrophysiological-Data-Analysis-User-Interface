function OriginalTrialNumbers = Preprocessing_Events_Get_Original_Trial_Indice(CurrentIndices, DeletedTrials)

%________________________________________________________________________________________
%% Function to convert current trigger/trial selection to true trigger indices.

% This function is only called when the user rejects trials from one event
% channel two times. Example: This is because after the first trial rejection, range
% is not 1-50 anymore but 1-40 with trials 1:10 deleted. So if rejection window opens again, user
% can reject trials 1 to 40. If he again selects to delete trials 1 to 10,
% it is truly trial 20-30 in repsect to the whole event related dataset he
% wants to delete!

% called in Preprocessing_Events_Add_Preprocessing_Info.m

% Inputs: 
% 1. CurrentIndices: Trials currently selected to delete
% 2. DeletedTrials: Already deleted trials (Data.Info.EventRelatedPreprocessing.TrialRejectionTrials)

% Outputs:
% 1. OriginalTrialNumbers: true trial indices to delete

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% Total number of original trials
totalOriginal = max([DeletedTrials(:); CurrentIndices(:)]);  

% Generate mapping of original -> current (remove deleted)
allOriginal = 1:totalOriginal;
remainingOriginal = setdiff(allOriginal, DeletedTrials, 'stable');

% Map current indices to original
OriginalTrialNumbers = remainingOriginal(CurrentIndices);
