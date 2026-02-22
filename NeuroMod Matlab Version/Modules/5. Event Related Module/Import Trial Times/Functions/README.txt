This folder contains the following functions with respective Header:

 ###################################################### 

File: Import_Events_Add_Imported_Events.m
%________________________________________________________________________________________
%% Function to add imported events to the main window data structure

% Inputs:
% 1. Data: main window data structure
% 2. EventInfo: struc holding event info laoded from selected file with
% fields TempEvents as cell array with time stamps for each event channel
% pretty much the finsihed Data.Events already, just has to be 'cleaned' by checking time violations etc.

% Outputs:
% 1. Data: main window data structure with Data.Events and corresponding
% Data.Info fields
% 2. EventChannelDropDown: cell array with each cell containing a char with
% an event channel name

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Import_Events_Read_File.m
%________________________________________________________________________________________
%% Function to read a file holding event time stamps to import

% Inputs:
% 1. EventInfo: output struc of this function in case user clicks to load
% another file but cancels selection --> dont want to erase everything
% loaded before if it was an accident

% Outputs:
% 1 .EventInfo: struc holding event info loaded from selected file with
% fields TempEvents as cell array with time stamps for each event channel
% pretty much the finsihed Data.Events already, just has to be 'cleaned' by
% checking time violations etc. 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

