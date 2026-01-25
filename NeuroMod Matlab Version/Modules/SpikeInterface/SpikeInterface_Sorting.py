# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import spikeinterface.full as si
import json
import spikeinterface.widgets as sw
import matplotlib.pyplot as plt
from spikeinterface import load

from spikeinterface.exporters import export_to_phy
import shutil

from SpikeInterface_FunctionDeclaration import Load_Binary_In_SpikeInterface
from SpikeInterface_FunctionDeclaration import Create_Probe
from SpikeInterface_FunctionDeclaration import Preprocessing
from SpikeInterface_FunctionDeclaration import combined_plot


from SpikeInterface_FunctionDeclaration import SortWithSpikingCircus
from SpikeInterface_FunctionDeclaration import SortWithMountainSort
from SpikeInterface_FunctionDeclaration import CreateSortingAnalyzer
from SpikeInterface_FunctionDeclaration import PlotTemplatesandRaster
from SpikeInterface_FunctionDeclaration import DeleteFolderContents
from SpikeInterface_FunctionDeclaration import SaveSpikePosition_mat
from SpikeInterface_FunctionDeclaration import get_all_subfolders
from SpikeInterface_FunctionDeclaration import get_bin_files
from SpikeInterface_FunctionDeclaration import get_dat_files

import os
import sys
import pyuac



FolderToStartAt = 1 # only when MultipleRecordings = 1

""" ################################################################ PipeLine functions ###################################################################### """

