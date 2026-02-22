This folder contains the following functions with respective Header:

 ###################################################### 

File: Module_MainWindow_ActiveChannel_ChannerlNumber_Grid_Traces.m
%________________________________________________________________________________________

%% Helper function to initiate the grid view grid array by determining the amount of channel columns depending on whether channel distanes are preserved
% called whenever the output arguments are needed to create/maintaine the grid array
% Also used to change spike positions that where determined to be within
% range to fit the grid layout

% Inputs: 
% 1. Info: main data structure meta data (Data.Info)
% SpikeData: structure with SpikeData.Indicies and SpikeData.SpikePositions
% WhatToDo: char, whether to just get number of channel and active channel
% ("NumChan" and "All") or just spike data ("Spikes" and "All")
% ActiveDataChannel: vector with currently activated active channel, is app.ActiveChannel
% PreserveChannelLocations: double, 1 or 0 whether to preserve the true distance
% between probe channels

% Output:
% 1. NumChannel: double, number of probe columns
% 2. ActiveDataChannel: vector with activ data channel to visualize,
% manipulated to fit selected plotting options
% 3. SpikeData: original struc as input, with modified SpikePositions

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Axon_Viewer.m
%________________________________________________________________________________________

%% Function that takes grid activity and performs thresholded nad neighbourhood analysis fo show spike psropagation in main window

% Inputs: 
% 1. Data: main window data structure
% PreviousThreshGrids: struc with field T1, holding the activity
% matrix of previous frames plotted (oroginal data structure!)
% frames for neighbourhood analysis
% 2. Info: main data metadata structure from Data.Info
% 3. PlotMode: char, whether to plot lines or color
% 4. PlotAppearance: struc holding all plotappearances for all windows to set
% plot properties like linewidths
% 5. PlotThreshGrids: activity matrix plotted for current frame
% 6. SpikeDataCell: Cell array with spike data for each channel to show as red
% point

% Output: 
%1. PreviousThreshGrids: see above
%2. PlotThreshGrids: See above

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Convert_DataMatrix_Into_3DGrid.m
%________________________________________________________________________________________

%% Function to prepare cell array with data to plot  grid view plot in main window
%% also handles detection of spikes within grid

% gets called in Module_Main_Window_Plot_Grid_Trace_View and
% Module_MainWindow_Plot_Data to prepare data for these plots or extract
% spikes for surf and mesh plots

% Inputs: 
% 1. Info: main data metadata structure from Data.Info
% 2. DataForMatrix: channel by time points data matrix with data being
% plotted in main window comes from
% Module_MainWindow_Convert_DataMatrix_Into_Grid!
% 3. TimeToPlot: vector double with time stamps for each data point
% 4. ActiveDataChannel: vector with currently active channel
% 5. PreserveChannelLocations: double, 1 or 0 whether to preserve the true distance
% between probe channels
% 6. SpikeData: cell array with dimension of probe design, holding spikes for
% each channel in spatially preserved channel order.
% 7. WhatToDo: char, what to do, either "JustData" to just get data matrix
% or "JustSpikes" to just get spikes or 'All' to get all. 

% Outputs:
% 1.PlotData: cell array (probe columns x rows)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Convert_DataMatrix_Into_Grid.m
%________________________________________________________________________________________

%% Function used to take matrix data of a single time point like in surf or axon viewer plots and save that single value for each channel in a matrix preserving channel locations
% Same as Module_MainWindow_Convert_DataMatrix_Into_3DGrid just for a
% single data point!

% gets called in 
% Module_MainWindow_Plot_Data to prepare data for these plots

% Inputs: 
% 1. Info: main data metadata structure from Data.Info
% 2. DataForMatrix: channel by time points data matrix with data being
% 3. PlotAppearance: structure holding indo about the appearance of plots
% the user selected
% 4. SpikeData: cell array with dimension of probe design, holding spikes for
% each channel in spatially preserverd channel order.
% 5. WhatToDo: char, what to do, either "DataMatrix" to just get data
% matrix or "SpikeMatrix" to just get spike matrix
% Channel_Selection: vector with data amtrix indicies that are selected to
% be plotted by user

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Detect_and_Add_Spikes.m
%________________________________________________________________________________________

%% NOT USED ANYMORE

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Initialize_Grid_Trace_Panel.m
%________________________________________________________________________________________

%% Function to initialze the grid of axes to plot data in grid view
% required is a app.Panel object to initiate all axes. One axes is
% initiated for each probe column. this acts like a subplot arrangement
% without using subplot (not usable in apps)

