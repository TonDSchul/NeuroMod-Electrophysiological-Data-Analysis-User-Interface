# -*- coding: utf-8 -*-
"""
Created on Mon Feb  9 17:22:33 2026

@author: tonyd
"""
import json
import numpy as np
import matplotlib.pyplot as plt
from neo.io import RawBinarySignalIO
from neo.core import SpikeTrain
import quantities as pq

Meta_Data_Path = 'C:/Users/tonyd/Desktop/BLABLA_NEO_dat_Info.json';
Channel_DataBin_Path = 'C:/Users/tonyd/Desktop/BLABLA.dat';
'''
Meta_Data_Path = 'Path_To_Saved_Recording/Filename_NEO_dat_Info.json';
Channel_DataBin_Path = 'Path_To_Saved_Recording/Filename.dat';
'''

'''
######################### Load Meta Data #########################
'''
with open(Meta_Data_Path) as f:
    metadata = json.load(f)

NrChannels = metadata["num_channels"]
SamplingRate = metadata["SampleRate"]
 
'''
######################### Load Channel Data #########################
'''

recording = RawBinarySignalIO(
    filename=Channel_DataBin_Path,
    dtype=metadata["dtype"],
    sampling_rate=SamplingRate,   # Hz
    nb_channel=NrChannels,
)

block = recording.read_block()
signal = block.segments[0].analogsignals[0]

'''
######################### Load Event Data If Present #########################
'''
# --- Attach event data ---
if "EventStruct" in metadata:
    for ev in metadata["EventStruct"]:
        event_times = ev["times"]           # list of samples
        channel_name = ev["event_channel_name"]

    print("Loaded events for", len(metadata["EventStruct"]), "event channels.")

'''
######################### Load Spike Data If Present #########################
''' 
# --- Attach event data ---
if "SpikeTimes" in metadata:
    spike_samples = np.asarray(metadata["SpikeTimes"])
    spike_times = spike_samples / metadata["Info"]["NativeSamplingRate"]
    # create SpikeTrain
    NEOSpikeTrain = SpikeTrain(
        times=spike_times * pq.s,
        t_start=0 * pq.s,
        t_stop=metadata["TimeEnd"] * pq.s
        )
    
    segment = block.segments[0]
    segment.spiketrains.append(NEOSpikeTrain)

    print("Loaded spikes times.")
    
'''
######################### Plot One Channel #########################
'''

DataOneChannel = np.asarray(signal[:, 0])
TimeToPlot = np.arange(len(DataOneChannel)) / SamplingRate

# Plot signal
plt.figure(figsize=(12, 4))
plt.plot(DataOneChannel, label="Signal", color="blue")

if "EventStruct" in metadata:
    # Extract EventStruct
    ev = metadata["EventStruct"]
    
    # Handle single event channel vs multiple channels
    if isinstance(ev, dict):      # single channel
        event_times = ev["times"]
        event_name = ev["event_channel_name"]
    elif isinstance(ev, list):    # multiple channels
        event_times = ev[0]["times"]
        event_name = ev[0]["event_channel_name"]
    else:
        raise ValueError("Unexpected EventStruct format!")

    # Plot events as vertical lines
    plt.vlines(event_times, ymin=min(DataOneChannel), ymax=max(DataOneChannel), color="red", alpha=0.6, label=f"Events: {event_name}")

plt.xlabel("Sample index")
plt.ylabel("Amplitude")
plt.title("Signal Channel 1 with Events (if present)")
plt.legend()
plt.show()