# -*- coding: utf-8 -*-
"""
Created on Sat Nov 30 21:47:33 2024

@author: tonyd
"""

import psutil
import os
import ctypes

def DeletePermittedHandle(file_path):
    
    for proc in psutil.process_iter(attrs=["pid", "name", "open_files"]):
        try:
            open_files = proc.info["open_files"]
            if open_files:
                for file in open_files:
                    if file.path == file_path:
                        print(f"Closing file held by process {proc.info['name']} (PID: {proc.info['pid']})")
                        proc.terminate()  # Force-close the process
                        proc.wait()  # Wait for process to close
        except (psutil.AccessDenied, psutil.NoSuchProcess):
            pass
    
    # Now delete the file
    try:
        os.remove(file_path)
        print("File deleted successfully.")
    except PermissionError as e:
        # Try deleting normally first
        try:
            os.remove(file_path)
            print("File deleted successfully.")
        except PermissionError:
            # If failed, use Windows API to force delete
            kernel32 = ctypes.windll.kernel32
            kernel32.DeleteFileW.restype = ctypes.c_bool
            success = kernel32.DeleteFileW(file_path)
            if success:
                print("File deleted using Windows API.")
            else:

                print("Failed to delete file even with Windows API.")
                print(f"Failed to delete file: {e}")