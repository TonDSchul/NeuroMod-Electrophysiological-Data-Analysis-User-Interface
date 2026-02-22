function Data = Extract_Events_Module_Add_EventRelatedInfo(Data,TimeWindowBefore,TimeWindowAfter)

%________________________________________________________________________________________
%% Function to add Data.Info fields about event related data

% This is the only information saved permanently when extracting events about event
% related data

% Inputs: 
% 1. Data: Data structure with raw data, preprocessed data, event data and
% the infio structure with infos about extracted events.
% 2. TimeWindowBefore: char, pre stimulus time range specified by user
% 3. TimeWindowAfter: char, post stimulus time range specified by user

% Outputs:
% 1. Data: Data object passed here with added field:
% EventRelatedDataTimeRange and EventRelatedActiveChannel
% and adeed infos to Data.Info

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


Data.Info.EventRelatedDataTimeRange = convertStringsToChars(strcat(TimeWindowBefore," ",TimeWindowAfter)) ;
Data.Info.EventRelatedActiveChannel = Data.Info.ProbeInfo.ActiveChannel;