$ErrorActionPreference = "stop"
$ffmpeg = "C:\Users\kosar_000\bin\ffmpeg\bin\ffmpeg.exe"
$inputDir = "input"
 
 # inputs should be stored in input folder
if (!(Test-Path "input")) {
    Write-Host "no input folder found!"
    exit
}
 
$i=0
 
# create renamed files that are suitable for ffmpeg
# get list of input
# sort by last-write time (this is assumed to be the same as the time photo was captured)
# loop through each and rename into %05d.JPG
 
gci input\*.JPG | Sort-Object LastWriteTime | ForEach-Object {
    $name = $_.Name
    $format = "{0:D5}" -f $i
    Write-Host "rename $name &gt; input\$format.JPG"
    mv input\$name input\$format.JPG
    $i++
}
 
Write-Host "-- $i frames"
 
# Run FFMPEG
 
# $arguments = "-framerate 30 -i input`/`%05d.JPG -c`:v libx264 -crf 30 -r 30 output.mp4"
# $arguments = "-i input`/`%05d.JPG output.mp4"
$arguments = "-f image2 -i input`/`%05d.JPG output.mp4"
Start-Process -FilePath $ffmpeg -ArgumentList $arguments -Wait
