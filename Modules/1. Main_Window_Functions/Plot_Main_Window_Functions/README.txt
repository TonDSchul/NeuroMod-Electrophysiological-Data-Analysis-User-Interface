This folder contains the following functions with respective Header:

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

