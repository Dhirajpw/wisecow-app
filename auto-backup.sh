#!/usr/bin/env bash

# Config
SOURCE_DIR="/home/user/data"
REMOTE_USER="username"
REMOTE_HOST="remote.server.com"
REMOTE_DIR="/remote/backup"
LOGFILE="/var/log/backup.log"

# Timestamp
DATE=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_NAME="backup_$DATE.tar.gz"

echo "=== Backup Started: $DATE ===" >> "$LOGFILE"

# Create a local archive
tar -czf /tmp/$BACKUP_NAME -C "$SOURCE_DIR" .

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create backup archive" | tee -a "$LOGFILE"
    exit 1
fi

# Transfer to remote server
rsync -avz /tmp/$BACKUP_NAME $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR

if [ $? -eq 0 ]; then
    echo "SUCCESS: Backup completed and sent to $REMOTE_HOST" | tee -a "$LOGFILE"
else
    echo "ERROR: Backup failed during transfer" | tee -a "$LOGFILE"
fi

# Clean up local archive
rm -f /tmp/$BACKUP_NAME

echo "Backup Finished: $(date)" >> "$LOGFILE"
