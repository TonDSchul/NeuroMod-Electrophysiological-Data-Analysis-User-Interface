# NeuroMod - Fully Interactive Ephys Data Analysis <br> and Visualization for Matlab 

<img src="NeuroMod Matlab Version/Modules/MISC/Images/GITLOGO.png" align="right" width="100" height="100"/>

<img src="NeuroMod Matlab Version/Modules/MISC/Images/MainWindowGIF.gif" width="700" height="360" />

** Warning: If you want to use NeuroMod with a valid MATLAB license, it will only work with Matlab Versions 2023a or newer **

NeuroMod is an interactive toolbox for analyzing and visualizing electrophysiological data from single shank or array probe designs with arbitrary geometry. 
It seamlessly integrates established toolboxes such as Kilosort, SpikeInterface, NEO, Open Ephys Tools and Fieldtrip for a wide range of LFP and spike analyses methods, supports various data formats in a code free user interface and bridged the gap between Matlab and Python packages.

The aim is to offer a comfortable and user-friendly experience while providing clear instructions and feedback on actions taken, rather than hard-to-interpret error messages or opaque processes. Nearly all parameters related to data extraction and analysis are automatically set, but can still be adjusted within the GUI.
This design ensures a smooth, code-free user experience, offering helpful guidance while still having full control over the analysis.

Since the requirements for analysis and visualization can be vastly different and should be editable, the modular design philosophy of the user interface enables you to easily integrate your own analysis module into the GUI. All you have to do is to open the Matlab App Designer and copy a few lines of code from the manual, giving real time access to the whole dataset. When your app window is ready, it can be activated with a few clicks in the GUI, integrating it into the rest of the analysis ecosystem. 
Lastly an autorun functionality can be used to automatically apply all analysis and visualization methods available in the GUI to multiple recordings in a folder and save analysis plots and results independent of the GUI.   

As a result, NeuroMod is not only ideal for teaching and evaluating recording quality before or after sessions but also for comprehensive data analysis of one or multiple recordings with your own pipeline. 

