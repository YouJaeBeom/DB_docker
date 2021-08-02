#!/bin/bash

docker-compose -f ./docker-compose.yml up -d

sleep 5

master_log_file=`mysql -h127.0.0.1 --port 33306 -uroot -psamjung -e "show master status\G" | grep mysql-bin`
echo ${master_log_file}

master_log_file=${master_log_file}

master_log_file=${master_log_file//[[:blank:]]/}

master_log_file=${${master_log_file}#File:}

echo ${master_log_file}



master_log_pos=`mysql -h127.0.0.1 --port 33306  -uroot -psamjung -e "show master status\G" | grep Position`
echo ${master_log_pos}

master_log_pos=${master_log_pos}

master_log_pos=${master_log_pos//[[:blank:]]/}

master_log_pos=${${master_log_pos}#Position:}

echo ${master_log_pos}





query="CHANGE MASTER TO MASTER_HOST='nextsj_master', MASTER_USER='nextsj_fixture', MASTER_PASSWORD='samjung', MASTER_LOG_FILE='${master_log_file}', MASTER_LOG_POS=${master_log_pos}"


echo ${query}

mysql --host 127.0.0.1 --port 43306 -uroot -psamjung -e "stop slave"

mysql --host 127.0.0.1 --port 43306 -uroot -psamjung -e "${query}"

mysql --host 127.0.0.1 --port 43306 -uroot -psamjung -e "start slave"