% each axes or probe column plots data forall rows concatonated together
% and separated by black vertical lines being plotted in the same axes.
% This boosts performance compared to an axes for each channel individually

% this function gets called for the main window data plot, ERP plot and
% spectrm plot. Thats ehy the second input ar is Mainapp, bc app can be one
% of the above

% Inputs: 
% 1. app: object to app window with app.Grid_Traces_View_Panel objectto
% intiate axes in
% 2. Mainapp: object to main window
% 3. Window: char, from which window this is called

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Plot_Data.m
%________________________________________________________________________________________
%% Function to Plot Data in the Main Window (raw data, preprocessed data, spike data and event data)

% Gets called in the 'Organize_Prepare_Plot_and_Extract_GUI_Info' function

% Input Arguments:
% 1. Data: Channel x Time holding the raw/preprocessed data (single/double)
% 2. UIAxis: App UIAxes object designating the plot you want to plot in
% 3. Time: Vector with time points to be plotted (single/double)
% 4. Channel_Selection [Ch1,Ch2]: Vector with two values, for the start andstop channel selected in main window
% 5. PlotLineSpacing: Factor (double) to introduce spacing between channel plots
% based on GUI slider input
% 6. Type: "Static" to not plot movie but just single plot. "Movie to plot movie"
% 7. colorMap: Colormap object to be used (as many elements as channel in dataset in a nelements x 3 matrix with rgb values)
% 8.Preprocessed: if 1: Data to be plotted is downsamßpled
% 9. EventPlot: "Events" to show event plots if within time range, any other
% string like "Non" leads to no events being plotted
% 10. EventData: vector of time points (in s as double) of the event selected
% on the bottom right of the main window. Only needed if EventPlot = "Events"
% 11. SampleRate as double in Hz
% 12. SpikePlot: string, "Spikes" when plotting spikes, some other string
% like "non" when not
% 13. SpikeData: structure with spike indicies and positions (all spikes)
% 14. StartIndex: First idicie plotted in main plot in samples as double
% 15. StopIndex: Last idicie plotted in main plot in samples as double
% 16. SpikeDatatype: Either "Internal" when plotting internal spike data or
% "Kilosort" when plotting spikes analysed with kilosort Or "SpikeInterface"
% 17. ChannelSpacing: as double in um
% 18. PlotAppearance: structure holding indo about the appearance of plots
% the user selected
% 19. SpikePlotType: string, either "Points" or "Waveforms" to specifiy how
% spikes should be plotted when the user selected them 
% 20. frameTime: double, Time in seconds of each frame based on selected
% frame rate
% 21. CurrentClim: double vector, lower and upper clim of max values so far

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Plot_Events_and_Label.m
%________________________________________________________________________________________

%% Function to plot event lines and event trigger numbers in main window

% gets called in 
% Module_MainWindow_Plot_Data

% Inputs: 
% 1. Info: main data metadata structure from Data.Info
% 2. Data: channel by time matrix with plotted data
% 3. Time: double vector with time stamps for each plotted data point in
% main plot
% 4. EventIndicies: double vector with sample indicies events are happening
% 5. UIAxis: plot axes to plot in (app.UIAxes)
% 6. EventPlot: char, from main window properties, whether to lot events or
% not 
% 7. EventIndexNr: index of event channel selected for plot
% 8. Eventline_handles: handles of already plotted event lines
% 9. YMinLimitsMultipeERP: min value of data plotted to set ylims
% of vertical line
% 10. YMaxLimitsMultipeERP: max value of data plotted to set ylims
% of vertical line
% 11. Channel_Selection: vector with data amtrix indicies that are selected to
% be plotted by user
% 12. PlotAppearance: structure holding indo about the appearance of plots
% the user selected

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Plot_Imagesc_Surf_Mesh.m
%________________________________________________________________________________________

%% Function to plot data in main window as surf, mesh or imagsc

% gets called in 
% Module_MainWindow_Plot_Data

% Inputs: 
% 1. Data: channel by time matrix with data to plot
% 2. Info: main data metadata structure from Data.Info
% 4. Time: double vector with time stamps for each plotted data point in
% main plot
% 5. Depth: double vector depths for each channel plotted in imagsc plot
% 6. ActiveChannel: data matrix channel indicies plotted
% 6. UIAxis: plot axes to plot in (app.UIAxes)
% 7. ClimMaxValues: 1 x 2 double vector with global clims plotted so far
% 8. PlotAppearance: structure holding indo about the appearance of plots
% the user selected
% 9. ImageScChannel_handles: handle to imagsc plot
% 10: SpikeDataCell: cell array with spike indicies for each channel (empty cell for no spikes in that channel)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Plot_Internal_Spikes.m
%________________________________________________________________________________________

