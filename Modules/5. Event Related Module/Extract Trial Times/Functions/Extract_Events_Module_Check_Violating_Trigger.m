function [Data,Events,texttoshow] = Extract_Events_Module_Check_Violating_Trigger(Data,Events,TimeAroundEvent)

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
                            texttoshow = [texttoshow;strcat("Successfully deleted ",num2str(length(ExcludedTrials))," trials that violate time limits (or result in data too large for Matlab to handle) for even channel ",CurrentEventName,".")];
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

for j = 1:length(Events)
    if isempty(Events{j})
        Events(j) = [];
        Data.Info.EventChannelNames(j) = [];
    end
end

if ~isempty(Delete_Time_Violating_TriggerWindow)
    try
        delete(Delete_Time_Violating_TriggerWindow)
    end
end