def main(subfolders,file_path,GUIParamsfile):
    ## first load GUI params guiding what is done in this script and giving probe layout etc
    with open(GUIParamsfile, 'r') as f:
        GUIparams = json.load(f)

    file_path = GUIparams['file_path']
    MultipleRecordings = int(GUIparams['MultipleRecordings'])
    Sorter = GUIparams['SelectedSorter']
    Apply_Preprocessing = int(GUIparams['Preprocess'])
    LoadSpikeSorting = int(GUIparams['LoadSorting'])
    OpenSpikeInterface_GUI = int(GUIparams['OpenSpikeInterface'])
    Plot_Results = int(GUIparams['PlotSortingResults'])
    JustOpenSpikeInterfaceGUI = int(GUIparams['JustOpenSpikeInterfaceGUI'])
    SampleRate = float(GUIparams['SampleRate'])
    num_elec = int(GUIparams['NumChannel'])
    ypitch = float(GUIparams['ypitch'])
    KeepConsoleOpen = int(GUIparams['KeepConsoleOpen'])
    PlotTraces = int(GUIparams['PlotTraces'])
    VerChannelOffset = int(GUIparams['VerChannelOffset'])
    HorChannelOffset = int(GUIparams['HorChannelOffset'])
    NumberRows = int(GUIparams['NumberRows'])
    RowOffset = int(GUIparams['RowOffset'])
    RowOffsetDistance = int(GUIparams['RowOffsetDistance'])
    RecordingType = GUIparams['RecordingType']
        
    # Arrays
    AllChannel = int(GUIparams['AllChannel'])  # if stored as 0/1 in JSON
    ActiveChannel = GUIparams['ActiveChannel']
    Xcoords = GUIparams['xCoords']
    Ycoords = GUIparams['yCoords']
    
    if os.path.exists(GUIParamsfile):
        os.remove(GUIParamsfile)
        print(f"Deleted file: {GUIParamsfile}")
    else:
        print("File does not exist, nothing to delete.")
            
    # Read the JSON file
    JsonFilename = os.path.join(file_path, 'sorting_parameters.json')
    with open(JsonFilename, 'r') as f:
        SortingParameter = json.load(f)
            
    print(f"Received arguments: {file_path}, {MultipleRecordings}, {Sorter}, {Apply_Preprocessing}, {LoadSpikeSorting}, {OpenSpikeInterface_GUI}, {Plot_Results}, {JustOpenSpikeInterfaceGUI} , {SampleRate}")
    
    print("SpikeInterface Version installed: " + si.__version__)
    
    print("Installed Sorter:")
    
    ISO = si.installed_sorters()
    print(ISO)
    
    """ ################################################################ Manage Folder Structure ###################################################################### """
    
    if MultipleRecordings==0:
        file_path = subfolders
        NumIter = 1
        LoopIterations = list(range(1, 2))
    else:
        NumIter = len(subfolders)
        print("Looping through " + str(NumIter) + " Folder(s)")
        LoopIterations = list(range(FolderToStartAt, NumIter + 1))
        
    for nIteration in LoopIterations:
        IterMessage = "Analysing Folder " + str(nIteration)
        
        if MultipleRecordings == 1:
            print("Loooing over multiple folder.")
            Filename = subfolders[nIteration - 1]
            CompletePath = os.path.join(file_path,Filename,"SpikeInterface")
        else:
            if Sorter in ['Kilosort 4']:
                CompletePath = subfolders[:subfolders.rfind("\\")] + "\\Kilosort"
            else:
                CompletePath = subfolders;
            
            print("Analyzing a single folder.")           
        
        print(IterMessage)
        print(CompletePath)
        
        if Sorter in ['Kilosort 4']:
            BinFiles = get_dat_files(CompletePath)
            print(BinFiles)
        else:            
            BinFiles = get_bin_files(CompletePath)
                    
        PathToLoad = os.path.join(CompletePath,BinFiles[0])

        PathToSaveCached = os.path.join(CompletePath, "Chached Recording")
        os.makedirs(PathToSaveCached, exist_ok=True)
        
        # Create Folder to save results that are loaded into Matlab
        PathForPhy = os.path.join(CompletePath, "SpikeInterface_Sorting_Phy_Results", Sorter)
        os.makedirs(PathForPhy, exist_ok=True)
        
        ### Path to save sorting results in to load later
        Save_Sorting_Folder = os.path.join(CompletePath, "SpikeInterface_Saved_Sorting", Sorter)
        if LoadSpikeSorting == 0:
            if os.path.exists(Save_Sorting_Folder):
                try:
                    shutil.rmtree(Save_Sorting_Folder)
                    print(f"Deleted existing folder: {Save_Sorting_Folder}")
                except Exception as e:
                    print(f"Could not delete {Save_Sorting_Folder}: {e}")
        
        """ ################################################################ Start Processing ###################################################################### """
            
        Recording = Load_Binary_In_SpikeInterface(PathToLoad,SampleRate,num_elec,Sorter,CompletePath)
        
        Probe = Create_Probe(num_elec,ypitch,PlotTraces,RowOffsetDistance,RowOffset,NumberRows,HorChannelOffset,VerChannelOffset,Recording,AllChannel,ActiveChannel,Xcoords,Ycoords,RecordingType)
            
        Recording = Recording.set_probe(Probe)
        
        if LoadSpikeSorting == 0: 
            if Sorter in ['Kilosort 4']:
                CachedRecording = Recording.save(format='binary', dtype = 'float32',folder=PathToSaveCached, n_jobs = 4, overwrite=True)
                CachedRecording.annotate(is_filtered=False)
                CachedRecording = CachedRecording.set_probe(Probe)
            if Sorter in ['SpyKING CIRCUS 2']:
                CachedRecording = Recording.save(format='binary', dtype = 'float64', folder=PathToSaveCached, n_jobs = 4, overwrite=True)
                CachedRecording.annotate(is_filtered=False)
                CachedRecording = CachedRecording.set_probe(Probe)
            if Sorter in ['Mountainsort 5']:
                CachedRecording = Recording.save(format='binary', dtype = 'float64', folder=PathToSaveCached, n_jobs = 4, overwrite=True)
                CachedRecording.annotate(is_filtered=False)
                CachedRecording = CachedRecording.set_probe(Probe)
        else:
            CachedRecording = Recording
            CachedRecording.annotate(is_filtered=False)
                        
            CachedRecording = CachedRecording.set_probe(Probe)
                
        if Apply_Preprocessing == 1:
            print("Preprocessing Data before Sorting")
            DumpedRecording = Preprocessing(CachedRecording,Probe,Apply_Preprocessing);
            DumpedRecording.annotate(is_filtered=True)
            DumpedRecording = DumpedRecording.set_probe(Probe)
        else:
            print("Not Preprocessing Data before Sorting")
            DumpedRecording = CachedRecording
            DumpedRecording.annotate(is_filtered=False)
            DumpedRecording = DumpedRecording.set_probe(Probe)
            
        
        if PlotTraces == 1:
            combined_plot(CachedRecording,DumpedRecording,ypitch)
        
        """ ################################################################ Start/Load Sorting ###################################################################### """
                
        if LoadSpikeSorting == 0:    
            
            print("Creating new sorting...")
            
            if Sorter in ['SpyKING CIRCUS 2']:
                DumpedRecording = DumpedRecording.set_probe(Probe)
                
                sorting = SortWithSpikingCircus(DumpedRecording,Save_Sorting_Folder,Apply_Preprocessing,SortingParameter)
                
                sorting = sorting.save(folder=Save_Sorting_Folder,overwrite=True)
                
            if Sorter in ['Mountainsort 5']:
                DumpedRecording = DumpedRecording.set_probe(Probe)
                
                sorting = SortWithMountainSort(DumpedRecording,Save_Sorting_Folder,Apply_Preprocessing,SortingParameter)
                
                sorting = sorting.save(folder=Save_Sorting_Folder,overwrite=True)
                                
        else:
            sorting = load(Save_Sorting_Folder)
        
        """ ################################################################ Create Analyzer ###################################################################### """
        
        Analyzer = CreateSortingAnalyzer(DumpedRecording,sorting,Save_Sorting_Folder,LoadSpikeSorting)
        
        """ ################################################################ Plot Sorting ###################################################################### """
        if Plot_Results == 1:
            print("Plotting Results...")
            # Template Plot
            PlotTemplatesandRaster(Analyzer)
            plt.show()    # Pause 5.5 seconds
            # Waveform Plot
            sw.plot_unit_waveforms(Analyzer)
            plt.show()   
            # Raster Plot
            si.plot_rasters(sorting, time_range=(1, 20), backend="matplotlib")
            plt.show()
            # Summaries
            #sw.plot_unit_summary(Analyzer, unit_id=1)
            sw.plot_unit_summary(Analyzer, unit_id=2)
            plt.show()
            sw.plot_unit_summary(Analyzer, unit_id=3)
            plt.show()
        
            #sw.plot_unit_probe_map(Analyzer, unit_ids=[1,2])
            #plt.show()
            
        """ ################################################################ Export To Phy ###################################################################### """
        
        if LoadSpikeSorting == 0:
            try:
                shutil.rmtree(PathForPhy)
            except FileNotFoundError:
                print("The folder does not exist.")
            except Exception as e:
                print(f"An error occurred: {e}")
               
            export_to_phy(sorting_analyzer=Analyzer, output_folder=PathForPhy, copy_binary=False)
    
        """ ################################################################ Save SpikePositions as .mat###################################################################### """
        if LoadSpikeSorting == 0:
            SaveSpikePosition_mat(PathForPhy,Analyzer)
        
        """ ################################################################ Spikeinterface GUI ###################################################################### """
        if OpenSpikeInterface_GUI == 1:   
           
            sw.plot_sorting_summary(Analyzer, backend="spikeinterface_gui")
                
        #### Warp up by deleting cached recording
        CachedRecording = None
        DeleteFolderContents(PathToSaveCached)
    
