#!/usr/bin/env bash
#
# Bash MySQL Backup Script
#
# @author M Yakub Mizan
# @url http://mymizan.rocks/
# @email ctgcoder@gmail.com
#
#

################################################################################
######      CHANGE MYSQL INFO AND BACKUP_DIR TO YOUR DESIRED ONES      #########
################################################################################

MYSQL_HOST='localhost'
MYSQL_USER='root'
MYSQL_PASS='abcabc'
MYSQL_PORT=3306
BACKUP_DIR="/Users/myakubmizan/CODE/mysql/"     # backup destination
NUMBER_OF_BACKUPS=30 # Total number of daily backups to keep
SILENT_TAR=1 # hide tar output from terminal. If set to 0 tar runs in verbose mode


################################################################################
###### DO NOT CHANGE ANYTHIG BELOW UNLESS YOU KNOW WHAT YOU ARE DOING! #########
################################################################################

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

BACKUP_NAME="mysql_all_databases""_$(getDate).sql"

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
mysqldump -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -P$MYSQL_PORT --all-databases>$BACKUP_LOCATION
tar cfz$SILENT_TAR "$BACKUP_LOCATION"".tar.gz" $BACKUP_LOCATION
rm "$BACKUP_DIR""$BACKUP_NAME"

cat <<- __EOF__


 "Backup Finished!"


__EOF__
