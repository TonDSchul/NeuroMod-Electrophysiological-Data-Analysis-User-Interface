function Organize_Delete_All_Open_Windows(app,DeleteProbeView)

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

%% Live main window plots
if ~isempty(app.PSTHApp)
    delete(app.PSTHApp.SpikeRateWindowUIFigure);
    app.PSTHApp = [];
end
if ~isempty(app.CSDApp)
    delete(app.CSDApp.CSDWindowUIFigure);
    app.CSDApp = [];
end
if ~isempty(app.SpectralEstApp)
    delete(app.SpectralEstApp);
    app.SpectralEstApp = [];
end

%% Cont Spectrum
if ~isempty(app.ContStaticSpectrumWindow)
    delete(app.ContStaticSpectrumWindow);
    app.ContStaticSpectrumWindow = [];
end

%% Cont Spikes
if ~isempty(app.ConInternalSpikesWindow)
    delete(app.ConInternalSpikesWindow);
    app.ConInternalSpikesWindow = [];
end
if ~isempty(app.ConKilosortSpikesWindow)
    delete(app.ConKilosortSpikesWindow);
    app.ConKilosortSpikesWindow = [];
end

if ~isempty(app.UnitAnalysis)
    delete(app.UnitAnalysis);
    app.UnitAnalysis = [];
end
%% Event spikes

if ~isempty(app.EventInternalSpikesWindow)
    delete(app.EventInternalSpikesWindow);
    app.EventInternalSpikesWindow = [];
end

if ~isempty(app.EventKilosortSpikesWindow)
    delete(app.EventKilosortSpikesWindow);
    app.EventKilosortSpikesWindow = [];
end

%% Event LFP

if ~isempty(app.EventLFPERP)
    delete(app.EventLFPERP);
    app.EventLFPERP = [];
end

if ~isempty(app.EventLFPCSD)
    delete(app.EventLFPCSD);
    app.EventLFPCSD = [];
end
if ~isempty(app.EventLFPTF)
    delete(app.EventLFPTF);
    app.EventLFPTF = [];
end

if ~isempty(app.EventLFPSSP)
    delete(app.EventLFPSSP);
    app.EventLFPSSP = [];
end

%% Prepro Artefact rejection
if ~isempty(app.PreproArtefactRejection)
    delete(app.PreproArtefactRejection);
    app.PreproArtefactRejection = [];
end

%% Event Extraction Window

if ~isempty(app.EventExtractionWindow)
    delete(app.EventExtractionWindow);
    app.EventExtractionWindow = [];
end

%% Spike Extraction Window

if ~isempty(app.SpikeExtractionWindow)
    delete(app.SpikeExtractionWindow);
    app.SpikeExtractionWindow = [];
end

%% Load from Kilosort Window

if ~isempty(app.LoadfromKilosortWindowWindow)
    delete(app.LoadfromKilosortWindowWindow);
    app.LoadfromKilosortWindowWindow = [];
end

%% SaveforKilsort Window

if ~isempty(app.SaveforKilosortWindowWindow)
    delete(app.SaveforKilosortWindowWindow);
    app.SaveforKilosortWindowWindow = [];
end

%% Preprocessing Window 
if ~isempty(app.PreproWindow)
    delete(app.PreproWindow);
    app.PreproWindow = [];
end

%% Prepro Events Main Window Window 
if ~isempty(app.PreproEventsMainWindow)
    delete(app.PreproEventsMainWindow);
    app.PreproEventsMainWindow = [];
end

%% Event LFP analysis main window
if ~isempty(app.LFPEventsMainWindow)
    delete(app.LFPEventsMainWindow);
    app.LFPEventsMainWindow = [];
end

%% Load Data Window
if ~isempty(app.LoadDataWindow)
    delete(app.LoadDataWindow);
    app.LoadDataWindow = [];
end

%% Save Data Window
if ~isempty(app.SaveDataWindow)
    delete(app.SaveDataWindow);
    app.SaveDataWindow = [];
end
