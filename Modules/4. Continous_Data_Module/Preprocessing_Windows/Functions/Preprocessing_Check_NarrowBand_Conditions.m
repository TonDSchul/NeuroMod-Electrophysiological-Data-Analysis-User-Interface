function [Proceed,Resampling,NewSampleFrequency] = Preprocessing_Check_NarrowBand_Conditions(app)

Proceed = 1;
Resampling = 0;
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

    if flagexistLowPass == 1 && flagDownsample == 1
        Proceed = 0;
        Resampling = 0;
        NewSampleFrequency = 1000;
        return;
    end

    NarrowbandFilterSettings = 'Narrowband';
    AppAskForResampleWindow = AskForResampleWindow(NarrowbandFilterSettings,app.Mainapp);
    
    uiwait(AppAskForResampleWindow.AskforResampleWindowUIFigure);
    
    if isvalid(AppAskForResampleWindow)
        if AppAskForResampleWindow.NarrowbandFilterSettings.Option == 1 % add resampling
            Resampling = 1;
            Proceed = 1;
        elseif AppAskForResampleWindow.NarrowbandFilterSettings.Option == 2 % just add narrowband
            Proceed = 1;
            Resampling = 0;
        elseif AppAskForResampleWindow.NarrowbandFilterSettings.Option == 3 % nothing added
            Proceed = 0;
            Resampling = 0;
        end
        delete(AppAskForResampleWindow);
    else
        msgbox("Nothing selected. Proceed just with Narrowband filter.")
        Proceed = 1;
        Resampling = 0;
    end
   
end

