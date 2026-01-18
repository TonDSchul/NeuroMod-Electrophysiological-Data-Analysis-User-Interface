function Organize_Delete_All_Open_Windows(app,DeleteProbeView)

%________________________________________________________________________________________
%% Function to close all related app widows when app is closed or new data is loaded

% Input Arguments:
% 1. app: main app window object containing all app windows as property (or empty if not opened)
% 2. DeleteProbeView: double, 1 or 0, specify whether the probe window is
% supposed to be closed

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

try
    if DeleteProbeView
        if ~isempty(app.ProbeViewWindowHandle)
            if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
                close(app.ProbeViewWindowHandle.ProbeViewUIFigure);
                app.ProbeViewWindowHandle = [];
            else
                app.ProbeViewWindowHandle = [];
            end
        end
    else
        if ~isempty(app.ProbeViewWindowHandle)
            Placeholder = {};
            app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items = Placeholder;
            app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{1} = 'All Windows Opened';
            app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{2} = 'Main Window';
        end
    end
catch
    if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        close(app.ProbeViewWindowHandle.ProbeViewUIFigure);
    end
    app.ProbeViewWindowHandle = [];
end

%% Data Extraction WIndow
% try
%     if ~isempty(app.ExtractDataWindow) && DeleteProbeView ~= 1
%         delete(app.ExtractDataWindow);
%         app.ExtractDataWindow = [];
%     end
% catch
%     app.ExtractDataWindow = [];
% end

%% Live main window plots
try
    if ~isempty(app.PSTHApp)
        delete(app.PSTHApp.SpikeRateWindowUIFigure);
        app.PSTHApp = [];
    end
catch
    app.PSTHApp = [];
end

try
    if ~isempty(app.CSDApp)
        delete(app.CSDApp.CSDWindowUIFigure);
        app.CSDApp = [];
    end
catch
    app.CSDApp = [];
end
try
    if ~isempty(app.SpectralEstApp)
        delete(app.SpectralEstApp);
        app.SpectralEstApp = [];
    end
catch
    app.SpectralEstApp = [];
end
%% Cont Spectrum
try
    if ~isempty(app.ContStaticSpectrumWindow)
        delete(app.ContStaticSpectrumWindow);
        app.ContStaticSpectrumWindow = [];
    end
catch
    app.ContStaticSpectrumWindow = [];
end

%% Cont Spikes
try
    if ~isempty(app.ConInternalSpikesWindow)
        delete(app.ConInternalSpikesWindow);
        app.ConInternalSpikesWindow = [];
    end
catch
    app.ConInternalSpikesWindow = [];
end
try
if ~isempty(app.ConKilosortSpikesWindow)
    delete(app.ConKilosortSpikesWindow);
    app.ConKilosortSpikesWindow = [];
end
catch
    app.ConKilosortSpikesWindow = [];
end
try
    if ~isempty(app.UnitAnalysis)
        delete(app.UnitAnalysis);
        app.UnitAnalysis = [];
    end
catch
    app.UnitAnalysis = [];
end
%% Event spikes
try
    if ~isempty(app.EventInternalSpikesWindow)
        delete(app.EventInternalSpikesWindow);
        app.EventInternalSpikesWindow = [];
    end
catch
    app.EventInternalSpikesWindow = [];
end
try
    if ~isempty(app.EventKilosortSpikesWindow)
        delete(app.EventKilosortSpikesWindow);
        app.EventKilosortSpikesWindow = [];
    end
catch
    app.EventKilosortSpikesWindow = [];
end
%% Event LFP
try
    if ~isempty(app.EventLFPERP)
        delete(app.EventLFPERP);
        app.EventLFPERP = [];
    end
catch
    app.EventLFPERP = [];
end
try
    if ~isempty(app.EventLFPCSD)
        delete(app.EventLFPCSD);
        app.EventLFPCSD = [];
    end
catch
    app.EventLFPCSD = [];
end
try
    if ~isempty(app.EventLFPTF)
        delete(app.EventLFPTF);
        app.EventLFPTF = [];
    end
catch
    app.EventLFPTF = [];
