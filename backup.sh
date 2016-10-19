#!/usr/bin/env bash
#
# BASH Backup Script with daily, weeky and monthly backup retention policy.
# Offers incremental backups and auto purging of older backup to free up
# disk space
# @author M Yakub Mizan
# @url http://mymizan.rocks/
# @email ctgcoder@gmail.com
#
#

################################################################################
######      CHANGE SOURCE_DIR AND BACKUP_DIR TO YOUR DESIRED ONES      #########
################################################################################

SOURCE_DIR="/Users/myakubmizan/CODE/www_root/" # directory to backup
BACKUP_DIR="/Users/myakubmizan/CODE/test/"     # backup destination
NUMBER_OF_BACKUPS=7 # Total number of daily backups to keep
DO_INCREMENTAL_BACKUPS=true # set to false to take full daily backups
                            # otherwise leave true to take daily incremental backup
TAKE_WEEKLY_FULL_BACKUP=true # Take a full backup every week
SILENT_TAR=1 # hide tar output from terminal. If set to 0 tar runs in verbose mode



################################################################################
###### DO NOT CHANGE ANYTHIG BELOW UNLESS YOU KNOW WHAT YOU ARE DOING! #########
################################################################################

# Check if source directory exists
if [ ! -d $SOURCE_DIR ]; then
  echo "Source directory doesn't exist! Refusing to proceed."
  exit
fi

if [ $SILENT_TAR -eq 1 ]; then
  SILENT_TAR=' '
else
  SILENT_TAR='v'
fi

# Get date string to append after the file name
function getDate(){
  date +"%d-%m-%Y_%H-%M-%S"
}

#Remove daily backups greater than the number set in NUMBER_OF_BACKUPS.
#Mothly backups and weekly backups are calculated seperately. Weekly and
#monthly backups are never deleted if DO_INCREMENTAL_BACKUPS is set to true
function deleteOlderBackups(){
  COUNT=1
  for FILENAME in $(ls -1 $BACKUP_DIR | sort -r); do
    if [ $NUMBER_OF_BACKUPS -gt $COUNT ]; then
      rm "$BACKUP_DIR/$FILENAME"
      echo "Removed Backup: $FILENAME"
    fi
    COUNT=$COUNT+1
  done
}

function purgeIncompleteBackups(){
  echo "Purging incomplete backups...."
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
tar cfz$SILENT_TAR $BACKUP_LOCATION $SOURCE_DIR
cat <<- __EOF__


 "Backup Finished!"


__EOF__
