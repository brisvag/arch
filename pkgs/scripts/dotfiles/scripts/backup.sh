#!/bin/bash

rsync -Partx --delete --stats --exclude 'lost+found/' --exclude 'mnt/' --exclude 'tmp/' --exclude 'var/tmp/' --exclude 'var/cache/' --exclude 'home/brisvag/.local/share/Steam/steamapps/common/Age2HD' --exclude '/home/brisvag/.cache' / /mnt/data/backup
