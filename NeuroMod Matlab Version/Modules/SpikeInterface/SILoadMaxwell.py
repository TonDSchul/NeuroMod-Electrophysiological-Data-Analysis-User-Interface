# -*- coding: utf-8 -*-
"""
Created on Sat Dec 27 13:05:11 2025

@author: tonyd
"""

import os
import sys
import numpy as np
import pyuac
import scipy.io
from scipy.io import savemat
from pathlib import Path

from spikeinterface.extractors import read_maxwell
from probeinterface.io import write_prb
from probeinterface import Probe, ProbeGroup
    
def Sanity_Plot(recording):
    import matplotlib.pyplot as plt
    
    # Parameters
    channel_id = recording.channel_ids[0]  # channel 1 (SpikeInterface uses IDs, not 1-based index)
    fs = recording.get_sampling_frequency()
    
    time_windows = [
        (0, 2),
        (9, 11),
        (19, 21),
        (99, 101),
    ]
    
    plt.ion()

    fig, axes = plt.subplots(len(time_windows), 1, sharex=False, figsize=(10, 8))
    
    for ax, (t_start, t_end) in zip(axes, time_windows):
        start_frame = int(t_start * fs)
        end_frame = int(t_end * fs)
    
        trace = recording.get_traces(
            start_frame=start_frame,
            end_frame=end_frame,
            channel_ids=[channel_id],
            return_in_uV=True
        ).squeeze() / 1e3  # µV → mV
    
        t = np.arange(trace.size) / fs + t_start
    
        ax.plot(t, trace)
        ax.set_title(f"{t_start}–{t_end} s")
        ax.set_xlabel("Time (s)")
        ax.set_ylabel("mV")
    
        ymin, ymax = trace.min(), trace.max()
        if ymin == ymax:  # avoid zero-height axis
            ymin -= 1e-6
            ymax += 1e-6
        ax.set_ylim(ymin, ymax)
    
    plt.tight_layout()
    plt.show(block=False)
    
def create_save_folder(selected_folder):
    """
    Given a selected folder, create a sibling folder with ' Neo SaveFile' suffix.
    """
    # Get parent dir and base folder name
    parent_dir = os.path.dirname(selected_folder)
    base_name = os.path.basename(selected_folder)

    # Construct new folder name
    new_folder_name = f"{base_name} SpikeInterface SaveFile"
    new_folder_path = os.path.join(parent_dir, new_folder_name)

    # Create the folder if it doesn't exist
    if not os.path.exists(new_folder_path):
        os.makedirs(new_folder_path)
        print(f"Created folder: {new_folder_path}")
    else:
        print(f"Folder already exists: {new_folder_path}")

    return new_folder_path


def Save_MetaData_SI(recording, JustExtractingEvents,
                      SaveFileName,channel_ids,channel_ids_extract,start_frame_extract,end_frame_extract):
    
    # Now get channel locations
    locs = recording.get_channel_locations()

    #annotations = recording.annotations
    start_sample = recording.get_annotation('acquisition_start_sample')  # fallback 0
    
    if start_sample is None:
        start_sample = 1
    
    # sampling rate
    sampling_rate = recording.get_sampling_frequency()  # Hz
    # Number of channels
    n_channels = recording.get_num_channels()  # integer
    # Number of frames / samples
    n_samples = recording.get_num_frames()     # integer
    # channel info
    Origchannel_ids = recording.get_channel_ids()
    channel_ids = Origchannel_ids[channel_ids_extract]

    try:
        channel_names = [str(ch) for ch in Origchannel_ids]  # default names = IDs
    except:
        channel_names = [f"ch{i}" for i in range(len(Origchannel_ids))]

    try:
        units = recording.get_channel_property("units")
    except:
        units = ["mV"] * len(Origchannel_ids)  # fallback

    
    if JustExtractingEvents == 0 and SaveFileName is not None:
        print("Saving Metadata to " + str(SaveFileName))
                
        # save .mat
        scipy.io.savemat(SaveFileName, {
            'sampling_rate': sampling_rate,
            'units': units,
            'channel_names': channel_names,
            'orig_channel_ids': Origchannel_ids,
            'custom_channel_ids': channel_ids,
            'n_channels': n_channels,
            'n_samples': n_samples,
            'acqu_start_samples': start_sample,
            'channel_locations': locs,
            'StartSampleToExtract': start_frame_extract,
            'StopSampleToExtract': end_frame_extract,
            'ChannelToExtract': channel_ids_extract,
        })

