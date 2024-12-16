# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import spikeinterface.full as si
import spikeinterface.preprocessing as spre
import spikeinterface.sorters as ss
import spikeinterface.sortingcomponents as so
import spikeinterface.widgets as sw
from spikeinterface import create_sorting_analyzer, load_sorting_analyzer
import numpy as np
from probeinterface import generate_linear_probe
from probeinterface.plotting import plot_probe
import matplotlib.pyplot as plt
from pprint import pprint
from spikeinterface import load_extractor
from pathlib import Path
from spikeinterface.preprocessing import common_reference
from spikeinterface.exporters import export_to_phy
import shutil
import json

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
from SpikeInterface_FunctionDeclaration import SortWithKilosort

from DeletePermissionErrorHandle import DeletePermittedHandle

import os
import sys
import pyuac
import tkinter as tkste
from tkinter import filedialog


### Specify Probe
#num_elec=16

#ypitch=100

#MultipleRecordings = 0
FolderToStartAt = 1 # only when MultipleRecordings = 1
PlotTraces = 0;
#Sorter = 'mountainsort5' # ['herdingspikes', 'mountainsort5', 'simple', 'spykingcircus2', 'tridesclous2']

### Data Path with .bin file of your recording
#file_path = "F:/100 µm channel spacing/100 µm channel spacing/STO-9920_24_EAE_iso_0,6_hippo1"
#file_path = "F:/100 µm channel spacing/100 µm channel spacing"

TempCacheFolder = "C:/Users/tonyd/AppData/Local/Temp/spikeinterface_cache"

### Pick the sorter you want to use

### Choose whether to preprocess data prior to sorting
#Apply_Preprocessing = 1;
### Specify whether new spike sorting should be created or existing sorting should be loaded
#LoadSpikeSorting = 0;
### Specify whether spikeinterface GUI should be openend with sorting data
#OpenSpikeInterface_GUI = 1;
### Specify whether to plot some results (traces, raster, uni summary, waveforms, templates)
#Plot_Results = 0
### Specify whether to just load spike sorting
#JustOpenSpikeInterfaceGUI = 0;

""" ################################################################ PipeLine functions ###################################################################### """

