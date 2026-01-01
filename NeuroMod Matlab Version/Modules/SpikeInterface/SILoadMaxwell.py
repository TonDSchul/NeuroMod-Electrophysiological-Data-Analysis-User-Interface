# -*- coding: utf-8 -*-
"""
Created on Sat Dec 27 13:05:11 2025

@author: tonyd
"""

import os
import sys
import numpy as np
import pyuac
from spikeinterface.extractors import read_maxwell
from probeinterface import read_prb
import scipy.io
from pathlib import Path

def create_save_folder(selected_folder):
    """
    Given a selected folder, create a sibling folder with ' Neo SaveFile' suffix.
    """
    # Get parent dir and base folder name
    parent_dir = os.path.dirname(selected_folder)
    base_name = os.path.basename(selected_folder)

    # Construct new folder name
    new_folder_name = f"{base_name} Neo SaveFile"
    new_folder_path = os.path.join(parent_dir, new_folder_name)

    # Create the folder if it doesn't exist
    if not os.path.exists(new_folder_path):
        os.makedirs(new_folder_path)
        print(f"Created folder: {new_folder_path}")
    else:
        print(f"Folder already exists: {new_folder_path}")

    return new_folder_path


def Save_MetaData_SI(recording, JustExtractingEvents,
                      SaveFileName,ProbeMappingFilePath):

    # first handle probe geometry
    # attach the probe file
    # Read the .prb file
    probe_group  = read_prb(ProbeMappingFilePath)  # ProbeGroup object
    print("########################")
    print(probe_group)
    print("########################")
    # Attach probe to the SpikeInterface recording
    # If there is only one probe, extract it
    probe = probe_group.probes[0]  # Probe object
    print("########################")
    print(probe)
    print("########################")
    # Attach probe to the recording
    recording = recording.set_probe(probe)
    
    # Now get channel locations
    locs = recording.get_channel_locations()
        
    #annotations = recording.annotations
    start_sample = recording.get_annotation('acquisition_start_sample')  # fallback 0
    
    if start_sample is None:
        start_sample = 1
    
    # sampling rate
    sampling_rate = recording.get_sampling_frequency()  # Hz

    # channel info
    channel_ids = recording.get_channel_ids()
    try:
        channel_names = [str(ch) for ch in channel_ids]  # default names = IDs
    except:
        channel_names = [f"ch{i}" for i in range(len(channel_ids))]

    try:
        units = recording.get_channel_property("units")
    except:
        units = ["mV"] * len(channel_ids)  # fallback

    n_channels = recording.get_num_channels()
    n_samples = recording.get_num_frames()

    print("Channel IDs:", channel_ids)

    if JustExtractingEvents == 0 and SaveFileName is not None:
        print("Saving Metadata to " + SaveFileName)
                
        # save .mat
        scipy.io.savemat(SaveFileName, {
            'sampling_rate': sampling_rate,
            'units': units,
            'channel_names': channel_names,
            'channel_ids': channel_ids,
            'n_channels': n_channels,
            'n_samples': n_samples,
            'acqu_start_samples': start_sample,
            'channel_locations': locs
        })

