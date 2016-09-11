# "MIV" project
This project is a prototype that hacks together a series of pictures into a single video. 
It is experimental only and not production quality software. 

# Many In Movie Out
This program combines photos from various sources into a logical sequence
based on time stamp and creates a logical video out at a configurable framerate. 

# Work In Progress
Still needs some tweaks to prevent image stretching. 

# Requirements
Windows
Powershell
ffmpeg (in system path)
jpeghead (in local directory or system path)
jpegtran (in local directory or system path)
imagemagick (installed on system, and in path)
 
# How to use
First make sure you have all the needed binaries installed (see 'Requirements'). Next put all the pictures you want to merge into folders inside the same directory as this script.  Run the script and it will merge all the files into a single output directory and then do all the work on those files, and write the resulting video to the same directory where this script ran from.

