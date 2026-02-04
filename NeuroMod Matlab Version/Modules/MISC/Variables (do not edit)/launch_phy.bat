@echo off
call "C:\Users\tonyd\anaconda3\condabin\conda.bat" activate phy2
cd /d "F:\Fake_Desktop\MEAData\20240826\R3\Kilosort\kilosort4"
phy template-gui params.py
pause
