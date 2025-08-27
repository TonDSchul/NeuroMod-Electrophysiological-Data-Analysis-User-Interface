function [Data,Error] = Extract_Events_Module_Costume_Trigger_Identity(Data,CostumeChannelIdentityInfo)

Error = 0;
if length(CostumeChannelIdentityInfo.AllIdentities) ~= size(Data.Events{1},2)
    msgbox(strcat("Error: selected file with trigger identities contains ",num2str(length(CostumeChannelIdentityInfo.AllIdentities))," trigger while current channel only contains ",num2str(size(Data.Events{1},2))," trigger! Returning without applying costum channel identity."))
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