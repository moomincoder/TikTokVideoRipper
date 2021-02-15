#!/bin/bash

# Create required folders
mkdir blur

# tiktok-scraper download the videos (user id is needed)
tiktok-scraper trend -d -n 5 marblemannequin 
# User IDs
# marblemannequin elfederal007

# Take the videos that are in the ./ directory and edit them to be 16/9 with a blurred background and put the blurred version in the /blur folder
for f in *.mp4;
do
  ffmpeg -i $f -lavfi '[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' -vb 800K blur/$f ;
done

# Echo the name of each one of the .mp4 files in the /blur folder 
for f in blur/*.mp4; do echo "file $f" >> file_list.txt ; done 
# Log the file name
for f in blur/*.mp4; do echo "file $f" >> log.txt ; done 
# Concat the blurred videos together
ffmpeg -f concat -i file_list.txt final.mp4 

# Ideas to deal with the dropped frames

# ffmpeg -f concat -vsync 2 -i file_list.txt final.mp4 maybe?
# ffmpeg -i final.mp4 -vf mpdecimate,setpts=N/FRAME_RATE/TB finalNoDroppedFrames.mp4


# Clean up
# rm *.mp4
# rm -rf blur
# rm file_list.txt
