# Neuromod - Fully Interactive Ephys Data Analysis <br> and Visualization for Matlab <img src="Modules/MISC/Images/Logo.png" align="right" width="200" height="200"/>

Ever wanted to watch an almost psychedelic video of your recording data in front of you,
alligned to a three dimensional plot of the current source density while ordering a second monitor the be able to compare spike analyis to it? Then you are perfectly right!

Neuromod is an interactive toolbox for analyzing and visualizing electrophysiological data from linear probe recordings. 
It seamlessly integrates established methods and toolboxes, such as Kilosort and Fieldtrip, to offer a wide range of analyses and support for various data formats, all with prooven methods and without reinventing the wheel. 
The aim is to offer a comfortable and user-friendly experience with support for many of the most popular recording formats, while providing clear instructions and feedback on actions taken, rather than hard-to-interpret error messages or opaque processes that leave users uncertain about what was done to their data.

## **Data Formats and Capabilities**
 <img src="Modules/MISC/Images/Example_Image_1.jpg" align="right" width="550" height="350"/>
The toolbox currently supports recordings from linear probes across all Intan recording systems formats (.dat and .rhd), all Open Ephys formats (.dat, .nwb, .continuous), as well as Spike2 (.smrx), Neuralynx (.ncs), and Plexon (.plx) files.
In addition to raw data, the GUI also supports event data (e.g., TTL signals to the recording system), enabling not only the preprocessing, analysis, and visualization of continuous data but also event-related data using a variety of methods.
<br>

Available types of analysis include current source density analysis, static power spectrum analysis, 
time-frequency power analysis, and event-related potentials for low-frequency signal components.
Additionally, the toolbox fully supports Kilosort 4, allowing users to save data and create channel maps for Kilosort 
and load Kilosort result files for interactive spike data visualization and analysis.
<br>
<br>
__NOTE:__ Currently only Kilosort 4 versions up to 4.0.8 are supported due to a bug of the read npy toolbox. Install legacy version by typing in your anaconda promt: conda activate kilosort; python -m pip install "kilosort[gui]"==4.0.8
<br>
<br>
If Kilosort can’t be used, the toolbox offers spike detection using different 
thresholding methods as well. 
This variety along with the simultaneous real time plotting of results provide several possibilities to correlate spike and LFP data along with dedicated spike triggered average analysis.
<br>
<br> 
Nearly all parameters related to data extraction and analysis are automatically set, but can still be adjusted within the GUI.
This design ensures a smooth, code-free user experience, offering helpful guidance while having full control over the analysis at the same time.
Besides the analysis of a single recording with the user interface, this toolbox includes an autorun functionality that applies 
selected methods to all recordings in a file, automatically saving all visualizations possible in the user interface based on a single config file with a few options to specify.
As a result, Neuromod is not only ideal for teaching purposes or evaluating recording quality before and after sessions, but also for comprehensive data analysis of multiple recordings. 
<br> 
Abother feature making this user intrerface attractive for your data analysis is the ability to easily add your own data analysis to integrate it into the rest of your analyiss pipeline. 
All you have to do is to follow this link and watch a short tuorial how to create your own app window, integrate it into the rest of the GUI, giving fully real time control over all parts of the data:
LINK TO YOUTUBE TUTORIAL

<table>
  <tr>
    <td><img src="Modules/MISC/Images/Example_Image_3.jpg" width="450" height="350"/></td>
    <td><img src="Modules/MISC/Images/Example_Image_2.jpg" width="550" height="350"/></td>
  </tr>
</table>



## **How to use**

There are two ways to use this toolbox: 
- Either you download all the files as they are, unpack them and double click in the windows file explorer on the app file (or right click in matlab current folder window and click on run).
However, this requires a valid Matlab license.
- Or you download the standalone version of this app, which you can execute without a valid Matlab license by just installing the Matlab runtime.
- The code was written in Matlab Version 2023 and 2024. There is no guarantue for other Verions. It requires the following Matlab addons: Signal Processing Toolbox
- To extract Spike2 .smrx files and use Kilosort you need to install the respective libraries /toolboxes yourself. However, once you done that the integration in this toolbox is seamless.
They can be found here: 


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

> ## **How to cite**
de Schultz T., Lippert M, Ohl F., 2024, Neuromod - Fully Interactive Ephys Data Analysis and Visualization for Matlab
> ## **License**
This project is licensed under the terms of the MIT license.
