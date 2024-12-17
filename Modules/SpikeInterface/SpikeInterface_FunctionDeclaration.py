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
from probeinterface import generate_linear_probe
from probeinterface.plotting import plot_probe
import matplotlib.pyplot as plt
#from kilosort import io
import time
import os
import shutil
from scipy.io import savemat


""" ################################################################ Load Binary file Function ####### """
def Load_Binary_In_SpikeInterface(file_path,sampling_frequency,num_channels,Sorter):
    
    num_channels = int(num_channels)
    
    """"Parallel Proc
    essing"""
    global_job_kwargs = dict(n_jobs=4, chunk_duration="1s")
    si.set_global_job_kwargs(**global_job_kwargs)
    
    print("Reading .bin file")
    """  Define recording parameters """
    #sampling_frequency = 20_000.0  # Adjust according to your MATLAB dataset
    #num_channels = 16  # Adjust according to your MATLAB dataset
    if Sorter in ['Kilosort 4']:
        dtype = "float32"  # MATLAB's double corresponds to Python's float64
    else:
        dtype = "float64"  # MATLAB's double corresponds to Python's float64
    
    """  Load data using SpikeInterface """
    recording = si.read_binary(file_paths=file_path, sampling_frequency=sampling_frequency,
                               num_channels=num_channels, dtype=dtype)
    
    recording.annotate(is_filtered=False)
    
    return recording 
    return dtype

""" ################################################################ Generate Probe Desing ####### """
def Create_Probe(num_elec,ypitch,PlotTraces,Recording):
    
    print("Creating and attaching Probe")
    
    probe = generate_linear_probe(num_elec=num_elec, ypitch=ypitch, contact_shapes='circle', contact_shape_params={'radius': 6})
    # the probe has to be wired to the recording
    probe.set_device_channel_indices(np.arange(num_elec))
    probe.set_contact_ids(np.arange(num_elec))
    
    if PlotTraces == 1:
        print("Plotting Traces...")
        plot_probe(probe, with_contact_id=True)
    
    probe.to_dataframe(complete=True).loc[:, ["contact_ids", "shank_ids", "device_channel_indices"]]
    
    Recording = Recording.set_probe(probe)

    return probe

""" ################################################################ Preprocessing ####### """
def Preprocessing(Recording,Probe,Apply_Preprocessing):

    print("Preprocessing data and dump into cache")
            
    if Apply_Preprocessing == 1:
        print("Preprocessing Data...")
        Recording = spre.bandpass_filter(recording=Recording, freq_min=300, freq_max=6000)
        Recording = spre.whiten(recording=Recording)
    else:
       print("Not Preprocessing Data...")
           
    Recording = Recording.set_probe(Probe)
    
    Recording_Dumped = Recording
    
    Recording_Dumped = Recording_Dumped.set_probe(Probe)
    
    return Recording_Dumped
    
""" ################################################################ Subplot ####### """

def combined_plot(recording,PreproRecording,ypitch):
   
    # Create a figure with two subplots
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6))  # Two rows, one column
    
    # Redirect plots to the first axes
    plt.sca(ax1)  # Set the current axes to ax1
    sw.plot_traces(recording,  backend="matplotlib",ax=ax1)  # Plot the first function here
    
    # Redirect plots to the second axes
    plt.sca(ax2)  # Set the current axes to ax2
    sw.plot_traces(PreproRecording, backend="matplotlib",ax=ax2)  # Plot the second function here
    
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
    
    print(default_SC2_params)
    
    default_SC2_params = update_standards(default_SC2_params, SortingParameter)
        
    print(default_SC2_params)
        
    folder_path = Sorting_output_folder

    try:
        shutil.rmtree(folder_path)
    except FileNotFoundError:
        print("The folder does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")
    
    sorting_SC  = ss.run_sorter(sorter_name='spykingcircus2', **default_SC2_params, recording=recording,output_folder=Sorting_output_folder, remove_existing_folder=True)
    return sorting_SC 

""" ################################################################ MountainSort 5 ####### """
def SortWithMountainSort(recording,Sorting_output_folder,Apply_Preprocessing,SortingParameter):
    
    print("Starting Spike Sorting with Mountainsort5")
    
    """"Parallel Processing"""
    global_job_kwargs = dict(n_jobs=4, chunk_duration="1s")
    si.set_global_job_kwargs(**global_job_kwargs)
    
    default_MS5_params =  si.get_default_sorter_params('mountainsort5')
    #default_MS5_params = ss.Mountainsort5Sorter.default_params()
    print(default_MS5_params)
    
    Costum_MS5_params = update_standards(default_MS5_params, SortingParameter)
    
    print(Costum_MS5_params)

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
    
    sorting_MS5  = ss.run_sorter(sorter_name='mountainsort5', **Costum_MS5_params, recording=recording,output_folder=Sorting_output_folder, remove_existing_folder=True)
    return sorting_MS5

""" ################################################################ Kilosort 4 ####### """
def SortWithKilosort(recording,Sorting_output_folder,Apply_Preprocessing,SortingParameter):
    
    print("Starting Spike Sorting with Kilosort 4")
    
    """"Parallel Processing"""
    global_job_kwargs = dict(n_jobs=4, chunk_duration="1s")
    si.set_global_job_kwargs(**global_job_kwargs)
    
    default_KS4_params = ss.Kilosort4Sorter.default_params()
    print(default_KS4_params)
    
    #default_KS4_params = update_standards(default_KS4_params, SortingParameter)
    #print(default_KS4_params)
        
    sortingKS4 = ss.run_sorter(sorter_name='kilosort4', **default_KS4_params, recording=recording,output_folder=Sorting_output_folder, remove_existing_folder=True)
    return sortingKS4
    
""" ################################################################ Sorting Analyzer ####### """
def CreateSortingAnalyzer(recording,sorting,Save_Sorting_Folder):
    
    analyzer = si.create_sorting_analyzer(sorting=sorting, recording=recording, format='memory', folder=None)
    print(analyzer)

    # which is equivalent to this:
    job_kwargs = dict(n_jobs=1, chunk_duration="1s", progress_bar=True)
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
    
    # Create a figure with subplots arranged in a 4-row grid
    fig, axes = plt.subplots(num_rows, num_cols, figsize=(15, 10), squeeze=False)
    
    # Flatten the axes for easy iteration
    axes_flat = axes.flatten()
    
    # Plot each template
    for unit_index, unit_id in enumerate(analyzer.unit_ids[:num_elements]):
        ax = axes_flat[unit_index]
        template = av_templates[unit_index]  # Extract the template (a NumPy array)
        ax.plot(template)  # Use ax.plot() to plot the NumPy array on the subplot
        ax.set_title(f"Unit ID: {unit_id}")  # Set the title for the subplot
    
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
    print("Saving Spike Positions as .mat")
    ext_SpikeLocations = Analyzer.get_extension("spike_locations")
    SpikePositions = ext_SpikeLocations.get_data()
    
    FullFolder = PathForPhy + "/SpikePositions.mat";
    mdic = {"SpikePositions": SpikePositions, "label": "SpikePositions"}
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
                print(f"Warning: Could not convert value for key '{key}' to {expected_type.__name__}")
                continue
            
            # Update the standard dictionary only if the value has changed
            if standsorting_parameters[key] != converted_value:
                standsorting_parameters[key] = converted_value

    return standsorting_parameters

