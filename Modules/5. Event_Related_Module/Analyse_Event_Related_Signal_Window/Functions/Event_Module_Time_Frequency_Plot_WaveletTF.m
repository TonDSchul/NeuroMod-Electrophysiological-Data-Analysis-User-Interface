function [climsTF] = Event_Module_Time_Frequency_Plot_WaveletTF (Figure,time,costumfrex,tfcycle,frexcycle,OneTrial,Type,TFType,ChannelSelection,EventSelection)

%________________________________________________________________________________________
%% Function to plot time Frequency power and intertrial phase using complex moorlet wavelets with varying wavelet widths 

% Inputs: 
% 1. Figure: axes handle to figure to plot in
% 2. time: time vector as double in seconds
% 3. costumfrex: frequency range from to as double vector [1,100] for 1 to
% 100 Hz -- only for ylim
% 4. tfcycle: 4D matrix with result of wavelet TF analysis (from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles function)
% 5. frexcycle: Frequency range used for analysis as a 1 x nrfrequencies double  (from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles function)
% 6. OneTrial: For ITPC, 1 if only one event/trial plotted, 0 otherwise
% 7. Type: determines signal components for TF analysis: "Total" OR "NonPhaseLocked" OR
% "PhaseLocked"; NonPhaseLocked = Signal - ERP; Phaselocked = ERP; Total =
% both components
% 8. TFType: "TF" OR "ITPC" to plot either Time frequency power or inter
% trial phase clustering.
% 9. ChannelSelection: 1 x 2 double with channel to plot; i.e. [1,10] for
% channel 1 to 10
% 10. EventSelection: 1 x 2 double with events to plot; i.e. [1,10] for
% events 1 to 10

% Outputs: 
% 1. climsTF: current clim as 1 x 2 vector of plot so that user can set auto clim in the
% GUI without having to calculate again

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

climsTF = [];

if strcmp(TFType,"TF")
    if strcmp(Type,"Total")
            hold(Figure, 'on' )
            Figure.NextPlot = "replace";
            contourf(Figure,time,frexcycle,10*log10(squeeze(tfcycle(1,:,:,1))),40,'linecolor','none')
            climsTF(1) = min(10*log10(squeeze(tfcycle(1,:,:,1))),[],'all');
            climsTF(2) = max(10*log10(squeeze(tfcycle(1,:,:,1))),[],'all');
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "dB Power";
            cbar_handle.Label.Rotation = 270;
    
            title(Figure,strcat("Total Time Frequency Power Channel ",num2str(ChannelSelection)," Events ",num2str(EventSelection)));
            xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
            xline(Figure,0,'--','LineWidth',2); 
            ylim(Figure,[costumfrex(1) costumfrex(3)])
            hold(Figure, 'off' )
    elseif strcmp(Type,"NonPhaseLocked")
            hold(Figure, 'on' )
            contourf(Figure,time,frexcycle,10*log10(squeeze(tfcycle(2,:,:,1))),40,'linecolor','none');
            climsTF(1) = min(10*log10(squeeze(tfcycle(2,:,:,1))),[],'all');
            climsTF(2) = max(10*log10(squeeze(tfcycle(2,:,:,1))),[],'all');
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "dB Power";
            cbar_handle.Label.Rotation = 270;
            title(Figure,strcat("Non Phase Locked Time Frequency Power Channel ",num2str(ChannelSelection)," Events ",num2str(EventSelection)));
            xline(Figure,0,'--','LineWidth',2); 
            xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
            ylim(Figure,[costumfrex(1) costumfrex(3)])
            hold(Figure, 'off' )
    
    elseif strcmp(Type,"PhaseLocked")
        %Standard TF Plot
        hold(Figure, 'on' )
        contourf(Figure,time,frexcycle,real(10*log10(squeeze(tfcycle(1,:,:,1))-squeeze(tfcycle(2,:,:,1)))),40,'linecolor','none');
        climsTF(1) = min(real(10*log10(squeeze(tfcycle(1,:,:,1))-squeeze(tfcycle(2,:,:,1)))),[],'all');
        climsTF(2) = max(real(10*log10(squeeze(tfcycle(1,:,:,1))-squeeze(tfcycle(2,:,:,1)))),[],'all');
        cbar_handle=colorbar('peer',Figure,'location','EastOutside');
        cbar_handle.Label.String = "dB Power";
        cbar_handle.Label.Rotation = 270;
        title(Figure,strcat("Phase Locked Time Frequency Power Channel ",num2str(ChannelSelection)," Events ",num2str(EventSelection)));
        xline(Figure,0,'--','LineWidth',2); 
        xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
        ylim(Figure,[costumfrex(1) costumfrex(3)])
        hold(Figure, 'off' )
    end

