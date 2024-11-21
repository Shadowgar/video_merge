@echo off
rem ---------------------------------------------------------
rem Script Created by: Paul Rocco Sr. Police Officer II of UPMC Greenville
rem 
rem Description:
rem This batch script merges video files selected by the user
rem into one single video file using FFmpeg, with options for
rem quality settings and fast merging with the original method.
rem 
rem License: MIT License
rem ---------------------------------------------------------
echo --- Starting Batch Script ---
echo Created by Paul Rocco
echo License: MIT License
echo ----------------------------------

rem --- Set the output folder to the Desktop of the user (usr_HHSGC1SECD2) ---
set "output_folder=C:\Users\usr_HHSGC1SECD2\Desktop"

rem --- Proceed with video merging ---
echo Selecting video files for merging...
powershell -NoProfile -ExecutionPolicy Bypass -File "select_files.ps1"

rem Check if the file list was created
if not exist filelist.txt (
    echo No files were selected or file list creation failed.
    pause
    exit /b
)

rem Prompt for the output file name
set /p "output_filename=Enter the name for the output file (without extension): "

rem Check if the user provided a filename, and if not, use default "output"
if "%output_filename%"=="" set "output_filename=output"
echo Output filename will be: %output_filename%

rem Prompt for quality selection
echo.
echo Select output quality:
echo 1. High Quality - Very low compression, near lossless quality, larger file size.
echo 2. Medium Quality - Balanced quality and file size, good for general use.
echo 3. Low Quality - Higher compression, smaller file size, reduced quality.
echo 4. Original Method - Fast merge without re-encoding into .avi format.
echo 5. Windows Media Player - Encodes to .wmv for sharing via email (compatible with Windows Media Player).

set /p "quality_choice=Enter the number corresponding to your quality choice (1, 2, 3, 4, or 5): "

rem Set the FFmpeg quality options based on user choice
if "%quality_choice%"=="1" (
    set "ffmpeg_options=-crf 18 -c:v libx264 -preset slow -an"
    set "output_extension=mp4"
    echo High Quality selected. Very low compression, near lossless quality, larger file size.
) else if "%quality_choice%"=="2" (
    set "ffmpeg_options=-crf 23 -c:v libx264 -preset medium -an"
    set "output_extension=mp4"
    echo Medium Quality selected. Balanced quality and file size, good for general use.
) else if "%quality_choice%"=="3" (
    set "ffmpeg_options=-crf 28 -c:v libx264 -preset faster -an"
    set "output_extension=mp4"
    echo Low Quality selected. Higher compression, smaller file size, reduced quality.
) else if "%quality_choice%"=="4" (
    set "ffmpeg_options=-c copy -an"
    set "output_extension=avi"
    echo Original Method selected. Fast merge without re-encoding, saved as .avi format for compatibility.
) else if "%quality_choice%"=="5" (
    rem Windows Media Player with audio and video encoding
    set "ffmpeg_options=-c:v wmv2 -b:v 1024k -c:a wmav2 -b:a 128k"
    set "output_extension=wmv"
    echo Windows Media Player selected. Encodes the video to .wmv format for easy sharing via email.
) else (
    echo Invalid selection. Defaulting to Medium Quality.
    set "ffmpeg_options=-crf 23 -c:v libx264 -preset medium -an"
    set "output_extension=mp4"
)

rem Run FFmpeg to merge the videos
echo Merging videos using FFmpeg...
ffmpeg -f concat -safe 0 -i filelist.txt %ffmpeg_options% "%output_folder%\%output_filename%.%output_extension%"

rem Delete the filelist.txt after merging
del /f /q filelist.txt
echo Filelist.txt has been deleted.

rem Show success message
echo Videos merged successfully into "%output_folder%\%output_filename%.%output_extension%"

rem Prompt user to press a key to exit
pause
exit
