# Neuromod - Fully Interactive Ephys Data Analysis <br> and Visualization for Matlab <img src="Modules/MISC/Images/Logo.png" align="right" width="200" height="200"/>

Ever wanted to watch an almost psychedelic video of your recording data in front of you,
alligned to a three dimensional plot of the current source density while ordering a second monitor the be able to compare spike analyis to it? Then you are perfectly right!

Neuromod is an interactive toolbox for analyzing and visualizing electrophysiological data from linear probe recordings. 
It seamlessly integrates established methods and toolboxes, such as Kilosort and Fieldtrip, to offer a wide range of analyses and support for various data formats, all with prooven methods and without reinventing the wheel. 
The aim is to offer a comfortable and user-friendly experience with support for many of the most popular recording formats, while providing clear instructions and feedback on actions taken, rather than hard-to-interpret error messages or opaque processes that leave users uncertain about what was done to their data.

## **Data Formats and Capabilities**
The toolbox currently supports recordings from linear probes across all Intan systems formats (.dat and .rhd), all Open Ephys formats (.dat, .nwb, .continuous), as well as Spike2 (.smrx), Neuralynx (.ncs), and Plexon (.plx) files.
In addition to raw data, the GUI also supports event data (e.g., TTL signals to the recording system), enabling not only the preprocessing, analysis, and visualization of continuous data but also event-related data using a variety of methods.

Available types of analysis include current source density analysis, static power spectrum analysis, time-frequency power analysis, and event-related potentials for low-frequency signal components.
Additionally, the toolbox fully supports Kilosort 4, allowing users to save data, create channel maps, and load Kilosort result files for interactive spike data visualization within the GUI.
If Kilosort can’t be used, the toolbox also offers spike detection using different thresholding methods. 

 <img src="Modules/MISC/Images/Example_Image_1.jpg" align="right" width="550" height="350"/>

The toolbox currently supports recordings from linear probes across all Intan recording systems formats (.dat and .rhd), all Open Ephys formats (.dat, .nwb, .continuous), as well as Spike2 (.smrx), Neuralynx (.ncs), and Plexon (.plx) files.
In addition to raw data, the GUI also supports event data (e.g., TTL signals to the recording system), enabling not only the preprocessing, analysis, and visualization of continuous data but also event-related data using a variety of methods.

Available types of analysis include current source density analysis, static power spectrum analysis, 
time-frequency power analysis, and event-related potentials for low-frequency signal components.
Additionally, the toolbox fully supports Kilosort 4, allowing users to save data and create channel maps for Kilosort 
and load Kilosort result files for interactive spike data visualization and analysis.

__NOTE:__ Currently only Kilosort 4 versions up to 4.0.8 are supported due to a bug in which one of the kilosort .npy output files apparently doesnt contain the expected header. When you already install a newer version, install legacy version by typing in your anaconda promt: 
```python
conda activate kilosort
```
```python
python -m pip install "kilosort[gui]"==4.0.8
```

For a guide how to installed Kilosort 4 and for more information visit:

https://github.com/MouseLand/Kilosort

If Kilosort can’t be used, the toolbox offers spike detection using different 
thresholding methods as well. 
This variety along with the simultaneous real time plotting of results provide several possibilities to correlate spike and LFP data along with dedicated spike triggered average analysis.

Nearly all parameters related to data extraction and analysis are automatically set, but can still be adjusted within the GUI.
This design ensures a smooth, code-free user experience, offering helpful guidance and full control over the analysis.
Besides the analysis of a single recording with the user interface, this toolbox includes an autorun functionality that applies selected methods to all recordings in a file, automatically saving all possible visualizations based on a single Config file with a few options to specify (see below).
As a result, Neuromod is not only ideal for teaching and evaluating recording quality before or after sessions but also for comprehensive data analysis of one or multiple recordings. 
This design ensures a smooth, code-free user experience, offering helpful guidance while having full control over the analysis at the same time.
Besides the analysis of a single recording with the user interface, this toolbox includes an autorun functionality that applies 
selected methods to all recordings in a file, automatically saving all visualizations possible in the user interface based on a single config file with a few options to specify.
As a result, Neuromod is not only ideal for teaching purposes or evaluating recording quality before and after sessions, but also for comprehensive data analysis of multiple recordings. 

Another feature making this user intrerface attractive for your data analysis is the ability to easily add your own data analysis to integrate it into the rest of your analyiss pipeline. 
All you have to do is to follow this link and watch a short tuorial how to create your own app window, integrate it into the rest of the GUI, giving fully real time control over all parts of the data:
LINK TO YOUTUBE TUTORIAL

<br>
<table>
  <tr>
    <td><img src="Modules/MISC/Images/Example_Image_3.jpg" width="450" height="350"/></td>
    <td><img src="Modules/MISC/Images/Example_Image_2.jpg" width="550" height="350"/></td>
  </tr>
</table>

## **How to use the GUI** ##

