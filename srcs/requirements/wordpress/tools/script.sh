#!/bin/bash

echo "➡️  Stage 1: Downloading WP-CLI..."
curl -O -s https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wordpress
echo "✅ WP-CLI installed."


echo "➡️  Stage 2: Preparing WordPress directory..."
WP_PATH='/var/www/wordpress'
mkdir -p "$WP_PATH"
chown -R www-data:www-data "$WP_PATH"
echo "✅ Directory $WP_PATH ready."

sleep 5

echo "➡️ Waiting for MariaDB to be ready..."
while ! mariadb -h "$DB_HOST" -u "$MARIADB_USER" -p"$MARIADB_PASSWORD" "$MARIADB_DB" -e "SELECT 1;" >/dev/null 2>&1; do
  sleep 2
done
echo "✅ MariaDB is ready."

if [ ! -f "$WP_PATH/wp-load.php" ]; then
    wordpress core download --path="$WP_PATH" --allow-root
else
    echo "✅ WordPress already present, skipping download."
fi

echo "➡️  Stage 3: Setting database configuration..."
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    wordpress config create --allow-root --dbname="$MARIADB_DB" --dbuser="$MARIADB_USER" \
    --dbpass="$MARIADB_PASSWORD" --dbhost="$DB_HOST:$MARIADB_PORT" --path="$WP_PATH"
    echo "✅ Database config set."
else
    echo "✅ wp-config.php already exists, skipping config."
fi

if ! wordpress core is-installed --path="$WP_PATH" --allow-root; then
    echo "➡️ Installing WordPress..."
    wordpress core install --url="$DOMAINE_NAME" --title="$TITLE" \
        --admin_user="$USER_ADMIN" --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_MAIL" --path="$WP_PATH" --allow-root
    echo "✅ WordPress installed."
else
    echo "✅ WordPress already installed, skipping."
fi

if !wp get user "$WP_USER" --field=ID --allow-root &> /dev/null;then
    echo "➡️  Stage 4: Creating additional WordPress user..."
    wordpress user create "$WP_USER" "$WP_USER_MAIL" --role="$ROLE" --user_pass="$USER_PASS" --path="$WP_PATH" --allow-root
    echo "✅ WordPress user $WP_USER created."
else
    echo "user already created."
fi

echo "➡️  Stage 5: Setting correct permissions..."
chown -R www-data:www-data "$WP_PATH"
echo "✅ Permissions applied."


echo "➡️  Stage 6: Configuring PHP-FPM to listen on TCP port 9000..."
sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
echo "✅ PHP-FPM configured."

mkdir -p /run/php

echo "➡️  Stage 7: Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F