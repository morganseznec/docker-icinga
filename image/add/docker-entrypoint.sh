#!/bin/bash

# Load helper functions
. /usr/local/bin/helpers

# Check that we can connect to a remote mysql server
mysql_wait ${MYSQL_HOST} ${MYSQL_PORT}
mysql_test_credentials

file="CONFIGURED"
if [ -f "$file" ]; then
	echo "=> Icinga2 already configured"
else
	# Setup Icinga2
	. /usr/local/bin/setup_icinga2
	. /usr/local/bin/setup_icingaweb2
	. /usr/local/bin/setup_icinga2_features
	. /usr/local/bin/setup_icingaweb2_modules
fi

# chown -R www-data /etc/icingaweb2/enabledModules
chown -R www-data:icingaweb2 /etc/icingaweb2
mkdir -p /var/log/apache2
chown -R www-data:adm /var/log/apache2
a2ensite 000-default

# Start Icinga2 & Apache2
service apache2 start
service icinga2 start

touch CONFIGURED

# Tail logs
tail -f -n 500 /var/log/icinga2/startup.log