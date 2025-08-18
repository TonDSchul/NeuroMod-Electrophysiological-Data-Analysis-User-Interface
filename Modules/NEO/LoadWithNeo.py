# -*- coding: utf-8 -*-
"""
Created on Thu Jul 31 16:12:47 2025

@author: tonyd
"""
import os
import sys
import pyuac
import numpy as np
import neo

from Neo_FunctionDeclaration import create_save_folder,Get_Save_Event_Data,Exract_Raw_Channel_Data,Save_MetaData,GetAcquisitionStartSample,Get_Reader,write_DataLogger

def main(FolderName,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveForMatlab):
    # -----------------------------------------------------------------------
    ''' Check what to do'''
    # -----------------------------------------------------------------------
    #### ----------- Check If Data or just Event Extraction ----------- ####
    JustExtractingEvents = 0
    if "EventExtraction" in RecordingSystemSelection:
        JustExtractingEvents = 1
    else:
        JustExtractingEvents = 0
    
    print(RecordingSystemSelection)
    if RecordingSystemSelection == "NEO Plexon" or RecordingSystemSelection == "PlexonEventExtraction":
        file_list = [
            os.path.join(FolderName, f)
            for f in os.listdir(FolderName)
            if f.lower().endswith(".plx")
        ]
        print(file_list)
    elif RecordingSystemSelection == "NEO NeuroExplorer" or RecordingSystemSelection == "NeuroExplorerEventExtraction":
        file_list = [
            os.path.join(FolderName, f)
            for f in os.listdir(FolderName)
            if f.lower().endswith(".nex")
        ]
        print(file_list)
    else:
        file_list = FolderName
        file_list = [file_list]  # wrap single string into a list
    
    
    # -----------------------------------------------------------------------
    ''' First Create a Save Folder to save results in for Matlab to load'''
    # -----------------------------------------------------------------------
    #### ----------- Create Save folder next to recording folder ----------- ####
    NEO_Save_Path = create_save_folder(FolderName)
    #### ------------ Set Folder name for raw channel data ----------- ####
    ChannelDataSaveFileName = NEO_Save_Path + "/NEO_Saved_Channel_Data.dat"
    #### ------------ Set Folder name for MetaData ----------- ####
    MetaDataSaveFileName = NEO_Save_Path + "/NEO_Saved_MetaData.mat"
    #### ------------ Set Folder name for Event Data ----------- ####
    EventSaveFileName = NEO_Save_Path + "/NEO_Saved_EventData.mat"
    #### ----------- Set save location for datalogger ----------- ####
    NeoMatConversionPath = NEO_Save_Path + "/NEOMatlabConversion.mat"
    #### ----------- Set save location for datalogger ----------- ####
    DataLoggerSaveFileName = NEO_Save_Path + "/Logger.txt"
    
    #### ----------- Save Info wat was done ----------- ####
    print("Created Folder to Save Channel Data and Metadata for matlab to read: " + NEO_Save_Path)
    LoggerMessage = ("Created Folder to Save Channel Data and Metadata for matlab to read: " + NEO_Save_Path)
    print("Starting Data Extraction with NEO from " + FolderName)
    LoggerMessage = LoggerMessage + "Starting Data Extraction with NEO from " + FolderName
    print("Checking if a suitable recording format is found in selected folder:")
    LoggerMessage = LoggerMessage + "Checking if a suitable recording format is found in selected folder:"
    write_DataLogger(LoggerMessage,DataLoggerSaveFileName)
    
    # -----------------------------------------------------------------------
    ''' Loop over all files or the single folder selected, depending in the foramt selected'''
    # -----------------------------------------------------------------------
    
    RawData = None
    first = True
    
    for file in file_list:
        
        SelectedDataFolder = file
        
        RawDataChunk = None
        reader = None
        start_sample = None
        analogsignals = None
        
        # -----------------------------------------------------------------------
        ''' Get Recording Reader and start sample number '''
        # -----------------------------------------------------------------------
        reader = Get_Reader(SelectedDataFolder,DataLoggerSaveFileName,RecordingSystemSelection)

        # -----------------------------------------------------------------------
        ''' Access Data in Loaded Recording'''
        # -----------------------------------------------------------------------
        if first == True:
            print("Starting Data Extraction with NEO from " + FolderName)
            write_DataLogger("Starting Data Extraction with NEO from " + FolderName,DataLoggerSaveFileName)
        
        RawDataChunk,analogsignals,block = Exract_Raw_Channel_Data(reader)
        
        #### ----------- If applicable: Find start sample of recording start in respect to acquisition start ----------- ####
        if first == True:
            try:
                start_sample = GetAcquisitionStartSample(block)
            except Exception:
                start_sample = None
        # -----------------------------------------------------------------------
        ''' Format channel Data and concatonate of necessary'''
        # -----------------------------------------------------------------------
        Method = 1
        if JustExtractingEvents == 0:
            if first == True:
                print("Prepraring Data to Save")
                write_DataLogger("Prepraring Data to Save",DataLoggerSaveFileName)
            
            # Build data matrix
            try:
                RawDataChunk = RawDataChunk.magnitude.T  # shape will be (n_channels, n_samples)
                Method = 1
            except Exception:
                RawDataChunk = np.vstack([asig.magnitude.flatten() for asig in RawDataChunk]) 
                Method = 2
            
            #RawDataChunk = RawDataChunk.T
            
            if RawData is not None:
                RawData = np.hstack((RawData, RawDataChunk))
            else:
                RawData = RawDataChunk
        
        write_DataLogger("Method: " + str(Method),DataLoggerSaveFileName)
        first = False
    #  ----------------------------------------------------------------------- END OF LOOP ----------------------------------------------------------------------- 
    #  -----------------------------------------------------------------------
    
    # -----------------------------------------------------------------------
    ''' Save Save Event, Meta Data and Channel Data in costume format'''
    # -----------------------------------------------------------------------
    if JustExtractingEvents == 0 and FormatToSaveForMatlab == "Costume files (.dat,.mat)":
        
        # -----------------------------------------------------------------------
        ''' Save Event Data If present'''
        # -----------------------------------------------------------------------
        #if JustExtractingEvents == 1:
        sampling_rate = analogsignals[0].sampling_rate.rescale('Hz').magnitude
        Get_Save_Event_Data(DataLoggerSaveFileName,reader,sampling_rate,EventSaveFileName)
        
        # -----------------------------------------------------------------------
        ''' Save MetaData'''
        # -----------------------------------------------------------------------
        NrChannel = RawDataChunk.shape[0]
        NrSamples = RawDataChunk.shape[1]
        Save_MetaData(analogsignals,start_sample,JustExtractingEvents,MetaDataSaveFileName,DataLoggerSaveFileName,Method,NrChannel,NrSamples)
        
        print("Saving Channel Data to " + ChannelDataSaveFileName + " (this might take a while)")
        write_DataLogger("Saving Channel Data to " + ChannelDataSaveFileName,DataLoggerSaveFileName)
        
        RawData.astype(np.float32).tofile(ChannelDataSaveFileName)  # Save as .dat      
    
    # -----------------------------------------------------------------------
    ''' Save Channel Data and Save MetaData in Neo Matlab conversion format'''
    # -----------------------------------------------------------------------
    if JustExtractingEvents == 0 and FormatToSaveForMatlab == "NEO Format to .mat Conversion":
        w = neo.io.NeoMatlabIO(filename=NeoMatConversionPath)
        blocks = reader.read()
        w.write(blocks[0])
        
        if start_sample is None:
            write_DataLogger("Acqusition Start Sample:" + str(1),DataLoggerSaveFileName)
        else:
            write_DataLogger("Acqusition Start Sample:" + str(start_sample),DataLoggerSaveFileName)

    print("Finished!")
    write_DataLogger("Finished!",DataLoggerSaveFileName)
                
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
                main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveandReadintoMatlab)  # Already an admin here.
    
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
        FormatToSaveandReadintoMatlab = sys.argv[5]
        
        JustLoad = int(JustLoad)
        
        if not pyuac.isUserAdmin():
            print("Re-launching as admin!")
            pyuac.runAsAdmin()
        else:                   
            main(file_path,JustLoad,RecordingSystemSelection,KeepConsoleOpen,FormatToSaveandReadintoMatlab)  # Already an admin here.
        
            
    

