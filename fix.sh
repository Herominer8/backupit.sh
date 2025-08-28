#!/bin/sh
if [ ! -f backupit.sh ]; then
    echo "backupit.sh Not Found"
    exit 1
fi
sed -i 's/\r$//' backupit.sh
echo "Fixed backupit.sh Successfully"