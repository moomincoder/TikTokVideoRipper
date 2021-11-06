#!/bin/bash

# I know this is probably the sloppiest way of doing this, but it works so ¯\_(ツ)_/¯

# the first arg is the hashtag you want the video to be about, the second arg is the number of videos you want to scrape, and the third arg is the name of the final video
# example "tiktok-ripper funny 8 largeFunnyCompilation"

# Find out if TikTok-Scraper is already installed and if not install it
if (npm list -g | grep tiktok-scraper);
then
# Create required folders
mkdir blur
touch log.txt
echo "$1 $2 $3" >> log.txt
# $1 is the first input arg from running the script and should be the hashtag you want to use
# tiktok-scraper download the videos
tiktok-scraper hashtag $1 -d -n $2 --session sid_tt=dae32131231
echo "downloaded videos to the subfolder" >> log.txt
# User IDs
# marblemannequin elfederal007 jasonderulo

# Move the downloaded files to the main directory
for f in \#"$1"/*.mp4; 
do mv \#"$1"/*.mp4 ./ ;
done
echo "moved the videos to the main directory" >> log.txt
# Remove the unused folder
rm -rf \#"$1"/

# Take the videos that are in the ./ directory and edit them to be 16/9 with a blurred background and put the blurred version in the /blur folder
for f in *.mp4;
do
  ffmpeg -i $f -lavfi '[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' -vb 800K -b:v 10M blur/$f | grep frame= | >> log.txt ;
done
echo "blurred all the videos" >> log.txt

# Echo the name of each one of the .mp4 files in the /blur folder 
for f in blur/*.mp4; 
do echo "file $f" >> file_list.txt ; 
done 
# Log the file names
echo "///////////////////////////////////////////////////////" >> log.txt
echo "/////////// List of videos that have been edited //////" >> log.txt
echo "///////////////////////////////////////////////////////" >> log.txt
for f in blur/*.mp4; 
do echo "file $f" >> log.txt ; 
done 
# Concat the blurred videos together
ffmpeg -f concat -i file_list.txt $3.mp4 
echo "combined all the blured videos together" >> log.txt

# Move the finshed file into a different directory
mkdir final
echo "made the final dir" >> log.txt
mv $3.mp4 final/
echo "moved the final video to the final dir" >> log.txt

# Clean up
# rm -rf *.mp4
rm -rf blur
rm file_list.txt
echo "cleaned up" >> log.txt
mv final/$3.mp4 ./
echo "moved the final video back to the main folder" >> log.txt
rm -rf final
else
  npm i -g tiktok-scraper
fi
