from pynwb import NWBHDF5IO
import matplotlib.pyplot as plt
import numpy as np

# Script to load a .nwb file saved in NeuroMod. using pynwb. Signal and (if present) event data is plotted 
# just exchange this path with the path to your .nwb file and execute the script in an environment in which pynwb was installed
# with: python Load_Saved_NWB_Example.py

nwb_path = "Path_to_SaveFile/NWB_File.nwb"

with NWBHDF5IO(nwb_path, 'r') as io:
    '''
    ######################### Extract Data from nwb #########################
    '''
    nwbfile = io.read()
    '''
    ######################### # --- Extract ElectricalSeries data --- #########################
    '''
    es = list(nwbfile.acquisition.values())[0]
    data = es.data[:]  # shape: [time, channels] or [time] if 1D
    sampling_rate = es.rate

    # Check if data is 2D or 1D
    if data.ndim == 2:
        channel_idx = 0  # channel to plot
        signal = data[:, channel_idx]
    else:
        signal = data

    duration_sec = len(signal) / sampling_rate
    time = np.arange(len(signal)) / sampling_rate
    '''
    ######################### # --- Extract event times and labels --- #########################
    '''
    # Assuming events stored under intervals group with name 'Events_Chan1'
    if 'Events_Chan1' in nwbfile.intervals:
        events_table = nwbfile.intervals['Events_Chan1']
        event_start_times = np.array(events_table.start_time.data[:])
    
        if 'label' in events_table.colnames:
            event_labels = np.array(events_table['label'].data[:])
        else:
            event_labels = np.array(['Event'] * len(event_start_times))
    else:
        event_start_times = np.array([])
        event_labels = np.array([])
    
    '''
    ######################### # --- Extract internally thresholded spike data (no sorting!) --- #########################
    '''
    
    if 'ecephys' in nwbfile.processing:
        print("Found internally thresholded spike data from NeuroMod")
        
        spike_times = np.array([])
        spike_channels = np.array([])
        
        ecephys_module = nwbfile.processing['ecephys']
        
        if 'ThreshSpikes' in ecephys_module.data_interfaces:
            ses = ecephys_module.data_interfaces['ThreshSpikes']
            
            spike_times = np.array(ses.timestamps[:])
            spike_channels = np.array(ses.electrodes.data[:])  # 0-based indices
            
        ######################### --- Raster plot (time vs channel) --- #########################
    
        plt.figure(figsize=(15, 5))
        
        plt.scatter(spike_times, spike_channels, s=2)
        plt.xlabel("Time [s]")
        plt.ylabel("Channel")
        plt.title("Spike Times over Channel")
        plt.tight_layout()
        plt.show()
      

'''
######################### Plot first data channel and event data channel (if present) #########################
'''
plt.figure(figsize=(15, 5))
plt.plot(time, signal, label='Signal Channel 1')

# Plot events as vertical lines
for t, label in zip(event_start_times, event_labels):
    plt.axvline(t, color='r', linestyle='--', alpha=0.7)
    plt.text(t, plt.ylim()[1]*0.9, label, rotation=90, verticalalignment='top', fontsize=8, color='r')

plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.title('Signal Channel 1 with Events (if present)')
plt.legend()
plt.tight_layout()
plt.show()



