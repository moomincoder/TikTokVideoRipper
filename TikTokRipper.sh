#!/bin/bash

mkdir blur
rm file_list.txt

tiktok-scraper trend -d -n 20 elfederal007
# marblemannequin

for f in *.mp4;
do
  ffmpeg -i $f -lavfi '[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' -vb 800K blur/$f ;
done

# rm *.mp4

for f in blur/*.mp4; do echo "file $f" >> file_list.txt ; done 
ffmpeg -f concat -i file_list.txt final.mp4 

# ffmpeg -f concat -vsync 2 -i file_list.txt final.mp4 maybe?

# ffmpeg -i final.mp4 -vf mpdecimate,setpts=N/FRAME_RATE/TB finalNoDroppedFrames.mp4

# rm -rf blur