elseif strcmp(TFType,"ITPC")
    %Total ITPC
    if OneTrial ~= 1
        if strcmp(Type,"Total")
            hold(Figure, 'on' )
            Figure.NextPlot = "replace";
            contourf(Figure,time,frexcycle,10*log10(squeeze(tfcycle(1,:,:,2))),40,'linecolor','none');
            climsTF(1) = min(min(10*log10(squeeze(tfcycle(1,:,:,2)))));
            climsTF(2) = max(max(10*log10(squeeze(tfcycle(1,:,:,2)))));
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "dB Power";
            cbar_handle.Label.Rotation = 270;
            title(Figure,strcat("Total Intertrial Phase Clustering Channel ",num2str(ChannelSelection)," Events ",num2str(EventSelection)));
            Figure.NextPlot = "add";
            xline(Figure,0,'--','LineWidth',2); 
            xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
            ylim(Figure,[costumfrex(1) costumfrex(3)])
            hold(Figure, 'off' )    
        %Non Phase Locked ITPC
        elseif strcmp(Type,"NonPhaseLocked")
            hold(Figure, 'on' )
            Figure.NextPlot = "replace";
            contourf(Figure,time,frexcycle,10*log10(squeeze(tfcycle(2,:,:,2))),40,'linecolor','none')
            climsTF(1) = min(min(10*log10(squeeze(tfcycle(2,:,:,2)))));
            climsTF(2) = max(max(10*log10(squeeze(tfcycle(2,:,:,2)))));
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "dB Power";
            cbar_handle.Label.Rotation = 270;
            title(Figure,strcat("Non Phase Locked Intertrial Phase Clustering Channel ",num2str(ChannelSelection)," Events ",num2str(EventSelection)));
            Figure.NextPlot = "add";
            xline(Figure,0,'--','LineWidth',2); 
            xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
            ylim(Figure,[costumfrex(1) costumfrex(3)]) 
            hold(Figure, 'off' )  
        %Phase Locked Time ITPC
        elseif strcmp(Type,"PhaseLocked")
            hold(Figure, 'on' )
            contourf(Figure,time,frexcycle,real(10*log10(squeeze(tfcycle(1,:,:,2))-squeeze(tfcycle(2,:,:,2)))),40,'linecolor','none')
            climsTF(1) = min(min(real(10*log10(squeeze(tfcycle(1,:,:,2))-squeeze(tfcycle(2,:,:,2))))));
            climsTF(2) = max(max(real(10*log10(squeeze(tfcycle(1,:,:,2))-squeeze(tfcycle(2,:,:,2))))));
            cbar_handle=colorbar('peer',Figure,'location','EastOutside');
            cbar_handle.Label.String = "dB Power";
            cbar_handle.Label.Rotation = 270;
            title(Figure,strcat("Phase Locked Intertrial Phase Clustering Channel ",num2str(ChannelSelection)," Events ",num2str(EventSelection)));
            xline(Figure,0,'--','LineWidth',2); 
            xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
            ylim(Figure,[costumfrex(1) costumfrex(3)])
            hold(Figure, 'off' ) 
        end
    
    end
end