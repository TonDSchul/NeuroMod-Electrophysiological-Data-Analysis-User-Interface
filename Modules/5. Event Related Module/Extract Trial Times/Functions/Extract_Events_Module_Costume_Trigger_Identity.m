function [Data] = Extract_Events_Module_Costume_Trigger_Identity(Data,CostumeChannelIdentityInfo)

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