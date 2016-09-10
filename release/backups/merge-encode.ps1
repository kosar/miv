param([switch]$encode_only, [switch]$merge_only, [switch]$autorotate_only);
$i=0
$ff = 'C:\users\kosar_000\bin\ffmpeg\bin\ffmpeg.exe'
$fp = 'C:\users\kosar_000\bin\ffmpeg\bin\ffplay.exe'
$ffi = ' -framerate 3/2 -i '
$od="output2"
$fpt = '\\"%07d.jpg"' 
$of = "out1-720p.mp4"
$ffp = ' -c:v libx264 -s:v 800x600 -vf "scale=800:-1" -r 15 -y '
$ag = $ffi + $od + $fpt + $ffp + "$of"
$ag2 = ' -autorot ' + $od + '\*.jpg'
Write-Host ("v0.99 usage: .\merge-encode.ps1 [-e[ncode_only]] [-m[erge_only]] [-a[utorotate_only]]")

function Run-ffmpeg(){
    Start-Process -FilePath $ff -ArgumentList $ag -NoNewWindow -Wait
}

function Run-autorotate(){
    Start-Process ".\jhead.exe" -ArgumentList $ag2 -Wait -NoNewWindow
}

if ($encode_only){
    Run-ffmpeg
    #Start-Process -FilePath $fp $of -Wait -NoNewWindow
    exit
} 

if ($autorotate_only){
    Run-autorotate
    exit
}

Write-Host ("Creating single list of images & then encoding...")
Write-Host "Checking if output directory ($od) exists..."
$pe=Test-Path -type container ($od)
Write-Host "Total Images found to merge & rename: " (Get-ChildItem -recurse ".\" -filter "*.JPG").Count

if (($pe)){
    Write-Host "Files found in $od : " (Get-ChildItem "$od" -filter "*.JPG").Count
    Remove-Item "$od\*.JPG" -Force
} else {
    Write-Host "No output directory found...creating $od directory... "
    New-Item -type directory -force ".\$od"
}

gci -recurse *.JPG | Sort-Object LastWriteTime | ForEach-Object {
    $name = $_.Name
    $dir = $_.Directory
    $format = "{0:D7}" -f $i
    Write-Host "$dir\$name" "$od\$format.JPG"
    cp "$dir\$name" -Destination "$od\$format.JPG" -Force
    $i++
}

Write-Host ("Copied $i files to $od")
Write-Host "Files merged & renamed: " (Get-ChildItem -recurse "$od" -filter "*.JPG").Count

if (!$autorotate_only){
    Run-autorotate
}

if (!$merge_only) {
    Run-ffmpeg
    Start-Process -FilePath $fp $of -Wait -NoNewWindow

    # optional params, not sure what they do:
    # -y -- this auto overwrites old file, so keep it in
    # -vf scale=1280:-2 #should scale to 1280 automatically, -1 also works, not sure what -2 does
    # -pix_fmt yuv420p 
    # -noautorotate (doesn't do anything!)

}