def Save_Probe_Info(recording,SaveFolder,SaveFormat,channel_ids,channel_ids_extract,start_frame_extract,end_frame_extract):
    print("Attempting to save probe info.")
    probe = recording.get_probe()
    channel_ids = recording.channel_ids
    channel_ids = channel_ids[channel_ids_extract]
    print("######################")
    print(channel_ids)
    print("######################")
    if SaveFormat == ".prb":
        
        # Select only the desired channels
        sub_probe = Probe(ndim=probe.ndim)
        sub_probe.set_contacts(
            positions=probe.contact_positions[channel_ids],
            shapes=np.array([probe.contact_shapes[i] for i in channel_ids]) if probe.contact_shapes is not None else None,
            shapes_params=np.array([probe.contact_shape_params[i] for i in channel_ids]) if probe.contact_shape_params is not None else None,
            device_channel_indices=np.array([probe.device_channel_indices[i] for i in channel_ids]),
            # Optional: assign contact_ids as 0..n-1
            contact_ids=np.arange(len(channel_ids))
        )
    
        # Wrap in a ProbeGroup
        probegroup = ProbeGroup()
        probegroup.add_probe(sub_probe)
    
        write_prb(SaveFolder, probegroup)
        print("Successfully saved probe information in " + str(SaveFolder))
    
    if SaveFormat == ".mat":
        # ---------- Save for Kilsoort as .mat file ----------
        pos = probe.contact_positions
        
        n_channels = len(channel_ids_extract)
    
        chanMap0ind = channel_ids.astype(np.int32)
        chanMap = chanMap0ind + 1  # MATLAB 1-based
        connected = np.ones(n_channels, dtype=bool)
        
        xcoords = pos[channel_ids_extract, 0]
        ycoords = pos[channel_ids_extract, 1]
    
        kcoords = np.ones(n_channels, dtype=np.int32)
    
        fs = float(recording.get_sampling_frequency())
    
        mat_dict = {
            "chanMap": chanMap,
            "chanMap0ind": chanMap0ind,
            "connected": connected,
            "xcoords": xcoords,
            "ycoords": ycoords,
            "kcoords": kcoords,
            "fs": fs,
        }
    
        savemat(SaveFolder, mat_dict)
        print("Succesfully saved probe information in " + str(SaveFolder))