def main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveForMatlab):
 
    #### ----------- Check If Data or just Event Extraction ----------- ####
    JustExtractingEvents = 0
    if "EventExtraction" in RecordingSystemSelection:
        JustExtractingEvents = 1
    else:
        JustExtractingEvents = 0
        
    # -----------------------------------------------------------------------
    ''' First Create a Save Folder to save results in for Matlab to load'''
    # -----------------------------------------------------------------------
    #### ----------- Create Save folder next to recording folder ----------- ####
    SI_Save_Path = create_save_folder(file_path)
    #### ------------ Set Folder name for raw channel data ----------- ####
    ChannelDataSaveFileName = SI_Save_Path + "/SI_Saved_Channel_Data.dat"
    #### ------------ Set Folder name for MetaData ----------- ####
    MetaDataSaveFileName = SI_Save_Path + "/SI_Saved_MetaData.mat"
    #### ------------ Set Folder name for Event Data ----------- ####
    EventSaveFileName = SI_Save_Path + "/SI_Saved_EventData.mat" 
    
    ''' Load Probe map File (.prb)'''
    folder = Path(file_path)
    prb_file = next(p for p in folder.iterdir() if p.is_file() and p.suffix == ".prb")
    
    if prb_file is None:
        raise FileNotFoundError(f"No .prb containing the probe mapping information file found in directory: {folder}")
        
    ProbeMappingFilePath = Path(folder) / prb_file
    
    ## Actually set recording folder
    folder = Path(file_path)
    h5_file = next(p for p in folder.iterdir() if p.is_file() and p.suffix == ".h5")
    
    if h5_file is None:
        raise FileNotFoundError(f"No .h5 file found in directory: {folder}")
        
    RecordingFilePath = Path(folder) / h5_file
    
    #### ----------- Save Info wat was done ----------- ####
    print("Created Folder to Save Channel Data and Metadata for matlab to read: " + SI_Save_Path)
    
    print("Starting Data Extraction with SpikeInterface from " + file_path)
    
    print("Checking if a suitable recording format is found in selected folder:")
        
    print("Loading Maxwell Recording from Path " + file_path)
    
    # load the recording
    recording = read_maxwell(
        file_path=RecordingFilePath,
        stream_id=None,        
        stream_name=None,      
        all_annotations=False, 
        rec_name=None,         
        install_maxwell_plugin=True  
    )
    
    # inspect basic properties
    print(recording)
    print("Sampling frequency:", recording.get_sampling_frequency())
    print("Number of channels:", recording.get_num_channels())
    print("Duration (s):", recording.get_total_duration())
    
    fs = recording.get_sampling_frequency()
    chunk_size = int(fs * 10)  # 10-second chunks
    n_frames = recording.get_num_frames()
    channel_ids = recording.channel_ids  # all channels
    
    print("Converting and saving channel data to " + ChannelDataSaveFileName + " (this might take a while)")
        
    with open(ChannelDataSaveFileName, 'wb') as f:
        for start in range(0, n_frames, chunk_size):
            end = min(start + chunk_size, n_frames)
            traces_chunk = recording.get_traces(
                start_frame=start,
                end_frame=end,
                channel_ids=channel_ids,
                return_in_uV=True
            )
            # Convert to mV
            traces_chunk_mV = traces_chunk / 1e3
            # Transpose to (channels x samples)
            traces_chunk_mV.astype(np.float32).tofile(f)
            
    # -----------------------------------------------------------------------
    ''' Save MetaData'''
    # -----------------------------------------------------------------------
    
    Save_MetaData_SI(recording,JustExtractingEvents,MetaDataSaveFileName,ProbeMappingFilePath)
    
if __name__ == "__main__":

    KeepConsoleOpen = sys.argv[2]   
    KeepConsoleOpen = int(KeepConsoleOpen)

    if KeepConsoleOpen == 1:
        try:
            # Access arguments
            file_path = sys.argv[1]
            JustLoad = sys.argv[3]
            RecordingSystemSelection = sys.argv[4]
            FormatToSaveandReadintoMatlab = sys.argv[5]
            
            JustLoad = int(JustLoad)
            
            if not pyuac.isUserAdmin():
                print("Re-launching as admin!")
                pyuac.runAsAdmin()
            else:                   
                main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveandReadintoMatlab)  
    
        except Exception as e:
            print(f"An error occurred: {e}")
            print("Traceback details:")
            import traceback
            traceback.print_exc()  
        finally:
            input("Press Enter to exit...")
    
    
    if KeepConsoleOpen == 0:
        # Access arguments
        file_path = sys.argv[1]
        JustLoad = sys.argv[3]
        RecordingSystemSelection = sys.argv[4]
        FormatToSaveandReadintoMatlab = sys.argv[5]
       
        JustLoad = int(JustLoad)
        
        if not pyuac.isUserAdmin():
            print("Re-launching as admin!")
            pyuac.runAsAdmin()
        else:                   
            main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveandReadintoMatlab)  
        

