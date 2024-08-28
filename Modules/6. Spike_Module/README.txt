Data structure (app.Data) contains two fields that handle spike data, dependent on whether the data comes from the internal thresholding spike detection or from Kilosort. The field handling internal spike data is saved as app.Data.Spikes.
Since Kilosort analysis yields more data than the internal thresholding, like spike clustering, it is handled in a different field calles app.Data.KilosortData.
Both fields (app.Data.Spikes and app.Data.KilosortData) contain different fields, like soike times and spike channel. 
Internal spike detection consists of simple thresholding methods (mean-std and median-std) in a channelwise fashion. 

*Important*: This code currently only works for Kilosort 4! It takes the results in the oupput data folder Kilosort creates after finishing spike sorting.
*Important*: app.Data.KilososortData and app.Data.Soikes have to be always part of the dataset, but empty when not loaded
*Important* : Only one spike dataset is allowed to exist at once. So if internal spikes are loaded, app.Data.KilsoortData has to set to be empty and vise versa.