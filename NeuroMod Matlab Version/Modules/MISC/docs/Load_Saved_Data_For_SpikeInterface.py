# -*- coding: utf-8 -*-
"""
Created on Sat Aug 16 16:32:17 2025

@author: tonyd
"""

import json
import numpy as np
import spikeinterface.full as si
import probeinterface as pi
from probeinterface.plotting import plot_probe
import matplotlib.pyplot as plt
import spikeinterface.sorters as ss


# This function loads data in a Spikeinterface compatible format saved within Neuromod. It expects a .bin file containing
# amplifier channel data as well as a Meta_Data.json file with meta data (samplerate, event trigger times) and a probe.json containing information about probe geometry.
# specify the paths to those variables and execute this script in a environment in which spikeinterface is installed.
# Upon execution this script plots the probe desing with spikeinterface as well as the raw data trace overlayed by event trigger time points if present

Meta_Data_Path = "Path_to_your_file/Meta_Data.json";
Probe_Path = "Path_to_your_file/probe.json"
ChannelDataBinPath = "Path_to_your_file/SITest.bin";

'''
######################### Load Channel Data and Meta Data #########################
'''

with open(Meta_Data_Path) as f:
    metadata = json.load(f)

recording = si.read_binary(
    file_paths=ChannelDataBinPath,
    sampling_frequency=metadata["SampleRate"],
    num_channels=metadata["num_channels"],
    dtype=metadata["dtype"]
)

'''
######################### Load Event Data If  Present #########################
'''
# --- Attach event data ---
if "EventStruct" in metadata:
    for ev in metadata["EventStruct"]:
        event_times = ev["times"]           # list of samples
        channel_name = ev["event_channel_name"]

    print("Loaded events for", len(metadata["EventStruct"]), "event channels.")
    
'''
######################### Load Probe Data #########################
'''
# Load probe
probe_group = pi.read_probeinterface(Probe_Path)

# If you only have one probe, extract it
probe = probe_group.probes[0]

'''
######################### Plot Probe #########################
'''
# Plot the probe
plot_probe(probe, with_contact_id=True)
plt.show()   
'''
######################### Plot Data (first channel, all time points) #########################
'''
PlotData = recording.get_traces(channel_ids=[0]).flatten()  # shape (num_samples,)

# Plot signal
plt.figure(figsize=(12, 4))
plt.plot(PlotData, label="Signal", color="blue")

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
    plt.vlines(event_times, ymin=min(PlotData), ymax=max(PlotData), color="red", alpha=0.6, label=f"Events: {event_name}")

plt.xlabel("Sample index")
plt.ylabel("Amplitude")
plt.title("Signal Channel 1 with Events (if present)")
plt.legend()
plt.show()

