@echo off
call "C:\Users\tonyd\anaconda3\condabin\conda.bat" activate phy2
cd /d "C:\Users\tonyd\Desktop\230510_mtl_230510_201202\SpikeInterface\SpikeInterface_Sorting_Phy_Results\SpyKING CIRCUS 2"
phy template-gui params.py
pause
