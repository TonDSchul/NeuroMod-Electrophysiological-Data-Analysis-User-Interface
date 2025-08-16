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

plt.plot(y)
plt.xlabel("Sample index")
plt.ylabel("Amplitude")
plt.show()                 

