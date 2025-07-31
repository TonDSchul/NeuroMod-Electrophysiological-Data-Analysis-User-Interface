# -*- coding: utf-8 -*-
"""
Created on Thu Jul 31 16:12:47 2025

@author: tonyd
"""
import time
import os
import sys
import pyuac
import numpy as np
import scipy.io
import neo

from neo.io import OpenEphysBinaryIO
import os


def main(FolderName,JustLoad):
 
    # Load Open Ephys Binary data
    print("Starting Data Extraction with NEO from " + FolderName)
    
    print("Loading Data with format " )
    
    #if Format == "New Open Ephys Format":
    # test 
    #if OpenEphysBinaryRawIO.is_supported(FolderName):
    #    result_string = "Folder contains a valid Open Ephys Binary recording."
    reader = neo.io.OpenEphysBinaryIO(FolderName)
    #else:
    #    result_string = "Folder does NOT contain a valid Open Ephys Binary recording."
        
    # Save to .txt file
    #SaveFileName = FolderName + "/NeoRawData/ExtractionInfo.txt"
    #with open(SaveFileName, "w") as f:
    #    f.write(result_string)
        
    blocks = reader.read(lazy=False)
    block = blocks[0]
    segment = block.segments[0]
    
    analogsignals = segment.analogsignals
    
    Amp_Signal_Object = analogsignals[0]
    
    RawData = Amp_Signal_Object 
    
    print("Loading Data Finished")
    
    print("Prepraring Data to Save (this might take a while)")
    # Build data matrix 
    data = np.vstack([asig.magnitude.flatten() for asig in RawData])  # shape: (channels, samples)
    
    # check of folder exists and if necessary create it
    save_dir = os.path.join(FolderName, "NeoRawData")
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)
        
    SaveFileName = FolderName + "/NeoRawData/NEO_Saved_Channel_Data.dat"
    print("Saving Channel Data to " + SaveFileName)
    data.astype(np.float32).tofile(SaveFileName)  # Save as .dat
    
    # Extract metadata
    sampling_rate = analogsignals[0].sampling_rate.rescale('Hz').magnitude
    units = [str(asig.units.dimensionality) for asig in analogsignals]
    channel_names = [asig.name for asig in analogsignals]
    channel_ids = [asig.annotations.get('channel_id', i) for i, asig in enumerate(analogsignals)]
    
    # Save metadata as .mat
    SaveFileName = FolderName + "/NeoRawData/NEO_Saved_MetaData.mat"
    print("Saving Metadata to " + SaveFileName)
    scipy.io.savemat(SaveFileName, {
        'sampling_rate': sampling_rate,
        'units': units,
        'channel_names': channel_names,
        'channel_ids': channel_ids,
        'n_channels': data.shape[1],
        'n_samples': data.shape[0]
    })
    
    print("Finished!")

if __name__ == "__main__":
    
    file_path = sys.argv[1]
    KeepConsoleOpen = sys.argv[2]
    JustLoad = sys.argv[3]
    
    if KeepConsoleOpen == 1:
        try:
            # Access arguments
            file_path = sys.argv[1]
            KeepConsoleOpen = sys.argv[2]
            JustLoad = sys.argv[3]
            
            if not pyuac.isUserAdmin():
                print("Re-launching as admin!")
                pyuac.runAsAdmin()
            else:                   
                main(file_path,JustLoad)  # Already an admin here.
    
        
        except Exception as e:
            print(f"An error occurred: {e}")
            print("Traceback details:")
            import traceback
            traceback.print_exc()  # Print detailed error information
        finally:
            input("Press Enter to exit...")
    else:
        # Access arguments
        file_path = sys.argv[1]
        KeepConsoleOpen = sys.argv[2]
        JustLoad = sys.argv[3]
        
        if not pyuac.isUserAdmin():
            print("Re-launching as admin!")
            pyuac.runAsAdmin()
        else:                   
            main(file_path,JustLoad)  # Already an admin here.
            
    

