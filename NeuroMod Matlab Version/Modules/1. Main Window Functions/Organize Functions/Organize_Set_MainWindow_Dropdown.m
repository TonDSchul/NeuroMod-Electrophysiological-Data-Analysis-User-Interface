function [app] = Organize_Set_MainWindow_Dropdown(app,Data)

%________________________________________________________________________________________

%% Function to reset the dropwdonw menu of the main app window enabling to select events or spikes and raw/preprocessed data as well as event channel names

% This function gets called whenever dataset components are changed 

% Input:
% 1. app: Main window app object
% 2. Data: Main object data stuccture with all relevant data components

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Plot Selection
% Plot Addons
PreviousAddonSelection = app.DropDown_2.Value;
app.DropDown_2.Items = {};

events = 0;
spikes = 0;

if isfield(Data,'Events')
    events = 1;
else
    app.PlotEvents = "Non";
end

if isfield(Data,'Spikes')
    spikes = 1;
else
    app.Plotspikes = "No";
end

app.DropDown_2.Items{1} = 'Non';

if events == 1 
    app.DropDown_2.Items{2} = 'Events';
end

if spikes == 1 && events == 1 
    app.DropDown_2.Items{3} = 'Spikes';
elseif spikes == 1 && events == 0 
    app.DropDown_2.Items{2} = 'Spikes';
end

for i = 1:length(app.DropDown_2.Items)
    if strcmp(app.DropDown_2.Items{i},PreviousAddonSelection)
        app.DropDown_2.Value = app.DropDown_2.Items{i};
    end
end

% Main plot data
PreviousMainPlotSelection = app.DropDown.Value;
app.DropDown.Items = {};
app.DropDown.Items{1} = 'Raw Data';
if isfield(Data,'Preprocessed')
    app.DropDown.Items{2} = 'Preprocessed Data';
end

for i = 1:length(app.DropDown.Items)
    if strcmp(app.DropDown.Items{i},PreviousMainPlotSelection)
        app.DropDown.Value = app.DropDown.Items{i};
    end
end

%% Event Channel Selection
PreviousEventSelection = app.EventChannelDropDown.Value;
app.EventChannelDropDown.Items = {};
if isfield(Data,'Events')
    app.EventChannelDropDown.Enable = "on";
    app.CurrentEventChannel = 1;
    for i = 1:length(Data.Info.EventChannelNames)
        app.EventChannelDropDown.Items{i} = convertStringsToChars(Data.Info.EventChannelNames{i});
    end
else
    EventText_handles = findobj(app.UIAxes, 'Tag','EventLabel');
    if ~isempty(EventText_handles)
        delete(EventText_handles(:));
    end
    app.EventChannelDropDown.Enable = "off";
end

for i = 1:length(app.EventChannelDropDown.Items)
    if strcmp(app.EventChannelDropDown.Items{i},PreviousEventSelection)
        app.EventChannelDropDown.Value = app.EventChannelDropDown.Items{i};
    end
end

%% Event trial number text area in main windwo

if isfield(Data,'Events')
    EventIndice = [];
    for i = 1:length(Data.Info.EventChannelNames)
        if strcmp(Data.Info.EventChannelNames{i},app.EventChannelDropDown.Value)
            EventIndice = i;
        end
    end
    app.EventTriggerNumberField.Value = strcat(num2str(length(Data.Events{EventIndice}))," event trigger.");
else
   app.EventTriggerNumberField.Value = "No event trigger found."; 
end

% Delete event trigger number text
if ~strcmp(app.PlotEvents,"Events")
    EventText_handles = findobj(app.UIAxes, 'Tag','EventLabel');
    if ~isempty(EventText_handles)
        delete(EventText_handles(:));
    end
end