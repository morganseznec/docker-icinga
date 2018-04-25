#!/bin/bash

CONFIGURED_FILE="/etc/icinga2/CONFIGURED"
PATH_ICINGAWEB2=/etc/icingaweb2
PATH_ICINGA2=/etc/icinga2

DB_TYPE=${DB_TYPE:="mysql"} # or pgsql
DB_ROOT_USER=${DB_ROOT_USER:="root"}
if [ -z ${DB_PORT:+x} ]; then
	if [ "${DB_HOST}" == "mysql" ]; then
		DB_PORT=3306
	else 
		DB_PORT=5432
	fi
fi

# Load helper functions
. /usr/local/bin/helpers

if [ ${DB_HOST:+x} ]; then
	db_wait ${DB_HOST} ${DB_PORT}
	db_test_credentials "${DB_HOST}" "${DB_PORT}" "" "${DB_ROOT_USER}" "${DB_ROOT_PASSWORD}"
fi

if [ -f "$CONFIGURED_FILE" ]; then
	echo "=> Icinga2 already configured"
else
	. /usr/local/bin/setup_php
	. /usr/local/bin/setup_icinga2
	. /usr/local/bin/setup_icinga2_features
	if [ ${DB_HOST:+x} ]; then
		. /usr/local/bin/setup_icingaweb2
		. /usr/local/bin/setup_icingaweb2_modules
	fi
fi

chown -R www-data:icingaweb2 /etc/icingaweb2
mkdir -p /var/log/apache2
chown -R www-data:adm /var/log/apache2
a2ensite 000-default

# Start Icinga2 & Apache2
service apache2 start
service icinga2 start

if evaluate_boolean "${RECONFIGURE:+x}"; then
	touch $CONFIGURED_FILE
fi

# Tail logs
tail -f -n 500 /var/log/icinga2/startup.log