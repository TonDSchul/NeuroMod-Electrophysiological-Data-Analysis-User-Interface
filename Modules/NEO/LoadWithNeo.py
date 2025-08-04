# -*- coding: utf-8 -*-
"""
Created on Thu Jul 31 16:12:47 2025

@author: tonyd
"""
import os
import sys
import pyuac
import numpy as np
import scipy.io
import neo

from neo.io import get_io

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

def main(FolderName,JustLoad,RecordingSystemSelection,KeepConsoleOpen):
    try:
        JustExtractingEvents = 0
        if "EventExtraction" in RecordingSystemSelection:
            JustExtractingEvents = 1
        else:
            JustExtractingEvents = 0
    
        # -----------------------------------------------------------------------
        ''' First Create a Save Folder to save results in for Matlab to load'''
        # -----------------------------------------------------------------------
        # call save folder function
        NEO_Save_Path = create_save_folder(FolderName)
        # show info and save in Data Logger file
        print("Created Folder to Save Channel Data and Metadata for matlab to read: " + NEO_Save_Path)
        result_string = ("Created Folder to Save Channel Data and Metadata for matlab to read: " + NEO_Save_Path)
        print("Starting Data Extraction with NEO from " + FolderName)
        result_string = result_string + "Starting Data Extraction with NEO from " + FolderName
        print("Checking if a suitable recording format is found in selected folder:")
        result_string = result_string + "Checking if a suitable recording format is found in selected folder:"
        
        # Save to .txt file
        DataLoggerSaveFileName = NEO_Save_Path + "/Logger.txt"
        with open(DataLoggerSaveFileName, "w") as f:
            f.write(result_string+"\n")
        
        result_string = None
        reader = None
        
        # -----------------------------------------------------------------------
        ''' Autodetect Recording System with NEO'''
        # -----------------------------------------------------------------------
        if RecordingSystemSelection == "NEO Format Autodetection" or RecordingSystemSelection == "NEO Format AutodetectionEventExtraction":
            try:
                reader = get_io(FolderName)
                result_string = (f"Detected IO class: {reader.__class__.__name__}")
                print(f"Detected IO class: {reader.__class__.__name__}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                
            except Exception as e:
                
                result_string = (f"Neo could not detect a compatible IO: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
                print(f"Neo could not detect a compatible IO: {e}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
        # -----------------------------------------------------------------------
        ''' Load Data Without Autodetection based on User Input'''
        # -----------------------------------------------------------------------
        # -----------------------------------------------------------------------
        ''' Neuralynx'''
        # -----------------------------------------------------------------------
        if RecordingSystemSelection == "Neuralynx" or RecordingSystemSelection == "NeuralynxEventExtraction":
            try:
                reader = neo.io.NeuralynxIO(dirname=FolderName)
                result_string = (f"Use IO class: {RecordingSystemSelection}")
                print(f"Use IO class: {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                    
            except Exception as e:
                
                result_string = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
                print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
        # -----------------------------------------------------------------------
        ''' Plexon'''
        # -----------------------------------------------------------------------
        if RecordingSystemSelection == "Plexon" or RecordingSystemSelection == "PlexonEventExtraction":
            try:
                reader = neo.io.PlexonIO(filename=FolderName)
                result_string = (f"Use IO class: {RecordingSystemSelection}")
                print(f"Use IO class: {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                    
            except Exception as e:
                
                result_string = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
                print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
           
        # -----------------------------------------------------------------------
        ''' Tucker Davis'''
        # -----------------------------------------------------------------------
        if RecordingSystemSelection == "TdT (Tucker-Davis Technologies)" or RecordingSystemSelection == "TdT (Tucker-Davis Technologies)EventExtraction":
            
            try:
                reader = neo.io.TdtIO(dirname=FolderName)
                result_string = (f"Use IO class: {RecordingSystemSelection}")
                print(f"Use IO class: {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                    
            except Exception as e:
                
                result_string = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
                print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
        
        # -----------------------------------------------------------------------
        ''' New Open ephys binary format'''
        # -----------------------------------------------------------------------
        if RecordingSystemSelection == "New Open Ephys Format" or RecordingSystemSelection == "New Open Ephys FormatEventExtraction":
            try:
                reader = neo.io.OpenEphysBinaryIO(dirname=FolderName)
                result_string = (f"Use IO class: {RecordingSystemSelection}")
                print(f"Use IO class: {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                    
            except Exception as e:
                
                result_string = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
                print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
        # -----------------------------------------------------------------------
        ''' Legacy Open ephys format'''
        # -----------------------------------------------------------------------
        if RecordingSystemSelection == "Legacy Open Ephys Format" or RecordingSystemSelection == "Legacy Open Ephys FormatEventExtraction":
            try:
                reader = neo.io.OpenEphysIO(dirname=FolderName)
                result_string = (f"Use IO class: {RecordingSystemSelection}")
                print(f"Use IO class: {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                    
            except Exception as e:
                
                result_string = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
                print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
        
        # -----------------------------------------------------------------------
        ''' NeuroExplorer format'''
        # -----------------------------------------------------------------------
        if RecordingSystemSelection == "NeuroExplorer":
            try:
                reader = neo.io.NeuroExplorerIO(filename=FolderName)
                result_string = (f"Use IO class: {RecordingSystemSelection}")
                print(f"Use IO class: {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                    
            except Exception as e:
                
                result_string = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
                print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                    
        # -----------------------------------------------------------------------
        ''' Blackrock format'''
        # -----------------------------------------------------------------------
        if RecordingSystemSelection == "Blackrock":
            try:
                reader = neo.io.BlackrockIO(filename=FolderName)
                result_string = (f"Use IO class: {RecordingSystemSelection}")
                print(f"Use IO class: {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
                    
            except Exception as e:
                
                result_string = (f"Neo could not detect a recording with type {RecordingSystemSelection}: {e}. Please make sure you preserve the original recording folder and file structure without any additional files in it!")
                print(f"Neo could not detect a recording with type {RecordingSystemSelection}")
                
                with open(DataLoggerSaveFileName, "a") as f:
                    f.write(result_string+"\n")
        
        # -----------------------------------------------------------------------
        ''' Access Data in Loaded Recording'''
        # -----------------------------------------------------------------------
        print("Starting Data Extraction with NEO from " + FolderName)
        result_string = "Starting Data Extraction with NEO from " + FolderName
        with open(DataLoggerSaveFileName, "a") as f:
            f.write(result_string+"\n")
            
        blocks = reader.read(lazy=False)
        block = blocks[0]
        segment = block.segments[0]
        
        analogsignals = segment.analogsignals
        
        Amp_Signal_Object = analogsignals[0]
        
        RawData = Amp_Signal_Object 
        
        print("Loading Data Finished")
        result_string = "Loading Data Finished"
        with open(DataLoggerSaveFileName, "a") as f:
            f.write(result_string+"\n")
        
        # -----------------------------------------------------------------------
        ''' Format channel Data to save as .dat gile'''
        # -----------------------------------------------------------------------
        Method = 1
        if JustExtractingEvents == 0:
            print("Prepraring Data to Save")
            result_string = "Prepraring Data to Save"
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
            
            
            # Build data matrix
            try:
                data = RawData.magnitude.T  # shape will be (n_channels, n_samples)
                Method = 1
            except Exception:
                data = np.vstack([asig.magnitude.flatten() for asig in RawData]) 
                Method = 2
            result_string = "Method: " + str(Method)
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
            
        # -----------------------------------------------------------------------
        ''' Save Channel Data'''
        # -----------------------------------------------------------------------
        if JustExtractingEvents == 0:
            SaveFileName = NEO_Save_Path + "/NEO_Saved_Channel_Data.dat"
            print("Saving Channel Data to " + SaveFileName + " (this might take a while)")
            result_string = "Saving Channel Data to " + SaveFileName
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
            
            data.astype(np.float32).tofile(SaveFileName)  # Save as .dat
        
        # -----------------------------------------------------------------------
        ''' Save MetaData'''
        # -----------------------------------------------------------------------
        # Extract metadata
        sampling_rate = analogsignals[0].sampling_rate.rescale('Hz').magnitude
        units = [str(asig.units.dimensionality) for asig in analogsignals]
        channel_names = [asig.name for asig in analogsignals]
        channel_ids = [asig.annotations.get('channel_id', i) for i, asig in enumerate(analogsignals)]
        
        if JustExtractingEvents == 0:
            # Save metadata as .mat
            SaveFileName = NEO_Save_Path + "/NEO_Saved_MetaData.mat"
            print("Saving Metadata to " + SaveFileName)
            result_string = "Saving Metadata to " + SaveFileName
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
            
            if Method == 2:
                scipy.io.savemat(SaveFileName, {
                    'sampling_rate': sampling_rate,
                    'units': units,
                    'channel_names': channel_names,
                    'channel_ids': channel_ids,
                    'n_channels': data.shape[1],
                    'n_samples': data.shape[0]        
                })
            else:
                scipy.io.savemat(SaveFileName, {
                    'sampling_rate': sampling_rate,
                    'units': units,
                    'channel_names': channel_names,
                    'channel_ids': channel_ids,
                    'n_channels': data.shape[0],
                    'n_samples': data.shape[1]        
                })
        
        # -----------------------------------------------------------------------
        ''' Save Event Data if present'''
        # -----------------------------------------------------------------------
        
        print("Checking for Event Data")
        result_string = "Checking for Event Data"
        with open(DataLoggerSaveFileName, "a") as f:
            f.write(result_string+"\n")
        
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
            
            SaveFileName = NEO_Save_Path + "/NEO_Saved_EventData.mat"
            print("Saving event data to " + SaveFileName)
            result_string = "Saving event data to " + SaveFileName
            
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
            
            print("Event Channel: " + str(all_channels))
            result_string = "Event Channel: " + str(all_channels)
            
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
                
            print("Event Times: " + str(all_times))
            result_string = "Event Times: " + str(all_times)
            
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
                
            print("Event Label: " + str(all_labels))
            result_string = "Event Label: " + str(all_labels)
            
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
            
            # Save to .mat
            scipy.io.savemat(SaveFileName, {
                'event_labels': all_labels,
                'event_samples': all_times,
                'event_channels': all_channels
            })
        else:
            print("No event data found!")
            result_string = "No event data found!"
            with open(DataLoggerSaveFileName, "a") as f:
                f.write(result_string+"\n")
        
        
        print("Finished!")
        result_string = "Finished!"
        with open(DataLoggerSaveFileName, "a") as f:
            f.write(result_string+"\n")
        
    except Exception as e:
        print(f"An error occurred: {e}")
        print("Traceback details:")
        import traceback
        traceback.print_exc()  # Print detailed error information
    finally:
        if KeepConsoleOpen == 1:
            input("Press Enter to exit...")
        
if __name__ == "__main__":

    KeepConsoleOpen = sys.argv[2]   
    KeepConsoleOpen = int(KeepConsoleOpen)

    if KeepConsoleOpen == 1:
        try:
            # Access arguments
            file_path = sys.argv[1]
            JustLoad = sys.argv[3]
            RecordingSystemSelection = sys.argv[4]
            
            JustLoad = int(JustLoad)
            
            if not pyuac.isUserAdmin():
                print("Re-launching as admin!")
                pyuac.runAsAdmin()
            else:                   
                main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen)  # Already an admin here.
    
        except Exception as e:
            print(f"An error occurred: {e}")
            print("Traceback details:")
            import traceback
            traceback.print_exc()  # Print detailed error information
        finally:
            input("Press Enter to exit...")
    
    
    if KeepConsoleOpen == 0:
        # Access arguments
        file_path = sys.argv[1]
        JustLoad = sys.argv[3]
        RecordingSystemSelection = sys.argv[4]
        
        JustLoad = int(JustLoad)
        
        if not pyuac.isUserAdmin():
            print("Re-launching as admin!")
            pyuac.runAsAdmin()
        else:                   
            main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen)  # Already an admin here.
        
            
    

