#!/bin/sh
rts=`mysql -h10.4.4.xx -uroot -pxxx --default-character-set=utf8 -e "SELECT ID FROM INFORMATION_SCHEMA.PROCESSLIST where db = 'xx' and HOST not like '10.4.4.22%' and HOST != 'localhost'"`

date
for rt in $rts; do
    if [[ $rt != 'ID' ]]; then
        mysql -h10.4.4.xx -uroot -pxxx --default-character-set=utf8 -e "kill $rt"
        echo "kill $rt"
    fi
done
