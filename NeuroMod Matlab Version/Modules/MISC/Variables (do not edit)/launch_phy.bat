@echo off
call "C:\Users\tonyd\anaconda3\condabin\conda.bat" activate phy2
cd /d "C:\Users\tonyd\Desktop\230510_mtl_230510_201202\Kilosort\kilosort4"
phy template-gui params.py
pause
