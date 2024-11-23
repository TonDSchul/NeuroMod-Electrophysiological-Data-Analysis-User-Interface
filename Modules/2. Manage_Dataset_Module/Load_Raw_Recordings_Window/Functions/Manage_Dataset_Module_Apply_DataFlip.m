function [Data] = Manage_Dataset_Module_Apply_DataFlip(Data)

% Data = nchannel x ntime matrix containing the data to flip

Data = flip(Data, 1);