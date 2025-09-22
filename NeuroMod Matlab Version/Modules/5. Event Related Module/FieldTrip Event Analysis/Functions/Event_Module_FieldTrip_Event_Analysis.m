function Event_Module_FieldTrip_Event_Analysis(Data,DataType,AnalysisType,SingleERPChannel,EventChannelToUse,EventTimeBeforeAfter,Info,EventDataType,TrialSelection)

%% -------------------------------------------------------------------------------------------------
%% ------------------------------ Get Fieldtrip compatible Event data ------------------------------
%% -------------------------------------------------------------------------------------------------

[Error,SavePath,raw,event,eventdata] = Manage_Dataset_SaveData_FieldTrip(Data,DataType,1,0,0,0,"No",[],EventChannelToUse,EventDataType);

%% -------------------------------------------------------------------------------------------------
%% ------------------------------ Create Probe Layout ------------------------------
%% -------------------------------------------------------------------------------------------------
nChannels = 64;
spacing   = 20;  % 20 µm

elec = [];
elec.label    = arrayfun(@(x) sprintf('chan%d', x), 1:nChannels, 'UniformOutput', false);
elec.elecpos  = [zeros(nChannels,1), (0:nChannels-1)'*spacing, zeros(nChannels,1)];
elec.chanpos  = elec.elecpos;
elec.unit     = 'um';
elec.type     = 'other';
elec.chanunit = repmat({'um'}, nChannels, 1);   % <-- must be CELL array of strings

% Create a layout
cfg_layout = [];
cfg_layout.elec = elec;
cfg_layout.rotate = 45;
cfg_layout.showlabels = 'yes';

layout = ft_prepare_layout(cfg_layout, eventdata);   % creates proper 2D layout for plotting

%% -------------------------------------------------------------------------------------------------
%% ------------------------------ ERP ------------------------------
%% -------------------------------------------------------------------------------------------------

if strcmp(AnalysisType,"SingleERP") || strcmp(AnalysisType,"MultipleERP")
    
    if strcmp(AnalysisType,"MultipleERP")
        cfg = [];
        cfg.layout = layout;
        cfg.showlabels = 'yes';
        cfg.interactive = 'yes';
        cfg.rotate = 45;
        cfg.style = 'butterfly';
        cfg.showoutline = 'yes';
        cfg.trials = eval(TrialSelection);
    end

    if strcmp(AnalysisType,"SingleERP")
        cfg = [];
        cfg.trials = eval(TrialSelection);
        cfg.channel = strcat('chan',SingleERPChannel);     % or any label from eventdata.label
    end

    selectedData = ft_selectdata(cfg, eventdata);
    
    avg = ft_timelockanalysis(cfg, selectedData);
    
    fieldsToDelete = {'trials'};
    % Delete fields
    cfg = rmfield(cfg, fieldsToDelete);

    if strcmp(AnalysisType,"MultipleERP")
        ft_multiplotER(cfg, avg);
    end

    if strcmp(AnalysisType,"SingleERP")
        ft_singleplotER(cfg, avg);
    end

end

%% -------------------------------------------------------------------------------------------------
%% ------------------------------ Time Frequency Power ------------------------------
%% -------------------------------------------------------------------------------------------------

if strcmp(AnalysisType,"SingleChannelTimeFrequencyPower")

    freqs = str2double(strsplit(Info.TimeFrequenyPowerFreqs,','));
    cfg = [];
    cfg.output     = 'pow';             % 'pow' = power, 'fourier' = complex output for connectivity
    cfg.channel    = strcat('chan',SingleERPChannel);             % channels to analyze
    cfg.foi        = freqs(1):freqs(3):freqs(2);           % frequencies of interest (Hz)
    cfg.trials = eval(TrialSelection);

    if strcmp(Info.TFMethod,"Wavelet")
        cfg.method     = 'wavelet';         % or 'mtmconvol'
        cfg.width = str2double(Info.SlidingWindowLength);
    else
        cfg.method     = 'mtmconvol';         % or 'wavelet'
        cfg.taper     = 'hanning';     % or 'dpss'
        cfg.t_ftimwin  = str2double(Info.SlidingWindowLength)./ cfg.foi;      % length of sliding time window (s), e.g., 5 cycles per freq
    end
    
    cfg.toi        = -EventTimeBeforeAfter(1):str2double(Info.TimeStepLength):EventTimeBeforeAfter(2);     % time points (s) relative to event onset
    cfg.pad        = 'maxperlen';       % zero-padding to next power-of-2
    cfg.keeptrials = 'no';              % 'yes' to keep single trials for statistics
    
    selectedData = ft_selectdata(cfg, eventdata);

    TFR = ft_freqanalysis(cfg, selectedData);

    cfg_plot = [];
    cfg_plot.channel = strcat('chan',SingleERPChannel);
    if Info.BaselineNormalize
        Baseline = str2double(strsplit(Info.BaseLineWindow,','));
        cfg_plot.baseline     = [Baseline(1) Baseline(2)];
        cfg_plot.baselinetype = 'db';
    end
    cfg_plot.zlim         = 'maxabs';  % automatic scaling
    ft_singleplotTFR(cfg_plot, TFR);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');

end

if strcmp(AnalysisType,"ConnectivityAnalysis")
    
    cfg.trials = eval(TrialSelection);
    selectedData = ft_selectdata(cfg, eventdata);
    
    cfg = [];
    cfg.demean  = 'yes';   % remove DC offset
    cfg.detrend = 'yes';   % optional
    data_preproc = ft_preprocessing(cfg, selectedData);
    
    freqs = str2double(strsplit(Info.TimeFrequenyPowerFreqs,','));
    cfg = [];
    cfg.output    = 'fourier';      % complex numbers for phase and amplitude
    cfg.channel    = {'chan1','chan2'};             % channels to analyze
    cfg.foi        = freqs(1):freqs(3):freqs(2);           % frequencies of interest (Hz)
    cfg.trials = eval(TrialSelection);
    cfg.method     = 'wavelet';         % or 'mtmconvol'
    cfg.width = str2double(Info.SlidingWindowLength);
    cfg.pad = 'maxperlen';  % pad each trial to the length of the longest trial
    cfg.toi        = -EventTimeBeforeAfter(1):str2double(Info.TimeStepLength):EventTimeBeforeAfter(2);     % time points (s) relative to event onset
    
    TFR = ft_freqanalysis(cfg, data_preproc);
    
    cfg = [];
    cfg.parameter = 'plvspctrm';
    cfg.channelcmb = {'chan1','chan2'};
    ft_connectivityplot(cfg, conn);

end

