function Utility_Trial_Rejection_ButtonDownFunction(app,src,event)

% Theory: find the line nearest to the one the user clicked on in UIAxes_2.
% Get X and Y Data of that line. Compare with cdata of UIAxes and get the
% row indice of matching data. The yaxis label of UIAxes at that index is
% the trrial number --> ensures that it works even when trials where
% already deleted

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
        msg = sprintf('Trial: %s', label);
        
        %plot text
        text(app.UIAxes_2, xClick, yClick, msg, ...
            'FontSize', 12, ...
            'Color', 'k', ...
            'Tag', 'TrialText');
    end
end
