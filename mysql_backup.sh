#!/bin/bash

# crontab -e
# 0 0 * * * /root/bak/dump.sh
cd /root/bak/
top -b -d 60 -n 300 > top.log &
pid=$!
TEMP_PATH=/opt

echo > debug.log
function dump() {
  # ./mysqldump --defaults-extra-file=/root/bak/extra.conf --set-gtid-purged=OFF -A | bzip2 - > /root/bak/mydb_$(date +\%A).bzip2
  cd /root/bak/
  FILE_NAME=db_$1_$(date +\%A)
  # 出现使用extra.conf无法登录，但是换成-u -p可以登录的情况。注意-p和密码之间不能有空格，应该是-ppassword。
  # 另外用户没有锁表权限，可以使用--lock-tables=false。
  ./mysqldump --defaults-extra-file=/root/bak/extra_$1.conf -h $1 --debug-info --lock-tables=false --set-gtid-purged=OFF -B nsp_app -B oauth2_client_cfg -B oauth2_open_cfg -B oauth2admin > $TEMP_PATH/$FILE_NAME.sql 2>>debug.log
  cat debug.log
  # bzip2 is very slow
  # bzip2 -c $TEMP_PATH/mydb.sql > /root/bak/mydb_$(date +\%A).bzip2 2>>debug.log
  cd $TEMP_PATH
  tar -zcvf /root/bak/$FILE_NAME.tar.gz $FILE_NAME.sql
  rm $TEMP_PATH/$FILE_NAME.sql
  echo $1 complete
}

dump 127.0.0.1

kill -9 $pid
