# -*- coding: utf-8 -*-
"""
Created on Sat Nov 30 21:16:20 2024

@author: tonyd
"""

import spikeinterface.full as si
import spikeinterface.preprocessing as spre
import spikeinterface.sorters as ss
import spikeinterface.widgets as sw

import numpy as np

from probeinterface import Probe
from probeinterface.plotting import plot_probe
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
#from kilosort import io
import time
import inspect
import os
import shutil
from scipy.io import savemat


""" ################################################################ Load Binary file Function ####### """
def Load_Binary_In_SpikeInterface(file_path,sampling_frequency,num_channels,Sorter,CompletePath):
    
    num_channels = int(num_channels)

    print("Reading .bin file")
    """  Define recording parameters """

    print(file_path)

    if Sorter in ['Kilosort 4']:
        dtype = "int16"  # MATLAB's double corresponds to Python's float64
        """  Load data using SpikeInterface """
        recording = si.read_binary(file_paths=file_path, sampling_frequency=sampling_frequency,
                                   num_channels=num_channels, dtype=dtype)
    else:
        
        dtype = "float64"  # MATLAB's double corresponds to Python's float64
        """  Load data using SpikeInterface """
        recording = si.read_binary(file_paths=file_path, sampling_frequency=sampling_frequency,
                                   num_channels=num_channels, dtype=dtype)
        
    recording.annotate(is_filtered=False)
    
    return recording 

""" ################################################################ Generate Probe Desing ####### """
def Create_Probe(num_elec,ypitch,PlotTraces,RowOffsetDistance,RowOffset,NumberRows,HorChannelOffset,VerChannelOffset,Recording,AllChannel,ActiveChannel,Xcoords,Ycoords,RecordingType):
        
    print("Creating and attaching Probe")
    '''
    if RecordingType == "SpikeInterface Maxwell MEA .h555":
        xcoordsvec = np.array([float(v) for v in Xcoords.split(',')])
        ycoordsvec = np.array([float(v) for v in Ycoords.split(',')])
        total_nb_channels = len(xcoordsvec)
        
        # Create probe object
        probe = Probe(si_units='um')
                
        # Add all contacts at once using numpy arrays
        positions = np.column_stack((xcoordsvec, ycoordsvec))  # x, y, z=0
        probe.set_contacts(positions=positions, shapes='circle', shape_params={'radius': 10})
        probe.set_device_channel_indices(np.arange(len(xcoordsvec)))
        
    else:
    '''
    positions = np.zeros((AllChannel * NumberRows, 2))
    
    xcoordsvec = np.array([float(v) for v in Xcoords.split(',')])
    ycoordsvec = np.array([float(v) for v in Ycoords.split(',')])

    positions[:len(ycoordsvec), 0] = xcoordsvec
    positions[:len(ycoordsvec), 1] = ycoordsvec
    
    print("Probe Channel Locations (x and y in um):")
    print(positions)
    ############################################################################################
    # -------------------------------------- Define Channel IDs --------------------------------------
    ############################################################################################
    # all nan except of active channel from 0 to length active channel at correct vector position corresponding to active channel
    device_mapping = np.full(AllChannel * NumberRows, np.nan, dtype=float)
    #create active channel vector with ints from comma separate string
    ActiveChannelVec = np.fromstring(ActiveChannel, sep=',', dtype=int)
    # set active channel to not nan
    for i, ch in enumerate(ActiveChannelVec):
        device_mapping[ch] = i
            
        ############################################################################################
        # -------------------------------------- Create Probe, Add Channel IDs --------------------------------------
        ############################################################################################
        
        # create an empty probe object with coordinates in um
        probe = Probe(ndim=2, si_units='um')
        # set contacts
        probe.set_contacts(positions=positions, shapes='circle',shape_params={'radius': 10})
        
        probe.set_device_channel_indices(device_mapping)
        probe.set_contact_ids(np.arange(AllChannel * NumberRows))  # ← must match positions length
    
    ############################################################################################
    # -------------------------------------- Plot Probe --------------------------------------
    ############################################################################################
    if PlotTraces == 1:
        print("Plotting Probe...")
        # Create a color list: red for active, blue for inactive
        colors = ['red' if not np.isnan(ch) else 'blue' for ch in device_mapping]
        
        # Plot probe with custom colors
        plot_probe(probe, with_contact_id=True, contacts_colors=colors)
        
        # Create legend handles
        active_patch = mpatches.Patch(color='red', label='Active Channel')
        inactive_patch = mpatches.Patch(color='blue', label='Inactive Channel')
        
        # Add legend
        plt.legend(handles=[active_patch, inactive_patch], loc='upper right')
        plt.show()
            
    #if RecordingType != "SpikeInterface Maxwell MEA .h5":
    probe.to_dataframe(complete=True).loc[:, ["shank_ids", "device_channel_indices"]]
    
    Recording = Recording.set_probe(probe)
    
    return probe