def main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveForMatlab,SaveProbeInfo,SaveProbeInfoFormat,TimeToExtract,ChannelToExtract):
    import spikeinterface as si
    print(si.__version__)
    #### ----------- Check If Data or just Event Extraction ----------- ####
    JustExtractingEvents = 0
    if "EventExtraction" in RecordingSystemSelection:
        JustExtractingEvents = 1
    else:
        JustExtractingEvents = 0
        
    # -----------------------------------------------------------------------
    ''' First Create a Save Folder to save results in for Matlab to load'''
    # -----------------------------------------------------------------------
    SI_Save_Path = Path(create_save_folder(file_path))

    #### ------------ Set Folder name for raw channel data ----------- ####
    ChannelDataSaveFileName = SI_Save_Path / "SI_Saved_Channel_Data.dat"
    
    #### ------------ Set Folder name for MetaData ----------- ####
    MetaDataSaveFileName = SI_Save_Path / "SI_Saved_MetaData.mat"
    
    #### ------------ Set Folder name for Event Data ----------- ####
    EventSaveFileName = SI_Save_Path / "SI_Saved_EventData.mat"
    
    #### ------------ Set Folder name for ProbeInfo ----------- ####
    if SaveProbeInfoFormat == ".mat":
        ProbeSaveFileName = SI_Save_Path / "SI_Probe_Mapping.mat"
    elif SaveProbeInfoFormat == ".prb":
        ProbeSaveFileName = SI_Save_Path / "SI_Probe_Mapping.prb"
        
    ## Actually set recording folder
    folder = Path(file_path)
    h5_file = next(p for p in folder.iterdir() if p.is_file() and p.suffix == ".h5")
    
    if h5_file is None:
        raise FileNotFoundError(f"No .h5 file found in directory: {folder}")
        
    RecordingFilePath = Path(folder) / h5_file
    
    #### ----------- Save Info wat was done ----------- ####
    print("Created Folder to Save Channel Data and Metadata for matlab to read: " + str(SI_Save_Path))
    
    print("Starting Data Extraction with SpikeInterface from " + str(file_path))
    
    print("Checking if a suitable recording format is found in selected folder:")
        
    print("Loading Maxwell Recording from Path " + str(file_path))
    
    # load the recording
    recording = read_maxwell(
        file_path=RecordingFilePath,
        stream_id=None,        
        stream_name=None,      
        all_annotations=False, 
        rec_name=None,         
        install_maxwell_plugin=True  
    )
        
    channel_positions = recording.get_channel_locations()
    
    print(channel_positions)
    
    # inspect basic properties
    print(recording)
    print("Sampling frequency:", recording.get_sampling_frequency())
    print("Number of channels:", recording.get_num_channels())
    print("Duration (s):", recording.get_total_duration())
    
    # Parse time range, allow 'Inf' as end
    t_start_str, t_end_str = TimeToExtract.split(",")
    
    t_start = float(t_start_str)
    if t_end_str.lower() == "inf":
        t_end = float("inf")
    else:
        t_end = float(t_end_str)
    
    fs = recording.get_sampling_frequency()
    n_frames = recording.get_num_frames()
    
    # Convert to frame indices
    start_frame_extract = int(t_start * fs)
    if t_end == float("inf"):
        end_frame_extract = n_frames
    else:
        end_frame_extract = int(t_end * fs)
    
    # Clamp to recording bounds
    start_frame_extract = max(0, start_frame_extract)
    end_frame_extract   = min(n_frames, end_frame_extract)
    
    # Chunk parameters
    chunk_size = int(fs * 10)  # 10-second chunks
    
    channel_ids = recording.channel_ids
    
    print(
        "Converting and saving channel data to",
        ChannelDataSaveFileName,
        f"(frames {start_frame_extract} → {end_frame_extract})"
    )
    
    print("Converting and saving channel data to " + str(ChannelDataSaveFileName )+ " (this might take a while)")
    
    # set channel to extract
    if ChannelToExtract == "All":
        n_channels = recording.get_num_channels()  # integer
        channel_ids_extract = np.arange(n_channels)  # [0, 1, 2, ..., n_channels-1]
    else:
        channel_ids_extract = np.array(
        [int(ch) - 1 for ch in ChannelToExtract.split() if ch.strip() != ""],
        dtype=int
        )
    
    with open(ChannelDataSaveFileName, "wb") as f:
        for start in range(start_frame_extract, end_frame_extract, chunk_size):
            end = min(start + chunk_size, end_frame_extract)
    
            traces_chunk = recording.get_traces(
                start_frame=start,
                end_frame=end,
                channel_ids=channel_ids[channel_ids_extract],
                return_in_uV=True,
            )
    
            # Convert µV → mV
            traces_chunk_mV = traces_chunk / 1e3
    
            # Write as float32, channels × samples
            traces_chunk_mV.astype(np.float32).tofile(f)
            
    # -----------------------------------------------------------------------
    ''' Save MetaData'''
    # -----------------------------------------------------------------------
    
    Save_MetaData_SI(recording,JustExtractingEvents,MetaDataSaveFileName,channel_ids,channel_ids_extract,start_frame_extract,end_frame_extract)
    
    # -----------------------------------------------------------------------
    ''' Save Probe'''
    # -----------------------------------------------------------------------

    if SaveProbeInfo == 1:
        Save_Probe_Info(recording,ProbeSaveFileName,SaveProbeInfoFormat,channel_ids,channel_ids_extract,start_frame_extract,end_frame_extract)
    
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
            SaveProbeInfo = sys.argv[6]
            SaveProbeInfoFormat = sys.argv[7]
            TimeToExtract = sys.argv[8]
            ChannelToextract = sys.argv[9]
            
            SaveProbeInfo = int(SaveProbeInfo)
            
            JustLoad = int(JustLoad)
            
            if not pyuac.isUserAdmin():
                print("Re-launching as admin!")
                pyuac.runAsAdmin()
            else:                   
                main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveandReadintoMatlab,SaveProbeInfo,SaveProbeInfoFormat,TimeToExtract,ChannelToextract)  
    
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
        SaveProbeInfo = sys.argv[6]
        SaveProbeInfoFormat = sys.argv[7]
        TimeToExtract = sys.argv[8]
        ChannelToextract = sys.argv[9]
        
        SaveProbeInfo = int(SaveProbeInfo)
       
        JustLoad = int(JustLoad)
        
        if not pyuac.isUserAdmin():
            print("Re-launching as admin!")
            pyuac.runAsAdmin()
        else:                   
            main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveandReadintoMatlab,SaveProbeInfo,SaveProbeInfoFormat,TimeToExtract,ChannelToextract)  
        

