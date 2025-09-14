function [Data] = Manage_Dataset_Module_Apply_DataFlip(Data)

%________________________________________________________________________________________

%% This function just flips the dataset

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


% Data = nchannel x ntime matrix containing the data to flip

Data = flip(Data, 1);