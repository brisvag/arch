#!/bin/bash

rsync -Partx --delete --stats --exclude '.local/share/Steam/steamapps/common/Age2HD' --exclude '.cache' /home/brisvag /mnt/backup
