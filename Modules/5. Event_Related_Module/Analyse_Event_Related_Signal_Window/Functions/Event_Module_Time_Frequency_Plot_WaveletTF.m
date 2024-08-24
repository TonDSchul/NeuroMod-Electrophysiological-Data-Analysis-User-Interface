function [climsTF] = Event_Module_Time_Frequency_Plot_WaveletTF (Figure,time,costumfrex,tfcycle,frexcycle,OneTrial,Type,TFType,ChannelSelection,EventSelection,TwoORThreeD)

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
if strcmp(TFType,"TF")
    if strcmp(Type,"Total")
        Datatouse = 10*log10(squeeze(tfcycle(1,:,:,1)));
    elseif strcmp(Type,"NonPhaseLocked")
        Datatouse = 10*log10(squeeze(tfcycle(2,:,:,1)));
    elseif strcmp(Type,"PhaseLocked")
        Datatouse = real(10*log10(squeeze(tfcycle(1,:,:,1))-squeeze(tfcycle(2,:,:,1))));
    end
elseif strcmp(TFType,"ITPC")
    if strcmp(Type,"Total")
        Datatouse = 10*log10(squeeze(tfcycle(1,:,:,2)));
    elseif strcmp(Type,"NonPhaseLocked")
        Datatouse = 10*log10(squeeze(tfcycle(2,:,:,2)));
    elseif strcmp(Type,"PhaseLocked")
        Datatouse = real(10*log10(squeeze(tfcycle(1,:,:,2))-squeeze(tfcycle(2,:,:,2))));
    end
end

climsTF = [];

if strcmp(TwoORThreeD,"TwoD")
    % 2D Plot
    PowerDepth2D_handles = findobj(Figure, 'Tag', '2DSpectrum');
    if length(PowerDepth2D_handles)>1
        delete(PowerDepth2D_handles(2:end));
    end
    
    if isempty(PowerDepth2D_handles)
        min_z = 0;
        surface(Figure,time,frexcycle, min_z * ones(size(Datatouse)), ...
        'CData', Datatouse, 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','2DSpectrum');
    else
        min_z = 0;
        set(PowerDepth2D_handles(1),'XData',time,'YData',frexcycle,'ZData', min_z * ones(size(Datatouse)), ...
        'CData', Datatouse, 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','2DSpectrum');
    end
else
    PowerDepth2D_handles = findobj(Figure, 'Tag', '2DSpectrum');
    PowerDepth3D_handles = findobj(Figure, 'Tag', '3DSpectrum');

    if length(PowerDepth2D_handles)>1
        delete(PowerDepth2D_handles(2:end));
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    elseif length(PowerDepth3D_handles)>1
        delete(PowerDepth3D_handles(2:end));
        PowerDepth3D_handles = findobj(Figure, 'Tag', '3DSpectrum');
    end

    if length(PowerDepth3D_handles)+length(PowerDepth2D_handles)==1
        delete(PowerDepth3D_handles(:));
        delete(PowerDepth2D_handles(:));
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
    end

    if isempty(PowerDepth2D_handles) || isempty(PowerDepth3D_handles)
        %3D
        surf(Figure,time,frexcycle,Datatouse,'EdgeColor', 'none','Tag','3DSpectrum')
        %2D
        % 2D Plot
        min_z = min(Datatouse,[],'all');
        surface(Figure,time,frexcycle, min_z * ones(size(Datatouse)), ...
        'CData', Datatouse, 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','2DSpectrum');
    else
        %3D
        set(PowerDepth3D_handles(1),'XData',time,'YData',frexcycle,'ZData',Datatouse,'CData',Datatouse,'EdgeColor', 'none','Tag','3DSpectrum')
        %2D
        % 2D Plot
        min_z = min(Datatouse,[],'all');
        set(PowerDepth2D_handles(1),'XData',time,'YData',frexcycle,'ZData', min_z * ones(size(Datatouse)), ...
        'CData', Datatouse, 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','2DSpectrum');
    end

    %imagesc(Figure,Time,ydata,mnLFP)
    view(Figure,45,45);
    box(Figure, 'off');
    grid(Figure, 'off');
end

climsTF(1) = min(Datatouse,[],'all');
climsTF(2) = max(Datatouse,[],'all');
cbar_handle=colorbar('peer',Figure,'location','EastOutside');
cbar_handle.Label.String = "dB Power";
cbar_handle.Label.Rotation = 270;

title(Figure,strcat("Total Time Frequency Power Channel ",num2str(ChannelSelection)," Events ",num2str(EventSelection)));
xlabel(Figure,'Time [s]'), ylabel(Figure,'Frequency [Hz]')
xline(Figure,0,'--','LineWidth',2); 
ylim(Figure,[costumfrex(1) costumfrex(3)])