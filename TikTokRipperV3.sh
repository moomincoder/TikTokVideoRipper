#!/bin/bash

# I know this is probably the sloppiest way of doing this, but it works so ¯\_(ツ)_/¯

# Find out if TikTok-Scraper is already installed and if not install it
if (npm list -g | grep tiktok-scraper);
then
# Create required folders
mkdir blur

# tiktok-scraper download the videos (user id is needed)
tiktok-scraper trend -d -n 1 jasonderulo 
# User IDs
# marblemannequin elfederal007 jasonderulo

# Move the downloaded files to the main directory
for f in trend/*.mp4; 
do mv trend/*.mp4 ./ ;
done
# Remove the unused folder
rm -rf trend

# Take the videos that are in the ./ directory and edit them to be 16/9 with a blurred background and put the blurred version in the /blur folder
# this is the version where 
for f in *.mp4;
do
  ffmpeg -i $f -lavfi '[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' -vb 800K -b:v 10M blur/$f ;
done

# Echo the name of each one of the .mp4 files in the /blur folder 
for f in blur/*.mp4; 
do echo "file $f" >> file_list.txt ; 
done 
# Log the file names
for f in blur/*.mp4; 
do echo "file $f" >> log.txt ; 
done 
# Concat the blurred videos together
ffmpeg -f concat -i file_list.txt final.mp4 

# Move the finshed file into a different directory
mkdir final
mv final.mp4 final/

# Clean up
rm -rf *.mp4
rm -rf blur
rm file_list.txt
else
  npm i -g tiktok-scraper
fi
