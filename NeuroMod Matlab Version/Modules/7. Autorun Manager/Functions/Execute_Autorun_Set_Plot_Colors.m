function [Figure] = Execute_Autorun_Set_Plot_Colors(Figure,AutorunConfig)

Figure.Color = AutorunConfig.WindowBackgroundColor;
Figure.Title.Color = 'k';
Figure.XLabel.Color = 'k';
Figure.YLabel.Color = 'k';
Figure.XColor = 'k';  
Figure.YColor = 'k';  
Figure.XTickLabelMode = 'auto';  
Figure.TickLabelInterpreter = 'none';
