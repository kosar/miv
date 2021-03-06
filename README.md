﻿# "MIVO" project
This project is a prototype that hacks together a series of pictures into a single video. 
It is experimental only and not production quality software. 

# Many In Video Out
This program combines photos (and eventually videos) from various sources into a logical sequence
based on time stamp and creates a logical video out at a configurable framerate. The intention is to 
create a video from all the photos that were taken, such as on a vacation where there were multiple 
cameras all capturing the same events.  

# Work In Progress
The size paramters have been very tricky to get right and are currently hard coded in the script 
for a 1280x720 output. 

TODO: It should be possible to make this configurable and have a command line option 
to specify the output video size and have that drive the encoding and conversion parameters. For example it should be 
possible to specify a 1080p video and have the parameters to ffmpeg, mogrify, etc. all follow from that. 

TODO: normalize date/time stamps to make interleaving more precise and accurate to when the photos were actually taken. 
Today's digital cameras can have wildly varying date & time stamps, and this program does not yet handle this gracefully so there can be a time gap in between photos that were actually taken at the same time. I have ideas for how to solve this by looking at the EXIF data but even so the cameras may have been on different time zones and perenially off by a few hours from another camera who's timestamps are contextually but not globally accurate. 

# Requirements
This approach should work on any system or OS but I have only developed & tested it on Windows, using powershell, 
which has a rich set of native commandlets to process files & time stamps, etc. 

Windows
Powershell
ffmpeg (in system path)
jpeghead (in local directory or system path)
jpegtran (in local directory or system path)
imagemagick (installed on system, and in path)
 
# How to use
## Prepare your system
1. Make sure you can execute powershell scripts on your system. Do this by opening a Powershell window and try to run the merge-encodep.ps1 script in this project. If you get permissions errors, google that until you can properly execute a script. You can also try to write a simple test script that does a simple 'Write-Host "hello world"' to see if you can execute any script at all. 
## Install the pre-requisite programs (this is easy, don't get spooked!)
2a. Install ffmpeg and put it in your path, and ensure you can run it from the same powershell environment you set up in 1. 
2b. Install Imagemagick and ensure the binaries for that program are in your path. Close and reopen powershell and type in 'convert' to see if it is working. Also try to run 'mogrify' (by itself just to see if your system can find it) and make sure it is in place. 
2c. Copy jpeghead.exe and jpegtrans.exe from this repo (under release/bin) to your 'project' directory (see below). 
## Create a Project Directory where you will run this program. Let's call our sample project 'G' for this exercise. In this case you would create a directory somewhere on your hard drive called 'G'.  
3a. Copy all your pictures to a sub-directoroy of your Project Directory. For example you could create a subdirectory called 'input'  (under the 'G' project directory in this case). It does not matter if you dump all the pictures into one sub-directory of G, ,or if you keep them organized by camera or some other way. As long as the pictures are somewhere in the top level Project Directory (e.g., 'G' in our example), this program will find them. 
3b. Copy the main powershell script in this repo to the Project Directory. 
## Do a test run
4. Run the powershell script with the -m option (merge only) to see if you have your pictures in the right place, etc. This will 'merge only' the files into one big directory called 'output (which is defined as variable $od in the code).  If you see an 'output' directory created in your Project Directory ('G') you're doing great. 
5. Run the powershell script with no options at all, and you should see it perform these steps:
  - merges the files into one directory (again, yes you are repeating the test above)
  - runs 'jpeghead' on the files (remember, you copied jpeghead.exe to your project directory so the script can find it)
  - runs 'mogrify' on the pictures to set the correct size & aspect ratios
  - runs 'ffmpeg' to start encoding all the pictures into one video 

6. The output video will be written into the Project Directory and is currently named out1-720p.mp4 (hard coded in the script) and is overwritten each time you run this program. You can rename it in the code, and a TODO for this project is for that to be configurable at the command line. 

7. Watch the video and enjoy! 


First make sure you have all the needed binaries installed (see 'Requirements'). Next put all the pictures you want to merge into folders inside the same directory as this script.  Run the script and it will merge all the files into a single output directory and then do all the work on those files, and write the resulting video to the same directory where this script ran from.

