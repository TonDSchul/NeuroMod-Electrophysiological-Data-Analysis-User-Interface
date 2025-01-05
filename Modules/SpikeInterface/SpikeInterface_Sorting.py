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


FolderToStartAt = 1 # only when MultipleRecordings = 1

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
    PlotTraces = sys.argv[13]  # Second argument
    
    VerChannelOffset = sys.argv[14]  
    HorChannelOffset = sys.argv[15]  
    NumberRows = sys.argv[16]  
    RowOffset = sys.argv[17]  
    RowOffsetDistance = sys.argv[18]  
    
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
    PlotTraces = int(PlotTraces);
    
    VerChannelOffset = int(VerChannelOffset);
    HorChannelOffset = int(HorChannelOffset);
    NumberRows = int(NumberRows);
    RowOffset = int(RowOffset);
    RowOffsetDistance = int(RowOffsetDistance);
    
    num_elec = int(num_elec)
    ypitch = int(ypitch)
    
    print(f"Received arguments: {file_path}, {MultipleRecordings}, {Sorter}, {Apply_Preprocessing}, {LoadSpikeSorting}, {OpenSpikeInterface_GUI}, {Plot_Results}, {JustOpenSpikeInterfaceGUI} , {SampleRate}")
    
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
            CompletePath = file_path+"/"+Filename+"/SpikeInterface"
        else:
            print("Analyzing a single folder.")
            CompletePath = subfolders;
        
        print(IterMessage)
        print(CompletePath)
        
        #if Sorter in ['Kilosort 4']:
        #    BinFiles = get_dat_files(CompletePath)
        #else:
            
        BinFiles = get_bin_files(CompletePath)
            
        PathToLoad = CompletePath+"/"+BinFiles[0]
        
        PathForPhy = CompletePath + "/SpikeInterface_Sorting_Phy_Results/"+Sorter
        ### Path to save sorting results in to load later
        Save_Sorting_Folder = CompletePath + "/SpikeInterface_Saved_Sorting/"+Sorter
                
        if LoadSpikeSorting == 0:
            print("Attempting to delete already existing folder:")
            print(PathForPhy)
            print(Save_Sorting_Folder)
            DeleteFolderContents(PathForPhy)
            DeleteFolderContents(Save_Sorting_Folder)
        
        """ ################################################################ Start Processing ###################################################################### """
            
        Recording = Load_Binary_In_SpikeInterface(PathToLoad,SampleRate,num_elec,Sorter)
        
        Probe = Create_Probe(num_elec,ypitch,PlotTraces,RowOffsetDistance,RowOffset,NumberRows,HorChannelOffset,VerChannelOffset,Recording)
        
        Recording = Recording.set_probe(Probe)
        
        DumpedRecording = Preprocessing(Recording,Probe,Apply_Preprocessing);
        
        if PlotTraces == 1:
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
    
        """ ################################################################ Save SpikePositions as .mat###################################################################### """
        if LoadSpikeSorting == 0:
            SaveSpikePosition_mat(PathForPhy,Analyzer)
        
        
        """ ################################################################ Spikeinterface GUI ###################################################################### """
        if OpenSpikeInterface_GUI == 1:   
           
            sw.plot_sorting_summary(Analyzer, backend="spikeinterface_gui")
            
    
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
            
