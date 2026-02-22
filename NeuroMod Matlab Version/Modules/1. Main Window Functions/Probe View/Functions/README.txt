This folder contains the following functions with respective Header:

 ###################################################### 

File: ProbeViewClickCallback.m
%________________________________________________________________________________________
%% Function to handle click on the probe view window -- only clicks not on a line but blank space!

% It only changes the current probe view position along the probe
% --> app.FirstZoomChannel changes!

% Inputs: 
% 1. app: Probe View app window
% 2. event: click event holding x and y position
% 3. Window: not used here

% Outputs:
% 1. app: Probe View app window

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: ProbeViewClickLineCallback.m
%________________________________________________________________________________________
%% Function to handle click on the probe view window -- only clicks not on a line or rectangle

% this functions handles all the magic happening when the user clicks a
% channel --> recognize clicekd channel, delete it from active channel and call
% analysis/plot functions from openend windows to update plotted data.

% Inputs: 
% 1. app: Probe View app window
% 2. event: click event holding x and y position
% 3. Window: not used here

% Outputs:
% 1. app: Probe View app window

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: ProbeView_ProbeScheme_Color_Selection_Inactivated.m
%________________________________________________________________________________________
%% Function to determine the color of a channel in the probe view window when it is clicked at

% This function is executed every time the probe view window is newly
% opened/plotted. Only executed, if y limits change

% Inputs: 
% 1. ChannelClicked: double, channel the user clicked at in the probe view
% window (empty when non was clicked)
% 2. FirstZoomChannel: First channel of the zoomed selection in the right
% (from the bottom)
% 3. ChannelRows: double, specifies whether probe has one or two rows
% 4. OffSetRows: double, 1 or 0, specifies, whether every second channel row is shifted to the right 
% 5. NrChannel: doubl, number of channel from Data.Info
% 6. AllChannelLeft: vector, with all channel indicies on the left row
% 7. AllChannelRight: vector, with all channel indicies on the right row (if present)

% Outputs:
% 1. Waveforms: nchannel x nwaveforms x ntime matrix saving each extract
% waveform
% 2. BiggestSpikeIndicies: 1 x nrspikes (length of SpikeTimes). 1 if spike waveform was extracted, 0 if spike waveform was NOT
% extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: ProbeView_Show_Spike_Positions.m
%________________________________________________________________________________________
%% Function show spikes in the probe view window
% When spiek sorting data available: plot median x and y position of all
% spikes within a cluster, for each cluster
% when data was just thresholed: shows a circle over a channel if spikes
% found in that channel. 
% Circle size can be spike number or spike amplitude

% Inputs: 
% 1. Data: main window data structure
% 2. ProbeViewProperties: struc with fields:
% ProbeViewProperties.YlimsPlottedChannel and
% ProbeViewProperties.xlimsPlottedChannel. Those contains min and max
% values of plotted channel to fit spike positions in (x positions not to scale! Thats why spike positions have to be scaled)
% 3. Figure: app.UIAxes object to plot in
% 4. WhatToShow: char, either "NumSpikes" or "SpikeAmps" depending on how
% to scale size of circles


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: ProbeView_ZoomedChannel_Color_Selection.m
%________________________________________________________________________________________
%% Function to set color of squares in probe view window depending on whether they are active channel and whether they are currently active

% Called in Utitlity_Plot_Zoomed_Channel_Right_Side - only if nr rows
% smaller than 3, since no zoomed selection is plotted otherwise

% Inputs: 
% 1. LoopIteration: double, number of sqaure currently looped through 
% 2. FirstZoomChannel: double, first channel number currently viewed in zoomed in
% channel selection (note: 'real' channel = channel nr - FirstZoomChannel since its flipped after plotting)
% 3. ChannelRows: Nr of channel rows
% 4. OffSetRows: double. nr of rows in probe design
% 5. ReversedActiveChannelLeft: vector with channel number on the left
% side(first row) when channel numbers reversed
% 6. AllActiveChannel: vector with all active channel (not matrix channel)
% 7. ChannelRight: vector 1:NrColumns for right channel row
% 8. ChannelLeft: vector 1:NrColumns for left channel row
% 9. nrows: current row iteration in Utitlity_Plot_Zoomed_Channel_Right_Side
% 10. NrChannel: double, number of all channel (active and inactive)
% 11. CurrentChannel: double, no influence currently, always 0
% 12. ActiveChannel: double vector, currently active channel

