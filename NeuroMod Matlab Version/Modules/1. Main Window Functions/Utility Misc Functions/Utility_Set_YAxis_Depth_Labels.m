function Utility_Set_YAxis_Depth_Labels(Data,Figure,executableFolder,CurrentActiveChannel)

tempactchannel{1} = Data.Info.ProbeInfo.ActiveChannel;

[x,y,Data.Spikes.ChannelMap] = Manage_Dataset_Save_ProbeInfo_Kilosort(executableFolder,Data.Info.ProbeInfo.NrRows,num2str(size(Data.Raw,1)),num2str(Data.Info.ChannelSpacing),tempactchannel,Data.Info.ProbeInfo.OffSetRows,str2double(Data.Info.ProbeInfo.OffSetRowsDistance),str2double(Data.Info.ProbeInfo.VertOffset),str2double(Data.Info.ProbeInfo.HorOffset),0);

% Make custome y positions if second channel row offset. This is because
% for Kilosort it needs to be reversed so that the first channel is on the
% bottom --> just change proper coordinates to fit with visualization

if Data.Info.ProbeInfo.OffSetRows==1
    %% ONE CHANNEL ROW
    if str2double(Data.Info.ProbeInfo.NrRows) == 1
        chanMap = 1:str2double(Data.Info.ProbeInfo.NrChannel);
        
        x = zeros(size(chanMap,1),size(chanMap,2));
        x(2:2:end) = 0 + str2double(Data.Info.ProbeInfo.OffSetRowsDistance);
        
    end
    %% Two CHANNEL ROWS
    if str2double(Data.Info.ProbeInfo.NrRows) == 2
        chanMap = 1:str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows);

        x = zeros(size(chanMap,1),size(chanMap,2));
        x(2:2:end) = 0 + str2double(Data.Info.ProbeInfo.HorOffset);
        
        vec = 1:length(chanMap);
        %% Select 2 indicies, leave next two alone
        step = 4; % Step size (4 values: take 2, skip 2)
        indices = [];
        for start_idx = 3:step:length(vec)
            indices = [indices, start_idx, start_idx + 1]; % Take the first two values of each group
        end
        indices = indices(indices <= length(vec));  
        ProperIndicies = vec(indices);

        %xcoords(ProperIndicies) = xcoords(ProperIndicies) - VerOffsetDistanceSecondRow;
        x(ProperIndicies) = x(ProperIndicies) + str2double(Data.Info.ProbeInfo.OffSetRowsDistance);
       
    end
    %% Three or more CHANNEL ROWS
    if str2double(Data.Info.ProbeInfo.NrRows) > 2
        NrChannel = str2double(Data.Info.ProbeInfo.NrChannel);
    
        chanMap = 1:NrChannel*str2double(Data.Info.ProbeInfo.NrRows);
        
        x = zeros(size(chanMap,1),size(chanMap,2));
        xcoordtemp = 0:str2double(Data.Info.ProbeInfo.HorOffset):str2double(Data.Info.ProbeInfo.HorOffset)*str2double(Data.Info.ProbeInfo.NrRows)-1;
        Laufvariable = 1;
        for tt = NrChannel:str2double(Data.Info.ProbeInfo.NrRows):NrChannel*str2double(Data.Info.ProbeInfo.NrRows)
            
            if mod(Laufvariable,2) == 0
                x(1,tt-str2double(Data.Info.ProbeInfo.NrRows)+1:tt) = xcoordtemp+str2double(Data.Info.ProbeInfo.OffSetRowsDistance);
            else
                x(1,tt-str2double(Data.Info.ProbeInfo.NrRows)+1:tt) = xcoordtemp;
            end
            
            Laufvariable = Laufvariable + 1;
        end
    end
end

% Create combined labels
newLabels = arrayfun(@(yy, xx) sprintf('%.0f (%.0f µm)', yy, xx), y, x, 'UniformOutput', false);

newLabels = newLabels(CurrentActiveChannel);

Ypositions = linspace(Figure.YLim(1), Figure.YLim(2), numel(CurrentActiveChannel));
%Ypositions = Ypositions(CurrentActiveChannel);

% Apply to the y-axis of your app's UIAxes
% if numel(CurrentActiveChannel)>10
%     Figure.YTick = Ypositions(1:2:end);
%     Figure.YTickLabel = newLabels(1:2:end);
% else
    Figure.YTick = Ypositions;
    Figure.YTickLabel = newLabels;
% end