""" ################################################################ Preprocessing ####### """
def Preprocessing(Recording,Probe,Apply_Preprocessing):
    
    PreProRecording = spre.bandpass_filter(recording=Recording, freq_min=300, freq_max=3000, dtype=np.float64)
    PreProRecording = spre.common_reference(recording=PreProRecording, dtype=np.float64)
                
    PreProRecording = PreProRecording.set_probe(Probe)
    
    PreProRecording.annotate(is_filtered=True)
        
    return PreProRecording
    
""" ################################################################ Subplot ####### """

def combined_plot(recording,PreproRecording,ypitch):
   
    # Create a figure with two subplots
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6))  # Two rows, one column
    
    # Redirect plots to the first axes
    plt.sca(ax1)  
    sw.plot_traces(recording,  backend="matplotlib",ax=ax1,channel_ids=recording.channel_ids[:32],time_range=(0, 4.0))  
    
    # Redirect plots to the second axes
    plt.sca(ax2) 
    sw.plot_traces(PreproRecording,  backend="matplotlib",ax=ax2,channel_ids=recording.channel_ids[:32],time_range=(0, 4.0))  
    
    # Adjust layout to make the subplots look better
    plt.tight_layout()
    plt.show()
    
""" ################################################################ SpikingCircus2 ####### """
def SortWithSpikingCircus(recording,Sorting_output_folder,Apply_Preprocessing,SortingParameter):
    
    print("Starting Spike Sorting with SpikingCircus 2")
    
    """"Parallel Processing"""
    global_job_kwargs = dict(n_jobs=4, chunk_duration="1s")
    si.set_global_job_kwargs(**global_job_kwargs)

    default_SC2_params = ss.Spykingcircus2Sorter.default_params()
        
    costum_SC2_params = update_standards(default_SC2_params, SortingParameter)
    
    # If it exists inside 'merging', remove it
    if 'merging' in costum_SC2_params and 'auto_merge' in costum_SC2_params['merging']:
        del costum_SC2_params['merging']['auto_merge']

    if 'merging' in costum_SC2_params and 'correlograms_kwargs' in costum_SC2_params['merging']:
        del costum_SC2_params['merging']['correlograms_kwargs']
    
    if Apply_Preprocessing == 1:
        costum_SC2_params['apply_preprocessing'] = False
        print("No Prepro in SC2")
    else:
        costum_SC2_params['apply_preprocessing'] = True
        print("Prepro in SC2")
    
    print("Costum_SC2_params:")
    print(costum_SC2_params)
    
    argname = get_run_sorter_folder_arg()

    kwargs = {
        "sorter_name": "spykingcircus2",
        "recording": recording,
        argname: Sorting_output_folder,   # dynamically insert correct key
        "remove_existing_folder": True,
        **costum_SC2_params
    }
    
    sorting_SC = ss.run_sorter(**kwargs)
    
    return sorting_SC 

