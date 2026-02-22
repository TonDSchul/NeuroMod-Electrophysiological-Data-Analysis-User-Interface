function [Data] = Manage_Dataset_Module_Apply_DataFlip(Data)

%________________________________________________________________________________________

%% This function just flips the channel by time data matrix

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Data = flip(Data, 1);