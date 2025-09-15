function [Data,Events,texttoshow] = Extract_Events_Module_Check_Violating_Trigger(Data,Events,TimeAroundEvent)

%________________________________________________________________________________________

%% Function to check whether event sample time points acquired violate time limits when extracting trial data (event related data)
% i.e trigger at 0.2 seconds before recording ends with a trila time of 0.5
% seconds after the trigger

% user is asked whether to delete those indices. This makes everything
% cleaner for sure, but everything still works without it!

% executed as last function in the extracting event data from a recording
% pipeline of the extract trigger times windwo

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% Events: cell array, each cell containing a a x 1 event sample vector
% TimeAroundEvent: 1 x 2 vector with time before (1) and after (2) each
% event trigger in seconds - both positive!

% Output
% 1. Data: Main window data strucure with all relevant dataset compontntes
% 2. Events: cell array, each cell containing a a x 1 event sample vector -
% cleaned or uncleaned depending on user selction
% 3. texttoshow: char, text to show when trigger where deleted in extract
% trial times window.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

WhatToDo = [];
texttoshow = [];
Delete_Time_Violating_TriggerWindow = [];


EventsToDeleteCompletly = [];

for nevents = 1:length(Events)
    TooLarge = [];
    ExcludedTrials = [];

    CurrentEventName = Data.Info.EventChannelNames{nevents};
    
    [~,~,ExcludedTrials,TooLarge] = Event_Module_Extract_Event_Related_Data(Data,CurrentEventName,TimeAroundEvent,"Raw Data","Raw Event Related Data");
            
    if ~isempty(ExcludedTrials)
        
        if isempty(WhatToDo)

            if isempty(TooLarge.Event) %% if event related data would be too big (too many trigger), just delete, dont ask -- here: Not too big
                Delete_Time_Violating_TriggerWindow = Delete_Time_Violating_Trigger();
                
                uiwait(Delete_Time_Violating_TriggerWindow.DeleteTimeViolatingTriggerUIFigure);
                
                if isvalid(Delete_Time_Violating_TriggerWindow)
                    if ~isempty(Delete_Time_Violating_TriggerWindow.SelectedOption)
                        if strcmp(Delete_Time_Violating_TriggerWindow.SelectedOption,"Delete")
                            Events{nevents}(ExcludedTrials) = [];                     
                            disp("Successfully deleted trials that violate time limits (or result in data too large for Matlab to handle).")
                            texttoshow = [texttoshow;strcat("Successfully deleted ",num2str(length(ExcludedTrials))," trials that violate time limits (or result in data too large for Matlab to handle) for event channel ",CurrentEventName,".")];
                            WhatToDo = "Delete";
                        else
                            disp("Keeping all trials.")
                            texttoshow = ("Keeping trigger whos trials violate time limits.");
                            try
                                delete(Delete_Time_Violating_TriggerWindow)
                            end
                            return;
                        end
                    end
                    
                end
            else %% if event related data would be too big (too many trigger), just delete, dont ask -- here: Too big
                Events{nevents}(ExcludedTrials) = [];
                disp("Successfully deleted trials that violate time limits (or result in data too large for Matlab to handle).")
                texttoshow = [texttoshow;strcat("Successfully deleted ",num2str(length(ExcludedTrials))," trials that violate time limits (or result in data too large for Matlab to handle) for even channel ",CurrentEventName,".")];
                WhatToDo = "Delete";
            end
        else
            if strcmp(WhatToDo,"Delete")
                Events{nevents}(ExcludedTrials) = [];
                disp("Successfully deleted trials that violate time limits.")
                texttoshow = [texttoshow;strcat("Successfully deleted ",num2str(length(ExcludedTrials))," trials that violate time limits for event channel ",CurrentEventName,".")];
            end
        end
    end
end

IndiceToDelete = [];
for j = 1:length(Events)
    if isempty(Events{j})
        IndiceToDelete = [IndiceToDelete,j];
    end
end

if ~isempty(IndiceToDelete)
    Events(IndiceToDelete) = [];
    Data.Info.EventChannelNames(IndiceToDelete) = [];
end

if ~isempty(Delete_Time_Violating_TriggerWindow)
    try
        delete(Delete_Time_Violating_TriggerWindow)
    end
end
