function [Events,texttoshow] = Extract_Events_Module_Check_Violating_Trigger(Data,Events,TimeAroundEvent)

WhatToDo = [];
texttoshow = [];
Delete_Time_Violating_TriggerWindow = [];

for nevents = 1:length(Events)
    CurrentEventName = Data.Info.EventChannelNames{nevents};
    
    [~,~,ExcludedTrials] = Event_Module_Extract_Event_Related_Data(Data,CurrentEventName,TimeAroundEvent,"Raw Data","Raw Event Related Data");
            
    if ~isempty(ExcludedTrials)
        if isempty(WhatToDo)
            Delete_Time_Violating_TriggerWindow = Delete_Time_Violating_Trigger();
            
            uiwait(Delete_Time_Violating_TriggerWindow.DeleteTimeViolatingTriggerUIFigure);
            
            if isvalid(Delete_Time_Violating_TriggerWindow)
                if ~isempty(Delete_Time_Violating_TriggerWindow.SelectedOption)
                    if strcmp(Delete_Time_Violating_TriggerWindow.SelectedOption,"Delete")
                        Events{nevents}(ExcludedTrials) = [];
                        disp("Successfully deleted trials that violate time limits.")
                        texttoshow = [texttoshow;strcat("Successfully deleted ",num2str(length(ExcludedTrials))," trials that violate time limits for even channel ",CurrentEventName,".")];
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
        else
            if strcmp(WhatToDo,"Delete")
                Events{nevents}(ExcludedTrials) = [];
                disp("Successfully deleted trials that violate time limits.")
                texttoshow = [texttoshow;strcat("Successfully deleted ",num2str(length(ExcludedTrials))," trials that violate time limits for event channel ",CurrentEventName,".")];
            end
        end
    end
end

if ~isempty(Delete_Time_Violating_TriggerWindow)
    try
        delete(Delete_Time_Violating_TriggerWindow)
    end
end
