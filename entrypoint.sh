#!/bin/sh -e
# This script should be run from a dash shell (alpine linux/busybox)

SERVICE_CONF_FILE=${SERVICE_CONF_FILE:-/etc/stunnel/stunnel.d/service.conf}
PSK_FILE=${PSK_FILE:-/etc/stunnel/psk.txt}

# Enable PSK cipher
sed -i 's/!PSK/PSK/' /etc/stunnel/stunnel.conf

write_conf_file () { local filename="$1";
	cat - > "$filename" &&
	chmod 400 "$filename" &&
	echo "Config file $filename written"
}

if [ -n "$SERVICE_CONF_TEXT" ]; then
	echo "$SERVICE_CONF_TEXT" | write_conf_file "$SERVICE_CONF_FILE"
elif [ -n "$SERVICE_CONF_GZBASE64" ]; then
	echo "$SERVICE_CONF_GZBASE64" | base64 -d | zcat | write_conf_file "$SERVICE_CONF_FILE"
else
	echo "No variables for config file $SERVICE_CONF_FILE"
fi

if [ -n "$PSK_TEXT" ]; then
	echo "$PSK_TEXT" | write_conf_file "$PSK_FILE"
elif [ -n "$PSK_GZBASE64" ]; then
	echo "$PSK_GZBASE64" | base64 -d | zcat | write_conf_file "$PSK_FILE"
else
	echo "No variables for config file $PSK_FILE"
fi

# With no parameters, go with stunnel, otherwise exec parameters
if [ -z "$1" ]; then
	exec stunnel /etc/stunnel/stunnel.conf
else
	"$@"
fi
