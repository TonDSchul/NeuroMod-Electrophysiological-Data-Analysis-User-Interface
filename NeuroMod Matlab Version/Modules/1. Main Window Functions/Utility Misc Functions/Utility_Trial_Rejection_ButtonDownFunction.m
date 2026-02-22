function Utility_Trial_Rejection_ButtonDownFunction(app,src,event)

%________________________________________________________________________________________
%% Function to handle callback in trial rejection window when user clicks a plot to show the trial/trigger number

% Input Arguments:
% 1. app: trial rejection app object
% 2. src: Not used
% 3. event: Not used

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%Get click location
cp = app.UIAxes_2.CurrentPoint;
xClick = cp(1,1);
yClick = cp(1,2);

%  Find nearest line in threshold crossing plot 
minDist = inf;
closestLine = [];

for k = 1:numel(app.LineHandles2) 
    xData = app.LineHandles2(k).XData;
    yData = app.LineHandles2(k).YData;

    d = hypot(double(xData) - xClick, double(yData) - yClick);
    dmin = min(d);

    if dmin < minDist
        minDist = dmin;
        closestLine = app.LineHandles2(k);
    end
end

app.LineHandles2 = findall(app.UIAxes_2,'Type','Line','Tag','Trials');

%compare clicked line with rows of CData
if ~isempty(closestLine)
    yCandidate = double(closestLine.YData(:)');  
    cdata = double(app.LineHandles.CData);       

    %find row index
    idxMatch = NaN;
    for r = 1:size(cdata,1)
        if isequal(yCandidate, cdata(r,:))
            idxMatch = r;
            break;
        end
    end

    if ~isnan(idxMatch)

        TrialTextObjects = findall(app.UIAxes_2,'Tag','TrialText');
        
        if ~isempty(TrialTextObjects)
            delete(TrialTextObjects);
        end
        
        label = app.AllYLabels{idxMatch};
        %label = app.UIAxes.YTickLabel{idxMatch};
        msg = sprintf('Trigger Nr: %s', label);
        
        %plot text
        text(app.UIAxes_2, xClick, yClick, msg, ...
            'FontSize', 12, ...
            'Color', 'k', ...
            'Tag', 'TrialText');
    end
end
