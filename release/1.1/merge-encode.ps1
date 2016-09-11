param([switch]$encode_only, [switch]$merge_only, [switch]$autorotate_only);
$i=0
$ff = 'C:\users\kosar_000\bin\ffmpeg\bin\ffmpeg.exe'
$fp = 'C:\users\kosar_000\bin\ffmpeg\bin\ffplay.exe'
$ffi = ' -framerate 1/2 -i '
$od="output"
$fpt = '\\"%07d.jpg"' 
$of = "out1-720p.mp4"
$ffp = ' -c:v libx264 -s:v 1280x720 -pix_fmt yuv420p -vf "scale=1280:-2" -r 15 -y '
#$ffp = ' -f image2 -pix_fmt yuv420p -y -r 15 -y '
$ag = $ffi + $od + $fpt + $ffp + "$of"
$ag2 = ' -autorot ' + $od + '\*.jpg'
$ag3 = ' -resize 1280x720 -background black -gravity center -extent 1280x720 -quality 92 -verbose '
$version='1.1'
Write-Host ("$version usage: .\merge-encode.ps1 [-e[ncode_only]] [-m[erge_only]] [-a[utorotate_only]]")

function Run-ffmpeg(){
    Start-Process -FilePath $ff -ArgumentList $ag -NoNewWindow -Wait
}

function Run-autorotate(){
    Write-Host "Auto-rotating all jpg images in $od ..."
    Start-Process ".\jhead.exe" -ArgumentList $ag2 -Wait -NoNewWindow
}

function Run-ffplay(){
    Start-Process -FilePath $fp $of -Wait -NoNewWindow
}

function Run-Mogrify(){
    Start-Process "mogrify.exe" -ArgumentList " $od\*.jpg $ag3 $od\*.jpg" -Wait -NoNewWindow
}


if ($encode_only){
    Run-ffmpeg
    exit
} 

if ($autorotate_only){
    Run-autorotate
    exit
}

Write-Host "Checking if output directory ($od) exists..."
$pe=Test-Path -type container ($od)
Write-Host "Total Images found to merge & rename: " (Get-ChildItem -recurse ".\" -filter "*.JPG").Count

if (($pe)){
    Write-Host "Output directory contains Files: (in $od ): " (Get-ChildItem "$od" -filter "*.JPG").Count
    Remove-Item "$od\*.JPG" -Force
} else {
    Write-Host "No output directory found...creating $od directory... "
    New-Item -type directory -force ".\$od"
}

gci -recurse *.JPG | Sort-Object LastWriteTime | ForEach-Object {
    $name = $_.Name
    $dir = $_.Directory
    $format = "{0:D7}" -f $i
    Write-Host "$dir\$name --> " "$od\$format.JPG"
    cp "$dir\$name" -Destination "$od\$format.JPG" -Force
    $i++
}

Write-Host ("Copied $i files to $od")
Write-Host "Files merged & renamed: " (Get-ChildItem -recurse "$od" -filter "*.JPG").Count

if (!$merge_only) {
    Run-autorotate
    Run-Mogrify
    Run-ffmpeg
    Run-ffplay
}
