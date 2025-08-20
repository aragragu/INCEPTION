#!/bin/bash

echo "======================================"
echo "[INFO] Starting temporary MariaDB server..."
echo "======================================"
service mariadb start
sleep 5

echo
echo "--------------------------------------"
echo "[INFO] Database configuration details:"
echo "  - Database Name : ${MARIADB_DB}"
echo "  - Username      : ${MARIADB_USER}"
echo "--------------------------------------"
echo

echo "[INFO] Creating database and user..."
mariadb -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DB"
mariadb -e "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD'"
mariadb -e "GRANT ALL PRIVILEGES ON $MARIADB_DB.* TO '$MARIADB_USER'@'%'"

echo "[OK] Database and user setup complete."

echo
echo "[INFO] Shutting down temporary MariaDB..."
mysqladmin -u root shutdown
echo "[OK] Temporary MariaDB stopped."

echo
echo "======================================"
echo "[INFO] Starting MariaDB in foreground..."
echo "======================================"
exec mariadbd --bind-address=0.0.0.0