%% Function to plot spike data coming from the internal thresholding in NeuroMod

% gets called in 
% Module_MainWindow_Plot_Data

% Inputs: 
% 1. Data: Channel x Time holding the raw/preprocessed data (single/double)
% 2. Info: main data metadata structure from Data.Info
% 3. Time: double vector with time stamps for each plotted data point in
% main plot
% 4. SpikePlot: string, "Spikes" when plotting spikes, some other string
% like "non" when not
% 5. SpikeDatatype: Either "Internal" when plotting internal spike data or
% "Kilosort" when plotting spikes analysed with kilosort Or "SpikeInterface"
% 6. SpikePlotType: string, either "Points" or "Waveforms" to specifiy how
% spikes should be plotted when the user selected them 
% 7. ActiveChannel: vector, active cahnnel selected (not matrix channel!)
% 8. Channel_Selection: vector, matrix data channel to plot
% 9. UIAxis: App UIAxes object designating the plot you want to plot in
% 10. ChannelSpacing: as double in um from Data.Info
% 11 PlotAppearance: structure holding indo about the appearance of plots
% the user selected

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Plot_Time.m
%________________________________________________________________________________________
%% Function to Plot Time in the Main Window
% Input Arguments:
% 1. UIAxis: App UIAxes object designating the plot you want to plot in
% 2. Time: Vector with time points to be plotted (single/double)
% 3. StartTimeIndex: Number of samples at which main window data plots beings
% to draw red rectangle
% 4. StopTimeIndex: Number of samples at which main window data plots ends
% to draw red rectangle
% 5. PlotType: "Initial" -- only input possible and needed so far
% 6. rectangleHandle: Handle to red rectangle drawn in time plot. Input and output to be
% able to access in rest of the GUI. Not needed yet
% 7. EventPlot: "Events" to show event plots if within time range, any other
% string like "Non" leads to no events being plotted
% 8. EventData: vector of time points (in s as double) of the event selected
% on the bottom right of the main window. Only needed if EventPlot = "Events"
% 9. PlotAppearance: structure holding indo about the appearance of plots
% the user selected

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_MainWindow_Show_Spike_Selector_Waveforms.m
%________________________________________________________________________________________

%% Function to plot waveform of sleected channel/cluster and spike nr in spike selector window


% Inputs: 
% 1. app: spike selector window object
% 2. PlotType: not used yet

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Module_Main_Window_Plot_Grid_Trace_View.m
%________________________________________________________________________________________

%% Function to plot grid trace view in main window, static spectrum and ERP windows
% This function is called inside of
% Organize_Prepare_Plot_and_Extract_GUI_Info when plotting in the main
% window. Otherwise it is called in the respective app window

% This plots within a plot grid created within an app.Panel object. As many
% plo axes as probe columns are created. For each column the signal of all
% rows is concatonated and demarkated by plotting black vertical lines. This
% saves significant amount of time compared to one plot axes for each
% channel

% Inputs: 
% 1. app: app object of the window to plot in. Takes app.ChannelAxes as
% cell array with each cell being one plot axes
% 2. Data: main window data structure
% PlotData: cell array with dimension of probe design, holdign signal for
% each channel in spatially preserverd channel order. Comes from
% Module_MainWindow_Convert_DataMatrix_Into_Grid.
% 3. Time: vector with time in seconds of signal plotted in each grid
% 4. BaselineNorm: double 1 or 0 whether to baseline normalize
% 5. PlotAppearance: struc holding all plotappearances for all windows to set
% plot properties like linewidths
% 6. ActiveDataChannel: vector of active channels. Default active channel
% numbers, not data matrix channel!
% 7. PreservePlotChannelLocations: double, 1 or 0 whether to preserve the true distance
% between probe channels
% 8. SpikeData: ell array with dimension of probe design, holding spikes for
% each channel in spatially preserverd channel order.
% 9. Window: char, determines from which window this function is called (and whether data lines or color plot), see
% below for options
% 10. MainPlot: 1 or 0 whether it is plotted in the main window
% 11. YlimMaxVlaues: Min and max y values of ALL data points being plotted to
% set global ylim
% 12. CurrentPlotData: struc holding all analysis results that can be exported

% Output:
% YlimMaxVlaues: Min and max y values of ALL data points being plotted to
% set global ylim.
% CurrentPlotData: struc holding all analysis results that can be exported

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

