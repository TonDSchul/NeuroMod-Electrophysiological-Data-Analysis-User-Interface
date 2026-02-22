function Utility_Save_Spike_Data(Analysis,Fullsavefile,PlottedData)

%________________________________________________________________________________________
%% NOT USED RIGHT NOW

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Write XData
writecell({" "},Fullsavefile, 'WriteMode', 'append');

writecell({"***** X_Data *****"},Fullsavefile, 'WriteMode', 'append');

if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
    writecell(num2cell(PlottedData.XData)', Fullsavefile, 'WriteMode', 'append');
elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
    if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
        writecell(num2cell(PlottedData.MainRateUnitXData)', Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && contains(Analysis,"Channel")
        writecell(num2cell(PlottedData.MainRateChannelXData)', Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
        writecell(num2cell(PlottedData.MainRateTimeXData)', Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
        writecell(num2cell(PlottedData.MainUnitXData)', Fullsavefile, 'WriteMode', 'append');
    elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Live")
        writecell(num2cell(PlottedData.MainXData)', Fullsavefile, 'WriteMode', 'append');
    elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && contains(Analysis,"Live")
        writecell(num2cell(PlottedData.LiveSpikeXData)', Fullsavefile, 'WriteMode', 'append');
    end
end

%% Write XTicks
writecell({" "},Fullsavefile, 'WriteMode', 'append');

writematrix(strcat("***** X_Tick Labels *****"),Fullsavefile, 'WriteMode', 'append');

if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
    writecell(PlottedData.XTicks, Fullsavefile, 'WriteMode', 'append');
elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
    if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
        writecell(PlottedData.MainRateUnitXTicks, Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && contains(Analysis,"Channel")
        writecell(PlottedData.MainRateChannelXTicks, Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
        writecell(PlottedData.MainRateTimeXTicks, Fullsavefile, 'WriteMode', 'append');
    elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
        writecell(PlottedData.MainUnitXTicks, Fullsavefile, 'WriteMode', 'append');
    elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Live")
        writecell(PlottedData.MainXTicks, Fullsavefile, 'WriteMode', 'append');
    elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && contains(Analysis,"Live")
        writecell(PlottedData.LiveSpikeXTicks, Fullsavefile, 'WriteMode', 'append');
    end
end

%% Write YData
writecell({" "},Fullsavefile, 'WriteMode', 'append');

writecell({"***** Y_Data *****"},Fullsavefile, 'WriteMode', 'append');

if ~contains(Analysis,"Spike") && ~contains(Analysis,"Spikes") % XData = Non - spike Data
    writecell(num2cell(PlottedData.YData)', Fullsavefile, 'WriteMode', 'append', 'Delimiter',';');
elseif contains(Analysis,"Spike") || contains(Analysis,"Spikes")  % MainXData = Main Spike analysis Plots without unit information
    if contains(Analysis,"Spike Rate") && contains(Analysis,"Unit")
        writecell(num2cell(PlottedData.MainRateUnitYData)', Fullsavefile, 'WriteMode', 'append', 'Delimiter',';');
    elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && contains(Analysis,"Channel")
        writecell(num2cell(PlottedData.MainRateChannelYData)', Fullsavefile, 'WriteMode', 'append', 'Delimiter',';');
    elseif contains(Analysis,"Spike Rate") && ~ contains(Analysis,"Unit") && ~contains(Analysis,"Channel")
        writecell(num2cell(PlottedData.MainRateTimeYData)', Fullsavefile, 'WriteMode', 'append', 'Delimiter',';');
    elseif contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate")
        writecell(num2cell(PlottedData.MainUnitYData)', Fullsavefile, 'WriteMode', 'append', 'Delimiter',';');
    elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && ~contains(Analysis,"Live")
        writecell(num2cell(PlottedData.MainYData)', Fullsavefile, 'WriteMode', 'append', 'Delimiter',';');
    elseif ~contains(Analysis,"Unit") && ~contains(Analysis,"Spike Rate") && contains(Analysis,"Live")
        writecell(num2cell(PlottedData.LiveSpikeYData)', Fullsavefile, 'WriteMode', 'append', 'Delimiter',';');
    end
end