% Outputs:
% 1. faceColor: 1x3 RGB value with face color of currently plotted square
% (yellow if currently active, white or black if not)
% 2. EdgeColor: 1x3 RGB value with edge olor of currently plotted square (red if active channel)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Probe_View_Set_Y_Ticks.m
%________________________________________________________________________________________
%% Function to reverse just the y ticks and y tick labels for the probe view window and probe creation window

% This function is executed every time the probe view window is newly
% opened/plotted. Only executed, if y limits change

% Inputs: 
% 1. Figure: app.UIAxes object of the probe view window
% 2. yMax: double, max value for yticks
% 3. yMin: double, min value for yticks
% 4. CreateProbeWindow: double, either 1 or 0, 1 if probe window is newly
% created, 0 if its for the probe view window when data was already
% exctracted
% 5: ChannelClicked: double if user activate a channel with channel nr. (to check whether min/max values change and this has to be excuted)

% Outputs:
% 1. Waveforms: nchannel x nwaveforms x ntime matrix saving each extract
% waveform
% 2. BiggestSpikeIndicies: 1 x nrspikes (length of SpikeTimes). 1 if spike waveform was extracted, 0 if spike waveform was NOT
% extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utility_Plot_BrainAreas.m
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


 ###################################################### 

File: Utility_Plot_Interactive_Probe_View.m
%________________________________________________________________________________________
%% Main Function to plot interactive probe view. Handles all sub functions to plot individual parts

%% Executed every time something about a probe view is plotted. Most necessray parameter come from Data.Info structure or the create probe view window as
%% well as the clickcallbacks executed when the user clicks something (like what exactly was clicked on, which channel are shwon at the moment etc.)
%% Most Inputs are logical 1 or 0 or double 1 or 0 specifying what happended and should be plotted. T

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. ChannelSpacing: double, from Data.Info structure in um
% 3. NrChannel: double, from Data.Info structure or create probe view window
% 4. ChannelRows: double, 1 or 2 from Data.Info structure or create probe view window
% 5. HorOffset: Horizontal offset in um between channel rows (0 if 1 channel row)
% 6. VerOffset: Vertical offset in um between channel rows (0 if 1 channel
% row) --> affects right row only. Positive and negative possible
% 7. SecondRowOffsetDistance: double, offset distance forevery second
% channel
% 8. ActiveChannel: double vector with all channel selected/activated by the
% user in the probe view window
% 9. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 10. LeftProbeChanged: double, 1 or 0 - if the left probe plot has to be
% updated -- saves time if not
% 11. ProbeBrainAreas: structure from trajectory explorer, empty if non
% 12. AllActiveChannel: double, vector with active channel  from Data.Info
% structure
% 13. PlotChannelSpacing: logical 1 or 0, if channel spacing should be
% shown in plot (rectangles for channel do not touch each other, gives more
% accurate scale and appearance) - selected in checkbox of probe view
% window
% 14. CreateProbeWindow: double, 1 or 0, if plot is for create probe window
% or probe view window
% 15. ChannelActivation: double, 1 or 0, if user activated/deactivated a
% channel (comes from ClickCallbacks), but also 1 if initialy created!!
% 16. ChannelClicked: double, channel the user clicked on if he did so,
% empty if not
% 17. OffSetRows: logical, 1 or 0, if left and right row have an offset (only if two channelrows)
% 18. RowClicked: 0 if clicked on a row on the left
% 19. SwitchTopBottom:  logical 1 or 0 if channel names are reversed from
% top to bottom
% 20. SwitchLeftRight logical 1 or 0 if channel names are switched between
% left and right channel row
% 21. ECogArray: logical 1 or 0 if probe is a ECoG array

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utility_Plot_Probe_Scheme.m
%________________________________________________________________________________________
%% Function to plot the complete probe scheme on the right of the probe view windows

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. GrayProbeFilling: vector with handles to gray patch plots -- empty
% when not necessray to plot or update
% 3. ProbeLines: array with line objects of the probe on the left -- empty
% when not necessray to plot or update
% 4. ChannelViewLeft: array with rectangle objects of the probe on the left (for all channel plotted) -- empty
% when not necessray to plot or update
% 5. NrChannel: double, from Data.Info structure or create probe view window
% 6. ChannelSpacing: double, from Data.Info structure in um
% 7. ActiveChannel: double, vector with currently active channel the userselected
% 8. VerOffset: Vertical offset in um between channel rows (0 if 1 channel
% row) --> affects right row only. Positive and negative possible
% 9. ChannelRows: double, 1 or 2 from Data.Info structure or create probe view window
% 10. LeftProbeChanged: double, 1 or 0 - if the left probe plot has to be
% updated -- saves time if not
% 11. AllActiveChannel: double, vector with active channel  from Data.Info
% structure
% 12. CreateProbeWindow: double, 1 or 0, if plot is for create probe window
% or probe view window
% 13. ChannelActivation: double, 1 or 0, if user activated/deactivated a
% channel (comes from ClickCallbacks), but also 1 if initialy created!!
% 14. ChannelClicked: double, channel the user clicked on if he did so,
% empty if not
% 15. OffSetRows: logical, 1 or 0, if left and right row have an offset (only if two channelrows)
% 16. RowClicked: 0 if clicked on a row on the left
% 17. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 18. ECogArray: logical 1 or 0 if probe is a ECoG array
% 19. SecondRowOffsetDistance: double, offset distance forevery second
% channel

