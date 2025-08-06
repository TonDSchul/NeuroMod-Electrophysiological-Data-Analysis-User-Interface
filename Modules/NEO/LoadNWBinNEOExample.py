# -*- coding: utf-8 -*-
"""
Created on Wed Aug  6 22:04:29 2025

@author: tonyd
"""

from pynwb import NWBHDF5IO
import matplotlib.pyplot as plt
import numpy as np

# Path to your NWB file
nwb_path = "C:/Users/tonyd/Desktop/Test.nwb"

# Open the file in read mode
with NWBHDF5IO(nwb_path, 'r') as io:
    nwbfile = io.read()

    # Access the first ElectricalSeries in acquisition
    es = list(nwbfile.acquisition.values())[0]

    # Extract raw data (as numpy array)
    data = es.data[:]
    sampling_rate = es.rate  # Hz

    # Get 1 second of data
    num_samples = int(sampling_rate)
    one_sec_data = data[:num_samples, :]  # shape: [time, channels]

    # Transpose to shape: [channels, time]
    one_sec_data = one_sec_data.T

    # Prepare time axis
    time = np.arange(num_samples) / sampling_rate

    # Plot
    plt.figure(figsize=(12, 8))
    offset = 0  # Vertical offset between traces

    for i, trace in enumerate(one_sec_data):
        plt.plot(time, trace + i * offset, label=f'Ch {i}')

    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude + offset")
    plt.title("1 Second of Signal from NWB (PyNWB)")
    plt.tight_layout()
    plt.show()


