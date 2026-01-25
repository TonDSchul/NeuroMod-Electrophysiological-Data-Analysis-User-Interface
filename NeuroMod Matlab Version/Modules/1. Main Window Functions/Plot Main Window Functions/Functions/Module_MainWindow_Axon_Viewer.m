function [PreviousThreshGrids,PlotThreshGrids] = Module_MainWindow_Axon_Viewer(Data,PreviousThreshGrids,Info,PlotMode,PlotAppearance,PlotThreshGrids)

% PreviousThreshGrids.T1 = cell array, each cell a grid at the previously
% ploted time point
% last cell is uncurated currently shown raw grid!

Threshold = Info.HighPassStatistics.Mean - (PlotAppearance.MainWindow.Data.AxonViewerSpikeThreshold * Info.HighPassStatistics.Std);   

if isempty(PreviousThreshGrids.T1)
    PreviousThreshGrids.T1{1} = Data; %
    
    if ~isfield(PreviousThreshGrids,'SpikeChannelSelected')
        %initialized thresholded grid
        NewPreviousThreshGrids = zeros(size(PreviousThreshGrids.T1{1}));
        % indicies of subthreshold values
        SubThresholdIndicies = PreviousThreshGrids.T1{1} < Threshold;
        % save potential when below threshold
        NewPreviousThreshGrids(SubThresholdIndicies) = PreviousThreshGrids.T1{1}(SubThresholdIndicies);
        % replace in cell array because it becomes the next previous grid
    
        if PlotAppearance.MainWindow.Data.AxonViewerOnlyOnes == 1
            NewPreviousThreshGrids(NewPreviousThreshGrids<0) = -1;
        end
    else
        [row, col] = ind2sub(size(PreviousThreshGrids.T1{1}), PreviousThreshGrids.SpikeChannelSelected);

        PrevValue = PreviousThreshGrids.T1{1}(col,row);
        PreviousThreshGrids.T1{1} = zeros(size(PreviousThreshGrids.T1{1}));
        PreviousThreshGrids.T1{1}(col,row) = PrevValue;

        NewPreviousThreshGrids = PreviousThreshGrids.T1{1};
    end

    if isfield(PreviousThreshGrids,'SpikeChannelSelected')
        if ~isempty(PreviousThreshGrids.SpikeChannelSelected)

            [row, col] = ind2sub(size(NewPreviousThreshGrids), PreviousThreshGrids.SpikeChannelSelected);

            if NewPreviousThreshGrids(col,row) == 0
                % NewPreviousThreshGrids(:) = 0;
            else
                % neighbouthood
                BW = NewPreviousThreshGrids ~= 0;
                CC = bwconncomp(BW, 8);
            
                % Identify which component with SpikeChannelSelected
                keepComp = [];
                for k = 1:CC.NumObjects
                    if any(CC.PixelIdxList{k} == PreviousThreshGrids.SpikeChannelSelected)
                        keepComp = k;
                        break;
                    end
                end
            
                % Zero out everything except that component
                if ~isempty(keepComp)
                    NewPreviousThreshGrids(:) = 0;
                    NewPreviousThreshGrids(CC.PixelIdxList{keepComp}) = ...
                        NewPreviousThreshGrids(CC.PixelIdxList{keepComp});
                else
                    PrevValue = NewPreviousThreshGrids(col,row);
                    NewPreviousThreshGrids(:) = 0;
                    NewPreviousThreshGrids(col,row) = PrevValue;
                end
            end

        end
    end
    
    PreviousThreshGrids.T1{1} = NewPreviousThreshGrids;
    PlotThreshGrids = NewPreviousThreshGrids;

    PreviousThreshGrids.T1PlotHistory = zeros([size(Data), PlotAppearance.MainWindow.Data.AxonViewerPastSampleToSum]);
    PreviousThreshGrids.T1PlotFrames = 1;
    PreviousThreshGrids.T1PlotHistory(:,:,1) = NewPreviousThreshGrids;

    return; % only compare paths when there is a previous grid saved

