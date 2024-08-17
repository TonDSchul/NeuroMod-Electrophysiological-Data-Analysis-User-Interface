function [ChannelSelection,TimeWindow,TrialSelection,EventTime] = Preprocessing_Events_Check_Inputs_Artefact_Rejection(Data,ChannelSelection,TimeWindow,TrialSelection,EventTime)

%________________________________________________________________________________________
%% Function to check each input the user has to make in the artefact rejection app window
% This function takes inputs from GUI as Input.Value structure. The value
% field saves what the user selcts as a char. I.e. TrialSelection.Value =
% '1,10' if user wants events/trials 1 to 10. If input violates format
% rules, selection gets autoreplaced by standard values and ouputted, so
% that autochange gets visible in app window

% called when the user clicks on the 'Interpolate Artefact Window' button of the artefact rejection window

% Inputs: 
% 1. Data: main window data structure with Data.EventRelatedData and if
% applicable Data.PreprocessedEventRelatedData
% 2. ChannelSelection: Has to contain field value containing a char with
% the selection user made, i.e. ChannelSelection.Value = '1,10' for events 1
% to 10
% 3. TimeWindow: Has to contain field value containing a char with
% the selection user made, i.e. TimeWindow.Value = '1,10' for events 1
% to 10
% 4. TrialSelection: Has to contain field value containing a char with
% the selection user made, i.e. TrialSelection.Value = '1,10' for events 1
% to 10
% 5. EventTime: time vector in seconds for event related data, same length
% as ntime of event related data ('real' time with negative values)

% Outputs: -- if error was deteccted, these values are different to the
% input values
% 1. ChannelSelection: Has to contain field value containing a char with
% the selection user made, i.e. ChannelSelection.Value = '1,10' for events 1
% to 10
% 2. TimeWindow: Has to contain field value containing a char with
% the selection user made, i.e. TimeWindow.Value = '1,10' for events 1
% to 10
% 3. TrialSelection: Has to contain field value containing a char with
% the selection user made, i.e. TrialSelection.Value = '1,10' for events 1
% to 10
% 4. EventTime: time vector in seconds for event related data, same length
% as ntime of event related data ('real' time with negative values)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Check Events
if isfield(Data,'PreprocessedEventRelatedData')
    [TrialSelection.Value] = Utility_SimpleCheckInputs(TrialSelection.Value,"Two",strcat('1,',num2str(size(Data.PreprocessedEventRelatedData,2))));
else
    [TrialSelection.Value] = Utility_SimpleCheckInputs(TrialSelection.Value,"Two",strcat('1,',num2str(size(Data.EventRelatedData,2))));
end

%% Check Channel
if isfield(Data,'PreprocessedEventRelatedData')
    [ChannelSelection.Value] = Utility_SimpleCheckInputs(ChannelSelection.Value,"Two",strcat('1,',num2str(size(Data.PreprocessedEventRelatedData,1))));
else
    [ChannelSelection.Value] = Utility_SimpleCheckInputs(ChannelSelection.Value,"Two",strcat('1,',num2str(size(Data.EventRelatedData,1))));
end

%% Check Time Window 

% StandardValue
%% Get Timewindow and trial information from GUI
if isempty(TimeWindow.Value)
    TempTimeWindin(1,1) = EventTime(floor(length(EventTime)/3));
    TempTimeWindin(1,2) = EventTime(floor(length(EventTime)/3)*2);
    TimeWindow.Value = strcat(num2str(TempTimeWindin(1)),',',num2str(TempTimeWindin(2)));
end

Input = TimeWindow.Value;

if isempty(Input) == 0 % If Trialselection field filled (empty = All Trials)

    CommaTest = find(Input == ',');
    
    if isempty(CommaTest) || length(CommaTest) ~= 1 || any(isletter(Input)) % If no Comma or Point
        TempTimeWindin(1,1) = EventTime(floor(length(EventTime)/3));
        TempTimeWindin(1,2) = EventTime(floor(length(EventTime)/3)*2);
        TimeWindow.Value = strcat(num2str(TempTimeWindin(1)),',',num2str(TempTimeWindin(2)));
        Input = TimeWindow.Value;
        CommaTest = find(Input == ',');
    end
  
    Inputvalue(1,1) = str2double(Input(1:CommaTest(1)-1));
    Inputvalue(1,2) = str2double(Input(CommaTest+1:end));
   
    if isnan(Inputvalue(1)) || isnan(Inputvalue(2))
        TempTimeWindin(1,1) = EventTime(floor(length(EventTime)/3));
        TempTimeWindin(1,2) = EventTime(floor(length(EventTime)/3)*2);
        TimeWindow.Value = strcat(num2str(TempTimeWindin(1)),',',num2str(TempTimeWindin(2)));
        Input = TimeWindow.Value;
        CommaTest = find(Input == ',');
    end

    if Inputvalue(1) > Inputvalue(2)
        TempTimeWindin(1,1) = EventTime(floor(length(EventTime)/3));
        TempTimeWindin(1,2) = EventTime(floor(length(EventTime)/3)*2);
        TimeWindow.Value = strcat(num2str(TempTimeWindin(1)),',',num2str(TempTimeWindin(2)));
        Input = TimeWindow.Value;
        CommaTest = find(Input == ',');
    end
  
end

Input = [];
CommaTest = [];
Inputvalue = [];

