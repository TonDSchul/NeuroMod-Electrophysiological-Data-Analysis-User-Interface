function [climsTF,CurrentPlotData] = Event_Module_Time_Frequency_Main(Data,EventRelatedData,Figure,SampleRate,TimearoundEvent,TF,Window,TwoORThreeD,CurrentPlotData,PlotAppearance,BaselineNormalize,NormalizationWindow)

%________________________________________________________________________________________
%% Main Function to call correct TF analysis and plotting functions with correct event related data portion based on input in app window

% Called whenever a TF calculation is done to select the right function
% based on what analysis the user selected - first calls analysis function,
% the plotting function

% Inputs: 
% 1. EventRelatedData: nchannel x nevents n ntimepoints single matrix with
% event related data.
% 2. Figure: Axes handle to figure to plot in
% 3. SampleRate: SampleRate as double in Hz
% 4. DataChannelSelected: 1 x 2 double vector with channels to take, i.e.
% [1,10] for channel 1 to 10, comes from
% 'Event_Module_Organize_TF_Window_Inputs' function
% 4. EventNrRange: 1 x 2 double vector with events to take, i.e.
% [1,10] for events 1 to 10, comes from
% 'Event_Module_Organize_TF_Window_Inputs' function
% 5. TimearoundEvent: 1 x 2 double vector time in seconds before event and after event, i.e.
% [0.2,0.5] for a time range of -0.2 to 0.5 NOTE: first element has to be
% positive, although its a negativ time.
% 6. TF: structure with parameter for TF calculations, comes from
% 'Event_Module_Organize_TF_Window_Inputs' function
% 7. Type: determines signal components for TF analysis: "Total" OR "NonPhaseLocked" OR
% "PhaseLocked"; NonPhaseLocked = Signal - ERP; Phaselocked = ERP; Total =
% both components
% 8. Plottype: "TF" OR "ITPC" to plot either Time frequency power or inter
% trial phase clustering.
% 9. WaveletType: determines type of TF analyisis, either "Moorlet
% Wavelets" OR "Filter Hilbert"; NOTE: TODO: "Filter Hilbert" does not work yet 
% 10. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 11. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 12. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds

% Outputs:
% 1. climsTF: clim of current plot, saved by TF window to be able to auto
% clim without calculating again
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Get data
if strcmp(TF.AnalysisType,'Single Channel ERP Spectogram')
    EventRelatedData = squeeze(EventRelatedData(TF.SingleChannelSelected,TF.EventNrRange,:));
    if isscalar(TF.EventNrRange)
        EventRelatedData = EventRelatedData';
    end

    if size(EventRelatedData,1) > 1
        EventRelatedData = mean(EventRelatedData,1);
    end

else
%elseif strcmp(TF.AnalysisType,'Time Varying Wavelet Coherence')
    if TF.ChannelTriggerToCompareType(1)==1 %1 = trigger
        % trigger 1
        EventRelatedData1 = squeeze(EventRelatedData(TF.SingleChannelSelected,TF.ChannelTriggerToCompare(1),:));
        EventRelatedData1 = EventRelatedData1';

        if size(EventRelatedData1,1) > 1
            EventRelatedData1 = mean(EventRelatedData1,1);
        end
        % trigger 2
        EventRelatedData2 = squeeze(EventRelatedData(TF.SingleChannelSelected,TF.ChannelTriggerToCompare(2),:));
        EventRelatedData2 = EventRelatedData2';
    
        if size(EventRelatedData2,1) > 1
            EventRelatedData2 = mean(EventRelatedData2,1);
        end
    else % ##########################################################
        % channel 1
        EventRelatedData1 = squeeze(EventRelatedData(TF.ChannelTriggerToCompare(1),TF.EventNrRange,:));
        if isscalar(TF.EventNrRange)
            EventRelatedData1 = EventRelatedData1';
        end
    
        if size(EventRelatedData1,1) > 1
            EventRelatedData1 = mean(EventRelatedData1,1);
        end
        % channel 2
        EventRelatedData2 = squeeze(EventRelatedData(TF.ChannelTriggerToCompare(2),TF.EventNrRange,:));
        if isscalar(TF.EventNrRange)
            EventRelatedData2 = EventRelatedData2';
        end
    
        if size(EventRelatedData2,1) > 1
            EventRelatedData2 = mean(EventRelatedData2,1);
        end
    end

end

%% Call respective function
if strcmp(TF.AnalysisType,'Time Varying Wavelet Coherence')
    [climsTF,CurrentPlotData] = Event_Module_Wavelet_Coherence(Data,EventRelatedData1,EventRelatedData2,Window,BaselineNormalize,NormalizationWindow,TF,[],Figure,SampleRate,PlotAppearance,Data.Info.EventRelatedTime,CurrentPlotData,TwoORThreeD);

elseif strcmp(TF.AnalysisType,'Wavelet Coherence')
    [climsTF,CurrentPlotData] = Event_Module_Wavelet_Coherence(Data,EventRelatedData1,EventRelatedData2,Window,BaselineNormalize,NormalizationWindow,TF,[],Figure,SampleRate,PlotAppearance,Data.Info.EventRelatedTime,CurrentPlotData,TwoORThreeD);

elseif strcmp(TF.AnalysisType,'Single Channel ERP Spectogram')
    [climsTF,CurrentPlotData] = Event_Module_Spectrogram2(Data,EventRelatedData,Window,BaselineNormalize,NormalizationWindow,TF,[],Figure,SampleRate,PlotAppearance,Data.Info.EventRelatedTime,CurrentPlotData,TwoORThreeD);
end








%[CurrentClim,CurrentPlotData] = Analyse_Main_Window_Event_Spectrogram2(Data,DataToShow,EventsToShow,ChannelToPlot,Window,FrequencyRange,LockCLim,DataType,CurrentClim,Figure,SampleRate,PlotAppearance,Time,CurrentEventChannel,PlotEvent,CurrentPlotData,TwoORThreeD);


% % Check if max frequ is bigger than nyquist
% if TF.FreqRange(3) > SampleRate/2
%     msgbox("Warning: Entered max frequency exceeds nyquist. Max frequency auto-set to nyquist!")
%     TF.FreqRange(3) = SampleRate/2;
% end
% 
% if strcmp(WaveletType,"Moorlet Wavelets")
%     [tf,frex] = Event_Module_Time_Frequency_Wavelet_ITPC_Cycles(EventRelatedData,Data.Info.EventRelatedTime,[],TF.FreqRange,TF.Range_cycles);
% 
%     [climsTF,CurrentPlotData] = Event_Module_Time_Frequency_Plot_WaveletTF (Data,Figure,Data.Info.EventRelatedTime,TF.FreqRange,tf,frex,0,Plottype,Type,DataChannelSelected,EventNrRange,TwoORThreeD,CurrentPlotData,PlotAppearance,BaselineNormalize,NormalizationWindow);
% elseif strcmp(WaveletType,"Filter Hilbert")
%     [tf,frex] = Event_Module_Time_Frequency_Hilbert_TimeFrequ_ITPC (EventRelatedData,SampleRate,Data.Info.EventRelatedTime,TF.FreqRange,TF.FilterRange,TF.FilterOrder,[EventNrRange(1),EventNrRange(2)],DataChannelSelected,[]);
% 
%     Event_Module_Time_Frequency_Plot_Hilbert_TF (Data,tf,frex,Data.Info.EventRelatedTime,TF.FreqRange,0,Figure,0,Type,Plottype,BaselineNormalize,NormalizationWindow);
% end