end
try
    if ~isempty(app.EventLFPSSP)
        delete(app.EventLFPSSP);
        app.EventLFPSSP = [];
    end
catch
    app.EventLFPSSP = [];
end
%% Prepro Artefact rejection
try
    if ~isempty(app.PreproArtefactRejection)
        delete(app.PreproArtefactRejection);
        app.PreproArtefactRejection = [];
    end
catch
    app.PreproArtefactRejection = [];
end

%% Event Extraction Window
if DeleteProbeView
    try
        if ~isempty(app.EventExtractionWindow)
            delete(app.EventExtractionWindow);
            app.EventExtractionWindow = [];
        end
    catch
        app.EventExtractionWindow = [];
    end
end
%% Import Events Window
if DeleteProbeView
    try
        if ~isempty(app.ImportEventTTLWindow)
            delete(app.ImportEventTTLWindow);
            app.ImportEventTTLWindow = [];
        end
    catch
        app.ImportEventTTLWindow = [];
    end
end
%% Spike Extraction Window
try
    if ~isempty(app.SpikeExtractionWindow)
        delete(app.SpikeExtractionWindow);
        app.SpikeExtractionWindow = [];
    end
catch
    app.SpikeExtractionWindow = [];
end
%% Load from Kilosort Window
try
    if ~isempty(app.LoadfromKilosortWindowWindow)
        delete(app.LoadfromKilosortWindowWindow);
        app.LoadfromKilosortWindowWindow = [];
    end
catch
    app.LoadfromKilosortWindowWindow = [];
end
%% SaveforKilsort Window
try
    if ~isempty(app.SaveforKilosortWindowWindow)
        delete(app.SaveforKilosortWindowWindow);
        app.SaveforKilosortWindowWindow = [];
    end
catch
    app.SaveforKilosortWindowWindow = [];
end

%% Prepro Events Main Window Window 
try
    if ~isempty(app.PreproEventsMainWindow)
        delete(app.PreproEventsMainWindow);
        app.PreproEventsMainWindow = [];
    end
catch
    app.PreproEventsMainWindow = [];
end

%% Event LFP analysis main window
try
    if ~isempty(app.LFPEventsMainWindow)
        delete(app.LFPEventsMainWindow);
        app.LFPEventsMainWindow = [];
    end
catch
    app.LFPEventsMainWindow = [];
end

%% Save Data Window
try
    if ~isempty(app.SaveDataWindow)
        delete(app.SaveDataWindow);
        app.SaveDataWindow = [];
    end
catch
    app.SaveDataWindow = [];
end

%% Autorun Window
try
    if ~isempty(app.AutorunWindow)
        delete(app.AutorunWindow);
        app.AutorunWindow = [];
    end
catch
    app.AutorunWindow = [];
end

%% Manage Modules window
try
    if ~isempty(app.ManageModulesWindow)
        delete(app.ManageModulesWindow);
        app.ManageModulesWindow = [];
    end
catch
    app.ManageModulesWindow = [];
end


%% Manage Components
try
    if ~isempty(app.Manage_Dataset_ComponentsWindow)
        delete(app.Manage_Dataset_ComponentsWindow);
        app.Manage_Dataset_ComponentsWindow = [];
    end
catch
    app.Manage_Dataset_ComponentsWindow = [];
end



%% LiveECHTWindow
try
    if ~isempty(app.LiveECHTWindow)
        delete(app.LiveECHTWindow);
        app.LiveECHTWindow = [];
    end
catch
    app.LiveECHTWindow = [];
end


%% EventIndiceRejectionWindow
try
    if ~isempty(app.EventIndiceRejectionWindow)
        delete(app.EventIndiceRejectionWindow);
        app.EventIndiceRejectionWindow = [];
    end
catch
    app.EventIndiceRejectionWindow = [];
end

%% Live Spectrogram
try
    if ~isempty(app.LiveSpectrogramApp)
        delete(app.LiveSpectrogramApp);
        app.LiveSpectrogramApp = [];
    end
catch
    app.LiveSpectrogramApp = [];
end