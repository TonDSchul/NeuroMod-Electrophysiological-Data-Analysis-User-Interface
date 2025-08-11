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

# Extract time axis (Neo already stores it)
time_axis = anasig.times.rescale(pq.s)
print(anasig.shape[1])
# Plot all channels
plt.figure(figsize=(12, 6))
for ch in range(anasig.shape[1]):
    plt.plot(time_axis, anasig[:, ch], label=f"Channel {ch+1}")

plt.xlabel("Time (s)")
plt.ylabel(f"Amplitude ({anasig.units.dimensionality.string})")
plt.title("All channels")
plt.legend()
plt.tight_layout()
plt.show()