""" ################################################################ MountainSort 5 ####### """
def SortWithMountainSort(recording,Sorting_output_folder,Apply_Preprocessing,SortingParameter):
    
    print("Starting Spike Sorting with Mountainsort5")
    
    """"Parallel Processing"""
    global_job_kwargs = dict(n_jobs=4, chunk_duration="1s")
    si.set_global_job_kwargs(**global_job_kwargs)
    
    default_MS5_params =  si.get_default_sorter_params('mountainsort5')
  
    Costum_MS5_params = update_standards(default_MS5_params, SortingParameter)
    
    """ 100 um  
    default_MS5_params['scheme2_training_duration_sec'] = 30
    default_MS5_params['scheme3_block_duration_sec'] = 50
    default_MS5_params['scheme1_detect_channel_radius'] = 50
    default_MS5_params['scheme2_phase1_detect_channel_radius'] = 100
    default_MS5_params['scheme2_max_num_snippets_per_training_batch'] = 100
    default_MS5_params['snippet_mask_radius'] = 50
    """
    
    """50 um
    default_MS5_params['scheme2_training_duration_sec'] = 30
    default_MS5_params['scheme3_block_duration_sec'] = 50
    default_MS5_params['scheme1_detect_channel_radius'] = 150
    default_MS5_params['scheme2_phase1_detect_channel_radius'] = 200
    default_MS5_params['scheme2_max_num_snippets_per_training_batch'] = 100
    default_MS5_params['snippet_mask_radius'] = 50
    default_MS5_params['filter'] = False
    default_MS5_params['detect_threshold'] =5 
    """
    
    if Apply_Preprocessing == 1:
        Costum_MS5_params['filter'] = False
        print("No Prepro in MS5")
    else:
        Costum_MS5_params['filter'] = True
        print("Prepro in MS5")
        
    print("Costum_MS5_params:")
    print(Costum_MS5_params)
    
    print(Costum_MS5_params.keys())
    
    # get the keyword for the current spikeinterface api signature
    argname = get_run_sorter_folder_arg()

    kwargs = {
        "sorter_name": "mountainsort5",
        "recording": recording,
        argname: Sorting_output_folder,   # dynamically insert correct key
        "remove_existing_folder": True,
        **Costum_MS5_params
    }
    
    sorting_MS5 = ss.run_sorter(**kwargs)

    return sorting_MS5

""" ################################################################ Kilosort 4 ####### """
def SortWithKilosort(recording,Sorting_output_folder,Apply_Preprocessing,SortingParameter):
        
    print("Starting Spike Sorting with Kilosort 4")
    
    """"Parallel Processing"""
    global_job_kwargs = dict(n_jobs=4, chunk_duration="1s")
    si.set_global_job_kwargs(**global_job_kwargs)
    
    default_KS4_params = ss.Kilosort4Sorter.default_params()
    
    costume_KS4_params = update_standards(default_KS4_params, SortingParameter)
    
    if Apply_Preprocessing == 1:
        costume_KS4_params['skip_kilosort_preprocessing'] = False
        print("No Prepro in KS4")
    else:
        costume_KS4_params['skip_kilosort_preprocessing'] = False
        print("Prepro in KS4")
    
    print(costume_KS4_params)
    
    if not os.path.exists(Sorting_output_folder):
        os.makedirs(Sorting_output_folder)
    os.chdir(Sorting_output_folder)
    
    sortingKS4 = ss.run_sorter(sorter_name='kilosort4', **costume_KS4_params, recording=recording, remove_existing_folder=True)
    return sortingKS4
    
""" ################################################################ Sorting Analyzer ####### """
def CreateSortingAnalyzer(recording,sorting,Save_Sorting_Folder,LoadRecording):
    
    analyzer = si.create_sorting_analyzer(sorting=sorting, recording=recording, format="memory", folder='None')
    print(analyzer)

    # which is equivalent to this:
    job_kwargs = dict(n_jobs=1, chunk_duration="1s", progress_bar=True)
    
    if LoadRecording == 1:
        compute_dict = {
            'random_spikes': {'method': 'uniform', 'max_spikes_per_unit': 500},
            'waveforms': {'ms_before': 2.0, 'ms_after': 2.0},
            'templates': {'operators': ["average", "median", "std"]},
            'noise_levels':{},
            'correlograms':{'window_ms':100, 'bin_ms':5.},
            'spike_amplitudes':{'peak_sign':"neg"},
            'unit_locations':{},
            'spike_locations':{},
            'isi_histograms':{},
            'principal_components':{},
            #'quality_metrics':{'metric_names': ['snr', 'firing_rate','isi_violation']},
            'template_similarity':{}
        }
    else:
        compute_dict = {
            'random_spikes': {'method': 'uniform', 'max_spikes_per_unit': 500},
            'waveforms': {'ms_before': 2.0, 'ms_after': 2.0},
            'templates': {'operators': ["average", "median", "std"]},
            'noise_levels':{},
            'correlograms':{'window_ms':100, 'bin_ms':5.},
            'spike_amplitudes':{'peak_sign':"neg"},
            'unit_locations':{},
            'spike_locations':{},
            'isi_histograms':{},
            'principal_components':{},
            'quality_metrics':{'metric_names': ['snr', 'firing_rate','isi_violation']},
            'template_similarity':{}
        }
    
    analyzer.compute(compute_dict, **job_kwargs, save=False)
    
    print("Save Analyzer")
    analyzer=analyzer.save_as(format='memory', folder=None, backend_options=None)
 
    print(analyzer)
    
    return analyzer

