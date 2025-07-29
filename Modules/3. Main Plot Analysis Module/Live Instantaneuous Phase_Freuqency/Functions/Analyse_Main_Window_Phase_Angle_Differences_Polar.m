function CurrentPlotData = Analyse_Main_Window_Phase_Angle_Differences_Polar(Channel1Data,Channel2Data,Figure1,Time,ChannelToCompare,PlotAppearance,CurrentPlotData)

%________________________________________________________________________________________

%% Function to plot phase angle differences between two channel in a polar unit circle plot

% This function is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Inputs:
% 1. Channel1Data: 1 x n vector with data of channel 1 in currentlyx viewed
% data snippet
% 2. Channel2Data: 1 x n vector with data of channel 2 in currentlyx viewed
% data snippet
% 3. Figure1: handle to figure object to plot in
% 4. Time: 1 x n time vector of currently viewed data snippet ( in respect to whole recording time)
% 5. ChannelToCompare: 1x2 double channel numbers of Channel1Data and Channel2Data
% 6. PlotAppearance: structure holding information about plot appearances
% the user can select
% 7. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

MaxNumberLines = 2000;
% initialize output time-frequency data

phase_data(1,:) = Channel1Data;
phase_data(2,:) = Channel2Data;

phaseDifferences = phase_data(2,:)-phase_data(1,:);

downsamplefactor = round(size(phaseDifferences,2)/2000);
if downsamplefactor ~= 0
    phaseDifferences = downsample(phaseDifferences,downsamplefactor);
end
% Build angle and radius matrices for each line: [0, theta]
theta = [zeros(1, length(phaseDifferences)); phaseDifferences];  % 2 x N
radii = [zeros(1, length(phaseDifferences)); ones(1, length(phaseDifferences))];  % 2 x N

% Compute average vector
avg_vector = mean(exp(1i * phaseDifferences));

% Get angle and length
avg_angle = angle(avg_vector);
avg_length = abs(avg_vector);

PhaseDiffs_handle = findobj(Figure1, 'Tag', 'PhaseDiffs');
MeanVector_handle = findobj(Figure1, 'Tag', 'MeanVector');

if length(PhaseDiffs_handle)>length(phaseDifferences)
    delete(PhaseDiffs_handle(length(phaseDifferences)+1:end));
    PhaseDiffs_handle = findobj(Figure1, 'Tag', 'PhaseDiffs');
end

if length(MeanVector_handle)>1
    delete(MeanVector_handle(2:end));
    MeanVector_handle = findobj(Figure1, 'Tag', 'MeanVector');
end

if isempty(PhaseDiffs_handle)
    hold(Figure1, 'on');
    polarplot(Figure1, theta(), radii(), 'Color',PlotAppearance.PhaseSyncPlots.AngleDiffAnglesColor,'LineWidth',PlotAppearance.PhaseSyncPlots.AngleDiffAnglesWidth,'Tag', 'PhaseDiffs');
    
    % Plot average vector as a green line
    polarplot(Figure1, [0 avg_angle], [0 avg_length], 'Color',PlotAppearance.PhaseSyncPlots.AngleDiffMeanColor, 'LineWidth', PlotAppearance.PhaseSyncPlots.AngleDiffMeanWidth, 'Tag', 'MeanVector');
    
    MeanVector_handle = findobj(Figure1, 'Tag', 'MeanVector');
    MeanVector_handle.DisplayName = 'Mean Phase Angle'; % Set the legend label
    
    %legend(Figure1, MeanVector_handle(1),'Location','northeast'); % This creates/updates the legend

    Figure1.Color = PlotAppearance.PhaseSyncPlots.AngleDiffBackgroundColor;        % Background color
    Figure1.ThetaColor = 'k';            % Angular ticks
    Figure1.RColor     = 'k';            % Radial ticks
    Figure1.GridColor  = 'k';            % Grid lines
    Figure1.Title.Color = 'k';           % Title color
    Figure1.FontSize = PlotAppearance.PhaseSyncPlots.AngleDiffFontSize;

else
    for i = 1:length(PhaseDiffs_handle)
        Figure1.NextPlot = "add";
        set(PhaseDiffs_handle(i), 'ThetaData', theta(:,i),'RData', radii(:,i), 'Tag', 'PhaseDiffs');
    end

    if length(PhaseDiffs_handle)<length(phaseDifferences)
        polarplot(Figure1, theta(:,i+1:end), radii(:,i+1:end),'Color',PlotAppearance.PhaseSyncPlots.AngleDiffAnglesColor,'LineWidth',PlotAppearance.PhaseSyncPlots.AngleDiffAnglesWidth, 'Tag', 'PhaseDiffs');
    end

    set(MeanVector_handle(1), 'ThetaData', [0 avg_angle],'RData', [0 avg_length], 'Tag', 'MeanVector');
    uistack(MeanVector_handle(1), 'top');
end

title(Figure1, strcat(PlotAppearance.PhaseSyncPlots.AngleDiffTitle," Ch ",num2str(ChannelToCompare(1))," vs Ch ",num2str(ChannelToCompare(2))));

CurrentPlotData.PhaseDiffsXData = theta;
CurrentPlotData.PhaseDiffsYData = radii;
CurrentPlotData.PhaseDiffsCData = [];
CurrentPlotData.PhaseDiffsType = strcat("Theta (X) and Radii (Y) of Phase Angle Differences ","Ch ",num2str(ChannelToCompare(1))," vs Ch ",num2str(ChannelToCompare(2)));
%CurrentPlotData.PhaseDiffsXTicks = Figure1.XTickLabel;