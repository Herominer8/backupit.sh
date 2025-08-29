#!/bin/bash
sed -i 's/\r$//' backupit.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'


echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}MAKEBACKUP BASH SCRIPT WROTE BY Herominer8${NC}"
echo -e "${BLUE}==========================================${NC}"
echo " "
echo " "
read -e -p "Current File Location: " SOURCE_DIR
echo " "
read -e -p "Filename: " FILE_NAME
echo " "
read -e -p "Where Do You Want To Save Your Backup?: " BACKUPS_DIR
echo " "
read -e -p "When Should The Backup Be Deleted?(Day): " RETENTION_DAYS
echo " "
read -e -p "Logs Filename: " LOG_FILE
echo " "

if [[ -z "$RETENTION_DAYS" ]]; then
    echo -e "${RED}You Must Enter A Numberic Retention Day !${NC}"
    exit 1
elif [[ ! "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}You Must Enter A Numberic Retention Day !${NC}"
    exit 1
else
    :
fi

if [[ -z "$LOG_FILE" ]]; then
    echo -e "${RED}You Must Enter A Name For The Log File"
    exit 1
fi

if [ -d "$BACKUPS_DIR" ]; then
    :
else
    mkdir -p "$BACKUPS_DIR"
    touch "$LOG_FILE"
fi

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%y)
HOUR=$(date +%H)
MINUTE=$(date +%M)
SECOND=$(date +%S)
find "$BACKUPS_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec sh -c 'now=$(date +"%Y_%m_%d_%H_%M_%S"); rm "$1" && echo "Removed $1 Time $now" >> "'"$LOG_FILE"'"' _ {} \;

if [ -d "$SOURCE_DIR" ] && [ -f "$SOURCE_DIR/$FILE_NAME" ]; then
    tar -czf "$BACKUPS_DIR/${FILE_NAME}_backup_${YEAR}_${MONTH}_${DAY}_${HOUR}_${MINUTE}_${SECOND}.tar.gz" -C "$SOURCE_DIR" "$FILE_NAME"
    echo " "
    echo -e "${GREEN}Backup From $FILE_NAME Successfully Done !${NC}"
    echo "Backup From $FILE_NAME Successfully Done ! Location ${BACKUPS_DIR} Time ${YEAR}_${MONTH}_${DAY}_${HOUR}_${MINUTE}_${SECOND}" >> "$LOG_FILE"
else
    echo -e "${RED}The Source File Or Directory Doesn't Exist${NC}"

fi