if __name__ == "__main__":
    # First Load mat file with GUI params guiding execution here
    GUIParamsfile = sys.argv[1]
    print(GUIParamsfile)
    # Load JSON with gui info
    with open(GUIParamsfile, 'r') as f:
        GUIparams = json.load(f)

    file_path = GUIparams['file_path']
    MultipleRecordings = int(GUIparams['MultipleRecordings'])
    Sorter = GUIparams['SelectedSorter']
    LoadSpikeSorting = int(GUIparams['LoadSorting'])
    OpenSpikeInterface_GUI = int(GUIparams['OpenSpikeInterface'])
    Plot_Results = int(GUIparams['PlotSortingResults'])
    JustOpenSpikeInterfaceGUI = int(GUIparams['JustOpenSpikeInterfaceGUI'])
    KeepConsoleOpen = int(GUIparams['KeepConsoleOpen'])
    PlotTraces = int(GUIparams['PlotTraces'])
    
    print("GUI params loaded successfully!")

    if KeepConsoleOpen == 1:
        try:
            if not pyuac.isUserAdmin():
                print("Re-launching as admin!")
                pyuac.runAsAdmin()
            else:     
                if MultipleRecordings == 1:
                   
                    folder_path = file_path
                    
                    if folder_path:
                        subfolders = get_all_subfolders(folder_path)
                        print("Subfolders found:")
                        for subfolder in subfolders:
                            print(subfolder)
                    else:
                        print("No folder was selected.")
                else:
                    subfolders = file_path
                
                main(subfolders,file_path,GUIParamsfile)  
                
        except Exception as e:
            print(f"An error occurred: {e}")
            print("Traceback details:")
            import traceback
            traceback.print_exc()  
        finally:
            input("Press Enter to exit...")
    else:
        
        if not pyuac.isUserAdmin():
            print("Re-launching as admin!")
            pyuac.runAsAdmin()
        else:     
            if MultipleRecordings == 1:
               
                folder_path = file_path
                
                if folder_path:
                    subfolders = get_all_subfolders(folder_path)
                    print("Subfolders found:")
                    for subfolder in subfolders:
                        print(subfolder)
                else:
                    print("No folder was selected.")
            else:
                subfolders = file_path
            
            
            main(subfolders,file_path,GUIParamsfile) 
            