def main(subfolders,file_path):
    
    file_path = sys.argv[1]
    Sorter = sys.argv[3]  # First argument
    MultipleRecordings = sys.argv[2]  # Second argument
    Apply_Preprocessing = sys.argv[4]  # Second argument
    LoadSpikeSorting = sys.argv[5]  # First argument
    OpenSpikeInterface_GUI = sys.argv[6]  # Second argument
    Plot_Results = sys.argv[7]  # First argument
    JustOpenSpikeInterfaceGUI = sys.argv[8]  # Second argument
    SampleRate = sys.argv[9]  # Second argument
    num_elec = sys.argv[10]  # Second argument
    ypitch = sys.argv[11]  # Second argument
    
    # Read the JSON file
    #json_file_path = sys.argv[12]  # Assume it's the last argument
    JsonFilename = file_path+"/sorting_parameters.json"
    with open(JsonFilename, 'r') as f:
        SortingParameter = json.load(f)
        
    MultipleRecordings = int(MultipleRecordings);
    Apply_Preprocessing = int(Apply_Preprocessing);
    LoadSpikeSorting = int(LoadSpikeSorting);
    OpenSpikeInterface_GUI = int(OpenSpikeInterface_GUI);
    JustOpenSpikeInterfaceGUI = int(JustOpenSpikeInterfaceGUI);
    Plot_Results = int(Plot_Results);
    
    num_elec = int(num_elec)
    ypitch = int(ypitch)
    
    print(f"Received arguments: {file_path}, {MultipleRecordings}, {Sorter}, {Apply_Preprocessing}, {LoadSpikeSorting}, {OpenSpikeInterface_GUI}, {Plot_Results}, {JustOpenSpikeInterfaceGUI} , {SampleRate}")
    
    print("Installed Sorter:")
    
    #ISO = si.installed_sorters()
    #print(ISO)
    
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
            CompletePath = file_path+"/"+Filename+"/SpikeInterface"
        else:
            print("Analyzing a single folder.")
            CompletePath = subfolders;
        
        print(IterMessage)
        print(CompletePath)
        
        #if Sorter in ['Kilosort 4']:
        #     BinFiles = get_dat_files(CompletePath)
        #else:
        BinFiles = get_bin_files(CompletePath)
            
        PathToLoad = CompletePath+"/"+BinFiles[0]
        
        PathForPhy = CompletePath + "/SpikeInterface_Sorting_Phy_Results/"+Sorter
        ### Path to save sorting results in to load later
        Save_Sorting_Folder = CompletePath + "/SpikeInterface_Saved_Sorting/"+Sorter
        
        print("Attempting to delete already existing folder:")
        
        if LoadSpikeSorting == 0:
            DeleteFolderContents(PathForPhy)
            DeleteFolderContents(Save_Sorting_Folder)
        
        """ ################################################################ Start Processing ###################################################################### """
            
        Recording = Load_Binary_In_SpikeInterface(PathToLoad,SampleRate,num_elec,Sorter)
        
        Probe = Create_Probe(num_elec,ypitch,PlotTraces)
        
        Recording = Recording.set_probe(Probe)
        
        DumpedRecording = Preprocessing(Recording,Probe,Apply_Preprocessing,TempCacheFolder);
        
        if PlotTraces == 1:
            print("Not plotting traces...")
            combined_plot(Recording,DumpedRecording,ypitch)
        
        """ ################################################################ Start/Load Sorting ###################################################################### """
        
        """
        Checks if a folder exists. If not, creates the folder.
        
        Parameters:
        folder_path (str): Path to the folder to check/create.
        """
        if not os.path.exists(Save_Sorting_Folder):
            print(f"Folder '{Save_Sorting_Folder}' does not exist. Creating it...")
            #os.makedirs(Save_Sorting_Folder)
            print(f"Folder '{Save_Sorting_Folder}' created successfully.")
        else:
            print(f"Folder '{Save_Sorting_Folder}' already exists.")
        
        if LoadSpikeSorting == 0:    
            
            print("Creating new sorting...")
            
            if Sorter in ['SpykingCircus 2']:
                sorting = SortWithSpikingCircus(DumpedRecording,Save_Sorting_Folder,Apply_Preprocessing,SortingParameter)
                
                try:
                    shutil.rmtree(Save_Sorting_Folder)
                except FileNotFoundError:
                    print("The folder does not exist.")
                except Exception as e:
                    print(f"An error occurred: {e}")
                
                #sorting.save(folder=Save_Sorting_Folder,overwrite=True)
                
            if Sorter in ['Mountainsort 5']:
                sorting = SortWithMountainSort(DumpedRecording,Save_Sorting_Folder,Apply_Preprocessing,SortingParameter)
                try:
                    shutil.rmtree(Save_Sorting_Folder)
                except FileNotFoundError:
                    print("The folder does not exist.")
                except Exception as e:
                    print(f"An error occurred: {e}")
                #sorting = sorting.save()
                
                sorting.save(folder=Save_Sorting_Folder,overwrite=True)
                
            if Sorter in ['Kilosort 4']:
                sorting = SortWithKilosort(DumpedRecording,Save_Sorting_Folder,Apply_Preprocessing,SortingParameter)
                try:
                    shutil.rmtree(Save_Sorting_Folder)
                except FileNotFoundError:
                    print("The folder does not exist.")
                except Exception as e:
                    print(f"An error occurred: {e}")
                #sorting = sorting.save()
                
                sorting.save(folder=Save_Sorting_Folder,overwrite=True)
                
        else:
            sorting = load_extractor(Save_Sorting_Folder)
        
        """ ################################################################ Create Analyzer ###################################################################### """
        
        Analyzer = CreateSortingAnalyzer(DumpedRecording,sorting,Save_Sorting_Folder)
        
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
               
            export_to_phy(sorting_analyzer=Analyzer, output_folder=PathForPhy)
    
        """ ################################################################ Spikeinterface GUI ###################################################################### """
        if OpenSpikeInterface_GUI == 1:   
            sw.plot_sorting_summary(Analyzer, backend="spikeinterface_gui")
    
        """ ################################################################ Save SpikePositions as .mat###################################################################### """
        if LoadSpikeSorting == 0:
            SaveSpikePosition_mat(PathForPhy,Analyzer)
    
    
if __name__ == "__main__":
    
    KeepConsoleOpen = sys.argv[12]
    KeepConsoleOpen = int(KeepConsoleOpen)
    
    if KeepConsoleOpen == 1:
        try:
            # Access arguments
            file_path = sys.argv[1]
            Sorter = sys.argv[3]  # First argument
            MultipleRecordings = sys.argv[2]  # Second argument
            Apply_Preprocessing = sys.argv[4]  # Second argument
            LoadSpikeSorting = sys.argv[5] # First argument
            OpenSpikeInterface_GUI = sys.argv[6] # Second argument
            Plot_Results = sys.argv[7] # First argument
            JustOpenSpikeInterfaceGUI = sys.argv[8]  # Second argument
            SampleRate = sys.argv[9]  # Second argument
            
            MultipleRecordings = int(MultipleRecordings);
            
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
                
                
                main(subfolders,file_path)  # Already an admin here.
                
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
        Sorter = sys.argv[3]  # First argument
        MultipleRecordings = sys.argv[2]  # Second argument
        Apply_Preprocessing = sys.argv[4]  # Second argument
        LoadSpikeSorting = sys.argv[5] # First argument
        OpenSpikeInterface_GUI = sys.argv[6] # Second argument
        Plot_Results = sys.argv[7] # First argument
        JustOpenSpikeInterfaceGUI = sys.argv[8]  # Second argument
        SampleRate = sys.argv[9]  # Second argument
        
        MultipleRecordings = int(MultipleRecordings);
        
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
            
            
            main(subfolders,file_path)  # Already an admin here.
            
