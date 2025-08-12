# -*- coding: utf-8 -*-
"""
Created on Mon Aug 11 19:15:49 2025

@author: tonyd
"""

import neo
import matplotlib.pyplot as plt
import quantities as pq

r = neo.io.NeoMatlabIO(filename='C:/Users/tonyd/Desktop/NEO.mat')
bl = r.read_block()

anasig = bl.segments[0].analogsignals[0]
time_axis = anasig.times.rescale(pq.s)

# Get first event channel
event_channel = bl.segments[0].events[0]  # events[0] = first event channel
event_times = event_channel.times.rescale(pq.s)  # Convert to seconds

# Plot all channels
plt.figure(figsize=(12, 6))
for ch in range(anasig.shape[1]):
    plt.plot(time_axis, anasig[:, ch], label=f"Channel {ch+1}")

# Overlay event times as vertical dashed lines
for t in event_times:
    plt.axvline(x=float(t), color='red', linestyle='--', linewidth=1, alpha=0.7)

plt.xlabel("Time (s)")
plt.ylabel(f"Amplitude ({anasig.units.dimensionality.string})")
plt.title("All channels with Event Channel 1")
plt.legend()
plt.tight_layout()
plt.show()