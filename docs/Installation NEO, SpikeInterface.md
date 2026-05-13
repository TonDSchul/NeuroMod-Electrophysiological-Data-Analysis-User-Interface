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

**NOTE:** When you get there error during the second or 5th command: Error executing cmd /u /c "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64 && set or something similar, you don't have the necessary C++ packages installed in Visual Studios. In doubt start the Visual Studios installer again, click to modify the installation and select everything that has to do with C++. In doubt manually download and install CMake from https://cmake.org/download/

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

**NOTE:** PathForPhy is the sorter output folder containing all .npy sorter results.


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
