/usr/sbin/mysqld &
sleep 10
echo "CREATE USER 'root'@'%' IDENTIFIED BY 'PASSWORD'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; CREATE DATABASE app; CREATE USER user@localhost IDENTIFIED BY 'userpass' ; GRANT ALL ON user.* TO user@localhost; FLUSH PRIVILEGES;" | mysql
# echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql