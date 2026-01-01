function Event_Module_Time_Frequency_Plot_Hilbert_TF (Data,tf,frex,time,costumfrex,OneTrial,Figure,BaselineNormalize,TFType,Type,BaselineNormalize,NormalizationWindow)
%________________________________________________________________________________________
%% Function to plot time Frequency power and intertrial phase using filter hilbert transformation

%***********************
%% work in progress, not implemented yet!!!!!!!!!!!!
%***********************

% Inputs: 
% 1. tf: 4D matrix with result of wavelet TF analysis (from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles function)
% 2. frex: Frequency range used for analysis as a 1 x nrfrequencies double  (from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles function)
% 3. time: time vector as double in seconds
% 4. costumfrex: frequency range from to as double vector [1,100] for 1 to
% 100 Hz -- only for ylim
% 5. OneTrial: For ITPC, 1 if only one event/trial plotted, 0 otherwise
% 6. Figure: axes handle to figure to plot in
% 7: BaselineNormalize: 1 if data was baseline normalized, 0 if not
% 8. TFType: "TF" OR "ITPC" to plot either Time frequency power or inter
% trial phase clustering.
% 9. Type: determines signal components for TF analysis: "Total" OR "NonPhaseLocked" OR
% "PhaseLocked"; NonPhaseLocked = Signal - ERP; Phaselocked = ERP; Total =
% both components

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%First 2 = Total and non phase locked; Second 2 = Power and ITPC

if strcmp(TFType,"TF")
    if strcmp(Type,"Total")
        Datatouse = 10*log10(squeeze(tf(1,:,:,1)));
    elseif strcmp(Type,"NonPhaseLocked")
        Datatouse = 10*log10(squeeze(tf(2,:,:,1)));
    elseif strcmp(Type,"PhaseLocked")
        Datatouse = real(10*log10(squeeze(tf(1,:,:,1))-squeeze(tf(2,:,:,1))));
    end
elseif strcmp(TFType,"ITPC")
    if strcmp(Type,"Total")
        Datatouse = 10*log10(squeeze(tf(1,:,:,2)));
    elseif strcmp(Type,"NonPhaseLocked")
        Datatouse = 10*log10(squeeze(tf(2,:,:,2)));
    elseif strcmp(Type,"PhaseLocked")
        Datatouse = real(10*log10(squeeze(tf(1,:,:,2))-squeeze(tf(2,:,:,2))));
    end
end


if BaselineNormalize
    Datatouse = Event_Module_Baseline_Normalize(Data,Datatouse,NormalizationWindow,Data.Info.EventRelatedTime,"TF");
end

if strcmp(TFType,"TF")
    if strcmp(Type,"Total")
        hold(Figure, 'on' )
        Figure.NextPlot = "replace";
        if BaselineNormalize
            contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "db Power";
            cbar_handle.Label.Rotation = 270;
        else
            contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "Power";
            cbar_handle.Label.Rotation = 270;
        end
        Figure.NextPlot = "add";
        ylim(Figure,[costumfrex(1) costumfrex(3)])
        % app.climsTF(1) = min(min(squeeze(tf(1,:,:,1))));
        % app.climsTF(2) = max(max(squeeze(tf(1,:,:,1))));
        plot(Figure,[0 0], [frex(1) frex(end)], '--k','LineWidth',2) 
        xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
        hold(Figure, 'off' )

    elseif strcmp(Type,"NonPhaseLocked")
        hold(Figure, 'on' )
        Figure.NextPlot = "replace";
        if BaselineNormalize
            contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "dB Power";
            cbar_handle.Label.Rotation = 270;
        else
            contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "Power";
            cbar_handle.Label.Rotation = 270;
        end
        Figure.NextPlot = "add";
        %Figure.FontSize = 9;
        plot(Figure,[0 0], [frex(1) frex(end)], '--k','LineWidth',2) 
        xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
        ylim(Figure,[costumfrex(1) costumfrex(3)])
        hold(Figure, 'off' )

    elseif strcmp(Type,"PhaseLocked")
        %Standard TF Plot
        hold(Figure, 'on' )
        Figure.NextPlot = "replace";
        if BaselineNormalize
            contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "dB Power";
            cbar_handle.Label.Rotation = 270;
        else
            contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "Power";
            cbar_handle.Label.Rotation = 270;
        end
        Figure.NextPlot = "add";
        %Figure.FontSize = 9;
        plot(Figure,[0 0], [frex(1) frex(end)], '--k','LineWidth',2) 
        xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
        ylim(Figure,[costumfrex(1) costumfrex(3)])
        hold(Figure, 'off' )
    end
end



%% Plot ITPC
if strcmp(TFType,"ITPC")
    if OneTrial ~= 1
        if strcmp(Type,"Total")
            %Total ITPC
            hold(Figure, 'on' )
            Figure.NextPlot = "replace";
            if BaselineNormalize
                contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
                cbar_handle=colorbar('peer',Figure,'location','EastOutside');
                cbar_handle.Label.String = "dB Power";
                cbar_handle.Label.Rotation = 270;
            else
                contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
                cbar_handle=colorbar('peer',Figure,'location','EastOutside');
                cbar_handle.Label.String = "Power";
                cbar_handle.Label.Rotation = 270;
            end
            Figure.NextPlot = "add";
            plot(Figure,[0 0], [frex(1) frex(end)], '--k','LineWidth',2) 
            %Figure.FontSize = 9;
            xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
            ylim(Figure,[costumfrex(1) costumfrex(3)])
            % app.climsITPC(1) = min(min(squeeze(tf(1,:,:,2))));
            % app.climsITPC(2) = max(max(squeeze(tf(1,:,:,2))));
            hold(Figure, 'off' )  
        
        %Non Phase Locked ITPC
        elseif strcmp(Type,"NonPhaseLocked")
            hold(Figure, 'on' )
            Figure.NextPlot = "replace";
            if BaselineNormalize
                contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
                cbar_handle=colorbar('peer',Figure,'location','EastOutside');
                cbar_handle.Label.String = "dB Power";
                cbar_handle.Label.Rotation = 270;
            else
                contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
                cbar_handle=colorbar('peer',Figure,'location','EastOutside');
                cbar_handle.Label.String = "Power";
                cbar_handle.Label.Rotation = 270;
            end
            Figure.NextPlot = "add";
            %Figure.FontSize = 9;
            plot(Figure,[0 0], [frex(1) frex(end)], '--k','LineWidth',2) 
            xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
            ylim(Figure,[costumfrex(1) costumfrex(3)])
            hold(Figure, 'off' )     
        
        %Phase Locked ITPC
        elseif strcmp(Type,"PhaseLocked")
            hold(Figure, 'on' )
            Figure.NextPlot = "replace";
            if BaselineNormalize
                contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
                cbar_handle=colorbar('peer',Figure,'location','EastOutside');
                cbar_handle.Label.String = "dB Power";
                cbar_handle.Label.Rotation = 270;
            else
                contourf(Figure,time,frex,Datatouse,40,'linecolor','none')
                cbar_handle=colorbar('peer',Figure,'location','EastOutside');
                cbar_handle.Label.String = "Power";
                cbar_handle.Label.Rotation = 270;
            end
            Figure.NextPlot = "add";
            %Figure.FontSize = 9;
            plot(Figure,[0 0], [frex(1) frex(end)], '--k','LineWidth',2) 
            xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
            ylim(Figure,[costumfrex(1) costumfrex(3)])
            hold(Figure, 'off' )
        end
    end
end