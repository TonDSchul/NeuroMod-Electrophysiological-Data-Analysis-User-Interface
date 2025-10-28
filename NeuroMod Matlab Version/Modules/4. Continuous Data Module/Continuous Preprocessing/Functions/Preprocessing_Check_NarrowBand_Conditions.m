function [Proceed,ExtraPrepro,NewSampleFrequency] = Preprocessing_Check_NarrowBand_Conditions(app)

%________________________________________________________________________________________

%% Function to check whether data was low pass filtered and downsampled before applying narrowband filter.
% If not, a window opens asking the user if he wants to add these steps
%  automatically before the narrowband filter

%Input:
% app: preprocessing app window object

% Outputs:
% 1. Proceed: 1 or 0, 1 if user proceeded with selection and asomething is
% added to the pipeline
% 2. ExtraPrepro: 1 or 0, 1 if extra preprocessing steps have to be added
% 3. NewSampleFrequency: Not used currently! 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


Proceed = 1;
ExtraPrepro = 0;
NewSampleFrequency = 1000;

if strcmp(app.FilterMethodDropDown.Value,'Narrowband')
    flagexist = 0;
    flagbandstop = 0;
    flagmedian = 0;
    flagexistNarrowband = 0;
    flagexistLowPass = 0;
    flagDownsample = 0;
    % If PreprocessingSteps filled with values (already added steps to pipeline)
    if ~isempty(app.PreprocessingSteps)
        % Loop over already added steps
        for i = 1:length(app.PreprocessingSteps)
            % Identofy which filter was already added and mark it with the
            % flag variables
            if strcmp(app.PreprocessingSteps(i),"Low-Pass")
                Index = i;
                flagexistLowPass = 1;
            elseif strcmp(app.PreprocessingSteps(i),"High-Pass")
                Index = i;
                flagexist = 1;
            elseif strcmp(app.PreprocessingSteps(i),"Narrowband")
                Index = i;
                flagexistNarrowband = 1;
            elseif strcmp(app.PreprocessingSteps(i),"Band-Stop")
                IndexBandstop = i;
                flagbandstop = 1;
            elseif strcmp(app.PreprocessingSteps(i),"Median Filter")
                IndexMedian = i;
                flagmedian = 1;
            elseif strcmp(app.PreprocessingSteps(i),"Downsampling")
                flagDownsample = 1;
            end
        end
    end
    
    % Nothing additionally needed
    if flagexistLowPass == 1 && flagDownsample == 1
        Proceed = 0;
        ExtraPrepro = 0;
        if app.Mainapp.Data.Info.NativeSamplingRate > 1000
            NewSampleFrequency = 1000;
        else
            NewSampleFrequency = app.Mainapp.Data.Info.NativeSamplingRate;
        end
        return;
    end
    
     % Open Window to ask!
    NarrowbandFilterSettings = 'Narrowband';
    AppAskForResampleWindow = AskForResampleWindow(NarrowbandFilterSettings,app.Mainapp);
    
    uiwait(AppAskForResampleWindow.AskforResampleWindowUIFigure);
    
    if isvalid(AppAskForResampleWindow)
        if AppAskForResampleWindow.NarrowbandFilterSettings.Option == 1 % Automatically add everything
            ExtraPrepro = 1;
            Proceed = 1;
        elseif AppAskForResampleWindow.NarrowbandFilterSettings.Option == 2 % just add narrowband
            Proceed = 1;
            ExtraPrepro = 0;
        elseif AppAskForResampleWindow.NarrowbandFilterSettings.Option == 3 % nothing added
            Proceed = 0;
            ExtraPrepro = 0;
        end
        delete(AppAskForResampleWindow);
    else
        msgbox("Nothing selected. Proceed just with Narrowband filter.")
        Proceed = 1;
        ExtraPrepro = 0;
    end
   
end