""" ################################################################ Plot Templates ####### """
def PlotTemplatesandRaster(analyzer):
    
    ext_templates = analyzer.get_extension("templates")
    av_templates = ext_templates.get_data(operator="average")
    
    # Calculate the number of rows and columns
    num_elements = len(av_templates)  # Gets the total number of templates
    num_rows = 4  # Define 4 rows
    num_cols = (num_elements + num_rows - 1) // num_rows  # Calculate columns needed

    fig, axes = plt.subplots(num_rows, num_cols, figsize=(15, 10), squeeze=False)

    axes_flat = axes.flatten()
    
    # Plot each template
    for unit_index, unit_id in enumerate(analyzer.unit_ids[:num_elements]):
        ax = axes_flat[unit_index]
        template = av_templates[unit_index]  
        ax.plot(template)  
        ax.set_title(f"Unit ID: {unit_id}")  
    
    # Hide unused subplots
    for ax in axes_flat[num_elements:]:
        ax.axis('off')
    
    # Adjust layout
    plt.tight_layout()
    plt.show()
    
    time.sleep(1)    # Pause 5.5 seconds
    
def DeleteFolderContents(folder_path):
    try:
        shutil.rmtree(folder_path)
    except FileNotFoundError:
        print("The folder does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")
        
def SaveSpikePosition_mat(PathForPhy,Analyzer):
    
    ext_SpikeLocations = Analyzer.get_extension("spike_locations")
    SpikePositions = ext_SpikeLocations.get_data()
    
    FullFolder = os.path.join(PathForPhy,"SpikePositions.mat")
    
    mdic = {"SpikePositions": SpikePositions, "label": "SpikePositions"}
    
    print(ext_SpikeLocations)
    print(SpikePositions)
    print("Saving Spike Positions as .mat to " + FullFolder)
    
    savemat(FullFolder, mdic)
    
def get_all_subfolders(folder_path):
    """
    Returns a list of immediate subfolders (not nested) in the given folder.
    """
    if not os.path.exists(folder_path):
        raise FileNotFoundError(f"The folder '{folder_path}' does not exist.")
    
    # List all entries in the folder and filter only directories
    subfolders = [entry for entry in os.listdir(folder_path) 
                  if os.path.isdir(os.path.join(folder_path, entry))]
    return subfolders

def get_bin_files(folder_path):
    """
    Returns a list of filenames with the .bin extension in the given folder.
    """
    
    if not os.path.exists(folder_path):
        raise FileNotFoundError(f"The folder '{folder_path}' does not exist.")
    
    # List all files in the folder and filter for .bin files
    bin_files = [file for file in os.listdir(folder_path) if file.endswith('.bin')]
    return bin_files

def get_dat_files(folder_path):
    """
    Returns a list of filenames with the .bin extension in the given folder.
    """
    
    if not os.path.exists(folder_path):
        raise FileNotFoundError(f"The folder '{folder_path}' does not exist.")
    
    # List all files in the folder and filter for .bin files
    dat_files = [file for file in os.listdir(folder_path) if file.endswith('.dat')]
    return dat_files
        
def update_standards(standsorting_parameters, sorting_parameters):
    for key, value in sorting_parameters.items():
        if key in standsorting_parameters:
            # Get the type of the standard parameter value
            expected_type = type(standsorting_parameters[key])
            
            # Attempt to convert the value to the expected type
            try:
                converted_value = expected_type(value)
            except (ValueError, TypeError):
                # If conversion fails, skip the update and log an error
                print(f"Warning: Could not convert value for key '{key}' to {expected_type.__name__}. Check in the conda command window to see sorting settings. KEys should be set to 'None'")
                continue
            
            # Update the standard dictionary only if the value has changed
            if standsorting_parameters[key] != converted_value:
                standsorting_parameters[key] = converted_value

    return standsorting_parameters

def get_run_sorter_folder_arg():
    sig = inspect.signature(ss.run_sorter)
    if "output_folder" in sig.parameters:
        print("SpikeInterface version signature key for sorting function: output_folder")
        return "output_folder"
    elif "folder" in sig.parameters:
        print("SpikeInterface version signature key for sorting function: folder")
        return "folder"
    else:
        raise RuntimeError("Neither 'folder' nor 'output_folder' found in run_sorter signature!")