> ## **Table of Contents**
> 
- [Data Formats and Capabilities](#data-formats-and-capabilities)
  
  - [Converting Recording Data for Different Toolboxes](#converting-recording-data-for-different-toolboxes)
    
- [How to install the GUI](#how-to-install-the-gui)
  
  - [Get Started With Example Data](#get-started-with-example-data)
  
  - [Overview of Required MATLAB Toolboxes](#overview-of-required-matlab-toolboxes)
    
  - [Overview of Other Toolboxes Used](#overview-of-other-toolboxes-used)

  - [How to Install SpikeInterface for Spike Sorting in NeuroMod](#how-to-install-spikeinterface-for-spike-sorting-in-neuromod)

  - [How to Install NeuralEnsemble NEO to extend supported file formats in NeuroMod](#how-to-install-neuralensemble-neo-to-extend-supported-file-formats-in-neuromod)

  - [How to Install Phy to Open via NeuroMod](#how-to-install-phy-to-open-via-neuromod)

  - [How to load Maxwell Biosystems MaxOne MEA h5 files](#how-to-load-maxwell-biosystems-maxone-mea-h5-files)	

  - [About Performance](#about-performance)

  - [General Remarks](#general-remarks)

  - [Nomenclature](#nomenclature)

 - [Rules and Philosophy](#rules-and-philosophy)
  
 - [Disclaimer, License and Contact](#disclaimer-license-and-contact)

> ## **Data Formats and Capabilities**

<img src="NeuroMod Matlab Version/Modules/MISC/Images/Example_Image_1.jpg" align="right" width="100%" />

NeuroMod supports data extraction from raw recording data with three different 'libraries' - first the NeuroMod intern (Matlab-based) data extraction, secondly data extraction using the NeuralEnsemble NEO Python package and thirdly data extraction using SpikeInterface- all through the user interface without the need for coding! The MATLAB intern and NEO libraries support recordings obtained with the Open Ephys GUI but to different extends - NeuroMod supports all OE formats (binary .dat; .nwb and OE format files) from any recording system (OE acquisition board; Intan RHD acquisition board; Neuropixels basestation with NP1.0 or 2.0 probes), while NEO only supports binary format recordings, also including Neuropixels recordings with a Neuropixels basestation. Additionally, both libraries support extraction of Neuralynx .ncs recordings (.ncs; .nev; .nse and .ntt files).

Besides these shared formats, NeuroMod itself currently supports formats recorded with the Intan RHX data acquisition software (and legacy RHD software) as well as Spike2, SpikeGLX Neuropixels 1.0 and Tucker Davis Tank recordings. This includes .dat and .rhd files from the Intan RHX and RHD software, .smrx files for Spike2 recordings, .ap.bin and .lp.bin files for SpikeGLX as well as .sev TDT (Tucker Davis Tank format) recordings. 
Through the use of the NEO library, NeuroMod furthermore offers to extract Plexon (.plx) recordings - while the use of the SpikeInterfae library allows to extract Maxwell Biosystems MaxOne MEA recordings in the .h5 format.

<img src="NeuroMod Matlab Version/Modules/MISC/Images/FormatOverview.jpg" align="right" width="45%" />

**Note:** When you want to load Neuropixels recordings from the Open Ephys GUI with NEO, it does not support having multiple recording folder within the same session, i.e. when acquisition was stopped and started again within the same recording session. To handle and concatenate multiple recordings within the same session, use the MATLAB internal library! Switching the format to save and load back into MATLAB to the custom format.

**Note:** When using SpikeInterface to extract Maxwell MEA data, you can take the same anconda environment as for spike sorting described below. See this section for install instructions.

**Note:** When using NEO or SpikeInterface to extract data from a raw recording, make sure there are no additional files or folder within the recording folder other than those that come from the recording software! Otherwise, NEO might not detect the format correctly or at all.

Since a lot of recordings are trial based and rely on synchronized event/TTL data, not only continuous amplifier channel data, but also event data from all recording formats mentioned (e.g., TTL signals to the recording system) can be loaded and analysed, enabling not only the pre-processing, analysis, and visualization of continuous data but also of event-related data.
Available types of analysis include current source density analysis, static power spectrum analysis, time-frequency power analysis, phase synchronization and event-related potentials for low-frequency signal components as well as event related spike analysis.

The supported recording systems can be used with a wide range of probes designs, influencing downstream data analysis. Therefore, a fully interactive probe design and probe view window enables to set arbitrary probe designs (of longituinal single shank probes and multielectrode arrays) while always having an overview and full control over which channel are used for the analysis. Even Neuropixel probe designs with hundreds of recording channels almost freely distributed over the whole shank can be analysed without loosing oversight and with a visual representation of brain areas distributed over the probe based on coordinates obtained from the Neuropixels Trajectory Explorer. Note: Multishank recordings (for example from NP 2.0 probes) can also be loaded, but are integrated into the same shank design, requiring to manually select the active analysis channel corresponding to a single shank.

<img src="NeuroMod Matlab Version/Modules/MISC/Images/Example_Image_2.jpg" align="right" width="70%" />

Lastly, NeuroMod fully supports Kilosort, Mountainsort 5 and SpyKING CIRCUS 2 spike sorting. This firstly includes saving the dataset and probe design for external use in one of the sorting packages with your own code/the respective Sorting GUI provided with it. Secondly, you can apply automatic spike sorting with SpikeInterface completely handled by NeuroMod without the need to code with Mountainsort 5 and SpyKING CIRCUS 2. You just have to install the respective python packages (see below for instructions) and everything else is taken care of for you in NeuroMod, while still having full control over sorting parameters. In any case, spike sorting results from all these sorters can be loaded back into NeuroMod for further analysis (see below for details). If these sorters can not be used, NeuroMod also offers spike detection using different thresholding methods as well as spike clustering using WaveClus 3 (which does not have to be installed). Since every analysis is shown and editable in a separate window, spike and LFP analysis results can be easily compared and correlated. 

**NOTE:** Loading sorting results is supported for Kilosort 3 (Matlab Kilosort version) and 4 (Python Kilosort version), although the compatibility of Kilosort 3 results with external spike sorting tools like Phy is not given and probably wont work. 

> ### **Converting Recording Data for Different Toolboxes**

After your extracted/loaded data into Neuromod, you can further save it in four different formats to load into other MATLAB or python toolboxes/codes. First, you can save it in a format compatible to load back into NeuroMod at a later stage with all dataset components in a .dat and separate .mat file. 

Second, continuous channel data and event data can be saved in a .mat file that can be loaded into the NeuralEnsemble Neo python toolbox. This means, you can load the data into any python toolbox using NEO as the data extraction/managing foundation. An example python script to show how to load the NEO compatible .mat file into NEO and plot the data and events can be found here: [Load NEO compatible MATLAB file into NEO](NeuroMod%20Matlab%20Version/Modules/MISC/docs/Load_Saved_Mat_For_Neo_Example.py) found at 'NeuroMod Matlab Version/Modules/MISC/docs/Load_Saved_Mat_For_Neo_Example.py'. 

The third option allows you to save data in the .nwb format using the MatNWB Matlab interface and can be loaded into any toolbox able to read nwb files. An example python script to show how to load the saved files into using pynwb and plot the data and events can be found here: [Load files saved as .nwb with pynwb](NeuroMod%20Matlab%20Version/Modules/MISC/docs/Load_Saved_NWB_Example.py) found at 'NeuroMod Matlab Version/Modules/MISC/docs/Load_Saved_NWB_Example.py‘.

The fourth option offers to save data as a .bin file with additional .json files containing probe information and meta data to load into the SpikeInterface python toolbox. This means you can either conduct spike sorting with the newest spike sorting algorythms in SpikeInterface directly or interface all toolboxes working using the SpikeInterface data representation. An example python script to show how to load the saved files into SpikeInterface and plot the data and events can be found here: [Load files saved for SpikeInterface into SpikeInterface](NeuroMod%20Matlab%20Version/Modules/MISC/docs/Load_Saved_Data_For_SpikeInterface.py) found at 'NeuroMod Matlab Version/Modules/MISC/docs/Load_Saved_Data_For_SpikeInterface.py'.

Lastly, you can save data in a FieldTrip compatible .mat file that can be read into FieldTrip for a custom pipeline. An example how to load data into FieldTrip and conduct LFP analysis can be found in 'Path_to_NeuroMod\Modules\5. Event Related Module\FieldTrip Event Analysis\Functions' and in 'Path_to_NeuroMod\Modules\2. Manage Dataset Module\Save GUI Dataset\Functions\Manage_Dataset_SaveData_FieldTrip.m'.

**NOTE:** This is different from using the SpikeInterface library within NeuroMod to sort spike data. This can be done without any additional code! The same holds true for extracting some of the recording formats supported by NEO into NeuroMod.

All of these formats that can be save, can also be loaded back into MATLAB (given they were saved with NeuroMod or assume the same format and files saved by NeuroMod).

> ## **How to install the GUI** ##

- First, NeuroMod is available as a normal Matlab version with the native code and the GUI as a. mlapp file. If you already have a valid Matlab license and Matlab installed, you can download all files in the native folder structure, 'cd' into the directory within Matlab and launch the NeuroMod_Toolbox_GUI.mlapp file. Then you have several options to launch the GUI:
  1. Double-click the 'NeuroMod_Toolbox_GUI.mlapp' file, which will automatically open MATLAB and the GUI.
  2. Alternatively, use the MATLAB command window to navigate (cd) to the folder where you saved the files. Then, right-click the NeuroMod_Toolbox_GUI.mlapp file in the current folder window and select "Run."
  3. Finally, you can also launch the GUI by typing the following command into the MATLAB command window after navigating (cd) to the folder containing the GUI:

```matlab
Neuromod_Toolbox_GUI
```
- If you don’t have a valid Matlab license, NeuroMod is also available as a standalone version. You just need to install a Matlab runtime version (at least 25.1) under: https://www.mathworks.com/products/compiler/mcr/index.html
1. Download and install the Matlab runtime.
2. Download the ‘NeuroMod Standalone Version‘ folder. 
3. Now you can start NeuroMod via the NeuroMod.exe file in the folder ‘NeuroMod Standalone Version’ folder. 

**NOTE:** If you want to use the standalone app, then only execute the NeuroMod.exe file from the ‘NeuroMod Standalone Version’ folder, since it is using the folder it is executed from to search for some resources within the ‘Modules’ folder. 

**NOTE:** After downloading, make sure that the folders within the NeuroMod folder are all named like in the repository! Otherwise, you cannot use some features of NeuroMod including spike sorting and using NEO for data extraction. 
- The GUI was created using Matlab version 2024b. In order for Matlab to be able to execute python code for the SpikeInterface spike sorting via this GUI, make sure your Matlab version is compatible with your python version!
  
> ### **Get Started With Example Data**

<img src="NeuroMod Matlab Version/Modules/MISC/Images/Get_Started_Image.jpg" width="1000" height="700" />

In doubt, have a look at the full documentation: [NeuroMod Toolbox Manual](NeuroMod%20Matlab%20Version/Modules/MISC/docs/NeuroMod_Toolbox_Manual.docx)

Download and extract the 'Example_Intan_Data.zip' file to explore all functionalities NeuroMod offers with a 64 channel recording!

The first thing you always have to do is to either extract data from a recording or to load data you previously saved with NeuroMod. To extract data from any dataset in one of the supported data formats select the "Load Raw Recordings" option in NeuroMod and click on the "RUN" button on the left side in the "Manage Dataset" module. Select a folder containing your recording (or the example recording folder containing the individual recording files) and specify your probe design. Some probe designs (also for the example dataset) are already available to load using the menu on top of the window (called Load Saved Probe Information). For the example dataset select the saved Probe_Info_64_ASSY_77_H3_acute_ChannelOrder.mat file. In doubt, most windows give additional information in the text areas as well as tooltips. In most cases, if you click on something or do something that is not supported or does not work (i.e. click start without specifying a probe design or selecting a folder without a supported recording file), you will get a message what the issue is. 

**NOTE:** Spike sorting results are not optimized and do not represent the best possible outcome with the respective sorter. 

> ### **Overview of required Matlab toolboxes**

**1. To extract Neuralynx Data:**
```matlab
Database Toolbox
Fixed Point Designer
Image Processing Toolbox
Optimization Toolbox
Robust Control Toolbox
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
Symbolic Math Toolbox
```
**2. For preprocessing (filtering) of data with fieldtrip:**
```matlab
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
```
**3. Spike Repository and with it a lot of spike analyses:**
```matlab
Communications Toolbox
Deep Learning Toolbox
Optimization Toolbox
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
```
**4. Wave_clus 3 Spike Sorting:**
```matlab
Image Processing Toolbox
Parallel Computing Toolbox
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
Wavelet Toolbox
```
**5. For everything else:**
```matlab
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
```

For more information how to install Matlab toolboxes:

https://de.mathworks.com/help/matlab/matlab_env/get-add-ons.html

If you want to extract .smrx files from Spike2, you additionally need to install the Spike2 MATLAB SON Interface from:

https://ced.co.uk/upgrades/spike2matson

When you extract .smrx for the first time, you are asked to select the folder 'CED64ML' that is created when installing the Spike2 MATLAB SON Interface which is necessary to read .smrx files. Once the path is set it is saved permanently, so you only have to do this once.

For how to install NEO and SpikeInterface refer to 'How to Install SpikeInterface for Spike Sorting in NeuroMod'

> ### **Overview of Other Toolboxes Used**

Spike Sorting with Mountainsort 5 and SpyKING CIRCUS 2 as well as raw recording data extraction of some formats are handled by python libraries, that are called and executed via custom python functions. More specifically, SpikeInterface for data extraction and spike sorting and NeuralEnsemble NEO for data extraction, which have to be installed manually but can then be used via NeuroMod without any coding. See below for more information.

Spike sorting with Mountainsort 5, SpykingCircus 2 as well as data extraction of Maxwell MaxOne MEA .h5 recordings are implemented in a custom python script executed via NeuroMod that uses the SpikeInterface library. 

Check out **SpikeInterface**: 

https://github.com/SpikeInterface/spikeinterface

Data extraction of Neuralynx, Open Ephys, Plexon, Blackrock and NeuroExplorer file formats is done via the NeuralEnsemble NEO python package and a custom python script, executed via NeuroMod.

Check out **NeuralEnsemble NEO**: 

https://neo.readthedocs.io/en/latest/index.html

Some aspects of data extraction and analysis are handled by the help of Matlab toolboxes, which do not have to be installed since the required functions are included in the source code (Data Path\Modules\Toolboxes). 

Specifically, data and event extraction of Neuralynx file formats (.ncs, .nve) is handled completely by Fieldtrip using the 'ft_read_data.m' and 'ft_read_header.m' functions. Moreover, Fieldtrip is used to for filtering data in the preprocessing window. Involved functions remained unchanged, there are just custom functions to coordinate them. 

Check out **Fieldtrip**: 

https://github.com/fieldtrip/fieldtrip

Data and event extraction of Open Ephys data formats is handled by the Open Ephys Matlab Tools via a custom compatibility function. The remaining toolbox functions remain unchanged. It is also used as the source for the read_npy.m function. 

Check out **Open Ephys Matlab Tools**: 

https://github.com/open-ephys/open-ephys-matlab-tools/tree/main

Spike Sorting for internally detected spikes (with thresholding) is done using the Wave_clus 3 Toolbox from Github and a custom compatibility function.

Check out the **Wave_clus 3 Toolbox**: 

https://github.com/csn-le/wave_clus?tab=readme-ov-file#wave_clus-3

Artefact Subspace Reconstruction is done using the Clean_rawdata EEGLAB plug-in from Github

Check out **Artefact Subspace Reconstruction Repository**: 

https://github.com/sccn/clean_rawdata

Endpoint Corrected Hilbert Transform calculation is handled using the echt.m function from the supplementary code from:

S. R. Schreglmann1*, D. Wang*, R. Peach*, J. Li, X. Zhang, E. Panella, 
       E. S. Boyden, M. Barahona, S. Santaniello, K. P. Bhatia, J. Rothwel, N. Grossman
       "Non-invasive Amelioration of Essential Tremor via Phase-Locked
       Disruption of its Temporal Coherence".

Brain Areas can be assigned to parts of the defined probe design using the Neuropixels trajectory explorer. The files remain unmodified and come with NeuroMod to be able to start the Trajectory explorer from GUI windows (Extract Raw Recordings window and Probe Layout window). Probe trajectories saved with the explorer can be loaded into the GUI to assign brain area labels to the probe). 

Check out **Neuropixels Trajectory Explorer**: 

https://github.com/petersaj/neuropixels_trajectory_explorer

**NOTE:** For the trajectory explorer to work you just need to download the Allen CCF mouse atlas and save it in the main directory of the GUI; available at:

https://osf.io/fv7ed/files/osfstorage

Saving the NeuroMod internal data structure in the .nwb (Neuroscience withouth borders) format is handled by the MatNWB toolbox via a custom compatibility function.

Check out **MatNWB**: 

https://github.com/NeurodataWithoutBorders/matnwb

Data and event extraction from raw TDT tank data recordings is done via the TDTMatlabSDK from GitHub using some compatibility functions.

Check out **TDTMatlabSDK**: 

https://github.com/tdtneuro/TDTMatlabSDK

Data extraction from raw Spike GLX files is handled using the SpikeGLX_Datafile_Tools GitHub repository.

Check out **SpikeGLX_Datafile_Tools**: 

https://github.com/jenniferColonell/SpikeGLX_Datafile_Tools

Lastly, some functions from the cortex-lab Github page were used ('Spikes' repository) for spike analysis and LFP Band power analysis. Almost all functions used are modified to make to fit the purpose of this GUI.

Check out the **Spikes repository from the Cortex-Lab**: 

https://github.com/cortex-lab/spikes

- Under NeuroMod_Path\Modules\MISC\LICENSES you can find the LICENSE and Citation files for those toolboxes.

> ### **How to Install SpikeInterface for Spike Sorting in NeuroMod**

*Tested and designed with SpikeInterface version 0.103.2*

First you have to install Python, Anaconda and Visual Studios C++ (during that install all C++ related options). After you done this, you have to type 'Anaconda Prompt' in your windows search bar and open the prompt window. To make sure there are no permission errors, set the anaconda prompt to open always with administrator rights (right-click, properties, security tab, give full control to user OR click on the compatibility tab and enable to execute it as an administrator). **Optional:** In the Anaconda Prompt, create a custom anaconda environment to install all the necessary packages in using this command: 'conda create --name YOURENVNAME python=3.10' (replace YOURENVNAME with the actual name you want to give that environment) (for comprehensive tutorials see Youtube or https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html). After creating the environment, activate it using 'conda activate <YourEnvironmentName>' and install the necessary packages using the following commands. Alternatively just copy-paste the commands in the anaconda prompt window as is, installing everything in the anaconda base environment. Which environment, the name of it and so on are not important, just that you know the name of the environment in which you installed everything.

When you get the error message 'pip not found as internal command' or similar first use:

```python
conda install pip
```

Then use these commands:

```python
pip install "spikeinterface[full]"
pip install --upgrade mountainsort5
python -m pip install kilosort[gui]
pip install spyking-circus
pip install Hdbscan
pip install sortingview
pip install spikeinterface[widgets]
pip install matplotlib ipympl ipywidgets
pip install PySide6 ephyviewer
conda install pyqt=5
pip install ephyviewer
pip install pyvips
pip install psutil
pip install scipy
pip install numba
pip install pyuac
pip install pypiwin32
pip install spikeinterface_gui
```

**Note:** When you get there error during the second or 5th command: Error executing cmd /u /c "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64 && set or something similar, you don't have the necessary C++ packages installed in Visual Studios. In doubt start the Visual Studios installer again, click to modify the installation and select everything that has to do with C++. In doubt manually download and install CMake from https://cmake.org/download/

**IMPORTANT:** When you execute SpikeInterface for the first time within NeuroMod, it will ask you for the path of a python.exe in the anaconda environment you installed the SpikeInterface packages in. If you haven't created a custom environment and just copy-pasted the pip command into the command window, you installed them in the anaconda base environment usually found at 'C:\ProgramData\anaconda3\python.exe'. If you've installed everything in a custom environment, you have to find the folder of this environment containing all installed packages, which also contains the python.exe. In doubt activate the environment (see above) and type in 'echo %CONDA_PREFIX%' to see the path for the python.exe. Also check if this folder contains a python.exe file! If not, try recreating the environment with 'conda create --name NEO python=3.10' after deleting it! In order to see a command window during spike sorting showing you the progress, you have to right click the python.exe, click on the compatibility tab and enable to execute it as an administrator! Otherwise there is a chance the command window won't open, but sorting is conducted anyway! You just don't know when it finishes or see potential error messages/warnings.

Selecting a valid python.exe file will save it's location in a .mat file in 'NeuroMod_Path/Modules/MISC/Variables (do not edit)/Python_Conda_Path.mat'. Each time you start NeuroMod, it searches for this file and checks whether the path saved within is valid. So if you move NeuroMod to a different PC with a different path to the python.exe, this file is deleted. However, if you should accidently give a path to the wrong python.exe, either delete this variable manually, or use the menu bar on top of the NeurMod main window. Select 'Extras', 'Delete Saved Paths' and click 'Python Path to Spikeinterface Environment' to delete it. When you want to conduct spike sorting afterwards, you are asked again for a new location of the python.exe.
The same holds true for the path to the Spike2 CEDS64ML folder when you want to load Spike2 recordings and to the pthon.exe for using the NeuralEnsemble NEO library.

To load sorting results from SpikeInterface spike sorting INTO NeuroMod that you created with your own code or the respective package GUI's OUTSIDE of NeuroMod (like the Kilosort GUI), you need to save the results as .npy files for example with the export_to_phy function (like the native Kilosort output) and you additionally need to save a SpikePositions.mat file saving the spike locations from the SpikeInterface analyzer object of your sorting. Additionally, you need to save a max_template_channel_index.npy file with the maximum template channel for each cluster. Here is an example code how to get this information in SpikeInterface: 

SpikePositions.mat:

```python
compute_dict = {
        .......
        'spike_locations':{},
        ......
    }
analyzer.compute(compute_dict)
ext_SpikeLocations = Analyzer.get_extension("spike_locations")
SpikePositions = ext_SpikeLocations.get_data()
savemat('YourFolder', mdic)
export_to_phy(sorting_analyzer=Analyzer, output_folder=PathForPhy, copy_binary=False)
```

```python
templates = Analyzer.get_extension("templates").get_data()
PeakToPeak = templates.ptp(axis=1)              
max_chan_idx = np.argmax(PeakToPeak, axis=1)   
np.save(PathForPhy, max_chan_idx)

```

Note: PathForPhy is the sorter output folder containing all .npy sorter results.


> ### **How to Install NeuralEnsemble NEO to extend supported file formats in NeuroMod**
>
To install the NEO python package, you have to follow the same steps as described in the first paragraph about the installation of SpikeInterface. So install the necessary programs, create a Anaconda environment and activate it. The type in the following command to install NEO:

*Tested and designed with neo version 0.14.3*

```python
pip install neo[nixio,tiffio]
pip install pynwb
pip install scipy
pip install matplotlib
pip install pyuac
```
For more information visit: https://neo.readthedocs.io/en/latest/install.html

**IMPORTANT:** When you execute NEO for the first time within NeuroMod, it will ask you for the path of a python.exe in the anaconda environment you installed the NEO in. If you haven't created a custom environment and just copy-pasted the pip command into the command window, you installed them in the anaconda base environment usually found at 'C:\ProgramData\anaconda3\python.exe'. If you've installed everything in a custom environment, you have to find the folder of this environment containing all installed packages, which also contains the python.exe. In doubt activate the environment (see above) and type in 'echo %CONDA_PREFIX%' to see the path for the python.exe. Also check if this folder contains a python.exe file! If not, try recreating the environment with 'conda create --name NEO python=3.10' after deleting it! In order to see a command window during spike sorting showing you the progress, you have to right click the python.exe, click on the compatibility tab and enable to execute it as an administrator! Otherwise there is a chance the command window won't open, but data extraction is conducted anyway! You just don't know when it finishes or see potential error messages/warnings.

Selecting a valid python.exe file will save it's location in a .mat file in 'NeuroMod_Path/Modules/MISC/Variables (do not edit)/NEO_Python_Conda_Path.mat'. Each time you start NeuroMod, it searches for this file and checks whether the path saved within is valid. So if you move NeuroMod to a different PC with a different path to the python.exe, this file is deleted. However, if you should accidently give a path to the wrong python.exe, either delete this variable manually, or use the menu bar on top of the NeuroMod main window. Select 'Extras', 'Delete Saved Paths' and click 'Python Path to NEO Environment' to delete it. When you want to use NEO again afterwards, you are asked again for a new location of the python.exe.

> ### **How to Install Phy to Open via NeuroMod**

Follow the instructions to install Phy from https://github.com/cortex-lab/phy by either using the commands they provide or by installing the environment.yml. Also see instructions for installing SpikeInterface and Neo. In either case you should only install it in an environment separate to the others, since it needs legacy versions of numpy and joblib.

When you should get the error: 12:23:18.933 [E] __init__:62 An error has occurred (TypeError): Memory.__init__() got an unexpected keyword argument 'bytes_limit' OR TypeError: Memory.__init__() got an unexpected keyword argument 'bytes_limit' you have to enter this in your anaconda prompt after activating your Phy environment:

*Tested and designed with Phy version 2.0b6*

```python
pip install joblib==1.2.0 (works up to joblib==1.3.1 ?!) 
```

In doubt also check your antivirus program, it can sometimes put the environmental python.exe into quarantine. 

After successful installation you can now view and curate spike sorting results by using the 'Load Spike Sorting Window' in NeuroMod.

**IMPORTANT:** When trying to start Phy for the first time, you are being asked for the path to a python.exe of the environment you installed Phy to. This is the same principle as for NEO and SpikeInterface and the path will be saved after selection for later use. If you installed Phy using the environment.yml, your environment will be called phy2.

**Information:** You can load spike sorting results from Mountainsort 5 and Spyking Circus 2 with the SpikeInterface GUI too. However, this is done in the 'Spike Detection and Sorting' window by changing the spike sorting parameter. Activate the checkboxes to open the SpikeInterface GUI and optionally to load spike sorting results to not have to wait for the spike sorting itself to finish again.

> ### **How to load Maxwell Biosystems MaxOne MEA h5 files**
>
In order to be able to extract MEA .h5 data files in any library you have to 'install' a .dll file provided by Maxwell biosystems by adding it to the environmental variables in windows. Follow the instructions provided here: https://share.mxwbio.com/d/5b5017febe354c8e942a/files/?p=%2FMxW%20-%20Installing%20the%20Decompression%20Library%20to%20load%20MaxLab%20Live%20Recordings.pdf

Besides this you need to install SpikeInterface in an anaconda environment. Follow instructions above how to do that, it will work for Maxwell MEA data extraction as well. When you select a recording and extract it, you are being asked for the python.exe file in the anaconda environment you installed SpikeInterface in.

> ### **About Performance**
> 
Everything was developed and tested with the following system: AM5 platform; CPU: AMD Ryzen 7 7800X3D, 32GB 4600Mhz DDR5 Ram, 1TB SSD, NVIDIA GeForce GTX 1660 and B650 AORUS ELITE AX mainboard. Since all relevant GUI information (raw and preprocessed data, spikes, event related data etc.) are saved in RAM, it is recommended to have at least 32GB of RAM. This allows to comfortably do everything with recording lengths of up to 600 seconds and 32 channel. 

The main window plot runs in 'Movie' mode with 1 seconds time range, 64 channel and 30000 Hz sample rate at 40-50 frames a second (without spike or event plots activated). If you have a comparable system but worse performance, check the Matlab graphics renderer by typing in the Matlab command window: info = rendererinfo. It should show something similar to:

```python
GraphicsRenderer: 'OpenGL Hardware'
          Vendor: 'NVIDIA Corporation'
         Version: '4.6.0 NVIDIA 560.94'
  RendererDevice: 'NVIDIA GeForce GTX 1660/PCIe/SSE2'
         Details: [1×1 struct]
```

When saving your dataset for later use in NeuroMod, channel data is saved as a .dat file in binary format independent of the format of the original dataset. This saves not only memory, but also enables to load the raw and preprocessed dataset within seconds (given they are saved on a SSD) and is faster than loading the NEO.mat file or .nwb files you can save in NeuroMod. Only loading data saved in NeuroMod for later use in SpikeInterface and saved during the data extraction from a raw recording with NEO can be loaded back into NeuroMod as fast, but not with all dataset components present (like spike data).

> ### **General Remarks**

If you want to update fieldtrip or one of the other tools available on Github, there are several things to consider:
- First some files of those tools are modified to fit the purpose of this GUI. You cant simply replace them. When you just update the not modified files, there is no guarantee that they will be compatible with the modified files.
- Second, some tools saved in the folders of this GUI like fieldtrip do not contain all files. This has to do with compatibility errors with other tools, specifically the open ephys tools which won't work with all fieldtrip files in the GUI directory.
- If you encounter errors or things I missed, have questions or want to incorporate one of the tools more in depth, please don't hesitate to contact me.

> ## **Nomenclature**

<u>Raw Recording</u>: Original recording files created by the respective recording software.

<u>Events</u>: Input signals into the recording system representing external stimuli, like a tones being played, behavioral responses etc. Can contain multiple continuous signals or multiple sets of discrete time points.

<u>Event Channel Type</u>: Types of event input signals, which depending on the recording system can be for example digital, analog or auxiliary channel in case of Intan recordings or recording nodes in case of Open Ephys recording. Each type can contain multiple individual event channel.

<u>Event Channel</u>: A single continuous event signal or set of discrete time points describing one (and the same) kind of external stimulus (like a tone being played). One event channel type can contain multiple event channel, each describing a certain type of external stimulus.

<u>Trigger</u>: Exact time points in each event input channel at which an external stimuli is happening. If the event signal is composed of discrete time points, triggers are equal to these time points. With a continuous event input signal, triggers are time points at which the event signal exceeds a certain threshold.

<u>Trials</u>: Data in a time range around each trigger (before and after).
Live Window: Window that updates along with the main window data plot, showing an analysis of the data plotted in the main window (if coupling to the main window time is enabled in the respective window).

<u>Event related</u>: Data of all trials. Event related analysis is therefore the same as trial analysis.


> ## **Rules and Philosophy**
> 
- First off: this toolbox is not trying the reinvent the wheel. Rather it takes already established and proven analysis solutions like SpikeInterface, NEO and Kilosort and integrates them into a central hub aiming to bring LFP and spike analysis as well as signal quality measures together in a way, that everyone - including students and beginners can comfortably use it. 
- All relevant analysis and data parts are saved in a single structure with a limited and clear amount of fields that every window shares. Changes in one window are automatically available in another window if its contents are updated.
- All interactive parts like buttons, checkboxes and so on that are disabled (grey and cant be clicked on) can be activated by conducting the necessary analysis step before.
- If the user tries to do an analysis without proper preprocessing or enters a wrong format into any field requiring user input, values are either autocorrected and/or the user gets a message why the operation is not possible. The aim is to give an explanation of what to do when an error occurs, not just what the error is.
- In every window that loads or saves some kind of data, a standard folder will be auto-set for files with the proper format and additional information to show. I.e. when opening the 'Event Extraction' window, it will auto-search the recording path raw data was extracted from for files holding event data and in the case of some recording formats show trigger information like time stamps. The same holds true for saving and loading spike sorting data from any of the supported sorters. When saving your dataset for spike sorting in the folder suggested and sort it, NeuroMod will automatically recognize the spike sorting results for a one-click load in the 'Load Spike Sorting' window (it searches for the standard output file names of those sorters in the standard location they save results in). However, you can also always select a folder manually that will be searched through for results as well. To make your live easier, consider leaving the standard file names and locations created throughout your analysis. 
- All functions are designed in a way that they can be used outside of the user interface with just a few support functions, including all visualizations. This enables the 'Autorun' functionality of the GUI, where you can apply all analysis and plots in a loop to several recordings.

> ## **Disclaimer, License and Contact**
This toolbox was created and is maintained by a single person as part of a PhD project and hobby. There is no guarantee for any of the analysis and results but dedication to fix bugs and evolve this.
Feel free to contact me for tips and requests or pull a request/open an issue on Github.
