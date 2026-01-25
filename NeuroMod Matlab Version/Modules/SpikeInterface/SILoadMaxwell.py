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
import json

from spikeinterface.extractors import read_maxwell
from probeinterface.io import write_prb
from probeinterface import Probe, ProbeGroup
from spikeinterface.preprocessing import unsigned_to_signed
        
def create_save_folder(selected_folder):
    """
    Given a selected folder, create a sibling folder with ' Neo SaveFile' suffix.
    """
    parent_dir = os.path.dirname(selected_folder)
    base_name = os.path.basename(selected_folder)

    new_folder_name = f"{base_name} SpikeInterface SaveFile"
    new_folder_path = os.path.join(parent_dir, new_folder_name)

    if not os.path.exists(new_folder_path):
        os.makedirs(new_folder_path)
        print(f"Created folder: {new_folder_path}")
    else:
        print(f"Folder already exists: {new_folder_path}")

    return new_folder_path


def Save_MetaData_SI(recording, JustExtractingEvents,
                      SaveFileName,channel_ids,channel_ids_extract,start_frame_extract,end_frame_extract):
    
    # channel locations
    locs = recording.get_channel_locations()

    start_sample = recording.get_annotation('acquisition_start_sample') 
    
    if start_sample is None:
        start_sample = 1
    
    sampling_rate = recording.get_sampling_frequency() 
    n_channels = recording.get_num_channels()  
    n_samples = recording.get_num_frames()  

    Origchannel_ids = recording.get_channel_ids()
    channel_ids = Origchannel_ids[channel_ids_extract]

    try:
        channel_names = [str(ch) for ch in Origchannel_ids]  # default names = IDs
    except:
        channel_names = [f"ch{i}" for i in range(len(Origchannel_ids))]

    try:
        units = recording.get_channel_property("units")
    except:
        units = ["mV"] * len(Origchannel_ids)

    # save as mat file
    if JustExtractingEvents == 0 and SaveFileName is not None:
        print("Saving Metadata to " + str(SaveFileName))
                
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
    print("Saving probe info.")
    probe = recording.get_probe()
    channel_ids = recording.channel_ids
    channel_ids = channel_ids[channel_ids_extract]
    if SaveFormat == ".prb":

        pos = probe.contact_positions
        
        n_channels = len(channel_ids_extract)
        print(n_channels)
        chanMap0ind = list(range(n_channels))
        chanMap = list(range(1, n_channels + 1))
        connected = np.ones(n_channels, dtype=bool)
        
        xcoords = pos[channel_ids_extract, 0]
        ycoords = pos[channel_ids_extract, 1]
    
        kcoords = np.ones(n_channels, dtype=np.int32)
    
        fs = float(recording.get_sampling_frequency())
        
        geometry = {
            ch: (float(x), float(y))
            for ch, x, y in zip(chanMap0ind, xcoords, ycoords)
        }
        
        channel_groups = {
            0: {
                'channels': chanMap0ind,
                'geometry': geometry
            }
        }
        
        with open(SaveFolder, "w") as f:
            f.write("channel_groups = ")
            f.write(repr(channel_groups))
            f.write("\n")
    
        #write_prb(SaveFolder, probegroup)
        print("Successfully saved probe information in " + str(SaveFolder))
    
    if SaveFormat == ".mat":
        # ---------- Save for Kilsoort as .mat file ----------
        pos = probe.contact_positions
        
        n_channels = len(channel_ids_extract)
        print(n_channels)
        chanMap0ind = list(range(n_channels))
        chanMap = list(range(1, n_channels + 1))
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

