> ## **How to install the NeuroMod Matlab Version** ##

- First, NeuroMod is available as a normal Matlab version with the GUI as a. mlapp file. If you already have a valid Matlab license (2023a or newer) and Matlab installed, you can download the whole repository as a .zip file and extract it. The 'NeuroMod Matlab Version' folder contains all files including the NeuroMod_Toolbox_GUI.mlapp file, which starts NeuroMod. Copy it in a directory with read/write access (in doubt use the desktop) and open NeuroMod with any of these three methods:

  1. Double-click the 'NeuroMod_Toolbox_GUI.mlapp' file, which will automatically open MATLAB and NeuroMod.
  2. Alternatively, use the MATLAB command window to navigate (cd) to the folder where you saved the files. Then, right-click the NeuroMod_Toolbox_GUI.mlapp file in the current folder window and select "Run."
  3. Finally, you can also launch NeuroMod by typing the following command into the MATLAB command window after navigating (cd) to the folder containing the GUI:

```matlab
Neuromod_Toolbox_GUI
```

> ## **How to install the NeuroMod Standalone Version** ##

- If you don’t have a Matlab license for Matlab 2023a or newer, you have to use the standalone version of NeuroMod. It is functionally identical to the Matlab version. The only requirement is to have the Matlab Runtime version 2025b installed, which is for free and comes with NeuroMod.

<img src="NeuroMod Matlab Version/Modules/MISC/Images/How To Standalone.jpg" align="right" width="100%" />


Follow these steps:

  1. Download only the 'NeuroMod Standalone Version.zip' file, extract it and save the folder in a directory with read/write access (in doubt use the desktop). **NOTE:** It cannot be extracted when the whole repository is downloaded as a .zip file, so you have to download it individually!
  2. In the extracted folder you will find a NeuroMod Installer.exe file. This is only needed to install the MATLAB 2025b runtime version. Double click and install in a folder of your choosing. Skip this step if you already installed it.
  3. Download the whole NeuroMod repository as a .zip file and extract it.
  4. Copy all files and folder in the 'NeuroMod Matlab Version' folder into the 'NeuroMod Standalone Version' folder. Afterwards, you should have a NeuroMod.exe file and the NeuroMod_Toolbox_GUI.mlapp file in the same folder.
  5. NeuroMod can now be started using the NeuroMod.exe. Create a shortcut for better access.

**NOTE:** Installation and usage of Python tools like SpikeInterface or NEO is the same for the Matlab and standalone version of NeuroMod.

**NOTE:** After downloading, make sure that the folders within the NeuroMod folder are all named like in the repository! Otherwise, you cannot use some features of NeuroMod including spike sorting and using NEO for data extraction. 
- The GUI was created using Matlab version 2025b. In order for Matlab to be able to execute python code for the SpikeInterface spike sorting via this GUI, make sure your Matlab version is compatible with your python version!
  
> ### **Get Started With Example Data**

<img src="NeuroMod Matlab Version/Modules/MISC/Images/Get_Started_Image.jpg" width="1000" height="700" />

In doubt, have a look at the full documentation: [NeuroMod Toolbox Manual](NeuroMod%20Matlab%20Version/Modules/MISC/docs/NeuroMod_Toolbox_Manual.docx)

Download and extract only the 'Example_Intan_Data.zip' file to explore all functionalities NeuroMod offers with a 64 channel recording including spike sorting results ready to load in! **NOTE:** If you download the whole repository as a .zip file, you cannot extract the 'Example_Intan_Data.zip', so you have to download it individually.

The first thing you always have to do is to either extract data from a recording or to load data you previously saved with NeuroMod. To extract data from any dataset in one of the supported data formats select the "Load Raw Recordings" option in NeuroMod and click on the "RUN" button on the left side in the "Manage Dataset" module. Select a folder containing your recording (or the example recording folder containing the individual recording files) and specify your probe design. Some probe designs (also for the example dataset) are already available to load using the menu on top of the window (called Load Saved Probe Information). For the example dataset select the saved Probe_Info_64_ASSY_77_H3_acute_ChannelOrder.mat file. In doubt, most windows give additional information in the text areas as well as tooltips. In most cases, if you click on something or do something that is not supported or does not work (i.e. click start without specifying a probe design or selecting a folder without a supported recording file), you will get a message what the issue is. 

**NOTE:** Spike sorting results in the example dataset are not optimized (standard settings) and do not represent the best possible outcome with the respective sorter. 
