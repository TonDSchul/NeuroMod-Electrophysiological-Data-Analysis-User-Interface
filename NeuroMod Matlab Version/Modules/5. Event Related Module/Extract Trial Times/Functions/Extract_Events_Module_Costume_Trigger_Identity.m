function [Data,Error] = Extract_Events_Module_Costume_Trigger_Identity(Data,CostumeChannelIdentityInfo)

%________________________________________________________________________________________

%% Function that takes an event channel and splits it into multiple differen event channels

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% CostumeChannelIdentityInfo: struc with fields:  
% AllIdentities: vector with numbers from laoded txt or csv file designating
% individual event channel for each indice
%and UniqueIdentities: cell array with string holding event channel name
%defined in loaded txt or csv file

% Output
% 1. Data: Main window data strucure with changed Data.Events and
% Data.Info fields
% 2. Error: double, 1 or 0 whether an error occured

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


Error = 0;
if length(CostumeChannelIdentityInfo.AllIdentities) ~= size(Data.Events{1},2)
    msgbox(strcat("Error: selected file with trigger identities contains ",num2str(length(CostumeChannelIdentityInfo.AllIdentities))," trigger while current channel only contains ",num2str(size(Data.Events{1},2))," trigger! Returning without applying custom channel identity."))
    Error = 1;
    return
end

disp("Splitting single event channel into different triggering identities!")

if isfield(Data.Info,'EventChannelNames')
    fieldsToDelete = {'EventChannelNames'};
    % Delete fields
    Data.Info = rmfield(Data.Info, fieldsToDelete);
end

CostumeChannelIdentityInfo.UniqueIdentities;
CostumeChannelIdentityInfo.AllIdentities;

%% Event names
Data.Info.EventChannelNames = {};
for i = 1:length(CostumeChannelIdentityInfo.UniqueIdentities)
    Data.Info.EventChannelNames{i} = convertStringsToChars(CostumeChannelIdentityInfo.UniqueIdentities(i));
end

TempEvents = Data.Events{1};
Data.Events = [];

%% Event Identities

for nUniques = 1:length(CostumeChannelIdentityInfo.UniqueIdentities)
    IdentIndice = CostumeChannelIdentityInfo.AllIdentities == CostumeChannelIdentityInfo.UniqueIdentities(nUniques);
    Data.Events{nUniques} = TempEvents(IdentIndice);
end