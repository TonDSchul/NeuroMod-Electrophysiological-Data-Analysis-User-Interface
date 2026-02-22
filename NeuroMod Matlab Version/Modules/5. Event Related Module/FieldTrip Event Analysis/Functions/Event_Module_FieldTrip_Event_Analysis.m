function CurrentPlotData = Event_Module_FieldTrip_Event_Analysis(Data,DataType,AnalysisType,SingleERPChannel,EventChannelToUse,EventTimeBeforeAfter,Info,EventDataType,TrialSelection)

%________________________________________________________________________________________

%% Function to Use some of the FieldTrip functionality within NeuroMod

% Naturally, this function uses functions from the FieldTrip Matlab toolbox

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. DataType: char, either "Raw Data" or "Preprocecssed Data" whether to
% construct struc for fieldtrip with one of both datasets
% 3. AnalysisType: char, what type of analysis do handle with FieldTrip;
% see below
% 4. SingleERPChannel: double, channel to show single channel ERP for (active channel, not data matrix channel)
% EventChannelToUse: char, event channel from which event time stamps are
% taken
% EventTimeBeforeAfter: 1x2 vector with pre and post stimulus time (prestimulus time postive!)
% Info: struc with feilds holding parameter for analysis, like
% Info.BaselineNormalizeERP (1 or 0) Info.BaseLineWindow (actual
% window),TimeFrequenyPowerFreqs (freqs for time frequency power)
% EventDataType: char, either 'Raw Event Related Data' OR 'Preprocessed Event Related Data'
% TrialSelection: char, matlab expression with user selected trial range to
% analyze

% Output: 
% 1. CurrentPlotData: struc saving results for export; NOT implemented yet!

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

CurrentPlotData = [];

%% -------------------------------------------------------------------------------------------------
%% ------------------------------ Get Fieldtrip compatible Event data ------------------------------
%% -------------------------------------------------------------------------------------------------

[Error,~,~,~,eventdata] = Manage_Dataset_SaveData_FieldTrip(Data,DataType,1,0,0,0,"No",[],EventChannelToUse,EventDataType);

%% -------------------------------------------------------------------------------------------------
%% ------------------------------ Create Probe Layout ------------------------------
%% -------------------------------------------------------------------------------------------------

%% ------------------------- Set Basic Parameter -------------------------
% Only active recording channel!

xcoords = Data.Info.ProbeInfo.xcoords;
ycoords = Data.Info.ProbeInfo.ycoords;

elec = [];
elec.label    = arrayfun(@(x) sprintf('chan%d', x), 1:length(Data.Info.ProbeInfo.ActiveChannel), 'UniformOutput', false);
elec.elecpos  = [xcoords(Data.Info.ProbeInfo.ActiveChannel)', ycoords(Data.Info.ProbeInfo.ActiveChannel)', zeros(length(Data.Info.ProbeInfo.ActiveChannel),1)];  
elec.chanpos  = elec.elecpos;
elec.unit     = 'um';
elec.type     = 'other';
elec.chanunit = repmat({'um'}, length(Data.Info.ProbeInfo.ActiveChannel), 1);   % <-- must be CELL array of strings

% Create a layout
cfg_layout = [];
cfg_layout.elec = elec;
cfg_layout.showlabels = 'yes';

layout = ft_prepare_layout(cfg_layout, eventdata);   % creates proper 2D layout for plotting

%% -------------------------------------------------------------------------------------------------
%% ------------------------------ ERP ------------------------------
%% -------------------------------------------------------------------------------------------------

if strcmp(AnalysisType,"SingleERP") || strcmp(AnalysisType,"MultipleERP")
    
    OriginalChannel = SingleERPChannel;
    [SingleERPChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,str2double(SingleERPChannel),'MainPlot');
    SingleERPChannel = num2str(SingleERPChannel);

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

    if Info.BaselineNormalizeERP
        Baseline = str2double(strsplit(Info.BaseLineWindow,','));
        cfg_bs = [];
        cfg_bs.baseline = Baseline;   % adapt to your time axis
        avg = ft_timelockbaseline(cfg_bs, avg);
    end

    fieldsToDelete = {'trials'};
    % Delete fields
    cfg = rmfield(cfg, fieldsToDelete);

    if strcmp(AnalysisType,"MultipleERP")
        ft_multiplotER(cfg, avg);
    end

    if strcmp(AnalysisType,"SingleERP")
        ft_singleplotER(cfg, avg);
    end

    CurrentPlotData.ERP_AVERAGE = avg;

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

    CurrentPlotData.TFrequencyPowerResultSingleChannel = TFR;

end

