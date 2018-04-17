#!/bin/bash

CONFIGURED_FILE="/etc/icinga2/CONFIGURED"

# Load helper functions
. /usr/local/bin/helpers

if [ -z ${DB_TYPE+x} ]; then
	NO_IDO=true
else
	db_wait ${DB_HOST} ${DB_PORT}
	db_test_credentials
fi

if [ -f "$CONFIGURED_FILE" ]; then
	echo "=> Icinga2 already configured"
else
	. /usr/local/bin/setup_php
	. /usr/local/bin/setup_icinga2
	. /usr/local/bin/setup_icinga2_features
	if evaluate_boolean "${NO_IDO}"; then
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

if evaluate_boolean "${RECONFIGURE}"; then
	touch $CONFIGURED_FILE
fi

# Tail logs
tail -f -n 500 /var/log/icinga2/startup.log