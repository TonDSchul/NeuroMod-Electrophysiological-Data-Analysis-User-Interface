# -*- coding: utf-8 -*-
"""
Created on Fri Aug  8 22:11:22 2025

@author: tonyd
"""
import re
import os
import neo
from neo.io import get_io
import scipy
import numpy as np
import matplotlib.pyplot as plt

def Get_Save_Event_Data(DataLoggerSaveFileName,reader,sampling_rate,EventSaveFileName):
    print("Checking for Event Data")
    write_DataLogger("Checking for Event Data",DataLoggerSaveFileName)
    
    all_labels = []
    all_times = []
    all_channels = []
    
    reader.parse_header()
    nb_event_channel = reader.event_channels_count()
    
    for chan_index in range(nb_event_channel):
        nb_event = reader.event_count(block_index=0, seg_index=0, event_channel_index=chan_index)
        if nb_event == 0:
            continue
        
        ev_timestamps, _, ev_labels = reader.get_event_timestamps(
            block_index=0, seg_index=0, event_channel_index=chan_index
        )
        ev_times = reader.rescale_event_timestamp(ev_timestamps, dtype='float64')  # seconds
        # convert to samples before saving
        ev_times_samples = (ev_times * sampling_rate).astype(int)
        
        all_times.extend(ev_times_samples)
        all_labels.extend([str(label) for label in ev_labels])
        all_channels.extend([chan_index] * len(ev_times))  # repeat channel index for each event
    
    if all_times:
        # Convert to arrays
        all_times = np.array(all_times)
        all_labels = np.array(all_labels, dtype=object)
        all_channels = np.array(all_channels)
        
        print("Saving event data to " + EventSaveFileName)
        write_DataLogger("Saving event data to " + EventSaveFileName,DataLoggerSaveFileName)
        
        print("Event Channel: " + str(all_channels))
        write_DataLogger("Event Channel: " + str(all_channels),DataLoggerSaveFileName)
            
        print("Event Times: " + str(all_times))
        write_DataLogger("Event Times: " + str(all_times),DataLoggerSaveFileName)
            
        print("Event Label: " + str(all_labels))
        write_DataLogger("Event Label: " + str(all_labels),DataLoggerSaveFileName)
        
        # Save to .mat
        scipy.io.savemat(EventSaveFileName, {
            'event_labels': all_labels,
            'event_samples': all_times,
            'event_channels': all_channels
        })
    else:
        print("No event data found!")
        write_DataLogger("No event data found!",DataLoggerSaveFileName)
    
def Save_MetaData(analogsignals,start_sample,JustExtractingEvents,SaveFileName,DataLoggerSaveFileName,Method,NrChannel,NrSamples):
    # -----------------------------------------------------------------------
    ''' Save MetaData'''
    # -----------------------------------------------------------------------
    # Extract metadata
    sampling_rate = analogsignals[0].sampling_rate.rescale('Hz').magnitude
    units = [str(asig.units.dimensionality) for asig in analogsignals]
    channel_names = [asig.name for asig in analogsignals]
    channel_ids = [asig.annotations.get('channel_id', i) for i, asig in enumerate(analogsignals)]
    
    if start_sample is None:
        start_sample = 1
    
    if JustExtractingEvents == 0:
        # Save metadata as .mat
        
        print("Saving Metadata to " + SaveFileName)
        write_DataLogger("Saving Metadata to " + SaveFileName,DataLoggerSaveFileName)
        
        if Method == 2:
            scipy.io.savemat(SaveFileName, {
                'sampling_rate': sampling_rate,
                'units': units,
                'channel_names': channel_names,
                'channel_ids': channel_ids,
                'n_channels': NrChannel,
                'n_samples': NrSamples,
                'acqu_start_samples': start_sample
            })
        else:
            scipy.io.savemat(SaveFileName, {
                'sampling_rate': sampling_rate,
                'units': units,
                'channel_names': channel_names,
                'channel_ids': channel_ids,
                'n_channels': NrChannel,
                'n_samples': NrSamples,
                'acqu_start_samples': start_sample       
            })
    
    
def write_DataLogger(LoggerMessage,DataLoggerSaveFileName):
    with open(DataLoggerSaveFileName, "a") as DataLoggerFile:
        DataLoggerFile.write(LoggerMessage+"\n")
        
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

def Exract_Raw_Channel_Data(reader):
    blocks = reader.read(lazy=False)
    block = blocks[0]
    segment = block.segments[0]
    
    analogsignals = segment.analogsignals
    
    Amp_Signal_Object = analogsignals[0]

    return Amp_Signal_Object,analogsignals

def find_sync_messages(base_path):
    for root, dirs, files in os.walk(base_path):
        if 'sync_messages.txt' in files:
            return os.path.join(root, 'sync_messages.txt')
    return None  # Not found

def GetAcquisitionStartSample(recording_path):
    print("Searching for acqu start!")
    try:
        # Search for sync_messages.txt
        sync_path = find_sync_messages(recording_path)

        if sync_path and os.path.exists(sync_path):
            with open(sync_path, 'r') as f:
                for line in f:
                    if "Start Time" in line:
                        # Extract the numeric value at the end using regex
                        match = re.search(r':\s*(\d+)', line)
                        if match:
                            start_sample = int(match.group(1))
                            print(f"Acquisition start (in samples): {start_sample}")
                            return start_sample
            print("No acquisition start sample found in sync_messages.txt")
            return None

        else:
            print("sync_messages.txt not found.")
            return None

    except Exception as e:
        print(f"Error while reading sync_messages.txt: {e}")
        return None


