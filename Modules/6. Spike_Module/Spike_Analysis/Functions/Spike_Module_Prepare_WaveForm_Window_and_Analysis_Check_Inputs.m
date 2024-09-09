function [W1,W2,W3,BinSize,ISIMaxTime] = Spike_Module_Prepare_WaveForm_Window_and_Analysis_Check_Inputs(W1,W2,W3,BinSize,ISIMaxTime)

%% Check Inputs 

[W1] = Utility_SimpleCheckInputs(W1,"One",'20',0,0);
[W2] = Utility_SimpleCheckInputs(W2,"One",'20',0,0);
[W3] = Utility_SimpleCheckInputs(W3,"One",'20',0,0);

[BinSize] = Utility_SimpleCheckInputs(BinSize,"One",'150',0,0);
[ISIMaxTime] = Utility_SimpleCheckInputs(ISIMaxTime,"One",'0.15',0,0);

