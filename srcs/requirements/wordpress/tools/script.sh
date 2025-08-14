#!/bin/bash
set -e

echo "➡️  Stage 1: Downloading WP-CLI..."
curl -O -s https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wordpress
echo "✅ WP-CLI installed."

echo "➡️  Stage 2: Configuring PHP-FPM to listen on TCP port 9000..."
sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf
echo "✅ PHP-FPM configured."

echo "➡️  Stage 3: Preparing WordPress directory..."
WP_PATH='/var/www/wordpress'
mkdir -p "$WP_PATH"
chown -R www-data:www-data "$WP_PATH"
echo "✅ Directory $WP_PATH ready."

echo "➡️  Stage 4: Downloading WordPress core..."
wordpress core download --path="$WP_PATH" --allow-root
echo "✅ WordPress downloaded."

# echo "➡️  Stage 5: Preparing wp-config.php..."
# mv "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php"
# echo "✅ wp-config.php created."

echo "➡️  Stage 6: Setting database configuration..."
wordpress config create --allow-root --dbname="$MARIADB_DB" --dbuser="$MARIADB_USER" \
        --dbpass="$MARIADB_PASSWORD" --dbhost="$DB_HOST" --path="$WP_PATH"
echo "✅ Database config set."

echo "➡️  Stage 7: Installing WordPress..."
wordpress core install --url="$DOMAINE_NAME" --title="$TITLE" --admin_user="$USER_ADMIN" \
        --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_MAIL" --path="$WP_PATH" --allow-root
echo "✅ WordPress installed."

echo "➡️  Stage 8: Creating additional WordPress user..."
wordpress user create "$WP_USER" "$WP_USER_MAIL" --role="$ROLE" --user_pass="$USER_PASS" --path="$WP_PATH" --allow-root
echo "✅ WordPress user $WP_USER created."

echo "➡️  Stage 9: Setting correct permissions..."
chown -R www-data:www-data "$WP_PATH"
echo "✅ Permissions applied."

echo "➡️  Stage 10: Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
