#!/bin/bash

#Msql backup script

backup_directory=$1
MYSQL='sudo mysql --skip-column-names'

if [ -z "$backup_directory" ]; then
        echo "The backup_directory parameter is empty."
        exit
fi

if [ -d "$backup_directory" ]; then
        current_dir=$(pwd)
        cd "$backup_directory" || exit

        sudo mysql -e "stop replica" || exit
#        sudo mysql -e "show replica status\G"

        for db in `$MYSQL -e "SHOW DATABASES LIKE '%\_db'"`;
                do
                        echo "database $db"

                        sudo mkdir "$db"
                        cd "$db" || exit

                        for tbl in `$MYSQL -e "show tables from $db"`;
                                do
                                        echo "  table $tbl"
                                        sudo /usr/bin/mysqldump -u root -p --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction \
                                        --quick --set-charset --events --routines --triggers "$db" "$tbl" | gzip -1 > "backup-$db-$tbl".gz
                                done

                        cd ..
                done

        sudo mysql -e "start replica"

        cd "$current_dir" || exit
else
        echo "Error. No such directory."
        exit 2
fi