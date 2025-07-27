function OriginalTrialNumbers = Preprocessing_Events_Get_Original_Trial_Indice(CurrentIndices, DeletedTrials)
% mapCurrentToOriginalTrials - Converts current trial indices (after deletion)
% back to their corresponding original trial numbers.
%
% Inputs:
%   CurrentIndices - indices in the current (post-deletion) trial list (1:N)
%   DeletedTrials  - original trial indices that were previously deleted (1:200)
%
% Output:
%   OriginalTrialNumbers - the corresponding original trial numbers

% Total number of original trials
totalOriginal = max([DeletedTrials(:); CurrentIndices(:)]);  % usually 200

% Generate mapping of original -> current (remove deleted)
allOriginal = 1:totalOriginal;
remainingOriginal = setdiff(allOriginal, DeletedTrials, 'stable');

% Map current indices to original
OriginalTrialNumbers = remainingOriginal(CurrentIndices);