% Outputs:
% 1. yPoint: y value of grey probe tip (warning: most likely negative!)
% 2. yLimits: double 1x2 vector with min and max value of plotted probe on
% the left - for y scale and detection where user clicked on
% 3. ActiveChannel: currently selected active channel
% 4. yLimitsSquares: double 1x2 vector with min and max value of plotted channel rectangles on
% the left, used as limit to plot black lines of channel zoomed on the
% right
% 5. squareHeight: double, Height of each square plotted in the left side
% (in um)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utility_ProbeChange_Plot_ContSpikes.m
%________________________________________________________________________________________
%% Function to update continous spike analysis plots when the user changed the active channel selection

% Executed only when the user changes the channelselection and cont. spike
% analysis windows are supposed to be updated (in the dropdown menu of the probe view window)

% Inputs: 
% 1. app: probe view window object

% Outputs:
% 1. app: probe view window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utility_ProbeChange_Plot_EventRelatedLFP.m
%________________________________________________________________________________________
%% Function to update event related LFP analysis plots when the user changed the active channel selection

% Executed only when the user changes the channelselection and event related LFP analysis windows are supposed to be updated (in the dropdown menu of the probe view window)

% Inputs: 
% 1. app: probe view window object
% 2. Window: string, either "ERP" OR "CSD" OR "EventSpectrum" OR "TF" (time frequency power window)

% Outputs:
% 1. app: probe view window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utility_ProbeChange_Plot_EventSpikes.m
%________________________________________________________________________________________
%% Function to update event related spike analysis plots when the user changed the active channel selection

% Executed only when the user changes the channelselection and event related spike analysis windows are supposed to be updated (in the dropdown menu of the probe view window)

% Inputs: 
% 1. app: probe view window object

% Outputs:
% 1. app: probe view window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utility_ProbeView_Mouse_Wheel_CalBack.m
%________________________________________________________________________________________
%% Function to change zoomed channel shown on the right when the user scrolls with the mouse wheel while hovering over the probe view plot

% Inputs: 
% 1. app: probe view window object
% 2. event: event structure from mouse wheel scroll
% 3. NrChannel: double, from Data.Info 

