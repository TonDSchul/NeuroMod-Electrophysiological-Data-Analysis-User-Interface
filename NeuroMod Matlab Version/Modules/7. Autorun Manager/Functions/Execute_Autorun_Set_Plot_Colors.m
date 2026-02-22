function [Figure] = Execute_Autorun_Set_Plot_Colors(Figure,AutorunConfig)

%________________________________________________________________________________________
%% Function to set plot colors of Matlab figure objects for the autorun function
% to account for background colors maybe changed by user and set
% labels/ticks to properly show in Matlab dark mode

% Inputs:
% 1. Figure: figure object to modify
% 2. AutorunConfig: struc with autorun settings


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

Figure.Color = AutorunConfig.WindowBackgroundColor;
Figure.Title.Color = 'k';
Figure.XLabel.Color = 'k';
Figure.YLabel.Color = 'k';
Figure.XColor = 'k';  
Figure.YColor = 'k';  
Figure.XTickLabelMode = 'auto';  
Figure.TickLabelInterpreter = 'none';
