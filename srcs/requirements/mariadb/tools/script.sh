#!/bin/bash


#start the mariadb deamon (database engine), it listen for incoming database queries, manages files, handle users ,etc in (sockets or ports).
service mariadb start

#sleeping to let the service startup to be complete
sleep 5

#printing some stats
echo "mariadb DATABASE: ${MYSQL_DB}"
echo "mariadb USER_NAME: ${MYSQL_USER}"
echo "Starting to create ${MYSQL_DB} database ..."

#"mariadb" is the CLI of the client to interact with the mariadbd. and in this case it lets us execute SQL statement
#directly, the -e option tells the client to run the SQL command directly from the CLI.

# (CREATE DATABASE) -> creates a database | (IF NOT EXISTS) -> prevents an error if the data base exists
mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB"

# (CREATE USER) -> creates a user account in mariadb | (IF NOT EXISTS) -> prevent an error if the user already exists
# in
mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'"
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'%'"
mariadb -e "FLUSH PRIVILEGES"

mysqladmin -u root shutdown

echo "Finished creating \`${MYSQL_DB}\`..."
echo "Starting MariaDB in foreground..."

# Keep MariaDB running in foreground

# sleep 0.5

exec mariadbd --bind-address=0.0.0.0