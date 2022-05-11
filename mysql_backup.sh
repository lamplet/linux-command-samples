#!/bin/bash

cd /root/bak/
top -b -d 60 -n 300 > top.log &
pid=$!
# mysqldump --defaults-extra-file=/root/bak/extra.conf --set-gtid-purged=OFF -A | bzip2 - > /root/bak/mydb_$(date +\%A).bzip2
mysqldump --defaults-extra-file=/root/bak/extra.conf --debug-info --set-gtid-purged=OFF -A > /opt/temppath/mydb_$(date +\%A).sql 2>debug.log
# try bzip2 because no enough disk space
# but bzip2 is very slow
# bzip2 -c /opt/temppath/mydb.sql > /root/bak/mydb_$(date +\%A).bzip2 2>>debug.log
cd /opt/temppath
tar -zcvf /root/bak/mydb_$(date +\%A).tar.gz mydb_$(date +\%A).sql
rm /opt/temppath/mydb_$(date +\%A).sql
kill -9 $pid
