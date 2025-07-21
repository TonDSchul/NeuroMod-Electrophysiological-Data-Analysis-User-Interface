function [event] = Extract_Events_Module_Extract_Events_Neuralynx(Filename,Path)

%________________________________________________________________________________________
%% Function to extract event Data from Neuralynx recordings

% This function gets caled when neurylynx events are supposed to be
% extracted. It calls the fieldtrip ft_read_event and ft_read_header
% functions for event data extraction

% Inputs: 
% 1.Filename: char, Name of the event file (.nve)
% 2.Path: char, direcory containing the event data

% Outputs:
% 1. event: 1x1 dataframe with sample times, time points, event types, event
% trigger information and so on. 


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

[event] = ft_read_event(Filename);

hdr = ft_read_header(Path);

for i=1:length(event)
  % the first sample in the datafile is 1
  event(i).sample = (event(i).timestamp-double(hdr.FirstTimeStamp))./hdr.TimeStampPerSample + 1;
end