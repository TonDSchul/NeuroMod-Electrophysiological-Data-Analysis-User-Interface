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
        Placeholder = {};
        app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items = Placeholder;
        app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{1} = 'All Windows Opened';
        app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{2} = 'Main Window';
    end
catch
    app.ProbeViewWindowHandle = [];
end
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
if isfield(app,'PreproArtefactRejection')
    if ~isempty(app.PreproArtefactRejection)
        delete(app.PreproArtefactRejection);
        app.PreproArtefactRejection = [];
    end
else
    app.PreproArtefactRejection = [];
end

%% Event Extraction Window
if isfield(app,'EventExtractionWindow')
    if ~isempty(app.EventExtractionWindow)
        delete(app.EventExtractionWindow);
        app.EventExtractionWindow = [];
    end
else
    app.EventExtractionWindow = [];
end
%% Spike Extraction Window
if isfield(app,'SpikeExtractionWindow')
    if ~isempty(app.SpikeExtractionWindow)
        delete(app.SpikeExtractionWindow);
        app.SpikeExtractionWindow = [];
    end
else
    app.SpikeExtractionWindow = [];
end
%% Load from Kilosort Window
if isfield(app,'LoadfromKilosortWindowWindow')
    if ~isempty(app.LoadfromKilosortWindowWindow)
        delete(app.LoadfromKilosortWindowWindow);
        app.LoadfromKilosortWindowWindow = [];
    end
else
    app.LoadfromKilosortWindowWindow = [];
end
%% SaveforKilsort Window
if isfield(app,'SaveforKilosortWindowWindow')
    if ~isempty(app.SaveforKilosortWindowWindow)
        delete(app.SaveforKilosortWindowWindow);
        app.SaveforKilosortWindowWindow = [];
    end
else
    app.SaveforKilosortWindowWindow = [];
end

%% Prepro Events Main Window Window 
if isfield(app,'PreproEventsMainWindow')
    if ~isempty(app.PreproEventsMainWindow)
        delete(app.PreproEventsMainWindow);
        app.PreproEventsMainWindow = [];
    end
else
    app.PreproEventsMainWindow = [];
end

%% Event LFP analysis main window
if isfield(app,'LFPEventsMainWindow')
    if ~isempty(app.LFPEventsMainWindow)
        delete(app.LFPEventsMainWindow);
        app.LFPEventsMainWindow = [];
    end
else
    app.LFPEventsMainWindow = [];
end

%% Save Data Window
if isfield(app,'SaveDataWindow')
    if ~isempty(app.SaveDataWindow)
        delete(app.SaveDataWindow);
        app.SaveDataWindow = [];
    end
else
    app.SaveDataWindow = [];
end

%% Autorun Window
if isfield(app,'AutorunWindow')
    if ~isempty(app.AutorunWindow)
        delete(app.AutorunWindow);
        app.AutorunWindow = [];
    end
else
    app.AutorunWindow = [];
end

%% Manage Modules window
if isfield(app,'ManageModulesWindow')
    if ~isempty(app.ManageModulesWindow)
        delete(app.ManageModulesWindow);
        app.ManageModulesWindow = [];
    end
else
    app.ManageModulesWindow = [];
end