% Outputs:
% 1. app: probe view window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utitlity_Plot_Brackets_Probe_View.m
%________________________________________________________________________________________
%% Function to plot the black bracket on the right for the zoomed channel selection

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. BracketLine: array with line objects of brackets
% 3. NrChannel: double, from Data.Info structure or create probe view window
% 4. ChannelSpacing: double, from Data.Info structure in um
% 5. yPoint: y value of grey probe tip (warning: most likely negative!)
% 6. yLimits: double 1x2 vector with min and max value of plotted probe on
% the left - for y scale and detection where user clicked on
% 7. yLimitsSquares: double 1x2 vector with min and max value of plotted channel rectangles on
% the left, used as limit to plot black lines of channel zoomed on the
% right
% 8. squareHeightLeftProbe: double, Height of each square plotted in the left side
% (in um)
% 9. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 10. NrRows: double, 1 or 2 from Data.Info structure or create probe view window
% 11. CreateProbeWindow: double, 1 or 0, if plot is for create probe window
% or probe view window
% 12. ChannelActivation: double, 1 or 0, if user activated/deactivated a
% channel (comes from ClickCallbacks), but also 1 if initialy created!!
% 13. ECogArray: logical 1 or 0 if probe is a ECoG array

% Outputs:
% 1. yLimitBracktes: double, vector with min and max value of the plotted
% bracket

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utitlity_Plot_Zoomed_Channel_Right_Side.m
%________________________________________________________________________________________
%% Function to plot the zoomed channel selection on the right.

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. ChannelViewRight: array with rectangle objects of the probe on the right (for all channel plotted) -- empty
% when not necessray to plot or update
% 3. NrChannel: double, from Data.Info structure or create probe view window
% 4. ChannelSpacing: double, from Data.Info structure in um
% 5. ShowChannelSpacing double, 1 or 0 if channel spacing between
% rectangles should be plotted (using the checkbox in the probe view window)
% 6. ChannelRows: double, 1 or 2 from Data.Info structure or create probe view window
% 7. VerOffset: Vertical offset in um between channel rows (0 if 1 channel
% row) --> affects right row only. Positive and negative possible
% 8. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 9. ActiveChannel: double, vector with currently active channel the userselected
% 10. NrRows: not used
% 11. yLimitBracktes: ymax and ymin of the black brackets in the right
% 12. AllActiveChannel: double, vector with active channel  from Data.Info
% structure
% 13. OffSetRows: logical, 1 or 0, if left and right row have an offset (only if two channelrows)
% 14. SwitchTopBottom: logical, 1 or 0, if upper and lower channel names
% are switched

% Outputs:
% 1. numSquares: double, number of channel squares plotted
% squareHeight : double, height of channel squares plotted
% 2. lowylimits: double, height of channel squares plotted
% 3. CorrrectedVerOffset: Vertical Offset in plot between left and right
% channelrow for the actual plot
% 4. xdistances: vector with distance between all x position rows are
% plotted at
% 5. AllYPositions: vector with y positions of all channels plotted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utitlity_Plot_Zoomed_Text_Channel_Right_Side.m
%________________________________________________________________________________________
%% Function to plot channel names on the zoomed channel on the right 

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. ChannelText: array of text objects that show the channel name
% 3. NrChannel: double, from Data.Info structure or create probe view window
% 4. ChannelRows: double, 1 or 2 from Data.Info structure or create probe view window
% 5. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 6. numSquares: double, number of channel sqaures plotted on the right
% 7. squareHeight: double, height of squares plotted on the right
% 8. lowylimits: lowest plot limit of channel plot on the right
% 9. CorrrectedVerOffset: double, vertical offset of channel rows plotted
% one the right in the actual plot (comes from Utitlity_Plot_Zoomed_Channel_Right_Side)
% 10. CreateProbeWindow: double, 1 or 0, if plot is for create probe window
% or probe view window
% 11. ChannelActivation: double, 1 or 0, if user activated/deactivated a
% channel (comes from ClickCallbacks), but also 1 if initialy created!!
% 12. PlotChannelSpacing: 1 or 0 if channel spacing between channel squares
% should be plotted on the right side
% 13. VerOffset: Vertical offset in um between channel rows (0 if 1 channel
% row) --> affects right row only. Positive and negative possible
% 14. ChannelSpacing: double, from Data.Info structure in um
% 15. SwitchTopBottom: 1 or 0 if upper and lower channel names are switched
% 16. SquareXPos: vector with all x position of all rows plotted (start and end of each row)
% 17. SquareYPos: vector with all x position of all columns plotted (start and end of each column)
% 18. OffSetRows: 1 or 0 whether every second column is offset to the right

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

