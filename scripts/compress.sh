#!/usr/bin/env bash

# constants
home_dir=/home/listener
jsonl_file=$(env TZ=Etc/UTC date -d "yesterday" +%Y-%m-%d.jsonl)
log=$(env TZ=Etc/UTC date -d "yesterday" +%Y-%m-%d.log)

mkdir -p home_dir/working
cd $home_dir/working

#cleanup and logging
echo "Deleting old files in cache"
find /home/listener/working/cache -type f -mtime +7
find /home/listener/working/cache -type f -mtime +7 | xargs -r0 rm --

#actual compress
echo "Starting Compress: $(date)"
echo "Moving File $jsonl_file"
mv ../$jsonl_file ./$jsonl_file
echo "Moving Log File"
mv ../log/listener.log ./listener.log
echo "Creating 7zip file"
7zr a "$jsonl_file.7z" $jsonl_file listener.log

#post compress
echo "Deleting listener file"
rm ./listener.log
echo "deleting json file"
rm $jsonl_file
echo "moving 7zip file to completed folder"
mv "$jsonl_file.7z" "../../webhost/webroot/$jsonl_file.7z"
echo "Compress completed: $(date)"
echo "Changing ownership"
chown webhost:webhost "../../webhost/webroot/$jsonl_file.7z"
chmod 664 "../../webhost/webroot/$jsonl_file.7z"
chown listener:listener "./log/$log"
