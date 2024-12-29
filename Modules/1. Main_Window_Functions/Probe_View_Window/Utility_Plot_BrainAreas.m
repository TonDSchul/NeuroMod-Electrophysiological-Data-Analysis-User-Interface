function Utility_Plot_BrainAreas(Figure,ProbeBrainAreas)

%________________________________________________________________________________________
%% Function to plot brain areas from trajectory explorer in probe view window
%% -- not implemented yet!!!

% Inputs: 
% 1. Figure: Figure object of probe view window
% 2. ProbeBrainAreas: Structure holding trajectorx explorer info

% Outputs:
% 1. app: Probe View app window

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if isfield(ProbeBrainAreas,'AreaDistanceFromTip') 
    ProbeBrainAreas.AreaTipDistance = ProbeBrainAreas.AreaDistanceFromTip;
    ProbeBrainAreas.AreaNamesShort = ProbeBrainAreas.ShortAreaNames;
end

if ~isempty(ProbeBrainAreas)
    if isfield(ProbeBrainAreas,'AreaTipDistance')
        
        BrainareatextLine = findobj(Figure, 'Tag', 'Brainareatext');
        
        if length(BrainareatextLine)>size(ProbeBrainAreas.AreaTipDistance,1)
            delete(BrainareatextLine(size(ProbeBrainAreas.AreaTipDistance,1)+1:end));
            BrainareatextLine = findobj(Figure, 'Tag', 'Brainareatext');
        end
        
        LowerBrainareabordersLine = findobj(Figure, 'Tag', 'LowerBrainareaborders');
        
        if length(LowerBrainareabordersLine)>size(ProbeBrainAreas.AreaTipDistance,1)*2
            delete(LowerBrainareabordersLine(size(ProbeBrainAreas.AreaTipDistance,1)*2+1:end));
            LowerBrainareabordersLine = findobj(Figure, 'Tag', 'LowerBrainareaborders');
        end
        
        UpperBrainareabordersLine = findobj(Figure, 'Tag', 'UpperBrainareaborders');
        
        if length(UpperBrainareabordersLine)>size(ProbeBrainAreas.AreaTipDistance,1)*2
            delete(UpperBrainareabordersLine(size(ProbeBrainAreas.AreaTipDistance,1)*2+1:end));
            UpperBrainareabordersLine = findobj(Figure, 'Tag', 'UpperBrainareaborders');
        end
        
        for nareas = 1:size(ProbeBrainAreas.AreaTipDistance,1)
            Startdepth = ProbeBrainAreas.AreaTipDistance(nareas,2) * 1000; % convert into um
            Stopdepth = ProbeBrainAreas.AreaTipDistance(nareas,1) * 1000; % convert into um
    
            if Startdepth>=0
                Xposition = [0 2];
                  
                if isempty(LowerBrainareabordersLine)
                    line(Figure,Xposition,[Startdepth,Startdepth],'Color','b','LineWidth',2,'Tag','LowerBrainareaborders');
                else
                    if length(LowerBrainareabordersLine)>=nareas
                        set(LowerBrainareabordersLine(nareas),'XData',Xposition,'YData',[Startdepth,Startdepth],'Color','b','LineWidth',2,'Tag','LowerBrainareaborders');
                    else
                        line(Figure,Xposition,[Startdepth,Startdepth],'Color','b','LineWidth',2,'Tag','LowerBrainareaborders');
                    end  
                end
        
                if isempty(UpperBrainareabordersLine)
                    line(Figure,Xposition,[Stopdepth,Stopdepth],'Color','b','LineWidth',2,'Tag','UpperBrainareaborders');
                else
                    if length(UpperBrainareabordersLine)>=nareas
                        set(UpperBrainareabordersLine(nareas),'XData',Xposition,'YData',[Stopdepth,Stopdepth],'Color','b','LineWidth',2,'Tag','UpperBrainareaborders');
                    else
                        line(Figure,Xposition,[Stopdepth,Stopdepth],'Color','b','LineWidth',2,'Tag','UpperBrainareaborders');
                    end
                end
        
                if isempty(BrainareatextLine)
                    text(Figure,1.1,Startdepth+((Stopdepth-Startdepth)/2),ProbeBrainAreas.AreaNamesShort{nareas},"Color",'r','FontSize',12,'Tag','Brainareatext');
                else
                    if length(BrainareatextLine)>=nareas
                        set(BrainareatextLine(nareas),'Position',[1.1,Startdepth+((Stopdepth-Startdepth)/2)],'String',ProbeBrainAreas.AreaNamesShort{nareas},"Color",'r','FontSize',12,'Tag','Brainareatext');
                    else
                        text(Figure,1.1,Startdepth+((Stopdepth-Startdepth)/2),ProbeBrainAreas.AreaNamesShort{nareas},"Color",'r','FontSize',12,'Tag','Brainareatext');
                    end
                end
            end
        end
    end
end