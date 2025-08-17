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

'''
######################### Load Channel Data and Meta Data #########################
'''

with open("C:/Users/tonyd/Desktop/Meta_Data.json") as f:
    metadata = json.load(f)

recording = si.read_binary(
    file_paths="C:/Users/tonyd/Desktop/TestSpikeInterface.bin",
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
probe_group = pi.read_probeinterface("C:/Users/tonyd/Desktop/probe.json")

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
y = recording.get_traces(channel_ids=[0]).flatten()  # shape (num_samples,)

# Plot signal
plt.figure(figsize=(12, 4))
plt.plot(y, label="Signal", color="blue")

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
    plt.vlines(event_times, ymin=min(y), ymax=max(y), color="red", alpha=0.6, label=f"Events: {event_name}")

plt.xlabel("Sample index")
plt.ylabel("Amplitude")
plt.title("Signal with Events (if present)")
plt.legend()
plt.show()