def main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveForMatlab,SaveProbeInfo,SaveProbeInfoFormat,TimeToExtract,ChannelToExtract,SIParamsfile):
    import spikeinterface as si
    print("Currently installed SI version:")
    print(si.__version__)
    
    # Check if the file exists, then delete it
    if os.path.exists(SIParamsfile):
        print(f"Deleted file: {SIParamsfile}")
        print(SIParamsfile)
        os.remove(SIParamsfile)
    else:
        print("File does not exist, nothing to delete.")
        
    #### ----------- Check If Data or just Event Extraction ----------- ####
    JustExtractingEvents = 0
    if "EventExtraction" in RecordingSystemSelection:
        JustExtractingEvents = 1
    else:
        JustExtractingEvents = 0
        
    # -----------------------------------------------------------------------
    ''' Create all save folders to load data from or save data to '''
    # -----------------------------------------------------------------------
    
    SI_Save_Path = Path(create_save_folder(file_path))
    SI_Save_Path.mkdir(parents=True, exist_ok=True)
    
    # Channel data
    ChannelDataSaveFileName = SI_Save_Path / "SI_Saved_Channel_Data.dat"
    
    # Metadata
    MetaDataSaveFileName = SI_Save_Path / "SI_Saved_MetaData.mat"
    
    # Event data
    EventSaveFileName = SI_Save_Path / "SI_Saved_EventData.mat"
    
    # Probe info
    if SaveProbeInfoFormat == ".mat":
        ProbeSaveFileName = SI_Save_Path / "SI_Probe_Mapping.mat"
    elif SaveProbeInfoFormat == ".prb":
        ProbeSaveFileName = SI_Save_Path / "SI_Probe_Mapping.prb"
    else:
        raise ValueError("Unsupported SaveProbeInfoFormat")
        
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
    
    # -----------------------------------------------------------------------
    ''' Intitialize recording '''
    # -----------------------------------------------------------------------
    
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
    
    print(recording)
    print("Sampling frequency:", recording.get_sampling_frequency())
    print("Number of channels:", recording.get_num_channels())
    print("Duration (s):", recording.get_total_duration())
    
    # -----------------------------------------------------------------------
    ''' Extraction parameter '''
    # -----------------------------------------------------------------------
    
    ####### time range to extract ########
    t_start_str, t_end_str = TimeToExtract.split(",")
    
    t_start = float(t_start_str)
    if t_end_str.lower() == "inf":
        t_end = float("inf")
    else:
        t_end = float(t_end_str)
    
    fs = recording.get_sampling_frequency()
    n_frames = recording.get_num_frames()
    
    # Convert to samples
    start_frame_extract = int(t_start * fs)
    if t_end == float("inf"):
        end_frame_extract = n_frames
    else:
        end_frame_extract = int(t_end * fs)
    
    start_frame_extract = max(0, start_frame_extract)
    end_frame_extract   = min(n_frames, end_frame_extract)
    
    chunk_size = int(fs * 10)  # 10-second chunks
    channel_ids = recording.channel_ids
    
    print(
        "Converting and saving channel data to",
        ChannelDataSaveFileName,
        f"(frames {start_frame_extract} → {end_frame_extract})"
    )
    
    ####### channel to extract ########
    if ChannelToExtract == "All":
        n_channels = recording.get_num_channels()  # integer
        channel_ids_extract = np.arange(n_channels)  # [0, 1, 2, ..., n_channels-1]
    else:
        channel_ids_extract = np.array(
        [int(ch) - 1 for ch in ChannelToExtract.split() if ch.strip() != ""],
        dtype=int
        )
    
    # -----------------------------------------------------------------------
    ''' Save Channel Data'''
    # -----------------------------------------------------------------------
    with open(ChannelDataSaveFileName, "wb") as f:
        for start in range(start_frame_extract, end_frame_extract, chunk_size):
            end = min(start + chunk_size, end_frame_extract)
    
            traces_chunk = recording.get_traces(
                start_frame=start,
                end_frame=end,
                channel_ids=channel_ids[channel_ids_extract],
                return_in_uV=True
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
    
    SIParamsfile = sys.argv[1]
    print(SIParamsfile)
    # load JSON with infos from gui what to do
    with open(SIParamsfile, 'r') as f:
        SIparams = json.load(f)
        
    file_path = SIparams['SelectedPath']
    JustLoad = int(SIparams['JustLoadDatFile'])
    KeepConsoleOpen = int(SIparams['KeepPythonOpen'])
    RecordingSystemSelection = SIparams['RecordingSystemSelection']
    FormatToSaveandReadintoMatlab = SIparams['FormatToSaveandReadintoMatlab']
    SaveProbeInfo = int(SIparams['SaveProbeInfo'])
    SaveProbeInfoFormat = SIparams['SaveProbeInfoFormat']
    TimeToExtract = SIparams['TimeToLoad']
    ChannelToextract = SIparams['ChannelToLoad']
    
    if KeepConsoleOpen == 1:
        try:
            # Access arguments

            if not pyuac.isUserAdmin():
                print("Re-launching as admin!")
                pyuac.runAsAdmin()
            else:                   
                main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveandReadintoMatlab,SaveProbeInfo,SaveProbeInfoFormat,TimeToExtract,ChannelToextract,SIParamsfile)  
    
        except Exception as e:
            print(f"An error occurred: {e}")
            print("Traceback details:")
            import traceback
            traceback.print_exc()  
        finally:
            input("Press Enter to exit...")
    
    
    if KeepConsoleOpen == 0:
        SIParamsfile = sys.argv[1]
        print(SIParamsfile)
        # load JSON with infos from gui what to do
        with open(SIParamsfile, 'r') as f:
            SIparams = json.load(f)

        file_path = SIparams['SelectedPath']
        JustLoad = int(SIparams['JustLoadDatFile'])
        KeepConsoleOpen = int(SIparams['KeepPythonOpen'])
        RecordingSystemSelection = SIparams['RecordingSystemSelection']
        FormatToSaveandReadintoMatlab = SIparams['FormatToSaveandReadintoMatlab']
        SaveProbeInfo = int(SIparams['SaveProbeInfo'])
        SaveProbeInfoFormat = SIparams['SaveProbeInfoFormat']
        TimeToExtract = SIparams['TimeToLoad']
        ChannelToextract = SIparams['ChannelToLoad']
        
        if not pyuac.isUserAdmin():
            print("Re-launching as admin!")
            pyuac.runAsAdmin()
        else:                   
            main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveandReadintoMatlab,SaveProbeInfo,SaveProbeInfoFormat,TimeToExtract,ChannelToextract,SIParamsfile)  
        

