@echo off
call "C:\Users\tonyd\anaconda3\condabin\conda.bat" activate phy2
cd /d "F:\Fake_Desktop\Raw Recordings\Intan\.dat\230510_mtl_230510_201202\SpikeInterface\SpikeInterface_Sorting_Phy_Results\Mountainsort 5"
phy template-gui params.py
pause