def Get_Reader(FolderName,DataLoggerSaveFileName,RecordingSystemSelection):
    
    LoggerMessage = None
    reader = None
    
    # -----------------------------------------------------------------------
    ''' Autodetect Recording System with NEO'''
    # -----------------------------------------------------------------------
    if RecordingSystemSelection == "NEO Format Autodetection" or RecordingSystemSelection == "NEO Format AutodetectionEventExtraction":
        try:
            reader = get_io(FolderName)
            LoggerMessage = (f"Detected IO class: {reader.__class__.__name__}")
            print(f"Detected IO class: {reader.__class__.__name__}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                    
        except Exception as e:
            
            LoggerMessage = (f"Neo could not detect a compatible IO: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
            print(f"Neo could not detect a compatible IO: {e}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
        
    # -----------------------------------------------------------------------
    ''' Load Data Without Autodetection based on User Input'''
    # -----------------------------------------------------------------------
    # -----------------------------------------------------------------------
    ''' Neuralynx'''
    # -----------------------------------------------------------------------
    if RecordingSystemSelection == "NEO Neuralynx" or RecordingSystemSelection == "NeuralynxEventExtraction":
        try:
            reader = neo.io.NeuralynxIO(dirname=FolderName, use_cache=False, cache_path='same_as_resource')
            LoggerMessage = (f"Use IO class: {RecordingSystemSelection}")
            print(f"Use IO class: {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
        except Exception as e:
            
            LoggerMessage = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
            print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
    # -----------------------------------------------------------------------
    ''' Plexon'''
    # -----------------------------------------------------------------------
    if RecordingSystemSelection == "NEO Plexon" or RecordingSystemSelection == "PlexonEventExtraction":
        try:
            reader = neo.io.PlexonIO(filename=FolderName)
            LoggerMessage = (f"Use IO class: {RecordingSystemSelection}")
            print(f"Use IO class: {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
            
            reader.parse_header()
            header = reader.header
            print(header)
             
        except Exception as e:
            
            LoggerMessage = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
            print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
       
    # -----------------------------------------------------------------------
    ''' Tucker Davis'''
    # -----------------------------------------------------------------------
    if RecordingSystemSelection == "NEO TdT" or RecordingSystemSelection == "TdT (Tucker-Davis Technologies)EventExtraction":
        
        #try:
        reader = neo.io.TdtIO(dirname=FolderName)
        print("Signal streams:", reader.signal_streams())
        print("Signal channels:", reader.signal_channels())
        print("Segments:", reader.segment_count())


        LoggerMessage = (f"Use IO class: {RecordingSystemSelection}")
        print(f"Use IO class: {RecordingSystemSelection}")
    
        write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
        #except Exception as e:
            
           # result_string = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
           #print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
            
            #with open(DataLoggerSaveFileName, "a") as f:
                #DataLoggerFile.write(result_string+"\n")
    
    # -----------------------------------------------------------------------
    ''' New Open ephys binary format'''
    # -----------------------------------------------------------------------
    if RecordingSystemSelection == "NEO New Open Ephys Format" or RecordingSystemSelection == "New Open Ephys FormatEventExtraction":
        try:
            reader = neo.io.OpenEphysBinaryIO(dirname=FolderName)
            LoggerMessage = (f"Use IO class: {RecordingSystemSelection}")
            print(f"Use IO class: {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
        except Exception as e:
            
            LoggerMessage = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
            print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
        
    # -----------------------------------------------------------------------
    ''' Legacy Open ephys format'''
    # -----------------------------------------------------------------------
    if RecordingSystemSelection == "NEO Legacy Open Ephys Format" or RecordingSystemSelection == "Legacy Open Ephys FormatEventExtraction":
        try:
            reader = neo.io.OpenEphysIO(dirname=FolderName)
            LoggerMessage = (f"Use IO class: {RecordingSystemSelection}")
            print(f"Use IO class: {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
        except Exception as e:
            
            LoggerMessage = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
            print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
    # -----------------------------------------------------------------------
    ''' NeuroExplorer format'''
    # -----------------------------------------------------------------------
    if RecordingSystemSelection == "NEO NeuroExplorer":
        try:
            reader = neo.io.NeuroExplorerIO(filename=FolderName)
            LoggerMessage = (f"Use IO class: {RecordingSystemSelection}")
            print(f"Use IO class: {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
        except Exception as e:
            
            LoggerMessage = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
            print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
    # -----------------------------------------------------------------------
    ''' Blackrock format'''
    # -----------------------------------------------------------------------
    if RecordingSystemSelection == "NEO Blackrock":
        try:
            reader = neo.io.BlackrockIO(filename=FolderName, nsx_to_load='all')
            LoggerMessage = (f"Use IO class: {RecordingSystemSelection}")
            print(f"Use IO class: {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
        except Exception as e:
            
            LoggerMessage = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
            print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
            
            write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
                
                
    return reader