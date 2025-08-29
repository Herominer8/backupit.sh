#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 

echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}MAKEBACKUP BASH SCRIPT WROTE BY Herominer8${NC}"
echo -e "${BLUE}==========================================${NC}"
echo

read -e -p "Full Path To File To Backup: " SOURCE_FILE
echo
read -e -p "Where Do You Want To Save Your Backup?: " BACKUPS_DIR
echo
read -e -p "When Should The Backup Be Deleted? (Days): " RETENTION_DAYS
echo
read -e -p "Logs Filename (e.g. backup.log): " LOG_FILE
echo

if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}Source file does not exist: $SOURCE_FILE${NC}"
    exit 1
fi

if [[ -z "$RETENTION_DAYS" || ! "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}You must enter a numeric retention day!${NC}"
    exit 1
fi

if [[ -z "$LOG_FILE" ]]; then
    echo -e "${RED}You must enter a name for the log file!${NC}"
    exit 1
fi

mkdir -p "$BACKUPS_DIR"
touch "$LOG_FILE"

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%y)
HOUR=$(date +%H)
MINUTE=$(date +%M)
SECOND=$(date +%S)
TIMESTAMP="${YEAR}_${MONTH}_${DAY}_${HOUR}_${MINUTE}_${SECOND}"

FILE_NAME=$(basename "$SOURCE_FILE")
SOURCE_DIR=$(dirname "$SOURCE_FILE")

find "$BACKUPS_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec sh -c '
    for file; do
        now=$(date +"%Y_%m_%d_%H_%M_%S")
        echo "Removed $file at $now" >> "'"$LOG_FILE"'"
        rm "$file"
    done
' _ {} +

BACKUP_NAME="${FILE_NAME}_backup_${TIMESTAMP}.tar.gz"
tar -czf "$BACKUPS_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" "$FILE_NAME"

if [ $? -eq 0 ]; then
    echo
    echo -e "${GREEN}Backup from $FILE_NAME successfully created at $BACKUPS_DIR/$BACKUP_NAME${NC}"
    echo "Backup created: $BACKUPS_DIR/$BACKUP_NAME at $TIMESTAMP" >> "$LOG_FILE"
else
    echo -e "${RED}Backup failed!${NC}"
    echo "Backup FAILED: $FILE_NAME at $TIMESTAMP" >> "$LOG_FILE"
fi
