#!/usr/bin/env bash
#
# BASH Backup Script
#

# directory to backup
SOURCE_DIR="/Users/myakubmizan/CODE/www_root/"

# directory to store backups
BACKUP_DIR="/Users/myakubmizan/CODE/test/"

# Get date string
# will be appended after the file name
function getDate(){
  date +"%d-%m-%Y_%H-%M-%S"
}

function deleteOlderBackups(){
  # clean backups older than 7 days
  echo ""
}

echo "Backup Started...."
echo "Source Directory: $SOURCE_DIR"

BSNAME=$(basename $SOURCE_DIR)
BSNAME=$(echo $BSNAME| sed -e "s/_/-/g")
BACKUP_NAME="$BSNAME""_$(getDate).tar.gz"

# check if backup target directory exists
# if not create a new one
if [ ! -d $BACKUP_DIR ];
then
  mkdir -p $BACKUP_DIR
  echo "Target Location Created $BACKUP_DIR"
else
  echo "Target Location Selected: $BACKUP_DIR"
fi

#start backup
BACKUP_LOCATION="$BACKUP_DIR""$BACKUP_NAME"
tar cvfz $BACKUP_LOCATION $SOURCE_DIR
cat <<- __EOF__


 "Backup Finished!"


__EOF__