- Download and unpack the toolbox files and execute them with an installed and veryfied Matlab version. Now you can eihter double click the Neuromod_Toolbox_GUI.mlapp file, which opens Matlab and subsequently the GUI. You can also 'cd' into the folder you saved the files at with the matlab command window, right click the Neuromod_Toolbox_GUI.mlapp file in the current folder window and click on run. The last option is to type the following into the matlab command window while being in the folder containing the GUI:

```matlab
Neuromod_Toolbox_GUI
```

- Along with Matlab you need the following Matlab Toolboxes for unrestricted functionality:

```matlab
Communications Toolbox
Database Toolbox
Deep Learning Toolbox
Fixed Point Designer
Fuzzy Logic Toolbox
Image Processing Toolbox
Optimization Toolbox
Robust Control Toolbox
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
Symbolic Math Toolbox
```

**Note:**
Some of those Matlab toolboxes are required for fieldtrip, the open ephys analysis tool or some other Github repositories used and are therefore not necessary in every circumstance.
Additionally, only portions of the respective tools and repositories are used, which might make some Matlab toolboxes unnecessary. 

Here is a rough overview for what you need what toolboxes:

**1. To extract Neuralynx or Plexon data, you need:**
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
**4. For everything else:**
```matlab
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
```

For more information how to install Matlab toolboxes:

https://de.mathworks.com/help/matlab/matlab_env/get-add-ons.html

If you want to extract .smrx files from Spike2, you need to install the Spike2 MATLAB SON Interface from:

https://ced.co.uk/upgrades/spike2matson

When you extract .smrx for the first time, you are asked to select the folder in which you installed the Spike2 MATLAB SON Interface to be able to use the library. The path is saved permanently, so you only have to do this once.

**General Remark:**
If you want to update fieldtrip or one of the other tools available on Github, there are several things to consider:
- First some files of those tools are modified to fit the purpose of this GUI. You cant simply replace them. They are saved in GUI_Path\Modules\Toolboxes\5. Modified\ . When you just update the not modified files, there is no guarantue that they will be compatible with the modified files.
- Second, some tools saved in the folders of this GUI like fieldtrip do not contain all files. This has to do with compatitbility errors with other tools, specifcally the open ephys tools. For some reason I dont know, the open ephys tool wont work with all fieldtrip files in the GUI directory.
- If you encounter errors or things I missed, have questions or want to incorpaorate one of the tools more in depth, please dont hesitate to contact me.

**Autorun Functionality**
- If you have multiple recordings and want to apply a fixed analysis pipeline using the GUI, you can automate the process with the Autorun function. This feature eliminates the need to manually navigate the GUI for each recording. Instead, it automatically processes each recording, applying all the data extraction, processing, and analysis steps offered by the GUI while being independent from it. All visualizations and analysis specified are then saved automatically in the respective recording folder.
- You can modify the specific processing steps and parameters using the configuration file located in GUI_Path\Autorun_Configs\Config_Files(do not edit!). However, there’s no need to navigate to this directory or make manual changes, as everything is managed through the Autorun Manager Window. You can access this window from the menu in the top left corner of the GUI’s main window. Simply start the GUI and open the Autorun Manager—no additional steps are required.
- In the Autorun Manager, you can select a configuration file to open directly within the GUI or in MATLAB for editing. To help you get started, a template configuration file is available for each recording system.
- Once you are satisfied with the configuration file, select a folder containing your recording(s), specify your probe properties (channel spacing and optionally channel order) and start the pipeline. The pipeline will run through and give messages about the progress in the matlab command window.
- For more information, see the documentation:
  
[NeuroMod Toolbox Manual](NeuroMod_Toolbox_Manual.docx)

## **Rules and Philosophie of the Toolbox**
- First off: this toolbox is not trying the reinvent the wheel. Rather it takes already established and proven analysis solutions like Kilosort and integrates them into a central hub aiming to bring LFP and spike analysis as well as signal quality measures together in a way, that everyone with (almost) every recording type can use it. 
- All relevant analysis and data parts are saved in a single structure with a limited and clear amount of fields that every window shares. Changes in one window are automatically available in another window.
- All interactive parts like buttons, checkboxes and so on that are disabled (grey and cant be clicked on) can be activated by conducting the necessary analysis step before. For example, to enable to ‘Event Data’ checkbox on the right of the main window, you first have to extract events. 
- If the user tries to do an analysis without proper preprocessing or enters a wrong format into any field requiring user input, values are either autocorrected and/or the user gets a message why the operation is not possible. The aim is to give an explanation of what to do when an error occurs, not only throw out an error nobody understands. 
- In every window were you select a folder to load and some information about folder or data contents are shown, the folders were autosearched for the expected contents. If no expected contents were found, the user gets a message that nothing was found and has to select himself. This means that when you see information there, everything goes well. 
- All functions are designed in a way that they can be easily used outside of the user interface with just a few support functions, including all visualizations. This enables the Autorun functionality of the GUI, where you can apply all analysis and plots in a loop to several recordings.

> ## **Disclaimer**
This toolbox was created and is maintained by a single person as part of a PhD Project and Hobby. There is no guarantee for any of the analysis and results but dedication to fix bugs and evolve this.
Feel free to contact me for tips and requests or pull a request/open an issue on Github. I try to get around all of them and provide guidance and help. 
