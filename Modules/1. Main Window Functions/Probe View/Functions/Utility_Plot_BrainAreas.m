function Utility_Plot_BrainAreas(Figure,ProbeBrainAreas,ActiveChannel,SwitchTopBottomChannel,ChannelSpacing,ChannelRows,NumChannel)

%________________________________________________________________________________________
%% Function to plot brain areas from trajectory explorer in probe view window
%% -- not implemented yet!!!

% Inputs: 
% 1. Figure: Figure object of probe view window
% 2. ProbeBrainAreas: Structure holding trajectorx explorer info
% 3. ActiveChannel: double vector with all channel currentlyx being active
% 4. SwitchTopBottomChannel: double, 1 or 0 whether to reverse top/bottom
% channel number (if 1, upmost channel = last channel number)
% 5. ChannelSpacing: double, channelspacing between channel in um
% 6. ChannelRows: double, number of channel rows on probe design
% 7. NumChannel: double number of channel per channel row

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
        
        NumPositiveDepths = sum(ProbeBrainAreas.AreaTipDistance(:,1)>0);

        if SwitchTopBottomChannel == 0
            FirstActiveChannelDepth = ((NumChannel-1)*ChannelSpacing) - (((ActiveChannel(1)/ChannelRows)-1)*ChannelSpacing);
        else
            FirstActiveChannelDepth = ((NumChannel-1)*ChannelSpacing) - (((min(ActiveChannel)/ChannelRows)-1)*ChannelSpacing);
        end

        Distances = abs(diff(ProbeBrainAreas.AreaTipDistance(1:NumPositiveDepths+1,1)));

        Areanames = ProbeBrainAreas.AreaNamesShort(1:NumPositiveDepths);

        BrainareatextLine = findobj(Figure, 'Tag', 'Brainareatext');
        
        if length(BrainareatextLine)>length(Areanames)
            delete(BrainareatextLine(length(Areanames)+1:end));
            BrainareatextLine = findobj(Figure, 'Tag', 'Brainareatext');
        end
        
        LowerBrainareabordersLine = findobj(Figure, 'Tag', 'LowerBrainareaborders');
        
        if length(LowerBrainareabordersLine)>length(Areanames)*2
            delete(LowerBrainareabordersLine(length(Areanames)*2+1:end));
            LowerBrainareabordersLine = findobj(Figure, 'Tag', 'LowerBrainareaborders');
        end
        
        UpperBrainareabordersLine = findobj(Figure, 'Tag', 'UpperBrainareaborders');
        
        if length(UpperBrainareabordersLine)>length(Areanames)*2
            delete(UpperBrainareabordersLine(length(Areanames)*2+1:end));
            UpperBrainareabordersLine = findobj(Figure, 'Tag', 'UpperBrainareaborders');
        end
        
        Startdepth = FirstActiveChannelDepth;
        Stopdepth = FirstActiveChannelDepth;

        for nareas = 1:length(Areanames)
            Startdepth = Stopdepth; % convert into um
            Stopdepth = Stopdepth - (Distances(nareas) * 1000); % convert into um
    
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