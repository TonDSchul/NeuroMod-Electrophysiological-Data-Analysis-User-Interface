function [currentYlim,CurrentPlotData] = Analyse_Main_Window_Spectral_Density_Estimate(Data,SampleRate,Figure,TimeWindow,PDLim,LockYLim,CurrentPlotData,PlotAppearance)

%________________________________________________________________________________________

%% Main Function to calculate and plot Spectral Density Estimate for specific frequency ranges for the main window data plot

% Note: LockYLim option determines, whether there should be a global limit
% for the y axis. If set to 1, the current ylim is compared to the max of
% ylim of previous power estimate plots. If current ylims exceed the previous ylims,
% global ylim is set to current. Otherwise global ylim remains unchanged. 

% Inputs:
% 1: Data: nchannel x n timepoints single matrix with data to compute
% frequency specific power estimates
% 2: SampleRate: in Hz as double (i.e. Data.Info.NativeSamplingRate)
% 3. Figure: axes object of figure to plot in
% DatatoPlot: nchannel x n timepoints single matrix of data to calculate csd with
% 4. TimeWindow: Time vector as double with one time point for each
% sample of Data
% 5. PDLim: 1 x 2 double, comes from Spectral_Power_Estimate_Window and
% captures the ylim of previous power plots. This is used to compare to current ylim and determine if y axis
% limits have to be changed. Only applies if LockYLim = 1, 
% 6. LockYLim: 1 or 0 as double. 1 to only update ylim when current ylim
% exceeds global ylim from Spectral_Power_Estimate_Window
% 7. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 8. PlotAppearance: structure holding information about plot appearances
% the user can select

% Output:
% 1. currentYlim: global ylim - either unchanged from previous power estimate plot if
% limits were no exceeded or current ylim otherwise. 
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if ~isa(Data, 'double')
    Data = double(Data);
end

nchan = size(Data,1);

% Comvert Main Window Time Span into sample
TimeWindow = length(TimeWindow);

% Set up welch method 
specest = spectrum.welch('Hamming', TimeWindow/2);

% Sum Spectral power over all selected Channel
for i=1:nchan
  % Apply welch method
  Estimate = psd(specest, Data(i,:), 'Fs', SampleRate);
  if i==1%initialize
    Power = Estimate.Data;
  else%sum
    Power = Power + Estimate.Data;
  end
end

% Get average of estimate over all channel
Power    = Power/nchan;

%% Average Power over Frequencybands
alpha = 8:12;
time_diffs = abs(Estimate.Frequencies - alpha);
% Find the index of the minimum absolute difference
[~, alphaclosest_index] = min(time_diffs);
beta = 13:30;
time_diffs = abs(Estimate.Frequencies - beta);
% Find the index of the minimum absolute difference
[~, betaclosest_index] = min(time_diffs);
gamma = 31:80;
time_diffs = abs(Estimate.Frequencies - gamma);
% Find the index of the minimum absolute difference
[~, gammaclosest_index] = min(time_diffs);
delta = 1:4;
time_diffs = abs(Estimate.Frequencies - delta);
% Find the index of the minimum absolute difference
[~, deltaclosest_index] = min(time_diffs);
theta = 5:7;
time_diffs = abs(Estimate.Frequencies - theta);
% Find the index of the minimum absolute difference
[~, thetaclosest_index] = min(time_diffs);

Avgalpha = mean(Power(alphaclosest_index));
Avgbeta = mean(Power(betaclosest_index));
Avggamma = mean(Power(gammaclosest_index));
Avgdelta = mean(Power(deltaclosest_index));
Avgtheta = mean(Power(thetaclosest_index));

PowerEstimatesHandles = findobj(Figure, 'Type', 'bar', 'Tag', 'PowerEstimates');

if isempty(PowerEstimatesHandles)
    bar(Figure,[Avgdelta,Avgtheta,Avgalpha,Avgbeta,Avggamma],'FaceColor', PlotAppearance.LivePowerEstimateWindow.BarColor, 'EdgeColor', PlotAppearance.LivePowerEstimateWindow.BarColor,'Tag','PowerEstimates');
    title(Figure,"Spectral Power Estimate")
    ylabel(Figure,PlotAppearance.LivePowerEstimateWindow.YLabel)
    xlabel(Figure,PlotAppearance.LivePowerEstimateWindow.XLabel)
    %xlable(Figure,"");
    xtick_labels = {strcat('Delta (',num2str(delta(1)),' - ',' ',num2str(delta(end)),' Hz)'), strcat('Theta (',num2str(theta(1)),' - ',' ',num2str(theta(end)),' Hz)'), strcat('Alpha (',num2str(alpha(1)),' - ',' ',num2str(alpha(end)),' Hz)'), strcat('Beta (',num2str(beta(1)),' - ',' ',num2str(beta(end)),' Hz)'), strcat('Gamma (',num2str(gamma(1)),' - ',' ',num2str(gamma(end)),' Hz)')};
    % Set the xtick labels
    Figure.XTickLabel = xtick_labels;    
    Figure.FontSize = PlotAppearance.LivePowerEstimateWindow.FontSize;
else
    set(PowerEstimatesHandles, 'YData', [Avgdelta,Avgtheta,Avgalpha,Avgbeta,Avggamma],'FaceColor', PlotAppearance.LivePowerEstimateWindow.BarColor, 'EdgeColor', PlotAppearance.LivePowerEstimateWindow.BarColor, 'Tag', 'Barobject');
end

if LockYLim== 1

    currentYlim(1) = min([Avgdelta,Avgtheta,Avgalpha,Avgbeta,Avggamma],[],'all');
    currentYlim(2) = max([Avgdelta,Avgtheta,Avgalpha,Avgbeta,Avggamma],[],'all');

    if isempty(PDLim)
        PDLim = currentYlim;
    else
        if currentYlim(1) < PDLim(1) && currentYlim(2) < PDLim(2)
            ylim(Figure,[currentYlim(1) PDLim(2)]);
            currentYlim(2) = PDLim(2);
        elseif currentYlim(1) < PDLim(1) && currentYlim(2) > PDLim(2)
            ylim(Figure,[currentYlim(1) currentYlim(2)]);
        elseif currentYlim(1) > PDLim(1) && currentYlim(2) > PDLim(2)
            ylim(Figure,[PDLim(1) currentYlim(2)]);
            currentYlim(1) = PDLim(1);
        elseif currentYlim(1) > PDLim(1) && currentYlim(2) < PDLim(2)
            ylim(Figure,PDLim);
            currentYlim = PDLim;
        end
                
    end
else
     currentYlim(1) = min([Avgdelta,Avgtheta,Avgalpha,Avgbeta,Avggamma],[],'all');
     currentYlim(2) = max([Avgdelta,Avgtheta,Avgalpha,Avgbeta,Avggamma],[],'all');
     ylim(Figure,currentYlim);
end

%% save plotted data in case user wants to save 
CurrentPlotData.XData = [1,2,3,4,5];
CurrentPlotData.YData = [Avgdelta,Avgtheta,Avgalpha,Avgbeta,Avggamma];
CurrentPlotData.CData = [];
CurrentPlotData.Type = "Spectral Estimate";
CurrentPlotData.XTicks = Figure.XTickLabel;