elseif length(PreviousThreshGrids.T1)==2
    TempGrid = PreviousThreshGrids.T1{2};

    PreviousThreshGrids.T1{1} = TempGrid;
    PreviousThreshGrids.T1{2} = Data;
    if length(PreviousThreshGrids.T1)>2
        PreviousThreshGrids.T1(2:end) = [];
    end
    % Since current grid comming in is not thresholded, do so
    %initialized thresholded grid
    NewPreviousThreshGrids = zeros(size(PreviousThreshGrids.T1{end}));
    % indicies of subthreshold values
    SubThresholdIndicies = PreviousThreshGrids.T1{end} < Threshold;
    % save potential when below threshold
    NewPreviousThreshGrids(SubThresholdIndicies) = PreviousThreshGrids.T1{end}(SubThresholdIndicies);
    % replace in cell array because it becomes the next previous grid
    PreviousThreshGrids.T1{end} = NewPreviousThreshGrids;
    
    clear NewPreviousThreshGrids;

elseif length(PreviousThreshGrids.T1)==1
    PreviousThreshGrids.T1{end+1} = Data; %
            
    % Since current grid comming in is not thresholded, do so
    %initialized thresholded grid
    NewPreviousThreshGrids = zeros(size(PreviousThreshGrids.T1{end}));
    % indicies of subthreshold values
    SubThresholdIndicies = PreviousThreshGrids.T1{end} < Threshold;
    % save potential when below threshold
    NewPreviousThreshGrids(SubThresholdIndicies) = PreviousThreshGrids.T1{end}(SubThresholdIndicies);
    % replace in cell array because it becomes the next previous grid
    PreviousThreshGrids.T1{end} = NewPreviousThreshGrids;
    
    clear NewPreviousThreshGrids;
end


%% Compare neighbourhood of current thresholded grid to previous grids
minDist = 1;   % in grid elements

% % Sum all previous grids
% prevStack = cat(3, PreviousThreshGrids.T1{1:end-1});
% prevSum   = sum(prevStack, 3);

% Binary mask derived from sum
prevMask = PreviousThreshGrids.T1{1} ~= 0;

% Dilate previous mask by distance
se = strel('square', 2*minDist + 1);
reachableMask = imdilate(prevMask, se);

% Keep current values within distance
filteredGrid = zeros(size(PreviousThreshGrids.T1{end}));
keepIdx = (PreviousThreshGrids.T1{end} ~= 0) & reachableMask;

filteredGrid(keepIdx) = PreviousThreshGrids.T1{end}(keepIdx);

PreviousThreshGrids.T1{end} = filteredGrid;

%% Post Processing
if ~isempty(PlotThreshGrids)
    % threshold all to 1 if user wants it
    if PlotAppearance.MainWindow.Data.AxonViewerOnlyOnes == 1
        PreviousThreshGrids.T1{end}(PreviousThreshGrids.T1{end}<0) = -1;
    end
    
    PreviousThreshGrids.T1PlotFrames = PreviousThreshGrids.T1PlotFrames + 1; % how many previous acquired?
        
    %% If reached critical sample number replace last value, add newest and sum again
    if PreviousThreshGrids.T1PlotFrames > PlotAppearance.MainWindow.Data.AxonViewerPastSampleToSum && PlotAppearance.MainWindow.Data.AxonViewerShowTrails == 1 % sum
               
        PreviousThreshGrids.T1PlotHistory(:,:,1) = []; % delete frame most in the past
        PreviousThreshGrids.T1PlotHistory(:,:,end+1) = PreviousThreshGrids.T1{end}; % add new one

        if PlotAppearance.MainWindow.Data.AxonViewerShowTrails == 1 % sum
            PlotThreshGrids = ((sum(PreviousThreshGrids.T1PlotHistory,3))); % add new
        end
    %% If under critical sample number just take sum or mean
    else
        PreviousThreshGrids.T1PlotHistory(:,:,PreviousThreshGrids.T1PlotFrames) = PreviousThreshGrids.T1{end};

        if PlotAppearance.MainWindow.Data.AxonViewerShowTrails == 1 % sum
            PlotThreshGrids = (PreviousThreshGrids.T1{end} + (PlotThreshGrids)); % add new
            %PlotThreshGrids=sum(PreviousThreshGrids.T1PlotHistory,3);
        else % mean
            PlotThreshGrids = (PreviousThreshGrids.T1{end} + (PlotThreshGrids))/2; % add new
        end

    end
   
end

if PlotAppearance.MainWindow.Data.AxonViewerOnlyOnes == 1
    PlotThreshGrids(PlotThreshGrids<0)=-1;
end