if strcmp(AnalysisType,"AllChannelTimeFrequencyPower")

    freqs = str2double(strsplit(Info.TimeFrequenyPowerFreqs,','));
    cfg = [];
    cfg.output     = 'pow';             % 'pow' = power, 'fourier' = complex output for connectivity
    cfg.channel    = 'all';             % analyze all channels
    cfg.foi        = freqs(1):freqs(3):freqs(2);   % frequencies of interest (Hz)
    cfg.trials     = eval(TrialSelection);

    if strcmp(Info.TFMethod,"Wavelet")
        cfg.method     = 'wavelet';         
        cfg.width      = str2double(Info.SlidingWindowLength);   % number of cycles
    else
        cfg.method     = 'mtmconvol';        
        cfg.taper      = 'hanning';     
        cfg.t_ftimwin  = str2double(Info.SlidingWindowLength)./ cfg.foi;  
    end
    
    cfg.toi        = -EventTimeBeforeAfter(1):str2double(Info.TimeStepLength):EventTimeBeforeAfter(2);     
    cfg.pad        = 'maxperlen';       
    cfg.keeptrials = 'no';              
    
    selectedData = ft_selectdata(cfg, eventdata);

    TFR = ft_freqanalysis(cfg, selectedData);

    cfg_plot = [];
    cfg_plot.layout = layout;  
    cfg_plot.showlabels = 'yes';

    if Info.BaselineNormalize
        Baseline = str2double(strsplit(Info.BaseLineWindow,','));
        cfg_plot.baseline     = [Baseline(1) Baseline(2)];
        cfg_plot.baselinetype = 'db';   % or 'absolute'/'relative'/'relchange'
    end

    cfg_plot.zlim = 'maxabs';

    % Option 1: multiplot of all channels
    ft_multiplotTFR(cfg_plot, TFR);

    % Option 2: topographic distribution (pick a time/freq window)
    % cfg_plot.xlim = [0.3 0.5];   % time window in seconds
    % cfg_plot.ylim = [8 12];      % frequency window (Hz)
    % ft_topoplotTFR(cfg_plot, TFR);

    xlabel('Time (s)');
    ylabel('Frequency (Hz)');

    CurrentPlotData.TFrequencyPowerResultAllChannel = TFR;

end

if strcmp(AnalysisType,"ConnectivityAnalysis")
    
    try
        ChannelCharsToCompare = cell(1,1);
        ChannelToCompare = eval(Info.ChannelToCompare);
        for i = 1:length(ChannelToCompare)
            if i ~= length(ChannelToCompare)
                ChannelCharsToCompare{1} = [ChannelCharsToCompare{1},strcat('chan',num2str(ChannelToCompare(i)),',')];
            else
                ChannelCharsToCompare{1} = [ChannelCharsToCompare{1},strcat('chan',num2str(ChannelToCompare(i)))];
            end
        end
    catch
        Error = 1;
        msgbox("Format error. Please only use Maltab expressions for channel to compare.")
        return;
    end

    % --- select trials / channels as before
    cfg.trials = eval(TrialSelection);
    selectedData = ft_selectdata(cfg, eventdata);
    
    % --- preprocessing
    cfg = [];
    cfg.demean  = 'yes';
    cfg.detrend = 'yes';
    data_preproc = ft_preprocessing(cfg, selectedData);
    
    % --- frequency decomposition: keep trials (important!)
    freqs = str2double(strsplit(Info.TimeFrequenyPowerFreqs,','));
    cfg = [];
    cfg.output    = 'fourier';                 % complex Fourier/wavelet output
    cfg.channel   = {'chan1','chan2'};         % the channels you want to analyze (or 'all')
    cfg.foi       = freqs(1):freqs(3):freqs(2);
    cfg.method    = 'wavelet';
    cfg.width     = str2double(Info.SlidingWindowLength);
    cfg.pad       = 'maxperlen';
    cfg.toi       = -EventTimeBeforeAfter(1):str2double(Info.TimeStepLength):EventTimeBeforeAfter(2);
    cfg.keeptrials = 'yes';                    % <-- REQUIRED for connectivity
    TFR = ft_freqanalysis(cfg, data_preproc);
    
    % --- connectivity analysis (PLV)
    cfg_conn = [];
    cfg_conn.method = 'plv';                   % choose method: 'plv','coh','ppc','wpli', ...
    cfg_conn.channelcmb = {'chan1','chan2'};   % specific channel pair(s) as a N x 2 cell array
    % alternatively compute for all pairs:
    % chanlabels = TFR.label;
    % idx = nchoosek(1:numel(chanlabels),2);
    % cfg_conn.channelcmb = cell(size(idx,1),2);
    % for i=1:size(idx,1)
    %   cfg_conn.channelcmb{i,1} = chanlabels{idx(i,1)};
    %   cfg_conn.channelcmb{i,2} = chanlabels{idx(i,2)};
    % end
    
    conn = ft_connectivityanalysis(cfg_conn, TFR);
    
    % conn now contains e.g. conn.plvspctrm (freq x time or pair x freq x time depending on config)
    CurrentPlotData.TFrequencyComplexFourierResult = TFR;
    CurrentPlotData.ConnectivityResult = conn;
    
    % --- plotting
    cfg_plot = [];
    cfg_plot.parameter = 'plvspctrm';          % name depends on chosen method
    cfg_plot.channelcmb = {'chan1','chan2'};   % keep consistent with analysis
    ft_connectivityplot(cfg_plot, conn);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');

end

